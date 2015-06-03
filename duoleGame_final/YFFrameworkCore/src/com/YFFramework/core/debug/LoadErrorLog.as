package com.YFFramework.core.debug
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;

	/** 加载地址资源错误日志
	 * @author yefeng
	 * 2013 2013-7-13 下午1:58:25 
	 */
	public class LoadErrorLog
	{
		private static var _instance:LoadErrorLog;
		
		private var _totalLoadErrorInfo:String;
		public function LoadErrorLog()
		{
			_totalLoadErrorInfo="###资源错误地址汇总####"+"\r\n";
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDow);
		}
		private function onKeyDow(e:KeyboardEvent):void
		{
			if(e.keyCode==Keyboard.F9)
			{
				var file:FileReference=new FileReference();
				file.save(_totalLoadErrorInfo,"资源缺少地址汇总.txt");
			}
		}
		
		public static function get Instance():LoadErrorLog
		{
			if(!_instance) _instance=new LoadErrorLog();
			return _instance;
		}
		
		public function add(str:String):void
		{
			_totalLoadErrorInfo +=str+"\r\n";
		}
		public function getLoadErrorInfo():String
		{
			return _totalLoadErrorInfo;
		}
	}
}