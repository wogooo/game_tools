package com.YFFramework.core.utils.tween.simple
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	/**
	 * author :夜枫
	 */
	[event(name="complete",type="flash.events.Event")] ///当停止播放时触发
	public class TimeTween extends EventDispatcher
	{
		
		///释放循环执行
		public var loop:Boolean;

		protected var _funcArr:Vector.<Function>;
		protected var _timeArr:Vector.<Number>;
		protected var _params:Array;///函数参数
		protected var _position:Number;
		protected var _time:Number;
		protected var _intervalTime:Number;
		protected var _index:int;//当前播放索引
		protected var _isStart:Boolean;
		
		protected var len:int;
		/** 时间间隔为毫秒
		 * funcArr 执行函数   timeArr执行时间间隔,也就是每一个函数执行后所要停留等待的时间   函数的参数数组  每一个函数 代表一个
		 */
		public function TimeTween(funcArr:Vector.<Function>,timeArr:Vector.<Number>,params:Array=null,loop:Boolean=false)
		{
			this._funcArr=funcArr;
			this._timeArr=timeArr;
			this.loop=loop;
			_params=params;
			len=funcArr.length;
		}
		/**
		 * @param index  播放的位置   index 在[0,timeArr.length-1]之间
		 */		
		public function start(index:int=0):void
		{
			_position=0;
			_isStart=true;
			_index=index;
			_time=getTimer();
			//执行函数
			play();
		}
		public function stop():void
		{
			_isStart=false;
		}
		
		///播放index 索引函数
		protected function play():void
		{
			if(_params) //如果带参数
				_funcArr[_index](_params[_index]);
			else _funcArr[_index]();
		}
		public function update():void
		{
			if(_isStart&&_index<len)
			{
				var t:Number=_time;
				_time=getTimer();
				var dif:Number=_time-t;
				_position +=dif;
				if(_position>=_timeArr[_index]) ////播放下一个
				{
					
					++_index;
					_position=0;
					if(loop) _index=_index%len;
					else if(_index>=len) 
					{
						sendEvent();
						return ;
					}
					play();
				}
			}
		}
		
		
		public function dispose():void
		{
			_funcArr=null;
			_timeArr=null;
			
		}
		protected function  sendEvent():void
		{
			if(hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}