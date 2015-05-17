package
{
import flash.display.*;
import flash.geom.*;

/**
 * 测试通道分离
 */
public class BmdChannel extends Sprite
{
	[Embed(source="bmdchannel.png")]
	private static const BMP:Class;

	public function BmdChannel()
	{
		_bmd = (new BMP as Bitmap).bitmapData;
		buildbmp1();
		buildbmp2();
		buildbmp3();
		buildbmp4()
		buildbmp5()
		trace(_bmd.getPixel32(25,20));
	}

	private var _bmd:BitmapData;
	private var _channelBmd:BitmapData;
	private var _pixelBmd:BitmapData;

	private var _bmp1:Bitmap;
	private var _bmp2:Bitmap;
	private var _bmp3:Bitmap;
	
	private var _bmp4:Bitmap;

	private var _bmp5:Bitmap;

	private function buildbmp1():void
	{
		_bmp1 = new BMP as Bitmap;
		this.addChild(_bmp1);
	}

	private function buildbmp2():void
	{
		var __p:Point = new Point(0,0);
		_channelBmd = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
		_channelBmd.fillRect(_bmd.rect, 0xff000000);
		_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 1);
		_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 2);
		_channelBmd.copyChannel(_bmd, _bmd.rect, __p, 8, 4);
		_bmp2 = new Bitmap(_channelBmd);
		_bmp2.x = 52;
		this.addChild(_bmp2);
	}

	//三个通道都进行拷贝   到时候还原通道的时候只需要取其中一个就行了
	private function buildbmp3():void
	{
		_pixelBmd = new BitmapData(_bmd.width, _bmd.height, false);
		for(var i:int=0;i<_bmd.height;i++)
		{
			var __str:String = '';
			for(var j:int=0;j<_bmd.width;j++)
			{
				var __pixel:int = _bmd.getPixel32(j,i);
				var __argb:Object = splitARGB(__pixel);
				var __argbstr:String = __argb.a == 0 ? '00' : __argb.a.toString(16);
				__str += __argbstr + ' ';
				//__pixel = mixARGB(__argb.a);
				__pixel = mixRGB(__argb.a);
				//_pixelBmd.setPixel32(j,i, __pixel);
				_pixelBmd.setPixel(j,i, __pixel);
			}
			trace(__str);
		}

		_bmp3 = new Bitmap(_pixelBmd);
		_bmp3.x = 104;
		this.addChild(_bmp3);
	}

	public function splitARGB($argb:uint):Object
	{
		return {	a:$argb >> 24 & 0xFF,
			r:$argb >> 16 & 0xFF,
			g:$argb >> 8 & 0xFF,
			b:$argb & 0xFF	};
	}

	public function mixARGB($color:uint):uint
	{
		return $color << 24 | $color << 16 | $color << 8 | $color;
	}

	public function mixRGB($color:uint):uint
	{
		return $color << 16 | $color << 8 | $color;
	}
	
	
		///手动合成
	private function buildbmp5():void
	{
			var _channelBmd2:BitmapData = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
			_channelBmd2.draw(_bmd)
			
			var _channelBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, true, 0x00000000);
			_channelBmd.draw(_channelBmd2)


//		_pixelBmd = new BitmapData(_bmd.width, _bmd.height, false);
		for(var i:int=0;i<_channelBmd.height;i++)
		{
//			var __str:String = '';
			for(var j:int=0;j<_channelBmd.width;j++)
			{
				var __pixel:int = _bmp2.bitmapData.getPixel(j,i);
//				var realALpha_r:int=__pixel>>16&0xFF
//				var realALpha_g:int=__pixel>>8&0xFF
				var realALpha:int=__pixel&0xFF ///随便通过一个通道获取 arpha值
//				var __argbstr:String = __argb.a == 0 ? '00' : __argb.a.toString(16);
//				__str += __argbstr + ' ';
				var nowPix:uint=_channelBmd.getPixel(j,i)
				
				var real:uint=nowPix|realALpha<<24
				
				_channelBmd.setPixel32(j,i, real);
			}
//			trace(__str);
		}

		_bmp5 = new Bitmap(_channelBmd);
		_bmp5.x =300
		this.addChild(_bmp5);
	}
	
	
	
	
	///拆分后再进行合成
	private function buildbmp4():void
	{
		var __p:Point = new Point(0,0);
		
		var _channelBmd2:BitmapData = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
		_channelBmd2.draw(_bmd)
		var _channelBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, true, 0x00000000);
		_channelBmd.draw(_channelBmd2)
//		_channelBmd.copyChannel(_bmp2.bitmapData, _bmp2.bitmapData.rect, __p, 1, 8);
//		_channelBmd.copyChannel(_bmp2.bitmapData,_bmp2.bitmapData.rect, __p, 2, 8);
		_channelBmd.copyChannel(_bmp2.bitmapData, _bmp2.bitmapData.rect, __p, 4, 8);  //随便复制一个通道就可以了
		_bmp4 = new Bitmap(_channelBmd);
		_bmp4.x = 250;
		this.addChild(_bmp4);
	}

	
	///手动合成
	private function buildbmp5():void
	{
			var _channelBmd2:BitmapData = new BitmapData(_bmd.width, _bmd.height, false, 0x00000000);
			_channelBmd2.draw(_bmd)
			
			var _channelBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, true, 0x00000000);
			_channelBmd.draw(_channelBmd2)


//		_pixelBmd = new BitmapData(_bmd.width, _bmd.height, false);
		for(var i:int=0;i<_channelBmd.height;i++)
		{
//			var __str:String = '';
			for(var j:int=0;j<_channelBmd.width;j++)
			{
				var __pixel:int = _bmp2.bitmapData.getPixel(j,i);
//				var realALpha_r:int=__pixel>>16&0xFF
//				var realALpha_g:int=__pixel>>8&0xFF
				var realALpha:int=__pixel&0xFF ///随便通过一个通道获取 arpha值
//				var __argbstr:String = __argb.a == 0 ? '00' : __argb.a.toString(16);
//				__str += __argbstr + ' ';
				var nowPix:uint=_channelBmd.getPixel(j,i)
				
				var real:uint=nowPix|realALpha<<24
				
				_channelBmd.setPixel32(j,i, real);
			}
//			trace(__str);
		}

		_bmp5 = new Bitmap(_channelBmd);
		_bmp5.x =300
		this.addChild(_bmp5);
	}

	
	
	
	
	
	
	
	
	
	

	
	
}
}
