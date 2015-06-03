package com.YFFramework.core.net.loader.yf2d
{
	import com.YFFramework.core.center.manager.update.QueenTimeOut;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.BytesLoader;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
//	import com.YFFramework.core.ui.yf2d.manager.YF2dAnalysse;
	
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**@author yefeng
	 *2012-11-17下午10:51:04
	 */
	public class YF2dLoader
	{
		public function YF2dLoader()
		{
		}
		/**带有  HswfLoader类型的参数  和一个 传递参数 data:Object
		 */
		public var loadCompleteCallback:Function;
		/**错误加载
		 */
		public var errorCallback:Function;

		public var actionData:ATFActionData;
		public var url:String;
		protected var _data:Object;
		/**  chitu/hswf 动画文件数据源
		 */	
		private var _hswfBytes:ByteArray;
		
		private static var _preLoadedTime:Number=0;
		
		public function load(url:String,data:Object=null):void
		{
			this.url=url;
			_data=data;
			var fileLoader:FileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			fileLoader.loadCompleteCallBack=yf2dLoadComplete
			fileLoader.ioErrorCallback=errorCallback;
			fileLoader.load(url)
		}
		private function yf2dLoadComplete(loader:FileLoader):void
		{
			var data:ByteArray=loader.data as ByteArray;   //// hswf/chitu 文件的 字节
			///拷贝一份数据用于so 存储
			_hswfBytes=new ByteArray();
			_hswfBytes.writeBytes(data);
			_hswfBytes.position=0;//重置位置
			analyseData(data,_data);
		}
		
		/**解析生成数据
		 */		
		public function analyseData(hswfBytes:ByteArray,data:Object=null):void
		{
//			this._data=data;
//			var obj:Object=YF2dAnalysse.analysse(hswfBytes);
//			hswfBytes.clear();
//			hswfBytes=null;
//			actionData=new ATFActionData();
//			actionData.headerData=obj.headData;
//			var bytesLoader:BytesLoader=new BytesLoader();
//			bytesLoader.loadCompleteCalback=hswfLoad;
//			var domain:ApplicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
//			bytesLoader.load(obj.swfBytes,domain);
		}
		
		
		private function hswfLoad(loader:BytesLoader,domain:ApplicationDomain):void
		{
			//进出处理
//			YF2dAnalysse.extractActionData(actionData,domain);
//			var t:QueenTimeOut=new QueenTimeOut(300+Math.random()*1200,complete);
//			t.start(); 
//			 
//			loadCompleteCallback(this,_data);
//			disposeAllData();
		}
		
		private function complete(data:Object):void
		{
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