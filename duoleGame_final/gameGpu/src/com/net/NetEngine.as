package  com.net
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.game.debug.Log;
	import com.msg.mapScene.OtherRoleInfo;
	import com.msg.mapScene.SOtherRoleInfo;
	import com.msg.mapScene.SOtherRoleListExitView;
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/** 帧驱动的  socket 事件收发  内置  消息队列机制
	 */	
	public class NetEngine extends YFDispather
	{
		/**心跳频率
		 */
		public static const HeartBeat:int=1000*60;// 1 分钟发一次
		/**最大缓冲长度
		 */		
		private static const MaxBuffLen:int=1024*30; //64 kb 
		private var _socket:Socket = null;
		private var _needLen:uint;
		private var _recvLen:uint;
		private var _cmd:int;
		private var _err:int;
		private const HEAD_LENGTH:uint = 8;
		
		/**这个包的个数  
		 */
		private const MaxLen:int=15*70;
		
		private var _recvData:ByteArray;		
		private var _sendData:ByteArray;
		private var _recvHead:Boolean;
		private var _msgMap:Dictionary = new Dictionary();
		private var _cmdMap:Dictionary = new Dictionary();
		private var _funcMap:Dictionary = new Dictionary();
		
		/**心跳
		 */
		private var _hearBeat:Timer;
		
		/**心跳包cmd 
		 */
		private var _heatBeatCMD:int;
		
		
		/**消息队列
		 */
		private var _messageArr:MessageArray;
		
		/**好点间距
		 */
		private var _intervalTime:int=2;
		/**包的个数
		 */
//		private var _packgeSize:int=50;
		
		/**阻止  动画渲染  
		 */
		private static const PreventMovieRenderTime:int=5;
		private static const PreventMovieRenderTime2:int=11;
		
//		private var _reveIndex:int=0;
	
//		private var _reRenderTime:int=3;
//		private static const ReveRenderTime:int=20;
//		 
//		private static const ReveRenderTime2:int=30;

//		private var _preRenderTime:Number=0;
		private static const ReveRenderTime3:int=40;

		public function NetEngine(heatbeatCMD:int) : void
		{
			_heatBeatCMD=heatbeatCMD;
			_recvData = new ByteArray();
			_recvData.endian = Endian.LITTLE_ENDIAN;
			_sendData = new ByteArray();
			_sendData.endian = Endian.LITTLE_ENDIAN;
			
			_needLen = HEAD_LENGTH;
			_recvHead = true;
			
			initTimer();
			_messageArr=new MessageArray();
		}
		private function initTimer():void
		{
			_hearBeat=new Timer(HeartBeat); 
			_hearBeat.addEventListener(TimerEvent.TIMER,onHearBeat);
		}
		private function onHearBeat(e:TimerEvent):void
		{
			sendMessage(_heatBeatCMD,null); 
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
			if ( mc != null&&mc != msgClass)
			{
				throw new Error("命令:" + cmd + "注册了两条不同的消息，请检查该命令号:" + cmd);
				return;
			}
			_cmdMap[cmd] = msgClass;
			// 此命令的响应函数
			if(_funcMap[cmd]==null) _funcMap[cmd]=[];
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
		
//		private function callBack(cmd:int, data:ByteArray):void
//		{
//			var msgClass:Class = _cmdMap[cmd] as Class;
//			if (msgClass == null)
//			{
//				trace("未为命令" + cmd + "注册消息");
//				return;
//			}
//			var funcArr:Array = _funcMap[cmd];
//			if (funcArr == null)
//			{
//				trace("未为消息" + cmd + "注册回调函数");
//				return;
//			}
//			if (data == null)
//			{
//				triggerFunc(null,funcArr);
//			}
//			else if (data.length==0)
//			{
//				triggerFunc(null,funcArr);
//			}
//
//			else
//			{
//				var msg:Message = new msgClass as Message;
//				msg.mergeFrom(data);
//				triggerFunc(msg,funcArr);
//			}
//		}
		

		
		public function connect(server:String, port:int,checkPort:int) : void
		{
			var profile:String="xmlsocket://"+server+":"+checkPort;
			Security.loadPolicyFile(profile);
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
			dispatchEventWith(NetEvent.ON_DISCONNECT);
		}		
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			print(this,"Connection-securityErrorHandler");
			dispatchEventWith(NetEvent.ON_DISCONNECT);

		}
		
		private function closeHandler(evt:Event):void
		{
			print(this,"Connection-closeHandler");
			dispatchEventWith(NetEvent.ON_DISCONNECT);

		}
		
		private function connectHandler(evt:Event):void
		{
			trace("Connection-connectHandler");
			dispatchEventWith(NetEvent.ON_CONNECT);
			
			_hearBeat.start();  ///启动 心跳
		}
	
		
		
		
		
		private function receiveHandler(evt:ProgressEvent=null):void
		{
			_socket.readBytes(_recvData,_recvData.length,_socket.bytesAvailable);
			
		}
		
		
		

		/**检验包 packageLen指的是包长
		 */		
		private function  checkPackage():void
		{
			///缓冲区大于包头长度
			if(_recvData.bytesAvailable>=HEAD_LENGTH)
			{
				var cmd:int=_recvData.readInt();
				var bodyLen:int=_recvData.readInt();	//			读取16位整数							-------------------------------bodyLen读取 包体长度读取
				//进行组包
				if(_recvData.bytesAvailable>=bodyLen)
				{
					var bodyTmp:ByteArray=null;
					if(bodyLen!=0)
					{
						bodyTmp=new ByteArray();
						bodyTmp.endian=Endian.LITTLE_ENDIAN;
						_recvData.readBytes(bodyTmp,0,bodyLen);
					}
					revBodyPackage(cmd,bodyTmp);
					checkPackage();
//					return true;
				}
				else
				{
					_recvData.position=_recvData.position-HEAD_LENGTH; ////继续填充缓冲区等待下一次组包
				}
				handleCleanBuff();
			}
//			return false;
		}
		
		
		private var _preT:Number=0;
		/**  处理服务端发过来的body部分  包的body 部分
		 */		
		protected function revBodyPackage(cmd:int,bodyData:ByteArray):void
		{
			var msgClass:Class = _cmdMap[cmd] as Class;
			Log.Instance.v("有消息过来:S=="+cmd);
			if (msgClass == null)
			{
//				print(this,"未为命令" + cmd + "注册消息");
				Log.Instance.v("S=="+cmd+"没有进行注册消息");
				return;
			}
			var funcArr:Array = _funcMap[cmd];
			if (funcArr == null)
			{
//				print(this,"未为消息" + cmd + "注册回调函数");
				Log.Instance.v("S=="+cmd+"没有进行注册函数");
				return;
			}
			if (bodyData == null)
			{
//		//	//	triggerFunc(null,funcArr);
				
				_messageArr.addMSG(cmd,null,funcArr);

				Log.Instance.s(cmd,null);//日志命令
			}
			else if (bodyData.length==0)
			{
//			////	triggerFunc(null,funcArr);
				
				_messageArr.addMSG(cmd,null,funcArr);

				Log.Instance.s(cmd,null);//日志命令
			}
				
			else
			{
				var msg:Message = new msgClass as Message;
				msg.mergeFrom(bodyData);
				Log.Instance.s(cmd,msg);//日志命令
				
				
				///添加消息
				switch(cmd)
				{
					case GameCmd.SOtherRoleInfo: ///离开 视野的 包  此包 需要拆开
						for each(var otherRoleInfo:OtherRoleInfo in SOtherRoleInfo(msg).otherRoles)
						{
							_messageArr.addMSG(GameCmd.SOtherRoleListExitView,otherRoleInfo,funcArr); ///将 此包 拆开
						}
						break;
					case GameCmd.SOtherRoleListExitView: //其他玩家；列表 此包 需要拆开 
						for each(var id:int in SOtherRoleListExitView(msg).dyIdArr)
						{
							_messageArr.addMSG(GameCmd.SOtherRoleListExitView,id,funcArr); ///将 此包 拆开
						}
						break;
					default:
						_messageArr.addMSG(cmd,msg,funcArr);
						break;
				}
			}
		}
		 
		/**上一次的message时间
		 */
		private var _messageTime:Number=0;
		private var t:Number=0;

		/**是否可以接受剩余socket数据 
		 */
//		private var canReve:Boolean=false;
//		
//		/**是否检查buff池
//		 */
//		private var canCheckBuff:Boolean=false;
		/**每帧都处理消息队列
		 */		
		public function handleMessage():void
		{
			_messageTime=getTimer();
			checkPackage();  //放在帧事件里
			var msgData:MessageData; 
			if(_messageArr.getMessageSize()<50)
			{
				_intervalTime=2;
			}
			else if(_messageArr.getMessageSize()<100)
			{
				_intervalTime=3;
			}
			else if(_messageArr.getMessageSize()<150)
			{
				_intervalTime=4;
			}
			else if(_messageArr.getMessageSize()<200)
			{
				_intervalTime=5;
			}
			else if(_messageArr.getMessageSize()<250)
			{
				_intervalTime=6;
			}
			else if(_messageArr.getMessageSize()<300)
			{
				_intervalTime=7;
			}
			else if(_messageArr.getMessageSize()<350)
			{
				_intervalTime=8;
			}
			else if(_messageArr.getMessageSize()<400)
			{
				_intervalTime=9;
			}
			else if(_messageArr.getMessageSize()<450)
			{
				_intervalTime=10;
			}
			else if(_messageArr.getMessageSize()<500)
			{
				_intervalTime=11;
			}
			else if(_messageArr.getMessageSize()<550)
			{
				_intervalTime=12;
			}
			else if(_messageArr.getMessageSize()<600)
			{
				_intervalTime=13;
			}
			else if(_messageArr.getMessageSize()<650)
			{
				_intervalTime=14;
			}
			else if(_messageArr.getMessageSize()<700)
			{
				_intervalTime=15;
			}
			else if(_messageArr.getMessageSize()<750)
			{
				_intervalTime=16;
			}
			else if(_messageArr.getMessageSize()<800)
			{
				_intervalTime=17;
			}
			else _intervalTime=20;

			while(_messageArr.getMessageSize()>0)
			{
				msgData=_messageArr.popMSG();
				triggerFunc(msgData.message,msgData.funcArr);
				_messageArr.toPool(msgData);
				
				t=getTimer()-_messageTime;
				if(t>=_intervalTime) 
				{
//					Log.Instance.s(1000000+_intervalTime,null);
				return ;
				}
			}
			
//			if(_messageArr.getMessageSize()<50)
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					if(t>=2) return ;
//				}
//			}
//			else if(_messageArr.getMessageSize()<100)
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(7777777,null);
//
//					if(t>=4) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<200))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(888888,null);
//					if(t>=6) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<300))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(999999,null);
//					if(t>=8) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<400))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(999901,null);
//					if(t>=10) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<500))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(999902,null);
//					if(t>=12) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<600))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(900003,null);
//					if(t>=14) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<700))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(900004,null);
//					if(t>=16) return ;
//				}
//			}
//			else if((_messageArr.getMessageSize()<800))
//			{
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//					
//					t=getTimer()-_messageTime;
//					Log.Instance.s(900005,null);
//					if(t>=18) return ;
//				}
//			}
//
//			else   //全部都执行
//			{
//				trace("消息队列过长，清空消息");
//				Log.Instance.s(9900019,null);
//				//全部执行
//				while(_messageArr.getMessageSize()>0)
//				{
//					msgData=_messageArr.popMSG();
//					triggerFunc(msgData.message,msgData.funcArr);
//					_messageArr.toPool(msgData);
//				}
//			}
		}
		/**当数据 太大时候  清空池buff
		 */
		private function handleCleanBuff():void
		{	
			/// 不需要用的缓冲区 达到 MaxBuffLen个包时  自动释放前面的包  进行内存释放
			if(_recvData.position>=MaxBuffLen)
			{
				var byteArray:ByteArray=new ByteArray();
				byteArray.endian=Endian.LITTLE_ENDIAN;
				_recvData.readBytes(byteArray,0,_recvData.bytesAvailable);
				_recvData.clear();
				_recvData=byteArray;
				_recvData.position=0;
			}
		}
		
		
		
		
		
		private function triggerFunc(msg:Object,funcArr:Array):void
		{
			
			for each(var func:Function in funcArr)
			{
				func(msg);
			}
		}
	
		
		//发送数据
		public function sendMessage(cmd:int, msg:Message):void
		{	
			if(_socket.connected)
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
		}
		
		public function close() : void
		{
			if (_socket && _socket.connected)
			{
				_socket.close();
			}
		}
		
		/**发送 字节
		 */
		public function sendBytes(bytes:ByteArray):void
		{
			if(_socket.connected)
			{
				_socket.writeBytes(bytes,0,bytes.length);
				_socket.flush();
//				Log.Instance.c(999999,null);//日志命令
			}
		}
		
	}
}
