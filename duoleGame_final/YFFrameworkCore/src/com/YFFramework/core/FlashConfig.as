package com.YFFramework.core
{
	import flash.system.Capabilities;

	/**@author yefeng
	 * 2013 2013-10-21 下午4:20:15 
	 */
	public class FlashConfig
	{
		
		/** flash版本
		 */
		private var _flashVersion:Number=11.4;
		
		/**能够使用atf的最低版本
		 */
		private static const Atf_Flash_Version:Number=11.4;

		/**是否能够使用atf
		 */
		private var _canUseAtf:Boolean=true;

		
		private static var _instance:FlashConfig;

		public function FlashConfig()
		{
			initFlashVersion();
		}
		
		public static function get Instance():FlashConfig
		{
			if(!_instance)_instance=new FlashConfig();
			return _instance;
		}
		/**flash版本    用于地图加载判定  
		 */
		public function getFlashVersion():Number
		{
			return _flashVersion; //WIN  MAC  UNIX    eg: WIN 11,4,402,265
		}
		private function initFlashVersion():void
		{
			var index:int=Capabilities.version.indexOf(" ");  //WIN  MAC  UNIX    eg: WIN 11,4,402,265
			var str:String=Capabilities.version.substring(index+1);
			var arr:Array=str.split(",");
			_flashVersion=Number(arr[0])+Number(arr[1]*0.1);
			
			if(_flashVersion>=Atf_Flash_Version)_canUseAtf=true;
			else _canUseAtf=false;
		}
		
		/**能否使用atf文件
		 */
		public function canUseATf():Boolean
		{
			return _canUseAtf;
		}

	}
}