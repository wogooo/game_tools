package movieData.movie.net
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 *  @author yefeng
	 *   @time:2012-3-16上午09:52:48
	 */
	public class BytesLoader extends EventDispatcher
	{
		/** 带BytesLoader类型参数的回调函数
		  */		
		public var loadCompleteCalback:Function;
		public var content:DisplayObject;
		private var _loader:Loader;
		private var domain:ApplicationDomain;
		public function BytesLoader()
		{
		}
		
		public function load(bytes:ByteArray,domain:ApplicationDomain=null):void
		{
			_loader=new Loader();
			var context:LoaderContext=new LoaderContext();
			context.allowCodeImport=true;
			if(!domain) domain=ApplicationDomain.currentDomain;
			context.applicationDomain=domain;
			this.domain=domain;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_loader.loadBytes(bytes,context);
		}
		
		private function onEventComplete(e:Event):void
		{
			content=LoaderInfo(e.target).content;
			if(loadCompleteCalback!=null) loadCompleteCalback(this,domain);
			if(hasEventListener(Event.COMPLETE)) dispatchEvent(e);
			_loader.unloadAndStop();
			dispose();
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("BytesLoader::字节加载发生错误...");
//			ErrorCollection.Instance.collect("BytesLoader::字节加载发生错误");
		}
		
		protected function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loadCompleteCalback=null;
			_loader=null;
			content=null;
			domain=null;
		}
	}
}