package com.YFFramework.core.net.loader.res
{
	/**加载 .res文件
	 * @author yefeng
	 *2012-11-21下午9:47:46
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.BytesLoader;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	public class ResFileLoader extends FileLoader
	{
		public function ResFileLoader()
		{
			super(URLLoaderDataFormat.BINARY);
		}
		///加载  
		override protected function onComplete(e:Event):void
		{
			_data=loader.data;
			remove();
			////压缩 atf 数据 
			var bytes:ByteArray=_data as ByteArray;
			bytes.uncompress();
			///进行文件解析
//			mydata.writeInt(headBytes.length);
//			mydata.writeInt(swfBytes.length);
//			mydata.writeBytes(headBytes);
//			mydata.writeBytes(swfBytes);
			var headLen:int=bytes.readInt();
			var swfBytesLen:int=bytes.readInt();
			var headBytes:ByteArray=new ByteArray();
			var swfBytes:ByteArray=new ByteArray();
			bytes.readBytes(headBytes,0,headLen);
			bytes.readBytes(swfBytes,0,swfBytesLen);
			///设置头
			var headObj:Object=headBytes.readObject();
			headBytes.clear();
			headBytes=null;
			///加载swf字节
			 var _domain:ApplicationDomain=new ApplicationDomain();
			var bytesLoader:BytesLoader=new BytesLoader();
			bytesLoader.setData(headObj);
			bytesLoader.loadCompleteCalback=bytesLoadComplete;
			bytesLoader.load(swfBytes,_domain);	
		}
		
		private function bytesLoadComplete(loader:BytesLoader,domain:ApplicationDomain):void
		{
			var headObj:Object=loader.getData();
			///根据 headObj创建相应的 texture
			var bmpClass:Class=domain.getDefinition("common") as Class;
			var resAtlas:BitmapData=new bmpClass() as BitmapData;
			loadCompleteCallBack({head:headObj,bitmapData:resAtlas});
			
			print(this,"resFile加载完成");
		}
		
		override protected function remove():void
		{
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			request.url="";
			request=null;
			loader=null;

		}
		
		
	}
}