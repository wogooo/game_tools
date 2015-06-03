
package com.YFFramework.core.event
{
    import flash.utils.getQualifiedClassName;
    public class YFEvent
    {
		private static const Path:String="com.YFFramework.core.event.";
		public static const Complete:String=Path+"Complete";
        
		///对象词池
        protected static var _eventPool:Vector.<YFEvent> = new <YFEvent>[];
        
        protected var _target:YFDispather;
		protected var _type:String;
		protected var _param:Object;
        
        /** Creates an event object that can be passed to listeners. */
        public function YFEvent(type:String, param:Object=null)
        {
            _type = type;
            _param = param;
        }
        
        
        
        /** Returns a description of the event, containing type and bubble information. */
        public function toString():String
        {
//            return formatString("[{0} type=\"{1}\" bubbles={2}]", 
//                getQualifiedClassName(this).split("::").pop(), _type, _bubbles);
			return "type:"+getQualifiedClassName(this).split("::").pop()+",type="+_type;
        }
        
        
        /** The object that dispatched the event. */
        public function get target():YFDispather { return _target; }
        
        
        /** A string that identifies the event. */
        public function get type():String { return _type; }
        
        /** Arbitrary data that is attached to the event. */
        public function get param():Object { return _param; }
        
        // properties for internal use
        
        /** @private */
        internal function setTarget(value:YFDispather):void { _target = value; }
        
        
        
        
        // event pooling
        
        /** @private */
        internal static function fromPool(type:String, param:Object=null):YFEvent
        {
            if (_eventPool.length) return (_eventPool.pop()).reset(type, param);
            else return new YFEvent(type, param);
        }
        
        /** @private */
        internal static function toPool(event:YFEvent):void
        {
            event._param = event._target = null;
			event._type=null;
            _eventPool.push(event);
        }
        
        /** @private */
        internal function reset(type:String, param:Object=null):YFEvent
        {
            _type = type;
            _param = param;
            _target = null;
            return this;
        }
    }
}