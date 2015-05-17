package com.YFFramework.core.center.manager.hotKey
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.KeyboardEvent;

	/**
	 * author :夜枫 * 时间 ：2011-9-27 下午08:04:13
	 * 
	 * 热键管理    最终 键盘响应发送的都是MouseEvent.CLICK事件
	 */
	public class HotKeyManager
	{
		private var _hotKeyArr:Vector.<HotKeyItem>=new Vector.<HotKeyItem>();
		private static var _instance:HotKeyManager;
		public function HotKeyManager()
		{
			if(_instance) throw new Error("请使用Instance属性");
			else addEvent();
		}
		public static function get Instance():HotKeyManager
		{
			if(!_instance) _instance=new HotKeyManager();
			return _instance;
		}
		/** 注册热键 
		 */		
		internal function regHotKey(item:HotKeyItem):void
		{
			addElement(_hotKeyArr,item);
			
		}
		/** 删除热键
		 */		
		internal function delHotKey(item:HotKeyItem):void
		{
			removeElement(_hotKeyArr,item);
			if(_hotKeyArr.length==0)removeEvent();
		}
		
		
		protected function addEvent():void
		{
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent);
		}
		protected function removeEvent():void
		{
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent);
		}
		protected function onKeyboardEvent(e:KeyboardEvent):void
		{
			var keyCode:uint=e.keyCode;
			for each (var item:HotKeyItem in _hotKeyArr)
			{
  				if(item.keyCode==keyCode)
				{
					item.dispatchEvent();
					return ;  /////当注册了多个相同的热键值的话 则只会响应第一个热键值  这里要注意  调试时可能用到
				}
			}
		}
		
		
		private function addElement(arr:Vector.<HotKeyItem>,obj:HotKeyItem):void
		{
			var index:int=arr.indexOf(obj);
			if(index==-1)arr.push(obj);
		}
		private function removeElement(arr:Vector.<HotKeyItem>,obj:HotKeyItem):void
		{
			var index:int=arr.indexOf(obj);
			if(index!=-1)arr.splice(index,1);
		}	
	}
}