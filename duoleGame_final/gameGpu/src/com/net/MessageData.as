package com.net
{
	import com.netease.protobuf.Message;

	/**@author yefeng
	 * 2013 2013-10-29 上午9:13:04 
	 */
	public class MessageData
	{
		public var cmd:int;
		public var message:Object;
//		public var id:int; //用于 玩家离开视野 删除 时候 使用 ，其他 时候不需要用
		public var funcArr:Array;//响应的方法数组
		public function MessageData()
		{
		}
	}
}