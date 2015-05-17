package com.YFFramework.core.debug
{
	import com.YFFramework.core.event.DebugEvent;
	
	import flash.events.EventDispatcher;
	

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:52:03
	 * 错误收集
	 */
	public class Log extends EventDispatcher
	{
		private static var _instance:Log;
		private var _erro:String="";
		/**必要信息
		 */
		private var _verbose:String="";
		public function Log()
		{
			if(_instance) throw new Error("请使用Instance属性");
		}
		public static function get Instance():Log
		{
			if(!_instance) _instance=new Log();
			return _instance;
		}
		/** 进行错误收集
		 */		
		public function e(str:Object):void
		{
			var seprator:String="================================================";///行分割符号
			_erro +="#错误信息# "+String(str)+"\r\n"+seprator+"\r\n"+seprator+"\r\n";
			dispatchEvent(new DebugEvent(DebugEvent.ErrorInfoUpdate,errorInfo));
		}
		/**提示信息
		 */
		public function v(str:Object):void
		{
			var seprator:String="++++++++++++++++++++++++++++++++++++++++++++++++++";///行分割符号
			_verbose +="#提示信息#"+String(str)+"\r\n"+seprator+"\r\n"+seprator+"\r\n";
			dispatchEvent(new DebugEvent(DebugEvent.VerboseInfoUpdate,_verbose));
		}
		public function get errorInfo():String
		{
			return _erro;
		}
		
		public function get verboseInfo():String
		{
			return _verbose;
		}
		
		
	}
}