package com.YFFramework.core.center.manager.time
{
	import flash.utils.Timer;

	/**@author yefeng
	 * 2013 2013-7-12 上午11:57:20 
	 */
	public class TimerObject
	{
		/**timer实例
		 */		
		public var timer:Timer;
		/**该timer响应的 回调
		 */		
		public var callBack:Function;
		public function TimerObject()
		{
		}
		public function dispose():void
		{
			callBack=null;
			timer=null;
		}
	}
}