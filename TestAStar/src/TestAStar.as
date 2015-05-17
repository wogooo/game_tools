package
{
	import Algorithm.AStar.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	public class TestAStar extends Sprite
	{
		private var _pathFinder:QuickAStar;	
		private var _blockSize:Number = 4;
		
		private var _role:Sprite = new Sprite();
		private var _row:int = -1;
		private var _col:int;
		
		private var _rowCount:int = 115;
		private var _colCount:int = 115;
		private var _path:AStarPath;
		
		private var _line:Shape = new Shape();
		
		public function TestAStar()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.color = 0;
			stage.align = StageAlign.TOP_LEFT;
			
			_role.graphics.beginFill(0x0000ff);
			_role.graphics.drawRect(0, 0, _blockSize, _blockSize);
			_role.graphics.endFill();
			addChild(_role);
			addChild(_line);
			_role.x = 0;
			_role.y = 0;
			
			
//			_row = 0;
//			_col = 0;
//			var wArray:Array = [1];
//			var hArray:Array = [1];
//			_pathFinder = new QuickAStar(_rowCount, _colCount, wArray, hArray);
//			
//			graphics.beginFill(0);
//			var x:int = 0;
//			var y:int = 0;
//			for (var i:int = 0; i < _rowCount; ++i, y += _blockSize)
//			{
//				x = 0;
//				for (var j:int = 0; j < _colCount; ++j, x += _blockSize)
//				{
//					if (Math.random() < 0.1 && i != 0 && j != 0)
//					{
//						_pathFinder.setWalkable(i, j, false);
//						
//						graphics.drawRect(x, y, _blockSize, _blockSize);
//					}
//					else
//					{
//						_pathFinder.setWalkable(i, j, true);
//					}
//				}
//			}
//			graphics.endFill();
//			
//			_pathFinder.initAfterMapBuilt();
//			
//			stage.addEventListener(MouseEvent.CLICK, clickHandler);
//			
//			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			var uldr:URLLoader = new URLLoader();
			var uq:URLRequest = new URLRequest("dolo_map_1001.mdt");
			uldr.dataFormat = URLLoaderDataFormat.BINARY;
			uldr.load(uq);
			uldr.addEventListener(Event.COMPLETE, onComplete);
		}
		
		public function onComplete(evt:Event):void
		{
			var bd:ByteArray = evt.target.data as ByteArray;    
			bd.endian = Endian.LITTLE_ENDIAN;
			
			
			var mf:int = bd.readInt();
			// 并非地图文件
			if (mf != 0x54C)
			{
				bd.position = 0;
				bd.endian = Endian.BIG_ENDIAN;
			}
			else
			{
				// 版本号
				bd.readInt();
			}
			
			// gridW
			bd.readInt();
			// gridH
			bd.readInt();
			_rowCount = bd.readInt();
			_colCount = bd.readInt();
			var left:int = bd.readInt();
			var top:int = bd.readInt();
			var count:int = _rowCount * _colCount;
			
			var t:uint = getTimer();
			_pathFinder = new QuickAStar(_colCount, _rowCount);
			var x:int = 0;
			var y:int = 0;
			for (var i:int = 0; i < _rowCount; ++i, y += _blockSize)
			{
				x = 0;
				for (var j:int = 0; j < _colCount; ++j, x += _blockSize)
				{
					var v:int = bd.readByte();
					if (v % 2 == 0)
					{
						_pathFinder.setWalkable(j, i, true);
						
						if (_row == -1)
						{
							_role.x = x;
							_role.y = y;
							_row = i;
							_col = j;
						}
					}
					else
					{
						_pathFinder.setWalkable(j, i, false);
						
						if (v == 1)
						{
							graphics.beginFill(0xff0000);
						}
						else
						{
							graphics.beginFill(0x00ff00);
						}
						graphics.drawRect(x, y, _blockSize, _blockSize);
					}
				}
			}
			graphics.endFill();
			
			_pathFinder.initAfterMapBuilt();
			
			trace(getTimer() - t);
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
//			var d:Number = Math.sqrt(10);
//			var m:Matrix = new Matrix;
//			m.rotate(Math.PI / 4);
//			m.scale(4 / d, 2 / d);
//			
//			var m2:Matrix = new Matrix();
//			m2.scale(8*Math.sqrt(5), 8*Math.sqrt(5));
//			m2.concat(m);
//			
//			this.transform.matrix = m2;
			//this.scaleX = 2;
			//this.scaleY = 2;
			//this.x = -2000;
			//this.y = -2000;
			//this.filters = [new BlurFilter(4, 4)];
		}
		
		public function clickHandler(evt:MouseEvent):void
		{
			var row:int = (int)(evt.localY) / _blockSize;
			var col:int = (int)(evt.localX) / _blockSize;
			if (row < _rowCount && col < _colCount)
			{
				var last:uint = getTimer();
				_path = _pathFinder.findPath(_col, _row, col, row);
				if (_path != null)
				{
					trace(getTimer() - last, _path.dirList.length);
				}
				else
				{
					trace(getTimer() - last,  0);
				}
			}
		}
		
		public function enterFrameHandler(event:Event):void
		{
			if (_path != null)
			{
				var dir:int = _path.dirList.pop();
				_row += AStarDefine.s_rowOffset[dir];
				_col += AStarDefine.s_colOffset[dir];
				_role.x = _col * _blockSize;
				_role.y = _row * _blockSize;
				
				if (_row == _path.endRow && _col == _path.endCol)
				{
					_path = null;
				}
				
				_line.graphics.clear();
				
				if (_path != null)
				{
					var len:int = _path.dirList.length;
					
					var row:int = _row;
					var col:int = _col;
					
					_line.graphics.lineStyle(_blockSize, 0xff0000);
					_line.graphics.moveTo(col * _blockSize + _blockSize / 2, row * _blockSize + _blockSize / 2);
					for (var i:int = 0; i < len; ++i)
					{
						var dir:int = _path.dirList[len - i - 1];
						row += AStarDefine.s_rowOffset[dir];
						col += AStarDefine.s_colOffset[dir];
						_line.graphics.lineTo(col * _blockSize + _blockSize / 2, row * _blockSize + _blockSize / 2);
					}
				}
			}
		}
	}
}