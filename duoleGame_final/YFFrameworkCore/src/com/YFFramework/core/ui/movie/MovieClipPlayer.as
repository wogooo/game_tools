package com.YFFramework.core.ui.movie
{
	/**按照指定的帧率播放mc 
	 * @author yefeng
	 * 2013 2013-11-6 上午10:00:28 
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/** movieClip包装器   按照指定帧数 播放
	 */
	public class MovieClipPlayer extends AbsView
	{
		
		
		
		private var _mc:MovieClip;
		private var _frameRate:int;
		private var _totalFrames:int;
		/**当前帧
		 */
		private var _currentFrame:int;
		/**播放的最后一帧
		 */
		private var _endFrame:int;
		private var _currenTime:Number=0;
		private var _perTime:int;
		
		private var _completeParam:Object;
		private var _completeFunc:Function;
		private var _loop:Boolean;
		private var _isStart:Boolean=false;
		public function MovieClipPlayer(mc:MovieClip,frameRate:int)
		{
			super(false);
			initMC(mc,frameRate);
		}
		public function initMC(mc:MovieClip,frameRate:int=30):void
		{
			_mc=mc;
			if(_mc)
			{
				_frameRate=frameRate;
				_totalFrames=_mc.totalFrames;
				_perTime=1000/_frameRate;
				addChild(_mc);
				gotoAndStop(1);
			}
		}
		
		public function gotoAndStop(index:int):void
		{
			if(index<=1)index=1;
			if(index>=_totalFrames)index=_totalFrames;
			_currentFrame=index;
			_currenTime=getTimer();
			playIt(_currentFrame);
		}
		public function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.framePer.delFunc(update);
		} 
		
		public function start():Boolean
		{
			if(!_isStart)
			{
				UpdateManager.Instance.framePer.regFunc(update);
				_isStart=true;
				return true;
			}
			return false
		}
		/**默认播放个 不断 循环播放
		 */
		public function playDefault():void
		{
			play(1,_totalFrames,true);
		}
			
		 
		private function update():void
		{
			if(_isStart)
			{
				var dif:Number=getTimer()-_currenTime;
				if(dif>=_perTime)
				{
					_currentFrame++
					if(_loop)
					{
						_currentFrame=(_currentFrame-1)%_totalFrames+1;
						playIt(_currentFrame);
					}
					else 
					{
						if(_currentFrame<=_endFrame)
						{
							playIt(_currentFrame);
						}
						else
						{
//							if(hasEventListener(Event.COMPLETE))
//							{
//								dispatchEvent(new Event(Event.COMPLETE));
//							}
							stop();
							if(_completeFunc!=null)_completeFunc(_completeParam);
							_completeFunc=null;
						}
					}
					_currenTime=getTimer();
				}
			}
		}
		private function  playIt(frame:int):void
		{
			if(_mc)_mc.gotoAndStop(frame);
		}
		
		public function play(startIndex:int,endIndex:int,loop:Boolean,complete:Function=null,completeParam:Object=null):void
		{
			_completeFunc=complete;
			_completeParam=completeParam;
			_currentFrame=startIndex;
			_endFrame=endIndex;
			_loop=loop;
			_currenTime=getTimer();
			start();
		}
		
		/**从开始播放到结束 停留在最后一帧 
		 */
		public function playToEnd(startIndex:int=1,complete:Function=null,completeParam:Object=null):void
		{
			play(startIndex,_totalFrames,false,complete,completeParam);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			stop();
			if(_mc)	_mc.stop();
			_mc=null;
			_completeFunc=null;
			_completeParam=null;
		}

		public function get totalFrames():int
		{
			return _totalFrames;
		}

		
		
		
	}
}