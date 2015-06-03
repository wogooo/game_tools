package com.YFFramework.core.center.manager.update
{
	import flash.utils.getTimer;

	/** 在某一个时间段存在的 更新函数 UpdateFrame是永远都存在的
	 * 这里注册的是时间
	 * 2012-10-29 下午8:21:45
	 *@author yefeng
	 */
	public class UpdateCore implements IUpdate
	{
		/** 每多少时间进行更新一次 单位是毫秒
		 */
		private var _updateTime:Number;
		private var _currentTime:Number;
		private var _dif:Number;
		private var _func:Function;
		private var _funcParam:Object;
		
		private var _isStart:Boolean;
		public function UpdateCore(updateTime:Number,func:Function,funcParam:Object=null)
		{
			_updateTime=updateTime;
			_currentTime=getTimer();
			_func=func;
			_funcParam=funcParam;
			_isStart=false;
		}
		
		/**enterFrame里执行
		 */		
		public function update():void
		{
			if(_isStart)
			{
				_dif=getTimer()-_currentTime;
				if(_dif>=_updateTime)
				{
					_func(_funcParam);
					_currentTime=getTimer();
				}
			}
		}
		
		public function stop():void
		{
			_isStart=false;
			UpdateManager.Instance.delUpdateCore(this);
		}
		
		public function start():void
		{
			_isStart=true;
			_currentTime=getTimer();
			UpdateManager.Instance.regUpdateCore(this);
		}
		
		public function dispose():void
		{
			stop();
			_func=null;
			_funcParam=null;
		}
		
	}
}