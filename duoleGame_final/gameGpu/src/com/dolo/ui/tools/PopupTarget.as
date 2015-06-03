package com.dolo.ui.tools
{
	import com.dolo.ui.managers.UI;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PopupTarget
	{
		private var _click:InteractiveObject;
		private var _pop:DisplayObject;
		
		private var _moveX:int = 0;
		private var _moveY:int = 0;
		private var _mode:int;
		
		public function PopupTarget(clickTarget:InteractiveObject,popTarget:DisplayObject,popMode:int=1):void
		{
			_click = clickTarget;
			_pop = popTarget;
			_mode = popMode;
			_click.addEventListener(MouseEvent.CLICK,switchShowClose);
		}
		
		public function get mode():int
		{
			return _mode;
		}

		public function set mode(value:int):void
		{
			_mode = value;
		}

		public function get moveY():int
		{
			return _moveY;
		}

		public function set moveY(value:int):void
		{
			_moveY = value;
		}

		public function get moveX():int
		{
			return _moveX;
		}

		public function set moveX(value:int):void
		{
			_moveX = value;
		}
		
		public function isShowing():Boolean
		{
			if(_pop.parent){
				return true;
			}
			return false;
		}

		public function switchShowClose(event:MouseEvent):void
		{
			if(_pop.parent){
				close();
			}else{
				show();
			}
		}
		
		public function show(event:MouseEvent=null):void
		{
			var po:Point = _click.localToGlobal(new Point(0,0));
			UI.topSprite.addChild(_pop);
			_pop.x = po.x + _moveX;
			_pop.y = po.y + _moveY;
			if(_mode == 2){
				_pop.y = po.y - _pop.height-_moveY;
			}
			UI.stage.addEventListener(MouseEvent.MOUSE_DOWN,close);
			UI.stage.addEventListener(Event.RESIZE,onStageResize);
		}
		
		public function close(event:MouseEvent = null):void
		{
			if(event){
				if( _click.hitTestPoint(UI.stage.mouseX,UI.stage.mouseY) == true ){
					return;
				}
				if( _pop.hitTestPoint(UI.stage.mouseX,UI.stage.mouseY) == true ){
					return;
				}
			}
			UI.stage.removeEventListener(MouseEvent.MOUSE_DOWN,close);
			UI.stage.removeEventListener(Event.RESIZE,onStageResize);
			if(_pop.parent){
				_pop.parent.removeChild(_pop);
			}
		}
		protected function onStageResize(event:Event):void
		{
			close();
		}
	}
}