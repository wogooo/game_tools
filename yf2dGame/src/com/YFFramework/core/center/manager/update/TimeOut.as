package com.YFFramework.core.center.manager.update
{
	import flash.utils.getTimer;

	/** 定时器 ，只执行一次
	 */	
	public class TimeOut implements IUpdate
	{
		private var _func:Function;
		private var _funcParam:Object;
		private var _waitTime:Number;
		private var _currentTime:Number;
		private var _isStart:Boolean;
		private var _dif:Number;
		public function TimeOut(waitTime:Number,func:Function,funcParam:Object=null)
		{
			_waitTime=waitTime;
			_func=func;
			_funcParam=funcParam;
		}
		
		/**enterFrame里执行
		 */		
		public function update():void
		{
			if(_isStart)
			{
				_dif=getTimer()-_currentTime;
				if(_dif>=_waitTime)
				{
					_func(_funcParam);
					dispose();
				}
			}
		}
		
		public function start():void
		{
			_isStart=true;
			_currentTime=getTimer();
			UpdateManager.Instance.regUpdateCore(this);
		}
		
		public function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.delUpdateCore(this);
		}
		
		public function dispose():void
		{
			stop();
			_func=null;
			_funcParam=null;
		}

		
	}
}