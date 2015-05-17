package manager
{
	import flash.display.BitmapData;
	
	//检测2 张图片是否一样   自动剔除 相同图片
	public class ImageCheckUtil
	{
		public function ImageCheckUtil()
		{
		}
		
		//检测2 张图片是否一样
		public static function checkSame(bitmapData1:BitmapData,bitmapData2:BitmapData):Boolean
		{
			var w1:int = bitmapData1.width;
			var h1:int = bitmapData1.height;
			var w2:int = bitmapData2.width;
			var h2:int = bitmapData2.height;
			var pixel_1:uint;
			var pixel_2:uint;
			if (w1==w2&&h1==h2)
			{
				for(var i:int = 0;i!=w1;++i)
				{
					for(var j:int = 0; j!=h1;++j)
					{
						pixel_1 = bitmapData1.getPixel32(i,j);
						pixel_2 = bitmapData2.getPixel32(i,j);
						if (pixel_1!=pixel_2)
						{
							return false;
						}
					}
				}
			}
			else 
			{
				return false;
			}
				
			return true;
		}
	}
}