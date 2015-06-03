package com.dolo.common
{
	import flash.net.LocalConnection;

	/**
	 * 系统和程序工具 
	 * @author flashk
	 * 
	 */
	public class SystemTool
	{
		public static function gc():void
		{
			try{
				new LocalConnection().connect ("cleanMem");
				new LocalConnection().connect ("cleanMem");
			}
			catch (e:*){}
		}
		
	}
}