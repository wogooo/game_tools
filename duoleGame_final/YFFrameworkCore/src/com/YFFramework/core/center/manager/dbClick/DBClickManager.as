package com.YFFramework.core.center.manager.dbClick
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**双击事件事件 管理
	 * @author yefeng
	 *2012-8-19下午5:01:27
	 */
	public class DBClickManager
	{
		/**双击的时间差
		 */		
		private static const DBClickTime:int=270;
		private var _dict:Dictionary;
		
		private static var _instance:DBClickManager;
		public function DBClickManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():DBClickManager
		{
			if(!_instance)_instance=new DBClickManager();
			return _instance;
		}
		public function regDBClick(display:InteractiveObject,func:Function):void
		{
			var item:DBClickItem=new DBClickItem();
			item.dbClickObject=display;
			item.dbClickFunc=func;
			_dict[display]=item;
			display.addEventListener(MouseEvent.CLICK,onClick);
		}
		/**删除双击注册
		 */		
		public function delDBClick(display:InteractiveObject):void
		{
			var item:DBClickItem=_dict[display];
			if(item)
			{
				///移除事件侦听
				display.removeEventListener(MouseEvent.CLICK,onClick);
				_dict[display]=null;
				delete _dict[display];
				item.dispose();
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			var target:DisplayObject=e.currentTarget as DisplayObject;
			var item:DBClickItem=_dict[target];
			var dif:Number=getTimer()-item.currentTime;
			if(dif<=DBClickTime)
			{
				if(item.dbClickFunc.length==0)	item.dbClickFunc();
				else if(item.dbClickFunc.length==1)item.dbClickFunc(item.dbClickObject);
				e.stopImmediatePropagation();
			}
			item.currentTime=getTimer();
		}
		
	}
}