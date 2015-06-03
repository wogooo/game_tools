package com.YFFramework.core.center.manager.update
{
	/** 2012-5-26 上午11:06:26
	 * @author  yefeng
	 */
	public class TimeLine
	{
		/**要播放的时间序列
		 */
		private var _arr:Vector.<TimeOut>;
		/** 总时间
		 */
		private var _totalTime:int;
		/**事件完成后的回调
		 */
		public var completeFunc:Function=null;
		/**事件完成后的回调
		 */
		public var completeParam:Object=null;
		
		private var _complete:TimeOut;
		public function TimeLine()
		{
			reset();
		}
		
		private function _completeListener(obj:Object):void
		{
			if(completeFunc!=null)completeFunc(completeParam);
			dispose();

		}
		
		/**重置状态
		 */
		public function reset():void
		{
			_arr=new Vector.<TimeOut>();
			_totalTime=0;
			completeFunc=null;
			completeParam=null;
		}
		
		
		/**  添加侦听器
		 * @param listener  调用的函数
		 * @param param 参数
		 * @param duration  listener  方法执行的时间
		 */
		public  function addFunc( listener:Function, param:Object, duration:int):void
		{
			var timeOut:TimeOut=new TimeOut(_totalTime, listener,param);
			_arr.push(timeOut);
			_totalTime +=duration;
		}
		/**等待时间
		 */
		public function addWait(duration:int ):void
		{
			_totalTime +=duration;
		}
		
		/**开始
		 */
		public function start():void
		{
			for each(var timeOut:TimeOut in _arr)
			{
				timeOut.start();
			}
			_complete=new TimeOut(_totalTime+100,_completeListener,null); ///加上 100 防止bug 
			_complete.start();
		}
		
		public function dispose():void
		{
			stop();
			_arr.length=0
			_arr=null;
			completeFunc=null;
			completeParam=null;
			_complete.dispose();
			_complete=null;
		}
		/**停止播放
		 */		
		public function stop():void
		{
			for each(var timeOut:TimeOut in _arr)
			{
				timeOut.stop();
			}
			if(_complete)_complete.stop();
		}
		
	}
}