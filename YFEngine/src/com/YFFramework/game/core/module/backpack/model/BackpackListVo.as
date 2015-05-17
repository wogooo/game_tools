package com.YFFramework.game.core.module.backpack.model
{
	/** 背包物品列表
	 * 2012-8-17 下午5:16:55
	 *@author yefeng
	 */
	public class BackpackListVo
	{
		/**
		 * 背包容量大小
		 */
		public var  size:int;
		/**
		 * 背包列表  list内部保存的是 GoodsDyVo 的 Object类型数据
		 */
		public var   list:Object;

		/**金币数量
		 */
		public var gold:Number;
		
		/**元宝数数量
		 */
		public var yuanBao:Number;
		
		public function BackpackListVo()
		{
		}
	}
}