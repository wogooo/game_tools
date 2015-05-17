package com.YFFramework.core.map.rectMap.findPath
{
	import com.YFFramework.core.center.pool.IPool;

	/**  2012-7-9
	 *	@author yefeng
	 */
	public class Node 
	{
		/** tileX值
		 */
		public var x:int;
		/** tileY值
		 */
		public var y:int;
		
		/**值 表示改点的类型 值属于  TypeRoad
		 */
		public var id:int;///值属于  TypeRoad
		
		
		
		
		/**   f   g   h  点 
		 */
		public var f:Number;
		public var g:Number;
		public var h:Number;
		
		public var parent:Node;
		
		public var version:int=1;
		
		/** 周围八个格子 ，采用预存  极大优化搜索效率
		 */
		public var aroundArr:Vector.<Link>;
		/** obj  具有参数  x  y   id 
		 * @param obj
		 */
		public function Node(x:int=0,y:int=0,id:int=0)
		{
			this.x=x;
			this.y=y;		
			this.id=id;
			aroundArr=new Vector.<Link>();
			f=0;
			g=0;
			h=0;
			version=1;
		}
		
		public function dispose():void
		{
			aroundArr=null;
			parent=null;
		}
		
		
		/** 是否可走 
		 */
		public  function get walkable():Boolean
		{
			if(id==TypeRoad.Block||id==TypeRoad.Fly1||id==TypeRoad.Fly2) return false;
			return true;
		}
		
			
	}
}