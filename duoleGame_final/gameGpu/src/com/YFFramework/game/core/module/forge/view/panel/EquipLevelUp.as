package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.EquipLevelUpBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipLevelupBasicVo;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.core.module.wing.view.WingLvUpEffMgr;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-9-6 下午3:21:52
	 */
	public class EquipLevelUp
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const COLOR_DARK_YELLOW:String='D6CC91';//暗黄色
		private const COLOR_BLUE:String='009cff';//蓝色
		
		private var _bagEquipList:TileList;//背包
		private var _CharacterEquipList:TileList;//身上
		
		private var _tabs:TabsManager;
		
		private var _beforeEquipIcon:IconImage;
		private var _afterEquipIcon:IconImage;
		private var _meterialIcon:IconImage;
		
		private var _curEquipTxt:TextField;
		private var _afterEquipTxt:TextField;
		private var _propsNum:TextField;
		private var _moneyTxt:TextField;
		
		private var _levelUpBtn:Button;
		/** 记录当前选中的装备   不为null则表示选择 了 物品   准备进行锻造  为 null则表示 锻造装备被清空了*/		
		private var _beforeDyVo:EquipDyVo;
		private var _beforeLevelUpVo:EquipLevelupBasicVo;
		/** 进阶后的装备 */		
		private var _afterBsVo:EquipBasicVo;
		
		private var _update:Boolean;
		/** 播放特效true->播放特效 */
		private var _playEff:Boolean=false;
		
		
		/**值在  NewGuideStep里面
		 *新手引导步骤
		 */
