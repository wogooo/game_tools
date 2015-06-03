package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.dolo.ui.managers.UI;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 数字增加减少输入框 
	 * @author flashk
	 * 
	 */
	public class NumericStepper extends UIComponent
	{
		protected var _stepSize:Number = 1;
		protected var _divisor:uint = 1;
		protected var _upBtn:SimpleButton;
		protected var _downBtn:SimpleButton;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _count:uint;
		protected var _id:int;
		protected var _sh:Shape;
		protected var _sh2:Shape;
		protected var _txt:TextField;
		protected var _ui:Sprite;
		protected var _textInputAble:Boolean = true;
		protected var _inputCheckLaterTime:int = 2000;
		protected var _inputCheckLaterTimeID:int;
		
		override public function dispose():void
		{
			super.dispose();
			_upBtn = null;
			_downBtn = null;
			_sh = null;
			_sh2 = null;
			_txt = null;
			_ui = null;
		}
		
		public function NumericStepper()
		{
			
		}
		
		public function get inputCheckLaterTime():int
		{
			return _inputCheckLaterTime;
		}

		/**
		 * 用户在删除修改文本时隔多久检查最大最小值，可以设置为-1关闭此功能 
		 * @param value
		 * 
		 */
		public function set inputCheckLaterTime(value:int):void
		{
			_inputCheckLaterTime = value;
		}

		public function get textInputAble():Boolean
		{
			return _textInputAble;
		}

		public function set textInputAble(value:Boolean):void
		{
			_textInputAble = value;
			_txt.mouseEnabled = _textInputAble;
		}

		public function get stepSize():Number
		{
			return _stepSize;
		}

		public function set stepSize(value:Number):void
		{
			_stepSize = value;
		}

		public function set text(value:String):void 
		{
			if(value == null) value = "";
			_txt.text = value;
		}
		
		public function get text():String 
		{
			return _txt.text;
		}
		
		public function set restrict(value:String):void 
		{
			_txt.restrict = value;
		}
		
		public function get textField():TextField 
		{
			return _txt;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as Sprite;
			resetXY(_ui);
			this.addChild(_ui);
			_txt = _ui.getChildByName("num_txt") as TextField;
			_txt.multiline = false;
			_txt.type = TextFieldType.INPUT;
			_upBtn = _ui.getChildByName("up_btn") as SimpleButton;
			_downBtn = _ui.getChildByName("down_btn") as SimpleButton;
			initWhenDone();
		}
		
		protected function initWhenDone():void
		{
			value = 0;
			restrict = "0-9 . \\-";
			maxChars = 5;
			_txt.addEventListener(FocusEvent.FOCUS_OUT,checkNum);
			_txt.addEventListener(Event.CHANGE,onTextChange);
			_upBtn.addEventListener(MouseEvent.CLICK,addNum);
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,upFrame);
			_downBtn.addEventListener(MouseEvent.CLICK,lessNum);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,downFrame);
			_downBtn.useHandCursor = false;
			_upBtn.useHandCursor = false;
		}
		
		protected function onTextChange(event:Event):void
		{
			checkBtnAble();
			if(_inputCheckLaterTime > 0){
				clearTimeout(_inputCheckLaterTimeID);
				_inputCheckLaterTimeID = setTimeout(checkNum,_inputCheckLaterTime);
			}else{
				checkNum();
			}
		}
		
		public function set maxChars(value:int):void
		{
			_txt.maxChars = value;
		}
		
		public function get maxChars():int
		{
			return _txt.maxChars;
		}
		
		public function get divisor():uint
		{
			return _divisor;
		}
		
		/**
		 * 小数点后精确到多少位，如10精确到0.1（以0.1为单位），如100精确到0.01 
		 * @param valueDi
		 * 
		 */
		public function set divisor(valueDi:uint):void
		{
			_divisor = valueDi;
			value = value;
		}
		
		public function get upClickButton():SimpleButton
		{
			return _upBtn;
		}
		
		public function get downClickButton():SimpleButton
		{
			return _downBtn;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value*divisor;
			checkNum();
		}
		
		public function get maximum():Number
		{
			return _maximum/divisor;
		}
		
		public function set minimum(value:Number):void
		{
			_minimum = value*divisor;
			if(value<0){
				_txt.restrict = "0-9 . \\-";
			}else{
				_txt.restrict = "0-9 .";
			}
			checkNum();
		}
		
		public function get minimum():Number
		{
			return _minimum/divisor;
		}
		
		public function set value(va:Number):void
		{
			va = va *divisor;
			_txt.text = Number(va/_divisor).toFixed(String(divisor).length-1);
			if(_txt.text == "0."){
				_txt.text = "0";
			}
			checkBtnAble();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():Number
		{
			return Number(_txt.text);
		}
		
		protected function upFrame(event:MouseEvent):void
		{
			clearTimeout(_id);
			_id = setTimeout(upFrameMain,500);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,clearUpFrame);
		}
		
		protected function upFrameMain():void
		{
			_count =0;
			if(this.stage == null) return;
//			this.addEventListener(Event.ENTER_FRAME,addByFrame);
			UpdateManager.Instance.framePer.regFunc(addByFrame);

		}
		
		protected function clearUpFrame(event:MouseEvent):void
		{
//			this.removeEventListener(Event.ENTER_FRAME,addByFrame);
			UpdateManager.Instance.framePer.delFunc(addByFrame);
			clearTimeout(_id);
			if(this.stage == null) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,clearUpFrame);
		}
		
		protected function addByFrame(event:Event=null):void
		{
			_count ++;
			if(_count>1){
				_count = 0;
				addNum();
			}
		}
		
		protected function downFrame(event:MouseEvent):void
		{
			clearTimeout(_id);
			_id = setTimeout(downFrameMain,500);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,cleardownFrame);
		}
		
		protected function downFrameMain():void
		{
			_count =0;
			if(this.stage == null) return;
//			this.addEventListener(Event.ENTER_FRAME,lessByFrame);
			UpdateManager.Instance.framePer.regFunc(lessByFrame);
		}
		
		protected function cleardownFrame(event:MouseEvent):void
		{
//			this.removeEventListener(Event.ENTER_FRAME,lessByFrame);
			UpdateManager.Instance.framePer.delFunc(lessByFrame);
			clearTimeout(_id);
			if(this.stage == null) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,cleardownFrame);
		}
		
		protected function lessByFrame(event:Event=null):void
		{
			_count ++;
			if(_count>1){
				_count = 0;
				lessNum();
			}
		}
		
		public function addNum(event:MouseEvent=null):void
		{
			var va:Number = Number(_txt.text)*divisor;
			va += stepSize;
			if( va>_maximum ){
				va = _maximum;
			}
			_txt.text = Number(va/divisor).toFixed(String(divisor).length-1);
			if(_txt.text == "0."){
				_txt.text = "0";
			}
			checkBtnAble();
			if(event != null) {
				clearTimeout(_id);
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function checkBtnAble():void
		{
			if(value >= _maximum){
				UI.setEnable(_upBtn,false);
			}else{
				UI.setEnable(_upBtn,true);
			}
			if(value <= _minimum){
				UI.setEnable(_downBtn,false);
			}else{
				UI.setEnable(_downBtn,true);
			}
		}
		
		public function lessNum(event:MouseEvent=null):void
		{
			var va:Number = Number(_txt.text)*divisor;
			va -= stepSize;
			if(va<_minimum ){
				va = _minimum;
			}
			_txt.text = Number(va/divisor).toFixed(String(divisor).length-1);
			if(_txt.text == "0.") {
				_txt.text = "0";
			}
			checkBtnAble();
			if(event != null) {
				clearTimeout(_id);
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function setSize(newWidth:Number, newHeight:Number):void
		{
			super.setSize(newWidth,newHeight);
		}
		
		protected function checkNum(event:Event=null):void
		{
			_txt.text = Number(_txt.text).toFixed(String(divisor).length-1);
			if(Number(_txt.text)> _maximum/divisor){
				_txt.text = Number(_maximum/divisor).toFixed(String(divisor).length-1);
			}
			if(Number(_txt.text)< _minimum/divisor){
				_txt.text = Number(_minimum/divisor).toFixed(String(divisor).length-1);
			}
			if(_txt.text == "0.") _txt.text = "0";
			checkBtnAble();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
	}
}