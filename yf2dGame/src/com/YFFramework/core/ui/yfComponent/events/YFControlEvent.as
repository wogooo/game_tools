package com.YFFramework.core.ui.yfComponent.events
{
	/** 控件 所有事件的集合
	 * 
	 *   2012-6-21
	 *	@author yefeng
	 */
	public class YFControlEvent
	{
		private static const Path:String="com.YFFramework.game.ui.yfComponent.events.";
		
		public static const Select:String=Path+"Select";
		
		/**发生改变时触发的事件
		 */
		public static const SelectChange:String=Path+"SelectChange";
		
		public function YFControlEvent()
		{
		}
	}
}