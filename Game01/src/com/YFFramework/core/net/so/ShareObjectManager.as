package com.YFFramework.core.net.so
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.movie.data.ActionData;
	
	import flash.display.BitmapData;
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**@author yefeng
	 *2012-9-28下午10:43:36
	 */
	public class ShareObjectManager
	{
		private static const Size:int=1024*1000*5*1000;/// 500M 
		private static var _instance:ShareObjectManager;
		private var _so:SharedObject;
		private static const SOName:String="YFSO";
		
		private var _dict:Dictionary
		public function ShareObjectManager()
		{
			SharedObject.defaultObjectEncoding=ObjectEncoding.AMF3; ///amf3编码
			_so=SharedObject.getLocal(SOName,"/");
			addEvents();
		}
		private function addEvents():void
		{
			_so.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		private function onNetStatus(e:NetStatusEvent):void
		{  
			print(this,e.info);
		}
		/**弹出写入缓存大小的窗口  
		 */		
		public function flushSize():void
		{
			_so.flush(Size);	
		}
		
		public static function get Instance():ShareObjectManager
		{
			if(!_instance)_instance=new ShareObjectManager();
			return _instance;
		}
		/**存入数据
		 * url  是 属性  一般为地址url
		 *  data是具体的数据
		 */		
		public function put(url:String,data:Object):void
		{
			var bytes:ByteArray;
			if(data is ByteArray)  ///当为byteArray
			{
				_so.data[url]=ByteArray(data);
			}
			else if(data is ActionData) ///当为动画数据
			{
				
			}
			else if(data is BitmapData) ///当为像素
			{
				
			}
		//	flushSize();////不能调用 ，该方法的调用很卡
		}
		/** 获取数据
		 */		
		public function getObjByteArray(url:String):ByteArray
		{
			var soBytes:ByteArray=_so.data[url] as ByteArray;
			if(soBytes)
			{
				var bytes:ByteArray=new ByteArray();
				bytes.writeBytes(soBytes);
				bytes.position=0;
				return bytes;	
			}
			return null;
		}
		/**  是否存在该对象
		 * @param url
		 */		
		public function isExsit(url:String):Boolean
		{
			var soBytes:ByteArray=_so.data[url] as ByteArray;
			if(soBytes) return true;
			return false;
		}
		/**移除 某个属性
		 * @param url
		 */		
		public function remove(url:String):void
		{
			_so.data.url=null;
			delete _so.data.url;
		}
		
	}
}