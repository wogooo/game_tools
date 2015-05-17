package com.YFFramework.core.center.manager
{
	/**@author yefeng
	 *2012-4-19下午10:54:00
	 */
	public class ResizeManager
	{
		private var funcArr:Vector.<Function>;
		private static var _instance:ResizeManager;
		public function ResizeManager()
		{
			funcArr=new Vector.<Function>();
		}
		 public static function get Instance():ResizeManager
		 {
			 if(!_instance) _instance=new ResizeManager();
			 return _instance;
		 }
		 /**func参数 不具备参数 或者存在默认参数  func(e:Event=null)这样的书写方式 
		  */
		 public function regFunc(func:Function):void
		 {
			var index:int =funcArr.indexOf(func);
			if(index==-1)funcArr.push(func);
		 }
		 public function delFunc(func:Function):void
		 {
			 var index:int =funcArr.indexOf(func);
			 if(index!=-1)funcArr.splice(index,1);
		 }
		 public function resize():void
		 {
			 for each (var func:Function in funcArr)
			 	func();
		 }
	}
}