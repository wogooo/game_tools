package com.YFFramework.core.net.socket.absSocket
{
	////包
	///// 	+ header    int 
	/////	+ BodyDataLen   short
	////	+ Body 
	////		+ type   byte 
	////		+ cmd    int 
	////		+ data   ByteArray
	/**
	 * author :夜枫 * 时间 ：2011-9-27 下午08:30:13
	 *  socket 常量
	 */
	public dynamic class SocketConst
	{
		/**
		 *心跳指令      CMD 0--90被框架系统占用  外部处理handle 的CMD需要从100开始 
		 */		
		public static const HeatBeatCMD:int=20;///心跳包命令
		
		
		
		/** 心跳类型
		 */
		public static const TypeHeartBeat:int=0;
		/**  相互通讯类型
		 */
		public static const TypeCommunicate:int=1;
		/** 心跳频率
		 */
	///	public static const HeatBeatRate:uint=1000;   /// 1000ms==  1s 
		
		
		/**包类型长度  1 个字节 byte 
		 */
		public static const TypeLength:uint=4;
		/** 包头长度   包头放的是包体长度信息	readUnsignedInt  无符号32位
		 */
		public static const HeadLength:uint=2;
//		public static const  HeadData:int=400000000; ///  int  32位  表示分隔符号
		
		public static const CMDLength:uint=4;
		
	///	public static const BodyLength:uint=TypeLength+CMDLength+DataLength; ///有信息 表示包的长度  == Type+ CMD  +  Data  ==10

		public static const BodyDataLen:int=4; ///包体长度 也就是 Body部分的长度  short 类型  2个字节  readShort   writeShort 
		
		private static const PakcageNum:int=6000;
		
//		public static const MinBodyLen:int=TypeLength+CMDLength;
		/**
		最小包长
		 */
		public static const MinPackageLen:int=HeadLength+BodyDataLen+TypeLength+CMDLength; /////4+ 2+1+4
		
		/**最大数据长度
		 */		
		private static const MaxDataBodyLen:int=4096*10;
		/**  最大包长
		 */		
		public static const MaxPackageLen:int=MinPackageLen+MaxDataBodyLen;
		
		/** 缓冲区长度  当当前的postion >缓冲区的长度时 则 将 Position以前的全部释放掉  也就是重新new 个新的
		 */		
		public static const BuffLen:int=MaxPackageLen*PakcageNum;
		public function SocketConst()
		{
			
		}
	}
}