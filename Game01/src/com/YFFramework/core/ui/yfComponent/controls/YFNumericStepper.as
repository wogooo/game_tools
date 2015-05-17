package com.YFFramework.core.ui.yfComponent.controls
{
	/**  2012-6-29
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class YFNumericStepper extends YFComponent
	{
		
		public var stepSize:int;
		public var maximum:int;
		public var minimum:int;
		protected var _upBtn:YFSimpleButton
		protected var _downBtn:YFSimpleButton;
		protected var _textInput:YFTextInput;
		protected var _value:int;
		public function YFNumericStepper(value:int=0,stepSize:int=1,maximum:int=100,minimum:int=0,autoRemove:Boolean=false)
		{
			this.stepSize=stepSize;
			this.maximum=maximum;
			this.minimum=minimum;
			super(autoRemove);
			value=0;
			
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_textInput=new YFTextInput("0",3,14);
			_textInput.width=80;
			addChild(_textInput);
			_upBtn=new YFSimpleButton(11);
			_downBtn=new YFSimpleButton(12);
//			_upBtn.width=_downBtn.width=24;
//			_upBtn.height=_downBtn.height=12;
			_upBtn.x=_textInput.width-_upBtn.width+2;
			_downBtn.x=_upBtn.x;
			_upBtn.y=-2;
			_downBtn.y=_upBtn.y+_upBtn.height;
			addChild(_upBtn);
			addChild(_downBtn);
		
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_upBtn.addEventListener(MouseEvent.CLICK,onClick);
			_downBtn.addEventListener(MouseEvent.CLICK,onClick);
			_textInput.addEventListener(Event.CHANGE,onChange);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_upBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_downBtn.removeEventListener(MouseEvent.CLICK,onClick);
			_textInput.removeEventListener(Event.CHANGE,onChange);
		}
		
		protected function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{	
				case _upBtn: 
					value +=stepSize;
					break;
				case _downBtn:
					value -=stepSize;
					break;
			}
		}
		
		
		public function set value(value:int):void
		{
			_value=value;
			if(_value> maximum) _value=maximum;
			if(_value<minimum)_value=minimum;
			_textInput.text=_value.toString();
		}
		public function get value():int
		{
			return _value;
		}
		protected function onChange(e:Event):void
		{
			value=int(_textInput.text);	
		}
		
		
	}
}