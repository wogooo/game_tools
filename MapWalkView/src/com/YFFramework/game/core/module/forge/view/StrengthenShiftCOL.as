package com.YFFramework.game.core.module.forge.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
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
	import com.YFFramework.game.core.module.ModuleManager;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.TabsMovieClipManager;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.ExtraAttr;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StrengthenShiftCOL
	{
		//强化最大等级
		public static var maxStrengthenLevel:int = 12;
		
		private var _ui:Sprite;
		private var _bagTileList:TileList;
		private var _selfTileList:TileList;
		private var _enhanceTileList:TileList;
		private var _tabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _materialTabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _equipIcon:IconImage;
		private var _materialIcon:IconImage;
		private var _nowOn:Array = [];
		private var _warnMC:MovieClip;
		private var _toVO:EquipDyVo;
		private var _shiftButton:Button;
		
		
		public function StrengthenShiftCOL(targetUI:Sprite)
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
			_enhanceTileList.itemRender = EquipStrengthenItemRender;
			_enhanceTileList.addEventListener(Event.CHANGE,onEnhanceChange);
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_materialIcon = Xdis.getChild(_ui,"material_iconImage");
			_warnMC = Xdis.getChild(_ui,"warn_mc");
			_shiftButton = Xdis.getChild(_ui,"shift_button");
			_shiftButton.addEventListener(MouseEvent.CLICK,onShiftBtnClick);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.EquipEnhanceLevelChange,onLevelChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
			updateSelf();
			updateBag();
			checkBtnAbleClick();
		}
		
		public function reset():void
		{
			_nowOn = [];
			_toVO = null;
			_equipIcon.clear();
			_materialIcon.clear();
			resetValues(Xdis.getChild(_ui,"now_mc"));
			resetValues(Xdis.getChild(_ui,"next_mc"));
			_warnMC.visible = true;
			checkBtnAbleClick();
		}
		
		private function onLevelChange(event:YFEvent):void
		{
			onBagChange(event);
		}
		
		protected function onShiftBtnClick(event:MouseEvent):void
		{
			var nowOnVO:EquipDyVo = _nowOn[0];
			var from:int = EquipDyManager.instance.getEquipPos(nowOnVO.equip_id);
			var to:int = EquipDyManager.instance.getEquipPos(_toVO.equip_id);
			ModuleManager.forgetModule.shiftEquipStrengthen(from,to);
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
								Alert.show(LangBasic.equipShiftPutFromBindUnable,LangBasic.equipUpdate);
								return;
			}
			putEquipOn(vo,list.selectedItem.basicVO);
		}
		
		/**
		 * 选中目标装备 
		 * @param event
		 * 
		 */
		protected function onEnhanceChange(event:Event):void
		{
			var list:TileList = event.currentTarget as TileList;
			var vo:EquipDyVo = list.selectedItem.vo;
			if(vo.binding_attr == 2 || vo.binding_attr == 3){
				Alert.show(LangBasic.equipShiftPutToBindUnable,LangBasic.equipUpdate);
				return;
			}
			_toVO =vo;
			var basicVO:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_toVO.template_id);
			_materialIcon.url = EquipBasicManager.Instance.getURL(basicVO.template_id);
			updateValues(Xdis.getChild(_ui,"next_mc"),getValuesScale(_toVO.enhance_level));
			checkBtnAbleClick();
		}
		
		private function checkBtnAbleClick():void
		{
			if(_nowOn.length > 0 && _toVO != null){
				_shiftButton.enabled = true;
			}else{
				_shiftButton.enabled = false;
			}
		}
		
		/**
		 * 更新强化石列表 
		 * 
		 */
		public function updateEnhance():void
		{
			if(_nowOn.length < 2) return;
			var len:int;
			var i:int;
			var arr:Array = [];
			var bag:Array = BagStoreManager.instantce.getAllEquips();
			arr = bag.concat();
			var all:Array = [];
			len = arr.length;
			var vo:EquipDyVo;
			var nowOnVO:EquipDyVo = _nowOn[0];
			for(i=0;i<len;i++){
				vo = arr[i];
				if(vo.enhance_level < nowOnVO.enhance_level){
					all.push(vo);
				}
			}
			updateTileList(_enhanceTileList,all,false);
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
			updateEnhance();
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
			_warnMC.visible = false;
			updateValues(Xdis.getChild(_ui,"now_mc"),getValuesScale(vo.enhance_level));
			updateEnhance();
			checkBtnAbleClick();
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
		
		private function resetValues(sp:Sprite):void
		{
			Xdis.getTextChild(sp,"value1_txt").text = "";
			Xdis.getTextChild(sp,"value2_txt").text = "";
			Xdis.getTextChild(sp,"value3_txt").text = "";
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
		 * 更新TileList 
		 * @param list
		 * @param arr
		 * 
		 */
		private function updateTileList(list:TileList,arr:Array,isCheck:Boolean = true):void
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
					if( (basicVO.can_enhance == 1 && vo.enhance_level > 0)  || isCheck == false){
						item = {};
						item.vo = vo;
						item.basicVO = basicVO;
						list.addItem(item);
					}
				}
			}
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
		
	}
}