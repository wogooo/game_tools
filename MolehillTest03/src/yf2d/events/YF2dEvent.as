package yf2d.events
{
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
		public static const CONTEXT_CREATE:String="contextCreate";
        
		/** Creates an event object that can be passed to listeners. */

//        public function YF2dEvent(type:String, bubbles:Boolean=false)
//        {
//            mType = type;
//            mBubbles = bubbles;
//        }
//        
//        public function stopPropagation():void
//        {
//            mStopsPropagation = true;            
//        }
//        
//        public function stopImmediatePropagation():void
//        {
//            mStopsPropagation = mStopsImmediatePropagation = true;
//        }
//        
//        public function toString():String
//        {
//            return formatString("[{0} type=\"{1}\" bubbles={2}]", 
//                getQualifiedClassName(this).split("::").pop(), mType, mBubbles);
//        }
//        
//        internal function setTarget(target:YFEventDispatcher):void 
//        { 
//            mTarget = target; 
//        }
//        
//        internal function setCurrentTarget(currentTarget:YFEventDispatcher):void 
//        { 
//            mCurrentTarget = currentTarget; 
//        }
//        
//        internal function get stopsPropagation():Boolean { return mStopsPropagation; }
//        internal function get stopsImmediatePropagation():Boolean { return mStopsImmediatePropagation; }
//        
//        public function get bubbles():Boolean { return mBubbles; }
//        public function get target():YFEventDispatcher { return mTarget; }
//        public function get currentTarget():YFEventDispatcher { return mCurrentTarget; }
//        public function get type():String { return mType; }
    }
}