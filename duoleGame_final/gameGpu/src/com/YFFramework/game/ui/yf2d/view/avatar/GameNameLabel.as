package com.YFFramework.game.ui.yf2d.view.avatar
{
	/**
	 *  @author yefeng
	 *   @time:2012-3-22下午03:46:38
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class GameNameLabel extends AbsView
	{
		protected var _textFiled:TextField;
		private var _text:String="";
		public function GameNameLabel()
		{
			super(false);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			initTextField();
			initGlow();
			cacheAsBitmap=true;
		}
		
		
		
		protected function initTextField():void
		{
			_textFiled=new TextField();
			_textFiled.autoSize="left";
			_textFiled.text=_text;
			var tf:TextFormat=new TextFormat(YFStyle.font,12,0xFFFFFF,false);
			tf.align="center";
			_textFiled.setTextFormat(tf);
			addChild(_textFiled);
			_textFiled.textColor=0xFFFFFF;

		} 
		protected function initGlow():void
		{
			///进行描边处理
			var glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);
			_textFiled.filters=[glow];
		}

		
		/** 设置字体颜色
		 */
		public function setColor(value:uint):void
		{
			_textFiled.textColor=value;
		}

		public function setHTMLText(htmlText:String,defaultColor:uint=0xFFFFFF):void
		{
			_textFiled.textColor=defaultColor;
			_textFiled.htmlText=htmlText;
		}
		
		
		
		
		public function get text():String	{	return _textFiled.text;		}
		
		public function setText(value:String,color:uint=0xFFFFFF):void
		{	
			_textFiled.text=value;	
			_textFiled.textColor=color;
		}
		
		public function appendText(value:String):void{	_textFiled.appendText(value)	}

		
		
		public function get htmlText():String{	return _textFiled.htmlText;		}
		
		public function get textWidth():Number{	return _textFiled.textWidth;	}
		public function get textHeight():Number{	return _textFiled.textHeight;	}
		
		override public function dispose(e:Event=null):void
		{
			removeChild(_textFiled);
			_textFiled.filters=[];
			_textFiled=null;
			_text="";
			super.dispose();
		}
		
		override public function set width(value:Number):void
		{
			_textFiled.width=value;
		}
		
		override public function set height(value:Number):void
		{
			_textFiled.height=value;
		}
		
		/**恰好的宽度
		 */
		public function exactWidth():void
		{
			_textFiled.width=textWidth+15;
		}
		
		
		public function set selectable(value:Boolean):void
		{
			_textFiled.selectable=value;	
		}
	}
}