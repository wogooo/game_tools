package com.YFFramework.game.core.global.util
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/***
	 *MovieClip控制类，控制mc的帧率，用于含有很多个子mc，且子mc也是动画的情况
	 *@author ludingchang 时间：2013-12-23 下午4:34:52
	 */
	public class MovieClipCtrl
	{
		private var _mc:MovieClip;
		private var _frameRate:int;
		private var _timer:Timer;
		private var _autoRemove:Boolean;
		/**特效结束时的回调方法*/
		private var _callback:Function;
		/**执行回调时的参数*/
		private var _params:Array;
		/**
		 *构造函数 
		 * @param mc 需要控制的MC
		 * @param frameRate 希望播放的帧率
		 */		
		public function MovieClipCtrl(mc:MovieClip,frameRate:int)
		{
			_mc=mc;
			_frameRate=frameRate;
			_timer=new Timer(1000/_frameRate);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerStop);
			stopAllChildren(mc);
			mc.stop();
		}
		
		protected function onTimerStop(event:TimerEvent):void
		{
			_timer.stop();
			if(_autoRemove&&_mc.parent)
				_mc.parent.removeChild(_mc);
			if(_callback != null)
			{
				_callback.apply(null,_params);
				_callback=null;
				_params=null;
			}
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if(_mc.currentFrame==_mc.totalFrames)
				_mc.gotoAndStop(1);
			else
				_mc.nextFrame();
			allChildrenGotoNext(_mc);
		}
		
		/**
		 * 播放
		 */		
		public function play():void
		{
			reset();
			_timer.reset();
			_timer.repeatCount=0;
			_timer.start();
		}
		
		/**
		 *播放一定时间 
		 * @param t 时间（毫秒）
		 * @param autoRemove 时间到了是否自动移除 
		 */		
		public function playWithTime(t:int,autoRemove:Boolean=true):void
		{
			reset();
			_timer.reset();
			_timer.repeatCount=t*_frameRate/1000;
			_timer.start();
			_autoRemove=autoRemove;
		}
		
		/**
		 *添加特效结束时的回调方法 
		 * @param callback 回调方法
		 * @param params 执行此回调方法时的参数列表
		 * 
		 */		
		public function addCallback(callback:Function,params:Array=null):void
		{
			_callback=callback;
			_params=params;
		}
		
		/**暂停*/
		public function stop():void
		{
			_timer.stop();
		}
		/**设置帧率*/
		public function setFrameRate(frameRate:int):void
		{
			_frameRate=frameRate;
			_timer.delay=1000/_frameRate;
		}
		
		/**释放*/
		public function dispose():void
		{
			_mc=null;
			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			_timer=null;
		}
		
		/**全部子mc停止*/
		private function stopAllChildren(mc:MovieClip):void
		{
			var j:int,len2:int=mc.totalFrames;
			for(j=1;j<=len2;j++)
			{
				mc.gotoAndStop(j);
				var i:int,len:int=mc.numChildren;
				for(i=0;i<len;i++)
				{
					var child:MovieClip=mc.getChildAt(i) as MovieClip;
					if(child)
					{
						child.stop();
						stopAllChildren(child);
					}
				}
			}
		}
		
		/**全部子mc往下走一帧*/
		private function allChildrenGotoNext(mc:MovieClip):void
		{
			var i:int,len:int=mc.numChildren;
			for(i=0;i<len;i++)
			{
				var child:MovieClip=mc.getChildAt(i) as MovieClip;
				if(child)
				{
					if(child.currentFrame==child.totalFrames)
						child.gotoAndStop(1);
					else
						child.nextFrame();
					
					allChildrenGotoNext(child);
				}
			}
		}
		
		public function reset():void
		{
			allChildrenGoto(_mc,1);
		}
		
		private function allChildrenGoto(mc:MovieClip,frame:int):void
		{
			var i:int,len:int=mc.numChildren;
			for(i=0;i<len;i++)
			{
				var child:MovieClip=mc.getChildAt(i) as MovieClip;
				if(child)
				{
					child.gotoAndStop(1);
					allChildrenGoto(child,frame);
				}
			}
		}
	}
}