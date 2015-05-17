package com.YFFramework.core.net.socket.absSocket
{
	import com.YFFramework.core.center.manager.HandleManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.Message;
	import com.YFFramework.core.net.socket.events.SocketEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	////包
	///// 	+ header    int 
	/////	+ BodyDataLen   short
	////	+ Body 
	////		+ type   byte 
	////		+ cmd    int 
	////		+ data   ByteArray
	/**
	 * author :夜枫 * 时间 ：2011-9-27 下午10:43:17
	 */
	public class SocketClient extends Socket
	{
		private var _host:String;
		private var _port:int;
		private var _timer:Timer;
		private const times:int=5;//重连次数只有当发生服务器断线时才进行重连
		private const interval:int=5*1000;   ///等待时间
		private var _isFire:Boolean=false;//是否已经触犯
		private var _buff:ByteArray=new ByteArray();

		/**发送  amf 字节
		 */ 
		private var _sendAmfBytes:ByteArray=new ByteArray();

		public function SocketClient(host:String = null, port:int = 0,checkPort:int=843)
		{
			super();
			this._host=host;
			this._port=port;
			addEvent();
			///自定义策略文件 返回 
			Security.loadPolicyFile("xmlsocket://"+host+":"+checkPort);
			//连接 
			connect(host,port);
			print(this,"连接"+host+":"+port);
		}
		protected function addEvent():void
		{
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		protected function closeHandler(e:Event):void
		{
			trace("SocketClient::服务器断线");
	//		if(!timer&&!isFire) initTimer();
			YFEventCenter.Instance.dispatchEventWith(SocketEvent.Close);
		}
		protected function connectHandler(e:Event):void
		{
			trace("SocketClient::socket连接成功...");
			YFEventCenter.Instance.dispatchEventWith(SocketEvent.Connnect);
		}
		protected function ioErrorHandler(e:IOErrorEvent):void
		{
			trace("SocketClient::无效socket,服务器没开");
			YFEventCenter.Instance.dispatchEventWith(SocketEvent.IOError);
		}
		protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
			trace("SocketClient::安全沙箱错误,请检测服务端是否打开");
			YFEventCenter.Instance.dispatchEventWith(SocketEvent.SecurityError);
		} 
		/**  发送数据    这里增加了消息类型 type 
		 */		
		public function sendData(data:Message):void
		{
			var obj:Object={};
			var bytes:ByteArray=new ByteArray();
			bytes.writeObject(data);
			bytes.position=0;
			obj=bytes.readObject();
			obj.type=SocketConst.TypeCommunicate;///添加  类型 type 
			sendPackage(obj);
			
		}
		
		private function sendPackage(amfData:Object):void
		{
			_sendAmfBytes.clear();
			_sendAmfBytes.writeObject(amfData);
			
			///进行 zlib压缩
			_sendAmfBytes.compress();
			var headLen:int=_sendAmfBytes.length;
			writeShort(headLen);
			writeBytes(_sendAmfBytes);
			flush();
		}
		
		
		/**  处理服务端发过来的body部分  包的body 部分
		 */		
		protected function revBodyPackage(bodyData:ByteArray):void
		{
			////bodyData为包的body部分
			///包的类型  1个字节
//			var type:int=bodyData.readByte();
//			var cmd:int=bodyData.readInt();
//			var data:ByteArray=new ByteArray();
//			bodyData.readBytes(data,data.position,bodyData.bytesAvailable);
//			///解压
//			data.uncompress();   ///只对要发送的信息数据进行压缩 其他部分不进行压缩  服务端一样-------------------------------------------------------------
//			
//			switch(type)
//			{		///心跳包
//				case SocketConst.TypeHeartBeat:
//					///返回一个包给服务端
//					sendPackage(SocketConst.TypeHeartBeat,SocketConst.HeatBeatCMD,new ByteArray())
//					break;
//				///通讯包
//				case SocketConst.TypeCommunicate:
//					HandleManager.Instance.initData(cmd,data);
//					break;
//			}
			
			////进行zlib解压 
			bodyData.uncompress();
			var obj:Object=bodyData.readObject();
			////进行handler 处理
			switch(obj.type)
			{		///心跳包
				case SocketConst.TypeHeartBeat:
					///返回一个包给服务端
					var msg:Object={type:SocketConst.TypeHeartBeat}
					sendPackage(msg);
					break;
				///通讯包
				case SocketConst.TypeCommunicate:
					delete obj.type;
					HandleManager.Instance.initData(obj);
					break;
			}
			
		}
		
		protected function socketDataHandler(e:ProgressEvent):void
		{
			////数据长度大于等于包头长则开始将数据读入缓冲区
			if(bytesAvailable>=SocketConst.HeadLength)
			{
				this.readBytes(_buff,_buff.length,bytesAvailable);
				checkPackage();
			}
		}
		/**检验包 packageLen指的是包长
		 */		
		private function  checkPackage():void
		{
			///缓冲区大于包头长度
			if(_buff.bytesAvailable>=SocketConst.MinPackageLen)
			{
		//		var headData:int=buff.readInt();///读取32位整数						 --------------------------- header读取部分
				var bodyLen:int=_buff.readShort();	//			读取16位整数							-------------------------------bodyLen读取 包体长度读取
				//进行组包
				if(_buff.bytesAvailable>=bodyLen)
				{
					var bodyTmp:ByteArray=new ByteArray();
					_buff.readBytes(bodyTmp,0,bodyLen);
					revBodyPackage(bodyTmp); ///发送包body部分数据到接收函数处理
					checkPackage();///递归回调
				}
				else
				{
				//	_buff.position=_buff.position-SocketConst.HeadLength-SocketConst.BodyDataLen; ////继续填充缓冲区等待下一次组包
					_buff.position=_buff.position-SocketConst.HeadLength; ////继续填充缓冲区等待下一次组包
					print(this,"等待下一次组包");
				}
			}
			/// 不需要用的缓冲区 达到  500个包时  自动释放前面的包  进行内存释放
			if(_buff.position>=SocketConst.BuffLen)
			{
				var byteArray:ByteArray=new ByteArray();
				_buff.readBytes(byteArray,0,_buff.bytesAvailable);
			//	_buff.clear();
				_buff=byteArray;
				_buff.position=0;
				print(this,"------------socket hero____initAgain");
			}
		}
		private function initTimer():void
		{
			_isFire=true;
			_timer=new Timer(interval,times);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimer);
			_timer.start();
		}
		public function  onTimer(e:TimerEvent):void
		{
			switch(e.type)
			{
				case TimerEvent.TIMER:
					if(!connected) connect(_host,_port);
					else removeTimer();
					
					break;
				case TimerEvent.TIMER_COMPLETE:
					removeTimer();
					break;
			}
		}
		private function removeTimer():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimer);
			_timer=null;
		}
	}
}
