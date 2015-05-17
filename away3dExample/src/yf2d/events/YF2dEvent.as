package yf2d.events
{
	import avmplus.getQualifiedClassName;
	
	import yf2d.utils.formatString;

	public class YF2dEvent
    {
		//public static const START:String="start";
		public static const ADDED:String = "added";
		public static const ADDED_TO_STAGE:String = "addedToStage";
		//   public static const ENTER_FRAME:String = "enterFrame";
		public static const REMOVED:String = "removed";
		public static const REMOVED_FROM_STAGE:String = "removedFromStage";
		// public static const TRIGGERED:String = "triggered";
		//  public static const MOVIE_COMPLETED:String = "movieCompleted";
		//  public static const FLATTEN:String = "flatten";
		//     public static const RESIZE:String = "resize";
		
		/**
		 * context3d创建完成时触发 
		 */		
//		public static const CONTEXT_CREATE:String="contextCreate";
		
		
		private static var sEventPool:Vector.<YF2dEvent> = new <YF2dEvent>[];
		
		private var mTarget:YF2dEventDispatcher;
		private var mCurrentTarget:YF2dEventDispatcher;
		private var mType:String;
		private var mBubbles:Boolean;
		private var mStopsPropagation:Boolean;
		private var mStopsImmediatePropagation:Boolean;
		private var mData:Object;
		
		/** Creates an event object that can be passed to listeners. */
		public function YF2dEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			mType = type;
			mBubbles = bubbles;
			mData = data;
		}
		
		/** Prevents listeners at the next bubble stage from receiving the event. */
		public function stopPropagation():void
		{
			mStopsPropagation = true;            
		}
		
		/** Prevents any other listeners from receiving the event. */
		public function stopImmediatePropagation():void
		{
			mStopsPropagation = mStopsImmediatePropagation = true;
		}
		
		/** Returns a description of the event, containing type and bubble information. */
		public function toString():String
		{
			return formatString("[{0} type=\"{1}\" bubbles={2}]", 
				getQualifiedClassName(this).split("::").pop(), mType, mBubbles);
		}
		
		/** Indicates if event will bubble. */
		public function get bubbles():Boolean { return mBubbles; }
		
		/** The object that dispatched the event. */
		public function get target():YF2dEventDispatcher { return mTarget; }
		
		/** The object the event is currently bubbling at. */
		public function get currentTarget():YF2dEventDispatcher { return mCurrentTarget; }
		
		/** A string that identifies the event. */
		public function get type():String { return mType; }
		
		/** Arbitrary data that is attached to the event. */
		public function get data():Object { return mData; }
		
		// properties for internal use
		
		/** @private */
		internal function setTarget(value:YF2dEventDispatcher):void { mTarget = value; }
		
		/** @private */
		internal function setCurrentTarget(value:YF2dEventDispatcher):void { mCurrentTarget = value; } 
		
		/** @private */
		internal function get stopsPropagation():Boolean { return mStopsPropagation; }
		
		/** @private */
		internal function get stopsImmediatePropagation():Boolean { return mStopsImmediatePropagation; }
		
		// event pooling
		
		/** @private */
		internal static function fromPool(type:String, bubbles:Boolean=false, data:Object=null):YF2dEvent
		{
			if (sEventPool.length) return sEventPool.pop().reset(type, bubbles, data);
			else return new YF2dEvent(type, bubbles, data);
		}
		
		/** @private */
		internal static function toPool(event:YF2dEvent):void
		{
			event.mData = event.mTarget = event.mCurrentTarget = null;
			sEventPool.push(event);
		}
		
		/** @private */
		internal function reset(type:String, bubbles:Boolean=false, data:Object=null):YF2dEvent
		{
			mType = type;
			mBubbles = bubbles;
			mData = data;
			mTarget = mCurrentTarget = null;
			mStopsPropagation = mStopsImmediatePropagation = false;
			return this;
		}
    }
}