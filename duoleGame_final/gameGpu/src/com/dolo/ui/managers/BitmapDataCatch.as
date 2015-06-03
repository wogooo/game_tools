package com.dolo.ui.managers
{
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.ObjectFactory;
	
	import flash.display.BitmapData;

	public class BitmapDataCatch
	{
		private static var all:Object = {};
		
		public static function getBD(linkName:String):BitmapData
		{
			var bd:BitmapData;
			bd = all[linkName];
			if(bd == null){
				bd = LibraryCreat.getObject(linkName) as BitmapData;
				all[linkName] = bd;
			}
			return bd;
		}
		
	}
}