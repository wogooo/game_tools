package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.BitmapData;

	public class LineBD
	{
		private static var _bitmapData:BitmapData;
		
		public function LineBD()
		{
		}

		public static function get bitmapData():BitmapData
		{
			if(_bitmapData == null){
				_bitmapData = ClassInstance.getInstance("bagUI_line");
			}
			return _bitmapData;
		}

	}
}