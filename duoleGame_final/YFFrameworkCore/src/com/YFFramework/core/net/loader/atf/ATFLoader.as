package com.YFFramework.core.net.loader.atf
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.manager.ATFMovieAnalysse;
	
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	/**@author yefeng
	 *2012-11-17下午10:51:04
	 */
	public class ATFLoader
	{
		/**带有  HswfLoader类型的参数  和一个 传递参数 data:Object
		 */
		public var loadCompleteCallback:Function;
		/**错误加载
		 */
		public var errorCallback:Function;

		public var url:String; 
		protected var _data:Object;

		public function ATFLoader()
		{
		}
		
		
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
			ATFMovieAnalysse.handleATFBytes(data,complete);
		}
		
		private function complete(actionData:ATFActionData):void
		{
			loadCompleteCallback(actionData,_data);
			disposeAllData();
		}
		
		private function disposeAllData():void
		{
			url=null;
			_data=null;
			loadCompleteCallback=null;
		}
		
		
		
		
	}
}