package com.YFFramework.core.world.movie.player.optimize
{
	import flash.utils.Dictionary;

	/** 所有的坐标都必须是flash坐标
	 * 2012-11-2 上午9:33:02
	 *@author yefeng
	 */
	public class SceneZoneManager
	{
		private static var _instance:SceneZoneManager;
		/**屏幕区域大小 [-100,1700] [-100,1100]
		 */		
		private static const Width:int=2000;
		private static const Height:int=1800
			
		/**  切割区域的宽度
		 */			
		private static const ZoneWidth:int=300;
		/**切割区域的高度
		 */		
		private static const ZoneHeight:int=300;
		
//		gridCoumns = Math.ceil(Width / ZoneWidth);
//		gridRows = Math.ceil(Height / ZoneHeight);

		/**
		 * 划分的行数
		 */
		private static const  gridRows:int=Math.ceil(Width / ZoneWidth);
		/**
		 * 划分的 列数 
		 */
		private static const gridCoumns:int=Math.ceil(Height / ZoneHeight);

		
		private var _dict:Array;
		/**
		 */		
		private var _nodeDict:Dictionary;
		
		public function SceneZoneManager()
		{
			_dict=[];
			_nodeDict=new Dictionary();
			initSceneZone();
		}
		/**数据清空
		 */		
		public function clear():void
		{
			for each(var zone:ScenceZone in _dict)
			{
				zone.clear();
			}
			_nodeDict=new Dictionary();
		}
		
		public static function get Instance():SceneZoneManager
		{
			if(_instance==null) _instance=new SceneZoneManager();
			return _instance;
		}
		/** 初始化屏幕区域
		 */		
		private function initSceneZone():void
		{
//			gridCoumns = Math.ceil(Width / ZoneWidth);
//			gridRows = Math.ceil(Height / ZoneHeight);
			var key:int;
			var zone:ScenceZone
			for(var i:int=0;i<=gridRows;++i)
			{
				for (var j:int=0;j<=gridCoumns;++j)
				{
					key=getSingleKey(i,j);
					zone=new ScenceZone();
					_dict[key]=zone;
				}
			}
		}
		
		/**  获取 该范围内的玩家          所有 的坐标都是flash坐标
		 * @param startX    矩形 左上角的点
		 * @param startY
		 * @param endX   矩形 右下角的点
		 * @param endY  
		 * @return     返回的是该范围内的playerView 对象 
		 */		 
		public function getZoneArr(startX:int,startY:int,endX:int,endY:int):Array
		{
			var startColumn:int = int (startX / ZoneWidth);
			var startRow:int = int(startY / ZoneHeight);
			var endColumn:int=int(endX/ZoneWidth);
			var endRow:int=int(endY/ZoneHeight);
			if(startColumn<0)startColumn=0;
			if(startRow<0)startRow=0;
			if(endColumn>gridCoumns)endColumn=gridCoumns;
			if(endRow>gridRows)endRow=gridRows;
			var zone:ScenceZone;
			var key:int;
			var arr:Array=[];
			for(var i:int=startRow;i<=endRow;++i)
			{
				for(var j:int=startColumn;j<=endColumn;++j)
				{
					key=getSingleKey(i,j);
					zone=_dict[key];
					if(zone)arr=arr.concat(zone.getArr());			
				}
			}
			return arr;
		}
		
		/**  获取该区域的玩家
		 * @param px
		 * @param py
		 */		
		public function getZoneArr2(px:int,py:int):Array
		{
			var coloumn:int=int(px/ZoneWidth);
			var row:int=int(py/ZoneHeight);
			var key:int=getSingleKey(row,coloumn);
			var zone:ScenceZone=_dict[key];
			if(zone) return zone.getArr();
			return [];
		}
		
//		public function getZoneDict(px:int,py:int):Dictionary
//		{
//			var row:int=int(px/ZoneWidth);
//			var coloumn:int=int(py/ZoneHeight);
//			var key:String=getSingleKey(row,coloumn);
//			var zone:ScenceZone=_dict[key];
//			if(zone) return zone.getDict();
//			return new Dictionary();
//		}
		/**返回的是  [diict,...]
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 * @return 
		 * 
		 */		
		public function getZoneDict2(startX:int,startY:int,endX:int,endY:int):Array
		{
			var startColumn:int = int (startX / ZoneWidth);
			var startRow:int = int(startY / ZoneHeight);
			var endColumn:int=int(endX/ZoneWidth);
			var endRow:int=int(endY/ZoneHeight);
			if(startColumn<0)startColumn=0;
			if(startRow<0)startRow=0;
			if(endColumn>gridCoumns)endColumn=gridCoumns;
			if(endRow>gridRows)endRow=gridRows;
			var zone:ScenceZone;
			var key:int;
			var arr:Array=[];
			for(var i:int=startRow;i<=endRow;++i)
			{
				for(var j:int=startColumn;j<=endColumn;++j)
				{
					key=getSingleKey(i,j);
					zone=_dict[key];
					if(zone)arr.push(zone.getDict());
				}
			}
			return arr;
		}
		
		
		/**得到唯一key 
		 */		
		private function getSingleKey(row:int,column:int):int
		{
		//	return row+"_"+column;
			return row*gridCoumns+column;
		}
		private function getSingleKey2(playerView:ZonePlayer):int
		{
			var column:int=int(playerView.x/ZoneWidth);
			var row:int=int(playerView.y/ZoneHeight);
			if(column<0)column=0;
			if(row<0)row=0;
			if(column>gridCoumns)column=gridCoumns;
			if(row>gridRows)row=gridRows;
//			return row+"_"+column;
			return getSingleKey(row,column);
		}
		
		/**注册玩家
		 */
		public function regPlayer(playerView:ZonePlayer):void
		{
			var zone:ScenceZone=getSceneZone(playerView);
		//	zone.addPlayer(playerView);
			addPlayer(zone,playerView);
		}
		
		public function delPlayer(playerView:ZonePlayer):void
		{
			var zone:ScenceZone=getSceneZone(playerView);
		//	zone.delPlayer(playerView);
			removePlayer(zone,playerView);
		}
		
		
		private function addPlayer(zone:ScenceZone,playerView:ZonePlayer):void
		{
			var zoneNode:PlayerNode=_nodeDict[playerView.getID()];
			if(zoneNode==null)
			{
				zoneNode=new PlayerNode(playerView);
				_nodeDict[playerView.getID()]=zoneNode;
			}
			zone.addNode(zoneNode);
		}
		private function removePlayer(zone:ScenceZone,playerView:ZonePlayer):void
		{
			var zoneNode:PlayerNode=_nodeDict[playerView.getID()];
			if(zoneNode)
			{
				_nodeDict[playerView.getID()]=zoneNode;
				zone.delNode(zoneNode);
			}
		}
		
		/**更新玩家所在的格子区域
		 */		
		public function updatePlayerZone(playerView:ZonePlayer):void
		{
			var zone:ScenceZone=getSceneZone(playerView);
			if(zone)addPlayer(zone,playerView);
		}
		
		
		
		public function getSceneZone(playerView:ZonePlayer):ScenceZone
		{
			var key:int=getSingleKey2(playerView);
			return _dict[key];
		}
		
		private function getSceneZone2(row:int,column:int):ScenceZone
		{
			var key:int=getSingleKey(row,column);
			return _dict[key];
		}
		
		/**  处理深度排序
		 */		
//		public function handleDeepth():void
//		{
//			var arr:Array=[];
//			var index:int=0;
//			var zone:ScenceZone;
//			for(var j:int=0;j!=gridRows;++j) ///先对每一行进行深度排序 再 对列进行深度排序
//			{
//
//			for(var i:int=0;i!=gridCoumns;++i) 
//			{
//					zone=getSceneZone2(j,i);
//					zone.handleDeepth(index);
//					index +=zone.getArr().length;
//				}
//			}
//		}
//		
//		
//		private function sortFunc(x:ZonePlayer,y:ZonePlayer):int
//		{
//			if(x.mouseY>y.mouseY) return -1;
//			else if(x.mouseY==y.mouseY) return 0;
//			return 1;
//		}

		
	}
}