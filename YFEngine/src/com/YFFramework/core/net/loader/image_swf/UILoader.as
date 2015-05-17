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
		/**加载进来的字节
		 */		
		private var _bytes:ByteArray;
		
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
			fileLoader.load(url,_data);
		}
		
		private function fileLoadCallBack(fileLoader:FileLoader):void
		{
			var data:ByteArray=fileLoader.data as ByteArray;
			var tmpObj:Object=fileLoader.getTemData();
			_data=tmpObj;
//			var loader:BytesLoader=new BytesLoader();
//			loader.loadCompleteCalback=bytesLoadComplete;
//			loader.load(data,domain);
			loadBytes(data,tmpObj);
		}
		/**
		 * @param data  自己数据
		 * @param tmpObj	 数据传递变量
		 */		
		public function loadBytes(data:ByteArray,tmpObj:Object=null):void
		{
			///保存数据
			_bytes=new ByteArray();
			_bytes.writeBytes(data);

			_data=tmpObj;
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
			_bytes=null;
		}
		public function getContentBytes():ByteArray
		{
			return _bytes;
		}
		
	}
}  
