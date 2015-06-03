package com.dolo.ui.controls
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 文本 
	 * @author flashk
	 * 
	 */
	public class Label extends UIComponent
	{
		//文本默认样式
		public static var textFormat:TextFormat = new TextFormat("_sans",12,0xFFFFFF);
		
		private static const GlowIt:GlowFilter=new GlowFilter(0x000000,1,2,2,2);
		
		protected var _txt:TextField;
		
		override public function dispose():void
		{
			super.dispose();
			_txt = null;
		}
		
		public function Label()
		{
			_txt =new TextField();
			_txt.defaultTextFormat = textFormat;
			_txt.mouseEnabled = false;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.cacheAsBitmap = true;
			_txt.autoSize = "left";
			this.addChild( _txt );
			mouseChildren = false ;
			cacheAsBitmap = true ;
			mouseChildren = mouseEnabled = false;
		}
		
		protected function initGlow():void
		{
			///进行描边处理
			_txt.filters = [ GlowIt ];
		}

		public function get textField():TextField
		{
			return _txt;
		}
		
		public function setText(text:String,color:uint=0xFFFFFF,bold:Boolean=false,size:int=12):void
		{
			_txt.text = text;
			_txt.textColor = color;
//			if( bold )
//			{
			var mat:TextFormat = new TextFormat();
			mat.bold = true;
			mat.size=size;
			_txt.setTextFormat( mat );
//			}
		}
		
		public function get text():String
		{
			return _txt.text;
		}

		public function setColor(value:uint):void
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
			super.setSize( newWidht, newHeight );
			_txt.width = newWidht;
			_txt.height = newHeight;
		}
		
		/**恰好的宽度
		 */
		public function exactWidth():void
		{
			_txt.width = _txt.textWidth + 20;
		}
		
		public function exactHeight():void
		{
			_txt.height = _txt.textHeight + 5;
		}

		public function set selectable(value:Boolean):void
		{
			_txt.selectable = value;
		}

		override public function set width(value:Number):void
		{
			_txt.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_txt.height=value;
		}
		
		public function get textWidth():Number
		{	
			return _txt.textWidth;	
		}
		
		public function get textHeight():Number
		{	
			return _txt.textHeight;	
		}

	}
}