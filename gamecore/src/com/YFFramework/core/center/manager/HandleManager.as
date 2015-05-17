package com.YFFramework.core.center.manager
{
	import com.YFFramework.core.center.face.IHandle;
	import com.YFFramework.core.utils.common.ArrayUtil;

	/**
	 * author :夜枫 * 时间 ：2011-9-28 上午09:05:48
	 */
	public final class HandleManager
	{
		public static var _instance:HandleManager;
		private var list:Array=[];
		public function HandleManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
		}
		public static function get Instance():HandleManager
		{
			if(!_instance) _instance=new HandleManager();
				return _instance;
		}
		
		/** 注册handle模块
		 */
		public function regHandle(handle:IHandle):void
		{
			ArrayUtil.addElement(list,handle);
		}
		/**卸载handle 
		 */		
		public function delHandle(handle:IHandle):void
		{
			ArrayUtil.removeElement(list,handle);
		}
		/** cmd 是通讯指令
		 */		
		public function  initData( data:Object):void
		{
			var len:int=list.length;
			var cmd:int=data.cmd;
			for each (var handle:IHandle in list )
			{
				if((cmd<=handle.maxCMD)&&(cmd>=handle.minCMD))
				{
					if(handle.socketHandle(data)) return;
					else throw new Error("发生丢包，包为cmd="+cmd);
				}
				
			}
			
		}
	}
}