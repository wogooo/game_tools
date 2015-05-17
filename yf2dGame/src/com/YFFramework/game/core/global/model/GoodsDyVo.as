package com.YFFramework.game.core.global.model
{
	/** 物品的动态vo 
	 * @author yefeng
	 *2012-7-28上午9:22:35
	 */
	public class GoodsDyVo
	{
		/** 物品动态id      由于 服务端的id 是增长型的  所以 用int型可能会溢出 所以 用字符串来表示
		 */
		public var  dyId:String;
		/**物品静态id 
		 */
		public var basicId:int;
		
		/**物品所在位置 是在仓库 还是在背包 还是在其他位置 
		 */
		public var position:int;
		/**格子数  索引时从 1 开始的
		 */
		public var gridNum:int;
		
		/**物品个数
		 */
		public var num:int;
		public function GoodsDyVo()
		{
		}
	}
}