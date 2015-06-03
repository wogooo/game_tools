package com.YFFramework.game.core.module.sceneUI.view.exception
{
	/**@author yefeng
	 * 2013 2013-4-18 下午4:08:13 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;

	/**登录异常  其他玩家登录该帐号
	 */	
	public class LoginException extends AbsView
	{
		private static var _instance:LoginException;
		public function LoginException()
		{
			super(false);
		}
		public static function get Instance():LoginException
		{
			if(_instance==null)_instance=new LoginException();
			return _instance;
		}
		public function show():void
		{
			Alert.show("该帐号在其他地方重新登录","异常登录",click,["重新登录"]);
		}
		private function click(e:AlertCloseEvent):void
		{
			var request:URLRequest=new URLRequest(ConfigManager.Instance.webHost);
//			request.data=ConfigManager.Instance.getURLVariables();
			request.method=URLRequestMethod.GET;
			navigateToURL(request,"_self");
		}

	}
}