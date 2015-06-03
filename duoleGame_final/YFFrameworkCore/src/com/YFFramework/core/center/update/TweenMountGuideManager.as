package com.YFFramework.core.center.update
{
	/**坐骑 偏移量的统一调度
	 * @author yefeng
	 * 2013 2013-7-27 下午1:32:38 
	 */
	public class TweenMountGuideManager extends UpdateFuncManager
	{
		private static var _instance:TweenMountGuideManager;
//		private var _arr:Vector.<Function>;
//		private var _size:int;
		public function TweenMountGuideManager()
		{
//			_arr=new Vector.<Function>();
//			_size=0;
		}
		public static function get Instance():TweenMountGuideManager
		{
			if(!_instance)_instance=new TweenMountGuideManager();
			return _instance;
		}
//		public function addFunc(func:Function):void
//		{
//			var index:int=_arr.indexOf(func);
//			if(index==-1)
//			{
//				_arr.push(func);
//				++_size;
//			}
//		}
//		public function removeFunc(func:Function):void
//		{
//			var index:int=_arr.indexOf(func);
//			if(index!=-1)
//			{
//				_arr.splice(index,1);
//				_size--;
//			}
//		}
//		
//		public function update():void
//		{
//			for(var i:int=0;i<_size;++i)
//			{
//				_arr[i]();
//			}
//		}
	}
}