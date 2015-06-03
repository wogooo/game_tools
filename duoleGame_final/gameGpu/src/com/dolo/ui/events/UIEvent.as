package com.dolo.ui.events
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		/**
		 * 用户开始拖动窗口 
		 */
		public static const USER_DRAG_WINDOWN_START:String = "userDragWindowStar";
		/**
		 * 用户停止拖动窗口 
		 */
		public static const USER_DRAG_WINDOWN_STOP:String = "userDragWindowStop";
		
		/**
		 *  当用户点击（或程序）切换选项卡的时候抛出此事件，然后使用nowIndex获取索引
		 */
		public static const INDEX_CHANGE:String = "indexChange";
		
		/**
		 * 用户单击item 
		 */
		public static const USER_ITEM_CLICK:String = "userItemClick";
		/**
		 * 用户双击item 
		 */
		public static const USER_ITEM_DOUBLE_CLICK:String = "userItemDoubleClick";
		
		/**
		 * 用户更改index 
		 */
		public static const USER_CHANGE:String = "userChange";
		/**
		 * 用户或代码更改index
		 */
		public static const CHANGE:String = "change";
		/** 选择树干 */
		public static const TREE_TRUNK_CHANGE:String = "treeTrunkChange";
		
		public static const PAGE_CHANGE:String = "pageChange";
		
		public function UIEvent(type:String)
		{
			super(type);
		}
	}
}