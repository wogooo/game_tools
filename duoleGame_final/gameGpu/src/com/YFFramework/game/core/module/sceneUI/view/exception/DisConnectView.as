package com.YFFramework.game.core.module.sceneUI.view.exception
{
	/**@author yefeng
	 * 2013 2013-4-18 下午2:29:01 
	 */
	import com.YFFramework.core.center.manager.update.YFTimer;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.gameConfig.ConfigManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;

	/** 断网 服务器断开连接后弹出的面板
	 */	
	public class DisConnectView extends AbsView
	{
		private var _mc:MovieClip;
		private var _richText:RichText;
		private var _waitCount:int=30;///等待30s
		
		private static  var _instance: DisConnectView;
		public function DisConnectView()
		{
			super(false);
		}
		public static function get Instance():DisConnectView
		{
			if(_instance==null) _instance=new DisConnectView();
			return _instance;
		}
		override protected function initUI():void
		{
			super.initUI();
		//	_mc=ClassInstance.getInstance("DisconectUI") as MovieClip;
			_mc=new DisconectUI();
			addChild(_mc);
			_mc.reloadMC.buttonMode=true;
			_mc.reloadMC.mouseChildren=false;
				
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_mc.reloadMC.addEventListener(MouseEvent.CLICK,onClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_mc.reloadMC.removeEventListener(MouseEvent.CLICK,onClick);
		}
		///刷新网页重新载入
		private function onClick(e:MouseEvent=null):void
		{
			var request:URLRequest=new URLRequest(ConfigManager.Instance.webHost);
//			request.data=ConfigManager.Instance.getURLVariables();
			request.method=URLRequestMethod.GET;
			navigateToURL(request,"_self"); 
		}
		
		public function show():void
		{
			var timer:YFTimer=new YFTimer(1000,_waitCount);
			timer.updateFunc=update;
			timer.updateParam=timer;
			timer.completeFunc=onClick;
			timer.start();
			PopUpManager.addPopUp(this,null,0,0,0x336699,0.5);
			PopUpManager.centerPopUp(this);
		}
		private function update(timer:YFTimer):void
		{
			var count:int=timer.currentCount;
			_mc.reConectTxt.text=count+"秒后将自动为您连接";
		}
		
			
	}
}