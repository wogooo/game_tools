package com.YFFramework.core.center.manager.time
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/** timer对象池
	 * @author yefeng
	 * 2013 2013-7-12 上午11:51:48 
	 */
	public class TimerPool
	{
		/**
		 */		
		private var _timerDict:Dictionary;
		public function TimerPool()
		{
			_timerDict=new Dictionary();
		}
		
		public function getTimer(interval:int,callback:Function):Timer
		{
			var timer:Timer=new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			var timerObj:TimerObject=new TimerObject();
			timerObj.callBack=callback;
			timerObj.timer=timer;
			_timerDict[timer]=timerObj;
			return timer;
		}
		public function toPool(timer:Timer):void
		{
			
		}
		private function onTimer(e:TimerEvent):void
		{
			var timer:Timer=e.currentTarget as Timer;
			var timerObj:TimerObject=_timerDict[timer];
			timerObj.callBack();
		}
		
	}
}