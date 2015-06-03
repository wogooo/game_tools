package com.YFFramework.core.center.manager.update
{
	import flash.utils.getTimer;

	/**队列 timeOut   同一时间内只执行 1个
	 * @author yefeng
	 * 2013 2013-10-23 上午10:24:00 
	 */
	public class QueenTimeOut
	{
		private var _func:Function;
		private var _funcParam:Object;
		private var _waitTime:Number;
		private var _currentTime:Number=0;
		private var _isStart:Boolean;
		private var _dif:Number;

		private var _temp:Number=0;
		public function QueenTimeOut(waitTime:Number,func:Function,funcParam:Object=null)
		{
			_waitTime=waitTime;
			_func=func;
			_funcParam=funcParam;
		}
		
		
		
//		public function setCurrentTime(currentTime:Number):void
//		{
//			_currentTime=currentTime;
//		}
			
		
		/**enterFrame里执行
		 */		
		public function update():Boolean
		{
			if(_isStart)
			{
				_dif=getTimer()-_currentTime;
				if(_dif>=_waitTime)
				{
					stop();
					_func(_funcParam);
					dispose();
					return true;
				}
			}
			return false;
		}

		
		
		
		public function start():void
		{
			_isStart=true;
			_currentTime=getTimer();
			UpdateManager.Instance.regQueenTimeOut(this);
		}
		
		public function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.delQueenTimeOut(this);
		}
		
		public function dispose():void
		{
			stop();
			_func=null;
			_funcParam=null;
		}

	}
}