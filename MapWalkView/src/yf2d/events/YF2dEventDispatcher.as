package yf2d.events
{
    import com.YFFramework.core.debug.print;
    
    import flash.utils.Dictionary;
    
    import yf2d.display.DisplayObject2D;

    public class YF2dEventDispatcher
    {
        private var mEventListeners:Dictionary;
        
        /** Helper object.  冒泡对象池 */  
        private static var sBubbleChains:Array = [];
        
        /** Creates an EventDispatcher. */
        public function YF2dEventDispatcher()
        {  }
        
        /** Registers an event listener at a certain object. */
        public function addEventListener(type:String, listener:Function):void
        {
            if (mEventListeners == null)
                mEventListeners = new Dictionary();
            
            var listeners:Vector.<Function> = mEventListeners[type];
            if (listeners == null)
                mEventListeners[type] = new <Function>[listener];
            else if (listeners.indexOf(listener) == -1) // check for duplicates
                listeners.push(listener);
        }
        
        /** Removes an event listener from the object. */
        public function removeEventListener(type:String, listener:Function):void
        {
            if (mEventListeners)
            {
                var listeners:Vector.<Function> = mEventListeners[type];
                if (listeners)
                {
                    var numListeners:int = listeners.length;
                    var remainingListeners:Vector.<Function> = new <Function>[];
                    
                    for (var i:int=0; i<numListeners; ++i)
                        if (listeners[i] != listener) remainingListeners.push(listeners[i]);
                    
                    mEventListeners[type] = remainingListeners;
                }
            }
        }
        
        /** Removes all event listeners with a certain type, or all of them if type is null. 
         *  Be careful when removing all event listeners: you never know who else was listening. */
        public function removeEventListeners(type:String=null):void
        {
            if (type && mEventListeners)
                delete mEventListeners[type];
            else
                mEventListeners = null;
        }
        
        /** Dispatches an event to all objects that have registered for events of the same type. */
        public function dispatchEvent(event:YF2dEvent):void
        {
            var bubbles:Boolean = event.bubbles;
            if(!mEventListeners[event.type])print(this,"消息:"+event.type+"没有注册");
			
            if (!bubbles && (mEventListeners == null || !(event.type in mEventListeners)))
                return; // no need to do anything
            
            // we save the current target and restore it later;
            // this allows users to re-dispatch events without creating a clone.
            
            var previousTarget:YF2dEventDispatcher = event.target;
            event.setTarget(this);
            
            if (bubbles && this is DisplayObject2D) bubble(event);
            else                                  invoke(event);
            
            if (previousTarget) event.setTarget(previousTarget);
        }
        
        private function invoke(event:YF2dEvent):Boolean
        {
            var listeners:Vector.<Function> = mEventListeners ? mEventListeners[event.type] : null;
            var numListeners:int = listeners == null ? 0 : listeners.length;
            
            if (numListeners)
            {
                event.setCurrentTarget(this);
                
                // we can enumerate directly over the vector, because:
                // when somebody modifies the list while we're looping, "addEventListener" is not
                // problematic, and "removeEventListener" will create a new Vector, anyway.
                
                for (var i:int=0; i<numListeners; ++i)
                {
                    var listener:Function = listeners[i] as Function;
                    var numArgs:int = listener.length;
                    
                    if (numArgs == 0) listener();
                    else if (numArgs == 1) listener(event);
                    else listener(event, event.data);
                    
                    if (event.stopsImmediatePropagation)
                        return true;
                }
                
                return event.stopsPropagation;
            }
            else
            {
                return false;
            }
        }
        
        private function bubble(event:YF2dEvent):void
        {
            // we determine the bubble chain before starting to invoke the listeners.
            // that way, changes done by the listeners won't affect the bubble chain.
            
            var chain:Vector.<YF2dEventDispatcher>;
            var element:DisplayObject2D = this as DisplayObject2D;
            var length:int = 1;
            if (sBubbleChains.length > 0) { chain = sBubbleChains.pop(); chain[0] = element; }
            else chain = new <YF2dEventDispatcher>[element];
            
            while (element = element.parent)
                chain[length++] = element;

            for (var i:int=0; i<length; ++i)
            {
                var stopPropagation:Boolean = chain[i].invoke(event);
                if (stopPropagation) break;
            }
            
            chain.length = 0;
            sBubbleChains.push(chain);
        }
        
        /** Dispatches an event with the given parameters to all objects that have registered for 
         *  events of the given type. The method uses an internal pool of event objects to avoid 
         *  allocations. */
        public function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void
        {
            if (bubbles || hasEventListener(type)) 
            {
                var event:YF2dEvent = YF2dEvent.fromPool(type, bubbles, data);
                dispatchEvent(event);
				YF2dEvent.toPool(event);
            }
        }
        
        /** Returns if there are listeners registered for a certain event type. */
        public function hasEventListener(type:String):Boolean
        {
            var listeners:Vector.<Function> = mEventListeners ? mEventListeners[type] : null;
            return listeners ? listeners.length != 0 : false;
        }
    }
}