package movieData.movie.net
{
	
	
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import movieData.movie.data.ActionData;
	import movieData.movie.hswf.HswfAnalysse;

	/**@author yefeng
	 *2012-4-21下午9:16:58
	 */
	public class HswfLoader 
	{
		/**带有  HswfLoader类型的参数 
		 */
		public var loadCompleteCallback:Function;
		public var actionData:ActionData;
		public var url:String;
		public function HswfLoader()
		{
		}
		
		public function load(url:String):void
		{
			this.url=url;
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
			loadCompleteCallback(this);
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