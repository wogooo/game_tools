package app
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.center.update.TweenMountGuideManager;
	import com.YFFramework.core.center.update.TweenMovingManager;
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.login.manager.ChatConnnection;
	import com.YFFramework.game.core.scence.ScenceInitManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.res.CommonFla;
	import com.net.NetManager;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/** socket 已经连接成功
	 * @author yefeng
	 * 2013 2013-8-20 下午3:34:33 
	 */
	public class AllInit
	{
		public function AllInit()
		{
			initAll();
		}
		private function initAll():void
		{
			
			CommonFla.initUI();
			CommonFla.initTexture();
			PoolFactory.initYF2dProgressBarPool();
			//////初始化UI组件
			var mainInit:MainInit=new MainInit();
			addEvents();
			onResize();
//				ScenceManager.Instance.enterScence(ScenceInitManager.GameLogin);
			//			initInfo();
			ScenceManager.Instance.enterScence(ScenceInitManager.GameOn);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GameIn);
			if(ChatConnnection.isConnnect)  //如果  聊天服务器已经连接成功 
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatCheckOK);
			}
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
		
		
		private function addEvents():void
		{
			///登陆   成功 进入场景
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
			if(UpdateTT.AnalysseIt<=0)
			{
				UpdateManager.Instance.update();
			}
		}
		
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
	}
}