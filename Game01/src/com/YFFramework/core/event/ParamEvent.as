package com.YFFramework.core.event
{
	/**@author yefeng
	 *2012-4-20下午11:52:02
	 */
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
		public var param:Object;
		protected var _type:String;
		protected var _param:Object;
		protected var _bubbles:Boolean;
		protected var _cancelable:Boolean;
		public function ParamEvent(type:String, param:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.param=param;
		}
	}
}