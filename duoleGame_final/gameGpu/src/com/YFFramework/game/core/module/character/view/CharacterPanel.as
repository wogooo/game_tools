package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.CharacterPointBasicVo;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.character.model.TitleDyManager;
	import com.YFFramework.game.core.module.character.view.simpleView.AddPoint;
	import com.YFFramework.game.core.module.character.view.simpleView.BodyEquipView;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.MouseDownKeepCall;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-20 下午1:31:53
	 */
	public class CharacterPanel
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		
		private const NUM:int=12;
		private var MendFactor:Number=1.0;	
		
		private var _grids:Vector.<BodyEquipView>;
		
		//人物加点
		private var add1:AddPoint;
		private var add2:AddPoint;
		private var add3:AddPoint;
		private var add4:AddPoint;
		private var add5:AddPoint;
		
		private var _addPointArray:Array;
		
		private var _potential:int;
		
		private var recommand_button:Button;
		private var confirm_button:Button;
		private var titleButton:Button;
		
		private var _myAvatar:SimplePlayer;
		
		private var _leftBtn:SimpleButton;
		private var _rightBtn:SimpleButton;
		
		private var _numSp:Sprite;
		
		private var _stars:Array;
		
//		private var _vipper:Sprite;
		private var _vipBtn:MovieClip;
//		private var _hasChange:Boolean;
		
