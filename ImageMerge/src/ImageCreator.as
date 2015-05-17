package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.core.utils.image.Cast;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import spark.components.Group;

	/**2012-11-21 下午7:41:12
	 *@author yefeng
	 */
	public class ImageCreator
	{
		
		public static const Extentsion:String=".resHead";
		
		public function ImageCreator()
		{
		}
		
		public static function create(container:Group,dir:File,fileName:String,dict:Dictionary,width:int,height:int):void
		{
			var imageEx:ImageEx;  ////保存 x   y   w    h  信息 
			var obj:Object;
			
			var totalObj:Object={};
			for  (var name:String in dict)
			{
				imageEx=dict[name];
				obj={x:imageEx.x,y:imageEx.y,w:imageEx.bitmapData.width,h:imageEx.bitmapData.height};
				totalObj[name]=obj
			}
			
			totalObj.width=width;
			totalObj.height=height;
			///生成字节
			var bytes:ByteArray=new ByteArray();
			bytes.writeObject(totalObj);
			
			////对 容器 生成图片
			var bitmapData:BitmapData=new BitmapData(width,height,true,0x0);
			var len:int=container.numElements
			var j:int=0
			for (j=0;j!=len;++j)
			{
				imageEx=container.getElementAt(j) as ImageEx;
				imageEx.frameVisible=false;
			}
			bitmapData.draw(container);
			for (j=0;j!=len;++j)
			{
				imageEx=container.getElementAt(j) as ImageEx;
				imageEx.frameVisible=true;
			}

			
			
			
			
			var coder:PNGEncoder=new PNGEncoder();
			var imageByte:ByteArray=coder.encode(bitmapData);
			
			///生成头 和图像
			///头
			FileUtil.createFileByByteArray(dir,fileName+Extentsion,bytes);
			
			//图像
			FileUtil.createFileByByteArray(dir,fileName+".png",imageByte);
		}
		
	}
}