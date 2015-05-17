package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.CharacterPointBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.skill.window.DragData;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.common.AttrInfo;
	import com.msg.hero.CAddHeroPoint;
	import com.msg.storage.CPutToBodyReq;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**人物面板
	 * @author yefeng
	 *2012-8-21下午9:55:37
	 */
	
	public class CharacterWindow extends Window
	{
		private const NUM:int=12;
		
		private var _mc:MovieClip;
		
		private var _grids:Vector.<BodyEquipView>;
		
		private var _armetBox:BodyEquipView;
		private var _clothBox:BodyEquipView;
		private var _gloveBox:BodyEquipView;
		private var _weaponBox:BodyEquipView;
		private var _necklaceBox:BodyEquipView;
		private var _ringBox:BodyEquipView;
		private var _shoesBox:BodyEquipView;
		private var _assistantBox:BodyEquipView;
		private var _fashionArmetBox:BodyEquipView;
		private var _wingBox:BodyEquipView;
		private var _fashionClothBox:BodyEquipView;
		
		//人物加点
		private var add1:AddPoint;
		private var add2:AddPoint;
		private var add3:AddPoint;
		private var add4:AddPoint;
		private var add5:AddPoint;
		
		private var addPointArray:Array;
		
		private var _potential:int;
		
		private var recommand_button:Button;
		private var confirm_button:Button;
		
		private var myRole:SimplePlayer;
		
		private var leftBtn:SimpleButton;
		private var rightBtn:SimpleButton;
		
		public function CharacterWindow()
		{
			initUI();
		}
		protected function initUI():void
		{
			setSize(535,515);
			_mc=ClassInstance.getInstance("newProperty") ;
			content=_mc;
			this.title="人物属性";
			AutoBuild.replaceAll(_mc);
			
			confirm_button = Xdis.getChild(_mc,"confirm_button");
			confirm_button.addEventListener(MouseEvent.CLICK,onConfirm);
			recommand_button = Xdis.getChild(_mc,"recommand_button");
			recommand_button.addEventListener(MouseEvent.CLICK,onRecommand);
			
			var _equipNames:Sprite=ClassInstance.getInstance("equipName");
			_equipNames.mouseEnabled=false;
			_equipNames.x=40;
			_equipNames.y=160;
			addChild(_equipNames);
			
			_grids=new Vector.<BodyEquipView>(NUM);
			
			_armetBox=new BodyEquipView(TypeProps.EQUIP_TYPE_HELMET);
			_grids[TypeProps.EQUIP_TYPE_HELMET]=_armetBox;
			_mc.mc1.addChild(_armetBox);
			
			_clothBox=new BodyEquipView(TypeProps.EQUIP_TYPE_CLOTHES);
			_grids[TypeProps.EQUIP_TYPE_CLOTHES]=_clothBox;
			_mc.mc2.addChild(_clothBox);
			
			_gloveBox=new BodyEquipView(TypeProps.EQUIP_TYPE_WRIST);
			_grids[TypeProps.EQUIP_TYPE_WRIST]=_gloveBox;
			_mc.mc3.addChild(_gloveBox);
			
			_weaponBox=new BodyEquipView(TypeProps.EQUIP_TYPE_WEAPON);
			_grids[TypeProps.EQUIP_TYPE_WEAPON]=_weaponBox;
			_mc.mc9.addChild(_weaponBox);
			
			_necklaceBox=new BodyEquipView(TypeProps.EQUIP_TYPE_NECKLACE);
			_grids[TypeProps.EQUIP_TYPE_NECKLACE]=_necklaceBox;
			_mc.mc4.addChild(_necklaceBox);
			
			_ringBox=new BodyEquipView(TypeProps.EQUIP_TYPE_RING);
			_grids[TypeProps.EQUIP_TYPE_RING]=_ringBox;
			_mc.mc5.addChild(_ringBox);
			
			_shoesBox=new BodyEquipView(TypeProps.EQUIP_TYPE_SHOES);
			_grids[TypeProps.EQUIP_TYPE_SHOES]=_shoesBox;
			_mc.mc6.addChild(_shoesBox);
			
			_assistantBox=new BodyEquipView(TypeProps.EQUIP_TYPE_SHIELD);
			_grids[TypeProps.EQUIP_TYPE_SHIELD]=_assistantBox;
			_mc.mc10.addChild(_assistantBox);
			
			_fashionArmetBox=new BodyEquipView(TypeProps.EQUIP_TYPE_FASHION_HEAD);
			_grids[TypeProps.EQUIP_TYPE_FASHION_HEAD]=_fashionArmetBox;
			_mc.mc7.addChild(_fashionArmetBox);
			
			_wingBox=new BodyEquipView(TypeProps.EQUIP_TYPE_WINGS);
			_grids[TypeProps.EQUIP_TYPE_WINGS]=_wingBox;
			_mc.mc11.addChild(_wingBox);
			
			_fashionClothBox=new BodyEquipView(TypeProps.EQUIP_TYPE_FASHION_BODY);
			_grids[TypeProps.EQUIP_TYPE_FASHION_BODY]=_fashionClothBox;
			_mc.mc8.addChild(_fashionClothBox);
			
			initPotential();
			
			add1=new AddPoint(_mc.add1,this,"体质");
			add2=new AddPoint(_mc.add2,this,"智力");
			add3=new AddPoint(_mc.add3,this,"精神");
			add4=new AddPoint(_mc.add4,this,"敏捷");
			add5=new AddPoint(_mc.add5,this,"力量");
			
			addPointArray=[add1,add2,add3,add4,add5];
			
			myRole=new SimplePlayer();
			addChild(myRole);
			myRole.x=160;
			myRole.y=290;
			myRole.mouseEnabled=false;
			
			leftBtn=_mc.left_button;
			rightBtn=_mc.right_button;
			
			addEvents();
		}
		
		protected function addEvents():void
		{
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			leftBtn.addEventListener(MouseEvent.CLICK,onLeft);
			rightBtn.addEventListener(MouseEvent.CLICK,onRight);
		}
		
		protected function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			leftBtn.removeEventListener(MouseEvent.CLICK,onLeft);
			rightBtn.removeEventListener(MouseEvent.CLICK,onRight);
		}
		/**更新装备面板文本信息
		 */ 
		public function updateTextInfo():void
		{
			///职业 
			_mc.t1.text=TypeRole.getCareerName(DataCenter.Instance.roleSelfVo.roleDyVo.career);
			///公会
			_mc.t3.text=CharacterDyManager.Instance.unionName;
			//等级
			_mc.t2.text=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			//称号 
			_mc.t11.text=CharacterDyManager.Instance.title+"";
			///罪恶  pk值
			_mc.t5.text=CharacterDyManager.Instance.pkValue+"";
			//阅历
			_mc.t6.text=CharacterDyManager.Instance.yueli+"";
			//活力
			_mc.t4.text=CharacterDyManager.Instance.energy+"";
			//荣誉
			_mc.rongyuTF.text=CharacterDyManager.Instance.honour+"";
			//战斗力
			_mc.t52.text=CharacterDyManager.Instance.power+"";
			//生命
			_mc.t12.text=int(DataCenter.Instance.roleSelfVo.roleDyVo.hp)+"/"+int(CharacterDyManager.Instance.propArr[TypeProps.EA_HEALTH_LIMIT]);
			//魔法
			_mc.t13.text=int(DataCenter.Instance.roleSelfVo.roleDyVo.mp)+"/"+int(CharacterDyManager.Instance.propArr[TypeProps.EA_MANA_LIMIT]);
			///物理攻击
			_mc.t14.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_PHYSIC_ATK]).toString()+"";
			///魔法攻击 
			_mc.t15.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MAGIC_ATK]).toString()+"";
			///物理防御
			_mc.t16.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_PHYSIC_DEFENSE]).toString()+"";
			//魔法防御
			_mc.t17.text=int(CharacterDyManager.Instance.propArr[TypeProps.EA_MAGIC_DEFENSE]).toString()+"";
			///命中 
			_mc.t31.text=CharacterDyManager.Instance.propArr[TypeProps.EA_HITRATE]+"";
			//流血抗性
			_mc.t41.text=CharacterDyManager.Instance.propArr[TypeProps.EA_BLOODRESIST]+"%";
			//闪避
			_mc.t32.text=CharacterDyManager.Instance.propArr[TypeProps.EA_MISSRATE]+"";
			//中毒抗性
			_mc.t42.text=CharacterDyManager.Instance.propArr[TypeProps.EA_POISONRESIST]+"";
			//暴击
			_mc.t33.text=CharacterDyManager.Instance.propArr[TypeProps.EA_CRITRATE]+"";
			//晕眩抗性
			_mc.t43.text=CharacterDyManager.Instance.propArr[TypeProps.EA_SWIMRESIST]+"";
			//坚韧
			_mc.t34.text=CharacterDyManager.Instance.propArr[TypeProps.EA_TOUGHRATE]+"";
			//冰冻抗性
			_mc.t44.text=CharacterDyManager.Instance.propArr[TypeProps.EA_FROZENRESIST]+"";
			//物理减伤 
			_mc.t35.text=CharacterDyManager.Instance.propArr[TypeProps.EA_PREDUCE]+"";
			//魔法减伤
			_mc.t45.text=CharacterDyManager.Instance.propArr[TypeProps.EA_MREDUCE]+"";
			//移动速度 
			DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=CharacterDyManager.Instance.propArr[TypeProps.EA_MOVESPEED]/UpdateManager.UpdateRate+2;
			print(this,"此处速度加上了2");
			_mc.t51.text=CharacterDyManager.Instance.propArr[TypeProps.EA_MOVESPEED]+"";
			///名称
			_mc.txtName.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName+"("+TypeRole.getSexName(DataCenter.Instance.roleSelfVo.roleDyVo.sex)+")";
			
			updatePoint();
			
		}
		
		public function updatePoint():void
		{
			clearPoint();
			initPotential();
			///体质 
			add1.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_PHYSIQUE]);
			/// 智力 
			add2.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_INTELLIGENCE]);
			///精神
			add3.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_SPIRIT]);
			///敏捷
			add4.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_AGILE]);
			///力量
			add5.setLabelNum(CharacterDyManager.Instance.propArr[TypeProps.BA_STRENGTH]);
			
		}
		
		public function updateAllEquips():void
		{
			var arr:Array=CharacterDyManager.Instance.getNewEquips();

			for each(var equipDyVo:EquipDyVo in arr)
			{
				_grids[equipDyVo.position].disposeContent();
				if(equipDyVo.type != 0)
				{
					_grids[equipDyVo.position].setContent(equipDyVo);
				}
			}
			
			var sex:int=DataCenter.Instance.roleSelfVo.roleDyVo.sex;
			var carrer:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
			var cloth:EquipDyVo=CharacterDyManager.Instance.getEquipInfo(TypeProps.EQUIP_TYPE_CLOTHES);
			var wings:EquipDyVo=CharacterDyManager.Instance.getEquipInfo(TypeProps.EQUIP_TYPE_WINGS);
			var weapon:EquipDyVo=CharacterDyManager.Instance.getEquipInfo(TypeProps.EQUIP_TYPE_WEAPON);
			if(cloth)
			{
				myRole.updateClothId(cloth.template_id,sex);
			}
			else
			{
				myRole.initDefaultCloth(sex,carrer);
			}
			if(wings)
			{
				myRole.updateWingId(wings.template_id,sex);
			}
			if(weapon)
			{
				myRole.updateWeaponId(weapon.template_id,sex);
			}
			playRoleAction();
		}
		
		public function playRoleAction():void
		{
			myRole.start();
			myRole.playDefault();
		}
		
		public function stopRoleAction():void
		{
			myRole.stop();
		}
		
		public function getPotential():int{
			return _potential;
		}
		
		public function changePotential(p:int):void{
			_potential += p;
			_mc.point.text="潜力："+_potential.toString();
		}
		
		/**
		 * 初始化潜力值 
		 * 
		 */		
		public function initPotential():void
		{
			_potential = CharacterDyManager.Instance.potential;
			_mc.point.text="潜力："+_potential.toString();
			
			if(_potential > 0)
				recommand_button.enabled=true;
			else
				recommand_button.enabled=false;
		}
		
		public function clearPoint():void
		{
			for(var i:int=0;i<addPointArray.length;i++){
				addPointArray[i].clearContent();
			}
		}
		
		public function equipResp(rsp:int):void
		{
			switch(rsp)
			{
				case TypeProps.RSPMSG_UN_EQUIP:
					NoticeUtil.setOperatorNotice("不可装备！");
					break;
				case TypeProps.RSPMSG_POS_ERROR:
					NoticeUtil.setOperatorNotice("源位置或目标位置错误");
					break;
				case TypeProps.RSPMSG_EQUIP_POS_UNFIT:
					NoticeUtil.setOperatorNotice("装备位置不匹配");
					break;
				case TypeProps.RSPMSG_EQUIP_RANK_UNFIT:
					NoticeUtil.setOperatorNotice("装备等级不匹配");
					break;
				case TypeProps.RSPMSG_EQUIP_GENDER_UNFIT:
					NoticeUtil.setOperatorNotice("装备性别不匹配");
					break;
				case TypeProps.RSPMSG_EQUIP_CAREER_UNFIT:
					NoticeUtil.setOperatorNotice("装备职业不匹配");
					break;
			}
		}
		////////////////////////////////////////////////////////////////
		
		private function onLeft(e:MouseEvent):void
		{
			myRole.turnLeft();
		}
		
		private function onRight(e:MouseEvent):void
		{
			myRole.turnRight();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if(DragManager.Instance.dragVo )
			{
				var toBox:IMoveGrid = ZHitTester.checkIMoveGrid(IMoveGrid);
				if(toBox)
				{
					if(toBox is BodyEquipView)
					{
						var box:BodyEquipView=toBox as BodyEquipView;
						if(box.hasDoubleClick == true)
							putToBody(DragManager.Instance.dragVo as DragData,toBox);
						else
						{
							if(box.info || box.info == null)
								putToBody(DragManager.Instance.dragVo as DragData,toBox);
						}
					}
				}
				
			}
			
		}

		
		private function putToBody(fromData:DragData,toBox:IMoveGrid):void
		{
			var toGrid:BodyEquipView=toBox as BodyEquipView;
			var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			
			var templateId:int=EquipDyManager.instance.getEquipInfo(fromData.data.id).template_id;//拖动的装备
			var type:int=EquipBasicManager.Instance.getEquipBasicVo(templateId).type;//就是在身上的部位
			
			if(EquipBasicManager.Instance.getEquipBasicVo(templateId).level > level)//拖动的装备等级>人的等级
			{
				NoticeUtil.setOperatorNotice("人物等级低，不能装备！");
				return;
			}
			if(EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != DataCenter.Instance.roleSelfVo.roleDyVo.sex
				&& EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != TypeProps.GENDER_NONE)
			{
				NoticeUtil.setOperatorNotice("人物性别不对，不能装备！");
				return;
			}
			if(EquipBasicManager.Instance.getEquipBasicVo(templateId).career != DataCenter.Instance.roleSelfVo.roleDyVo.career)
			{
				NoticeUtil.setOperatorNotice("人物职业不对，不能装备！");
				return;
			}
			if(toGrid.boxKey != type)
			{
				NoticeUtil.setOperatorNotice("装备部位不对，不能装备！");
				return;
			}
			var bodyMsg:CPutToBodyReq=new CPutToBodyReq();
			bodyMsg.sourcePos=fromData.fromID;
			bodyMsg.targetPos=toGrid.boxKey;
			YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_PutOnEquip,bodyMsg);
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
				add2.changePoint(mul*point.int_add);
				add3.changePoint(mul*point.spi_add);
				add4.changePoint(mul*point.agi_add);
				add5.changePoint(mul*point.str_add);
				
			}
		}
		
		private function onConfirm(e:MouseEvent):void
		{
			var msg:CAddHeroPoint = new CAddHeroPoint();
			msg.addAttrArr=[];
			
			if(add1.curPoint > 0)
			{
				var attr:AttrInfo = new AttrInfo();
				attr.attrId = TypeProps.BASIC_PHY;
				attr.attrValue = add1.curPoint;
				msg.addAttrArr.push(attr);
			}
			if(add2.curPoint > 0)
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BASIC_INT;
				attr.attrValue = add2.curPoint;
				msg.addAttrArr.push(attr);
			}
			if(add3.curPoint > 0)
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BASIC_SPI;
				attr.attrValue = add3.curPoint;
				msg.addAttrArr.push(attr);
			}
			if(add4.curPoint > 0)
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BASIC_AGI;
				attr.attrValue = add4.curPoint;
				msg.addAttrArr.push(attr);
			}
			if(add5.curPoint > 0)
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BASIC_STR;
				attr.attrValue = add5.curPoint;
				msg.addAttrArr.push(attr);
			}
			YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_AddPointReq,msg);
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
		
		
	}
}