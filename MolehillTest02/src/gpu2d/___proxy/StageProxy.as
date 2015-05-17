package gpu2d.proxy
{
	import flash.display.Stage;
	
	import gpu2d.errors.SingletonError;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:36:01
	 */
	public final class StageProxy
	{
		private static var _instance:StageProxy;
		
		public var stage:Stage;
		public function StageProxy()
		{
			if(_instance) throw  new SingletonError();
		}
		public static function get Instance():StageProxy
		{
			if(!_instance) _instance=new StageProxy();
			return _instance;
		}
		public function initData(stage:Stage):void
		{
			this.stage=stage;
		}
	}
}