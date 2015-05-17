package com.YFFramework.core.net.loader.file
{
	import com.YFFramework.core.debug.Log;
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:45:15
	 * 文本文件加载  txt  csv xml  等等文件
	 */
	public   class FileLoader
	{
		/**该函数带有一个FileLoader类型的参数
		 */		
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有一个ProgressEvent类型的参数
		 */		
		public var progressCallBack:Function=null;
		
		public var ioErrorCallback:Function;
		/**加载完成后得到的数据
		 */		
		protected var _data:*;
		protected var loader:URLLoader;
		protected var request:URLRequest;
		private var format:String;
		/**传递参数
		 */		
		protected var _tmpData:Object;
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
		public function load(url:String,data:Object=null):void
		{
			_tmpData=data;
			request.url=url;
			loader.load(request);
		}
		protected function onComplete(e:Event):void
		{
			_data=loader.data;
			if(loadCompleteCallBack!=null)loadCompleteCallBack(this);
			remove();
		}
		protected function onError(e:IOErrorEvent):void
		{
			if(ioErrorCallback!=null) ioErrorCallback(request.url);
			print(this,"加载发生流错误，错误地址为:",request.url);
			Log.Instance.e("FileLoader::发生流错误，错误地址为:"+request.url);
			remove();
	//		throw new Error("加载发生流错误，错误地址为:"+request.url);
			
		}
		protected function onProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null) progressCallBack(e);
		}
		protected function remove():void
		{
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			request.url="";
			request=null;
			loader=null;
			loadCompleteCallBack=null;
			progressCallBack=null;
			_tmpData=null;
		}
		
		public function get data():*
		{
			return _data;
		}
		/**  获取传递进来的参数
		 */		
		public function getTemData():Object
		{
			return _tmpData;
		}
	}
}