package  net
{
	import avmplus.getQualifiedClassName;
	
	import com.dolo.arpg.debug.Debug;
	import com.netease.protobuf.Message;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	
	public class NetEngine extends EventDispatcher
	{
		private var _socket:Socket = null;
		private var _needLen:uint;
		private var _recvLen:uint;
		private var _cmd:int;
		private var _err:int;
		private const HEAD_LENGTH:uint = 12;
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
			if (mc != null && mc != msgClass)
			{
				throw new Error("命令" + cmd + "已注册消息" + mc);
				return;
			}
			_cmdMap[cmd] = msgClass;
			
			// 此命令的响应函数
			if (_funcMap[cmd] != null)
			{
				trace("移除了" + cmd + "消息之前的回调函数");
			}
			_funcMap[cmd] = func;
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
			var func:Function = _funcMap[cmd];
			if (func == null)
			{
				trace("未为消息" + cmd + "注册回调函数");
				return;
			}
			if (data == null)
			{
				func(null);
			}
			else
			{
				var msg:Message = new msgClass as Message;
				msg.mergeFrom(data);
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
			trace("Connection-ioErrorHandler");
			dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
		}		
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("Connection-securityErrorHandler");
			dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
		}
		
		private function closeHandler(evt:Event):void
		{
			trace("Connection-closeHandler");
			dispatchEvent(new NetEvent(NetEvent.ON_DISCONNECT));
		}
		
		private function connectHandler(evt:Event):void
		{
			trace("Connection-connectHandler");
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT));
		}
		
		//接收数据处理
		private function receiveHandler(evt:ProgressEvent):void
		{
			
		
			var slice_len:uint = _socket.bytesAvailable;
			
			while(true)
			{
				if(slice_len < 1)
				{
					break;
				}
				var read_len:uint = 0;
				// 还不够
				if (_recvLen + slice_len < _needLen)
				{
					read_len = slice_len;
				}
					// 已搞完
				else
				{
					read_len = _needLen - _recvLen;
				}
				_socket.readBytes(_recvData, _recvLen, read_len);
				_recvLen += read_len;
				slice_len -= read_len;
				
				if (_recvLen == _needLen)
				{
					// 包头读取完毕
					if (_recvHead)
					{
						_cmd = _recvData.readInt();
						_needLen = _recvData.readInt();
						_err = _recvData.readInt();
						// 准备下一次读取
						_recvData.clear();
						_recvLen = 0;
						_recvHead = false;
						// 空消息体
						if (_needLen == 0)
						{
							// 错误码
							if (_err != 0)
							{
								dispatchEvent(new NetEvent(NetEvent.ON_ERROR_CODE, _err));
							}
							else
							{
								callBack(_cmd, null);
							}
							_needLen = HEAD_LENGTH;
							_recvHead = true;
						}
					}
						// 消息主体读取完毕
					else
					{
						_needLen = HEAD_LENGTH;
						_recvLen = 0;
						_recvHead = true;
						
						// 错误码
						if (_err != 0)
						{
							dispatchEvent(new NetEvent(NetEvent.ON_ERROR_CODE, _err));
						}
						else
						{
							_recvData.position = 0;
							callBack(_cmd, _recvData);
						}
						// 准备下一次读取
						_recvData.clear();
					}
				}
			}
		}
		
		//发送数据
		public function sendMessage(cmd:int, msg:Message):void
		{	
//			if (!(msg is _cmdMap[cmd]))
//			{
//				throw new Error("命令" + cmd + "与消息" + _cmdMap[cmd] + "不对应");
//				return;
//			}
			// flag
			_socket.writeUnsignedInt(0xccccaaaa);
			// cmd
			_socket.writeInt(cmd);
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
				_socket.writeBytes(_sendData);
			}
			_socket.flush();
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
