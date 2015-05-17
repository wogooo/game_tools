package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.yfComponent.YFComponent;

	/**  2012-6-29
	 *	@author yefeng
	 */

	public class YFTextArea extends YFComponent
	{
		
		protected var _label:YFTextInput;
		protected var _scroller:YFScroller;
		protected var _width:int;
		protected var _height:int;
		public function YFTextArea(width:int=250,height:int=200)
		{
			_width=width;
			_height=height;
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_label=new YFTextInput();
			_label.width=_width;
			_label.height=_height;
			_scroller=new YFScroller(_label,_height);
			addChild(_scroller);
			
		}
		
		public function set text(txt:String):void
		{
			var preHeight:int=_label.height
			_label.text=txt;
			_label.height=_label.textHeight;
//			if((preHeight-_height)*(_label.height-_height)<=0)
//			{
				_scroller.updateView();			
//			}
	
				
		}
		
		public function get text():String
		{
			return _label.text;
		}
			
		
	}
	
}
