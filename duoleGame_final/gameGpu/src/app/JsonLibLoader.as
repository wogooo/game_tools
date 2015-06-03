package app
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	/**@author yefeng
	 * 2013 2013-8-31 上午11:47:54 
	 */
	public class JsonLibLoader
	{
		public var allResLodedCallback:Function;
		private var progressFunc:Function;
		public function JsonLibLoader(progressCall:Function)
		{
			this.progressFunc=progressCall;
		}
		public function load(url:String):void
		{
			var fileLoader:FileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			fileLoader.loadCompleteCallBack=completeCall;
			fileLoader.progressCallBack=progressFunc;
			fileLoader.load(url,{tips:"配置文件"});
		}
		private function completeCall(loader:FileLoader):void
		{
			var bytes:ByteArray=loader.data as ByteArray;
			DataParse.parseInt(bytes);
			if(allResLodedCallback!=null)allResLodedCallback();
		}
	}
}