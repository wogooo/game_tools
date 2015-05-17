package com.YFFramework.core.ui.yfComponent.controls
{
	/**  2012-6-28
	 *	@author yefeng
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.container.OneChildContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/** checkBox 图标大小为19*19
	 * 
	 */	
	[Event(name="SelectChange", type="com.YFFramework.core.ui.yfComponent.events.YFControlEvent")]
	///选择改变时触发
	public class YFCheckBox extends YFTogleButton
	{
		protected var _label:YFLabel;
		protected var _txt:String;
		public function YFCheckBox(txt:String="文本框",skinId:int=1,autoRemove:Boolean=false)
		{
			_txt=txt;
			super(skinId);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			initLabel();
		}
		protected function initLabel():void
		{
			_label=new YFLabel(_txt,1,_style.fontSize,_style.upColor,_style.backgroundColor,_style.isBold);
			addChild(_label);
			_label.x=_iconW;
			_label.y=(_iconH-_label.height)*0.5;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}

		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		
		protected function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					_label.setColor(_style.overColor);
					break;
				case MouseEvent.MOUSE_DOWN:
					_label.setColor(_style.downColor);
					break;
				case MouseEvent.MOUSE_OUT:
					_label.setColor(_style.upColor);
					break;				
			}
		}
		
		override protected function onMouseUp(e:MouseEvent):void
		{
			_label.setColor(_style.overColor);
			super.onMouseUp(e);
		}
		
		public function set text(value:String):void
		{
			_txt=value;
			_label.text=_txt;
		}
		public function get text():String
		{
			return _txt;			
		}
		override public function set width(value:Number):void
		{
			_label.width=value-_iconW;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_txt=null;
		}
		
		
	}
}