package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.RoleSelfVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.EquipEnhanceBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipEnhanceBasicVo;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2014-1-16 上午10:26:41
	 */
	public class EquipStrengthenPanel
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		public static var equipName:String;
		public static var level:int;
		public static var quality:int;
		
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		
		private var _bagEquipsList:TileList;
		private var _characterEquipsList:TileList;
		
		private var _equipIcon:IconImage;
		private var _propsIcon:IconImage;
		
		private var _strengthenButton:Button;
		/** 一键强化，直到强化到成功为止 */
		private var _allStrengthenBtn:Button;
		
		/**选中装备名称文本框  */
		private var _equipNameTxt:TextField;
		/** 选中装备强化等级 */
		private var _levelTxt:TextField;
		/** 道具数量文本框 */
		private var _propsNum:TextField;
		private var _propsName:TextField;
		/** 强化星星 */
		private var _stars:Array = [];
		
		/** 当前选中的装备的动态信息  */		
		private var _curEquipDyVo:EquipDyVo;
		/** 装备静态信息 */
		private var _curEquipBsVo:EquipBasicVo;
		/** 选择的哪个强化石的静态数据 */		
		private var _curPropsBsVo:PropsBasicVo;
		/** 强化装备信息 */
		private var _curEnhenceVo:EquipEnhanceBasicVo;
		/** 切换到这个面板，背包改变才更新 */		
		private var _update:Boolean=false;
		/**是否点击了一键强化*/
		private var _allStrengthen:Boolean;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EquipStrengthenPanel(targetUI:Sprite)
		{
			_ui = targetUI;
			_bagEquipsList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagEquipsList.itemRender = EquipItemRender;
			_bagEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_characterEquipsList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_characterEquipsList.itemRender = EquipItemRender;
			_characterEquipsList.setSelfDeselect(true);
			_characterEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_equipIcon.addEventListener(MouseEvent.CLICK,onClearPanel);
			
			_propsIcon = Xdis.getChild(_ui,"material_iconImage");
			
			for(var i:int=1;i<=10;i++)
			{
				_stars.push(Xdis.getChild(_ui,"star"+i));
			}
			
			_equipNameTxt = Xdis.getChild(_ui,"info_txt");
			_levelTxt=Xdis.getChild(_ui,'level_txt');
			_propsNum=Xdis.getChild(_ui,"propsNum");
			_propsName=Xdis.getChild(_ui,"propsName");
			
			
			_strengthenButton = Xdis.getChildAndAddClickEvent(onStrengthenBtnClick,_ui,"strengthen_button");
			_strengthenButton.enabled = false;
			_allStrengthenBtn=Xdis.getChildAndAddClickEvent(onAllStrenthenBtnClick,_ui,"allStrengthen_button");
			_allStrengthenBtn.enabled=false;
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				clearLeftPanel();
				_bagEquipsList.clearSelection();
				_characterEquipsList.clearSelection();
				_tabs.switchToTab(1);	
				updateAllList();			
			}		
		}
		
		/**
		 * 背包有任何改变就刷新背包装备list，自己身上list，宝石list
		 * @param event
		 * 
		 */
		public function updateAllList(e:YFEvent=null):void
		{
			if(_update == false) return;
			
			updateCharacterList();
			updateBagEquipsList();
			
			var index1:int=_bagEquipsList.findDataIndex(_curEquipDyVo,"vo");		
			if(index1 > -1)
			{
				_bagEquipsList.selectedIndex=index1;
				_bagEquipsList.scrollToSelected();
				showEquipName();
			}
			else
			{
				var index2:int=_characterEquipsList.findDataIndex(_curEquipDyVo,"vo");
				if(index2 > -1)
				{
					_characterEquipsList.selectedIndex = index2;
					_characterEquipsList.scrollToIndex(index2);
					showEquipName();
				}
				else
				{
					clearLeftPanel();
				}
			}
			
			checkEnhanceBtn();
			
		}
		
		public function resetPanel():void
		{
			clearLeftPanel();
			_bagEquipsList.clearSelection();
			_characterEquipsList.clearSelection();
			_tabs.switchToTab(1);
			
			_update=false;
		}
		
		public function updateStars():void
		{
			if(_curEquipDyVo)
				showStarLevel(_curEquipDyVo.star);
		}
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 装备选择后切换后要做的是：更换装备图标；把百分百选择去掉；显示金钱；显示装备名称；强化等级星星；强化按钮可用否；各个属性
		 * @param event
		 * 
		 */
		protected function onEquipListChange(event:Event):void
		{
			var list:TileList = event.currentTarget as TileList;	
			
			if(list.selectedSp.select == false)
			{
				clearLeftPanel();
				return;
			}
			
			_curEquipDyVo = list.selectedItem.vo;
			_curEquipBsVo = EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			_curEnhenceVo=EquipEnhanceBasicManager.Instance.getEquipEnhanceBasicVo(_curEquipDyVo.enhance_level+1);
			_curPropsBsVo=PropsBasicManager.Instance.getPropsBasicVo(_curEnhenceVo.template_id);
			
			putEquipOn();
			putPropsOn();
			showEquipName();
			showStarLevel(_curEquipDyVo.star);
			checkEnhanceBtn();
			updateValues(Xdis.getChild(_ui,"now_mc"),getValuesScale(_curEquipDyVo.enhance_level));
			updateValues(Xdis.getChild(_ui,"next_mc"),getValuesScale(_curEquipDyVo.enhance_level+1));
			
			if(list == _bagEquipsList)
			{
				_characterEquipsList.clearSelection();
			}
			else
			{
				_bagEquipsList.clearSelection();
			}
			
		}
		
		/**
		 * 放上装备 :显示装备图标、tip、星运
		 */
		private function putEquipOn():void
		{	
			if(_curEquipDyVo==null) return;
			_equipIcon.url = EquipBasicManager.Instance.getURL(_curEquipDyVo.template_id);	
			
			if(EquipDyManager.instance.getEquipPosFromRole(_curEquipDyVo.equip_id) > 0)
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id,true);
			else
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id);			
			showStarLevel(_curEquipDyVo.star);
		}
		
		/** 显示道具名，注意，这里没有区分道具够不够的情况，在检查按钮可用与否里有区分 */
		private function putPropsOn():void
		{
			_propsIcon.url=PropsBasicManager.Instance.getURL(_curPropsBsVo.template_id);
			Xtip.registerLinkTip(_propsIcon,PropsTip,TipUtil.propsTipInitFunc,0,_curPropsBsVo.template_id);
			_propsName.htmlText=HTMLUtil.createHtmlText(_curPropsBsVo.name,12,TypeProps.getQualityColor(_curPropsBsVo.quality));
		}
		
		/** 显示装备名字和装备的强化等级 */		
		private function showEquipName():void
		{
			var basicVO:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			_equipNameTxt.htmlText = HTMLUtil.createHtmlText(basicVO.name,12,TypeProps.getQualityColor(basicVO.quality));
			_levelTxt.text='当前强化  +'+_curEquipDyVo.enhance_level.toString();
		}
		
		/** 一次强化 */
		private function onStrengthenBtnClick(event:MouseEvent=null):void
		{
			if(allStrengthenMode == false)
				oneStrengthen();
		}
		
		/** 一键强化 */
		private function onAllStrenthenBtnClick(e:MouseEvent):void
		{
			if(allStrengthenMode == false)
			{
				allStrengthenMode=true;
			}			
		}
		
		public function oneStrengthen():void
		{
			var pos:int;			
			if(EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id) != 0)
			{
				pos = EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id);
			}
			else
			{
				pos = EquipDyManager.instance.getEquipPosFromRole(_curEquipDyVo.equip_id);
			}
			
			ModuleManager.forgetModule.strengthenEquip(pos,_curEnhenceVo.num,_curPropsBsVo.template_id);
			
			//为了显示notice的变量
			equipName=_curEquipBsVo.name;
			level=_curEquipDyVo.enhance_level;
			quality=_curEquipBsVo.quality;		
			_strengthenButton.enabled=false;
			_allStrengthenBtn.enabled=false;
		}
		
		/**
		 * 刷新身上装备 
		 */
		public function updateCharacterList(event:Object=null):void
		{
			var arr:Array = CharacterDyManager.Instance.getEquipDict().values();
			updateTileList(_characterEquipsList,arr,true);
		}
		
		/**
		 * 刷新背包list
		 */
		public function updateBagEquipsList():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			updateTileList(_bagEquipsList,arr);
		}
		
		/**
		 * 更新TileList 
		 * @param list
		 * @param arr
		 */
		private function updateTileList(list:TileList,ary:Array,isSelf:Boolean=false):void
		{
			list.removeAll();
			
			var basicVO:EquipBasicVo;			
			var equips:Array=[];
			var equipDict:Dictionary=new Dictionary();
			
			for each(var vo:EquipDyVo in ary)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS && basicVO.can_enhance == 1 
					&& vo.enhance_level < ForgeSource.MAX_ENHENCE_LEVEL && basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY &&
					basicVO.career != TypeRole.CAREER_NEWHAND)
				{
					equips.push(vo);	
				}
			}
			
			equips=ForgeSource.orderContainEquips(equips);
			var item:Object;
			for each(vo in equips)
			{
				item = {};
				item.showType=ForgeSource.SHOW_ENHANCE_LEVEL;
				item.vo = vo;
				if(isSelf)
					item.type=ForgeSource.CHARACTER;
				else
					item.type=ForgeSource.BAG;
				item.basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				list.addItem(item);
			}
		}
		
		private function onClearPanel(e:MouseEvent):void
		{
			clearLeftPanel();
			_bagEquipsList.clearAllSelection();
			_characterEquipsList.clearAllSelection();
		}
		
		/**1强化星星清零；2所有数据清理；3装备图标、名字、等级、道具图标、名字清空；3装备属性清空；4按钮不可用；5一键强化变量为假 */
		private function clearLeftPanel():void
		{
			showStarLevel(0);
			
			_curEquipDyVo=null;
			_curPropsBsVo=null;
			_curEquipBsVo=null;
			_curEnhenceVo=null;
			
			_equipIcon.clear();
			Xtip.clearLinkTip(_equipIcon);
			
			_propsIcon.clear();
			Xtip.clearLinkTip(_propsIcon);
			
			_equipNameTxt.htmlText = '';
			_propsNum.text='';
			_levelTxt.text='';
			_propsName.text='';
			
			clearValues(Xdis.getChild(_ui,"now_mc"));
			clearValues(Xdis.getChild(_ui,"next_mc"));
			
			checkEnhanceBtn();
			allStrengthenMode=false;
		}
		
		/** 强化按钮是否可用：材料是否足够（同时这里也对材料数赋值）  */
		public function checkEnhanceBtn():void
		{
			//首先检查有没有选中装备
			if(_curEquipDyVo != null)
			{
				var num:int=PropsDyManager.instance.getPropsQuantity(_curEnhenceVo.template_id);
				if(num >= _curEnhenceVo.num)//材料是否足够
				{
					if(allStrengthenMode == false)
					{
						_strengthenButton.enabled=true;
						_allStrengthenBtn.enabled=true;
					}
					else//一键强化时两个按钮都不可用
					{
						_strengthenButton.enabled=false;
						_allStrengthenBtn.enabled=false;
					}				
					_propsNum.htmlText=HTMLUtil.createHtmlText(_curEnhenceVo.num.toString(),12,'00ff00');
				}
				else
				{
					_strengthenButton.enabled=false;
					_allStrengthenBtn.enabled=false;
					_propsNum.htmlText=HTMLUtil.createHtmlText(_curEnhenceVo.num.toString(),12,'ff0000');
				}
			}
			else
			{
				_strengthenButton.enabled=false;
				_allStrengthenBtn.enabled=false;
				_propsNum.htmlText=HTMLUtil.createHtmlText('0',12,'ff0000');
			}
		}
		
		/**
		 * 仅显示装备的星星等级
		 * @param level
		 */
		private function showStarLevel(level:uint):void
		{
			var len:int = _stars.length;
			var i:int;
			for(i=0;i<len;i++)
			{
				DisplayObject(_stars[i]).visible = false;
			}
			for(i=0;i<level;i++)
			{
				DisplayObject(_stars[i]).visible = true;
			}
		}
		
		/** 根据装备强化等级返回对应属性的增长比值
		 * @param enhanceLevel
		 * @return 
		 */		
		private function getValuesScale(enhanceLevel:int):Number
		{
			return EquipDyManager.instance.getEquipStrengthenIncrement(enhanceLevel);
		}
		
		/**
		 * 刷新属性 
		 * @param sp
		 * @param scaleValue
		 */
		private function updateValues(sp:Sprite,scaleValue:Number):void
		{
			var bvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			
			var a:int = Math.ceil(bvo.base_attr_v1*scaleValue);
			if(isNaN(a) == false && bvo.base_attr_t1 != 0){
				Xdis.getTextChild(sp,"value1_txt").text = TypeProps.getAttrName(bvo.base_attr_t1)+"："+a;
			}else{
				Xdis.getTextChild(sp,"value1_txt").text = "";
			}
			var b:int = Math.ceil(bvo.base_attr_v2*scaleValue);
			if(isNaN(b) == false && bvo.base_attr_t2 != 0){
				Xdis.getTextChild(sp,"value2_txt").text = TypeProps.getAttrName(bvo.base_attr_t2)+"："+b;
			}else{
				Xdis.getTextChild(sp,"value2_txt").text = "";
			}
			var c:int = Math.ceil(bvo.base_attr_v3*scaleValue);
			if(isNaN(c) == false && bvo.base_attr_t3 != 0){
				Xdis.getTextChild(sp,"value3_txt").text = TypeProps.getAttrName(bvo.base_attr_t3)+"："+c;
			}else{
				Xdis.getTextChild(sp,"value3_txt").text = "";
			}
		}
		
		private function clearValues(sp:Sprite):void
		{
			Xdis.getTextChild(sp,"value1_txt").text = "";
			Xdis.getTextChild(sp,"value2_txt").text = "";
			Xdis.getTextChild(sp,"value3_txt").text = "";
		}

		/**是否点击了一键强化*/
		public function get allStrengthenMode():Boolean
		{
			return _allStrengthen;
		}

		/**是否处于一键强化状态,true就开始不停执行强化*/
		public function set allStrengthenMode(value:Boolean):void
		{
			_allStrengthen = value;
			if(_allStrengthen)
				oneStrengthen();
			else
				checkEnhanceBtn();
		}


		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 