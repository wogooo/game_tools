package com.YFFramework.core.net.loader.mapFile
{
	import flash.utils.ByteArray;

	/** 处理   .xx文件的打开 
	 * 
	 *  2012-7-12
	 *	@author yefeng
	 */
	public class XXFileManager
	{
		public function XXFileManager()
		{
		}
		
		/**  查看 FileManager类
		 * 	obj.tileW=RectMapConfig.tileW;
			obj.tileH=RectMapConfig.tileH;
			obj.gridW=RectMapConfig.gridW;
			obj.gridH=RectMapConfig.gridH;
			obj.columns=RectMapConfig.columns;
			obj.rows=RectMapConfig.rows;

		 *  obj.floor ：Array;
		 * 	obj.building={};
		 * 		obj.building[name]=[{x,y},{x,y}];		  ///name为 建筑文件名
		 * obj.npc={};
		 * 	obj.npc[name]=[{x,y},{x,y}]; name为npc文件名
		 * 
		 * 
		 */		
		public static  function analyse(bytes:ByteArray):Object
		{
			bytes.uncompress();
			bytes.position=0;
			var obj:Object=bytes.readObject() as Object;
			///将地图场景信息变成数据 
			var arr:Array= String(obj.floor).split("");
			obj.floor=null;
			obj.floor=arr;
			return obj;
		}
		
	}
}