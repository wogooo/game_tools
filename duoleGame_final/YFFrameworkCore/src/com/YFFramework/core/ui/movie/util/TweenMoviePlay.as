package com.YFFramework.core.ui.movie.util
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	
	import flash.utils.getTimer;
	

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午12:24:04
	 */
	public class TweenMoviePlay extends YFDispather
	{
		public var loop:Boolean;
		public var frameRate:Number;//帧频
		private var _playArr:Vector.<BitmapDataEx>;
		
		/**是否已经播放
		 */
		private var _isStart:Boolean;
		private var _playIndex:Number;
		
		private var _position:Number;
		private var _timer:Number;
		private var _playFunc:Function;
		
		private var arrLen:Number;
		
		
		/**是否能够播放
		 */
		private var _canPlay:Boolean;
		
		/**  播放BitmapDataEx对象  
		 */		
		public function TweenMoviePlay()
		{
		}
		
		/**playArr[i] 是  playFunc的参数
		 */
		public function  initData(playArr:Vector.<BitmapDataEx>,frameRate:Number=100,loop:Boolean=true):void
		{
			_playArr=playArr;
			_isStart=false;
			_timer=0;
			_position=0;
			this.loop=loop;
			this.frameRate=frameRate;
			arrLen=playArr.length;
		}
		public function setPlayFunc(playFunc:Function):void
		{
			_playFunc=playFunc;
		}

		public function start(playIndex:Number=0):void
		{
			_playIndex=playIndex;
			_isStart=true;
			_canPlay=false;
			_timer=getTimer();
//			play();
			_playFunc(_playArr[_playIndex]);
		}
		/**  继续播放 在原来的基础上继续播放
		 */		
		public function  continuePlay():void
		{
			_isStart=true;
			_timer=getTimer();
//			play();
			_playFunc(_playArr[_playIndex]);
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
		
		public function  gotoAndStop(index:Number):void
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
//					dispose();
//					dispatchEventWith(YFEvent.Complete);
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
				///循环   
				while(_position>=frameRate*_playArr[_playIndex].delay)
				{
					if(_playIndex<arrLen)
					{
						
						_position -=frameRate*_playArr[_playIndex].delay;
						++_playIndex;
						_canPlay=true;
						if(loop&&_playIndex>=arrLen)
						{
							_playIndex=_playIndex%arrLen;
						}
						else if(_playIndex>=arrLen)
						{
							dispose();
							dispatchEventWith(YFEvent.Complete);
							return ;
						}
//						play();	
					}
					else 
					{
						dispose();
						dispatchEventWith(YFEvent.Complete);
						return;
					}
				}
				if(_canPlay)
				{
//					play();	
					_playFunc(_playArr[_playIndex]);
					_canPlay=false;
				}
				
			}
		}
		
		
//		private function play():void
//		{
//			_playFunc(_playArr[_playIndex]);
//
//		}
		
		public function getPlayIndex():int
		{
			return _playIndex;
		}

		
		public function dispose():void
		{
			_playArr=null;
			loop=false
			frameRate=0;//帧频
			_isStart=false
			_playIndex=0;
			_position=0;
			_timer=0;
			arrLen=0;

		}
		
	}
}