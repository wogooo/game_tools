package app
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.loginNew.events.LoginNewEvent;
	import com.YFFramework.game.core.module.sceneUI.view.exception.DisConnectView;
	import com.YFFramework.game.debug.Log;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.net.NetEvent;
	import com.net.NetManager;

	/**
	 * 游戏 socket连接 以及yf2d 的初始化 
	 * @author yefeng
	 * 2013 2013-8-19 下午5:30:10 
	 */
	public class GameSocketConnection
	{
		public function GameSocketConnection()
		{
//			initGameStart();
		}
		/**游戏启动
		 */		
		public function initGameStart():void
		{
			NetManager.gameSocket.addEventListener(NetEvent.ON_CONNECT,onSocketConenct);     
			NetManager.gameSocket.addEventListener(NetEvent.ON_DISCONNECT,onSocketConenct);       
			NetManager.gameSocket.addEventListener(NetEvent.ON_ERROR_CODE,onSocketConenct);  
			NetManager.gameSocket.connect(ConfigManager.Instance.selectIp,ConfigManager.Instance.port,ConfigManager.Instance.checkport);
			
			print(this,"开始连接...",ConfigManager.Instance.selectIp,ConfigManager.Instance.port,ConfigManager.Instance.checkport);
//			Log.Instance.v("开始连接服务器");
			
		}
		private function onSocketConenct(e:YFEvent):void
		{
			switch(e.type)
			{
				case NetEvent.ON_CONNECT:
					init();
					print(this,"连接成功....");
//					Log.Instance.v("连接成功....");
					break;
				case NetEvent.ON_DISCONNECT:
					print(this,"服务器已经关闭");
					//					YFAlert.show("服务器已经关闭","提示:",0);
					DisConnectView.Instance.show();
					Log.Instance.v("服务器已经关闭....");
//					RegisterView.Instance.socketCloseCall();
					break;
				case NetEvent.ON_ERROR_CODE:
					//					YFAlert.show("服务器错误码","提示:",0);
					print(this,"服务器已经关闭");
					DisConnectView.Instance.show();
					Log.Instance.v("服务器错误验证码....");
//					RegisterView.Instance.socketCloseCall();
					break;
			}
		}

		private function init():void
		{
			//发送数据
			NetManager.gameSocket.sendBytes(ConfigManager.Instance.getMaintTencentBytes());
				//判断登录是否为新手
				//开始去连接socket 
			YFEventCenter.Instance.dispatchEventWith(LoginNewEvent.BeginConnectSocket);
		}
		
	
		
		
		
	}
}