//		private var _newGuideStep:int=NewGuideStep.EquipLevelUp_ToClickEquip;
//		
//		/**新手引导
//		 */
//		private var _newGuideMovieClip:NewGuideMovieClipWidthArrow;
		
		/**新手引导容器
		 */
		private var _newGuideContainer:AbsView;
		
		/**装备是否已经放入进去
		 */
		private var _newGuideEquipFill:Boolean=false;
		
		/**该 面板根容器 */
		private var _targetUI:Sprite;
		//======================================================================
		//        constructor
		//======================================================================	
		public function EquipLevelUp(targetUI:Sprite,newGuideContainer:AbsView)
		{
			_targetUI=targetUI;
			_newGuideContainer=newGuideContainer;
			
			_bagEquipList = Xdis.getChild(targetUI,"equipView2","equipsBox_tileList");
			_bagEquipList.itemRender = EquipItemRender;
			_bagEquipList.setSelfDeselect(true);
			_bagEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_CharacterEquipList = Xdis.getChild(targetUI,"equipView1","equipsBox_tileList");
			_CharacterEquipList.itemRender = EquipItemRender;
			_CharacterEquipList.setSelfDeselect(true);
			_CharacterEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_beforeEquipIcon = Xdis.getChild(targetUI,"equip_iconImage");
			_afterEquipIcon = Xdis.getChild(targetUI,"afterEquip_iconImage");
			_meterialIcon = Xdis.getChild(targetUI,'material_iconImage');
			
			_curEquipTxt = Xdis.getChild(targetUI,'cur_txt');
			_afterEquipTxt = Xdis.getChild(targetUI,'after_txt');
			_moneyTxt = Xdis.getChild(targetUI,'money');
			_moneyTxt.text='';
			_propsNum = Xdis.getChild(targetUI,'propsNum');
			
			_levelUpBtn = Xdis.getChild(targetUI,'levelUp_button');
			_levelUpBtn.addEventListener(MouseEvent.CLICK,onLevelUp);
			_levelUpBtn.enabled=false;
			
			_tabs=new TabsManager();
			_tabs.initTabs(targetUI,"tabsEquip_sp",2,"equipView");
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
			
		}
		
		//进阶后把装备list刷新一遍，因为改变了装备图标
		//还要改变背包对应的图标

		//======================================================================
		//        public function
		//======================================================================
		public function initPanel(fresh:Boolean):void
		{
			_update=fresh;
			if(_update)
			{
				updateAllList();
			}
			WingLvUpEffMgr.Instence.loadEff();
		}
		
		public function resetPanel():void
		{
			clearLeftPanel();
			
			_tabs.switchToTab(1);
			
			_bagEquipList.clearAllSelection();
			_CharacterEquipList.clearAllSelection();
			
			_update=false;
		}
		
		public function updateAllList(event:YFEvent=null):void
		{	
			if(update == false) return;
			if(_playEff) return;//播放特效时，不执行下面的语句
			
			updateBagList();
			updateCharacterEquipList();
			
			if(_beforeDyVo == null)  return;
			var beforeBsVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_beforeDyVo.template_id);
			if(EquipLevelUpBasicManager.Instance.getEquipLevelupBasicVo(beforeBsVo.level))
			{
				var index:int=_CharacterEquipList.findDataIndex(_beforeDyVo,"vo");
				if(index > -1)
				{
					_CharacterEquipList.selectedIndex=index;
					_CharacterEquipList.scrollToIndex(index);
				}
				else
				{
					index =_bagEquipList.findDataIndex(_beforeDyVo,"vo");
					if(index  > -1)
					{
						_bagEquipList.selectedIndex=index;
						_bagEquipList.scrollToIndex(index);
					}
					else
					{
						clearLeftPanel();
					}
				}
			}
			else
				clearLeftPanel();
			checkLevelUpAbleClick();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function clearLeftPanel():void
		{
			_beforeDyVo=null;
			
			_beforeEquipIcon.clear();
			Xtip.clearLinkTip(_beforeEquipIcon);
			
			_afterBsVo=null;
			_afterEquipIcon.clear();
			Xtip.clearLinkTip(_afterEquipIcon);
			
			_meterialIcon.clear();
			Xtip.clearLinkTip(_meterialIcon);
			
			_beforeLevelUpVo=null;
			
			_moneyTxt.text ='';
			_curEquipTxt.text='';
			_afterEquipTxt.text = '';
			_propsNum.text = '0';
		}
		
		/** 身上或背包list选中的装备，显示在左侧的信息  */
		private function putMainEquipOn():void
		{	
			var beforeBsVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_beforeDyVo.template_id);		
			_beforeEquipIcon.url = EquipBasicManager.Instance.getURL(beforeBsVo.template_id);
			
			if(EquipDyManager.instance.getEquipPosFromRole(_beforeDyVo.equip_id) > 0)
				Xtip.registerLinkTip(_beforeEquipIcon,EquipTip,TipUtil.equipTipInitFunc,_beforeDyVo.equip_id,_beforeDyVo.template_id,true);
			else
				Xtip.registerLinkTip(_beforeEquipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_beforeDyVo.equip_id,_beforeDyVo.template_id);
			
			_beforeLevelUpVo=EquipLevelUpBasicManager.Instance.getEquipLevelupBasicVo(beforeBsVo.level);
			
			var nextQuality:String=_beforeLevelUpVo.after_quality.toString();
			var nextLevel:String;
			if(_beforeLevelUpVo.after_level < 100)
				nextLevel='0'+_beforeLevelUpVo.after_level.toString();
			else
				nextLevel=_beforeLevelUpVo.after_level.toString();
			var carrer:String=beforeBsVo.career.toString();
			var pos:String;
			if(beforeBsVo.type < 10)
				pos = '0'+beforeBsVo.type.toString();
			else
				pos = beforeBsVo.type.toString();
			
			var nextEquipId:int=int(nextQuality+nextLevel+carrer+pos);
			_afterBsVo = EquipBasicManager.Instance.getEquipBasicVo(nextEquipId);
			
			_afterEquipIcon.url = EquipBasicManager.Instance.getURL(nextEquipId);
			Xtip.registerLinkTip(_afterEquipIcon,EquipTip,TipUtil.equipTipInitFunc,0,nextEquipId);
			
			_meterialIcon.url = PropsBasicManager.Instance.getURL(_beforeLevelUpVo.props_id);
			Xtip.registerLinkTip(_meterialIcon,PropsTip,TipUtil.propsTipInitFunc,0,_beforeLevelUpVo.props_id);
			
