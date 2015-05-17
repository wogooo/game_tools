package com.YFFramework.core.center.system
{
	import flash.utils.Dictionary;
	
	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:16:54
	 * 
	 * 系统配置 ，主要是用来保存临时需要的量  避免全局变量的创建  单例模式
	 * 动态创建变量 SystemConfig.Instance["临时量设置"]
	 */
	public class TempObject
	{
		private  var _systemConfig:Dictionary;
		private static var _instance:TempObject;
		public function TempObject()
		{
			if(_instance) throw new Error("请使用Instance属性");
			else init();
		}
		
		private function init():void
		{
			_systemConfig=new Dictionary();
		}
		public static function  get Instance():TempObject
		{
			if(!_instance) _instance=new TempObject(); 
			return _instance;
		}
		
		public  function setKey(key:String,value:Object):void
		{
			_systemConfig[key]=value;
		}
		public  function  getObj(key:String):Object
		{
			return _systemConfig[key];
		}
		/** 删除key 变量
		 */		
		public  function deleteKey(key:String):void
		{
			delete _systemConfig[key];
		}
		public  function haveKey(key:String):Boolean
		{
			if(_systemConfig[key]!=null) return true;
			return false;
		}
		
		public function toString():String
		{
			var str:String="";
			for(var key:String in _systemConfig)
			{
				str +=key+":"+_systemConfig[key]+"\n";
			}
			return str;
		}
	}
}