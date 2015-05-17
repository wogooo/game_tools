package gpu2d.core
{
	import gpu2d.errors.SingletonError;
	import gpu2d.events.GEventDispatcher;

	/**
	 * gpu2d的事件中心
	 * author :夜枫
	 * 时间 ：2011-11-21 下午08:15:29
	 */
	public final class GEventCenter extends GEventDispatcher
	{
		private static var _instance:GEventCenter;
		public function GEventCenter()
		{
			if(_instance) throw new SingletonError();
		}
		public static function get Instance():GEventCenter
		{
			if(!_instance) _instance=new GEventCenter();
			return _instance;
		}
		
	}
}