package manager
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BitmapDataManager
	{
		public function BitmapDataManager()
		{
		}
		
		
		public static function getAlphaMask(_bmd:BitmapData):BitmapData
		{
			var __p:Point = new Point(0,0);
			var _channelBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
			_channelBmd.fillRect(_bmd.rect, 0xff000000);
			_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 1);
			_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 2);
			_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 4);
			return _channelBmd
		}
		public static function getRBG(_bmd:BitmapData):BitmapData
		{
			var __p:Point = new Point(0,0);
			var _channelBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
			_channelBmd.draw(_bmd)
			return _channelBmd
		}
	}
}