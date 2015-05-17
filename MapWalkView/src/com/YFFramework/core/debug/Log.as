package com.YFFramework.core.debug
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.DebugEvent;
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	

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
		
		private var _socketInfo:String="";
		private var file:FileReference=new FileReference();
		public function Log()
		{
			System.useCodePage=true
			var item:KeyBoardItem=new KeyBoardItem(Keyboard.F9,itemIt); 
			var item2:KeyBoardItem=new KeyBoardItem(Keyboard.F8,itemIt); 
		}
		private function itemIt(code:int):void
		{
			switch(code)
			{
				case Keyboard.F9:
					file.save(_socketInfo)
					break;
				case Keyboard.F8:
					_socketInfo="";
					break;
			}
					
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
		
		public function c(cmd:int,msg:Message):void
		{
			_socketInfo += "**************客户端发送消息***************"+"\r\n";
			
			_socketInfo +="C=="+ cmd+"\r\n"+"NAME:"+"\r\n"+getQualifiedClassName(msg)+"\r\n";
//			_socketInfo += "\r\n";
			
			if(msg)
			{
				_socketInfo += "MESSAGE:"+"\r\n"+msg.toString()+"\r\n";
			}
			_socketInfo += "\r\n\r\n";	
		}
		
		public function s(cmd:int,bodyData:Message):void
		{
			_socketInfo += "++++++++++++++服务端发送消息+++++++++++++++"+"\r\n";
			_socketInfo +="S=="+ cmd+"\r\n"+"NAME:"+"\r\n"+getQualifiedClassName(bodyData)+"\r\n";
//			_socketInfo += "\r\n";
			
			if(bodyData)
			{
				_socketInfo += "MESSAGE:"+"\r\n"+bodyData.toString()+"\r\n";
			}
			else
			{
				_socketInfo += "没有数据\r\n";
			}
			_socketInfo += "\r\n\r\n";
		}

		
		
		public function get errorInfo():String
		{
			return _erro;
		}
		
		public function get verboseInfo():String
		{
			return _verbose;
		}
		
		public function printArr(arr:Array):String
		{
			var str:String="";
			for each(var i:* in arr)
			{
				str +=String(i);
			}
			return str;
		}

		
	}
}