package com.YFFramework.core.net.loader.image_swf
{
	import com.YFFramework.core.debug.print;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**@author flashk
	 * 
	 * 加载swf 或者 ng 进行跨域加载
	 */
	public class IconLoader
	{
		private static var dict:Dictionary=new Dictionary();

		/**  含有 DisplayObject类型的参数    表示加载的对象  和一个传递数据的变量
		 */
		public var loadCompleteCallback:Function;
		/**带有 一个 e:ProgressEvent类型的参数 
		 */
		public var progressCallBack:Function;
		/**发生错误
		 */		
		public var ioErrorCallBack:Function;
		/** 加载进来的对象存放的容器  假如为null则不进行存放
		 */
		
		private var _container:Sprite;
		private var _url:String;
		private var _bpPos:Object;
		private var _callData:Object;
		private var _loader:Loader;

		public function IconLoader(){
			
		}
		
		/**加载图标
		 * @param url
		 * @param holder
		 * @param data
		 * @param domain
		 * @param pos {x,y} 用来对content进行定位
		 */		
		public static function initLoader(url:String,holder:Sprite=null,data:Object=null,pos:Object=null):void{
			var iconLoader:IconLoader = new IconLoader();
			iconLoader.initData(url,holder,data,pos);
		}

		/**
		 * @param url  资源地址
		 * @param holder  加载进来的对象存放的容器  假如为null则不进行存放  不为空  则表示加载进来的对象将会存放在 holder容器里面W
		 * @data是传递的数据  可以通过回调函数 loadCompleteCallback(argument1,argument2)  argument2 访问   argument2
		 * @param pos {x,y} 用来对content进行定位
		 */
		public function initData(url:String,holder:Sprite=null,data:Object=null,pos:Object=null):void{
			_url = url;
			_container = holder;
			_callData = data;
			_bpPos = pos;
			if(_loader == null){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadIOError);
			}
			var isInCatch:Boolean = checkInCatchAndAdd();
			if(isInCatch == false){
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
				_loader.load(new URLRequest(_url));
			}else{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
				try{
					_loader.close();
				} catch(error:Error) {}
			}
		}
		
		protected function onLoadIOError(event:IOErrorEvent):void{
			print(this,"加载错误，错误地址："+_url);
			if(ioErrorCallBack != null) ioErrorCallBack(event);
		}
		
		protected function onLoadProgress(event:ProgressEvent):void{
			if(progressCallBack != null) progressCallBack(event);
		}
		
		protected function onLoadComplete(event:Event):void{
			var bd:BitmapData = Bitmap(_loader.content).bitmapData;
			dict[_url] = bd;
			checkInCatchAndAdd();
		}		
		
		private function checkInCatchAndAdd():Boolean{
			var bd:BitmapData = dict[_url];
			if(bd){
				var bp:Bitmap = new Bitmap();
				bp.bitmapData = bd;
				if(_container) _container.addChild(bp);
				if(_bpPos){
					bp.x = _bpPos.x;
					bp.y = _bpPos.y;
				}
				if(loadCompleteCallback != null){
					loadCompleteCallback(bp,_callData);
				}
				return true;
			}
			return false;
		}
		
	}
}