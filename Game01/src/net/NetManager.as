package net
{
	import flash.utils.Dictionary;

	public class NetManager
	{
		private static var _instance:NetManager = null;
		private var _engineMap:Dictionary = new Dictionary();
		
		public function NetManager()
		{
			if (_instance)
			{
				throw new Error("不允许创建NetManager的实例");
			}
			_instance = this;
		}
		
		public static function get Instance():NetManager
		{
			if (!_instance)
			{
				_instance = new NetManager();
			}
			return _instance;
		}
		
		public function getNetEngine(name:String):NetEngine
		{
			if (!_engineMap[name])
			{
				_engineMap[name] = new NetEngine();
			}
			return 	_engineMap[name];
		}
	}
}