package com.YFFramework.core.center.update
{
	/**移动管理器
	 * @author yefeng
	 * 2013 2013-7-27 上午11:54:16 
	 */
	public class TweenMovingManager
	{
		private static var _instance:TweenMovingManager;
		private var _arr:Vector.<Function>;
		private var _size:int;
		public function TweenMovingManager()
		{
			_arr=new Vector.<Function>();
			_size=0;
		}
		public static function get Instance():TweenMovingManager
		{
			if(!_instance)_instance=new TweenMovingManager();
			return _instance;
		}
		public function addFunc(func:Function):void
		{
			var index:int=_arr.indexOf(func);
			if(index==-1)
			{
				_arr.push(func);
				++_size;
			}
		}
		public function removeFunc(func:Function):void
		{
			var index:int=_arr.indexOf(func);
			if(index!=-1)
			{
				_arr.splice(index,1);
				_size--;
			}
		}
		
		public function update():void
		{
			var func:Function;
			for(var i:int=0;i<_size;++i)
			{
				func=_arr[i];
				func();
			}
		}
	}
}