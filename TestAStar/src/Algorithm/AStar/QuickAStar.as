package Algorithm.AStar
{
	import flash.sampler.getSize;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class QuickAStar
	{
		private const MAX_FIND_NODE:int 	= 8192;
		
		private const STRAIGHT_G:int		= 10;
		private const ITALIC_G:int			= 14;
		
		private const NOT_CHECKED:int		= 0;	// 初始状态
		private const IN_OPEN_LIST:int		= 1;	// 处于开放列表
		private const IN_CLOSE_LISET:int	= 2;	// 处于关闭列表
		
		private const INIT_BOUND:int		= int.MAX_VALUE - 1;
		
		/**
		 * 节点属性 
		 */		
		public var	nodeDirection:Vector.<int>;		// 方向
		public var 	nodeGValue:Vector.<int>;
		public var 	nodeFValue:Vector.<int>;
		public var	heapIndex:Vector.<int>;		// 二叉堆使用
		
		// 地图长宽（以格子计）
		private var rowCount:int;
		private var colCount:int;
		// 标记行走
		private var walkable:Vector.< Vector.<Boolean> >;
		// 寻路结点
		private var state:Vector.< Vector.<int> >;
		private var nowBound:int;
		// 二叉堆
		private var heap:Vector.<int>;
		private var nodeCount:int;
		// 预处理方向
		public var direction:Vector.< Vector.<int> >;
		
		/**
		 * 
		 * @param mapRow
		 * @param mapCol
		 * @return 
		 * 
		 */		
		public function QuickAStar(mapCol:int, mapRow:int)
		{
			rowCount = mapRow;
			colCount = mapCol;
			var len:int = mapRow * mapCol;
			// 各种new
			heap = new Vector.<int>();
			nodeDirection = new Vector.<int>(len, true);		// 方向
			nodeGValue = new Vector.<int>(len, true);
			nodeFValue = new Vector.<int>(len, true);
			heapIndex = new Vector.<int>(len, true);		// 二叉堆使用
			
			walkable = new Vector.<Vector.<Boolean>>(mapRow, true);
			
			state = new Vector.<Vector.<int>>(mapRow, true);
			for (var i:int = 0; i < mapRow; ++i)
			{
				walkable[i] = new Vector.<Boolean>(mapCol, true);
				state[i] = new Vector.<int>(mapCol, true);
				for (var j:int = 0; j < mapCol; ++j)
				{
					walkable[i][j] = false;
				}
			}
			
			direction = new Vector.< Vector.<int> >(mapRow, true);
			for (i = 0; i < mapRow; ++i)
			{
				direction[i] = new Vector.<int>(mapCol, true);
				for (j = 0; j < mapCol; ++j)
				{
					direction[i][j] = 0;
				}
			}
			
			nowBound = INIT_BOUND - IN_CLOSE_LISET;
		}
		/**
		 * 
		 * @param nIndex1
		 * @param nIndex2
		 * 
		 */		
		private function swap(nIndex1:int, nIndex2:int):void
		{
			var temp:int = heap[nIndex1]; 
			heap[nIndex1] = heap[nIndex2];
			heap[nIndex2] = temp;
			heapIndex[heap[nIndex1]] = nIndex1;
			heapIndex[heap[nIndex2]] = nIndex2;
		}
		/**
		 * 
		 * @param pNode
		 * 
		 */		
		private function Insert(pNode:int):void
		{
			heap[nodeCount] = pNode;
			var nResult:int = nodeCount;
			if (nodeCount > 0)
			{
				var nChild:int = nodeCount;
				var nParent:int = (nChild - 1) >> 1;
				for (; ;)
				{
					if (nodeFValue[heap[nChild]] < nodeFValue[heap[nParent]])
					{
						swap(nChild, nParent);
						nResult = nParent;
						if (nParent == 0)
						{
							break;
						}
					}
					else
					{
						break;
					}
					
					nChild = nParent;
					nParent = (nChild - 1) >> 1;
				}
			}
			heapIndex[pNode] = nResult;
			++nodeCount;
		}
		/**
		 * 
		 * @param pNode
		 * @param newValue
		 * 
		 */		
		private function ChangeValue(pNode:int, newValue:int):void
		{
			if (nodeFValue[pNode] != newValue)
			{
				var nIndex:int = heapIndex[pNode];
				nodeFValue[pNode] = newValue;
				
				// 先向上比较
				var nChild:int = nIndex;
				var nParent:int;
				for (;;)
				{
					if (nChild <= 0)
					{
						break;
					}
					nParent = (nChild - 1) >> 1;
					if (newValue <= nodeFValue[heap[nParent]])
					{
						swap(nChild, nParent);
						nChild = nParent;
					}  
					else
					{
						break;
					}
				}
				// 物是人非
				if (nChild != nIndex)
				{
					return;
				}
				// 向下比较
				nParent = nIndex;
				var nChild1:int = (nParent<<1) + 1;
				var nChild2:int = (nParent<<1) + 2;
				for (;;)
				{
					if (nChild1 >= nodeCount)
					{
						return;
					}
						// 仅有一个子节点
					else if (nChild2 >= nodeCount)
					{
						if (nodeFValue[heap[nParent]] > nodeFValue[heap[nChild1]])
						{
							swap(nParent, nChild1);
						}
						return;
					}
					else
					{
						// child1较小
						if (nodeFValue[heap[nChild1]] <= nodeFValue[heap[nChild2]])
						{
							if (nodeFValue[heap[nChild1]] < nodeFValue[heap[nParent]])
							{
								swap(nChild1, nParent);
								nParent = nChild1;
							}
							else
							{
								break;
							}
						}
						// child2较小
						else
						{
							if (nodeFValue[heap[nChild2]] < nodeFValue[heap[nParent]])
							{
								swap(nChild2, nParent);
								nParent = nChild2;
							}
							else
							{
								break;
							}
						}
						nChild1 = (nParent<<1) + 1;
						nChild2 = (nParent<<1) + 2;
					}
				}
			}
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		private function PopFront():int
		{
			if (nodeCount == 0)
			{
				return -1;
			}
			var result:int = heap[0];
			heap[0] = heap[nodeCount - 1];
			heapIndex[heap[0]] = 0;
			--nodeCount;
			if (nodeCount > 1)
			{
				// 重排序
				var nParent:int = 0;
				var nChild1:int = 1, nChild2:int = 2;
				for (;;)
				{
					if (nChild1 >= nodeCount)
					{
						break;
					}
					else if (nChild2 >= nodeCount)
					{
						if (nodeFValue[heap[nChild1]] < nodeFValue[heap[nParent]])
						{
							swap(nChild1, nParent);
						}
						break;
					}
					else
					{
						// child2较小
						var child:int = nChild1;
						// child2较小
						if (nodeFValue[heap[nChild2]] < nodeFValue[heap[nChild1]])
						{
							child = nChild2;
						}
						
						if (nodeFValue[heap[child]] < nodeFValue[heap[nParent]])
						{
							swap(child, nParent);
							nParent = child;
						}
						else
						{
							break;
						}
					}
					nChild1 = (nParent<<1) + 1;
					nChild2 = (nParent<<1) + 2;
				}
			}
			return result;
		}
		
		/**
		 * 
		 * @param beginRow
		 * @param beginCol
		 * @param endRow
		 * @param endCol
		 * @return 
		 * 
		 */		
		private function Diagonal(beginRow:int, beginCol:int, endRow:int, endCol:int):int
		{
			var dx:int = beginCol < endCol ? endCol - beginCol : beginCol - endCol;
			var dy:int = beginRow < endRow ? endRow - beginRow : beginRow - endRow;
			var diag:int, rest:int;
			diag = dx < dy ? (rest = dy - dx, dx) : (rest = dx - dy, dy);
			return diag * ITALIC_G + rest * STRAIGHT_G;
		}
			
		public function setWalkable(col:int, row:int, bWalkable:Boolean):void
		{
			if (col < 0 || col >= colCount || row < 0 || row >= rowCount)
			{
				return
			}
			walkable[row][col] = bWalkable;
		}
		
		public function isWalkable(col:int, row:int):Boolean
		{
			return walkable[row][col];
		}

		/**
		 * 构建后预处理，地图数据全部设置完后调用
		 * 
		 */		
		public function initAfterMapBuilt():void
		{
			for (var i:int = 0; i < rowCount; ++i) 
			{
				for (var j:int = 0; j < colCount; ++j) 
				{
					if (walkable[i][j])
					{
						// 向右
						if (j < colCount - 1 && walkable[i][j + 1])
						{
							direction[i][j] |= 1;
						}
						// 向上
						if (i > 0 && walkable[i - 1][j])
						{
							direction[i][j] |= 2;
						}
						// 向左
						if (j > 0 && walkable[i][j - 1])
						{
							direction[i][j] |= 4;
						}
						// 向下
						if (i < rowCount - 1 && walkable[i + 1][j])
						{
							direction[i][j] |= 8;
						}
					}
				}
			}
		}
		
		/**
		 * 寻路
		 * @param beginRow
		 * @param beginCol
		 * @param endRow
		 * @param endCol
		 * @param w
		 * @param h
		 * @param mt　寻路类型，具体参考AStarDefine
		 * @return 
		 * 
		 */		
		public function findPath(beginCol:int, beginRow:int, endCol:int, endRow:int):AStarPath
		{
			if (beginRow < 0 || beginRow >= rowCount 
				|| beginCol < 0 || beginCol >= colCount
				|| endRow < 0 || endRow >= rowCount
				|| endCol < 0 || endCol >= colCount)
			{
				//throw new Error("错误寻路参数", 0);
				return null;
			}
			// 原地踏步
			if (beginRow == endRow && beginCol == endCol)
			{
				return null;
			}

			// 重置数据
			nodeCount = 0;
			nowBound += IN_CLOSE_LISET;
			// 初始化状态值
			if (nowBound == INIT_BOUND)
			{
				for (var i:int = 0; i < rowCount; ++i)
				{
					for (var j:int = 0; j < colCount; ++j)
					{
						state[i][j] = 0;
					}
				}
				nowBound = 0;
			}
			var nowOpen:int = nowBound + IN_OPEN_LIST;
			var nowClose:int = nowBound + IN_CLOSE_LISET;
			
			state[beginRow][beginCol] = nowClose;
			var closeCount:int = 1;
			var nowRow:int = beginRow;
			var nowCol:int = beginCol;
			var nowGValue:int = 0;
			var lastDir:int = 0;
			
			var pNearest:int = nowRow * colCount + nowCol;
			nodeGValue[pNearest] = 0;
			nodeFValue[pNearest] = Diagonal(beginRow, beginCol, endRow, endCol);
			
			var pNode:int;
			var row:int, col:int;
			// 开始寻路
			_FIND:
			for (;;)
			{
				_DIRECTION:
				// 八个方向
				for (var i:int = 0; i < 8; ++i)
				{
					// 可移动
					var nowDir:int = AStarDefine.s_dir[i];
					
					if ((direction[nowRow][nowCol] & nowDir) == nowDir)
					{
						row = nowRow + AStarDefine.s_rowOffset[nowDir];
						col = nowCol + AStarDefine.s_colOffset[nowDir];
						
						// 判断对角
						if (i > 3 && !walkable[row][col])
						{
							continue;
						}
						
						pNode = row * colCount + col;
						// 到达目标
						if (row == endRow && col == endCol)
						{
							nodeDirection[pNode] = nowDir;
							
							break _FIND;
							
						}
						// 关闭列表
						var nodeState:int = state[row][col];
						if (nodeState != nowClose)
						{
							var gValue:int = STRAIGHT_G + ((i>>2)<<2);
							if (nowDir != lastDir)
							{
								gValue += 1;
							}
							// 未检查点
							if (nodeState <= nowBound)
							{
								var dx:int = col < endCol ? endCol - col : col - endCol;
								var dy:int = row < endRow ? endRow - row : row - endRow;
								var diag:int, rest:int;
								if (dx < dy)
								{
									rest = dy - dx;
									diag = dx;
								}
								else
								{
									rest = dx - dy;
									diag = dy;
								}
								
								nodeGValue[pNode] = nowGValue + gValue;
								nodeFValue[pNode] = nodeGValue[pNode] + diag * ITALIC_G + rest * STRAIGHT_G;;
								nodeDirection[pNode] = nowDir;
								state[row][col] = nowOpen;
								// 插入节点
								Insert(pNode);
							}
							// 开放列表
							else
							{
								// 更短的路径
								if (nowGValue + gValue < nodeGValue[pNode])
								{
									nodeDirection[pNode] = nowDir;
									var hValue:int = nodeFValue[pNode] - nodeGValue[pNode];
									nodeGValue[pNode] = nowGValue + gValue;
									ChangeValue(pNode, nodeGValue[pNode] + hValue);
								}
							}
						}
					}
				}
				
				// 找不到目标
				if (nodeCount == 0 || closeCount == MAX_FIND_NODE)
				{
					row = pNearest / colCount;
					col = pNearest % colCount;
					break _FIND;
				}
				
				pNode = PopFront();
				nowRow = pNode / colCount;
				nowCol = pNode % colCount;
				nowGValue = nodeGValue[pNode];
				lastDir = nodeDirection[pNode];
				state[nowRow][nowCol] = nowClose;
				++closeCount;
				
				if (nodeFValue[pNode] - nodeGValue[pNode] < nodeFValue[pNearest] - nodeGValue[pNearest]
					|| (nodeFValue[pNode] - nodeGValue[pNode] == nodeFValue[pNearest] - nodeGValue[pNearest] && nodeGValue[pNode] < nodeGValue[pNearest]))
				{
					pNearest = pNode;
				}
			}
			
			if (row == beginRow && col == beginCol)
			{
				return null;
			}
			
			var path:AStarPath = new AStarPath;
			
			path.beginRow = beginRow;
			path.beginCol = beginCol;
			path.endRow = row;
			path.endCol = col;
			
			var y:int = row;
			var x:int = col;
			for (; ;)
			{
				var dir:int = nodeDirection[y * colCount + x];
				var rdir:int = ((dir&1)<<2) | ((dir&2)<<2) | ((dir&4)>>2) | ((dir&8)>>2);
				path.dirList.push(dir);
				y += AStarDefine.s_rowOffset[rdir];
				x += AStarDefine.s_colOffset[rdir];
				
				if (y == beginRow && x == beginCol)
				{
					break;
				}
			}
			return path;			
			
		}
	}
}