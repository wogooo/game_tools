package com.YFFramework.core.ui.yfComponent.controls
{
	/**
	 *  @author yefeng
	 *   @time:2012-3-22下午03:46:38
	 */
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class YFGameLabel extends TextField//YFComponent
	{
		public static const glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);
		private static var _pool:Vector.<YFGameLabel>=new Vector.<YFGameLabel>();
		private static const MaxSize:int=100;
		private static var _currentSize:int=0;
		
		private var _text:String;
		private var _size:int;
		private var _color:int;
		private var _bold:Boolean;
		private var _textAlign:String;
		protected var _bgColor:uint;
		
		private var _skinId:int;
		public function YFGameLabel(text:String="",skinId:int=1,size:int=12,color:int=0xFFFFFF,bgColor:int=0x000000,bold:Boolean=false,textAlign:String="left",autoRemove:Boolean=false)
		{
			_text=text;
			_size=size;
			_color=color;
			_bold=bold;
			_textAlign=textAlign;
			_bgColor=bgColor;
			_skinId=skinId;
			initUI();
		}
		protected function initUI():void
		{
			initTextField();
			initGlow();
		}
		
		protected function initTextField():void
		{
			
			autoSize="left";
			text=_text;
			multiline=true;
			wordWrap=true;
			var tf:TextFormat=new TextFormat(YFStyle.font,_size,_color,_bold);
			tf.align=_textAlign;
			setTextFormat(tf);
			textColor=_color;
			
		} 
		protected function initGlow():void
		{
			///进行描边处理
			filters=[glow];
			cacheAsBitmap=true;
		}
		
		
		/** 设置字体颜色
		 */
		public function setColor(value:uint):void
		{
			textColor=value;
		}
		
		public function setHTMLText(htmlText:String,defaultColor:uint=0xFFFFFF):void
		{
			textColor=defaultColor;
			htmlText=htmlText;
		}
		
		
		
		public function setText(txt:String,color:uint=0xFFFFFF):void
		{
			text=txt;
			setColor(color);
			width=200;
			exactWidth();
		}
		
		//		public function get text():String	{	return text;		}
		//		
		//		public function set text(value:String):void{	text=value;		}
		
		//		public function appendText(value:String):void{	appendText(value)	}
		
		
		
		//		public function get htmlText():String{	return _textFiled.htmlText;		}
		//		
		//		public function get textWidth():Number{	return _textFiled.textWidth;	}
		//		public function get textHeight():Number{	return _textFiled.textHeight;	}
		
		public function dispose(e:Event=null):void
		{
			//			removeChild(_textFiled);
			//			_textFiled.filters=[];
			//			_textFiled=null;
			filters=[];
			_text="";
			//			super.dispose();
		}
//		override public function set width(value:Number):void
//		{
//			width=value;
//			//			if(_bg) _bg.width=value;
//			//	super.width=value;
//		}
//		
//		override public function set height(value:Number):void
//		{
//			height=value;
//			//			if(_bg)_bg.height=value;
//		}
		
		/**恰好的宽度
		 */
		public function exactWidth():void
		{
			width=textWidth+10;
		}
		
		
		//		public function set selectable(value:Boolean):void
		//		{
		//			_textFiled.selectable=value;	
		//		}
		
		
		public static function getYFGameLabel():YFGameLabel
		{
			if(_currentSize>0)
			{
				_currentSize--;
				return _pool.pop();
			}
			return new YFGameLabel();
		}
		public static function toYFGameLabelPool(label:YFGameLabel):void
		{
			if(_currentSize<MaxSize)
			{
				_pool.push(label);
				_currentSize++;
			}
			else 
			{
				label.dispose();
			}
		}
	}
}