//		private var _clothBtn:CheckBox;
//		private var _wingBtn:CheckBox;
		private var _isFirst:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function CharacterPanel(mc:MovieClip)
		{
			_mc=mc;
//			_hasChange=false;
			confirm_button = Xdis.getChild(_mc,"confirm_button");
			confirm_button.addEventListener(MouseEvent.CLICK,onConfirm);
			recommand_button = Xdis.getChild(_mc,"recommand_button");
			recommand_button.addEventListener(MouseEvent.CLICK,onRecommand);
			
			_grids=new Vector.<BodyEquipView>(NUM);
			
			for(var i:int=1;i<NUM;i++)
			{
				if(i == 10)
					continue;
				_grids[i]=new BodyEquipView(i,Xdis.getChild(_mc,"et"+i));
				Object(_mc)['mc'+i].addChild(_grids[i]);
			}
			
			_stars=[];
			for(i=0;i<3;i++)
			{
				_stars.push(Xdis.getChild(_mc,'star'+(i+1)));
			}
			
			add1=new AddPoint(Object(_mc).add1,this,NoticeUtils.getStr(NoticeType.Notice_id_100029));
			add2=new AddPoint(Object(_mc).add2,this,NoticeUtils.getStr(NoticeType.Notice_id_100030));
			add3=new AddPoint(Object(_mc).add3,this,NoticeUtils.getStr(NoticeType.Notice_id_100031));
			add4=new AddPoint(Object(_mc).add4,this,NoticeUtils.getStr(NoticeType.Notice_id_100032));
			add5=new AddPoint(Object(_mc).add5,this,NoticeUtils.getStr(NoticeType.Notice_id_100033));
			
			_addPointArray=[add1,add2,add3,add4,add5];
			
			initPotential();
			
			var avatar:Sprite=Xdis.getChild(_mc,"avatar")
			_myAvatar=new SimplePlayer();
			avatar.addChild(_myAvatar);
			avatar.mouseChildren=false;
			avatar.mouseEnabled=false;
			
			_leftBtn=Object(_mc).left_button;
			_rightBtn=Object(_mc).right_button;
			
			_numSp=Xdis.getChild(_mc,"numSp");
			
			TextField(Object(_mc).point).cacheAsBitmap=true;
			
//			_vipper=Xdis.getChild(_mc,"vipper");
//			_clothBtn=Xdis.getChild(_mc,"cloth_checkBox");
//			_wingBtn=Xdis.getChild(_mc,"wing_checkBox");
//			
//			_clothBtn.addEventListener(MouseEvent.CLICK,putOnFashionCloth);
//			_wingBtn.addEventListener(MouseEvent.CLICK,putOnWings);
			
			addEvents();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**更新装备面板文本信息 */ 
		public function updateTextInfo():void
		{
			
//			updateMyVip(_isFirst);
			///职业 
			Object(_mc).t1.text=TypeRole.getCareerName(DataCenter.Instance.roleSelfVo.roleDyVo.career);
			///公会
			updateGuildName();
			//等级
			Object(_mc).t2.text=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			///罪恶  pk值
			updatePKValue();
			//阅历
			Object(_mc).t6.text=CharacterDyManager.Instance.yueli+"";
			//活力
			Object(_mc).t4.text=CharacterDyManager.Instance.energy+"";
			//荣誉
			Object(_mc).rongyuTF.text=CharacterDyManager.Instance.honour+"";
			//战斗力
			playPower();
			//生命
			Object(_mc).t12.text=int(DataCenter.Instance.roleSelfVo.roleDyVo.hp)+"/"+int(CharacterDyManager.Instance.propArr[TypeProps.EA_HEALTH_LIMIT]);
			//魔法
			Object(_mc).t13.text=int(DataCenter.Instance.roleSelfVo.roleDyVo.mp)+"/"+int(CharacterDyManager.Instance.propArr[TypeProps.EA_MANA_LIMIT]);
			///物理攻击
			Object(_mc).t14.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_PHYSIC_ATK]).toString();
			///魔法攻击 
			Object(_mc).t15.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MAGIC_ATK]).toString();
			///物理防御
			Object(_mc).t16.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_PHYSIC_DEFENSE]).toString();
			//魔法防御
			Object(_mc).t17.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MAGIC_DEFENSE]).toString();
			///命中 
			Object(_mc).t31.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_HITRATE]).toString();
			//流血抗性\减速抗性
			Object(_mc).t41.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_BLOODRESIST]).toString()+"%";
			//闪避
			Object(_mc).t32.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MISSRATE]).toString();
			//中毒抗性\定身抗性
			Object(_mc).t42.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_POISONRESIST]).toString()+"%";
			//暴击
			Object(_mc).t33.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_CRITRATE]).toString();
			//晕眩抗性
			Object(_mc).t43.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_SWIMRESIST])+"%";
			//坚韧
			Object(_mc).t34.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_TOUGHRATE]).toString();
			//冰冻抗性\沉默抗性
			Object(_mc).t44.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_FROZENRESIST])+"%";
			//物理减伤 
			Object(_mc).t35.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_PREDUCE])+"%";
			//魔法减伤
			Object(_mc).t45.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MREDUCE])+"%";
			//移动速度 
			CharacterDyManager.Instance.speed=CharacterDyManager.Instance.propArr[TypeProps.EA_MOVESPEED]/UpdateManager.UpdateRate;
			//			print(this,"此处速度加上了0");
			Object(_mc).t51.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MOVESPEED])+"";		
			
		}
		
		public function updateMyVip():void
		{
			//人物名字
			Object(_mc).txtName.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			
			var type:int=DataCenter.Instance.roleSelfVo.roleDyVo.vipType;
			var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel;
			var vipRes:String=TypeRole.getVipResName(type,level);
			if(vipRes != '')
			{
				_vipBtn=ClassInstance.getInstance(vipRes);
				_mc.addChild(_vipBtn);
				var nameTXT:TextField=_mc.txtName;
//				trace("角色名    ："+nameTXT.text);
				_vipBtn.x=nameTXT.x+nameTXT.width/2+nameTXT.textWidth/2+2;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.vipType == TypeRole.VIP_TYPE_YEAR && 
					DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel == 8)
					_vipBtn.y=nameTXT.y-4;
				else
					_vipBtn.y=nameTXT.y;
				_vipBtn.buttonMode=true;
				_vipBtn.addEventListener(MouseEvent.CLICK,onVipClick);
			}		
		}
		
		public function updateGuildName():void
		{
			Object(_mc).t3.text=CharacterDyManager.Instance.unionName;
		}
		
		public function updatePoint():void
		{
			clearPoint();
			initPotential();			
		}
		
		public function updatePKValue():void
		{
			///罪恶  pk值
			Object(_mc).t5.text=CharacterDyManager.Instance.pkValue+"";
		}
		
		/**装备改变
		 */
