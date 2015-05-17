package com.YFFramework.core.movie3d.avartar
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	
	import flash.utils.getTimer;

	/**@author yefeng
	 *2013-3-24下午5:43:11
	 */
	public class TweenMeshMoviePlay extends YFDispather
	{
		
		private var loop:Boolean;
		private var _playArr:Vector.<MeshMovieData>;
		
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
		public function TweenMeshMoviePlay()
		{
		}
		
		public function initData(playFunc:Function,playArr:Vector.<MeshMovieData>,loop:Boolean=true):void
		{
			_playArr=playArr;
			_isStart=false;
			_timer=0;
			_playFunc=playFunc;
			_position=0;
			this.loop=loop;
			arrLen=playArr.length;
		}
		
		
		public function start(playIndex:Number=0):void
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
		
		public function  gotoAndStop(index:Number):void
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
					if(_position>=_playArr[_playIndex].exeTime) 
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
					//	dispatchEvent(new Event(Event.COMPLETE));
					dispose();
					dispatchEventWith(YFEvent.Complete);
					
				}
			}
		}
		
		private function play():void
		{
			_playFunc(_playArr[_playIndex]);
			
		}
		
		public function dispose():void
		{
			stop();
			_playArr=null;
			_playFunc=null;
			loop=false
			_isStart=false
			_playIndex=0;
			_position=0;
			_timer=0;
			arrLen=0;
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}