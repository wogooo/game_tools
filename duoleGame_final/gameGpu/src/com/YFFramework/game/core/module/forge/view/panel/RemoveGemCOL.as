package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 宝石摘除
	 * @author flashk
	 * 
	 */
	public class RemoveGemCOL
	{
		public static var gemNum:int;
		
		private const MAX_HOLES:int = 8;
		
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		
		private var _bagEquipList:TileList;
		private var _characterEquipList:TileList;
		
		private var _curEquipDyVo:EquipDyVo;
		private var _equipIcon:IconImage;
		
		/**
		 * 左侧八个宝石图标的iconImage 
		 */		
		private var _holes:Array = [];
		private var _holeIcons:Array = [];
		/**
		 * 保存已镶嵌宝石的icon和数据（bsVo、pos、remove）
		 */	
		private var _curGemsDict:Dictionary;
//		private var _curGemsAry:Array = [];
		/**
		 * 选中装备的已镶嵌宝石数量 
		 */		
//		private var _curEquipInlayGemsNum:int = 0;
		private var _removeButton:Button;
		
		private var _update:Boolean;
		
		public function RemoveGemCOL(targetUI:Sprite)
		{			
			_ui = targetUI;
			
			_bagEquipList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagEquipList.itemRender = EquipItemRender;
			_bagEquipList.setSelfDeselect(true);
			_bagEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_characterEquipList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_characterEquipList.itemRender = EquipItemRender;
			_characterEquipList.setSelfDeselect(true);
			_characterEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			
			_removeButton = Xdis.getChild(_ui,"inlay_button");
			_removeButton.addEventListener(MouseEvent.CLICK,onRemoveBtnClick);
			
			for(var i:int=0;i<MAX_HOLES;i++)
			{
				_holes.push(Xdis.getChild(_ui,"gem"+(i+1)));
				Sprite(_holes[i]).addEventListener(MouseEvent.CLICK,onHoleClick);
				_holeIcons.push(Xdis.getChild(_ui,"gem"+(i+1),"icon_iconImage"));
			}
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			
			_curGemsDict=new Dictionary();
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
			
			resetPanel();
		
		}

		
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				updateBagList();
				updateCharacterList();
				putEquipOn();
			}
		}
		
		/**
		 * 清除面板上的信息 
		 * 
		 */		
		public function resetPanel():void
		{
			clearLeftPanel();
			
			_bagEquipList.clearSelection();
			_characterEquipList.clearSelection();
			
			_tabs.switchToTab(1);
			_update=false;
			
			checkRemoveBtn();
		}
		
		public function clearLeftPanel():void
		{
			_curEquipDyVo=null;
			
			_equipIcon.clear();
			Xtip.clearLinkTip(_equipIcon);
			
			showOneEquipCanInlaidHoles(MAX_HOLES);

			_curGemsDict=new Dictionary();
			clearAllIcon();	
		}
		
		private function onHoleClick(e:MouseEvent):void
		{
			if(_curEquipDyVo == null) return;
			
			if(e.target is IconImage)
			{
				var icon:IconImage = e.target as IconImage;
				var gemInfo:Object=_curGemsDict[icon];
				if(gemInfo.remove)
				{
					icon.filters=null;
					gemInfo.remove=false;
				}
				else
				{
					icon.filters=FilterConfig.Yellow_Small_Filter;
					gemInfo.remove=true;
				}
			}
			checkRemoveBtn();
		}
		
		protected function onRemoveBtnClick(event:MouseEvent):void
		{
			var removeGems:Array=[];//存放将要摘除的宝石信息，位置和数组的index是对应的
			var removeNum:int=0;//摘除多少个宝石
			
			for each(var gemInfo:Object in _curGemsDict)
			{
				if(gemInfo.remove)
				{
					removeGems[gemInfo.pos]=1;
					removeNum++;
				}
			}
			
			if(removeNum > BagStoreManager.instantce.remainBagNum())//背包空间不足，无法摘除
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);
				return;
			}
			
			var equipPos:int;
			var bvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			if(EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id) != 0)
			{
				equipPos = EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id);
			}
			else
			{
				equipPos = bvo.type;
			}
			
			gemNum=removeGems.length;
			for(var i:int=0;i<gemNum;i++)
			{
				if(removeGems[i] != null)
				{
					ModuleManager.forgetModule.removeGem(equipPos,i);
				}
			}
		}
		
		/**
		 * 背包或装备有任何改变就全部刷新
		 * @param event
		 * 
		 */
		public function updateAllList(event:YFEvent=null):void
		{
			if(_update == false) return;
			
			updateBagList();
			updateCharacterList();
			
			_bagEquipList.updateNow();
			_characterEquipList.updateNow();
			
			if(_curEquipDyVo)//如果有之前的缓存数据，则在背包和身上找，找不到再删
			{
				var index1:int=_bagEquipList.findDataIndex(_curEquipDyVo,"vo");		
				if(index1 > -1)
				{
//					_bagEquipList.isDispatchEvnet=false;
					_bagEquipList.selectedIndex=index1;
					_bagEquipList.scrollToIndex(index1);
				}
				else
				{
					var index2:int=_characterEquipList.findDataIndex(_curEquipDyVo,"vo");
					if(index2 > -1)
					{
//						_characterEquipList.isDispatchEvnet=false;
						_characterEquipList.selectedIndex = index2;
						_characterEquipList.scrollToIndex(index2);
					}
					else
					{
						clearLeftPanel();
					}
					
				}
			}
			
			checkRemoveBtn();
		}	
		
		/**
		 * 刷新身上装备 
		 * 
		 */
		private function updateCharacterList(event:Object=null):void
		{
			var arr:Array = CharacterDyManager.Instance.getEquipDict().values();
			updateTileList(_characterEquipList,arr,ForgeSource.SHOW_ENHANCE_LEVEL,true);
				
		}
		
		/**
		 * 刷新背包装备
		 * 
		 */
		private function updateBagList():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			updateTileList(_bagEquipList,arr,ForgeSource.SHOW_ENHANCE_LEVEL);
			
		}
		
		/**
		 * 更新装备和身上列表 
		 * @param list
		 * @param arr
		 * @param type
		 * 
		 */		
		private function updateTileList(list:TileList,arr:Array,showType:int,isSelf:Boolean=false):void
		{
			list.removeAll();
			
//			if(arr == null) return;
			
//			var vo:EquipDyVo;
//			var len:int = arr.length;
			var basicVO:EquipBasicVo;
			var item:Object;
			var equips:Array=[];
			for each(var vo:EquipDyVo in arr)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS)
				{
					var nowCount:int = countGems(vo);
					if(nowCount> 0){
						equips.push(vo);
						
					}
				}
			}
			
			equips=ForgeSource.orderContainEquips(equips);
			for each(vo in equips)
			{
				item = {};
				item.vo = vo;
				item.showType=ForgeSource.SHOW_GEMS;
				item.now = nowCount;
				if(isSelf)
					item.type=ForgeSource.CHARACTER;
				else
					item.type=ForgeSource.BAG;
				list.addItem(item);
			}
		}
		
		/**
		 * 查询指定装备已镶嵌宝石数量 
		 * @param vo
		 * @return 
		 * 
		 */		
		private function countGems(vo:EquipDyVo):int
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
		protected function onEquipListChange(event:Event):void
		{
			clearLeftPanel();
			
			var list:TileList = event.currentTarget as TileList;
			_curEquipDyVo = list.selectedItem.vo;
			
			if(list.selectedSp.select == false) return;
			
			putEquipOn();
			
			if(list == _bagEquipList){
				_characterEquipList.clearSelection();
			}else{
				_bagEquipList.clearSelection();
			}
			
//			checkRemoveBtn();
			
		}
		
		/**
		 * 显示装备孔数
		 * @param num
		 * 
		 */		
		private function showOneEquipCanInlaidHoles(num:int):void
		{		
			//先全部显示不可用一遍
			var len:int = _holes.length;
			for(var i:int=0;i<len;i++)
			{
				UI.setEnable(Sprite(_holes[i]),false);
				Sprite(_holes[i]).alpha = 0.5;
			}
			//再显示可以用的
			for(i=0;i<num;i++)
			{
				UI.setEnable(Sprite(_holes[i]),true);
				Sprite(_holes[i]).alpha = 1;
			}
		}
		
		/**
		 * 在背包或身上list选中某装备在左侧显示
		 * @param vo
		 * @param basicVO
		 * 
		 */
		public function putEquipOn():void
		{	
			if(_curEquipDyVo ==null) return;
			var basicVO:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			
			_equipIcon.url = EquipBasicManager.Instance.getURL(basicVO.template_id);
			
			if(EquipDyManager.instance.getEquipPosFromRole(_curEquipDyVo.equip_id) > 0)
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id,true);
			else
				Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id);
			
