package com.YFFramework.core.map.rectMap.findPath
{
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	
	import flash.geom.Point;

	/** 网格数据控制器    单例
	 * 
	 *  2012-7-13
	 *	@author yefeng
	 */
	public class GridData
	{
		
		/**直线消耗
		 */
		public static const StraightCost:int=10;
		/**斜线消耗
		 */
		public static const DiagCost:int=14;

		/**进行搜索时的调节范围
		 */
		private static var StretchYLen:int=1;
		private static const StretchXLen:int=1;
		/**  xx文件数据对象
		 */
		private var _xxObj:Object;
		/**  保存所有的 节点信息
		 */
		private var _nodeArr:Vector.<Node>;
		
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
			if(_nodeArr)removePreNodes();
			_nodeArr=new Vector.<Node>();
			var len:int=RectMapConfig.Len;
			_nodeArr.length=len;
			var floor:Array=_xxObj.floor;
			var id:int;
			var i:int,k:int,m:int;
			var node:Node;
			var tileArr:Array;
			
			var startX:int;
			var endX:int;
			var startY:int;
			var endY:int;              
//			var t:Number=getTimer();
			for(i=0;i!=len;++i)
			{
				id=int(floor[i]);
				tileArr=RectMapUtil.getTilePostionByIndex2(i);
				node=new Node(tileArr[0],tileArr[1],id);//
				_nodeArr[tileArr[1]*RectMapConfig.columns+tileArr[0]]=node;
			}
			
//			print(this,"第一次消耗时间为::"+(getTimer()-t)+",长度:" +len);
			
//			t=getTimer();
			///创建周围八点 
			var otherNode:Node;
//			var link:Link;
			var link:Array;
			var cost:Number = StraightCost;
//			for each (node in _nodeArr)
			for(i=0;i!=len;++i)
			{
				node=_nodeArr[i];  // for (i++)的性能远远高于for each 
				
				//找出相邻节点的x,y范围
				startX=Math.max(0, node.x - 1);
				endX=Math.min(RectMapConfig.columns - 1, node.x + 1);
				startY=Math.max(0, node.y - 1);
				endY=Math.min(RectMapConfig.rows - 1, node.y + 1);              
				//循环处理所有相邻节点
				for (k=startX; k <= endX; ++k)
				{
					for (m=startY; m <= endY;++m)
					{
						otherNode=_nodeArr[m*RectMapConfig.columns+k];//getNode(k,m);
					//	if(node==otherNode||!otherNode.walkable||!getNode(node.x, otherNode.y).walkable || !getNode(otherNode.x, node.y).walkable) continue;
						if(!(node==otherNode||
							otherNode.id==TypeRoad.Block||
							_nodeArr[otherNode.y*RectMapConfig.columns+node.x].id==TypeRoad.Block||
							_nodeArr[node.y*RectMapConfig.columns+otherNode.x].id==TypeRoad.Block))
						{
							if ((node.x == otherNode.x)|| (node.y == otherNode.y))	cost = StraightCost;
							else cost=DiagCost;
							link=[otherNode,cost];
							node.aroundArr.push(link);
						}
					}
				}
			}
//			print(this,"第二次消耗时间为::"+(getTimer()-t));
			_xxObj=null;
		}
		
		
		
		/**根据 tile坐标获取节点数据
		 */
		public function getNode(tileX:int,tileY:int):Node
		{
			var index:int=tileY*RectMapConfig.columns+tileX;
			if(index<RectMapConfig.Len)
			{
				if(_nodeArr)return _nodeArr[index];
			}
			return null;
		}
		
		
		
		/**移除先前的节点 
		 */
		private function removePreNodes():void
		{
			_gridStartNode=null;
			_gridEndNode=null;
		}

		/** 返回可走的点
		 * @param startX   flash 坐标 地图坐标
		 * @param startY
		 * @param endX
		 * @param endY
		 * @return 
		 * 
		 */
		public function findWakablePt(startX:int,startY:int,endX:int,endY:int):Point
		{
			var startPt:Point=RectMapUtil.getTilePosition(startX,startY);
			var endPt:Point=RectMapUtil.getTilePosition(endX,endY);
			startPt=getUsablePt(startPt);
			endPt=getUsablePt(endPt);
			var startNode:Node=getNode(startPt.x,startPt.y);
			var endNode:Node=getNode(endPt.x,endPt.y);
			var node:Node=findWakableNode(startNode,endNode);
			return RectMapUtil.getFlashCenterPosition(node.x,node.y);
		}
		
		
		
		/** 寻找可走的路点
		 */
		public function findWakableNode(startNode:Node,endNode:Node):Node
		{
			var hSpace:int=Math.abs(endNode.x-startNode.x);
			var vSpace:int=Math.abs(endNode.y-startNode.y);
			var node:Node;
//			var arr:Array=[];
			
			var lineX:int;
			var lineY:int;
			var nodeX:int;
			var nodeY:int;
			
			var mY:int;
			var mX:int;    
//			if(hSpace>=vSpace) //  与竖线相交
//			{
			if(endNode.y>=startNode.y)   //// endY  >= startY
			{
				if(endNode.x>=startNode.x)
				{
					for(mX=endNode.x;mX>=startNode.x;mX--)
					{
						for(mY=endNode.y;mY>=startNode.y;mY-- )
						{
							nodeY=mY;
							nodeX=mX;//(nodeY-startNode.y)/k+startNode.x;
							node=getNode(nodeX,nodeY);
							if(node.walkable&&endNode!=node&&startNode!=node)
							{
								return node;
							}
						}
					}
				}
				else 
				{
					for(mX=endNode.x;mX<=startNode.x;mX++)
					{
						for(mY=endNode.y;mY>=startNode.y;mY-- )
						{
							nodeY=mY;
							nodeX=mX;//(nodeY-startNode.y)/k+startNode.x;
							node=getNode(nodeX,nodeY);
							if(node.walkable&&endNode!=node&&startNode!=node)
							{
								return node;
							}
						}
					}
				}
			}
			else /// endY<=startY
			{
				if(endNode.x>=startNode.x)
				{
					for(mX=endNode.x;mX>=startNode.x;mX--)
					{
						for(mY=endNode.y;mY<=startNode.y;mY++)
						{
							nodeY=mY;
							nodeX=mX;//(nodeY-startNode.y)/k+startNode.x;
							node=getNode(nodeX,nodeY);
							if(node.walkable&&endNode!=node&&startNode!=node)
							{
								return node;
							}
						}
					}
				}
				else 
				{
					for(mX=endNode.x;mX<=startNode.x;mX++)
					{
						for(mY=endNode.y;mY<=startNode.y;mY++)
						{
							nodeY=mY;
							nodeX=mX;//(nodeY-startNode.y)/k+startNode.x;
							node=getNode(nodeX,nodeY);
							if(node.walkable&&endNode!=node&&startNode!=node)
							{
								return node;
							}
						}
					}
				}
			}      
			
			var chekeLen:int=10;
			var totalCheckLen:int=chekeLen*4;
			var testK:int;
			var xSpace:int=0;
			var ySpace:int=0;
			for(var i:int=0;i!=totalCheckLen;++i)
			{
				testK=i%4;
				if(testK==0||testK==1)xSpace++;
				else if(testK==2||testK==3)ySpace++;
				if(ySpace>5)ySpace=5;
				switch(testK)
				{
					case 0: //为0    判断 x  正方向
						mX=endNode.x+xSpace;
						if(mX>_gridEndNode.x)mX=_gridEndNode.x;
						node=getNode(mX,endNode.y);
						break;
					case 1: //为1	判断x  负方向
						mX=endNode.x-xSpace;
						if(mX<0)mX=0;
						node=getNode(mX,endNode.y);
						break;
					case 2: //为2	判断 y正方向                  
						mY=endNode.y+ySpace;
						if(mY>_gridEndNode.y)mY=_gridEndNode.y;
						node=getNode(endNode.x,mY);
						break;
					case 3: //为3	判断y负方向
						mY=endNode.y-ySpace;
						if(mY<0)mY=0;
						node=getNode(endNode.x,mY);
						break;
				}
				if(node.walkable&&endNode!=node&&startNode!=node)	return node;
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
			if(node)
			{
				if(node.id==TypeRoad.Block) return true;
			}
			return false;
		}
		/**是否为障碍点 flashX flashY   map  flash坐标
		 */		
		public function isBlock2(flashX:int,flashY:int):Boolean
		{
			var pt:Point=RectMapUtil.getTilePosition(flashX,flashY);
			return isBlock(pt.x,pt.y);
		}
		
		/** 获取周围可走的 节点 ，节点 附近 八点 可走的点 
		 * 没有则返回 null
		 *   返回值是返回的是地图flash坐标
		 */
		public function  getWalkAbleMapPoint(mapX:int,mapY:int):Point
		{
			var tilePt:Point=RectMapUtil.getTilePosition(mapX,mapY);
			var node:Node=getNode(tilePt.x,tilePt.y);
			return node.getWalkAbleNode();
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
			var pt:Point=new Point(startX,startY);
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
	}
}