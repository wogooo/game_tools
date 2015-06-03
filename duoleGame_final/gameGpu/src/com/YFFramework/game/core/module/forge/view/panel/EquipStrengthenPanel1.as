package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
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
	import com.YFFramework.game.core.module.forge.view.simpleView.EnhenceStoneRender;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.NumericStepper;
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
	 * 装备强化 (此版本不要了，但是不要删，说不定以后又要改回来)
	 * @author jina
	 * 
	 */
	public class EquipStrengthenPanel1
	{	
		private const MAX_ENHENCE_LEVEL:int = 12;
		/** 界面文字的默认黄色 */		
		private const DEFAULT_TXT_COLOR:String='FDF3AB';
		private const DEFAULT_TXT_COLOR_UINT:uint=0xFDF3AB;
		/** 警告红色 */		
		private const RED_COLOR:String='ff0000';
		private const RED_COLOR_UINT:uint=0xff0000;
		/** 三种强化石等级分界点，如：5级以前是低级强化石  */		
//		private const LEVEL_BOUND:Array = [5,9];
		/** 强化石最小数量 */		
		private const MIN_STONES:int = 1;
		/** 金钱基础值 */		
		private const MONEY_RATIO:Number = 100;
		private const FIRST_PROPS:int=101;//第一个强化材料
		private const LAST_PROPS:int=106;//最后一个强化材料
		
		public static var equipName:String;
		public static var level:int;
		public static var quality:int;
		/********************************************************/
			
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		private var _numStep:NumericStepper;
		/** 是否百分百强化  */		
		private var _perCheckBox:CheckBox;
		private var _strengthenButton:Button;

		private var _bagEquipsList:TileList;
		private var _characterEquipsList:TileList;
		private var _enhanceStonesList:TileList;
		
		private var _equipIcon:IconImage;
		private var _materialIcon:IconImage;
		/** 根据强化石数量显示金钱 */		
		private var _moneyTxt:TextField;		
		/**选中装备名称  */		
		private var _infoTxt:TextField;
		
		private var _stars:Array = [];
		/** 成功率 */		
		private var _sucessTxt:TextField;

		/** 当前选中的装备的动态信息  */		
		private var _curEquipDyVo:EquipDyVo;
		/** 选择的哪个强化石的静态数据 */		
		private var _curPropsBsVo:PropsBasicVo;
		/** 6种强化材料的数组 */		
		private var _propsAry:Array;
		
		/** 切换到这个面板，背包改变才更新
		 */		
		private var _update:Boolean=false;
		
		public function EquipStrengthenPanel1(targetUI:Sprite)
		{
			_ui = targetUI;
			
			_bagEquipsList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagEquipsList.itemRender = EquipItemRender;
			//_bagEquipsList.setSelfDeselect(true);
			_bagEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_characterEquipsList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_characterEquipsList.itemRender = EquipItemRender;
			_characterEquipsList.setSelfDeselect(true);
			_characterEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_enhanceStonesList = Xdis.getChild(_ui,"equipsBox_tileList");
			_enhanceStonesList.itemRender = EnhenceStoneRender;
			_enhanceStonesList.setSelfDeselect(true);
			_enhanceStonesList.addEventListener(Event.CHANGE,onEnhanceChange);
			
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_equipIcon.addEventListener(MouseEvent.CLICK,onClearPanel);
			
			_materialIcon = Xdis.getChild(_ui,"material_iconImage");
			_materialIcon.addEventListener(MouseEvent.CLICK,onClearProps);
			
			_sucessTxt = Xdis.getChild(_ui,"succ_txt");
			
			_moneyTxt = Xdis.getChild(_ui,"use_txt");
			
			for(var i:int=1;i<=MAX_ENHENCE_LEVEL;i++)
			{
				_stars.push(Xdis.getChild(_ui,"star"+i));
			}
			
			_infoTxt = Xdis.getChild(_ui,"info_txt");
			
			_numStep = Xdis.getChild(_ui,"num_numericStepper");
			_numStep.minimum = 0;
			_numStep.maximum = 0;
			_numStep.value = 0;
			_numStep.textField.textColor=RED_COLOR_UINT;
			_numStep.addEventListener(Event.CHANGE,onStoneNumChange);
			
			_perCheckBox = Xdis.getChild(_ui,"per100_checkBox");
			_perCheckBox.label = "100%";
			_perCheckBox.textField.y=1;
			_perCheckBox.textField.width=_perCheckBox.textField.textWidth+20;
			_perCheckBox.addEventListener(Event.CHANGE,onPer100Change);
			
			_strengthenButton = Xdis.getChildAndAddClickEvent(onStrengthenBtnClick,_ui,"strengthen_button");
			_strengthenButton.enabled = false;
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");

			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
			
			initStrengthenProps();
		}
		
		private function initStrengthenProps():void
		{
			var id:int;
			_propsAry=[];
			for(var i:int=FIRST_PROPS;i<=LAST_PROPS;i++)
			{
				id=ConstMapBasicManager.Instance.getTempId(i);
				_propsAry.push(id);
			}
		}
		
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				clearLeftPanel();
				_bagEquipsList.clearSelection();
				_characterEquipsList.clearSelection();
				_tabs.switchToTab(1);	
				
				if(_perCheckBox.selected == true)
					_perCheckBox.selected = false;
				
				updateAllList();			
			}		
		}
		
		public function resetPanel():void
		{
			clearLeftPanel();
			_bagEquipsList.clearSelection();
			_characterEquipsList.clearSelection();
			_tabs.switchToTab(1);
			
			if(_perCheckBox.selected == true)
				_perCheckBox.selected = false;
			
			_update=false;
		}
		
		private function clearLeftPanel():void
		{
			showStarLevel(0);
			
			_curEquipDyVo=null;
			
			_equipIcon.clear();
			Xtip.clearLinkTip(_equipIcon);
			
			_infoTxt.htmlText = '';
			
			clearValues(Xdis.getChild(_ui,"now_mc"));
			clearValues(Xdis.getChild(_ui,"next_mc"));			
			
			_moneyTxt.text='';
			_enhanceStonesList.removeAll();
			
			clearProps();
		}
		
		private function clearProps():void
		{
			checkEnhanceBtn();
			_enhanceStonesList.clearAllSelection();
			clearSelectStone();
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
				_bagEquipsList.isDispatchEvnet=false;
				_bagEquipsList.selectedIndex=index1;
				//_bagEquipsList.scrollToIndex(index1);
				_bagEquipsList.scrollToSelected();
				showEquipName();
				showStarLevel(_curEquipDyVo.enhance_level);
			}
			else
			{
				var index2:int=_characterEquipsList.findDataIndex(_curEquipDyVo,"vo");
				if(index2 > -1)
				{
					_characterEquipsList.isDispatchEvnet=false;
					_characterEquipsList.selectedIndex = index2;
					_characterEquipsList.scrollToIndex(index2);
					showEquipName();
					showStarLevel(_curEquipDyVo.enhance_level);
					showMoney();
				}
				else
				{
					clearLeftPanel();
				}
			}

			updateEnhanceItemsList();
			
			if(_curEquipDyVo != null && _curEquipDyVo.enhance_level < MAX_ENHENCE_LEVEL)
			{
				if(_curPropsBsVo != null)
				{
					var bagNum:int=PropsDyManager.instance.getPropsQuantity(_curPropsBsVo.template_id);
					if(bagNum > 0)//背包有这个道具
					{
						var maxNum:int=getStoneMaxNum(_curPropsBsVo);//强化百分百需要多少选中的多少强化石
						if(maxNum > 0)//可以继续用这个道具强化
						{
							putPropsOn(_curPropsBsVo);//这句话必须放在这里，否则成功率会显示错误
							if(_perCheckBox.selected == true)//如果之前选中了强化百分百，那么背包里的数量超过这个数量就继续选中
							{
								if(bagNum < maxNum)
									_perCheckBox.selected = false;
								_numStep.value=maxNum;
							}
							var index:int=_enhanceStonesList.findDataIndex(_curPropsBsVo);
							_enhanceStonesList.scrollToIndex(index);						
							onStoneNumChange();				
						}
						else//如果maxNum为0，说明这个强化石不能继续强化这件装备了
						{
							if(_perCheckBox.selected == true)
								_perCheckBox.selected = false;
							_curPropsBsVo=null;
							clearProps();
						}					
					}
					else//背包里没有这个道具，就清除道具图标
						clearProps();
				}
			}			
			else
				clearLeftPanel();
			
			checkEnhanceBtn();
			
		}
		
		/** 清除选中的石头：1._curPropsBsVo置空，2.强化百分百不选中，3._numStep置零，4.强化图标清除，5.成功率置空 */
		private function clearSelectStone():void
		{
			_curPropsBsVo=null;
			
			_perCheckBox.selected=false;
			
			_numStep.enabled=true;
			_numStep.minimum = 0;
			_numStep.maximum = 0;
			_numStep.value = 0;
			_numStep.textField.textColor = RED_COLOR_UINT;
			
			_materialIcon.clear();
			Xtip.clearLinkTip(_materialIcon);
			
			_sucessTxt.text = "";
		}
		
		/** 选中强化石  */
		protected function onEnhanceChange(event:Event):void
		{
			if(_curEquipDyVo)
			{
				var list:TileList = event.currentTarget as TileList;
				clearSelectStone();
				if(list.selectedSp.select)
				{
					if(list.selectedItem.isBuyClick == true) return;//如果当前是点击购买而不是选择这个道具，就不执行下面
					var vo:PropsBasicVo = list.selectedItem.vo;			
					var bagNum:int=list.selectedItem.count;
					if(bagNum == 0) 
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1226);
						_enhanceStonesList.clearAllSelection();
					}
					else
						putPropsOn(vo);
					checkEnhanceBtn();
				}		
			}
			else
			{
				_enhanceStonesList.clearAllSelection();
				NoticeManager.setNotice(NoticeType.Notice_id_1227);
			}
		}
		
		/**
		 * 1.材料icon、tip；
		 */		
		private function putPropsOn(vo:PropsBasicVo):void
		{
			_curPropsBsVo=vo;//只能放在这，表示如果满足条件了才能放上图标
			
			_materialIcon.url=PropsBasicManager.Instance.getURL(vo.template_id);
			Xtip.registerLinkTip(_materialIcon,PropsTip,TipUtil.propsTipInitFunc,0,vo.template_id);
			
			_numStep.textField.textColor=DEFAULT_TXT_COLOR_UINT;
			_numStep.value=1;//这句会调用onStoneNumChange方法
			_numStep.minimum=1;
			_numStep.maximum=getCurEquipMaxNum();	
			
		}
		
		private function onClearPanel(e:MouseEvent):void
		{
			clearLeftPanel();
			_bagEquipsList.clearAllSelection();
			_characterEquipsList.clearAllSelection();
		}
		
		private function onClearProps(e:MouseEvent):void
		{
			clearProps();
			checkEnhanceBtn();
		}
		
		/**
		 * 更新强化石列表 
		 */
		public function updateEnhanceItemsList():void
		{
			if(_curEquipDyVo == null) return;
			_enhanceStonesList.removeAll();
			
			var item:Object;
			var vo:PropsBasicVo;
			var num:int;
			for each(var id:int in _propsAry)
			{
				vo=PropsBasicManager.Instance.getPropsBasicVo(id);
				num = getStoneMaxNum(vo);
				if(num > 0)
				{
					item = {};
					item.showType=ForgeSource.ENHENCE_STONES;
					item.vo = vo;
					item.type = ForgeSource.PROPS;
					item.count = PropsDyManager.instance.getPropsQuantity(vo.template_id);
					item.isBuyClick=false;
					_enhanceStonesList.addItem(item);
				}
			}

		}
		
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
			putEquipOn();
			_perCheckBox.selected=false;
			
			showMoney();
			showEquipName();
			showStarLevel(_curEquipDyVo.enhance_level);
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
			
			updateEnhanceItemsList();
		}
		
		/**
		 * 放上装备 :1.显示装备
		 * @param vo
		 * @param basicVO
		 * 
		 */
		private function putEquipOn():void
		{	
			if(_curEquipDyVo==null) return;
			_equipIcon.url = EquipBasicManager.Instance.getURL(_curEquipDyVo.template_id);	
			
			if(EquipDyManager.instance.getEquipPosFromRole(_curEquipDyVo.equip_id) > 0)
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id,true);
			else
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id);			
			
		}
		
		/** 显示装备名字和装备的强化等级 */		
		private function showEquipName():void
		{
			var basicVO:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			_infoTxt.htmlText =  basicVO.name + HTMLUtil.createHtmlText("     +"+_curEquipDyVo.enhance_level.toString(),12,TypeProps.getQualityColor(basicVO.quality));
		}
		
		/** 显示强化需要多少钱
		 */		
		private function showMoney():void
		{
			var needMoney:int=MONEY_RATIO*(_curEquipDyVo.enhance_level+1);
			if(DataCenter.Instance.roleSelfVo.note >= needMoney)
				_moneyTxt.htmlText = HTMLUtil.createHtmlText(NoticeUtils.getStr(NoticeType.Notice_id_100068)+needMoney.toString(),12,DEFAULT_TXT_COLOR);
			else
				_moneyTxt.htmlText = HTMLUtil.createHtmlText(NoticeUtils.getStr(NoticeType.Notice_id_100068)+needMoney.toString(),12,RED_COLOR);
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
					&& vo.enhance_level < MAX_ENHENCE_LEVEL && basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY &&
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
		
		/**
		 * 加减强化石
		 * @param event
		 */
		protected function onStoneNumChange(event:Event=null):void
		{
			if(_curEquipDyVo == null || _numStep.value == 0) return;
			
			var total:int=getStoneMaxNum(_curPropsBsVo);
			_sucessTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100070)+Math.ceil(1/total*_numStep.value*100).toString()+"%";
		}
		
		/** 检查强化按钮当前是否可点  */
		public function checkEnhanceBtn():void
		{
			//首先检查有没有选中装备和材料
			if(_curEquipDyVo != null && _curPropsBsVo != null)
			{
				//其次检查钱够不够
				var roleVO:RoleSelfVo = DataCenter.Instance.roleSelfVo;
				var needMoney:int=MONEY_RATIO*(_curEquipDyVo.enhance_level+1);			
				if(needMoney > roleVO.note)
				{
					_strengthenButton.enabled=false;
					return;
				}

				_strengthenButton.enabled = true;
			}
			else
				_strengthenButton.enabled=false;
		}
		
		/**
		 * 点击强化按钮 
		 * @param event
		 * 
		 */
		private function onStrengthenBtnClick(event:MouseEvent):void
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
			
			ModuleManager.forgetModule.strengthenEquip(pos,_numStep.value,_curPropsBsVo.template_id);
			
			//为了显示notice的变量
			equipName=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id).name;
			level=_curEquipDyVo.enhance_level;
			quality=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id).quality;		
			_strengthenButton.enabled=false;
		}
		
		/**
		 * 切换100%多选按钮 
		 * @param event
		 * 
		 */
		protected function onPer100Change(event:Event=null):void{
			if(_curEquipDyVo != null && _curPropsBsVo != null)
			{
				if(_perCheckBox.selected == false)
				{
					_numStep.enabled=true;			
				}
				else
				{				
					_numStep.enabled=false;
					var needNum:int=getStoneMaxNum(_curPropsBsVo);
					var bagNum:int=PropsDyManager.instance.getPropsQuantity(_curPropsBsVo.template_id);
					if(bagNum >= needNum)
					{
						_numStep.value=needNum;
						_numStep.maximum=needNum;
					}
					else
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1226);
					}	
				}
			}			

		}
		
		/** 根据装备强化等级和材料强化等级，找出这个强化百分百需要多少材料
		 */		
		private function getStoneMaxNum(propsVo:PropsBasicVo):int
		{	
			var num:int=0;
//			if(propsVo != null)
//			{		
//				//在表里找出强化到下一级需要所有强化材料的信息
//				var enhanceVo:EquipEnhanceBasicVo=EquipEnhanceBasicManager.Instance.getEquipEnhanceBasicVo(_curEquipDyVo.enhance_level+1);
//				if(propsVo.enhance_level == 1)
//					num=enhanceVo.enhance_equip1;
//				else if(propsVo.enhance_level == 2)
//					num=enhanceVo.enhance_equip2;
//				else if(propsVo.enhance_level == 3)
//					num=enhanceVo.enhance_equip3;
//				else if(propsVo.enhance_level == 4)
//					num=enhanceVo.enhance_equip4;
//				else if(propsVo.enhance_level == 5)
//					num=enhanceVo.enhance_equip5;
//				else
//					num=enhanceVo.enhance_equip6;				
//			}
			return num;
		}
		
		/** 用户最多可使用的强化石数量
		 * @param dyVo
		 * @return 
		 */		
		private function getCurEquipMaxNum():int
		{
			var a:int = getStoneMaxNum(_curPropsBsVo);//100%强化需要多少石头
			
//			var stoneTemplateId:int=getStoneTemplateId(_curEquipDyVo);
			var b:int = PropsDyManager.instance.getPropsQuantity(_curPropsBsVo.template_id);//目前背包有多少石头
			
			var maxNum:int=Math.min(a,b);
			return maxNum;
		}
	}
}