//			_curEquipInlayGemsNum = countGems(_curEquipDyVo);
			
			showOneEquipCanInlaidHoles(basicVO.hole_number);//显示宝石已有孔数
			
			var i:int=0;
			if(_curEquipDyVo.gem_1_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_1_id,i,0);
				i++;
			}
			if(_curEquipDyVo.gem_2_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_2_id,i,1);
				i++;
			}
			if(_curEquipDyVo.gem_3_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_3_id,i,2);
				i++;
			}
			if(_curEquipDyVo.gem_4_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_4_id,i,3);
				i++;
			}
			if(_curEquipDyVo.gem_5_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_5_id,i,4);
				i++;
			}
			if(_curEquipDyVo.gem_6_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_6_id,i,5);
				i++;
			}
			if(_curEquipDyVo.gem_7_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_7_id,i,6);
				i++;
			}
			if(_curEquipDyVo.gem_8_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_8_id,i,7);
				i++;
			}
		}
		
		/**
		 * 显示宝石图片，并生成宝石数据，和图片绑定
		 * @param gemId
		 * @param iconIndex
		 * @param gemPos
		 * 
		 */		
		private function showOneInlaidGem(gemId:int,iconIndex:int,gemPos:int):void
		{
			var icon:IconImage =_holeIcons[iconIndex];
			var bsVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(gemId);
			icon.url = PropsBasicManager.Instance.getURL(gemId);
			Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,gemId);
			
			var gemInfo:Object={};
			gemInfo.pos=gemPos;
			gemInfo.remove=false;
			
			_curGemsDict[icon]=gemInfo;
		}
		
		private function clearAllIcon():void
		{
			var len:int = _holeIcons.length;
			for(var i:int=0;i<len;i++)
			{
				IconImage(_holeIcons[i]).clear();
				Xtip.clearLinkTip(_holeIcons[i]);
				IconImage(_holeIcons[i]).filters=null;
			}
		}
		
		private function checkRemoveBtn():void
		{
			if(_curEquipDyVo)
			{
				var remove:Boolean=false;
				for each(var gemInfo:Object in _curGemsDict)
				{
					if(gemInfo.remove == true)
					{
						remove = true;
						break;
					}
				}
				if(remove)
					_removeButton.enabled=true;
				else
					_removeButton.enabled=false;
			}
			else
				_removeButton.enabled=false;
		}
	}
}