//			trace('装备进阶：前level：',beforeBsVo.level,'后level:',_afterBsVo.level,'下一等级道具id',nextEquipId,'需要材料id',_beforeLevelUpVo.props_id)
			
			var propsNum:int=PropsDyManager.instance.getPropsQuantity(_beforeLevelUpVo.props_id);
			if(propsNum >= _beforeLevelUpVo.props_num)
				_propsNum.text = _beforeLevelUpVo.props_num.toString();
			else
				_propsNum.htmlText = HTMLUtil.setFont(_beforeLevelUpVo.props_num.toString());
			
			////金钱的更新
			var money:int=_beforeLevelUpVo.money;
			if(DataCenter.Instance.roleSelfVo.note >= money)
				_moneyTxt.text = money.toString()+NoticeUtils.getStr(NoticeType.Notice_id_100001);
			else
				_moneyTxt.htmlText = HTMLUtil.setFont(money.toString()+NoticeUtils.getStr(NoticeType.Notice_id_100001));
			
			///更新当前装备和预览升级后装备的属性
			_curEquipTxt.htmlText = getEquipAttrs(beforeBsVo);
			_afterEquipTxt.htmlText = getEquipAttrs(_afterBsVo);
		}
		
		private function getEquipAttrs(bsVo:EquipBasicVo):String
		{
			var html:String='';
			var str:String='';
			if(bsVo.base_attr_t1 > 0)
				str=TypeProps.getAttrName(bsVo.base_attr_t1) + "："+Math.ceil(bsVo.base_attr_v1).toString();
			else str='';
			html += createLineHtml(str,COLOR_DARK_YELLOW)+'<br>';
			if(bsVo.base_attr_t2 > 0)
				str=TypeProps.getAttrName(bsVo.base_attr_t2) + "："+Math.ceil(bsVo.base_attr_v2).toString();
			else str='';
			html += createLineHtml(str,COLOR_DARK_YELLOW)+'<br>';
			if(bsVo.base_attr_t3 > 0)
				str=TypeProps.getAttrName(bsVo.base_attr_t3) + "："+Math.ceil(bsVo.base_attr_v3).toString();
			else str='';
			html += createLineHtml(str,COLOR_DARK_YELLOW)+'<br>';
			if(bsVo.app_attr_t1 > 0)
				str=TypeProps.getAttrName(bsVo.app_attr_t1) + "："+Math.ceil(bsVo.app_attr_v1).toString();
			else str='';
			html += createLineHtml(str,COLOR_BLUE)+'<br>';
			if(bsVo.app_attr_t2 > 0)
				str=TypeProps.getAttrName(bsVo.app_attr_t2) + "："+Math.ceil(bsVo.app_attr_v2).toString();
			else str='';
			html += createLineHtml(str,COLOR_BLUE)+'<br>';
			html = html.slice(0,html.length-4);
			return html;
		}
		
		private function createLineHtml(str:String,color:String,size:int=12):String
		{
			return HTMLUtil.createHtmlText(str,size,color);
		}
		
		private function checkLevelUpAbleClick():void
		{
			if(_playEff) {
				_levelUpBtn.enabled = false;//播放特效时，按钮不能用
				return;
			}
			else
			{
				if(_beforeDyVo != null){
					var propsNum:int=PropsDyManager.instance.getPropsQuantity(_beforeLevelUpVo.props_id);
					if(propsNum >= _beforeLevelUpVo.props_num)
					{
						var money:int=_beforeLevelUpVo.money;
						if(DataCenter.Instance.roleSelfVo.note >= money)
							_levelUpBtn.enabled = true;
					}
					else
						_levelUpBtn.enabled = false;
				}else{				
					_levelUpBtn.enabled = false;
				}
			}			
		}
		
		public function checkMoney():void
		{
			if(_beforeLevelUpVo)
			{
				var money:int=_beforeLevelUpVo.money;
				if(DataCenter.Instance.roleSelfVo.note >= money)
					_moneyTxt.text = money.toString()+NoticeUtils.getStr(NoticeType.Notice_id_100001);
				else
					_moneyTxt.htmlText = HTMLUtil.setFont(money.toString()+NoticeUtils.getStr(NoticeType.Notice_id_100001));
			}				
		}
		
		public function updateBagList():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			updateTileList(_bagEquipList,arr);
		}
		
		public function updateCharacterEquipList(event:Object=null):void
		{	
			var arr:Array = CharacterDyManager.Instance.getAllEquips();
			updateTileList(_CharacterEquipList,arr,true);
		}
		
		private function updateTileList(list:TileList,ary:Array,isSelf:Boolean=false):void
		{
			list.removeAll();
			
			var basicVO:EquipBasicVo;
			var levelUpVo:EquipLevelupBasicVo;
			var item:Object;
			var nextEquipBasicVo:EquipBasicVo;//  下一等级的装备
			var equips:Array=[];
			for each(var equipDyVo:EquipDyVo in ary)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
				levelUpVo=EquipLevelUpBasicManager.Instance.getEquipLevelupBasicVo(basicVO.level);
				nextEquipBasicVo=EquipBasicManager.Instance.getNextEquipBasicVo(DataCenter.Instance.roleSelfVo.roleDyVo.career,basicVO.type,basicVO.level);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS && basicVO.quality < TypeProps.QUALITY_ORANGE &&
					basicVO.career != TypeRole.CAREER_NEWHAND && basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY && levelUpVo && nextEquipBasicVo &&
					(nextEquipBasicVo.level) <= DataCenter.Instance.roleSelfVo.roleDyVo.level)
				{
					equips.push(equipDyVo);
				}
			}
			
			equips=ForgeSource.orderContainEquips(equips);
			for each(equipDyVo in equips)
			{
				item = new Object();
				item.vo = equipDyVo;
				item.showType=ForgeSource.EQUIP_SHOW_LEVEL_UP;
				if(isSelf)
					item.type=ForgeSource.CHARACTER;
				else
					item.type=ForgeSource.BAG;
				list.addItem(item);
			}
		}
		
		
		
		
		//======================================================================
		//        event handler
		//======================================================================
		protected function onEquipListChange(event:Event):void
		{		
			clearLeftPanel();//每次重新选择一个装备，都把左侧清空 
			var list:TileList = event.currentTarget as TileList;
			if(list.selectedSp.select == false) 
			{
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<=22&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=20)
				{
					NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_ToClickEquip; //返回到第一步
					NewGuideManager.DoGuide();
				}
				return;
			}
			_beforeDyVo = list.selectedItem.vo; 
			putMainEquipOn();     
			 
			checkLevelUpAbleClick();
			
			if(list == _bagEquipList)
				_CharacterEquipList.clearSelection();
			else
				_bagEquipList.clearSelection();		
			
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<=22&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=20)
			{
				NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_ToClickLevelUpBtn;
				NewGuideManager.DoGuide();
			}
		}
		
		/**引导升级按钮
		 */
		public function handleLevelUpBtnGuide():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<=22&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=20)
			{
				//引导升级按钮
				if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_ToClickLevelUpBtn)
				{
//					var rect:Rectangle=getLevelUpBtnRect();//获取升级区域
//					NewGuideMovieClipWidthArrow.Instance.initRect(rect.x,rect.y,rect.width,rect.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//					NewGuideMovieClipWidthArrow.Instance.addToContainer(_targetUI);
					var pt:Point=UIPositionUtil.getUIRootPosition(_levelUpBtn);
					NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_levelUpBtn.width,_levelUpBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_levelUpBtn);
					return true;
				}
			}
			return false;
		}
		
		
		/**处理新手引导抠图 
		 */
		public function handleClickEquipNewGuide():Boolean
		{
			var task_targetBasicVo:Task_targetBasicVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo();
			if(task_targetBasicVo)
			{
				if(task_targetBasicVo.seach_type==TypeProps.TaskTargetType_WeaponLevelUp)
				{
//					if(TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo().seach_type==TypeProps.TaskTargetType_WeaponLevelUp)  //主线为武器升级
//					{
						var equipItemRender:EquipItemRender;
						if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_ToClickEquip)
						{
							equipItemRender=getClickEquipRect();
							if(equipItemRender)
							{
								//找到 父容器 坐标 ，然后计算子对象坐标
								var pt:Point=UIPositionUtil.getPosition(equipItemRender.parent,_targetUI);
								var height:int=(equipItemRender.index)*equipItemRender.renderHeight;
								pt.y +=height;
								
								NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,equipItemRender.width,equipItemRender.height,NewGuideMovieClipWidthArrow.ArrowDirection_Right);
								NewGuideMovieClipWidthArrow.Instance.addToContainer(_targetUI);
								//							var pt:Point=UIPositionUtil.getUIRootPosition(equipItemRender);
								//							NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,equipItemRender.width,equipItemRender.height,NewGuideMovieClipWidthArrow.ArrowDirection_Right,equipItemRender);
							}
							else 
							{
								NewGuideMovieClipWidthArrow.Instance.hide();
							}
							
							return true;
						}
//					}
				}
			}

			return false;
		}
		
		/**获取要点击的区域
		 */
		private function getClickEquipRect():EquipItemRender
		{
			//获取锻造面板
			var len:int=_CharacterEquipList.length;
			var data:Object;//数据 
			var equipBasicVo:EquipBasicVo;
			var equipItemRender:EquipItemRender;
			var equipDyVo:EquipDyVo;
			for(var i:int=0;i!=len;++i)
			{
				data=_CharacterEquipList.getItemAt(i);
				equipDyVo=data.vo;
				equipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
			//	equipBasicVo=data.bsVo as EquipBasicVo;
				if(equipBasicVo.type==TypeProps.EQUIP_TYPE_WEAPON)
				{
					equipItemRender=_CharacterEquipList.getItemRenderAt(i) as EquipItemRender;
					break;
				}
			}
//			if(equipItemRender) //开始 划区域进行引导 
//			{
////				var pt:Point=UIPositionUtil.getPosition(equipItemRender,_targetUI); //不能使用 这个方法 因为 list内部坐标的改变是一个异步的    此处需要等待 ，此时坐标并没有刷新
//				//找到 父容器 坐标 ，然后计算子对象坐标
//				var pt:Point=UIPositionUtil.getPosition(equipItemRender.parent,_targetUI);
//				var height:int=(equipItemRender.index)*equipItemRender.renderHeight;
//				pt.y +=height;
//				return new Rectangle(pt.x,pt.y,equipItemRender.width,equipItemRender.height);
//			}
//			return null;
			return equipItemRender;
		}
		
		/**获取升级按钮区域
		 */
