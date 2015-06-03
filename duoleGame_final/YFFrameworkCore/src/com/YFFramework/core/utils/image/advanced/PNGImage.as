/*

对png图像进行处理



*/


package com.YFFramework.core.utils.image.advanced
{


	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	public class PNGImage
	{

		public function PNGImage()
		{
			// constructor code
		}


	/*
	用法
	import utils.images.*
var data:BitmapData=new Image(800,600);
var bmp:Bitmap= PNGImage.clipBitmap(data);

addChild(bmp)
	
	*/
		public static function clipBitmap(data:BitmapData):Bitmap
		{

			var _mask:uint = 0xFF000000;
			var color:uint = 0x00000000;
			var rec:Rectangle = data.getColorBoundsRect(_mask,color,false);

			var bmpData:BitmapData = new BitmapData(rec.width,rec.height,true,0xff);
			var mat:Matrix=new Matrix();
			mat.tx =  -  rec.x;
			mat.ty =  -  rec.y;
			bmpData.draw(data,mat);
			var bmp:Bitmap = new Bitmap(bmpData);

			return bmp;

		}





		// end class

	}

}