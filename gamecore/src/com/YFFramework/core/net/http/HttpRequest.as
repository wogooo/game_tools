package com.YFFramework.core.net.http
{
	import com.YFFramework.core.debug.print;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class HttpRequest
	{
		private var _urlLoader:URLLoader;
		private var _request:URLRequest;
		/**返回成功后响应
		 */
		private var _callBack:Function;
		private var _isDispose:Boolean;
		public function HttpRequest(dispose:Boolean=true)
		{
			_isDispose=dispose;
			initData();
			addEvents();
		}
		/**发送数据 
		 */
		public function sendMessage(request:URLRequest,callback:Function):void
		{
			_request=request;
			_callBack=callback;
			_urlLoader.load(_request);
		}
		/**初始化
		 */
		private function initData():void
		{
			_urlLoader=new URLLoader();
		}
		/**事件侦听
		 */
		private function addEvents():void
		{
			_urlLoader.addEventListener(Event.COMPLETE,onEventComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		private function removeEvents():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE,onEventComplete);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		/**
		 */
		private function onEventComplete(e:Event):void
		{
			var data:Object=_urlLoader.data;
			_callBack(data);
			if(_isDispose)dispose();
		}
		private function onError(e:IOErrorEvent):void
		{
			print(this,"地址找不到,地址："+_request.url);
		}
		
		private function dispose():void
		{
			removeEvents();
			_request=null;
			_urlLoader=null;
			_callBack=null;
			_isDispose=true;
		}
		public function get isDispose():Boolean{return _isDispose;}
		
		
	}
}