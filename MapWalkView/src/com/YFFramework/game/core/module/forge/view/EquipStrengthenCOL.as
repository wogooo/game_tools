package com.YFFramework.game.core.module.forge.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.model.RoleSelfVo;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.TabsMovieClipManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.BindingType;
	import com.msg.enumdef.ExtraAttr;
	import com.msg.enumdef.PropsType;
	import com.msg.item.CEnhanceEquipReq;
	import com.msg.pets.EmptyReq;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.profiler.showRedrawRegions;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	/**
	 * 装备强化 
	 * @author flashk
	 * 
	 */
	public class EquipStrengthenCOL
	{
		//强化最大等级
		public static var maxStrengthenLevel:int = 12;
		public static var levelSpace:Array = [5,9];
		//自动选择强化石对应的ID
		public static var stoneIDs:Array = [300001,300003,300005];
		//强化石最小数量
		public static var minNum:int = 4;
		
		private var _ui:Sprite;
		private var _tabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _materialTabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _numStep:NumericStepper;
		private var _perCheckBox:CheckBox;
		private var _strengthenButton:Button;
		private var _bakNum:int;
		private var _bagTileList:TileList;
		private var _selfTileList:TileList;
		private var _enhanceTileList:TileList;
		private var _equipIcon:IconImage;
		private var _materialIcon:IconImage;
		private var _infoTxt:TextField;
		private var _nextLevel:int;
		private var _stars:Array = [];
		private var _sucessTxt:TextField;
		private var _maxNeed:int = 50;
		private var _textBakColor:uint;
		private var _nowOn:Array = [];
		private var _moneyPer:Number = 1.0;
		private var _moneyTxt:TextField;
		private var _moneyBakColor:uint;
		private var _checks:Array = [];
		
		public function EquipStrengthenCOL(targetUI:Sprite)
		{
			_ui = targetUI;
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			_materialTabs.initTabs(_ui,"tabsMaterial_sp",1,"materialView");
			_bagTileList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagTileList.itemRender = EquipStrengthenItemRender;
			_bagTileList.addEventListener(Event.CHANGE,onEqListChange);
			_selfTileList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_selfTileList.itemRender = EquipStrengthenItemRender;
			_selfTileList.addEventListener(Event.CHANGE,onEqListChange);
			_enhanceTileList = Xdis.getChild(_ui,"materialView1","equipsBox_tileList");
			_enhanceTileList.itemRender = EquipEnhanceItemRender;
			_enhanceTileList.addEventListener(Event.CHANGE,onEnhanceChange);
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_materialIcon = Xdis.getChild(_ui,"material_iconImage");
			_sucessTxt = Xdis.getChild(_ui,"succ_txt");
			_moneyTxt = Xdis.getChild(_ui,"use_txt");
			_moneyBakColor = _moneyTxt.textColor;
			for(var i:int=1;i<=maxStrengthenLevel;i++){
				_stars.push(Xdis.getChild(_ui,"star"+i));
			}
			_infoTxt = Xdis.getChild(_ui,"info_txt");
			_numStep = Xdis.getChild(_ui,"num_numericStepper");
			_numStep.minimum = minNum;
			_numStep.maximum = _maxNeed;
			_numStep.textInputAble = false;
			_numStep.value = minNum;
			_numStep.addEventListener(Event.CHANGE,onStoneNumChange);
			_textBakColor = _numStep.textField.textColor;
			_perCheckBox = Xdis.getChild(_ui,"per100_checkBox");
			_perCheckBox.addEventListener(Event.CHANGE,onPer100Change);
			_strengthenButton = Xdis.getChildAndAddClickEvent(onStrengthenBtnClick,_ui,"strengthen_button");
			_strengthenButton.enabled = false;
			
			showStarLevel(0);
			updateEnhance();
			updateSelf();
			updateBag();
			YFEventCenter.Instance.addEventListener(GlobalEvent.EquipEnhanceLevelChange,onBagChange)
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
		}
		
		/**
		 * 强化石数量更改后刷新 
		 * @param event
		 * 
		 */
		protected function onStoneNumChange(event:Event=null):void
		{
			_sucessTxt.text = int(getSuccessPercent(_nextLevel,_numStep.value)*100)+"%";
			if(_numStep.value<4){
				_numStep.textField.textColor = 0xFF0000;
			}else{
				_numStep.textField.textColor = _textBakColor;
			}
			checkClickAble();
		}
		
		/**
		 * 检查强化按钮当前是否可点 
		 * 
		 */
		private function checkClickAble():void
		{
			checkMoney();
			var isAble:Boolean = true;
			var len:int = _checks.length;
			for(var i:int=0;i<len;i++){
				if(_checks[i] == false){
					isAble = false;
				}
			}
			_strengthenButton.enabled = isAble;
		}
		
		/**
		 * 背包切换选中 
		 * @param event
		 * 
		 */
		private function onBagChange(event:YFEvent):void
		{
			updateEnhance();
			updateBag();
			if(_nowOn.length>1){
				putEquipOn(_nowOn[0],_nowOn[1]);
			}
			updateSelf();
		}
		
		/**
		 * 选中强化石 
		 * @param event
		 * 
		 */
		protected function onEnhanceChange(event:Event):void
		{
			var list:TileList = event.currentTarget as TileList;
			var vo:PropsBasicVo = list.selectedItem.vo;
			if(list.selectedItem.isIn == false){
				ModuleManager.moduleShop.openBuySmallWindow(vo.template_id,1);
			}
		}
		
		/**
		 * 更新强化石列表 
		 * 
		 */
		public function updateEnhance():void
		{
			var arr:Array = [];
			var all:Array = PropsBasicManager.Instance.getAllPropsBasicVo();
			var i:int;
			var len:int = all.length;
			var vo:PropsBasicVo;
			for(i=0;i<len;i++){
				vo = all[i];
				if(vo.type == PropsType.PROPS_TYPE_ENHANCE && vo.binding_type == BindingType.BIND_TYPE_NO){
					arr.push(vo);
				}
			}
			arr.sortOn("template_id",Array.NUMERIC);
			len = arr.length;
			var item:Object;
			_enhanceTileList.removeAll();
			for(i=0;i<len;i++){
				item = {};
				item.vo = arr[i];
				item.isIn = PropsDyManager.instance.checkPropsIsInBag(PropsBasicVo(arr[i]).template_id);
				_enhanceTileList.addItem(item);
			}
		}
		
		/**
		 * 装备选择后切换 
		 * @param event
		 * 
		 */
		protected function onEqListChange(event:Event):void
		{
			var list:TileList = event.currentTarget as TileList;
			var vo:EquipDyVo = list.selectedItem.vo;
			// 1绑定  2未绑定  3穿戴后绑定
			if(vo.binding_attr == 2 || vo.binding_attr == 3){
				//暂时关闭，正式需打开
				Alert.show(LangBasic.equipStrengthenBindUnable,LangBasic.equipUpdate);
				return;
			}
			putEquipOn(vo,list.selectedItem.basicVO);
		}
		
		/**
		 * 显示星星 
		 * @param level
		 * 
		 */
		public function showStarLevel(level:uint):void
		{
			var len:int = _stars.length;
			var i:int;
			for(i=0;i<len;i++){
				DisplayObject(_stars[i]).visible = false;
			}
			for(i=0;i<level;i++){
				DisplayObject(_stars[i]).visible = true;
			}
		}
		
		private function getValuesScale(enhanceLevel:int):Number
		{
			return StrRatioManager.Instance.getStrRatio(enhanceLevel);
		}
		
		/**
		 * 放上装备 
		 * @param vo
		 * @param basicVO
		 * 
		 */
		public function putEquipOn(vo:EquipDyVo,basicVO:EquipBasicVo):void
		{
			_nowOn = [vo,basicVO];
			_equipIcon.url = EquipBasicManager.Instance.getURL(basicVO.template_id);
			_infoTxt.htmlText =  basicVO.name + HTMLFormat.color("     +"+vo.enhance_level,0xFF0000);
			updateValues(Xdis.getChild(_ui,"now_mc"),getValuesScale(vo.enhance_level));
			updateValues(Xdis.getChild(_ui,"next_mc"),getValuesScale(vo.enhance_level+1));
			var stone:int;
			var level:int = vo.enhance_level;
			_nextLevel = level+1;
			if(level<levelSpace[0]){
				stone = stoneIDs[0];
			}else if(level < levelSpace[1]){
				stone = stoneIDs[1];
			}else{
				stone = stoneIDs[2];
			}
			_materialIcon.url = PropsBasicManager.Instance.getURL(stone);
			var a:int = getMaxStoneNum(_nextLevel);;
			var b:int = PropsDyManager.instance.getPropsQuantity(stone);
			_maxNeed = Math.min(a,b);
			_numStep.maximum = _maxNeed;
			_numStep.value = Math.min(4,b);
			onPer100Change();
			onStoneNumChange();
		}
		
		/**
		 * 检查钱币 
		 * 
		 */
		private function checkMoney():void
		{
			var needMoney:int = _moneyPer*_nextLevel;
			var roleVO:RoleSelfVo = DataCenter.Instance.roleSelfVo;
			_moneyTxt.text = LangBasic.noteUse+needMoney;
			if(needMoney > roleVO.note+roleVO.silver){
				_checks[0] = false;
				_moneyTxt.textColor = 0xFF0000;
			}else{
				_checks[0] = true;
				_moneyTxt.textColor = _moneyBakColor;
			}
		}
		
		/**
		 * 刷新属性 
		 * @param sp
		 * @param scaleValue
		 * 
		 */
		private function updateValues(sp:Sprite,scaleValue:Number):void
		{
			Xdis.getTextChild(sp,"value1_txt").text = Math.round(CharacterDyManager.Instance.propArr[ExtraAttr.EA_HEALTH_LIMIT]*scaleValue).toString();
			Xdis.getTextChild(sp,"value2_txt").text = Math.round(CharacterDyManager.Instance.propArr[ExtraAttr.EA_PHYSIC_DEFENSE]*scaleValue).toString();
			Xdis.getTextChild(sp,"value3_txt").text = Math.round(CharacterDyManager.Instance.propArr[ExtraAttr.EA_MAGIC_DEFENSE]*scaleValue).toString();
		}
		
		/**
		 * 刷新身上装备 
		 * 
		 */
		public function updateSelf():void
		{
			var arr:Array = CharacterDyManager.Instance.getEquipDict().values();
			updateTileList(_selfTileList,arr);
		}
		
		/**
		 * 更新TileList 
		 * @param list
		 * @param arr
		 * 
		 */
		private function updateTileList(list:TileList,arr:Array):void
		{
			list.removeAll();
			if(arr == null) return;
			var vo:EquipDyVo;
			var len:int = arr.length;
			var basicVO:EquipBasicVo;
			var item:Object;
			for(var i:int=0;i<len;i++){
				vo = arr[i];
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO){
					if(basicVO.can_enhance == 1 && vo.enhance_level < maxStrengthenLevel){
						item = {};
						item.vo = vo;
						item.basicVO = basicVO;
						list.addItem(item);
					}
				}
			}
		}
		
		/**
		 * 刷新背包 
		 * 
		 */
		public function updateBag():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquips();
			updateTileList(_bagTileList,arr);
		}
		
		/**
		 * 点击强化按钮 
		 * @param event
		 * 
		 */
		private function onStrengthenBtnClick(event:MouseEvent):void
		{
			var pos:int = EquipDyManager.instance.getEquipPos(EquipDyVo(_nowOn[0]).equip_id);
			ModuleManager.forgetModule.strengthenEquip(pos,_numStep.value);
		}
		
		/**
		 * 切换100%多选按钮 
		 * @param event
		 * 
		 */
		protected function onPer100Change(event:Event=null):void
		{
			if(_perCheckBox.selected == true){
				_numStep.enabled = false;
				_bakNum = _numStep.value;
				_numStep.value = _maxNeed;
			}else{
				_numStep.enabled = true;
			}
		}
		
		/**
		 * 反算出当前装备等级达到100%成功率需要多少石头 
		 * @param level
		 * @return 
		 * 
		 */
		public function getMaxStoneNum(level:int):int
		{
			return StrRatioManager.Instance.get100SuccQuantity(level);
		}
		
		/**
		 * 计算当前成功率 
		 * @param level
		 * @param stoneCount
		 * @return 
		 * 
		 */
		public function getSuccessPercent(level:int,stoneCount:int):Number
		{
			return StrRatioManager.Instance.getSuccRate(level,stoneCount);
		}
		
	}
}