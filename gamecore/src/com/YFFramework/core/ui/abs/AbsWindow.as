package com.YFFramework.core.ui.abs
{
	import com.YFFramework.core.center.manager.hotKey.HotKeyItem;
	import com.YFFramework.core.ui.layer.LayerManager;
	
	import flash.events.Event;
	import flash.ui.Keyboard;

	/**所有的弹出层窗口的的基类
	 * 
	 * @author yefeng
	 *2012-4-20下午9:51:22
	 */
	
	public class AbsWindow extends AbsUIView
	{
		private static const ToggleEvent:String="ToggleEvent";
		/**  是否已经弹出
		 */
		protected var _isPop:Boolean;
		protected var hotKeyItem:HotKeyItem;
		public function AbsWindow(autoRemove:Boolean=false)
		{
			super(autoRemove);
			_isPop=false
		}
		
		override protected function initUI():void
		{
			super.initUI();
			hotKeyItem=new HotKeyItem(this,Keyboard.ESCAPE,new Event(ToggleEvent));
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(ToggleEvent,toggle);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(ToggleEvent,toggle);
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			hotKeyItem.dispose();
			hotKeyItem=null;
		}
		/**切换窗口弹出与关闭
		 */
		public function toggle(e:Event=null):void
		{
			if(LayerManager.WindowLayer.contains(this))
			{
				_isPop=false;
				LayerManager.WindowLayer.removeChild(this);
			}
			else 
			{
				_isPop=true;
				LayerManager.WindowLayer.addChild(this);
			}
			
		}
		
		/** 将窗口置顶 在窗口层进行置顶
		 */
		public function topWindow():void
		{
			if(LayerManager.WindowLayer.contains(this))
				LayerManager.WindowLayer.setChildIndex(this,LayerManager.WindowLayer.numChildren-1);
			else LayerManager.WindowLayer.addChild(this);
			_isPop=true;
		}
	}
}