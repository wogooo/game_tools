package com.YFFramework.game.core.module.newGuide.events
{
	/**@author yefeng
	 * 2013 2013-10-14 下午5:23:06 
	 */
	public class NewGuideEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.newGuide.events.";
		/**引导宠物出战事件
		 */
//		public static const GuidePetFight:String=Path+"NewGuideEvent";
		
//		/**  引导坐骑 出战  --- 给 游戏界面下排按钮 坐骑按钮  画方形进行引导
//		 */
//		public static const GuideMountFightToRectMainUIMountBtn:String=Path+"GuideMountFightToRectMainUIMountBtn";
		
		/**引导坐骑 出战  ---给坐骑界面  出战按钮上画 方形 进行引导
		 */
		public static const GuideMountFightToRectMountWindowFightBtn:String=Path+"GuideMountFightToRectMountWindowFightBtn";

		/** 引导坐骑 出战  ---  关闭   坐骑窗口
		 */
		public static const GuideMountFightToCloseWindow:String=Path+"GuideMountFightToCloseWindow";


		public function NewGuideEvent()
		{
		}
	}
}