//		private function getLevelUpBtnRect():Rectangle
//		{
//			var point:Point=UIPositionUtil.getPosition(_levelUpBtn,_targetUI);
//			return new Rectangle(point.x,point.y,_levelUpBtn.width,_levelUpBtn.height);
//		}
		
		/**获取关闭按钮区域
		 */
		private function getClothBtnRect():Rectangle
		{
			return null
		}
		
		////////////////-----------end --------------新手引导
		
		
		
		private function onLevelUp(e:MouseEvent):void
		{
			var pos:int;
			if(EquipDyManager.instance.getEquipPosFromBag(_beforeDyVo.equip_id) != 0)
			{
				pos = EquipDyManager.instance.getEquipPosFromBag(_beforeDyVo.equip_id);
			}
			else
			{
				pos = EquipDyManager.instance.getEquipPosFromRole(_beforeDyVo.equip_id);
			}
			var itemAry:Array=PropsDyManager.instance.getPropsPosArray(_beforeLevelUpVo.props_id,_beforeLevelUpVo.props_num);
			ModuleManager.forgetModule.equipLevelUp(pos,itemAry);
			_levelUpBtn.enabled=false;
		}
		
		/**升级成功播放特效*/
		public function showLevelUp():void
		{
			_playEff=true;
			WingLvUpEffMgr.Instence.setTo(_targetUI,55,60);
			WingLvUpEffMgr.Instence.addCallback(completeEff);
		
		}
		
		private function completeEff():void
		{
			_playEff=false;
			updateAllList();
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public function get update():Boolean
		{
			return _update;
		}
		
		public function set update(value:Boolean):void
		{
			_update = value;
		}
		
	}
} 