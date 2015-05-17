package  com.net
{
	import com.YFFramework.core.debug.Log;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFDispather;
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class NetEngine extends YFDispather
	{
		/**最大缓冲长度
		 */		
		private static const MaxBuffLen:int=1000*1024*100;
		private var _socket:Socket = null;
		private var _needLen:uint;
		private var _recvLen:uint;
		private var _cmd:int;
		private var _err:int;
		private const HEAD_LENGTH:uint = 8;
		private var _recvData:ByteArray;		
		private var _sendData:ByteArray;
		private var _recvHead:Boolean;
		private var _msgMap:Dictionary = new Dictionary;
		private var _cmdMap:Dictionary = new Dictionary;
		private var _funcMap:Dictionary = new Dictionary;
		
		public function NetEngine() : void
		{
			
			_recvData = new ByteArray();
			_recvData.endian = Endian.LITTLE_ENDIAN;
			_sendData = new ByteArray();
			_sendData.endian = Endian.LITTLE_ENDIAN;
			
			_needLen = HEAD_LENGTH;
			_recvHead = true;
		}
		
		/**
		 * 添加对某消息的回调函数
		 * @param msgClass 消息类名
		 * @param func 回调函数
		 * 
		 */
		public function addCallback(cmd:int, msgClass:Class, func:Function):void
		{
			var mc:Class = _cmdMap[cmd] as Class;
//			if (mc != null && mc != msgClass)
			if ( mc != null&&mc != msgClass)
			{
				throw new Error("命令:" + cmd + "注册了两条不同的消息，请检查该命令号:" + cmd);
				return;
			}
			_cmdMap[cmd] = msgClass;
			// 此命令的响应函数
			if(_funcMap[cmd]==null) _funcMap[cmd]=[];
			else  //if (_funcMap[cmd] != null)
			{
//				trace("移除了" + cmd + "消息之前的回调函数");
				print(this,"消息 cmd=="+cmd+"已经侦听了"+_funcMap[cmd].length+"次");
			}
//			_funcMap[cmd] = func;
			_funcMap[cmd].push(func);
		}
		
		/**
		 *移除回调方法 
		 * @param cmd 回调类型
		 * @param func 回调方法
		 * 
		 */		
		public function removeCallback(cmd:int, msgClass:Class):void
		{
			if (_cmdMap[cmd] == null)
			{
				trace("命令" + cmd + "没有注册");
			}
			_funcMap[cmd]=null;
			delete _cmdMap[cmd];
			delete _funcMap[cmd];
		}
		
		private function callBack(cmd:int, data:ByteArray):void
		{
			var msgClass:Class = _cmdMap[cmd] as Class;
			if (msgClass == null)
			{
				trace("未为命令" + cmd + "注册消息");
				return;
			}
//			var func:Function = _funcMap[cmd];
			var funcArr:Array = _funcMap[cmd];
//			if (func == null)
			if (funcArr == null)
			{
				trace("未为消息" + cmd + "注册回调函数");
				return;
			}
			if (data == null)
			{
//				func(null);
				triggerFunc(null,funcArr);
			}
			else if (data.length==0)
			{
//				func(null);
				triggerFunc(null,funcArr);
			}

			else
			{
				var msg:Message = new msgClass as Message;
				msg.mergeFrom(data);
//				func(msg);
				triggerFunc(msg,funcArr);
			}
		}
		
		private function triggerFunc(msg:Message,funcArr:Array):void
		{
			for each(var func:Function in funcArr)
			{
				func(msg);
			}
		}
		
		public function connect(server:String, port:int) : void
		{
			_socket = new Socket();
			_socket.endian = Endian.LITTLE_ENDIAN;
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(Event.CONNECT,connectHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, receiveHandler);
			// 连接
			_socket.connect(server,port);
			return;
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			print(this,"Connection-ioErrorHandler");
		//	dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
			dispatchEventWith(NetEvent.ON_DISCONNECT);
		}		
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			print(this,"Connection-securityErrorHandler");
		//	dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
			
			dispatchEventWith(NetEvent.ON_DISCONNECT);

		}
		
		private function closeHandler(evt:Event):void
		{
			print(this,"Connection-closeHandler");
		//	dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
			
			dispatchEventWith(NetEvent.ON_DISCONNECT);

		}
		
		private function connectHandler(evt:Event):void
		{
			trace("Connection-connectHandler");
		//	dispatchEvent(new NetEvent(NetEvent.ON_CONNECT));
			dispatchEventWith(NetEvent.ON_CONNECT);

		}
	
		
		
		
		
		private function receiveHandler(evt:ProgressEvent=null):void
		{
//			if(_socket.bytesAvailable>=HEAD_LENGTH)
//			{
				_socket.readBytes(_recvData,_recvData.length,_socket.bytesAvailable);
				checkPackage();
//			}
		}
		
		
		
		/**检验包 packageLen指的是包长
		 */		
		private function  checkPackage():void
		{
			///缓冲区大于包头长度
			if(_recvData.bytesAvailable>=HEAD_LENGTH)
			{
				var cmd:int=_recvData.readInt();
//				var cmd:int=_recvData.readShort();
				var bodyLen:int=_recvData.readInt();	//			读取16位整数							-------------------------------bodyLen读取 包体长度读取
//				var errorCode:int=_recvData.readInt();
				//进行组包
//				print(this,"bodyLen:",bodyLen);
				if(_recvData.bytesAvailable>=bodyLen)
				{
					var bodyTmp:ByteArray=null;
					if(bodyLen!=0)
					{
						bodyTmp=new ByteArray();
						bodyTmp.endian=Endian.LITTLE_ENDIAN;
//						print(this,"len:",bodyTmp.length);
//						bodyTmp.clear();
						_recvData.readBytes(bodyTmp,0,bodyLen);
					}
					revBodyPackage(cmd,bodyTmp);
					checkPackage();
				}
				else
				{
					_recvData.position=_recvData.position-HEAD_LENGTH; ////继续填充缓冲区等待下一次组包
					print(this,"等待下一次组包");
				}
			}
			/// 不需要用的缓冲区 达到 MaxBuffLen个包时  自动释放前面的包  进行内存释放
			if(_recvData.position>=MaxBuffLen)
			{
				var byteArray:ByteArray=new ByteArray();
				byteArray.endian=Endian.LITTLE_ENDIAN;
				_recvData.readBytes(byteArray,0,_recvData.bytesAvailable);
				_recvData.clear();
				_recvData=byteArray;
				_recvData.position=0;
//							print(this,"------------socket hero____initAgain");
			}
		}
		
		
		/**  处理服务端发过来的body部分  包的body 部分
		 */		
		protected function revBodyPackage(cmd:int,bodyData:ByteArray):void
		{
			
			var msgClass:Class = _cmdMap[cmd] as Class;
			if (msgClass == null)
			{
				trace("未为命令" + cmd + "注册消息");
				return;
			}
			//			var func:Function = _funcMap[cmd];
			var funcArr:Array = _funcMap[cmd];
			//			if (func == null)
			if (funcArr == null)
			{
				trace("未为消息" + cmd + "注册回调函数");
				return;
			}
			if (bodyData == null)
			{
				//				func(null);
				triggerFunc(null,funcArr);
				Log.Instance.s(cmd,null);//日志命令
			}
			else if (bodyData.length==0)
			{
				//				func(null);
				triggerFunc(null,funcArr);
				Log.Instance.s(cmd,null);//日志命令
			}
				
			else
			{
				var msg:Message = new msgClass as Message;
				msg.mergeFrom(bodyData);
				//				func(msg);
				triggerFunc(msg,funcArr);
				Log.Instance.s(cmd,msg);//日志命令
			}
			
		}
		
		
//		private function callBack(cmd:int, data:ByteArray):void
//		{
//			var msgClass:Class = _cmdMap[cmd] as Class;
//			if (msgClass == null)
//			{
//				trace("未为命令" + cmd + "注册消息");
//				return;
//			}
//			//			var func:Function = _funcMap[cmd];
//			var funcArr:Array = _funcMap[cmd];
//			//			if (func == null)
//			if (funcArr == null)
//			{
//				trace("未为消息" + cmd + "注册回调函数");
//				return;
//			}
//			if (data == null)
//			{
//				//				func(null);
//				triggerFunc(null,funcArr);
//			}
//			else if (data.length==0)
//			{
//				//				func(null);
//				triggerFunc(null,funcArr);
//			}
//				
//			else
//			{
//				var msg:Message = new msgClass as Message;
//				msg.mergeFrom(data);
//				//				func(msg);
//				triggerFunc(msg,funcArr);
//			}
//		}
		
		//发送数据
		public function sendMessage(cmd:int, msg:Message):void
		{	
			// flag
//			_socket.writeUnsignedInt(0xccccaaaa);
			// cmd
			_socket.writeInt(cmd);
//			_socket.writeShort(cmd);
			// 空消息
			if (msg == null)
			{
				_socket.writeInt(0);
			}
			else
			{
				// len
				_sendData.clear();
				msg.writeTo(_sendData);
				_socket.writeInt(_sendData.length);
				if (_sendData.length > 0)
				{
					_socket.writeBytes(_sendData);
				}
			}
			_socket.flush();
			
			Log.Instance.c(cmd,msg);//日志命令

		}
		
		public function close() : void
		{
			if (_socket && _socket.connected)
			{
				_socket.close();
			}
		}
	}
}
