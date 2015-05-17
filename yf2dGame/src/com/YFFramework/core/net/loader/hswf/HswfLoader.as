package com.YFFramework.core.net.loader.hswf
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.BytesLoader;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.hswf.HswfAnalysse;
	
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**@author yefeng
	 *2012-4-21下午9:16:58
	 */
	public class HswfLoader 
	{
		public var errorCallback:Function;
		/**带有  HswfLoader类型的参数  和一个 传递参数 data:Object
		 */
		public var loadCompleteCallback:Function;
		public var actionData:ActionData;
		public var url:String;
		protected var _data:Object;
		/**  chitu/hswf 动画文件数据源
		 */	
		private var _hswfBytes:ByteArray;
		public function HswfLoader()
		{
		}
		
		public function load(url:String,data:Object=null):void
		{
			this.url=url;
			_data=data;
			var fileLoader:FileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			fileLoader.ioErrorCallback=errorCallback
			fileLoader.loadCompleteCallBack=hswfLoadComplete
			fileLoader.load(url)
		}
		private function hswfLoadComplete(loader:FileLoader):void
		{
			var data:ByteArray=loader.data as ByteArray;   //// hswf/chitu 文件的 字节
			///拷贝一份数据用于so 存储
			_hswfBytes=new ByteArray();
			_hswfBytes.writeBytes(data);
			_hswfBytes.position=0;//重置位置
			
			///进行数据解析
//			var obj:Object=HswfAnalysse.analysse(data);
//			data.clear();
//			data=null;
//			actionData=new ActionData();
//			actionData.headerData=obj.headData;
//			var bytesLoader:BytesLoader=new BytesLoader();
//			bytesLoader.loadCompleteCalback=hswfLoad;
//			var domain:ApplicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
//			bytesLoader.load(obj.swfBytes,domain);
			analyseData(data,_data);
		}
		
		/**解析生成数据
		 */		
		public function analyseData(hswfBytes:ByteArray,data:Object=null):void
		{
			this._data=data;
			var obj:Object=HswfAnalysse.analysse(hswfBytes);
			hswfBytes.clear();
			hswfBytes=null;
			actionData=new ActionData();
			actionData.headerData=obj.headData;
			var bytesLoader:BytesLoader=new BytesLoader();
			bytesLoader.loadCompleteCalback=hswfLoad;
			var domain:ApplicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
			bytesLoader.load(obj.swfBytes,domain);
		}
		
	
		private function hswfLoad(loader:BytesLoader,domain:ApplicationDomain):void
		{
			//进出处理
			HswfAnalysse.extractActionData(actionData,domain);
			loadCompleteCallback(this,_data);
			disposeAllData();
		}
		
		private function disposeAllData():void
		{
			loadCompleteCallback=null;
			actionData=null;
			url=null;
		}
		public function dispose():void
		{
			_hswfBytes=null;
		}
		/**  获取 hswf资源
		 * @return 
		 */		
		public function getHSwfByteArray():ByteArray
		{
			return _hswfBytes;
		}
		
		
	}
}