//		public function updateEquipChange():void
//		{
//			_hasChange=true;
//		}
		
		public function updateAllEquips():void
		{
//			if(_hasChange)
//			{
				var arr:Array=CharacterDyManager.Instance.getNewEquips();
				for each(var equipDyVo:EquipDyVo in arr)
				{
					_grids[equipDyVo.position].disposeContent();
					if(equipDyVo.type != 0)
					{
						_grids[equipDyVo.position].setContent(equipDyVo);
					}
				}
				if(_mc.stage)
				{
					updateAvatar();
				}
//				_hasChange=false;
//			}
		}
		
		public function delGrid(pos:int):void
		{
			_grids[pos].disposeContent();
		}
		
		public function updateAvatar():void
		{
			var sex:int=DataCenter.Instance.roleSelfVo.roleDyVo.sex;
			var carrer:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
			var cloth:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_CLOTHES);
			var wings:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);
			var weapon:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WEAPON);
			var clothId:int=DataCenter.Instance.roleSelfVo.roleDyVo.clothBasicId;//CharacterDyManager.Instance.getClothBasicId();
			var clothEnhancelLel:int=-1;
			if(cloth)clothEnhancelLel=cloth.enhance_level;
			if(clothId>0)
			{
				//				_myAvatar.updateClothId(cloth.template_id,sex,carrer,cloth.enhance_level);
				_myAvatar.updateClothId(clothId,sex,carrer,clothEnhancelLel);
			}
			else
				_myAvatar.initDefaultCloth(sex,carrer);
			if(wings)
				_myAvatar.updateWingId(wings.template_id,sex);
			else _myAvatar.updateWingId(-1,0);
			if(weapon)
			{
				_myAvatar.updateWeaponId(weapon.template_id,sex,carrer,weapon.enhance_level);
			}
			else _myAvatar.updateWeaponId(-1,0,carrer,-1);
			
			_myAvatar.start();
		}
		
		public function getPotential():int{
			return _potential;
		}
		
		public function changePotential(p:int):void{
			_potential += p;
			Object(_mc).point.text=NoticeUtils.getStr(NoticeType.Notice_id_100034)+_potential.toString();
		}
		
		/**
		 * 初始化潜力值 
		 */		
		public function initPotential():void
		{
			_potential = CharacterDyManager.Instance.potential;
			Object(_mc).point.text=NoticeUtils.getStr(NoticeType.Notice_id_100034)+_potential.toString();
			
			if(_potential > 0)
			{
				recommand_button.visible=true;
				confirm_button.visible=true;
				for each(var btn:AddPoint in _addPointArray)
				{
					btn.visibleBtn();
				}
			}
			else
			{
				recommand_button.visible=false;
				confirm_button.visible=false;
				for each(btn in _addPointArray)
				{
					btn.visibleBtn(false);
				}
			}
			
			///体质/耐力
			add1.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_PHYSIQUE]);
			///力量
			add2.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_STRENGTH]);
			///敏捷
			add3.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_AGILE]);
			///智力
			add4.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]);
			///精神
			add5.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_SPIRIT]);
			
		}
		
		private function playPower():void
		{
			var num:AbsView=ImageTextManager.Instance.createNum(CharacterDyManager.Instance.power.toString(),TypeImageText.Num_power);
			UI.removeAllChilds(_numSp);
			_numSp.addChild(num);
		}
		
		private function clearPoint():void
		{
			for(var i:int=0;i<_addPointArray.length;i++){
				_addPointArray[i].clearContent();
			}
		}
		
		public function updateTitle():void
		{
			var titleId:int=TitleDyManager.instance.curTitleId;
			if(titleId > 0)
				Object(_mc).t11.text=TitleBasicManager.Instance.getTitleBasicVo(titleId).name;
			else
				Object(_mc).t11.text='';
		}
		
		public function stopAvatar():void
		{
			_myAvatar.stop();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onLeft(e:MouseEvent=null):void
		{
			_myAvatar.turnLeft();
		}
		
		private function onRight(e:MouseEvent=null):void
		{
			_myAvatar.turnRight();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			var fromDragVo:DragData = DragManager.Instance.dragVo as DragData;
			if(fromDragVo)
			{
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox)
				{
					if(toBox is BodyEquipView)
					{
						var box:BodyEquipView=toBox as BodyEquipView;
						if(box.hasDoubleClick == true)
							putToBody(fromDragVo,toBox);
						else
						{
							if(box.info || box.info == null)
								putToBody(fromDragVo,toBox);
						}
					}
				}	
				
			}
			
		}
		
		
		private function putToBody(fromData:DragData,toBox:IMoveGrid):void
		{	
			if(fromData.type == DragData.FROM_BAG && fromData.data.type == TypeProps.ITEM_TYPE_EQUIP)//从背包里
			{
				var toGrid:BodyEquipView=toBox as BodyEquipView;
				var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
				
				var templateId:int=EquipDyManager.instance.getEquipInfo(fromData.data.id).template_id;//拖动的装备
				var type:int=EquipBasicManager.Instance.getEquipBasicVo(templateId).type;//就是在身上的部位
				
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).level > level)//拖动的装备等级>人的等级
				{
					NoticeManager.setNotice(NoticeType.Notice_id_307);
					return;
				}
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != DataCenter.Instance.roleSelfVo.roleDyVo.sex
					&& EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != TypeProps.GENDER_NONE)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_308);
					return;
				}
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).career != DataCenter.Instance.roleSelfVo.roleDyVo.career)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1700);
					return;
				}
				if(toGrid.boxKey != type)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1701);
					return;
				}
				ModuleManager.moduleCharacter.putOnEquipReq(fromData.fromID,toGrid.boxKey);
			}
			
		}
		
		public function onFixEquip(e:MouseEvent):void
		{
			if(BagSource.shopMend)
			{
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox && toBox is BodyEquipView)
				{
					var grid:BodyEquipView=toBox as BodyEquipView;
					if(grid.info)
					{
						var curDurability:int=EquipDyManager.instance.getEquipInfo(grid.info.equip_id).cur_durability;
						var tmpId:int=grid.info.template_id;
						var equip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(tmpId);
						var allDurability:int=EquipBasicManager.Instance.getEquipBasicVo(equip.template_id).durability;
						if(curDurability < allDurability)
						{
							var needMoney:int=DataCenter.Instance.roleSelfVo.note;
							var consumeMoney:int=equip.level*(allDurability-curDurability)*MendFactor;
							if(needMoney > consumeMoney)
							{
								YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_CRepairEquipReq,grid.boxKey);
							}
							else
							{
								NoticeManager.setNotice(NoticeType.Notice_id_1703);
							}
						}
						else
						{
							NoticeManager.setNotice(NoticeType.Notice_id_331);
						}
					}
					
				}
			}
		}
		
		/** 检查人物身上的套装强化等级是否全部等于5,9,12
		 */		
		public function equipStrengthChange():void
		{
			updateAvatar();
			var num:int=EquipDyManager.instance.getTotalStrengthenAddition(CharacterDyManager.Instance.getEquipDict().values());
			for(var i:int=0;i<3;i++)//先把三颗星星灭掉
			{
				MovieClip(_stars[i]).visible=false;
			}
			for(i=0;i<num;i++)//再把星星依次亮起
			{
				MovieClip(_stars[i]).visible=true;
			}
			
		}
		
		protected function rollOverHandler(e:MouseEvent):void
		{
			if(BagSource.shopMend)
			{
				MouseManager.changeMouse(MouseStyle.FIX);
			}	
			
		}
		protected function rollOutHandler(e:MouseEvent):void
		{
			MouseManager.resetToDefaultMouse();	
		}
		
		private function onRecommand(e:MouseEvent):void
		{
			clearPoint();
			initPotential();
			
			if(_potential>=5)
			{
				var mul:int = int(_potential/5);
				var carrer:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
				var point:CharacterPointBasicVo=CharacterPointBasicManager.Instance.getCharacterConfigBasicVo(carrer);
				
				add1.changePoint(mul*point.phy_add);
				add2.changePoint(mul*point.str_add);
				add3.changePoint(mul*point.agi_add);
				add4.changePoint(mul*point.int_add);
				add5.changePoint(mul*point.spi_add);
				
			}
			
			///推荐
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorGuideTuiJian)
			{
				NewGuideStep.CharactorGuideStep=NewGuideStep.CharactorGuideQueDing;
				NewGuideManager.DoGuide();
			}			
		}
		
		private function onConfirm(e:MouseEvent):void
		{
			ModuleManager.moduleCharacter.addPoint(add1.curPoint,add2.curPoint,add3.curPoint,add4.curPoint,add5.curPoint);
			
			
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorGuideQueDing)
			{
				NewGuideStep.CharactorGuideStep=NewGuideStep.CharactorCloseWindow;
				NewGuideManager.DoGuide();
			}
		}
		
		/**卸下 人物身上所有装备
		 */		
		public function removeAllEquip():void
		{
			for each(var equipView:BodyEquipView in _grids)
			{
				if(equipView)	
					equipView.onMouseDoubleClick();
			}
			
		}
		
		//======================================================================
		//        private function
		//======================================================================
		protected function addEvents():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			new MouseDownKeepCall(_leftBtn,onLeft,8);
			new MouseDownKeepCall(_rightBtn,onRight,8);
			//修理装备
			_mc.addEventListener(MouseEvent.CLICK,onFixEquip);
			_mc.addEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
		}
		
		protected function removeEvents():void
		{
			_mc.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_leftBtn.removeEventListener(MouseEvent.CLICK,onLeft);
			_rightBtn.removeEventListener(MouseEvent.CLICK,onRight);
		}
		
		private function onVipClick(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
		/** 引导推荐 推荐引导
		 */
		public function handleGuideTuiJian():Boolean
		{
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorGuideTuiJian)
			{
//				var pt:Point=UIPositionUtil.getPosition(recommand_button,LayerManager.UIViewRoot); //获取
//				var rect:Rectangle=new Rectangle(pt.x,pt.y,recommand_button.width,recommand_button.height);
//				NewGuideMovieClipWidthArrow.Instance.initRect(rect.x,rect.y,rect.width,rect.height,NewGuideMovieClipWidthArrow.ArrowDirection_Right);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(LayerManager.NewGuideLayer);
				var pt:Point=UIPositionUtil.getUIRootPosition(recommand_button); //获取
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,recommand_button.width,recommand_button.height,NewGuideMovieClipWidthArrow.ArrowDirection_Right,recommand_button);
				return true;
			}
			return false;
		}
		
		/** 引导确定  确定引导
		 */
		public function handleGuideQueDing():Boolean
		{
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorGuideQueDing)
			{
//				var pt:Point=UIPositionUtil.getPosition(confirm_button,LayerManager.UIViewRoot); //获取
//				var rect:Rectangle=new Rectangle(pt.x,pt.y,confirm_button.width,confirm_button.height);
//				NewGuideMovieClipWidthArrow.Instance.initRect(rect.x,rect.y,rect.width,rect.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(LayerManager.NewGuideLayer);
				var pt:Point=UIPositionUtil.getUIRootPosition(confirm_button); //获取
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,confirm_button.width,confirm_button.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,confirm_button);
				return true;
			}
			return false;
		}

		
		
	}
} 