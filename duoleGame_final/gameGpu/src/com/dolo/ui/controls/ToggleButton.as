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
		public static var defaultTextColors:ButtonTextStyle = new ButtonTextStyle(0x000000,0x000000,0x000000,0x000000);
		
		protected var _selected:Boolean;
		protected var _mc:MovieClip;
		protected var _hit:InteractiveObject;
		/** 为了满足在一组中只选中一个的情况（实质是，选中某个时，再次选中时，选中效果不会消失；其实可以做一个类似radioBtn的按钮组件，就让后来人去开发吧：） */
		protected var _alwaysSelectedEffect:Boolean;
		
		override public function dispose():void
		{
			super.dispose();
			_hit.removeEventListener(MouseEvent.ROLL_OVER,showOver);
			_hit.removeEventListener(MouseEvent.MOUSE_OUT,showOut);
			_hit.removeEventListener(MouseEvent.MOUSE_DOWN,showDown);
			_hit.removeEventListener(MouseEvent.CLICK,switchSelect);
			_mc = null;
			_hit = null;
		}
		
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
		
		public function setSelectedByUser(value:Boolean,isDispatch:Boolean=false):void
		{
			_selected = value;
			showOut();
			if(isDispatch)
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
			alwaysSelectedEffect=false;
		}
		
		public function switchSelect(event:MouseEvent=null):void
		{
			if(alwaysSelectedEffect && selected)//如果永远选中效果，且当前已经选中了，就不再执行
				return;
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
			if(_txt)
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

		/** 选中某个时，再次选中时，选中效果不会消失 */
		public function get alwaysSelectedEffect():Boolean
		{
			return _alwaysSelectedEffect;
		}

		public function set alwaysSelectedEffect(value:Boolean):void
		{
			_alwaysSelectedEffect = value;
		}

		
	}
}