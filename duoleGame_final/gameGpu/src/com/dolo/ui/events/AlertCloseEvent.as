package com.dolo.ui.events
{
	import flash.events.Event;
	
	/**
	 * 当侦听Alert的回调函数的参数Event 
	 * @author flashk
	 * 
	 */
	public class AlertCloseEvent extends Event
	{
		public static const CLOSE:String = "close";
		
		private var _data:*;
		private var _index:uint;
		private var _label:String;
		
		public function AlertCloseEvent(type:String,index:uint,label:String)
		{
			super(type);
			_index = index;
			_label = label;
		}
		
		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		/**
		 * 用户点击按钮的索引，从1开始，比如["确定","取消"],确定为1，当用户点击窗口关闭按钮为0。 
		 * @return 
		 * 
		 */
		public function get clickButtonIndex():uint
		{
			return _index;
		}
		
		/**
		 * 用户点击按钮的按钮文字，比如"确定"或"取消"，当用户点击窗口关闭按钮为Close。 
		 * @return 
		 * 
		 */
		public function get clickButtonLabel():String
		{
			return _label;
		}
		
	}
}