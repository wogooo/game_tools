package com.YFFramework.game.core.module.newGuide.manager
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.newGuide.view.scene.GuaJiView;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**挂机功能  计时器，处理挂机逻辑
	 * @author yefeng
	 * 2013 2013-7-30 下午5:51:28 
	 */
	public class GuaJiManager
	{
		private static var _instance:GuaJiManager;
		private var _timer:Timer;
		private var _start:Boolean;
		/**挂机回调
		 */		
		public var guajiCall:Function;
		
//		private var _handleIndex:int;
		public function GuaJiManager()
		{
			_timer=new Timer(1200);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		public function onTimer(e:TimerEvent=null):void
		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel&&_handleIndex>0) //处于新手引导阶段
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel) //处于新手引导阶段
			{
				var boo:Boolean=NewGuideManager.DoGuide();
				if(!boo)  //如果 没有触发主线 也就是没有主线任务的时候 触发 自动挂机
				{
					if(guajiCall!=null)guajiCall();
				}
			}
			else   //自动搜索打怪 
			{
//				++_handleIndex;
				if(guajiCall!=null)guajiCall();
			}
		}
		
		public static function get Instance():GuaJiManager
		{
			if(!_instance)_instance=new GuaJiManager();
			return _instance;
		}
		/**开始
		 */		
		public function start():void
		{
			if(!_start)
			{
				_start=true;
//				_handleIndex=handleIndex;
				_timer.start();
				GuaJiView.Instance.show();
				onTimer();
			}
		}
		/**停止
		 */		
		public function stop():void
		{
			if(_start)
			{
				_timer.stop();
				_start=false;
				GuaJiView.Instance.hide();
			}
		}
		/**切换
		 */		
		public function toggle():void
		{
			if(_start)stop();
			else start();
		}
		
		/**是否处在挂机中
		 */		
		public function getStart():Boolean
		{
			return _start;
		}
		
		
	}
}