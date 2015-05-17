package com.YFFramework.core.net.loader.image_swf
{
	import com.YFFramework.core.net.loader.file.FileLoader;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/** 加载swf 或者 ng 进行跨域加载
	 * 
	 * @author yefeng
	 *2012-6-24下午2:57:44
	 */
	public class UILoader
	{
		/**  含有 DisplayObject类型的参数    表示加载的对象  和一个传递数据的变量
		 */
		public var loadCompleteCallback:Function;
		/**带有 一个 e:ProgressEvent类型的参数 
		 */
		public var progressCallBack:Function;
		/**发生错误
		 */		
		public var ioErrorCallBack:Function;
		private var fileLoader:FileLoader;
		/** 加载进来的对象存放的容器  假如为null则不进行存放
		 */
		private var holder:Sprite;
		
		private var domain:ApplicationDomain;
		
		/** 数据传递  传递数据
		 */
		protected var _data:Object;
		public function UILoader()
		{
		}
		/**
		 * @param url  资源地址
		 * @param holder  加载进来的对象存放的容器  假如为null则不进行存放  不为空  则表示加载进来的对象将会存放在 holder容器里面W
		 * @data是传递的数据  可以通过回调函数 loadCompleteCallback(argument1,argument2)  argument2 访问   argument2
		 */
		public function initData(url:String,holder:Sprite=null,data:Object=null,domain:ApplicationDomain=null):void
		{
			this.domain=domain;
			this.holder=holder;
			_data=data;
			fileLoader=new FileLoader(URLLoaderDataFormat.BINARY);
			fileLoader.loadCompleteCallBack=fileLoadCallBack;
			fileLoader.progressCallBack=progressCallBack;
			fileLoader.ioErrorCallback=ioErrorCallBack;
			fileLoader.load(url);
		}
		
		private function fileLoadCallBack(fileLoader:FileLoader):void
		{
			var data:ByteArray=fileLoader.data as ByteArray;
			var loader:BytesLoader=new BytesLoader();
			loader.loadCompleteCalback=bytesLoadComplete;
			loader.load(data,domain);
		}
		
		private function bytesLoadComplete(loader:BytesLoader,domain:ApplicationDomain):void
		{
			var  content:DisplayObject=loader.content;
			if(holder)holder.addChild(content);
			if(loadCompleteCallback!=null)loadCompleteCallback(content,_data);
			dispose();
		}
		
		private function dispose():void
		{
			holder=null;
			domain=null;
			progressCallBack=null;
			loadCompleteCallback=null;
			fileLoader=null;
		}
		
	}
}  

///类中类
//import com.YFFramework.core.debug.Log;
//import com.YFFramework.core.debug.print;
//import flash.display.DisplayObject;
//import flash.display.Loader;
//import flash.events.Event;
//import flash.events.IOErrorEvent;
//import flash.events.ProgressEvent;
//import flash.net.URLRequest;
//
//
///**   加载  image 和 swf  都可以   而image 包  和swf 只是分别加载 建议   用通用包CommonLoader  这样可以减少文件大小
// * author :夜枫
// */
//class CommonLoader
//{
//	/** 干函数带有一个CommonLoader类型的参数
//	 */
//	public  var loadCompleteCallBack:Function=null;
//	/**该函数带有一个ProgressEvent类型的参数
//	 */	
//	public var progressCallBack:Function=null;
//	private var content:DisplayObject;
//	private var _loader:Loader;
//	private var _request:URLRequest;
//	
//	public function CommonLoader()
//	{
//		init();
//	}
//	private function init():void
//	{
//		_loader=new Loader();
//		_request=new URLRequest();
//		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
//		_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
//		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
//	}
//	public function initData(url:String):void
//	{
//		_request.url=url;
//		if(_loader.content) _loader.unloadAndStop();
//		_loader.load(_request);
//	}
//	
//	private function onProgress(e:ProgressEvent):void
//	{
//		if(progressCallBack!=null) progressCallBack(e);
//	}
//	
//	private function onError(e:IOErrorEvent):void
//	{
//		print(this,"UILoader===>发生流错误，错误地址为:"+_request.url);
//		Log.Instance.e("CommonLoader::发生流错误，错误地址为:"+_request.url);
//		destroy();
//	}
//	
//	private function onComplete(e:Event):void
//	{
//		content=_loader.content
//		if(loadCompleteCallBack!=null)loadCompleteCallBack(content);///loadCompleteCallBack函数的声明 需要加上参数  参数为imageLoader 为的是得到他的引用
//		destroy();
//	}
//	
//	private function destroy():void
//	{
//		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
//		_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
//		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
//		_request.url="";
//		_request=null;
//		_loader.unloadAndStop();
//		_loader=null;
//		loadCompleteCallBack=null;
//		progressCallBack=null;
//	}
//	public function remove():void
//	{
//		content=null;
//	}
//	/** 关闭加载
//	 */		
//	public function close():void
//	{
//		_loader.close();
//		destroy();
//	}
//}
