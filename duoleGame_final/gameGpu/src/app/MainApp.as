package app
{
	
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.center.update.TweenMountGuideManager;
	import com.YFFramework.core.center.update.TweenMovingManager;
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.login.view.SocketSelectView;
	import com.YFFramework.game.core.module.sceneUI.view.exception.DisConnectView;
	import com.YFFramework.game.core.scence.ScenceInitManager;
	import com.YFFramework.game.debug.Log;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.res.CommonFla;
	import com.net.NetEvent;
	import com.net.NetManager;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class MainApp 
	{
		
		private var mainInit:MainInit;
		
		public function MainApp()
		{
		}
		
		public function initApp():void
		{
			var controller:ControlInit=new ControlInit();
		//	showSocketSelectView();
//			initGameStart("192.168.1.48",6961,10906);
			initGameStart(ConfigManager.Instance.selectIp,ConfigManager.Instance.port,ConfigManager.Instance.checkport);

		}
		/**显示选择socket频道
		 */			
		private function showSocketSelectView():void
		{
			var selectView:SocketSelectView=new SocketSelectView();
			selectView.popUp();
			selectView.centerWindow();
//			selectView.open();
			selectView.callBack=initGameStart;
			selectView.initData(ConfigManager.Instance.socketArr);
//			print(this,"tttt");
		}
		/**游戏启动
		 */		
		private function initGameStart(ip:String,port:int,checkPort:int):void
		{
			ConfigManager.Instance.selectIp=ip;
			NetManager.gameSocket.addEventListener(NetEvent.ON_CONNECT,onSocketConenct);     
			NetManager.gameSocket.addEventListener(NetEvent.ON_DISCONNECT,onSocketConenct);       
			NetManager.gameSocket.addEventListener(NetEvent.ON_ERROR_CODE,onSocketConenct);  
			NetManager.gameSocket.connect(ip,port,checkPort);
//			print(this,ConfigManager.Instance.getIp().toString(),ConfigManager.Instance.getPort(),ConfigManager.Instance.getCheckPort());
			print(this,"开始连接...",ip.toString(),port,checkPort);
			Log.Instance.v("开始连接服务器");
		}
		
		/** 服务器连接成功开始登陆
		 */
		private function initSocket():void
		{
			//发送数据
			NetManager.gameSocket.sendBytes(ConfigManager.Instance.getMaintTencentBytes());
			initYf2d();
		}
		
		private function initYf2d():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_First_CREATE,onContext3dCreate);
			YF2d.Instance.initData(StageProxy.Instance.stage,0x000000);
		}
		private function onContext3dCreate(e:YF2dEvent):void
		{
			CommonFla.initUI();
			CommonFla.initTexture();
			PoolFactory.initYF2dProgressBarPool();
			//////初始化UI组件
			mainInit=new MainInit();
			addEvents();
			onResize();
			ScenceManager.Instance.enterScence(ScenceInitManager.GameLogin);
			initInfo();
			
		}
		
		
		private function initInfo():void
		{
			var label:YFLabel=new YFLabel();
			label.text=YF2d.Instance.getDriverInfo();
			label.width=200;
			label.exactWidth();
			LayerManager.DebugLayer.addChild(label);
			label.x=400;
			label.y=5
			label.exactWidth();
		}

		private function onSocketConenct(e:YFEvent):void
		{
			switch(e.type)
			{
				case NetEvent.ON_CONNECT:
					initSocket();
					print(this,"连接成功....");
					Log.Instance.v("连接成功....");

					break;
				case NetEvent.ON_DISCONNECT:
					print(this,"服务器已经关闭");
//					YFAlert.show("服务器已经关闭","提示:",0);
					DisConnectView.Instance.show();
					Log.Instance.v("服务器已经关闭....");

					break;
				case NetEvent.ON_ERROR_CODE:
//					YFAlert.show("服务器错误码","提示:",0);
					print(this,"服务器已经关闭");
					DisConnectView.Instance.show();
					Log.Instance.v("服务器已经关闭....");
					break;
			}
		}
		
		private function addEvents():void
		{
			///登陆   成功 进入场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.Login,onEnterScence);
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
			
			var  timer:Timer=new Timer(25);//new Timer(UpdateManager.IntervalRate+1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			
			//渲染动画
			StageProxy.Instance.stage.addEventListener(Event.ENTER_FRAME,onFrame);
			
//			var t:Timer=new Timer(UpdateManager.IntervalRate);
//			t.addEventListener(TimerEvent.TIMER,onMove);
//			t.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if(UpdateTT.AnalysseIt==0)
			{
				UpdateManager.Instance.update();
			}

//			if(UpdateTT.AnalysseIt==0)
//			{
//				UpdateManager.Instance.update();
//			}
		}
		
//		private function onMove(e:TimerEvent):void
//		{
//			TweenMovingManager.Instance.update();
//		}

//		private var _t:Number;
//		private var _preT:Number;
		private function onFrame(e:Event):void
		{
			YF2d.Instance.render();
			TweenMovingManager.Instance.update();
			if(UpdateTT.AnalysseIt<=0)
			{
				MovieUpdateManager.Instance.update();
				TweenMountGuideManager.Instance.update();
			}
			else 
			{
				UpdateTT.AnalysseIt--
//				YF2dAnalysse.AnalysseIt=false; 
			}
			NetManager.handleMessage();
		}
		
		private function onResize(e:Event=null):void
		{
			YF2d.Instance.resizeScence(StageProxy.Instance.getWidth(),StageProxy.Instance.getHeight());
			ResizeManager.Instance.resize();
		}
		private function onEnterScence(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.Login,onEnterScence);
			//游戏成功登陆后启动游戏
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GameIn,e.param);
		}
		
	}
}