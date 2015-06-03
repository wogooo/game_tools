package com.YFFramework.core.map.rectMap.findPath
{
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;
	

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
		public var f:Number=0;
		public var g:Number=0;
		public var h:Number=0;
		
		public var parent:Node;
		
		public var version:int=1;
		
		/** 周围八个格子 ，采用预存  极大优化搜索效率
		 */
//		public var aroundArr:Vector.<Link>;
		public var aroundArr:Vector.<Array>;
		
		

		/** obj  具有参数  x  y   id 
		 * @param obj
		 */
		public function Node(x:int=0,y:int=0,id:int=0)
		{
			this.x=x;
			this.y=y;		
			this.id=id;
//			aroundArr=new Vector.<Link>();
			aroundArr=new Vector.<Array>();
//			f=0;
//			g=0;
//			h=0;
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
			if(id==TypeRoad.Block||id==TypeRoad.Fly2) return false;
			return true;
		}
			
		/**对象池中获取数据重新初始化
		 */		
//		public function initFromPool(x:int=0,y:int=0,id:int=0):void
//		{
//			this.x=x;
//			this.y=y;		
//			this.id=id;
//			aroundArr.length=0;
//			f=0;
//			g=0;
//			h=0;
//			version=1;
//		}
		
		
		/**获取相链周围可走的点
		 * 返回的是flash坐标
		 */
		public function getWalkAbleNode():Point
		{
			var len:int=aroundArr.length;
			var node:Node
			for(var i:int=0;i!=len;++i)
			{
				node=aroundArr[i][0];
				if(node.id!=TypeRoad.Block)  //不为障碍点
				{
					return RectMapUtil.getFlashCenterPosition(node.x,node.y);
				}
			}
			return null;
		}
	}
}