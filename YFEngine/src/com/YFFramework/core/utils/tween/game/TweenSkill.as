package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	
	import flash.utils.getTimer;

	/**  处理特效技能的 Tween
	 * 等待函数 等待一段时间在进行执行
	 *  2012-7-5
	 *	@author yefeng
	 */
	public class TweenSkill extends AbsPool
	{
		
		private var _time:Number;
		private var _waitTime:Number;
		private var _excuteFunc:Function;
		private var _params:Object;
		
		/**执行的总时间
		 */
		private var _totalTimes:Number;
		
		/** 时间到了执行的函数
		 */
		private var _timeCompleteFunc:Function;
		/**参数 
		 */
		private var _timeCompleteParam:Object;
		
		/**是否已经执行了等待函数 
		 */
		private var _isExcute:Boolean;
		
		private var _difTime:Number;
		
		public function TweenSkill()
		{
			
		}
		
		/**单位为毫秒  totalTimes必须要大于 waiteTime 要不然 totaltime将会等于 waitTime
		 */
		private function handleWait(waitTime:Number,excuteFunc:Function,excuteParam:Object=null,totalTimes:Number=-1,timeCompleteFunc:Function=null,timeCompleteParam:Object=null):void
		{
			_waitTime=waitTime;
			_excuteFunc=excuteFunc;
			_params=excuteParam;
			_totalTimes=totalTimes;
			if(_totalTimes<waitTime) _totalTimes=waitTime+1;
			_timeCompleteFunc=timeCompleteFunc;
			_timeCompleteParam=timeCompleteParam;
			_isExcute=false;
			_difTime=0;
			_time=getTimer();
			UpdateManager.Instance.framePer.regFunc(update);
		}
		private function update():void
		{
			_difTime=getTimer()-_time;
			if(_difTime>=_waitTime)
			{
				if(!_isExcute)
				{   
					_isExcute=true;
					///执行那个等待函数
					_excuteFunc(_params);
				}
				else
				{
					//当到达终止时间后 执行
					if(_difTime>=_totalTimes)
					{
						if(_timeCompleteFunc!=null)_timeCompleteFunc(_timeCompleteParam);
						//reset();
						disposeToPool();
					}
				}
			}
			
		}
		public function stop():void
		{
			UpdateManager.Instance.framePer.delFunc(update);
		}
	
		override public function reset():void
		{
			UpdateManager.Instance.framePer.delFunc(update);
			_excuteFunc=null;
			_params=null;
			_params=NaN;
			_time=NaN;
			_totalTimes:Number;
			_timeCompleteFunc=null;
			_timeCompleteParam=null;
			_difTime=NaN;

		}
		
		public static  function  WaitToExcute(waitTime:Number,excuteFunc:Function,excuteParam:Object=null,totalTimes:Number=-1,timeCompleteFunc:Function=null,timeCompleteParam:Object=null):TweenSkill
		{
			var tweenWait:TweenSkill=PoolCenter.Instance.getFromPool(TweenSkill) as TweenSkill;//new TweenSkill();
			tweenWait.handleWait(waitTime,excuteFunc,excuteParam,totalTimes,timeCompleteFunc,timeCompleteParam);
			return tweenWait;
		}
		
		
		
	}
}