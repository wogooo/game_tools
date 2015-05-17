package com.YFFramework.game.gameConfig
{
	/**配置文件 的信息
	 * @author yefeng
	 *2012-4-21下午8:21:28
	 */
	public class ConfigManager
	{
		private var _xml:XML;
		private var _root:String;
		private var _ip:String;
		private var _port:int;
		private var _checkport:int;
		private var _version:String;
		private static var _instance:ConfigManager;
		
		public function ConfigManager()
		{
		}
		public static function get Instance():ConfigManager
		{
			if(!_instance)_instance=new ConfigManager();
			return _instance;
		}
		
		public function parseData(data:XML):void
		{
			_xml=data;
			_root=_xml.libs.@root;
			_version=_xml.libs.@version;
			_ip=_xml.system.socket.@ip;
			_port=int(_xml.system.socket.@port);
			_checkport=int(_xml.system.socket.@checkport);
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
		public function getIp():String
		{
			return _ip;
		}
		public function getPort():int
		{
			return _port;
		}
		/**
		 *得到验证端口   843端口的替代 
		 */		
		public function getCheckPort():int
		{
			return _checkport;
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
		
	}
}