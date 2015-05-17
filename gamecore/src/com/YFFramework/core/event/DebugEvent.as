package com.YFFramework.core.event
{
	import flash.events.Event;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-26 下午01:17:54
	 */
	public class DebugEvent extends Event
	{
		public var data:Object;
		private static const Path:String="com.YFFramework.core.event.";
		/**  当错误信息更新时触发
		 */		
		public static const ErrorInfoUpdate:String=Path+"ErrorInfoUpdate";
		
		/**提示信息更新
		 */
		public static const VerboseInfoUpdate:String=Path+"VerboseInfoUpdate";
		public function DebugEvent(type:String,_data:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			data=_data;
			super(type, bubbles, cancelable);
		}
	}
}