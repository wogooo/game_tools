package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.center.manager.update.UpdateManager;

	/**人物角色 速度管理器
	 * @author yefeng
	 *2012-8-24下午11:42:33
	 */
	public class SpeedManager
	{
		/**  人物实际移动速度
		 */		
		public var walkSpeed:Number;
//		public var mountSpeed:Number
		public function SpeedManager()
		{
			walkSpeed=200/UpdateManager.UpdateRate;
//			mountSpeed=12;
		}
	}
}