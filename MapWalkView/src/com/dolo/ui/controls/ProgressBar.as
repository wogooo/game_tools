package com.dolo.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * 皮肤百分比进度条 
	 * @author Administrator
	 * 
	 */
	public class ProgressBar extends UIComponent
	{
		protected var _speed:Number = 4;
		protected var _ui:DisplayObject;
		protected var _initW:Number;
		protected var _percent:Number;
		protected var _toWidth:Number;
		
		public function ProgressBar()
		{
			
		}

		public function get speed():Number
		{
			return _speed;
		}

		/**
		 * 缓动的速度，默认4 公式 a += (b-a)/speed 
		 * @param value
		 * 
		 */
		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get percent():Number
		{
			return _percent;
		}
		
		/**
		 * 设置百分比 
		 * @param value 0-1之间的浮点数字
		 * 
		 */
		public function set percent(value:Number):void
		{
			_percent = value;
			if(_percent < 0 ){
				_percent = 0;
			}
			if(_percent > 1 ) {
				_percent = 1;
			}
			_toWidth = int(_initW*_percent);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var less:Number = _toWidth-_ui.width;
			_ui.width += less/_speed;
			if(Math.abs(less)<1.1){
				_ui.width = _toWidth;
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin;
			this.x = int(_ui.x);
			this.y = int(_ui.y);
			_ui.x = 0;
			_ui.y = 0;
			_initW = _ui.width;
			_percent = 0;
			_ui.width = 0;
			this.addChild(_ui);
		}
		
	}
}