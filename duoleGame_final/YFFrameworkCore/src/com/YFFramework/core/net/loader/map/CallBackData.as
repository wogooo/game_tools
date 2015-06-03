package com.YFFramework.core.net.loader.map
{
	import flash.utils.ByteArray;

	/**@author yefeng
	 * 2013 2013-11-20 下午5:55:16 
	 */
	public class CallBackData
	{
		
		private static var _pool:Vector.<CallBackData>=new Vector.<CallBackData>();
		private static var _size:int=0;
		public var func:Function;
		public var data:Object;
		public var bytes:ByteArray;

		public function CallBackData()
		{
		}
		public static function getCallBackData():CallBackData
		{
			if(_size==0)
			{
				return new CallBackData();
			}
			else
			{
				_size--;
				return _pool.pop();
			}
		}
		public static function toCallBackDataPool(callBackData:CallBackData):void
		{
			callBackData.func=null;
			callBackData.data=null; 
			callBackData.bytes=null
			_pool.push(callBackData);
		}

	}
}