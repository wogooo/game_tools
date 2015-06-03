package com.YFFramework.core.net.loader.image_swf
{
	import com.YFFramework.core.debug.LoadErrorLog;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	/**  加载字节
	 *  @author yefeng
	 *   @time:2012-3-16上午10:06:03
	 */
	public class BytesLoaders extends EventDispatcher
	{
		
		public var data:Object;
		
		/** 带BytesLoader类型参数的回调函数
		 */		
		public var loadCompleteCalback:Function;
		public var contentArr:Vector.<DisplayObject>;
		private var _loader:Loader;
		
		private var _loadIndex:int;
		private var bytesArr:Vector.<ByteArray>;
		public function BytesLoaders()
		{
			contentArr=new Vector.<DisplayObject>();
			_loadIndex=0;
			_loader=new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);

		}
		public function load(bytesArr:Vector.<ByteArray>):void
		{
			this.bytesArr=bytesArr;
			handleLoad();
		}
		private function handleLoad():void
		{
			_loader.loadBytes(bytesArr[_loadIndex]);

		}
		private function onEventComplete(e:Event):void
		{
			contentArr.push(LoaderInfo(e.target).content);
			++_loadIndex;
			_loader.unloadAndStop();
			if(_loadIndex<bytesArr.length) handleLoad();
			else 
			{
				if(loadCompleteCalback!=null) loadCompleteCalback(this);
				dispose();
			}
  
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("BytesLoader::字节加载发生错误...,错误索引为:"+_loadIndex);
			LoadErrorLog.Instance.add("BytesLoader::字节加载发生错误...,错误索引为:"+_loadIndex);
		}
		
		protected function dispose():void
		{
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loadCompleteCalback=null;
			_loader=null;
		}

	}
}