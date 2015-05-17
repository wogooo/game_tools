package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.utils.UtilString;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.PNGEncoder;

	/**加载  图片 并且将其转化 指定大小
	 * @author yefeng
	 *2012-8-18下午6:41:21
	 */
	public class ImageCreator
	{
		
		private var _width:int;
		private var _height:int;
		/** 图片转化后的宽高
		 * @param width
		 * @param height
		 */		
		public function ImageCreator(width:int=32,height:int=32)
		{
			_width=width;
			_height=height;
		}
		
		
		public function  create(urlArr:Vector.<String>):void
		{
			var uisLoader:UISLoader=new UISLoader();
			var arr:Vector.<Object>=new Vector.<Object>();
			for each (var url:String in urlArr)
			{
				arr.push({url:url,fileUrl:url})	
			}
			uisLoader.loadCompleteCallBack=callback;
			uisLoader.load(arr);
		}
	
		private function  callback(arr:Vector.<Object>):void
		{
			
			var bytes:ByteArray;
			var name:String;
			var fileDir:File=File.desktopDirectory;
			fileDir.url=arr[0].fileUrl;
			fileDir=fileDir.parent;
			var file:File=File.desktopDirectory;
			var bmp:Bitmap;
			var bitmapData:BitmapData;
			var mat:Matrix;
			var encoder:PNGEncoder=new PNGEncoder();
			var suffix:String;
			var realname:String;
			for each (var obj:Object in arr)
			{
				suffix=null;
				realname=null;
				bmp=obj.display as Bitmap;
		//		bmp.smoothing=true;
				mat=new Matrix();
				mat.scale(_width/bmp.width,_height/bmp.height);
				bitmapData=new BitmapData(_width,_height,true,0x000000);

				bitmapData.draw(bmp,mat);
				bytes=encoder.encode(bitmapData);
				file.url=obj.fileUrl;
				name=file.name;
				
//				suffix=UtilString.getSuffix(name);
//				if(suffix=="PNG")
//				{
//					suffix="png"
//				}
//				realname=UtilString.getExactName(name);
//				
//				name=realname+"."+suffix;
				
				FileUtil.createFileByByteArray(fileDir,name,bytes);
				bitmapData.dispose();
			}
			Alert.show("图片处理完成!");
		}
	}
}