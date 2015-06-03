package com.YFFramework.core.text
{
	/**@author yefeng
	 * 2013 2013-4-26 下午5:29:55 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	/**  飞鞋传送   任务面板的快速传送图标
	 */	
	public class FlyView extends AbsView
	{
		public static const White_Glow_Filter:Array = [new GlowFilter(0xFFFFFF,1,8,8,3.91,BitmapFilterQuality.LOW)];

		public var clickCall:Function;
		public var clickParam:Object;
		public function FlyView()
		{
			super(false);
			mouseChildren=false;
			buttonMode=true;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.CLICK,onClick);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);

		}
		
		public function doFilter():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					filters=White_Glow_Filter
					break;
				case MouseEvent.MOUSE_OUT:
					filters=[];
					break;
			}
		}
		
		
		public function onClick(e:Event=null):void
		{
			if(clickCall!=null)clickCall(clickParam);
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			clickCall=null;
			clickParam=null;
		}
		
	}
}