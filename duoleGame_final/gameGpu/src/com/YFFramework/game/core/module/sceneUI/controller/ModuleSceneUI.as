package com.YFFramework.game.core.module.sceneUI.controller
{
	/**@author yefeng
	 * 2013 2013-4-9 上午11:29:05 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.game.core.module.sceneUI.view.HideLoadingView;
	import com.YFFramework.game.core.module.sceneUI.view.exception.DisConnectView;
	import com.YFFramework.game.core.module.sceneUI.view.exception.LoginException;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.enumdef.ExceptionType;
	import com.msg.hero.SException;
	import com.net.MsgPool;
	import com.net.NetManager;

	/**场景 界面UI   主要处理 场景界面的 一些小UI     比如  一些图标处理     比如礼包      人物专职ui 等等
	 */	
	public class ModuleSceneUI extends AbsModule
	{

		public function ModuleSceneUI()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			var hideLoadingView:HideLoadingView=new HideLoadingView();

		}
		override public function init():void
		{
			addEvents();
			addSocketEvents();
		}
		
		private function addEvents():void
		{
			////玩家升级到十级  进行选角色
//			YFEventCenter.Instance.addEventListener(GlobalEvent.ShowSelectCareerWindow,onEventHandle);
			///检测人物是否转职
//			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onEventHandle);

		}
		private function addSocketEvents():void
		{
			//异常处理
			MsgPool.addCallBack(GameCmd.SException,SException,onException);
		}
		private function onException(sException:SException):void
		{
			switch(sException.code)
			{
				case ExceptionType.BE_RELOADED: //被重复登录  同一账号在其他敌方登录
					LoginException.Instance.show();
					break;
				case ExceptionType.SERVER_EXCEPTION: ///服务端异常  客户端刷新网页
					NetManager.close();//关闭socket
					DisConnectView.Instance.show();
					break;
			}
		}
		
//		private function onEventHandle(e:YFEvent):void
//		{
//			switch(e.type)
//			{
////				///弹出选职业面板
////				case GlobalEvent.ShowSelectCareerWindow:
////					popChangeCareerWindow();
////					break;
//				case SceneUIEvent.SelectCareer:  ///角色选职业
//					var career:int=int(e.param); 
//					var cChangeCareer:CChangeCareer=new CChangeCareer();  ///转职结果的接受在场景模块ModuleMapScene
//					cChangeCareer.newCareer=career;
//					MsgPool.sendGameMsg(GameCmd.CChangeCareer,cChangeCareer);
//					break;
////				case GlobalEvent.GameIn:  //检测人物是否转职 ，没有转职则进行转职
////					break;
//			}
//		}
		
		
	}
}