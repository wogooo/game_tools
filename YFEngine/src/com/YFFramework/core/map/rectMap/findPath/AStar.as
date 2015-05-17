package com.YFFramework.core.map.rectMap.findPath
{
	
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;

	/**A星寻路 
	 *     A星  优化原理  ：  http://www.cnblogs.com/pelephone/archive/2012/09/27/astar-fastest.html
	 *  2011-7-9
	 *	@author yefeng
	 */
	public class AStar
	{
		/**开放列表
		 */
		private var _open:BinaryHeap;
		private var _startNode:Node;
		private var _endNode:Node;
		/**最终路径 
		 */
		private var _path:Vector.<Node>;
		private var _grid:GridData;
		private var _nowVersion:int=1;
		public function AStar()
		{
			_open=new BinaryHeap(sortFunc);			
		}
		
		
		public function initData(gridData:GridData):void
		{
			_grid=gridData;
		}
		private function sortFunc(node1:Node,node2:Node):Boolean
		{
			return node1.f<node2.f;
		}
		
		private function findPath(startNode:Node,endNode:Node):Boolean
		{
			_nowVersion++;
			_open.identify();			
			_startNode=startNode;
			_endNode=endNode;
			_startNode.g=0;						
			var ok:Boolean=search();
//			_open.dispose();
//			_open=null;
			if(ok)
			{
				_path=optimize(_path);
				if(_path.length==0) return false;
				// floyd优化 
			//	floyd(_path);
				return true;
			}
			return false
		}
		private	 function search():Boolean {
			var node:Node = _startNode;
			node.version=_nowVersion;
			var test:Node ;
			var cost:Number ;
			var g:Number ;
			var h:Number;
			var f:Number;
			var len:int ; 
			var link:Link;
			while (node != _endNode)
			{
				for each (link in node.aroundArr)
				{
					test= link.node;
					cost =link.cost;
					g = node.g + cost;
					h = heuristic(test,_endNode);
					f = g + h;
					if (test.version == _nowVersion)
					{
						if (test.f > f)
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
						}
					}
					 else 
					{
						test.f = f;
						test.g = g;
						test.h = h;
						test.parent = node;
						_open.ins(test);
						test.version = _nowVersion;
					}
					
				}
				if (_open.a.length == 1)return false;
				node = _open.pop() as Node;
			}
			buildPath();
			return true;
		}
			
			
			
		private function buildPath():void {
			_path =new Vector.<Node>();
			var node:Node = _endNode;
			_path.push(node);
			while (node != _startNode)
			{
				node = node.parent;
				_path.unshift(node);
			}
			
			_path.shift();
			
			doFlody();
		}
		
//		private function heuristic(node:Node,_endNode:Node):Number 
//		{
//			var dx:Number=Math.abs(node.x - _endNode.x);
//			var dy:Number=Math.abs(node.y - _endNode.y);
//			var diag:Number=Math.min(dx, dy);
//			var straight:Number=dx + dy;
//			return Link.DiagCost * diag + Link.StraightCost * (straight - 2 * diag);
//		
//		}
		
//		public function heuristic(node:Node,endNode:Node):int
//		{
////			var dx:Number = Math.abs(node.x - _endNode.x);
////			var dy:Number = Math.abs(node.y - _endNode.y);
////			return (dx + dy)*Link.StraightCost + Math.abs(dx - dy) / 100;
//			var dx:Number = (node.x - _endNode.x)*Link.StraightCost;
//			var dy:Number = (node.y - _endNode.y)*Link.StraightCost;
//			return dx * dx + dy * dy;
//		}
		
		/**山海战纪 估算方法
		 */		
		private function heuristic(startNode:Node,endNode:Node):Number
		{
			return (Math.abs(startNode.x - endNode.x) + Math.abs(startNode.y - endNode.y))*Link.StraightCost;
		}
		  
		/** 优化地图数据
		 */
		private function  optimize(path:Vector.<Node>):Vector.<Node>
		{
			var _floydPath:Vector.<Node>=path.concat();
			var len:int=_floydPath.length;
			if (len > 2){
				var vector:Node =new Node(0, 0);
				var tempVector:Node =new Node(0, 0);
				floydVector(vector, _floydPath[len - 1], _floydPath[len - 2]);
				var myLen:int=_floydPath.length - 3;
				for (var i:int = myLen; i >= 0; i--)
				{
					floydVector(tempVector, _floydPath[i + 1], _floydPath[i]);
					if (vector.x == tempVector.x && vector.y == tempVector.y)
					{
						_floydPath.splice(i + 1, 1);
					} else 
					{
						vector.x = tempVector.x;
						vector.y = tempVector.y;
					}
				}
			}
			
			return _floydPath
		}
		
		
		
		private function floydVector(target:Node, n1:Node, n2:Node):void {
			target.x = n1.x - n2.x;
			target.y = n1.y - n2.y;
		}
		
		
		/**取得行走路径   返回的是 flash坐标下的路径
		 */
		public function getPath():Array
		{
			var arr:Array=[];
			var pt:Point;
			for each (var node:Node in _path)
			{
				pt=new Point(node.x,node.y);
				pt=RectMapUtil.getFlashCenterPosition(pt.x,pt.y);
				arr.push(pt);
			}
			return arr;
		}
		public function getPath2():Vector.<Point>
		{
			var arr:Vector.<Point>=new Vector.<Point>();
			var pt:Point;
			for each (var node:Node in _path)
			{
				pt=new Point(node.x,node.y);
				pt=RectMapUtil.getFlashCenterPosition(pt.x,pt.y);
				arr.push(pt);
			}
			return arr;
		}
		
		/** 进行寻路   
		 * 
		 */		
		public function seachPath(startTilePt:Point,endTilePt:Point):Boolean
		{
			var startNode:Node=_grid.getNode(startTilePt.x,startTilePt.y);
			var endNode:Node=_grid.getNode(endTilePt.x,endTilePt.y);
			if(!endNode.walkable)// return false;
			{
				endNode=_grid.findWakableNode(startNode,endNode);
				if(!endNode) return false;
			}
			return findPath(startNode,endNode);
		}
		
		/**进行floy处理
		 */ 
		private function doFlody():void
		{
			floyd(_path);
		}
		/** 将最终路径进行floyd处理
		 */		
		private function floyd(floydPath:Vector.<Node>):void
		{
			var len:int = floydPath.length;
			var i:int,j:int;
			for (i = len - 1; i >= 0; i--)
			{
				for (j = 0; j <= i - 2; j++)
				{
					if (floydCrossAble(floydPath[i], floydPath[j]))
					{
						for (var k:int = i - 1; k > j; k--)
						{
							floydPath.splice(k, 1);
						}
						i = j;
						len = floydPath.length;
						break;
					}
				}
			}  
		}
		
		
		private function floydCrossAble(n1:Node, n2:Node):Boolean 
		{
			var ps:Vector.<Point> = bresenhamNodes(new Point(n1.x, n1.y), new Point(n2.x, n2.y));
			for (var i:int = ps.length - 2; i > 0; i--)
			{
				if (!_grid.getNode(ps[i].x, ps[i].y).walkable)
				{
					return false;
				}
			}
			return true;
		}
		
		private function bresenhamNodes(p1:Point, p2:Point):Vector.<Point> 
		{
			var steep:Boolean = Math.abs(p2.y - p1.y) > Math.abs(p2.x - p1.x);
			if (steep)
			{
				var temp:int = p1.x;
				p1.x = p1.y;
				p1.y = temp;
				temp = p2.x;
				p2.x = p2.y;
				p2.y = temp;
			}
			var stepX:int = p2.x > p1.x ? 1 : (p2.x < p1.x ? -1 : 0);
			var stepY:int = p2.y > p1.y ? 1 : (p2.y < p1.y ? -1 : 0);
			var deltay:Number = (p2.y - p1.y) / Math.abs(p2.x - p1.x);
			var ret:Vector.<Point> =new Vector.<Point>();
			var nowX:Number = p1.x + stepX;
			var nowY:Number = p1.y + deltay;
			if (steep)
			{
				ret.push(new Point(p1.y, p1.x));
			} else
			{
				ret.push(new Point(p1.x, p1.y));
			}
			var fy:int,cy:int; 
			while (nowX != p2.x)
			{
				fy= Math.floor(nowY)
				cy= Math.ceil(nowY);
				if (steep)
				{
					ret.push(new Point(fy, nowX));
				} else
				{
					ret.push(new Point(nowX, fy));
				}
				if (fy != cy)
				{
					if (steep)
					{
						ret.push(new Point(cy, nowX));
					} else 
					{
						ret.push(new Point(nowX, cy));
					}
				}
				nowX += stepX;
				nowY += deltay;
			}
			if (steep)
			{
				ret.push(new Point(p2.y, p2.x));
			} else 
			{
				ret.push(new Point(p2.x, p2.y));
			}
			return ret;
		}
	}
}