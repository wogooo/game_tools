package com.dolo.ui.controls
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;

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
		
		public function CheckBox()
		{
			
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateView();
			this.dispatchEvent(new Event(Event.CHANGE));
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
			_ui.mouseEnabled = false;
			_ui.addEventListener(MouseEvent.CLICK,onMouseClick);
			resetXY(_ui);
			this.addChild(_ui);
			initMouseSet();
		}
		
		protected function onMouseClick(event:MouseEvent=null):void
		{
			selected = !selected;
		}
		
		protected function updateView():void
		{
			if(_selected == true){
				_ui.gotoAndStop(2);
			}else{
				_ui.gotoAndStop(1);
			}
			initMouseSet();
		}
		
		protected function initMouseSet():void
		{
			var simBtn:SimpleButton;
			for(var i:int=0;i<_ui.numChildren;i++){
				simBtn = _ui.getChildAt(i) as SimpleButton;
				if(simBtn){
					simBtn.useHandCursor = false;
				}
			}
		}
		
	}
}