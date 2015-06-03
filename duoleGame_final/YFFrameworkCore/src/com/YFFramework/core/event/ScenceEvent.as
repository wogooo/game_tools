package com.YFFramework.core.event
{
	import flash.events.Event;
	
	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 2:54:35 PM
	 */
	public final class ScenceEvent extends Event
	{
		private static const Path:String="com.YFFramework.mapEditor.event.";
		/**场景移除完成时触发   运用于 Iscence
		 */		
		public static const RemoveScenceComplete:String=Path+"RemoveScenceComplete";
		/**  地图移除完成时触发
		 */		
		public static const RemoveMapComplete:String=Path+"RemoveMapComplete";
		public function ScenceEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}