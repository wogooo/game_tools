package movieData.movie.net
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:45:15
	 * 文本文件加载  txt  csv xml  等等文件
	 */
	public final  class FileLoader
	{
		/**该函数带有一个FileLoader类型的参数
		 */		
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有一个ProgressEvent类型的参数
		 */		
		public var progressCallBack:Function=null;
		/**加载完成后得到的数据
		 */		
		protected var _data:*;
		private var loader:URLLoader;
		private var request:URLRequest;
		private var format:String;
		public function FileLoader(format:String="text")
		{
			this.format=format;
			initData();
		}
		private function initData():void
		{
			loader=new URLLoader();
			loader.dataFormat=format;
			request=new URLRequest();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		public function load(url:String):void
		{
			request.url=url;
			loader.load(request);
		}
		private function onComplete(e:Event):void
		{
			_data=loader.data;
			if(loadCompleteCallBack!=null)loadCompleteCallBack(this);
			remove();
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("FileLoader::发生流错误，错误地址为:",request.url);
	//		ErrorCollection.Instance.collect("FileLoader::发生流错误，错误地址为:"+request.url);
			remove();
			
		}
		private function onProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null) progressCallBack(e);
		}
		private function remove():void
		{
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			request.url="";
			request=null;
			loader=null;
			loadCompleteCallBack=null;
			progressCallBack=null;
		}
		
		public function get data():*
		{
			return _data;
		}
		
	}
}