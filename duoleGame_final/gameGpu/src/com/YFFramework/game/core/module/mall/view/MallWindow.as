package com.YFFramework.game.core.module.mall.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-27 下午3:18:15
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.YFFramework.game.core.module.shop.view.ShopPageControl;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ComboBox;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class MallWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const TAB_MAX:int=7;
		
		private var _mc:MovieClip;
		
		private var _tabsManager:TabsManager;
		
		private var diamondTxt:TextField;
		private var couponTxt:TextField;
		
		private var _panels:Vector.<MallPageControl>;
//		private var _panelIdAry:Array;
//		private var _pageControl:MallPageControl;
		
//		private var _tabViews:Array = [];
		private var _npcSp:Sprite;
//		private var _searchCombo:ComboBox;
//		private var _searchInputTxt:TextField;
//		private var _searchBtn:Button;
		
		/**充值按钮*/
		private var _payBtn:SimpleButton;
		//======================================================================
		//        constructor
		//======================================================================
		public function MallWindow()
		{
			_mc = initByArgument(725,580,"mall",WindowTittleName.mallTitle,true,DyModuleUIManager.guildMarketWinBg) as MovieClip;
			setContentXY(29,28);
			
			_tabsManager = new TabsManager();
//			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
//			var _toogleBtn:MovieClip = _mc.tabs_sp;
			_panels=new Vector.<MallPageControl>();
			var page:MallPageControl;
			for(var i:int=1;i<=TAB_MAX;i++)
			{
				page=new MallPageControl();
				_panels.push(page);
				_mc.addChild(page);
				_tabsManager.add(Xdis.getChild(_mc,"tabs_sp","tab"+i),page,Xdis.getChild(_mc,"tabs_sp","tabTxt"+i));			
//				var view:MallPageControl=new MallPageControl(_mc.pageList);
//				_panels.push(view);
			}
			
//			_pageControl=new MallPageControl(_mc.pageList);
			diamondTxt=Xdis.getTextChild(_mc,"mozuanTxt");
			Xtip.registerTip(diamondTxt,NoticeUtils.getStr(NoticeType.Notice_id_100013));
			
			couponTxt=Xdis.getTextChild(_mc,"liquanTxt");
			Xtip.registerTip(couponTxt,NoticeUtils.getStr(NoticeType.Notice_id_100015));
			
			_npcSp=Xdis.getChild(_mc,'npcPic');
//			_panelIdAry=[];
			
//			_searchCombo = Xdis.getChild(_mc,"search_comboBox");
//			_searchCombo.rightSpace = 0;
//			_searchCombo.setSize(_searchCombo.compoWidth,_searchCombo.compoHeight);
//			_searchCombo.editable = true;
//			_searchCombo.dropdown.addEventListener(Event.CHANGE,onInputSearch);
//			_searchInputTxt = _searchCombo.inputTextField;
//			
//			TextInputUtil.initDefautText(_searchInputTxt,NoticeUtils.getStr(NoticeType.Notice_id_100036));
			
//			_searchInputTxt.addEventListener(TextEvent.TEXT_INPUT,onInputChnage);
//			_searchInputTxt.addEventListener(Event.CHANGE,onInputChnage);
//			_searchInputTxt.addEventListener(FocusEvent.FOCUS_IN,onInputChnage);
//			
//			_searchBtn=Xdis.getChild(_mc,"search_button");
//			_searchBtn.addEventListener(MouseEvent.CLICK,onSearch);
			
			updateMoney();
//			NPCShopBasicManager.Instance.getMallItemsName();
			_payBtn=Xdis.getSimpleButtonChild(_mc,"pay_btn");
			_payBtn.addEventListener(MouseEvent.CLICK,onPayOpen);
		}
		
		protected function onPayOpen(event:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.Recharge);
		}		
		
		//======================================================================
		//        public function
		//======================================================================
		public function updateMoney():void
		{
			diamondTxt.text=DataCenter.Instance.roleSelfVo.diamond.toString();
			couponTxt.text=DataCenter.Instance.roleSelfVo.coupon.toString();
		}
		
		override public function open():void
		{
			super.open();
//			var tabIndexAry:Array=ShopBasicManager.Instance.getShopTabsLength(ShopBasicManager.MallId);
//			for each(var i:int in tabIndexAry)
//			{
//				showTabAt(i);
//			}
//			showSearch();//显示搜索界面的搜索结果
			if(_npcSp.numChildren == 0)
			{
				var loader:UILoader=new UILoader();
				loader.initData(DyModuleUIManager.mallNpcBg,_npcSp,DyModuleUIManager.mallNpcBg);
				
				//这是第一次加载，要把所有数据加载出来，因为tab上的文字显示
				for(var i:int=1;i<=TAB_MAX;i++)
				{
					showTabAt(i);
				}
				
			}
			_tabsManager.switchToTab(1);
		}
		
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-85,UI.stage.stageHeight-70,0.02,0.04);
		}
		//======================================================================
		//        private function
		//======================================================================
//		private function onTabChange(e:Event=null):void
//		{
//			var index:int=_tabsManager.nowIndex;
//			
//		}
		
		private function showTabAt(tabIndex:int):void
		{
			var data:Vector.<ShopBasicVo>;
			data = ShopBasicManager.Instance.getDataByIDAndTab(ShopBasicManager.MallId,tabIndex);
			_panels[tabIndex-1].updateList(data);
			_tabsManager.labelTxts[tabIndex-1].text = data[0].tab_label;
		}

//		private function showSearch():void
//		{
//			if(_searchInputTxt.text.indexOf(NoticeUtils.getStr(NoticeType.Notice_id_100036)) == -1 || _searchInputTxt.text.indexOf("") == -1)
//			{
//				var data:Vector.<ShopBasicVo>=ShopBasicManager.Instance.getSearchResult(_searchInputTxt.text);
//				_panels[6].updateList(data);
//				if(data.length == 0)
//					_panels[6].showNoResult(true);
//				else
//					_panels[6].showNoResult(false);
//			}
//			else
//				_panels[6].showNoResult(false);
//		}
//		
//		private function showSearchResult():void
//		{
//			showSearch();
//			_tabsManager.switchToTab(TAB_MAX);
//		}
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 随着输入文字的改变，下拉菜单也随之改变 
		 * @param event
		 * 
		 */		
//		private function onInputChnage(event:Event=null):void
//		{
//			if(_searchInputTxt.text != '')
//			{
//				var item:ListItem;
//				_searchCombo.rowCount = 15;
//				_searchCombo.removeAll();
//				
//				var nameAry:Array=ShopBasicManager.Instance.getDynamicSearch(_searchInputTxt.text);
//				for each(var name:String in nameAry)
//				{
//					item = new ListItem();
//					item.label = name;
//					_searchCombo.addItem(item);
//				}
//				_searchCombo.popList();
//			}
//			
//		}
		
		/**
		 * 选择某个名字就进行搜索，给出结果 
		 * @param e
		 * 
		 */		
//		public function onInputSearch(e:Event):void
//		{
//			showSearchResult();
//		}
//		
//		private function onSearch(e:MouseEvent):void
//		{
//			showSearchResult();
//		}
		//======================================================================
		//        getter&setter
		//======================================================================
	}
} 