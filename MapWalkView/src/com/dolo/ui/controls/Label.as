package com.dolo.ui.controls
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;

	/**
	 * 文本 
	 * @author flashk
	 * 
	 */
	public class Label extends UIComponent
	{
		//文本默认样式
		public static var textFormat:TextFormat = new TextFormat("_sans",12,0xFFFFFF);
		
		protected var _txt:TextField;
		
		public function Label()
		{
			_txt =new TextField();
			_txt.defaultTextFormat = textFormat;
			_txt.mouseEnabled = false;
			_txt.multiline = true;
			_txt.wordWrap = true;
			this.addChild(_txt);
		}
		
		public function get textField():TextField
		{
			return _txt;
		}
		
		public function set text(str:String):void
		{
			_txt.htmlText = str;
		}

		public function set color(value:uint):void
		{
			_txt.textColor = value;
		}
		
		public function get color():uint
		{
			return _txt.textColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_txt.background = true;
			_txt.backgroundColor = value;
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
			_txt.width = newWidht;
			_txt.height = newHeight;
		}
		
	}
}