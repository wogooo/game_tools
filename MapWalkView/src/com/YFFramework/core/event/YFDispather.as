
package com.YFFramework.core.event
{
    import com.YFFramework.core.debug.print;
    
    import flash.utils.Dictionary;

    public class YFDispather
    {
        private var _eventListeners:Dictionary;
        
        /** Helper object. */
        private static var sBubbleChains:Array = [];
        
        /** Creates an Dispather. */
        public function YFDispather()
        {  
			_eventListeners = new Dictionary();
		}
        
        /** Registers an event listener at a certain object. */
        public function addEventListener(type:String, listener:Function):void
        {
            var listeners:Vector.<Function> = _eventListeners[type];
            if (listeners == null)
                _eventListeners[type] = new <Function>[listener];
           else if (listeners.indexOf(listener) == -1) // check for duplicates
				_eventListeners[type].push(listener);
        }
        
        /** Removes an event listener from the object. */
        public function removeEventListener(type:String, listener:Function):void
        {
//            if (_eventListeners)
//            {
                var listeners:Vector.<Function> = _eventListeners[type];
                if (listeners)
                {
//					var index:int=listeners.indexOf(listener);
//					if(index!=-1)listeners.splice(index,1);   ///不能用这个方法 ，因为这样会导致有的函数调用不到   必须使用下面的方法
					
					
                    var numListeners:int = listeners.length;
                    var remainingListeners:Vector.<Function> = new <Function>[];
                    var newLen:int=0;//新的长度
                    for (var i:int=0; i<numListeners; ++i)
					{
						if (listeners[i] != listener) 
						{
							remainingListeners.push(listeners[i]);
							newLen++;
						}
					}
                       
					if(newLen>0)  _eventListeners[type] = remainingListeners;
					else   delete _eventListeners[type];
                }
//            }
        }
        
        /** Removes all event listeners with a certain type, or all of them if type is null. 
         *  Be careful when removing all event listeners: you never know who else was listening. */
        public function removeEventListeners(type:String=null):void
        {
            if (type && _eventListeners)
                delete _eventListeners[type];
            else
                _eventListeners = null;
        }
        
        /** Dispatches an event to all objects that have registered for events of the same type. */
        protected function dispatchEvent(event:YFEvent):void
        {
            
            if ((_eventListeners == null || !(event.type in _eventListeners)))
                return; // no need to do anything
            
            // we save the current target and restore it later;
            // this allows users to re-dispatch events without creating a clone.
            
            var previousTarget:YFDispather = event.target;
            event.setTarget(this);
            invoke(event);
        }
        private function invoke(event:YFEvent):Boolean
        {
            var listeners:Vector.<Function> = _eventListeners ? _eventListeners[event.type] : null;
            var numListeners:int = listeners == null ? 0 : listeners.length;
            if (numListeners)
            {
                event.setTarget(this);
				///响应函数
				for each (var listener:Function in listeners )
				{
					listener(event);
				}
				return true
            }
            return false;
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
			else print(this,"消息type=="+type+"没有进行注册");
        }
        
        /** Returns if there are listeners registered for a certain event type. */
        public function hasEventListener(type:String):Boolean
        {
            var listeners:Vector.<Function> = _eventListeners ? _eventListeners[type] : null;
            return listeners ? listeners.length != 0 : false;
        }
    }
}