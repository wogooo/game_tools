package com.YFFramework.core.ui.yf2d.tween
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	
	import flash.utils.getTimer;

	/**@author yefeng
	 *2012-11-17下午11:43:31
	 */
	public class TweenYF2dPlay extends YFDispather
	{
	
		private var loop:Boolean;
		private var frameRate:int;//帧频
		private var _playData:MovieData;
		
		/**是否已经播放
		 */
		private var _isStart:Boolean;
		private var _playIndex:int;
		
		private var _position:Number;
		private var _timer:Number;
		private var _playFunc:Function;
		
		/**用于镜像贴图
		 */ 
		private var _scaleX:Number;
		
		private var arrLen:int;
		/**  播放BitmapDataEx对象  
		 */		
		public function TweenYF2dPlay()
		{
		}
		
		/**playData是  playFunc的参数   playFunc是 updateTextureData
		 */
		public function  initData(playFunc:Function,playData:MovieData,scaleX:Number,frameRate:int=100,loop:Boolean=true):void
		{
			_playData=playData;
			_scaleX=scaleX;
			_isStart=false;
			_timer=0;
			_playFunc=playFunc;
			_position=0;
			this.loop=loop;
			this.frameRate=frameRate;
			arrLen=playData.dataArr.length;
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
					if(_position>=frameRate*_playData.dataArr[_playIndex].delay) 
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
			_playFunc(_playData.dataArr[_playIndex],_scaleX);
			
		}
		
		public function dispose():void
		{
			_playData=null;
			_playFunc=null;
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