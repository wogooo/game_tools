package com.YFFramework.game.core.module.backpack.model
{
	/**
	 * 单一 窗口中移动物品  比如 背包内 物品 移动  或者仓库 内物品移动 但是不包括  跨窗口间的拖动
	 * @author yefeng
	 *2012-8-18下午11:18:11
	 */
	public class SimpleMoveGoodsVo
	{
		
		/**移动物品的动态id 
		 */		
		public var movingDyId:String;
		/**移动到的格子数
		 */		
		public var toGridNum:int;
		public function SimpleMoveGoodsVo()
		{
		}
	}
}