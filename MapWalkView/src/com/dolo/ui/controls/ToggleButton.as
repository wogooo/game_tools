package com.dolo.ui.controls
{
	import com.dolo.ui.sets.ButtonTextStyle;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 可切换选中按钮 
	 * @author Administrator
	 * 
	 */
	public class ToggleButton extends Button
	{
		public static var defaultTextColors:ButtonTextStyle = new ButtonTextStyle(0xFFFFFF,0xFFFF00,0x666666,0xFFFF00);
		
		protected var _selected:Boolean;
		protected var _mc:MovieClip;
		protected var _hit:InteractiveObject;
		
		public function ToggleButton()
		{
			
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			showOut();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_mc = skin as MovieClip;
			changeTextColor(defaultTextColors);
			if(_mc == null) return;
			_mc.stop();
			_hit = _mc.getChildByName("hit") as InteractiveObject;
			_hit.addEventListener(MouseEvent.ROLL_OVER,showOver);
			_hit.addEventListener(MouseEvent.MOUSE_OUT,showOut);
			_hit.addEventListener(MouseEvent.MOUSE_DOWN,showDown);
			_hit.addEventListener(MouseEvent.CLICK,switchSelect);
			if(_hit is SimpleButton){
				SimpleButton(_hit).useHandCursor = false;
			}
			_txt = _mc.getChildByName("label_txt") as TextField;
			label = _label;
			this.mouseEnabled = false;
			resetXY(_mc);
			this.addChild(_mc);
		}
		
		public function switchSelect(event:MouseEvent=null):void
		{
			selected = !selected;
		}
		
		override protected function showDown(event:MouseEvent=null):void
		{
			super.showDown(event);
			_mc.gotoAndStop(3);
		}
		
		override protected function showOver(event:MouseEvent=null):void
		{
			super.showOver(event);
			_mc.gotoAndStop(2);
			_txt.textColor = _colors.overColor;
		}
		
		override protected function showOut(event:MouseEvent=null):void
		{
			if(_selected == true){
				_mc.gotoAndStop(4);
				if(_txt){
					_txt.textColor = _colors.selectColor;
				}
			}else{
				_mc.gotoAndStop(1);
				if(_txt){
					_txt.textColor = _colors.outColor;
				}
			}
		}
		
	}
}