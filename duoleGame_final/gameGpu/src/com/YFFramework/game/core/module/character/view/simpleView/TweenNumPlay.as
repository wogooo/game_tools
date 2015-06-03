package com.YFFramework.game.core.module.character.view.simpleView
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	
	import flash.utils.getTimer;

	/**数字滚动播放器，参考例子：屏幕中下方战斗力数字改变动画效果
	 * @author yefeng
	 * 2013 2013-10-26 下午4:10:56 
	 */
	public class TweenNumPlay extends YFDispather
	{
		/**是否已经开始 */
		private var _isStart:Boolean;
		/** 从哪个位置播放 */		
		private var _playIndex:Number;
		
		private var _position:Number;
		private var _startTime:Number;
		/** 数字改变后调用的外部函数 */		
		private var _playFunc:Function;
		/** 共有多少数字 */		
		private var _totalNum:Number;
		
		private var _playAry:Array;
		/** 两个数字之间的播放时间间隔 */		
		private var _interval:int;
		
		private var _canPlay:Boolean;

		public function TweenNumPlay()
		{
		}
		
		public function initData(startNum:int,endNum:int,inverval:int):void
		{
			_playAry=[];
			
			if(startNum < endNum)
			{
				for(var i:int=startNum;i<=endNum;i++ )
				{
					_playAry.push(i);
				}
				_totalNum=endNum-startNum+1;
			}
			else
			{
				for(i = startNum;i<=endNum;i-- )
				{
					_playAry.push(i);
				}
				_totalNum=startNum-endNum+1;
			}
			_interval=inverval;//时间间隔
			_playIndex=0;
			_position=0;
			_startTime=0;
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
			_startTime=getTimer();
			_playFunc(_playAry[_playIndex]);
			UpdateManager.Instance.framePer.regFunc(update);
		}
		
		public function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.framePer.delFunc(update);
		}
	
		private function update():void
		{
			if(_isStart)
			{
				var dif:Number=getTimer()-_startTime;
				_position +=dif;
				_startTime=getTimer();
				///循环   
				while(_position>=_interval)
				{
					if(_playIndex<_totalNum)
					{
						
						_position -=_interval;
						++_playIndex;
						_canPlay=true;
						if(_playIndex>=_totalNum)
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
						return;
					}
				}
				if(_canPlay)
				{
					_playFunc(_playAry[_playIndex]);
					_canPlay=false;
				}
			}
		}
		public function dispose():void
		{
			stop();
			_playAry=null;
			_isStart=false
			_playIndex=0;
			_position=0;
			_startTime=0;
			_totalNum=0;
		}

		
	}
}