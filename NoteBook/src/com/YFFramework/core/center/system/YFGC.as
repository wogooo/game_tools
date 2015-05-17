package com.YFFramework.core.center.system
{
	import flash.net.LocalConnection;
	
	/**
	 * 
	 * 垃圾清理工具类
	 * 
	 * */
	public class YFGC
	{
		public function YFGC()
		{
		}
		
		/**
		 * 强制执行垃圾清理
		 * */
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
			}
			catch(e:Error)
			{
				
			}
		}

	}
}