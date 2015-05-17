package com.YFFramework.core.center.manager.dbClick
{
	import flash.display.DisplayObject;
	import flash.utils.getTimer;

	/**@author yefeng
	 *2012-8-19下午5:31:46
	 */
	
	public class DBClickItem 
	{
		
		public var dbClickObject:DisplayObject;
		
		public var currentTime:Number;
		public var dbClickFunc:Function;
		public function DBClickItem()
		{
			super();
			currentTime=getTimer();
		}
		public function dispose():void
		{
			dbClickObject=null;
			dbClickFunc=null;
			currentTime=0;
		}
	}
}