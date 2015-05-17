package com.YFFramework.core.event
{
	public class YFEventCenter extends YFDispather
	{
		
		private static var _instance:YFEventCenter;
		
		public function YFEventCenter()
		{
			super();
		}
		public static function get Instance():YFEventCenter
		{
			if(!_instance) 	_instance=new YFEventCenter();
			return _instance;
		}           

	}
}