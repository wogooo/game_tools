package com.YFFramework.core.center.face
{
	

	/**
	 * author :夜枫 * 时间 ：2011-9-28 上午09:08:42
	 */
	public interface IHandle
	{
		/** 处理socket事件
		 */		
		function socketHandle( data:Object):Boolean;
		
		/**  最大指令值
		 */		
		function get maxCMD():int;
		/** 最小指令值
		 */		
		function get minCMD():int;
	}
}