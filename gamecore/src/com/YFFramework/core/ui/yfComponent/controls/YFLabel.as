package com.YFFramework.core.ui.yfComponent.controls
{
	/**
	 *  @author yefeng
	 *   @time:2012-3-22下午03:46:38
	 */
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
	
	
	public class YFLabel extends YFComponent
	{
		protected var _textFiled:TextField;
		private var _text:String;
		private var _size:int;
		private var _color:int;
		private var _bold:Boolean;
		private var _textAlign:String;
		protected var _bgColor:uint;
		protected var _bg:DisplayObject;

		public function YFLabel(text:String="",skinId:int=1,size:int=12,color:int=0xFFFFFF,bgColor:int=0x000000,bold:Boolean=false,textAlign:String="left",autoRemove:Boolean=false)
		{
			_text=text;
			_size=size;
			_color=color;
			_bold=bold;
			_textAlign=textAlign;
			_bgColor=bgColor;
			mouseChildren=false;
			_skinId=skinId;
			super(autoRemove);
		}
		override protected function initUI():void
		{
			initTextField();
			createTextBg();
			initGlow();
		}
		
		/** 创建文本的背景色
		 */
		protected function createTextBg():void
		{
			switch(_skinId)
			{
				case 1:///没有背景 
					return ;
					break;
				case 2:
					_textFiled.background=true;
					_textFiled.backgroundColor=_bgColor;
					_textFiled.border=true;
					_textFiled.borderColor=0x000000;
					break;
				case 3:
					_style=YFSkin.Instance.getStyle(YFSkin.NumberStepperTextBg) ;
					_bg=_style.link as Scale9Bitmap;
					addChildAt(_bg,0);
					_bg.width=_textFiled.width;
					_bg.y=-1;
					_textFiled.border=true;
					_textFiled.borderColor=0x000000;
					break;
				case 4:
					_style=YFSkin.Instance.getStyle(YFSkin.LabelBg1);
					_bg=new Bitmap(_style.link as BitmapData);
					addChildAt(_bg,0);
					_bg.width=_textFiled.width;
					_bg.y=-1;
					break;
			}
		}
		
		protected function initTextField():void
		{
			_textFiled=new TextField();
			_textFiled.autoSize="left";
		//	_textFiled.mouseEnabled=false;
			_textFiled.text=_text;
			_textFiled.multiline=true;
			_textFiled.wordWrap=true;
			var tf:TextFormat=new TextFormat(YFStyle.font,_size,_color,_bold);
			tf.align=_textAlign;
			_textFiled.setTextFormat(tf);
			addChild(_textFiled);
			_textFiled.textColor=_color;

		} 
		protected function initGlow():void
		{
			///进行描边处理
			var glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);
			_textFiled.filters=[glow];
		}

		
		/** 设置字体颜色
		 */
		public function setColor(value:int):void
		{
			_textFiled.textColor=value;
		}

		public function setHTMLText(htmlText:String,defaultColor:uint=0xFFFFFF):void
		{
			_textFiled.textColor=defaultColor;
			_textFiled.htmlText=htmlText;
		}
		
		
		
		
		public function get text():String	{	return _textFiled.text;		}
		
		public function set text(value:String):void{	_textFiled.text=value;		}
		
		
		public function get htmlText():String{	return _textFiled.htmlText;		}
		
		public function get textWidth():Number{	return _textFiled.textWidth;	}
		public function get textHeight():Number{	return _textFiled.textHeight;	}
		
		override public function dispose(e:Event=null):void
		{
			removeChild(_textFiled);
			_textFiled=null;
			_text="";
			super.dispose();
		}
		
		override public function set width(value:Number):void
		{
			_textFiled.width=value;
			if(_bg) _bg.width=value;
		//	super.width=value;
		}
		
		override public function set height(value:Number):void
		{
			_textFiled.height=value;
			if(_bg)_bg.height=value;
		}
		
		/**恰好的宽度
		 */
		public function exactWidth():void
		{
			_textFiled.width=textWidth+15;
		}
		
	}
}