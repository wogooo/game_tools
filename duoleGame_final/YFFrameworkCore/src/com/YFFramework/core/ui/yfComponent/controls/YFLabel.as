package com.YFFramework.core.ui.yfComponent.controls
{
	/**
	 *  @author yefeng
	 *   @time:2012-3-22下午03:46:38
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class YFLabel extends AbsView//YFComponent
	{
		
		private static var _pool:Vector.<YFLabel>=new Vector.<YFLabel>();
		private static const MaxSize:int=50;
		private static var _currentSize:int=0;
		
		protected var _textFiled:TextField;
		private var _text:String;
		private var _size:int;
		private var _color:int;
		private var _bold:Boolean;
		private var _textAlign:String;
		protected var _bgColor:uint;
		protected var _bg:DisplayObject;
		private var _skinId:int;
		
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
//		private function removeTF():void
//		{
//			if(contains(_textFiled))removeChild(_textFiled);
//		}
//		private function addTF():void
//		{
//			if(!contains(_textFiled))addChild(_textFiled);
//		}

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
		
		
		
		public function setText(txt:String,color:uint=0xFFFFFF):void
		{
			text=txt;
			setColor(color);
			_textFiled.width=200;
			exactWidth();
		}
		
		
		/**设置图标设置vip图标
		 */
		public function setVipIcon(mc:MovieClip):void
		{
			clearIcon();
			addChild(mc);
			mc.x=_textFiled.x+_textFiled.textWidth;
			mc.y=0
		}
		private function clearIcon():void
		{
			var len:int=numChildren;
			var mc:MovieClip;
			for(var i:int=0;i!=len;++i)
			{
				mc=getChildAt(i) as MovieClip;
				if(mc)
				{
					removeChild(mc);
				}
			}
		}
		
		public function get text():String	{	return _textFiled.text;		}
		
		public function set text(value:String):void{	_textFiled.text=value;		}
		
		public function appendText(value:String):void{	_textFiled.appendText(value)	}

		
		
		public function get htmlText():String{	return _textFiled.htmlText;		}
		
		public function get textWidth():Number{	return _textFiled.textWidth;	}
		public function get textHeight():Number{	return _textFiled.textHeight;	}
		
		override public function dispose(e:Event=null):void
		{
			clearIcon();
			removeChild(_textFiled);
			_textFiled.filters=[];
			_textFiled=null;
			_text="";
			_bg=null;
			_text=null;
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
		
		
		public function set selectable(value:Boolean):void
		{
			_textFiled.selectable=value;	
		}
		
		
		public static function getYFLabel():YFLabel
		{
			if(_currentSize>0)
			{
				_currentSize--;
				var label:YFLabel=_pool.pop();
				return label;
			}
			return new YFLabel();
		}
		public static function toYFLabelPool(label:YFLabel):void
		{
			if(label.parent)label.parent.removeChild(label);
			if(_currentSize<MaxSize)
			{
				label.clearIcon();
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