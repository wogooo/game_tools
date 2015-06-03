package com.dolo.ui.controls
{
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 通过使用 Slider 组件，用户可以在滑块轨道的端点之间移动滑块来选择值。 
	 * Slider 组件的当前值由滑块端点之间滑块的相对位置确定，端点对应于 Slider 组件的 minimum 和 maximum 值。 
	 * 
	 * @author flashk
	 * 
	 */
	public class Slider extends UIComponent
	{
		protected var _ui:Sprite;
		protected var _drag:Sprite;
		protected var _area:Sprite;
		protected var _bg:Sprite;
		protected var _bar:Sprite;
		protected var _areaX:int;
		protected var _areaSpace:int;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _value:Number = 50;
		protected var _snapInterval:Number = 1;
		protected var _liveDragging:Boolean = true;
		protected var _lastValue:Number=-1;
		
		override public function dispose():void
		{
			super.dispose();
			_ui = null;
			_drag = null;
			_area = null;
			_bg = null;
			_bar = null;
		}
		
		public function Slider(){
		}
		
		public function get liveDragging():Boolean{
			return _liveDragging;
		}

		/**获取或设置用户在拖动鼠标移动时是否抛出Event.CHANGE事件
		 * @param value
		 */
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}

		public function get snapInterval():Number
		{
			return _snapInterval;
		}

		/**
		 * 获取或设置用户移动滑块时值增加或减小的量。 
		 * @param value
		 * 
		 */
		public function set snapInterval(value:Number):void
		{
			_snapInterval = value;
		}

		public function get value():Number
		{
			if(_value > _maximum)
				_value=_maximum;
			else if(_value < _minimum)
				_value = _minimum;
			return _value;
		}
		
		public function get drag():Sprite{
			return _drag;
		}

		/**
		 * 获取或设置 Slider 组件的当前值。 
		 * @param value
		 * 
		 */
		public function set value(v:Number):void
		{
			if(v > _maximum)//确保值在设定的范围内
				v = _maximum;
			else if(v < _minimum)
				v = _minimum;
			else
				_value = v;
			
			_value = int(_value/_snapInterval)*_snapInterval;
			
			var ratio:Number = (_value-_minimum)/(_maximum-_minimum);//当前值的在拖动区域的比率
			if(_value == _minimum)
				_drag.x = _areaX+ratio*_area.width;
			else if(_value == _maximum)
				_drag.x = _compoWidth-_areaSpace-_drag.width;
			else
				_drag.x = ratio*_area.width-_drag.width+_areaX;
			onStageMouseMove();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function updateValue():void
		{
			if(_drag.x == 0 || _drag.x < _drag.width)//特别提示，这个判断是为了当滑块拉到最右边(或拉到右边不满足一个滑块的宽度)时，判定为最小，所以根据具体情况具体判断
				_value = _minimum;
			else
			{
				_value = (_bar.width+_drag.width)/_area.width*(_maximum-_minimum)+_minimum;
				_value = int(_value/_snapInterval)*_snapInterval;
				
				if(_value > _maximum)//最右边
					_value = _maximum;
				else if(_value < _minimum)
					_value = _minimum;
			}		
//			trace("slider:",_value)
		}

		public function get minimum():Number
		{
			return _minimum;
		}

		/**
		 * Slider 组件实例所允许的最小值。 
		 * @param value
		 * 
		 */
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}

		public function get maximum():Number
		{
			return _maximum;
		}

		/**
		 * Slider 组件实例所允许的最大值。 
		 * @param value
		 * 
		 */
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}

		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as Sprite;
			resetXY(_ui);
			this.addChildAt(_ui,0);
			_area = Xdis.getChild(_ui,"area");
			_bg = Xdis.getChild(_ui,"bg");
			_bar = Xdis.getChild(_ui,"bar");
			_bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarMouseDown);
			_area.addEventListener(MouseEvent.MOUSE_DOWN,onBarMouseDown);
			_drag = Xdis.getChild(_ui,"drag");
			_drag.parent.setChildIndex(_drag,_drag.parent.numChildren-1);
			_drag.addEventListener(MouseEvent.MOUSE_DOWN,onDragMouseDown);
			_areaX = _area.x;
			_areaSpace = _bg.width-_areaX-_area.width;
		}
		
		protected function onBarMouseDown(event:MouseEvent):void
		{
			_drag.x = _ui.mouseX;
			onStageMouseMove();
			updateValue();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDragMouseDown(event:MouseEvent):void
		{
			_drag.startDrag(false,new Rectangle(_areaX,_drag.y,_area.width-_drag.width,0));
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			UI.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		}
		
		protected function onStageMouseMove(event:MouseEvent=null):void
		{
			if( _drag.x-_areaX <= 0)//拖到最左边
				_bar.width = 0;
			else
				_bar.width = _drag.x;
			
			if(event){
				event.updateAfterEvent();
				updateValue();
				if(_liveDragging == true && _lastValue != _value){
					this.dispatchEvent(new Event(Event.CHANGE));
				}
				_lastValue = _value;
			}
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			UI.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			_drag.stopDrag();
			updateValue();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
			_ui.scaleX = 1;
			_bg.width = _compoWidth;
			_area.width = _compoWidth-_areaX-_areaSpace;
			value = _value;
		}
		
	}
}