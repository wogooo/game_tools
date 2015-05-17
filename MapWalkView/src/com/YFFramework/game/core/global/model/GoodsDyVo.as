package com.YFFramework.game.core.global.model
{
	/**物品  包含 位置 和格子
	 * @author yefeng
	 * 2013 2013-3-19 下午4:52:38 
	 */
	public class GoodsDyVo
	{
		/** 格子位置
		 */		
		public var position:int;
		/**类型  		0 ==空  1==装备 ,2==道具    值在  ItemType里面
		 */		
		public var type:int; 
		public function GoodsDyVo()
		{
		}
	}
}