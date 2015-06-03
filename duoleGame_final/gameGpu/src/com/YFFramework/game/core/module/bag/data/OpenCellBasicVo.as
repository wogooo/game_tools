package com.YFFramework.game.core.module.bag.data
{
	public class OpenCellBasicVo
	{

		/** 唯一id */
		public var id:int;
		/** 开启几个背包格子 */
		public var cell_pack_num:int;
		/** 需要多久开启（初始化数据时已经转化为"毫秒"了） */
		public var delta_time:Number;
		/** 开启几个仓库格子 */
		public var cell_depot_num:int;

		public function OpenCellBasicVo()
		{
		}
	}
}