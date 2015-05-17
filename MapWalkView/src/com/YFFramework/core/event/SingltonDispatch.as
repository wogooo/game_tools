
package com.YFFramework.core.event
{
	import com.YFFramework.core.debug.print;
	
	import flash.utils.Dictionary;

	/**  单一事件派发 也就是   事件注册是单利的   事件不会派发给多个函数响应 只会让一个函数响应 
	 */	
	public class SingltonDispatch
	{
		private var _eventListeners:Dictionary;
	
		/** Creates an Dispather. */
		public function SingltonDispatch()
		{ 
			_eventListeners=new Dictionary();
		}
		
		/** Registers an event listener at a certain object. */
		public function addEventListener(type:String, listener:Function):void
		{
			
//			if(_eventListeners[type]) print(this,"type=="+type+"消息已经注册");
			_eventListeners[type]=listener;
		}
		
		/** Removes an event listener from the object. */
		public function removeEventListener(type:String, listener:Function):void
		{
			if(_eventListeners[type])  _eventListeners[type]=null;
			delete _eventListeners[type];
		}
		
	
		
		/** Dispatches an event to all objects that have registered for events of the same type. */
		private function dispatchEvent(event:YFEvent):void
		{
			var func:Function=_eventListeners[event.type];
			func(event);	
//			else print(this,"event",event.type);
		}
		
		/** Dispatches an event with the given parameters to all objects that have registered for 
		 *  events of the given type. The method uses an internal pool of event objects to avoid 
		 *  allocations. */
		public function dispatchEventWith(type:String, data:Object=null):void
		{
			if (hasEventListener(type)) 
			{
				var event:YFEvent = YFEvent.fromPool(type, data);
				dispatchEvent(event);
				YFEvent.toPool(event);
			}
		}
		
		/** Returns if there are listeners registered for a certain event type. */
		public function hasEventListener(type:String):Boolean
		{
			return _eventListeners[type];
			
		}
	}
}