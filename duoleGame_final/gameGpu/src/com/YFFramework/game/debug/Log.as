package com.YFFramework.game.debug
{
	import com.YFFramework.core.debug.print;
	import com.netease.protobuf.Message;
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:52:03
	 * 错误收集
	 */
	public class Log extends EventDispatcher
	{
		private static var _instance:Log;
		
		public function Log()
		{
			
		}

		public static function get Instance():Log
		{
			if(!_instance) _instance=new Log();
			return _instance;
		}
		
		/** 进行错误收集
		 */		
		private function e(str:Object):void
		{
			Debug.error("#错误信息# "+String(str));
		}
		
		/**提示信息
		 */
		public function v(str:Object):void
		{
			if(Debug.isOn == true)
			{
				var str2:String;
				str2 = "#提示信息#"+String(str);
				Debug.warn(Debug.colors[2],str2);
			}
		}
		
		public function c(cmd:int,msg:Message):void
		{

//			if(Debug.isOn == true){
				if(msg)
				{
					Debug.log("**************客户端发送消息***************\nC=="+ cmd+" "+"NAME:"+getQualifiedClassName(msg)+"msg：："+msg.toString());
				}
				else 
				{
					Debug.log("**************客户端发送消息***************\nC=="+ cmd);

				}
//			}

		}
		
		public function s(cmd:int,bodyData:Message):void
		{
//			if(Debug.isOn == true){
				var str:String;
				str = "++++++++++++++服务端发送消息+++++++++++++++";
				Debug.log("S=="+ cmd+" "+"NAME:"+getQualifiedClassName(bodyData));
				
				if(bodyData)
				{
					try
					{
						str = "MESSAGE:"+"\r\n"+bodyData.toString();
						Debug.log("MESSAGE:"+bodyData.toString());

					}
					catch(e:Error)
					{
					}
				}
				else
				{
					str = "没有数据";
					Debug.log(str);
				}
//			}
		}

		public function get errorInfo():String
		{
			return "";
		}
		
		public function get verboseInfo():String
		{
			return "";
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