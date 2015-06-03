package com.net
{
	

	/**@author yefeng
	 * 2013 2013-10-29 上午9:12:55 
	 */
	public class MessageArray
	{
		/**
		 */
		private static const MaxSize:int=50; 
		private var _messageArr:Vector.<MessageData>
		private var _messageSize:int;
		private var _pool:Vector.<MessageData>;
		private var _poolSize:int
		public function MessageArray()
		{
			_messageArr=new Vector.<MessageData>();
			_pool=new Vector.<MessageData>();
			_messageSize=0;
			_poolSize=0;
		}
		/**
		 * @param cmd
		 * @param msg  为message类型 或者   int 类型
		 * funcArr响应函数
		 */
		public function addMSG(cmd:int,msg:Object,funcArr:Array):void
		{
			var messageData:MessageData;
			if(_poolSize>0)
			{
				messageData=_pool.pop();
				_poolSize--;
			}
			else 
			{
				messageData=new MessageData();
			}
			messageData.cmd=cmd;
			messageData.message=msg;
			messageData.funcArr=funcArr;
			_messageArr.unshift(messageData);
			_messageSize++;
		}
		/**获取消息 大小
		 */
		public function getMessageSize():int
		{
			return _messageSize;
		}
		public function popMSG():MessageData
		{
			if(_messageSize>0)
			{
				_messageSize--;
				return _messageArr.pop();
			}
			return null;
		}
		
		public function toPool(msg:MessageData):void
		{
			if(_poolSize<MaxSize)
			{
				_pool.push(msg);
				_poolSize++;
			}
			else
			{
				msg=null;
			}
		}
			
	}
}