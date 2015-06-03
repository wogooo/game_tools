package com.YFFramework.core.net.so
{
	import com.YFFramework.core.debug.print;
	
	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**@author yefeng
	 *2012-9-28下午10:43:36
	 */
	public class ShareObjectManager
	{
		private static const Size:int=1024*1000*5*10;/// 500M 
		private static const FileSize:int=1024*1000*3
		private static var _instance:ShareObjectManager;
		private var _forCapacitySO:SharedObject; //作用为请求分配 so大小  以及存储全局字符串
		private static const SOName:String="YFSO"; //用来进行 存储
		
		private var _dict:Dictionary;
			
		/**资源根目录
		 */		
		private var __root:String;
		/**版本号
		 */		
		private var __version:String;
		public function ShareObjectManager()
		{
			_dict=new Dictionary();
			SharedObject.defaultObjectEncoding=ObjectEncoding.AMF3; ///amf3编码
			_forCapacitySO=SharedObject.getLocal(SOName,"/");
			_dict[SOName]=_forCapacitySO;
			addEvents();
		}
		/**
		 * @param root 资源根目录
		 * @param version 版本号
		 * 
		 */		
		public function init(root:String,version:String):void
		{
			__root=root;
			__version=version;
		}
		/**  根据url获取对应的so文件   url 为  文件的 http地址
		 * @param url  地址  
		 * @return 
		 * 
		 */		
		private function getSOByURL(url:String):SharedObject  //此方法很消耗时间
		{
//			var so:SharedObject= _dict[url];
//			if(!so) 
//			{
//				//得到文件的URL   例如  dyUI/movie/role/npc/12.yf2d?13715444850510.5440065683797002
//				var fileUrl:String=url.replace(__root,"");   
//				//获取除去版本号后的 地址
//				var index:int=fileUrl.indexOf("?");
//				if(index!=-1)
//				{
//					fileUrl=fileUrl.substring(0,index);  ///dyUI/movie/role/npc/12.yf2d
//				}
//				var t:Number=getTimer();
//
//				so=SharedObject.getLocal(fileUrl,"/"); 
//				_dict[url]=so;
//				trace("so消耗耗时间::..."+(getTimer()-t));
//			}
//			return so;
			return null;
		}

		private function addEvents():void
		{
			_forCapacitySO.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		private function onNetStatus(e:NetStatusEvent):void
		{  
			print(this,e.info);
		}
		/**弹出写入缓存大小的窗口  
		 */		
		public function flushSize():void
		{
//			_forCapacitySO.flush(Size);	
		}
		
		public static function get Instance():ShareObjectManager
		{
			if(!_instance)_instance=new ShareObjectManager();
			return _instance;
		}
		/** 设置版本
		 * @param so
		 * @param version
		 */		
		private function setVersion(so:SharedObject,version:String):void
		{
			so.data["version"]=version;
		}
		/**获取版本
		 * @param so
		 * @return 
		 * 
		 */		
		private function getVersion(so:SharedObject):String
		{
			return so.data["version"];	
		}
		public function put(url:String,data:Object):void
		{
//			var so:SharedObject=getSOByURL(url); //获取相关so 
//			setVersion(so,__version);
//			//进行数据存储
//			var bytes:ByteArray;
//			if(data is ByteArray)  ///当为byteArray
//			{
//				//				print(this," so暂时屏蔽掉....此处直接return ");
//				//				return ;
//				so.data[url]=ByteArray(data);
//			}
//			else if(data is String)
//			{
//				so.data[url]=data;
//			}
			
		}
		
		
		
		/** 获取数据
		 */		
		public function getObjByteArray(url:String):ByteArray
		{
//			var so:SharedObject=getSOByURL(url);
//			var version:String=getVersion(so);
//			if(version==__version)
//			{
//				var soBytes:ByteArray=so.data[url] as ByteArray;
//				if(soBytes)
//				{
//					var bytes:ByteArray=new ByteArray();
//					bytes.writeBytes(soBytes);
//					bytes.position=0;
//					return bytes;	
//				}
//			}
//			else 
//			{
//				so.clear();//清空  该版本的数据
//			}
			return null;
		}

		/** 存储全局的字符串
		 * @param name
		 * @return 
		 */		
		public function getString(name:String):String
		{
//			var so:SharedObject=getSOByURL(name);
//			return so.data[name];
			return null;
		}
		
		

		/**  是否存在该对象
		 * @param url
		 */		
		public function isExsit(url:String):Boolean
		{
//			var so:SharedObject=getSOByURL(url);
//			var soBytes:ByteArray=so.data[url] as ByteArray;
//			if(soBytes) return true;
			return false;
		}
		public function remove(url:String):void
		{
//			var so:SharedObject=getSOByURL(url);
//			so.data[url]=null;
//			delete _forCapacitySO.data[url];
		}
		
		/**清除所有的
		 */		
		public function clearAll():void
		{
			_forCapacitySO.clear();	
		}
		
	}
}