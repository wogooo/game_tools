package utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import manager.BitmapDataEx;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午12:24:04
	 */
	public class TweenPlay extends EventDispatcher
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
		/** 循环总次数
		 */
		private var _loopTimes:int;
		
		/**当前循环 
		 */
		private var _currentLoop:int;
		

		public var isDispose:Boolean;
		/**  播放BitmapDataEx对象  
		 */		
		public function TweenPlay()
		{
			
		}
		
		/**playArr[i] 是  playFunc的参数
		 */
		public function  initData(playFunc:Function,playArr:Vector.<BitmapDataEx>,frameRate:int=100,loop:Boolean=true,times:int=1):void
		{
			isDispose=false;
			_playArr=playArr;
			_isStart=false;
			_timer=0;
			_playFunc=playFunc;
			_position=0;
			this.loop=loop;
			this.frameRate=frameRate;
			arrLen=playArr.length;
			_currentLoop=times;
		}
		public function start(playIndex:int=0):void
		{
			_playIndex=playIndex;
			_isStart=true;
			_timer=getTimer();
			_currentLoop=0;
			play();
		}
		/**  继续播放 在原来的基础上继续播放
		 */		
		public function  continuePlay(loopTime:int):void
		{
			_loopTimes=loopTime;
			_currentLoop=0;
			_isStart=true;
			_timer=getTimer();
			_playIndex=_playIndex%arrLen;
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
//		public function update():void
//		{
//			if(_isStart)
//			{
//				var dif:Number=getTimer()-_timer;
//				_position +=dif;
//				_timer=getTimer();
//				if(_playIndex<arrLen)
//				{
//					if(_position>=frameRate*_playArr[_playIndex].delay) 
//					{
//						++_playIndex;
//						if(loop&&_playIndex>=arrLen)_playIndex=_playIndex%arrLen;
//						if(_playIndex>=arrLen) return ;
//						play();	
//						_position=0;
//					}
//				}
//				else 
//				{
//					if(hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
//				}
//			}
//		}
		
		
		public function update():void
		{
			if(_isStart)
			{
				var dif:Number=getTimer()-_timer;
				_position +=dif;
				_timer=getTimer();
				var canPlay:Boolean=false;
				///循环   
				while(_position>=frameRate*_playArr[_playIndex].delay)
				{
					if(_playIndex<arrLen)
					{
						canPlay=true;
						_position -=frameRate*_playArr[_playIndex].delay;
						++_playIndex;
						if(!loop) //不循环
						{
							if(_playIndex>=arrLen)
							{
								_currentLoop+=int(_playIndex/arrLen);
								if(_currentLoop<_loopTimes)  //继续播放
								{
									_playIndex=_playIndex%arrLen;
								}
								else 
								{
									dispose();
									dispatchEvent(new Event(Event.COMPLETE));
									return ;
								}
							}
						}
						else 
						{
							if(_playIndex>=arrLen)
							{
								_playIndex=_playIndex%arrLen;
							}
						}
					}
					else 
					{
						dispose();
						dispatchEvent(new Event(Event.COMPLETE));
					}
				}
				if(canPlay)	play();	
			}
		}
		
		
		
		
		private function play():void
		{
			_playFunc(_playArr[_playIndex]);			

		}
		
		public function dispose():void
		{
//			_playArr=null;
//			_playFunc=null;
//			_position=0;
			_isStart=false;
			isDispose=true;
		}
		
	}
}