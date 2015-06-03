package com.YFFramework.game.ui.layer
{
	/**窗口层
	 * @author yefeng
	 *2012-8-18下午10:51:10
	 */
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.abs.GameWindow;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class WindowsLayer extends AbsView
	{
		/**鼠标是否已经按下		
		 */
		private var _press:Boolean;
		public function WindowsLayer()
		{
			super(false);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownEvent);
			StageProxy.Instance.mouseDown.regFunc(mouseDown);
			StageProxy.Instance.mouseUp.regFunc(mouseUp);
			
		}
		/**事件侦听	
		 */		
		private function onMouseDownEvent(e:MouseEvent):void
		{
			_press=true;
			var target:EventDispatcher=e.target as EventDispatcher;
			target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER))
		}
		/**将滑上的窗口放在最顶层
		 */		
		private function onMouseOver(e:MouseEvent):void
		{
			if(_press)  ///当鼠标已经按下
			{
				var display:DisplayObject=e.target as DisplayObject;
				var window:GameWindow;
				while(display is GameWindow==false) ///找到 窗口层
				{
					display=display.parent;
				}
				window=display as GameWindow;
				if(window)
				{
					window.topIt();
				}	
			}
		}
		
		private function mouseDown():void
		{
			_press=true;
			
			
		}
		private function mouseUp():void
		{
			_press=false;
			
		}
			
		
	}
}