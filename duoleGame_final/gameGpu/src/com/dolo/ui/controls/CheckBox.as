package com.dolo.ui.controls
{
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * CheckBox 组件显示一个小方框，该方框内可以有选中标记。 CheckBox 组件还可以显示可选的文本标。
	 * 
	 * <p>CheckBox 组件为响应鼠标单击将更改其状态，或者从选中状态变为取消选中状态，或者从取消选中状态变为选中状态。 CheckBox 组件包含一组非相互排斥的 true 或 false 值。</p>
	 *  
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author flashk
	 */
	public class CheckBox extends UIComponent
	{
		protected var _ui:MovieClip;
		protected var _selected:Boolean = false;
		protected var _value:*;
		protected var _txt:TextField;
		protected var _label:String;
		
		override public function dispose():void
		{
			super.dispose();
			_ui = null;
			_value = null;
			_txt = null;
			_label = null;
		}
		
		public function CheckBox()
		{
			
		}
		
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * 设置标签文本 
		 * @param value
		 * 
		 */
		public function set label(value:String):void
		{
			_label = value;
			if( _txt ){
				_txt.htmlText = value;
				_txt.width = _txt.textWidth+15;
			}
		}
		
		public function setFormat(format:TextFormat):void{
			if(_txt){
				_txt.setTextFormat(format);
			}
		}
		
		/**
		 * 返回对标签文本实例的引用 
		 * @return 
		 * 
		 */
		public function get textField():TextField
		{
			return _txt;
		}
		
		public function get textColor():uint
		{
			return _txt.textColor;
		}
		
		/**
		 * 设置标签文本颜色 
		 * @param value
		 * 
		 */
		public function set textColor(value:uint):void
		{
			_txt.textColor = value;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateView();
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}

		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get value():*
		{
			return _value;
		}
		
		/**
		 * 设置此单选按钮对应的数据项，此数据和文本互相独立 
		 * @param value
		 * 
		 */
		public function set value(value:*):void
		{
			_value = value;
		}

		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as MovieClip;
			_ui.stop();
			_ui.addEventListener( MouseEvent.CLICK, onMouseClick );
			_txt = Xdis.getChild( _ui, "label_txt" );
			if( _txt ){
				_txt.mouseEnabled = false;
				_txt.autoSize=TextFieldAutoSize.LEFT;
			}
			resetXY( _ui );
			this.addChild( _ui );
			initMouseSet();
			label = _label;
		}
		
		protected function onMouseClick(event:MouseEvent=null):void
		{
			selected = !selected;
			this.dispatchEvent( new Event( UIEvent.USER_CHANGE ) );
		}
		
		protected function updateView():void
		{
			if( _selected == true ){
				_ui.gotoAndStop( 2 );
			}else{
				_ui.gotoAndStop( 1 );
			}
			initMouseSet();
		}
		
		protected function initMouseSet():void
		{
			var simBtn:SimpleButton;
			for( var i:int=0; i<_ui.numChildren; i++){
				simBtn = _ui.getChildAt( i ) as SimpleButton;
				if( simBtn ){
					simBtn.useHandCursor = false;
				}
			}
		}
		
	}
}