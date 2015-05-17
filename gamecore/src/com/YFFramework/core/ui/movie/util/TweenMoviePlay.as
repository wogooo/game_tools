package com.YFFramework.core.ui.movie.util
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午12:24:04
	 */
	public class TweenMoviePlay extends EventDispatcher
	{
		public var loop:Boolean;
		public var frameRate:int;//帧频
		private var _playArr:Vector.<BitmapDataEx>;
		
		/**是否已经播放
		 */
		private var _isStart:Boolean;
		private var _playIndex:int;
		
		private var _position:Number;
		private var _timer:Number;
		private var _playFunc:Function;
		
		private var arrLen:int;
		/**  播放BitmapDataEx对象  
		 */		
		public function TweenMoviePlay()
		{
		}
		
		/**playArr[i] 是  playFunc的参数
		 */
		public function  initData(playFunc:Function,playArr:Vector.<BitmapDataEx>,frameRate:int=100,loop:Boolean=true):void
		{
			_playArr=playArr;
			_isStart=false;
			_timer=0;
			_playFunc=playFunc;
			_position=0;
			this.loop=loop;
			this.frameRate=frameRate;
			arrLen=playArr.length;
		}
		public function start(playIndex:int=0):void
		{
			_playIndex=playIndex;
			_isStart=true;
			_timer=getTimer();
			play();
		}
		/**  继续播放 在原来的基础上继续播放
		 */		
		public function  continuePlay():void
		{
			_isStart=true;
			_timer=getTimer();
			play();

		}
		public function stop():void
		{
			_isStart=false;
		}
		
		public function nextPlay():void
		{
			gotoAndStop((_playIndex+1)%arrLen)
		}
		public function prePlay():void
		{
			gotoAndStop((_playIndex-1+arrLen)%arrLen);
		}
		
		public function  gotoAndStop(index:int):void
		{
			start(index);
			stop();
		}
		
		
		/**更新
		 */
		public function update():void
		{
			if(_isStart)
			{
				var dif:Number=getTimer()-_timer;
				_position +=dif;
				_timer=getTimer();
				if(_playIndex<arrLen)
				{
					if(_position>=frameRate*_playArr[_playIndex].delay) 
					{
						++_playIndex;
						if(loop&&_playIndex>=arrLen)_playIndex=_playIndex%arrLen;
						if(_playIndex>=arrLen) return ;
						play();	
						_position=0;
					}
				}
				else 
				{
				//	if(hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		private function play():void
		{
			_playFunc(_playArr[_playIndex]);

		}
		
		public function dispose():void
		{
			_playArr=null;
			_playFunc=null;

		}
		
	}
}