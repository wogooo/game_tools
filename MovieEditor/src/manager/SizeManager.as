package manager
{
	import com.YFFramework.core.utils.image.advanced.encoder.JPGEncoder;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**算出 actionData具体多大
	 */	
	public class SizeManager
	{
		public function SizeManager()
		{
		}
		
		/**获取大小  返回的是KB 
		 */
		public static function getPngSize(actionData:ActionData):int
		{
			var size:int=0;
			var coder:PNGEncoder=new PNGEncoder();
			var childBytes:ByteArray;
			var bytes:ByteArray=new ByteArray();
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					for each (var bitmapDataExData:BitmapDataEx in actionData.dataDict[action][direction])
					{
						childBytes=coder.encode(bitmapDataExData.bitmapData);
						childBytes.position=0;
						bytes.writeBytes(childBytes);
					}
				}
			}
			
			bytes.compress();
			size=bytes.length/1024;
			return size;
		}
		
		
		
		public static function getJpgSize(actionData:ActionData):int
		{
			var size:int=0;
			var coder:JPGEncoder=new JPGEncoder(60);
			var alphaCode:JPGEncoder=new JPGEncoder(50);
			var childRbgBytes:ByteArray;
			var childRaBytes:ByteArray;
			var rbg:BitmapData;
			var ra:BitmapData;
			var bytes:ByteArray=new ByteArray();
			var pt:Point=new Point();
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					for each (var bitmapDataExData:BitmapDataEx in actionData.dataDict[action][direction])
					{
						rbg=new BitmapData(bitmapDataExData.bitmapData.width,bitmapDataExData.bitmapData.height,false,0xFF)
						ra=new BitmapData(bitmapDataExData.bitmapData.width,bitmapDataExData.bitmapData.height,false,0xFF)

						rbg.copyPixels(bitmapDataExData.bitmapData,bitmapDataExData.bitmapData.rect,pt)	
						ra.copyChannel(bitmapDataExData.bitmapData,bitmapDataExData.bitmapData.rect,pt,BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
						childRbgBytes=coder.encode(rbg);
						childRaBytes=alphaCode.encode(ra);
						childRbgBytes.position=0;
						childRaBytes.position=0;
						bytes.writeBytes(childRbgBytes);
						bytes.writeBytes(childRaBytes);
					}
				}
			}
			
			bytes.compress();
			size=bytes.length/1024+5;
			return size;
		}

		
		
		
		
		
		
		
		
		
		
	}
}