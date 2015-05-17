package com.YFFramework.core.ui.yfComponent.controls
{
	/** tree cell 元件
	 * @author yefeng
	 *2012-8-11下午4:39:07
	 */
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class YFTreeCell extends YFCheckBox
	{
		private var  _bg:YFTogleButton;
		
		
		public function YFTreeCell(txt:String,skinId:int=3,autoRemove:Boolean=false)
		{
			super(txt,skinId,autoRemove);
		}
		
		/**
		 *初始化ui  
		 */
		override protected function initUI():void
		{
			super.initUI();
			_bg=new YFTogleButton(4);
			_bg.height=25;
			addChildAt(_bg,0);
			_bg.y=-(_bg.height-_label.textHeight)*0.5;
			_bg.x=-5;
		}
		
		
		override protected function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					_label.setColor(_style.overColor);
					_bg.select=true;
					break;
				case MouseEvent.MOUSE_DOWN:
					_label.setColor(_style.downColor);
					break;
				case MouseEvent.MOUSE_OUT:
					_label.setColor(_style.upColor);
					_bg.select=false;
					break;				
			}
		}
		
	}
}