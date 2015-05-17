package com.dolo.ui.controls
{
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * 基本按钮 
	 * @author flashk
	 */
	public class Button extends UIComponent
	{
		public static var defaultUseHandCursor:Boolean = false;
		public static var defaultTextColors:ButtonTextStyle = new ButtonTextStyle();
		public static var isOtherButtonMouseDown:Boolean = false;
		
		protected var _txt:TextField;
		protected var _label:String;
		protected var _ui:Sprite;
		protected var _colors:ButtonTextStyle;
		protected var _simBtn:SimpleButton;
		protected var _isMeDown:Boolean = false;
		protected var _timeOutID:int = -1;
		protected var _lastTimeOutTime:int;
		protected var _laterTime:int;
		protected var _bakLabel:String;
		protected var _startTime:int;
		protected var _textApped:String;
		protected var _formatValue:int;
		
		public function Button()
		{
			
		}
		
		public function get textField():TextField
		{
			return _txt;
		}
		
		public function set icon(iconDis:DisplayObject):void
		{
			this.addChild(iconDis);
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
			_bakLabel = _label;
			if(_txt){
				_txt.htmlText = _label;
			}
		}
		
		/**
		 * 增加鼠标点击事件侦听 
		 * @param listener
		 * 
		 */
		public function addMouseClickEventListener(listener:Function):void
		{
			this.addEventListener(MouseEvent.CLICK,listener);
		}
		
		public function removeMouseClickEventListener(listener:Function):void
		{
			this.removeEventListener(MouseEvent.CLICK,listener);
		}
		
		public function changeTextColor(colors:ButtonTextStyle):void
		{
			_colors = colors;
			showOut();
		}
		
		/**
		 * CD按钮 
		 * @param laterTime 毫秒
		 * @param textAppend 后面追加文字格式，如"(*)",星号会被替换为数字，如显示成 整理(5) 
		 * @param formatValue 数字的精确度，1为秒，2为0.1秒
		 * 
		 */
		public function disableAndAbleLater(laterTime:int,textAppend:String="$*",formatValue:int=1):void
		{
			enabled = false;
			_startTime = getTimer();
			if(_timeOutID == -1){
				_laterTime = laterTime;
				_lastTimeOutTime = getTimer();
				_timeOutID = 50;
			}else{
				_laterTime = _laterTime-(getTimer()-_lastTimeOutTime)+laterTime;
				_lastTimeOutTime = getTimer();
				_timeOutID = 50;
			}
			_bakLabel = label;
			_textApped = textAppend;
			_formatValue = formatValue;
			this.addEventListener(Event.ENTER_FRAME,updateLabel);
		}
		
		public function clearCDUpdate():void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateLabel);
		}
		
		public function startCDUpdate():void
		{
			this.addEventListener(Event.ENTER_FRAME,updateLabel);
		}
		
		/**重新获取CD时间，重新得到按钮的CD状态
		 * @return Boolean	按钮是否还在CD中
		 */		
		public function resetCD():Boolean
		{
			var t:int = getTimer();
			if(_lastTimeOutTime+_laterTime > t){
				startCDUpdate();
				enabled = false;
				return true;
			}else
			{
				setAbleLater();
				return false;
			}
		}
		
		public function stopDisable():void
		{
			setAbleLater();
		}
		
		protected function updateLabel(event:Event):void
		{
			var t:int = _laterTime-(getTimer()-_startTime);
			var v:Number;
			var vstr:String;
			if(t<0){
				t = 0;
			}
			if(_formatValue == 1){
				v = Math.ceil(t/1000);
				vstr = _textApped.replace("*",v);
				vstr = vstr.replace("$",_bakLabel);
			}else{
				v = Math.ceil(t/100)/10;
				vstr = _textApped.replace("*",v.toFixed(1));
				vstr = vstr.replace("$",_bakLabel);
			}
			if(_txt){
				_txt.htmlText = vstr;
			}
			if(t==0){
				setAbleLater();
			}
		}
		
		public function showAsNoCDLabel():void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateLabel);
		}
		
		protected function setAbleLater():void
		{
			enabled = true;
			this.removeEventListener(Event.ENTER_FRAME,updateLabel);
			label = _bakLabel;
			clearTimeout(_timeOutID);
			_timeOutID = -1;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			var skinDis:Sprite = skin as Sprite;
			if(skinDis == null) {
				this.addChild(skin);
				return;
			}
			_ui = skinDis;
			_ui.mouseEnabled = false;
			changeTextColor(defaultTextColors);
			_txt = skinDis.getChildByName("label_txt") as TextField;
			if(_label != null){
				label = _label;
			}
			if(_txt){
				_txt.mouseEnabled = false;
				showOut();
			}
			this.x = int(_ui.x);
			this.y = int(_ui.y);
			_ui.x = 0;
			_ui.y = 0;
			this.addChild(_ui);
			if(defaultUseHandCursor == false){
				var len:int = _ui.numChildren;
				for(var i:int=0;i<len;i++){
					var simBtn:SimpleButton = _ui.getChildAt(i) as SimpleButton;
					if(simBtn){
						simBtn.useHandCursor = false;
						_simBtn = simBtn;
						_simBtn.addEventListener(MouseEvent.MOUSE_OVER,showOver);
						_simBtn.addEventListener(MouseEvent.MOUSE_OUT,showOut);
						_simBtn.addEventListener(MouseEvent.MOUSE_DOWN,showDown);
						break;
					}
				}
			}
		}
		
		protected function showDown(event:MouseEvent=null):void
		{
			_txt.textColor = _colors.downColor;
			if(_simBtn == null) return;
			_isMeDown = true;
			isOtherButtonMouseDown = true;
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onUserMouseUp);
		}
		
		protected function onUserMouseUp(event:MouseEvent):void
		{
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onUserMouseUp);
			_isMeDown = false;
			isOtherButtonMouseDown = false;
			if(_simBtn == null) return;
			if(_simBtn.hitTestPoint(UI.stage.mouseX,UI.stage.mouseY,true) == true){
				showOver();
			}else{
				showOut();
			}
		}
		
		protected function showOut(event:MouseEvent=null):void
		{
			if(_isMeDown == false){
				UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onUserMouseUp);
			}
			if(_txt){
				if(_isMeDown == false){
					_txt.textColor = _colors.outColor;
				}else{
					_txt.textColor = _colors.overColor;
				}
			}
		}
		
		protected function showOver(event:MouseEvent=null):void
		{
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onUserMouseUp);
			if(_isMeDown == false && isOtherButtonMouseDown == true) return;
			if(_isMeDown == false && UI.isUserMouseDown == true) return;
			if(_isMeDown == false){
				_txt.textColor = _colors.overColor;
			}else{
				_txt.textColor = _colors.downColor;
			}
		}
		
		public static function creatNewButton(label:String):Button
		{
			var btn:Button = new Button();
			var sp:Sprite = LibraryCreat.getSprite("ShareUIButtonSkinDefault");
			btn.targetSkin(sp);
			btn.label = label;
			return btn;
		}
		
	}
}