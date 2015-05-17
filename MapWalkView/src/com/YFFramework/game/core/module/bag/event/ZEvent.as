package com.YFFramework.game.core.module.bag.event
{
	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-6-28 下午04:04:54
	 * 
	 */
	import flash.events.Event;
	
	public class ZEvent extends Event
	{
		//======================================================================
		//        property
		//======================================================================
		public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
		public static const PROGRESS:String = "PROGRESS";
		public static const SCROLL_CHANGE:String = "SCROLL_CHANGE";
		public static const SELECTED_CHANGE:String = "SELECTED_CHANGE";
		public static const ERROR:String = "ERROR";
		
		public static const CLICK_NODE:String = "CLICK_NODE";
		public static const OPEN_NODE:String = "OPEN_NODE";
		
		public var data:Object;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ZEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 