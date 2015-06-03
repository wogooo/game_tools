package com.YFFramework.core.net.loader.file
{
	import com.YFFramework.core.debug.LoadErrorLog;
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午02:59:34
	 */
	public final class FilesLoader
	{
		/**该函数带有一个FilesLoader类型的参数
		 */		
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有ProgressEvent类型的参数 和一个int型的指示当前正在加载的个数的参数<索引从0开始>
		 */		
		public var progressCallBack:Function=null;
		/**  数据保存数组
		 */
		public var dataArr:Array=[];
		private var loader:URLLoader;
		private var request:URLRequest;
		private var currentIndex:int; ////索引从0开始
		private var totalLen:int;//数组总长度
		private var urlArr:Vector.<Object>;//加载的地址的数组
		public function FilesLoader()
		{
			initData();
		}
		private function initData():void
		{
			loader=new URLLoader();
			request=new URLRequest();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		
		/** 文件地址   arr里保存的是 Object类型的对象  含有  url 属性
		 */
		public function load(arr:Vector.<Object>):void
		{
			if(arr.length!=0)
			{
				urlArr=arr;
				currentIndex=0;
				totalLen=arr.length;
				beginLoad();
			}
			else destroy();
		}
		private function beginLoad():void
		{
			if(currentIndex!=totalLen)///继续加载
			{
				request.url=urlArr[currentIndex].url;
				loader.load(request);
			}
			else ///加载完成
			{
				if(loadCompleteCallBack!=null)loadCompleteCallBack(this);
				destroy();
			}
		}
		
		private function onComplete(e:Event):void
		{
			urlArr[currentIndex].data=loader.data;//保存加载的数据 除 去url属性
			delete urlArr[currentIndex].url;
			dataArr.push(urlArr[currentIndex])
			++currentIndex;
			beginLoad();
		}
		/** 发生错误后继续进行加载  错误部分用null填充表示出现错误
		 */		
		private function onError(e:IOErrorEvent):void
		{
			print(this,"FilesLoader::发生流错误，错误地址为:",request.url);
			LoadErrorLog.Instance.add("FilesLoader::发生流错误，错误地址为:"+request.url);
			dataArr.push(null);
			++currentIndex;
			beginLoad();
		}
		private function onProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null)progressCallBack(e,currentIndex);
		}
		private function destroy():void
		{
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			request.url="";
			request=null;
			loader=null;
			loadCompleteCallBack=null;
			progressCallBack=null;
			urlArr=null;
		}
		public function dispose():void
		{
			dataArr=null;
		}
		
	}
}