package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * 一个每秒运行的计时器，主要用于tips里有关时间的实时更细
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2014-1-14 上午9:45:08
	 */
	public class TimerDispather
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:TimerDispather;
		
		private var _timer:Timer;
		private var _funcDict:Dictionary;
		private var _funs_count:int=0;//字典长度
		//======================================================================
		//        constructor
		//======================================================================
		
		public function TimerDispather()
		{
			_timer=new Timer(ActivityData.MILLISECOND);
			_timer.addEventListener(TimerEvent.TIMER,runAllFunc);
			_timer.start();
			_funcDict=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function addFunc(type:String,func:Function):void
		{
			if(!_funcDict.hasOwnProperty(type))
				_funs_count++;
			_funcDict[type]=func;
			if(!_timer.running)
				_timer.start();
		}
		
		public function delFunc(type:String):void
		{
			if(_funcDict.hasOwnProperty(type))
				_funs_count--;
			_funcDict[type]=null;
			delete _funcDict[type];
			if(_funs_count<=0)
				_timer.stop();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function runAllFunc(e:TimerEvent):void
		{
			for(var type:String in _funcDict)
			{
				_funcDict[type]();
			}
		}
		
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
		public static function get instance():TimerDispather
		{
			if(_instance==null) _instance=new TimerDispather();
			return _instance;
		}

	}
} 