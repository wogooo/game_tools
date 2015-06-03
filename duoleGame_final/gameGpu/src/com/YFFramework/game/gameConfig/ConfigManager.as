package com.YFFramework.game.gameConfig
{
	import com.YFFramework.core.debug.print;
	
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**配置文件 的信息
	 * @author yefeng
	 *2012-4-21下午8:21:28
	 */
	public class ConfigManager
	{
		/**平台*/
		public var platform:String=TypePlatform.PF_37wan;
		/**网站 id 
		 */		
		public var webId:String;	
		/**web key 
		 */		
		public var keyId:String;
		
		/**主应用程序名
		 */		
		public var appName:String;
		/**主应用程序地址
		 */		
		public var appUrl:String;
		
		/**聊天服务器用的 ip
		 */
		public var chatIp:String;

		/**选中的ips
		 */		
		public var selectIp:String;
		
		private var _xml:XML;
		private var _root:String;
		
		private var _ip:String;
		/**主逻辑端口
		 */		
		public var port:int;
		/** 校验端口
		 */		
		public var checkport:int;
		/**聊天服务器端口
		 */		
		public var chatPort:int;
		
		/**版本号
		 */		
		private var _version:String;
		private static var _instance:ConfigManager;
		/**  socket数组
		 */		
		public var socketArr:Array;
		
		/**当前网页的网址  用于刷新 
		 */		
		public var webHost:String;
		public function ConfigManager()
		{
			socketArr=[];
//			initFlashVersion();
		}
		public static function get Instance():ConfigManager
		{
			if(!_instance)_instance=new ConfigManager();
			return _instance;
		}
		
		public function  setRoot(url:String):void
		{
			_root=url;
		}
		/** 调试调用的接口 
		 */
		public function parseDataForDebug(data:XML):void
		{
			_xml=data;
//			_root=_xml.libs.@root;  ///版本发布时候需要去掉
			print(this,"此处root过滤...,版本发布时候需要将 root.txt去掉");
			_version=_xml.libs.@version+""+Math.random();
			if(!webId) // 没有进行赋值 也就是不是通过html登录的
			{
				var len:int=_xml.system.socket.length();
				for(var i:int=0;i!=len;++i)
				{
					socketArr.push({ip:_xml.system.socket[i].@ip+"",port:int(_xml.system.socket[i].@port),checkPort:int(_xml.system.socket[i].@checkPort),tittle:_xml.system.socket[i].@ip+""});
					chatPort=_xml.system.socket[i].@chatPort;///聊天服务器端口
					checkport=_xml.system.socket[i].@checkPort;///聊天服务器端口
				}

			}
			
			
			try
			{
				webHost=ExternalInterface.call('function(){return document.location.href.toString()}');
			}
			catch(e:Error)
			{
				webHost=_root;
			}
			loadPolicy();
		}
		
		/**发布版本使用的接口
		 */
		public function parseData(data:XML):void
		{
			_xml=data;
			_root=_xml.libs.@root;  ///版本发布时候需要去掉
			_version=_xml.libs.@version;
			
			loadPolicy();
			try
			{
				webHost=ExternalInterface.call('function(){return document.location.href.toString()}');
			}
			catch(e:Error)
			{
				webHost=_root;
			}
			
			
		}

		/**加载安全策略    必须要这个才能通过腾讯资源服务器
		 */
		private function loadPolicy():void
		{
			Security.loadPolicyFile(_root+"crossdomain.xml");
		}
		
		
		
		
		
		
		public function getRoot():String
		{
			return _root;
		}
		/**版本
		 */		
		public function getVersion():String
		{
			return _version;
		}
		/** 版本字符串
		 */		
		public function getVersionStr():String
		{
			return "?v="+_version
		}
		
		/**得到 swf列表
		 */		
		public function getUIList():Vector.<Object>
		{
			var list:XMLList=_xml.libs.ui;
			var len:int=list.swf.length();
			var obj:Object;
			var arr:Vector.<Object>=new Vector.<Object>();
			for(var i:int=0;i!=len;++i)
			{
				obj={url:getRoot()+list.swf[i],tips:list.swf[i].@tittle}
				arr.push(obj);
			}
			return arr;
		}
		
		/** 获得各个数值表 的具体信息
		 */		
		public function getFileList():Vector.<Object>
		{
			var list:XMLList=_xml.libs.files;
			var len:int=list.item.length();
			var obj:Object;
			var arr:Vector.<Object>=new Vector.<Object>();
			for(var i:int=0;i!=len;++i)
			{
				obj={url:getRoot()+list.item[i]+"?V="+_version,tips:list.item[i].@tittle,id:int(list.item[i].@id)}
				arr.push(obj);
			}
			return arr;

		}
		/**获取res文件
		 */		
		public function getResURL():String
		{
			return getRoot()+_xml.libs.res;
		}
		
		/**获取登录的 URL地址 
		 */
		public function getLoginURL():String
		{
			return getRoot()+_xml.libs.login;
		}
		/**获取jsonlib数据
		 */		
		public function getJsonLibURL():String
		{
			return getRoot()+_xml.libs.jsonLib+"";
		}
		
		
		/** 获取 xx2d文件
		 */
		public function getXX2dFiles():Array
		{
			var xx2dList:XMLList=_xml.libs.xx2d;
			var len:int=xx2dList.item.length();
			
			var url:String;
			var arr:Array=[];
			for(var i:int=0;i!=len;++i)
			{
				url=URLTool.getMapConfig(int(xx2dList.item[i]));
				arr.push(url);
			}
			return arr;
		}
		
		/**获取接入腾讯服务器需要的字节  主逻辑
		 */
		public function getMaintTencentBytes():ByteArray
		{
//			var str:String="tgw_l7_forward\r\nHost:"+getPengYouHostLogic()+":"+port+"\r\n\r\n";
//			var bytes:ByteArray=new ByteArray();
//			bytes.writeMultiByte(str,"GBK");
//			bytes.position=0;
//			return bytes;
			return new ByteArray();
		}
		/**获取接入腾讯服务器需要的字节 聊天服务器
		 */
		public function getChatTencentBytes():ByteArray
		{
//			var str:String="tgw_l7_forward\r\nHost:"+getPengYouHostChat()+":"+chatPort+"\r\n\r\n";
//			var bytes:ByteArray=new ByteArray();
//			bytes.writeMultiByte(str,"GBK");
//			bytes.position=0;
//			return bytes;
			return new ByteArray();
		}
		
		/**朋友网host 逻辑服务器的ip
		 */
		private function getPengYouHostLogic():String
		{
			return _xml.libs.pengyou.@logic+"";
		}
		/**朋友网host 聊天服务器的ip
		 */
		private function getPengYouHostChat():String
		{
			return _xml.libs.pengyou.@chat+"";
		}
		
		
		
		
	}
}