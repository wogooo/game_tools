package com.YFFramework.game.core.module.login
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	import com.YFFramework.game.core.module.login.model.LoginVo;
	import com.YFFramework.game.core.module.login.model.proto.CMDLogin;
	import com.YFFramework.game.core.module.login.view.LoginView;
	import com.YFFramework.game.core.scence.ScenceInitManager;
	import com.YFFramework.game.core.scence.TypeScence;
	
	/**2012-8-2 下午12:43:29
	 *@author yefeng
	 */
	public class ModuleLogin extends AbsModule
	{
		private var _loginView:LoginView;
		public function ModuleLogin()
		{
			super();
			_belongScence=TypeScence.ScenceLogin;
		}
		override public function show():void
		{
			initUI();
			addEvents();
		}
		
		private function initUI():void
		{
			_loginView=new LoginView();
		}
		private function addEvents():void
		{
			//发送socket 数据
			_loginView.addEventListener(LoginEvent.C_Login,onSendSocket);
			
			//接受socket 返回回来的数据
			YFEventCenter.Instance.addEventListener(LoginEvent.S_Login,onRevSocket);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_loginView.dispose();
			_loginView=null;
		}
		
		/**发送socket 数据
		 */		
		private function onSendSocket(e:ParamEvent):void
		{
			switch(e.type)
			{
				case LoginEvent.C_Login:
					var vo:LoginVo=e.param as LoginVo
					YFSocket.Instance.sendMessage(CMDLogin.C_LOGIN,vo);
					break;
			}
		}
		
		/**接受socket 返回回来的数据
		 */		
		private function onRevSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case LoginEvent.S_Login:
					var loginVo:LoginVo=e.param as LoginVo;
					ScenceManager.Instance.enterScence(ScenceInitManager.GameOn);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.Login,loginVo);
					break;
				
			}
		}
		

	}
}