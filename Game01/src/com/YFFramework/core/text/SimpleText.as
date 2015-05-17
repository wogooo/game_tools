package com.YFFramework.core.text
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**2012-10-24 下午6:43:37
	 *@author yefeng
	 */
	public class SimpleText extends TextField
	{
		/**正常状态下的颜色
		 */		
		private var _normalColor:uint;
		private var _downColor:uint;
		private var _overColor:uint;
		public function SimpleText()
		{
			super(false);
			initUI();
			addEvents();
		}
		private function addEvents():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		
		private function initUI():void
		{
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					break;
				case MouseEvent.MOUSE_OUT:
					
					break;
				case MouseEvent.MOUSE_UP:
					
					break;
			}
		}
		public function setText(txt:String):void
		{
			
		}
		
		public function getText():String
		{
			
		}
	}
}