package com.YFFramework.core.map.rectMap.findPath
{
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.IPool;

	/**  2012-7-13
	 *	@author yefeng
	 */
	public class Link 
	{
		/**直线消耗
		 */
		public static const StraightCost:int=10;
		/**斜线消耗
		 */
		public static const DiagCost:int=14;
		
		/**节点
		 */
		public var node:Node;
		/** 节点 与相邻节点之间的消耗
		 */
		public var cost:int;
		/**
		 * @param obj=={node:Node,cost:int}
		 */		
		public function Link(node:Node,cost:int)
		{
		
			this.node=node;
			this.cost=cost;
		}
		
		
				
		
		
	}
}