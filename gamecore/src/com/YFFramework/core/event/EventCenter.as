package com.YFFramework.core.event
{
	
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**事件中心
	 * author :夜枫 
	 */
	public final class EventCenter extends EventDispatcher
	{
		private static var _instance:EventCenter;
		public function EventCenter(target:IEventDispatcher=null)
		{
			super(target);
			if(_instance) throw new Error("请使用Instance属性");

		}
		
		public static function get Instance():EventCenter
		{
			if(!_instance) 	_instance=new EventCenter();
			return _instance;
		}           
		
//		override public function dispatchEvent(event:Event):Boolean
//		{
//			if(hasEventListener(event.type))
//				return super.dispatchEvent(event);
//			return false;
//		}
		
//		public function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void
//		{
//			if (bubbles || hasEventListener(type)) 
//			{
//				var event:Event = Event.fromPool(type, bubbles, data);
//				dispatchEvent(event);
//				Event.toPool(event);
//			}
//		}
		
	}
}