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
		/**带有  HswfLoader类型的参数  和一个 传递参数 data:Object
		 */
		public var loadCompleteCallback:Function;
		public var actionData:ActionData;
		public var url:String;
		protected var _data:Object;
		public function HswfLoader()
		{
		}
		
		public function load(url:String,data:Object=null):void
		{
			this.url=url;
			_data=data;
			var fileLoader:FileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			fileLoader.loadCompleteCallBack=hswfLoadComplete
			fileLoader.load(url)
		}
		private function hswfLoadComplete(loader:FileLoader):void
		{
			var data:ByteArray=loader.data as ByteArray;
			var obj:Object=HswfAnalysse.analysse(data);
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
			dispose();
		}
		
		private function dispose():void
		{
			loadCompleteCallback=null;
			actionData=null;
			url=null;
		}
	}
}