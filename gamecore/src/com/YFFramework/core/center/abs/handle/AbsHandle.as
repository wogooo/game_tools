package com.YFFramework.core.center.abs.handle
{
	import com.YFFramework.core.center.face.IHandle;
	import com.YFFramework.core.center.manager.HandleManager;
	
	import flash.utils.ByteArray;

	/**
	 * author :夜枫 * 时间 ：2011-9-28 上午09:04:39
	 * 
	 * 处理socket消息的类  子类需要继承重写   CMD 需要从100开始    0---99的被框架系统占用
	 */
	public class AbsHandle implements IHandle
	{
		/** 消息范围
		 */		
		protected var _maxCMD:int=1000;
		protected var _minCMD:int=0;
		public function AbsHandle()
		{
			HandleManager.Instance.regHandle(this);
		}
		
		/**
		 * 子类重写覆盖 data 是 Message 的Object类型变量 
		 * 
		 */
		public function socketHandle(data:Object):Boolean
		{
			return false 	
		}
		
		public function get maxCMD():int
		{
			return _maxCMD;
		}
		public function get minCMD():int
		{
			return _minCMD;
		}
	}
}