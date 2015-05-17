// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package gpu2d.events
{
    import flash.utils.getQualifiedClassName;
    
    import gpu2d.utils.formatString;

    public class GEvent
    {
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
		
		
        private var mTarget:GEventDispatcher;
        private var mCurrentTarget:GEventDispatcher;
        private var mType:String;
        private var mBubbles:Boolean;
        private var mStopsPropagation:Boolean;
        private var mStopsImmediatePropagation:Boolean;
        
        public function GEvent(type:String, bubbles:Boolean=false)
        {
            mType = type;
            mBubbles = bubbles;
        }
        
        public function stopPropagation():void
        {
            mStopsPropagation = true;            
        }
        
        public function stopImmediatePropagation():void
        {
            mStopsPropagation = mStopsImmediatePropagation = true;
        }
        
        public function toString():String
        {
            return formatString("[{0} type=\"{1}\" bubbles={2}]", 
                getQualifiedClassName(this).split("::").pop(), mType, mBubbles);
        }
        
        internal function setTarget(target:GEventDispatcher):void 
        { 
            mTarget = target; 
        }
        
        internal function setCurrentTarget(currentTarget:GEventDispatcher):void 
        { 
            mCurrentTarget = currentTarget; 
        }
        
        internal function get stopsPropagation():Boolean { return mStopsPropagation; }
        internal function get stopsImmediatePropagation():Boolean { return mStopsImmediatePropagation; }
        
        public function get bubbles():Boolean { return mBubbles; }
        public function get target():GEventDispatcher { return mTarget; }
        public function get currentTarget():GEventDispatcher { return mCurrentTarget; }
        public function get type():String { return mType; }
    }
}