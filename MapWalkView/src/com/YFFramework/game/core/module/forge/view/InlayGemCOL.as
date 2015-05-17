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
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.TabsMovieClipManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.PropsType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 宝石镶嵌 
	 * @author flashk
	 * 
	 */
	public class InlayGemCOL
	{
		public static var maxStrengthenLevel:int = 12;
		
		private var _ui:Sprite;
		private var _tabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _materialTabs:TabsMovieClipManager = new TabsMovieClipManager();
		private var _bagTileList:TileList;
		private var _selfTileList:TileList;
		private var _enhanceTileList:TileList;
		private var _nowOn:Array = [];
		private var _equipIcon:IconImage;
		private var _holeMax:int = 8;
		private var _holes:Array = [];
		private var _holeIcons:Array = [];
		private var _nowOnGems:Array = [];
		private var _hasLength:int = 0;
		private var _nowMaxHole:int;
		private var _inlayButton:Button;
		
		public function InlayGemCOL(targetUI:Sprite)
		{
			_ui = targetUI;
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			_materialTabs.initTabs(_ui,"tabsMaterial_sp",1,"materialView");
			_bagTileList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagTileList.itemRender = InlayGemEquipItemRender;
			_bagTileList.addEventListener(Event.CHANGE,onEqListChange);
			_selfTileList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_selfTileList.itemRender = InlayGemEquipItemRender;
			_selfTileList.addEventListener(Event.CHANGE,onEqListChange);
			_enhanceTileList = Xdis.getChild(_ui,"materialView1","equipsBox_tileList");
			_enhanceTileList.itemRender = InlayGemItemRender;
			_enhanceTileList.addEventListener(Event.CHANGE,onEnhanceChange);
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_inlayButton = Xdis.getChild(_ui,"inlay_button");
			_inlayButton.addEventListener(MouseEvent.CLICK,onInlayBtnClick);
			for(var i:int=0;i<_holeMax;i++){
				_holes.push(Xdis.getChild(_ui,"gem"+(i+1)));
				_holeIcons.push(Xdis.getChild(_ui,"gem"+(i+1),"icon_iconImage"));
			}
			YFEventCenter.Instance.addEventListener(GlobalEvent.EquipGemChange,onBagChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
			updateBag();
			updateSelf();
		}
		
		protected function onInlayBtnClick(event:MouseEvent):void
		{
			if(_nowOnGems.length == _hasLength){
				Alert.show(LangBasic.noGem,LangBasic.equipUpdate);
				return;
			}
			for(var i:int=_hasLength;i<_nowOnGems.length;i++){
				var equPos:int = EquipDyManager.instance.getEquipPos(EquipDyVo(_nowOn[0]).equip_id);
				var inlayPos:int = i;
				var gemPos:int = PropsDyManager.instance.getPropsPostion(PropsDyVo(_nowOnGems[inlayPos]).propsId);
				ModuleManager.forgetModule.inlayGem(equPos,inlayPos,gemPos);
			}
		}
		
		/**
		 * 背包切换选中 
		 * @param event
		 * 
		 */
		private function onBagChange(event:YFEvent):void
		{
			updateBag();
			updateSelf();
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
		 * 刷新背包 
		 * 
		 */
		public function updateBag():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquips();
			updateTileList(_bagTileList,arr);
			updateGem();
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
					var nowCount:int = countHole(vo);
					if( nowCount < basicVO.hole_number){
						item = {};
						item.vo = vo;
						item.basicVO = basicVO;
						item.now = nowCount;
						list.addItem(item);
					}
				}
			}
		}
		
		/**
		 * 更新宝石列表 
		 * 
		 */
		public function updateGem():void
		{
			var i:int;
			var len:int;
			var item:Object;
			var vo:PropsDyVo;
			var pbvo:PropsBasicVo;
			var arr:Array = [];
			var all:Array = BagStoreManager.instantce.getAllProps();
			len = all.length;
			for(i=0;i<len;i++){
				vo = all[i];
				pbvo = PropsBasicManager.Instance.getPropsBasicVo(vo.templateId);
				if(pbvo.type == PropsType.PROPS_TYPE_GEM){
					arr.push(vo);
				}
			}
			arr.sortOn("templateId",Array.NUMERIC);
			len = arr.length;
			len = arr.length;
			_enhanceTileList.removeAll();
			for(i=0;i<len;i++){
				item = {};
				item.vo = arr[i];
				_enhanceTileList.addItem(item);
			}
		}
	
		/**
		 * 选中宝石 
		 * @param event
		 * 
		 */
		protected function onEnhanceChange(event:Event):void
		{
			var list:TileList = event.currentTarget as TileList;
			var vo:PropsDyVo = _enhanceTileList.selectedItem.vo;
			if(_nowOnGems.length >= _nowMaxHole){
				Alert.show(LangBasic.equipGemNoHole,LangBasic.equipUpdate);
				return;
			}
			if(checkGemNone(vo) == true){
				Alert.show(LangBasic.gemHasNone,LangBasic.equipUpdate);
				return;
			}
			IconImage(_holeIcons[_nowOnGems.length]).url = PropsBasicManager.Instance.getURL(vo.templateId);
			_nowOnGems.push(vo);
		}
		
		private function checkGemNone(vo:PropsDyVo):Boolean
		{
			var onvo:PropsDyVo;
			var count:int=0;
			for(var i:int=_hasLength;i<_nowOnGems.length;i++){
				onvo = _nowOnGems[i];
				if(onvo.templateId == vo.templateId){
					count ++;
				}
			}
			var max:int = PropsDyManager.instance.getPropsQuantity(vo.templateId);
			if( (count+1) > max ) return true;
			return false;
		}
		
		private function countHole(vo:EquipDyVo):int
		{
			var count:int=0;
			if(vo.gem_1_id != 0){
				count++;
			}
			if(vo.gem_2_id != 0){
				count++;
			}
			if(vo.gem_3_id != 0){
				count++;
			}
			if(vo.gem_4_id != 0){
				count++;
			}
			if(vo.gem_5_id != 0){
				count++;
			}
			if(vo.gem_6_id != 0){
				count++;
			}
			if(vo.gem_7_id != 0){
				count++;
			}
			if(vo.gem_8_id != 0){
				count++;
			}
			return count;
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
				Alert.show(LangBasic.equipInlayBindUnable,LangBasic.equipUpdate);
				return;
			}
			putEquipOn(vo,list.selectedItem.basicVO);
		}
		
		private function showHoleNum(num:int):void
		{
			_nowMaxHole = num;
			var len:int = _holes.length;
			for(var i:int=0;i<len;i++){
				UI.setEnable(Sprite(_holes[i]),false);
				Sprite(_holes[i]).alpha = 0.5;
			}
			for(i=0;i<num;i++){
				UI.setEnable(Sprite(_holes[i]),true);
				Sprite(_holes[i]).alpha = 1;
			}
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
			_hasLength = countHole(vo);
			showHoleNum(basicVO.hole_number);
			_nowOnGems = [];
			clearIcons();
			checkOneIcon(vo.gem_1_id,1);
			checkOneIcon(vo.gem_2_id,2);
			checkOneIcon(vo.gem_3_id,3);
			checkOneIcon(vo.gem_4_id,4);
			checkOneIcon(vo.gem_5_id,5);
			checkOneIcon(vo.gem_6_id,6);
			checkOneIcon(vo.gem_7_id,7);
			checkOneIcon(vo.gem_8_id,8);
		}
		
		private function checkOneIcon(id:int,index:int):void
		{
			if(id != 0){
				var dyvo:PropsDyVo = PropsDyManager.instance.getPropsInfo(id);
				_nowOnGems[index-1] = dyvo;
				IconImage(_holeIcons[index-1]).url = PropsBasicManager.Instance.getURL(dyvo.templateId);
			}
		}
		
		private function clearIcons():void
		{
			var len:int = _holeIcons.length;
			for(var i:int=0;i<len;i++){
				IconImage(_holeIcons[i]).clear();
			}
		}
		
	}
}