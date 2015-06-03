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
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EnhenceStoneRender;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.forge.view.simpleView.SophisticationItem;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-6 下午2:08:01
	 */
	public class EquipSophistication
	{
		//======================================================================
		//       public property
		//======================================================================
		public  var curEquipDyVo:EquipDyVo;//因为服务端不会发来装备id
		//======================================================================
		//       private property
		//======================================================================
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		
		private var _bagEquipsList:TileList;
		private var _characterEquipsList:TileList;
		private var _materiallList:TileList;		
		private var _equipIcon:IconImage;
		private var _moneyTxt:TextField;
		private var _sophiBtn:Button;
		private var _equipName:TextField;
		
		/** 切换到这个面板，背包改变才更新 */		
		private var _update:Boolean=false;		
		private var _attrItems:Vector.<SophisticationItem>;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EquipSophistication(targetUI:Sprite)
		{
			_ui = targetUI;
			
			_bagEquipsList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagEquipsList.itemRender = EquipItemRender;
			_bagEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_characterEquipsList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_characterEquipsList.itemRender = EquipItemRender;
			_characterEquipsList.setSelfDeselect(true);
			_characterEquipsList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_materiallList = Xdis.getChild(_ui,"equipsBox_tileList");
			_materiallList.itemRender = EnhenceStoneRender;//跟强化石头一样
			
			var sophiItem:SophisticationItem;
			_attrItems=new Vector.<SophisticationItem>();
			var btnName:String;
			var btn:Button;
			for(var i:int=1;i<=4;i++)
			{
				btnName="lock"+i+"_button";
				btn=Xdis.getChild(_ui,btnName)
				sophiItem=new SophisticationItem(i,Xdis.getChild(_ui,"attr"+i),Xdis.getChild(_ui,"attrV"+i),btn);
				_attrItems.push(sophiItem);
			}
			
			_equipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_equipIcon.addEventListener(MouseEvent.CLICK,onClickEquip);
			
			_equipName=Xdis.getChild(_ui,"equipName");
			_moneyTxt=Xdis.getChild(_ui,"money");
			_moneyTxt.selectable=false;
			_moneyTxt.text='';
			
			_sophiBtn=Xdis.getChild(_ui,"sophi_button");
			_sophiBtn.addEventListener(MouseEvent.CLICK,onSophiClick);
			_sophiBtn.enabled=false;
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,checkSophBtn);
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				updateAllList();
			}		
		}
		
		public function resetPanel():void
		{
			clearLeftPanel();
			_tabs.switchToTab(1);
			_bagEquipsList.clearAllSelection();
			_characterEquipsList.clearAllSelection();
			_update=false;
		}
		
		public function updateAllList(e:YFEvent=null):void
		{
			if(_update == false) return;
			
			updateBagEquipsList();
			updateCharacterList();
			updateMaterialList();
			
			if(curEquipDyVo)//如果有之前的缓存数据，则在背包和身上找，找不到再删
			{
				var index1:int=_bagEquipsList.findDataIndex(curEquipDyVo,"vo");		
				if(index1 > -1)
				{
					_bagEquipsList.selectedIndex=index1;
					_bagEquipsList.scrollToIndex(index1);
				}
				else
				{
					var index2:int=_characterEquipsList.findDataIndex(curEquipDyVo,"vo");
					if(index2 > -1)
					{
						_characterEquipsList.selectedIndex = index2;
						_characterEquipsList.scrollToIndex(index2);
					}
					else
					{
						clearLeftPanel();
					}	
				}
			}
		}
		
		/** 锁定或解锁某个属性
		 * @param attrType
		 * @param lock 
		 */		
		public function lockOrNotAttr(attrType:int,lock:Boolean,index:int):void
		{
			if(curEquipDyVo == null) return;
			_attrItems[index].lock=lock;			
			updateMoney();			
		}
		
		public function updateMaterialList():void
		{
			_materiallList.removeAll();
			
			var item:Object;
			var vo:PropsBasicVo;

			item = {};
			var tmpId:int=ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_EQUIP_SOPHI);
			item.vo = PropsBasicManager.Instance.getPropsBasicVo(tmpId);
			item.count = PropsDyManager.instance.getPropsQuantity(tmpId);
			item.isBuyClick=false;
			_materiallList.addItem(item);		
		}
		
		public function checkSophBtn():void
		{
			var money:int=checkMoney();
			if(curEquipDyVo && DataCenter.Instance.roleSelfVo.note >= money)
				_sophiBtn.enabled=true;
			else
				_sophiBtn.enabled=false;
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function checkMoney():int
		{
			var count:int=0;
			var money:int=0;
			for(var i:int=0;i<4;i++)
			{
				if(_attrItems[i].lock)
					count++;
			}
			
			if(count == 0)
				money=5000;
			else if(count == 1)
				money = 10000;
			else if(count == 2)
				money = 20000;
			else 
				money = 50000;
			return money;
		}
		
		/** 更新金钱后也要看看是不是符合按钮可用要求
		 */		
		private function updateMoney():void
		{
			var money:int=checkMoney();
			if(DataCenter.Instance.roleSelfVo.note >= money)
				_moneyTxt.text="消耗银锭："+money;
			else
				_moneyTxt.htmlText=HTMLUtil.createHtmlText("消耗银锭："+money,12,"ff0000");
			
			checkSophBtn();
		}
		
		/** 清除装备图标、名字；当前装备信息；不可用洗练按钮；清除所有属性，锁定按钮不可用 ;身上背包栏不选中;清除钱*/		
		private function clearLeftPanel():void
		{			
			_equipIcon.clear();
			Xtip.clearLinkTip(_equipIcon);		
			curEquipDyVo=null;
			_equipName.text='';
			checkSophBtn();
			_moneyTxt.text='';
			clearAttrs();
		}
		
		private function clearAttrs():void
		{
			for(var i:int=0;i<4;i++)
			{
				_attrItems[i].clearAttr();
				_attrItems[i].enabledBtn(false);
			}
		}
		
		/**刷新身上装备  */
		private function updateCharacterList():void
		{
			var arr:Array = CharacterDyManager.Instance.getEquipDict().values();
			updateTileList(_characterEquipsList,arr,true);
		}
		
		/**刷新背包list */
		private function updateBagEquipsList():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			updateTileList(_bagEquipsList,arr);
		}
		
		private function updateTileList(list:TileList,ary:Array,isSelf:Boolean=false):void
		{
			list.removeAll();
			
			var basicVO:EquipBasicVo;			
			var equips:Array=[];
			
			for each(var vo:EquipDyVo in ary)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS && basicVO.quality >= TypeProps.QUALITY_BLUE 
					&& basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY &&
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
		
		//======================================================================
		//        event handler
		//======================================================================
		/** 切换装备后要做的事：1.洗练按钮可用；2.图标、名字显示；3.显示洗练属性
		 */		
		protected function onEquipListChange(event:Event):void
		{	
			var list:TileList = event.currentTarget as TileList;
			curEquipDyVo = list.selectedItem.vo;
			
			_equipIcon.clear();
			Xtip.clearLinkTip(_equipIcon);
			_equipIcon.url=EquipBasicManager.Instance.getURL(curEquipDyVo.template_id);
			Xtip.registerLinkTip(_equipIcon,EquipTipMix,TipUtil.equipTipInitFunc,curEquipDyVo.equip_id,curEquipDyVo.template_id);
			
			var bsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(curEquipDyVo.template_id);
			_equipName.htmlText=HTMLUtil.createHtmlText(bsVo.name,12,TypeProps.getQualityColor(bsVo.quality));
			
			clearAttrs();
			for(var i:int=0;i<4;i++)
			{
				_attrItems[i].init(curEquipDyVo);
			}
			
			updateMoney();
			checkSophBtn();
		}
		
		private function onClickEquip(e:MouseEvent):void
		{
			clearLeftPanel();
			_bagEquipsList.clearAllSelection();
			_characterEquipsList.clearAllSelection();
		}
		
		private function onSophiClick(e:MouseEvent):void
		{
			var pos:int;
			pos=EquipDyManager.instance.getEquipPosFromRole(curEquipDyVo.equip_id);
			if(pos == 0)
				pos=EquipDyManager.instance.getEquipPosFromBag(curEquipDyVo.equip_id);
			ModuleManager.forgetModule.equipSophiReq(pos);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 