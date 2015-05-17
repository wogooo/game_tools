package com.YFFramework.game.core.module.backpack.model
{
	/** 使用消耗性物品后 服务端返回的 信息Vo
	 * 2012-8-21 下午3:17:46
	 *@author yefeng
	 */
	public class UseGoodsResultVo extends UseGoodsVo
	{
		/**使用物品后服务端返回的新个数
		 */		
		public var num:int;
		public function UseGoodsResultVo()
		{
			super();
		}
	}
}