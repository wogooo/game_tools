package com.YFFramework.core.ui.abs
{
	/**
	 * author :夜枫 * 时间 ：Sep 17, 2011 3:41:47 PM
	 */
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/** 所有UI的基类
	 */
	public class AbsView extends Sprite
	{
		/**是否在移出舞台时自动销毁
		 */
		protected var _autoRemove:Boolean=false;
		protected var _isDispose:Boolean;
		public function AbsView(autoRemove:Boolean=false)
		{
			_autoRemove=autoRemove;
			_isDispose=false;
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
		}
		
		protected function addEvents():void
		{
			if(_autoRemove)	this.addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		protected function removeEvents():void
		{
			if(_autoRemove)	this.removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		public function  dispose(e:Event=null):void
		{
			removeEvents();
			removeAllContent(true);
			_isDispose=true;
		}
		public function addContent(obj:DisplayObject,_x:Number=0,_y:Number=0):void
		{
			super.addChild(obj);
			obj.x=_x;
			obj.y=_y;
		}
		/**  将obj从父对象中移除去，  disposeFunc 不为null表示进行内存释放 调用该  obj的释放函数 disposeFunc
		 */
		public function removeContent(obj:DisplayObject,dispose:Boolean=false):void
		{
			super.removeChild(obj);
			if(dispose)
			{
				Object(obj).dispose();
			}
		}
		
		/**  移除子对象    dispose  表示是否进行内存释放       当为true时   执行  子对象的释放内存函数  disPoseFunc
		 */
		public function removeAllContent(dispose:Boolean=false):void
		{
			var len:int=numChildren;
			var child:DisplayObject;
			for(var i:int=0;i!=len;++i)
			{
				child=removeChildAt(0);
				if(dispose)
				{
					if(child.hasOwnProperty(dispose))
						Object(child).dispose();
				}
			}
		}
		
		/**释放已经释放了内存
		 */
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		
	}
}