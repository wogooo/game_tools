/**
 *
 *
 * 
 * 用法   设置完宽高后需要updateView();才能准确定位文本
  var btn:YFButton=new YFButton("完成任务");

btn.x=btn.y=200

btn.width=100

addChild(btn);
 *  
 */

package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-5-14下午10:47:40
	 */
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.container.OneChildContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class YFButton extends YFSimpleButton
	{
		
		protected var _label:YFLabel;
		protected var _text:String;
		
		private var _textSize:int;
		
		private var _align:String;
		/**
		 * @param text 文本
		 * @param textSize  字体大小   默认使用 皮肤指定字体   -1 时 表示使用默认字体大小  也就是 皮肤参数里设置的大小
		 * @param skinId    皮肤id 
		 * @param autoRemove  释放自动删除
		 * 
		 */
		public function YFButton(text:String="按钮",skinId:int=2,textSize:int=-1,alin:String="center",autoRemove:Boolean=false)
		{
			this._text=text;
			this._textSize=textSize;
			_align=alin;
			super(skinId,autoRemove);
			mouseChildren=false;
			disabled=false;
			width=50;//_upMc.width;
			height=_upMc.height;
		}
		override protected function initUI():void
		{
			super.initUI();
			initLabel();
		}
		
		private function initLabel():void
		{
			var width:int=_upMc.width;
			_textSize=_textSize==-1?_style.fontSize:_textSize;
			
			_label=new YFLabel(_text,1,_textSize,_style.upColor,_style.backgroundColor,_style.isBold,"left");
			addChild(_label);
			_label.x=_style.scale9L;
			updateWidth()
		}

		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		
		override protected function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_UP:
					_skinContainer.addChild(_overMc);
					_label.setColor(_style.overColor);
					break;
				case MouseEvent.MOUSE_DOWN:
					_skinContainer.addChild(_downMc);
					_label.setColor(_style.downColor);
					break;
				case MouseEvent.MOUSE_OVER:
					_skinContainer.addChild(_overMc);
					_label.setColor(_style.overColor);
					break;
				case MouseEvent.MOUSE_OUT:
					_skinContainer.addChild(_upMc);
					_label.setColor(_style.upColor);
					break;
			}
		}
		
	
//		public function set disabled(value:Boolean):void
//		{
//			_disable=value;
//			if(_disable)
//			{
//				_skinContainer.addChild(_disableMC);
//				mouseChildren=mouseEnabled=false;
//			}
//			else 
//			{
//				_skinContainer.addChild(_upMc);
//				mouseChildren=false;
//				mouseEnabled=true;
//			}
//		}
		
//		public function get disabled():Boolean
//		{
//			return _disable;
//		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
//			_upMc=null;
//			_upMc=null;
//			_overMc=null;
//			_downMc=null;
//			_disableMC=null;
//			_skinContainer=null;
			_text=null;
			_label=null;
		}
		
		
		
		override public function set width(value:Number):void
		{
			_upMc.width=value;
			_downMc.width=value;
			_overMc.width=value;
			if(_disableMC)	_disableMC.width=value;
			updateWidth();
		}
		override public function get width():Number
		{
			return _upMc.width;
		}
		override public function set height(value:Number):void
		{
			_upMc.height=value;
			_downMc.height=value;
			_overMc.height=value;
			if(_disableMC)	_disableMC.height=value;
			updateLabelY();
		}
		override public function get height():Number
		{
			return _upMc.height;
		}
		
		private function updateWidth():void
		{
			_label.width=_upMc.width-_style.scale9L-_style.scale9R;
			centerLabel();
			updateLabelY();
		}
		private function updateLabelY():void
		{
			_label.y=(_upMc.height-_label.height)*0.5;
		}
		/**居中文本
		 */			
		private function centerLabel():void
		{
			var ad:int=15;
			_label.width=_label.textWidth+ad;
			if(_align=="center")
			{
				_label.x=(_upMc.width-_style.scale9L-_style.scale9R-_label.textWidth)*0.5;
		//		_label.x +=ad;
			}
		}

		
		
		public function get text():String
		{
			return _label.text;
		}
		public function set text(value:String):void
		{
			_text=value;
			_label.text=_text;
			updateWidth();
			
		}
		
		
		/**  恰好宽度
		 */
		public function exactWidth():void
		{
			width=_style.scale9L+_label.textWidth+5+_style.scale9R;
		}
		
		
		public function exactHeight():void
		{
			height=_style.scale9T+_label.textHeight+_style.scale9B;
		}
		
		
		override public function set disabled(value:Boolean):void
		{
			super.disabled=value;
			if(value)_label.setColor(_style.disableColor);
		}
		

		
	}
}