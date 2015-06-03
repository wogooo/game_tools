package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *特权展示页面，
	 *@author ludingchang 时间：2013-12-6 下午3:01:09
	 */
	public class SpecialRightView
	{
		private static const BGURL:String="giftYellow/right.png";
		private var _ui:Sprite;
		/**前往黄钻新手礼包*/
		private var _goNewPlayer:SimpleButton;
		/**前往黄钻每日礼包*/
		private var _goDayGift:SimpleButton;
		/**开通黄钻*/
		private var _openYellow:SimpleButton;
		/**续费黄钻*/
		private var _renewalYellow:SimpleButton;
		/**开通年费黄钻*/
		private var _openYearYellow:SimpleButton;
		/**续费年费黄钻*/
		private var _renewalYearYellow:SimpleButton;
		private var _bg:Sprite;
		private var _loadBG:Boolean;
		
		public function SpecialRightView(ui:Sprite)
		{
			_ui=ui;
			_goNewPlayer=Xdis.getSimpleButtonChild(ui,"go_new_player");
			_goDayGift=Xdis.getSimpleButtonChild(ui,"go_day_gift");
			_openYellow=Xdis.getSimpleButtonChild(ui,"open_yellow");
			_renewalYellow=Xdis.getSimpleButtonChild(ui,"renewal_yellow");
			_openYearYellow=Xdis.getSimpleButtonChild(ui,"open_year_yellow");
			_renewalYearYellow=Xdis.getSimpleButtonChild(ui,"renewal_year_yellow");
			
			_goNewPlayer.addEventListener(MouseEvent.CLICK,onClick);
			_goDayGift.addEventListener(MouseEvent.CLICK,onClick);
			_openYellow.addEventListener(MouseEvent.CLICK,onClick);
			_renewalYellow.addEventListener(MouseEvent.CLICK,onClick);
			_openYearYellow.addEventListener(MouseEvent.CLICK,onClick);
			_renewalYearYellow.addEventListener(MouseEvent.CLICK,onClick);
			_bg=new Sprite;
			_bg.x=86;
			_bg.y=120;
			_ui.addChildAt(_bg,0);
		}
		
		public function update():void
		{
			var isYellow:Boolean=YellowAPIManager.Instence.yellow_vip_lv>0;
			_openYellow.visible=!isYellow;
			_renewalYellow.visible=isYellow;
			var isYearYellow:Boolean=YellowAPIManager.Instence.is_year_yellow;
			_openYearYellow.visible=!isYearYellow;
			_renewalYearYellow.visible=isYearYellow;
			
			if(_bg.numChildren==0&&_loadBG==false)
			{
				var url:String=URLTool.getDyModuleUI(BGURL);
				UILoader.initLoader(url,_bg);
				_loadBG=true;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case _goNewPlayer:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,GiftYellowWindow.Tab_Id_NewPlayer);
					break;
				case _goDayGift:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,GiftYellowWindow.Tab_Id_DayGift);
					break;
				case _openYellow:
				case _renewalYellow:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.CallOpenAPI);
					break;
				case _openYearYellow:
				case _renewalYearYellow:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.CallOpenYearAPI);
					break;
			}
		}
		
		public function dispose():void
		{
			_ui=null;
			if(_bg.parent)
				_bg.parent.removeChild(_bg);
			_bg=null;
			_goNewPlayer.removeEventListener(MouseEvent.CLICK,onClick);
			_goDayGift.removeEventListener(MouseEvent.CLICK,onClick);
			_openYellow.removeEventListener(MouseEvent.CLICK,onClick);
			_renewalYellow.removeEventListener(MouseEvent.CLICK,onClick);
			_openYearYellow.removeEventListener(MouseEvent.CLICK,onClick);
			_renewalYearYellow.removeEventListener(MouseEvent.CLICK,onClick);
			
			_goNewPlayer=null;
			_goDayGift=null;
			_openYellow=null;
			_renewalYellow=null;
			_openYearYellow=null;
			_renewalYearYellow=null;
		}
	}
}