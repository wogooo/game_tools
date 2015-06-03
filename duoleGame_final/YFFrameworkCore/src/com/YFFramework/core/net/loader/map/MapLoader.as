package com.YFFramework.core.net.loader.map
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**加载 .map文件  .map文件  是 压缩过的 atf文件 
	 *  我们只需要获取   里面的字节数据即可
	 * @author yefeng
	 *2012-11-20下午10:11:38
	 */
	public class MapLoader extends FileLoader
	{
		private var __myUrl:String;
		private var __myData:Object;
		
		
		private static var _pool:Vector.<MapLoader>=new Vector.<MapLoader>();
		private static var _size:int=0;
		
		/**
		 *是否已经加载 
		 */
		private var _isDoLoader:Boolean=false;
		public function MapLoader()
		{
			super(URLLoaderDataFormat.BINARY);
		}
		///加载  
		override protected function onComplete(e:Event):void
		{
			_data=loader.data;
			////压缩 atf 数据 
			
			var bytes:ByteArray=_data as ByteArray;
			var hswfBytes:ByteArray=new ByteArray();
			hswfBytes.writeBytes(bytes);
			hswfBytes.position=0;//重置位置
			
			if(loadCompleteCallBack!=null)loadCompleteCallBack(bytes,_tmpData);
//			ShareObjectManager.Instance.put(request.url,hswfBytes);
			remove();
		}
		
		private function comepleLoadIt(obj:Object):void
		{
			var hswfBytes:ByteArray=obj.hswfBytes as ByteArray;
			var bytes:ByteArray=obj.bytes as ByteArray;

			if(loadCompleteCallBack!=null)
			{
				loadCompleteCallBack(bytes,_tmpData);
			}
//			ShareObjectManager.Instance.put(request.url,hswfBytes);
			remove();
		}

		public function initData(url:String,data:Object=null):void
		{
			__myUrl=url;
			__myData=data;
		}
		public function doLoad():void
		{
			load(__myUrl,__myData);
		}
//		private static var _preT:Number=0;
		override public function load(url:String,data:Object=null):void
		{
//			var bytes:ByteArray=ShareObjectManager.Instance.getObjByteArray(url) as ByteArray;
//			if(bytes)
//			{
//				trace("bytesLoaded");
//				if(loadCompleteCallBack!=null)loadCompleteCallBack(bytes,data);
//				remove();
//				 
//			}
//			else  
//			{
//				trace("url load"); 
//				var t:Number=getTimer();
				_tmpData=data;
				request.url=url;
				loader.load(request);
//				trace("url加载消耗：",getTimer()-t);
//			}
		}
		  
		
//		private function comepleLoadIt2(obj:Object):void
//		{
//			var bytes:ByteArray=obj.bytes as ByteArray;
//			var data:Object=obj.data;
//			if(loadCompleteCallBack!=null)loadCompleteCallBack(bytes,data);
//			remove();
//		}
		
		
//		public static function getMapLoader():MapLoader
//		{
//			return null;
//		}
		
		
		
		
	}
}