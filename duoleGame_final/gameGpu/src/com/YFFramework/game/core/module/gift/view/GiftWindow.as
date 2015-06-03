package com.YFFramework.game.core.module.gift.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.gift.manager.New_player_giftBasicManager;
	import com.YFFramework.game.core.module.gift.model.New_player_giftBasicVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	import com.msg.enumdef.MoneyType;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/***
	 *礼包窗口
	 *@author ludingchang 时间：2013-9-10 上午11:44:34
	 */
	public class GiftWindow extends Window
	{
		private static const UIName:String="giftUI";
		/**总共有多少个页签*/
		private static const TAB_num:int=6;
		/**tabUI一次移动多少像素*/
		private static const EachWith:Number=108;
		private static const TAB_BG_URL:String="gift/tab_bg.png";
		private static const TITTLE_URL:String="gift/tittle.png";

		private var _ui:Sprite;
		private var _tabs:TabsManager;
		private var _tabsUI:Sprite;
		private var _toLeft:SimpleButton;
		private var _toRight:SimpleButton;
		/**一个的tab位置的tab编号*/
		private var _firstIndex:int=1;
		/**一次显示的tab个数*/
		private var ShowTabsNum:int=5;
		/**tabui正在移动*/
		private var _isMoving:Boolean;
		
		private var _signView:SignPackageView;
		
		private var _tab_bg:Sprite;
		private var _tittle_img:Sprite;
		
		public function GiftWindow()
		{
			_ui=initByArgument(708,550,UIName,null,true,DyModuleUIManager.giftBg);
			setContentXY(28.5,29);
			
			_tabsUI=Xdis.getChild(_ui,"tabs");
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,_tabsUI,TAB_num);
			var tabs_sp:Array=new Array;
			var tab1:Sprite;
			for(var i:int=1;i<=TAB_num;i++)
			{
				tab1=Xdis.getChild(_tabsUI,"gift"+i);
				tab1.mouseChildren=false;
				tab1.mouseEnabled=false;
				tabs_sp.push(tab1);
				var giftVo:New_player_giftBasicVo=New_player_giftBasicManager.Instance.getNew_player_giftBasicVo(i);
				var name1:TextField=tab1.getChildByName("name_txt") as TextField;
				name1.text=giftVo.name;
				var icon1:IconImage=Xdis.getChild(tab1,"icon_iconImage");
				icon1.url=URLTool.getGoodsIcon(giftVo.icon_id);
			}
			
			_tab_bg=Xdis.getSpriteChild(_ui,"tab_bg");
			_tittle_img=Xdis.getSpriteChild(_ui,"tittle_img");
			var tab_bg_loader:UILoader=new UILoader;
			tab_bg_loader.initData(URLTool.getDyModuleUI(TAB_BG_URL),_tab_bg);
			var tittle_img_loader:UILoader=new UILoader;
			tittle_img_loader.initData(URLTool.getDyModuleUI(TITTLE_URL),_tittle_img);
			
			_signView=new SignPackageView(Xdis.getChild(_ui,"tabView1"));
			
			_toLeft=Xdis.getChildAndAddClickEvent(moveToLeft,_ui,"toLeft");
			_toRight=Xdis.getChildAndAddClickEvent(moveToRight,_ui,"toRight");
			checkMoveBtnEnable();
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onIndexChange);
		}
		
		protected function onIndexChange(e:Event=null):void
		{
			switch(_tabs.nowIndex)
			{
				case 1://新手礼包
					_signView.update();
					break;
			}
		}
		private function onOpen():void
		{
			switch(_tabs.nowIndex)
			{
				case 1://新手签到礼包
					_signView.onOpen();
					break;
			}
		}
		
		private function moveToRight(e:MouseEvent):void
		{
			if(_isMoving)
				return;
			// TODO 将tabUI右移
			TweenLite.to(_tabsUI,0.3,{x:_tabsUI.x-EachWith,onComplete:onCom});
//			_tabsUI.x+=EachWith;
			_firstIndex++;
			_isMoving=true;
			checkMoveBtnEnable();
		}
		
		private function moveToLeft(e:MouseEvent):void
		{
			if(_isMoving)
				return;
			// TODO 将tabUI左移
//			_tabsUI.x -=EachWith;
			TweenLite.to(_tabsUI,.3,{x:_tabsUI.x+EachWith,onComplete:onCom});
			_firstIndex--;
			_isMoving=true;
			checkMoveBtnEnable();
		}
		
		private function onCom():void
		{
			_isMoving=false;
		}
		
		/**检测是左右移动按钮是否可点*/
		private function checkMoveBtnEnable():void
		{
			// TODO 判断左边是否还有按钮未显示的，是就左移按钮可点击，否就不可点击
			//右移按钮同理
			
			UI.setEnable(_toLeft,_firstIndex>1);
			UI.setEnable(_toRight,_firstIndex+ShowTabsNum-1<TAB_num);
		}
		
		override public function open():void
		{
			onOpen();
			onIndexChange();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GiftUiUpdate);
			super.open();
		}
		
		override public function update():void
		{
			if(isOpen)
				onIndexChange();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GiftUiUpdate);
		}
		
		public function doMoveEff():void
		{
			switch(_tabs.nowIndex)
			{
				case 1://新手签到礼包
					_signView.doMoveEff();
					break;
			}
		}
	}
}