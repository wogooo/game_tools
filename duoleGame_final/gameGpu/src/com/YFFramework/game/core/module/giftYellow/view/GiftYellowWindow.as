package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.module.giftYellow.model.TypeVipGift;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/***
	 *黄钻礼包主窗口
	 *@author ludingchang 时间：2013-12-6 下午2:47:06
	 */
	public class GiftYellowWindow extends Window
	{
		/**黄钻特权*/
		public static const Tab_Id_SpecialRight:int=1;
		/**黄钻新手*/
		public static const Tab_Id_NewPlayer:int=2;
		/**黄钻每日*/
		public static const Tab_Id_DayGift:int=3;
		/**tab个数*/
		private static const TAB_num:int=3;
		
		private static const UIName:String="UI_giftyellow";
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		private var _tabsUI:Sprite;
		
		/**特权页面*/
		private var _sr:SpecialRightView;
		/**黄钻新手礼包*/
		private var _newPlayer:NewPlayerView;
		/**黄钻每日礼包*/
		private var _dayGift:DayGiftView;
		public function GiftYellowWindow()
		{
			super(NoneBg)
			_ui=ClassInstance.getInstance(UIName) as Sprite;
			AutoBuild.replaceAll(_ui);
			bgUrl=DyModuleUIManager.giftYellowBG;
			content=_ui;
			setSize(666,495);
			_tabs=new TabsManager;
			_tabs.initTabs(_ui,_ui,TAB_num);
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onIndexChange);
			
			
			_sr=new SpecialRightView(_ui["tabView1"]);
			_newPlayer=new NewPlayerView(_ui["tabView2"]);
			_dayGift=new DayGiftView(_ui["tabView3"]);
			closeButton.x=589;
			closeButton.y=72;
		}
		
		protected function onIndexChange(event:Event=null):void
		{
			switch(_tabs.nowIndex)
			{
				case Tab_Id_SpecialRight:
					_sr.update();
					break;
				case Tab_Id_NewPlayer:
					_newPlayer.update();
					break;
				case Tab_Id_DayGift:
					_dayGift.update();
					break;
			}
		}
		
		public function doIconMoveEff(type:int):void
		{
			switch(type)
			{
				case TypeVipGift.NEW_PLAYER_GIFT:
					if(_tabs.nowIndex==Tab_Id_NewPlayer)
						_newPlayer.doIconMoveEff();
					break;
				case TypeVipGift.DAY_GIFT:
					if(_tabs.nowIndex==Tab_Id_DayGift)
						_dayGift.doRowMoveEff();
					break;
				case TypeVipGift.YEAR_DAY_GIFT:
					if(_tabs.nowIndex==Tab_Id_DayGift)
						_dayGift.doYearIconMoveEff();
					break;
			}
		}
		
		override public function update():void
		{
			onIndexChange();
		}
		
		override public function open():void
		{
			update();
			super.open();
		}
		
		/**
		 * 切换到tab id 对应的视图
		 * @param tab_index: Tab_Id_xxx 本类定义的
		 * 
		 */		
		public function updateTo(tab_index:int):void
		{
			super.open();
			_tabs.switchToTab(tab_index);
		}
		
		public override function dispose():void
		{
			_sr.dispose();
			_sr=null;
			
			_newPlayer.dispose();
			_newPlayer=null;
			
			_dayGift.dispose();
			_dayGift=null;
			
			super.dispose();
		}
	}
}