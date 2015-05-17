package com.YFFramework.core.event
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

		/**事件发送器
		 */
		public function sendEvent(dispatcher:IEventDispatcher,event:Event):Boolean
		{
			if(dispatcher.hasEventListener(event.type))
				return dispatcher.dispatchEvent(event);
			return true;
		}
		
}