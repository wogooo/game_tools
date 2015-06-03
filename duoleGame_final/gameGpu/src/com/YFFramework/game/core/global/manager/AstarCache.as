package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/** A星寻路cache 
	 * @author yefeng
	 * 2013 2013-10-28 上午10:35:43 
	 */
	public class AstarCache
	{
		private var _instance:AstarCache;
		/** 存储路径
		 */
		private var _dict:Dictionary;
		public static var isOn:Boolean=true;
		private static var _instance:AstarCache;
		public function AstarCache()
		{
			_dict=new Dictionary();
			save();
		}
		public static function get Instance():AstarCache
		{
			if(_instance==null)
			{
				_instance=new AstarCache();
			}
			return _instance;
		}
		public function get Instance():AstarCache
		{
			if(_instance==null)_instance=new AstarCache();
			return _instance;	
		}
		
		public function put(mapId:int,starTile:Point,endTilePoint:Point,arr:Array):void
		{
			if(isOn)
			{
				if(!_dict[mapId])
				{
					_dict[mapId]=new Dictionary();
				}
				var key:String=getKey(starTile,endTilePoint);
				_dict[mapId][key]=arr.concat();
			}
		}
		private function getKey(starTile:Point,endTilePoint:Point):String
		{
			return starTile.x+"_"+starTile.y+"_"+endTilePoint.x+"_"+endTilePoint.y;
		}
		
		public function getAstarRoad(mapId:int,starTile:Point,endTilePoint:Point):Array
		{
			var key:String=getKey(starTile,endTilePoint);
			if(_dict[mapId])
			{
				return _dict[mapId][key];
			}
			return null;
		}
		
		
		public function cache(obj:Object):void
		{
		//	_dict=obj;
			for (var mapId:String in obj)
			{
				if(!_dict[mapId])_dict[mapId]=new Dictionary();
				for(var key:String in obj[mapId])
				{
					_dict[mapId][key]=covertObjArrayToPointArray(obj[mapId][key]);
				}
			}
		}
		
		private function covertObjArrayToPointArray(objArr:Array):Array
		{
			var path:Array=[];
			var len:int=objArr.length;
			for(var i:int=0;i!=len;++i)
			{
				path.push(new Point(objArr[i].x,objArr[i].y));
			}
			return path;
		}
		
		private function save():void
		{
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDow);
		}
		private function onKeyDow(e:KeyboardEvent):void
		{
			if(e.keyCode==Keyboard.F8)
			{
				var file:FileReference=new FileReference();
				
				var obj:Object={};
				
				for (var mapId:String in _dict)
				{
					if(!obj[mapId])obj[mapId]={};
					for(var key:String in _dict[mapId])
					{
						obj[mapId][key]=_dict[mapId][key]
					}
				}
				
				var str:String=JSON.stringify(obj);
				file.save(str,getTimer()+"astarCache.json");

			}
		}
		
		
		
	}
}