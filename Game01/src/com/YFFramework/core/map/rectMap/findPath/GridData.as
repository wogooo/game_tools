package com.YFFramework.core.map.rectMap.findPath
{
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/** 网格数据控制器    单例
	 * 
	 *  2012-7-13
	 *	@author yefeng
	 */
	public class GridData
	{
		
		/**进行搜索时的调节范围
		 */
		private static var StretchYLen:int=4;
		private static const StretchXLen:int=3;
		
		/**  xx文件数据对象
		 */
		private var _xxObj:Object;
		/**  保存所有的 节点信息
		 */
		private var _nodeDict:Dictionary;
		
		private  static var _instance:GridData;
		/**起始路点
		 */
		private	var _gridStartNode:Node;
		/**结束路点 
		 */
		private var _gridEndNode:Node;

		public function GridData()
		{
		}
		public static function get Instance():GridData
		{
			if(!_instance) _instance=new GridData();
			return _instance; 
		}
		
		/**  填充数据
		 */
		public function initData(xxObj:Object):void
		{
			_xxObj=xxObj;
			RectMapConfig.tileW=xxObj.tileW;
			RectMapConfig.tileH=xxObj.tileH;
			RectMapConfig.gridW=xxObj.gridW;
			RectMapConfig.gridH=xxObj.gridH;
			RectMapConfig.rows=xxObj.rows;
			RectMapConfig.columns=xxObj.columns;
			initNodes();
			_gridStartNode=getNode(0,0);
			_gridEndNode=getNode(RectMapConfig.columns-1,RectMapConfig.rows-1);

		}
		/**初始化 node点
		 */
		private function initNodes():void
		{
			if(_nodeDict)removePreNodes();
			_nodeDict=new Dictionary();
			var floor:Array=_xxObj.floor;
			var id:int;
			var i:int,k:int,m:int;
			var len:int=RectMapConfig.Len;
			var node:Node;
			var tilePoint:Point;
			var key:String;
			
			var startX:int;
			var endX:int;
			var startY:int;
			var endY:int;              
			for(i=0;i!=len;++i)
			{
				id=int(floor[i]);
				tilePoint=RectMapUtil.getTilePostionByIndex(i);
				node=new Node(tilePoint.x,tilePoint.y,id);
			//	node=new Node({x:tilePoint.x,y:tilePoint.y,id:id})//PoolCenter.Instance.getFromPool(Node,{x:tilePoint.x,y:tilePoint.y,id:id}) as Node;
				key=getStr(tilePoint.x,tilePoint.y);
				_nodeDict[key]=node;
			}
			
			///创建周围八点 
			var otherNode:Node;
			var link:Link;
			var cost:Number = Link.StraightCost;
			for each (node in _nodeDict)
			{
				//找出相邻节点的x,y范围
				startX=Math.max(0, node.x - 1);
				endX=Math.min(RectMapConfig.columns - 1, node.x + 1);
				startY=Math.max(0, node.y - 1);
				endY=Math.min(RectMapConfig.rows - 1, node.y + 1);              
				//循环处理所有相邻节点
				for (k=startX; k <= endX; k++)
				{
					for (m=startY; m <= endY;m++)
					{
						otherNode=getNode(k,m);
						if(node==otherNode||!otherNode.walkable||!getNode(node.x, otherNode.y).walkable || !getNode(otherNode.x, node.y).walkable) continue;
						if ((node.x == otherNode.x)|| (node.y == otherNode.y))	cost = Link.StraightCost;
						else cost=Link.DiagCost;
						link=new Link(otherNode,cost);
						node.aroundArr.push(link);
					}
				}
			//	node.aroundArrLen=node.aroundArr.length;			
			}
			_xxObj=null;
		}
		
		/** 得到 唯一key 值 
		 */
		private function getStr(x:int,y:int):String
		{
			return x+"_"+y;
		}
		
		/**根据 tile坐标获取节点数据
		 */
		public function getNode(tileX:int,tileY:int):Node
		{
			if(_nodeDict)return _nodeDict[getStr(tileX,tileY)]
			return null;
		}
		
		
		public function dispose():void
		{
			_xxObj=null;
			for each (var node:Node in _nodeDict)
			{
				node.dispose();
			}
			node=null;
			_nodeDict=null;
			_gridStartNode=null;
			_gridEndNode=null;
		}
		
		/**移除先前的节点 
		 */
		private function removePreNodes():void
		{
//			for each (var node:Node in _nodeDict)
//			{
//				node.dispose();
//			}
//			node=null;
			_gridStartNode=null;
			_gridEndNode=null;
		}
		
		
		
		/** 寻找可走的路点
		 */
		public function findWakableNode(startNode:Node,endNode:Node):Node
		{
			//寻找 附近可走点
			var seachX:int,seachY:int;
			var findNode:Node;
			var stretchY:int;
			var stretchX:int;
			if(startNode.x<=endNode.x&&startNode.y<=endNode.y)
			{		
				stretchX=endNode.x+StretchXLen;
				stretchY=endNode.y+StretchYLen;
				stretchX=stretchX>RectMapConfig.columns-1?RectMapConfig.columns-1:stretchX;
				stretchY=stretchY>RectMapConfig.rows-1?RectMapConfig.rows-1:stretchY;
				endNode=getNode(stretchX,stretchY);
				for (seachX=endNode.x;seachX>=_gridStartNode.x;seachX--)
				{
					for (seachY=endNode.y;seachY>_gridStartNode.y;seachY--)
					{
						findNode=getNode(seachX,seachY);
						//	if(findNode!=startNode&&findNode.walkable) return findNode;
						if(findNode.walkable) return findNode;

					}
				}
			}
			else if(startNode.x>=endNode.x&&startNode.y<=endNode.y)
			{
				stretchX=endNode.x-StretchXLen;
				stretchY=endNode.y+StretchYLen;
				stretchX=stretchX<0?0:stretchX;
				stretchY=stretchY>RectMapConfig.rows-1?RectMapConfig.rows-1:stretchY;
				endNode=getNode(stretchX,stretchY);
				for (seachX=endNode.x;seachX<=_gridEndNode.x;seachX++)
				{
					for (seachY=endNode.y;seachY>=_gridStartNode.y;seachY--)
					{
						findNode=getNode(seachX,seachY);
						//	if(findNode!=startNode&&findNode.walkable) return findNode;
						if(findNode.walkable) return findNode;

					}
				}
			}
			
			else if(startNode.x<=endNode.x&&startNode.y>=endNode.y)
			{
				stretchX=endNode.x+StretchXLen;
				stretchY=endNode.y-StretchYLen;
				stretchX=stretchX>RectMapConfig.columns-1?RectMapConfig.columns-1:stretchX;
				stretchY=stretchY<0?0:stretchY;
				endNode=getNode(stretchX,stretchY);

				for (seachX=endNode.x;seachX>=_gridStartNode.x;seachX--)
				{
					for (seachY=endNode.y;seachY<=_gridEndNode.y;seachY++)
					{
						findNode=getNode(seachX,seachY);
						//	if(findNode!=startNode&&findNode.walkable) return findNode;
						if(findNode.walkable) return findNode;

					}
				}
			}
			
			else if(startNode.x>=endNode.x&&startNode.y>=endNode.y)
			{
				stretchX=endNode.x-StretchXLen;
				stretchY=endNode.y-StretchYLen;
				stretchX=stretchX<0?0:stretchX;
				stretchY=stretchY<0?0:stretchY;
				endNode=getNode(stretchX,stretchY);
				for (seachX=endNode.x;seachX<=_gridEndNode.x;seachX++)
				{
					for (seachY=endNode.y;seachY<_gridEndNode.y;seachY++)
					{
						findNode=getNode(seachX,seachY);
					//	if(findNode!=startNode&&findNode.walkable) return findNode;
						if(findNode.walkable) return findNode;
					}
				}
			}
			
			return null;
		}
		
		
		/** 是否为地图跳转点  px py  是地图的像素坐标
		 */
		public function isSkipNode(px:int,py:int):Boolean
		{
			var tilePt:Point=RectMapUtil.getTilePosition(px,py);
			var node:Node=getNode(tilePt.x,tilePt.y);
			if(node.id==TypeRoad.Skip) return true;
			return false;
		}
		/**是否为障碍点 tileX tileY 为 tile坐标
		 */		
		public function isBlock(tileX:int,tileY:int):Boolean
		{
			var node:Node=getNode(tileX,tileY);
			if(node.id==TypeRoad.Block) return true;
			return false;

		}
		
		
		
		/**  返回的是地图世界下的坐标下的坐标     也就是flash坐标
		 * startX  startY  endX  endY   都是地图世界下的坐标 也就是flash坐标
		 * startX startY开始位置
		 * endX endY 要直线移动到的位置
		 *  检测 startX startY 到endX,endY这条直线之间是否有障碍点 如果有则取障碍点的前一个点  
		 * 返回实际能运动到的点 startX startY endX endY  这条直线上的点
		 */		
		public  function getMoveToEndPoint(startX:int,startY:int,endX:int,endY:int):Point
		{
			var pt:Point;
			var arr:Array=[];
			if(startX>=0&&startX<=RectMapConfig.gridW&&startY>=0&&startY<=RectMapConfig.gridH&&endX>=0&&endX<=RectMapConfig.gridW&&endY>=0&&endY<=RectMapConfig.gridH)
			{
				///  算出与垂直的线相交的点
				var startTilePt:Point=RectMapUtil.getTilePosition(startX,startY);
				var endTilePoint:Point=RectMapUtil.getTilePosition(endX,endY);
				var line:int;
				var ptX:int;
				var ptY:int;
				var testLine:Number;
				var mapPt:Point;
				if(startTilePt.x==endTilePoint.x)
				{
					
					if(endTilePoint.y>startTilePt.y)
					{
						for(line=startTilePt.y+1;line<=endTilePoint.y;++line)
						{
							ptX=startTilePt.x;
							ptY=line;
							if(!isBlock(ptX,ptY))
							{
								mapPt=RectMapUtil.getFlashCenterPosition(ptX,ptY);
								arr.push(mapPt);
							}
							else 
							{
								if(arr.length>0)pt=arr.pop();
								return pt;
							}
						}
					}
					else 
					{
						for(line=startTilePt.y-1;line>=endTilePoint.y;line--)
						{
							ptX=startTilePt.x;
							ptY=line;
							if(!isBlock(ptX,ptY))
							{
								mapPt=RectMapUtil.getFlashCenterPosition(ptX,ptY);
								arr.push(mapPt);
							}
							else 
							{
								if(arr.length>0)pt=arr.pop();
								return pt;
							}
							
						}
					}
				}
				else 
				{
					var k:Number=(endTilePoint.y-startTilePt.y)/(endTilePoint.x-startTilePt.x);
					if(startTilePt.x>endTilePoint.x)
					{
						for(line=startTilePt.x-1;line>=endTilePoint.x;line--)
						{
							ptX=line;
							ptY=int(k*(line-startTilePt.x)+startTilePt.y);
							if(!isBlock(ptX,ptY))
							{
								mapPt=RectMapUtil.getFlashCenterPosition(ptX,ptY);
								arr.push(mapPt);
							}
							else 
							{
								if(arr.length>0)pt=arr.pop();
								return pt;
							}
							
							
							if(ptX>=1)
							{
								if(!isBlock(ptX-1,ptY))
								{
									mapPt=RectMapUtil.getFlashCenterPosition(ptX-1,ptY);
									arr.push(mapPt);
								}
								else 
								{
									if(arr.length>0)pt=arr.pop();
									return pt;
								}
							}
						}
					}
					else 
					{
						for(line=startTilePt.x+1;line<=endTilePoint.x;line++)
						{
							ptX=line;
							ptY=int(k*(line-startTilePt.x)+startTilePt.y);
							if(ptX>=1)
							{
								if(!isBlock(ptX-1,ptY))
								{
									mapPt=RectMapUtil.getFlashCenterPosition(ptX-1,ptY);
									arr.push(mapPt);
								}
								else 
								{
									if(arr.length>0)pt=arr.pop();
									return pt;
								}
							}
							if(!isBlock(ptX,ptY))
							{
								mapPt=RectMapUtil.getFlashCenterPosition(ptX,ptY);
								arr.push(mapPt);
							}
							else 
							{
								if(arr.length>0)pt=arr.pop();
								return pt;
							}
							
						}
					}
				}
			}
			if(arr.length>0)pt=arr.pop();
			return pt;
		}
		/**  获取转化在格子范围内的点 
		 */		
		public function getUsablePt(pt:Point):Point
		{
			var myX:int=pt.x;
			var myY:int=pt.y;
			if(myX<0)myX=0;
			else if(myX>_gridEndNode.x)myX=_gridEndNode.x;
			if(myY<0)myY=0;
			else if(myY>_gridEndNode.y)myY=_gridEndNode.y;
			pt.x=myX;
			pt.y=myY;
			return pt;
		}
		
	}}