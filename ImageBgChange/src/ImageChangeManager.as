package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.Color;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	/** 将黑色背景 /白色背景的 图片改成透明的    算法用到了 alpha   去 预乘alpha      即： alpha =  1-  alpha预乘 
	 * 
	 * @author 
	 * 
	 */
	public class ImageChangeManager
	{
		private static const Dif:int = 0; //容积差
		public function ImageChangeManager()
		{
		}

		
		
		/**返回转会后的图片
		 */
		public static function changeImage(sourceBitmapData:BitmapData,fileDir:File,name:String):void
		{
			var retBitmapData:BitmapData = new BitmapData(sourceBitmapData.width,sourceBitmapData.height,true,0xFFFFFF);
			
			for(var i:int = 0;i!=sourceBitmapData.width;++i)
			{
				for(var j:int = 0;j!=sourceBitmapData.height;++j)
				{
					var color32:uint  = sourceBitmapData.getPixel32(i,j);
					var r:int = Color.getRed(color32);
					var g:int  = Color.getGreen(color32);
					var b:int  = Color.getBlue(color32);
					
					var currentAlpha :int= 255* (1-r*g*b/(255*255*255));  //去除预乘 aplha
					
					var alphaClor :uint = 0x00FFFFFF;
					if (255-r<=Dif&&255-g<=Dif&&255-b<=Dif)
					{
						
						retBitmapData.setPixel32(i,j,alphaClor);
						
					}
					else 
					{
						var myColor:uint = Color.argb(currentAlpha,r,g,b);
						retBitmapData.setPixel32(i,j,myColor);
					}
				}
				
			}
			
			
			var coder:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = coder.encode(retBitmapData)
			FileUtil.createFileByByteArray(fileDir,name,bytes);

			
		}
		
		
		
		
		
	}
}