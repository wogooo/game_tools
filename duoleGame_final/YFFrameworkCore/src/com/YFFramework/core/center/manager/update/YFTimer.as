package com.YFFramework.core.center.manager.update
{
	import flash.utils.getTimer;

	/**@author yefeng
	 * 2013 2013-4-18 下午2:38:01 
	 */
	public class YFTimer implements IUpdate
	{
		/**时间间隔
		 */		
		private var _intervalTime:int;
		/** 数量
		 */		
		public var updateFunc:Function;
		public var updateParam:Object;
		
		public var completeFunc:Function;
		public var completeParam:Object;
		private var _lastTime:int;
		private var _currentCount:int;
		/**
		 * @param intervalTime    每次执行的 中间的时间差  也就是停留的时间
		 * @param count			 执行的总次数 一直到 0时
		 * @param updateFunc   更新 函数  
		 * @param funcParam 更新函数参数
		 */		
		public function YFTimer(intervalTime:int,count:int)
		{
			_intervalTime=intervalTime;
			_currentCount=count;
		}
		public function start():void
		{
			UpdateManager.Instance.regUpdateCore(this);	
		}
		public function stop():void
		{
			UpdateManager.Instance.delUpdateCore(this);	
		}
		
		public function update():void
		{
			
			if(getTimer()-_lastTime>=_intervalTime)
			{
				_lastTime=getTimer();
				_currentCount--;
				updateFunc(updateParam);
				if(_currentCount<=0)
				{
					if(completeFunc!=null)completeFunc(completeParam);
					dispose();
				}
			}
		}
		public function get currentCount():int
		{
			return _currentCount;
		}
		private function dispose():void
		{
			stop();
			updateFunc=null;
			updateParam=null;
			completeFunc=null;
			completeParam=null;
		}
			
	}
}