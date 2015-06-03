package com.YFFramework.core.ui.yf2d.tween
{
	/**@author yefeng
	 * 2013 2013-4-27 上午10:58:25 
	 */
	import com.YFFramework.core.center.update.TweenMountGuideManager;
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**坐骑引导点  引导  其他 对象动
	 */	
	public class TweenGuidePlay extends YFDispather
	{
		private var loop:Boolean;
		private var _playData:Array; //含有  [ {x,y,delay}]		单元	{x,y,delay}  属性
		/**是否已经播放
		 */
		private var _isStart:Boolean;
		private var _playIndex:int;
		
		private var _position:Number;
		private var _mTime:Number;
		private var _playFunc:Function;
		
		private var arrLen:int;
		
		
//		private var _timer:Timer;
		/** 引导方向
		 */		
		private var _scaleX:int;
		private var _canPlay:Boolean;
		public function TweenGuidePlay()
		{
			super();
//			initTimer();
		}
		
//		private function initTimer():void
//		{
//			_timer=new Timer(30);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
//			
//		}
		private function removeTimer():void
		{
//			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
//			_timer.stop()
//			_timer=null;
			TweenMountGuideManager.Instance.removeFunc(update);
		}
//		private function onTimer(e:TimerEvent):void
//		{
//			update();
//		}

		
		/**playData是  playFunc的参数   playFunc是 updateTextureData
		 */
		public function  initData(playData:Array,scaleX:Number=1,loop:Boolean=true):void
		{
			_playData=playData;
			_isStart=false;
			_mTime=0;
			_position=0;
			this.loop=loop;
			_scaleX=scaleX;
			arrLen=playData.length;
		}
		
		public function setPlayFunc(playFunc:Function):void
		{
			_playFunc=playFunc;
		}
		public function start(playIndex:int=0):void
		{
			if(_playData)
			{
				_playIndex=playIndex;
				_isStart=true;
				_canPlay=false;
				_mTime=getTimer();
//				play();
				_playFunc(_playData[_playIndex],_scaleX);
//				_timer.start();
				TweenMountGuideManager.Instance.addFunc(update);
			}
		}
		/**  继续播放 在原来的基础上继续播放
		 */		
		public function  continuePlay():void
		{
			_isStart=true;
			_mTime=getTimer();
//			play();
			_playFunc(_playData[_playIndex],_scaleX);
		}
		public function stop():void
		{
			_isStart=false;
//			_timer.stop();
			TweenMountGuideManager.Instance.removeFunc(update);
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
	
		
		
		public function update():void
		{
			if(_isStart)
			{
				var dif:Number=getTimer()-_mTime;
				_position +=dif;
				_mTime=getTimer();
				while(_position>=_playData[_playIndex].delay) 
				{
					if(_playIndex<arrLen)
					{
						_position -=_playData[_playIndex].delay;
						++_playIndex;
						_canPlay=true;
						if(loop&&_playIndex>=arrLen)_playIndex=_playIndex%arrLen;
						if(_playIndex>=arrLen) 
						{
							dispose();
							dispatchEventWith(YFEvent.Complete);
							return ;
						}
					}
					else 
					{
						dispose();
						dispatchEventWith(YFEvent.Complete);
					}
				}
				if(_canPlay)
				{
//					play();	 /// 移到外面调用
					_playFunc(_playData[_playIndex],_scaleX);
					_canPlay=false;
				}
			}
		}
		
		
//		private function play():void
//		{
//			_playFunc(_playData[_playIndex],_scaleX);
//		}
		
		public function dispose():void
		{
			stop();
			removeTimer();
			_playData=null;
			loop=false
			_isStart=false
			_playIndex=0;
			_position=0;
			_mTime=0;
			arrLen=0;
		}
		
	}
}