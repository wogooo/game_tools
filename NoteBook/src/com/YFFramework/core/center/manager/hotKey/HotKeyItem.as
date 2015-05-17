package com.YFFramework.core.center.manager.hotKey
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * author :夜枫 
	 * 热键管理
	 */
	public final class HotKeyItem
	{
		
		/*
		 *  当使用 HotKeyItem发生错误时 需要将侦听器 的参数设为基类Event就可以了 
			function lisntner(e:Event):void{}   因为下面的构造函数是Event   在调用时 内部不进行转化  所以这里的侦听器最好写成e:Event 
			而不是实际的事件类型 当定义的新事件类型  NewEvent 带属性时  可用 Object(newEvent_instance:Event)强制取出来
		*/
		/**
		 *键盘键值 
		 */
		private var _keyCode:uint;
		private  var _dispatcher:IEventDispatcher;
		private var idDelete:Boolean=false;
		private var event:Event;
		/** 侦听该类型的 侦听器 必须是 e:Event  要不然会报出异常  取属性 用Object(e)进行取属性
		 */		
		public function HotKeyItem(dispatcher:IEventDispatcher,keyCode:uint,event:Event)
		{
			_dispatcher=dispatcher;
			_keyCode=keyCode;
			this.event=event;
			HotKeyManager.Instance.regHotKey(this);
		}
		/**发送事件
		 */		
		internal function dispatchEvent():void
		{
			_dispatcher.dispatchEvent(event);                   
		}
		internal function get keyCode():uint
		{
			return _keyCode;                       
		}
		/**删除热键功能
		 */		
		public function delHotKey():void
		{ 
			HotKeyManager.Instance.delHotKey(this);          
			idDelete=true;
		}
		public function dispose():void
		{
			if(!idDelete)delHotKey();
			_keyCode=0;
			_dispatcher=null;
			event=null;
		}
		
	}
}