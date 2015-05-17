package com.YFFramework.core.net.loader.mapFile
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	
	/**   具体信息在  XXFileManager
	 *  2012-7-12
	 *	@author yefeng
	 */
	public class XXFileLoader
	{
		public var loadCompleteCallback:Function;
		/**回调函数传递的参数
		 */
		public var _data:Object;
		public function XXFileLoader()
		{
		}
		
		public function initData(url:String,data:Object=null):void
		{
			_data=data;
			var loader:FileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			loader.loadCompleteCallBack=callBack;
			loader.load(url);
			
		}
		private function callBack(loader:FileLoader):void
		{
			var data:ByteArray=loader.data;
			var obj:Object=XXFileManager.analyse(data);
			loadCompleteCallback(obj,_data);
		}
	}
}