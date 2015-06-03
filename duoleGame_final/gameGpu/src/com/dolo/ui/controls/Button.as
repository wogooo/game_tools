package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.skin.ButtonSkin;
	import com.dolo.ui.skin.SkinLinkages;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;

	/**基本按钮 ，按钮默认有1秒的点击CD，以避免双击重复生成Click事件引起重复发送协议之类bug，可以通过autoDisableMouse关闭或者autoDisableMouseCD设置这个时间
	 * @author flashk
	 */
	public class Button extends BitmapButton{
		
		public static var defaultUseHandCursor:Boolean = false;
		public static var defaultTextColors:ButtonTextStyle = new ButtonTextStyle();
		public static var isOtherButtonMouseDown:Boolean = false;
		
		protected var _txt:TextField;
		protected var _label:String;
		protected var _ui:Sprite;
		/** 按钮默认，无点击的颜色是黑色；按钮的颜色是程序控制，如要更改调用changeTextColor方法
		 */		
		protected var _colors:ButtonTextStyle;
		protected var _simBtn:SimpleButton;
		protected var _isMeDown:Boolean = false;
		protected var _autoDisableMouse:Boolean = false;
		protected var _autoDisableMouseCD:int = 700;
		protected var _timeOut:TimeOut;
		protected var _lastClickTime:int=0;
		protected var _isTargetSkin:Boolean = false;
		
		protected var _STStartTime:int=0;
		protected var _STCDTime:int=0;
		protected var _STCDViewable:Boolean=true;
		protected var _STBackupTxt:String;
		protected var _STViewStyle:int;
		protected var _STAbleLater:Boolean=true;
		
		/**倒计时结束后的回调
		 */
		public var timeOutCall:Function;
		public function Button(){
			this.addEventListener( MouseEvent.CLICK, onClickMe );
		}
		
		public function disableText():void{
			if(_txt)
				_txt.mouseEnabled=false;
		}
		
		override public function dispose():void{
			super.dispose ();
			_txt = null;
			_label = null;
			_ui = null;
			_colors = null;
			_simBtn = null;
			this.removeEventListener( MouseEvent.CLICK, onClickMe );
			UI.stage.removeEventListener( MouseEvent.MOUSE_UP, onUserMouseUp );
		}
		
		public static function creatNewButton(label:String):Button{
			var btn:Button = new Button();
			var sp:Sprite ;
			if(label.length <= 3)
				sp = LibraryCreat.getSprite( SkinLinkages.DEFAULT_BUTTON );
			else
				sp = LibraryCreat.getSprite( SkinLinkages.LONG_BUTTON );
			btn.targetSkin( sp );
			btn.label = label;
			return btn;
		}
		
		public function get autoDisableMouseCD():int{
			return _autoDisableMouseCD;
		}

		/**是否自动用户点击之后在某个时间内禁止鼠标事件 CD的时间 （毫秒）
		 * @param value
		 */
		public function set autoDisableMouseCD(value:int):void{
			_autoDisableMouseCD = value;
		}

		public function get autoDisableMouse():Boolean{
			return _autoDisableMouse;
		}

		/**是否自动用户点击之后在某个时间内禁止鼠标事件 
		 * @param value
		 */
		public function set autoDisableMouse(value:Boolean):void{
			_autoDisableMouse = value;
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled = value;
			if( _autoDisableMouse && getTimer() -_lastClickTime < _autoDisableMouseCD ){
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}
		}
		
		public function stopAutoDisableMouseNow():void{
			ableMyMouse();
		}
		
		/**返回文本框的实例 
		 * @return 
		 */
		public function get textField():TextField{
			return _txt;
		}
		
		public function set textField(t:TextField):void{
			var textFormat:TextFormat=t.getTextFormat();
			if(_txt)
				_txt.defaultTextFormat=textFormat;
		}
		
		/**设置图标 
		 * @param iconDis
		 */
		public function set icon(iconDis:DisplayObject):void{
			this.addChild( iconDis );
		}

		public function get label():String{
			return _label;
		}

		/**设置按钮文本 
		 * @param values
		 */
		public function set label(value:String):void{
			_label = value;
			if( _txt )	{
				_txt.htmlText = _label;
			}
		}
		
		public function setFormat(format:TextFormat):void{
			if(_txt){
				format.align=TextFormatAlign.CENTER;
				_txt.setTextFormat(format);
			}
		}
		
		public function setTextSize(size:uint):void{
			if(_txt){
				var tf:TextFormat=_txt.getTextFormat();
				tf.size=size;
				_txt.setTextFormat(tf);
			}
		}
		/**增加鼠标点击事件侦听 
		 * @param listener
		 */
		public function addMouseClickEventListener(listener:Function):void{
			this.addEventListener( MouseEvent.CLICK, listener );
		}
		
		public function removeMouseClickEventListener(listener:Function):void{
			this.removeEventListener( MouseEvent.CLICK, listener );
		}
		
		/**更改按钮文本的各个状态颜色 
		 * @param colors
		 */
		public function changeTextColor(colors:ButtonTextStyle):void{
			_colors = colors;
			showOut ();
		}
		
		public function STAddCDTime(laterTime:int, cdViewable:Boolean, backupTxt:String=null, viewStyle:int=1):void{
			_STCDViewable = cdViewable;
			_STViewStyle = viewStyle;
			if(_STCDViewable)	enabled=false;
			else	enabled=true;
			if(backupTxt)	_STBackupTxt = backupTxt;
			else	_STBackupTxt = label;
			if(_STStartTime==0)	_STStartTime = getTimer();
			_STCDTime += laterTime;
			UpdateManager.Instance.framePer.regFunc(countDown);
		}
		
		public function getCDTime():int{
			var t:int = _STCDTime - (getTimer() - _STStartTime);
			if(t<0)	t=0;
			return t;
		}
		
		public function isCDing():Boolean{
			if(_STCDTime==0)	return false;
			else{
				var t:int = _STCDTime - (getTimer() - _STStartTime);
				if(t>0)	return true;
				else	return false;
			}
		}
		
		public function setCDViewable(viewable:Boolean):void{
			_STCDViewable = viewable;
		}
		
		public function setCDBackupTxt(backupTxt:String):void{
			_STBackupTxt = backupTxt;
		}
		
		public function setSTAbleLater(ableLater:Boolean):void{
			_STAbleLater = ableLater;
		}
		
		public function countDown():void{
			var t:int = _STCDTime - (getTimer() - _STStartTime);
			if(_STCDViewable){
				if(t>0){
					var v:Number = Math.ceil(t/1000);
					if(_STViewStyle==1)	_txt.text = _STBackupTxt + " " + v;
					else	_txt.text = String(v);
				}else{
					_txt.text = _STBackupTxt;
				}
			}
			if(t<=0){
				UpdateManager.Instance.framePer.delFunc(countDown);
				if(_STAbleLater)	enabled = true;
				_STStartTime = 0;
				_STCDTime = 0;
			}
		}
		
		protected function onClickMe(event:MouseEvent):void{
			if( _autoDisableMouse == true ){
				this.mouseChildren = false;
				this.mouseEnabled = false;
				_lastClickTime = getTimer();
				_timeOut = new TimeOut( _autoDisableMouseCD, ableMyMouse );
				_timeOut.start();
			}
		}
		
		override public function changeSkin(skin:ButtonSkin):void{
			super.changeSkin( skin );
			if( _txt == null ){
				_txt = new TextField();
				_txt.width = this.width;
				_txt.height = 19;
				_txt.y = ( this.height - _txt.height ) / 2;
				_txt.defaultTextFormat = new TextFormat( "_sans", 12, null, null, null, null, null, null, TextFormatAlign.CENTER );
				this.addChild( _txt );
				changeTextColor( defaultTextColors );
				initText();
				this.addEventListener( MouseEvent.ROLL_OVER, showOver );
				this.addEventListener( MouseEvent.ROLL_OUT, showOut );
				this.addEventListener( MouseEvent.MOUSE_DOWN, showDown );
			}
		}
		
		private function ableMyMouse(obj:Object=null):void{
			if( _enabled == true ){
				this.mouseChildren = true;
				this.mouseEnabled = true;
				if(timeOutCall!=null)timeOutCall();
			}
		}
		
		private function initText():void{
			if( _label != null )	label = _label;
			if( _txt ){
				_txt.mouseEnabled = false;
				showOut ();
			}
		}
		
		override public function targetSkin(skin:DisplayObject):void{
			_isTargetSkin = true;
			var skinDis:Sprite = skin as Sprite;
			if( skinDis == null ) {
				this.addChild( skin );
				return;
			}
			_ui = skinDis;
			_ui.mouseEnabled = false;
			changeTextColor( defaultTextColors );
			_txt = skinDis.getChildByName( "label_txt" ) as TextField;
			initText ();
			this.x = int( _ui.x );
			this.y = int( _ui.y );
			_ui.x = 0;
			_ui.y = 0;
			this.addChild( _ui );
			if( defaultUseHandCursor == false ){
				var len:int = _ui.numChildren;
				for( var i:int=0; i<len; i++ ){
					var simBtn:SimpleButton = _ui.getChildAt( i ) as SimpleButton;
					if( simBtn ){
						simBtn.useHandCursor = false;
						_simBtn = simBtn;
						_simBtn.addEventListener( MouseEvent.MOUSE_OVER, showOver );
						_simBtn.addEventListener( MouseEvent.MOUSE_OUT, showOut );
						_simBtn.addEventListener( MouseEvent.MOUSE_DOWN, showDown );
						break;
					}
				}
			}
		}
		
		protected function showDown(event:MouseEvent=null):void{
			if(_txt)
				_txt.textColor = _colors.downColor;
			if( _simBtn == null ) return;
			_isMeDown = true;
			isOtherButtonMouseDown = true;
			UI.stage.addEventListener( MouseEvent.MOUSE_UP, onUserMouseUp );
		}
		
		protected function onUserMouseUp(event:MouseEvent):void{
			UI.stage.removeEventListener( MouseEvent.MOUSE_UP, onUserMouseUp );
			_isMeDown = false;
			isOtherButtonMouseDown = false;
			if( _simBtn == null ) return;
			if(_simBtn.hitTestPoint(UI.stage.mouseX, UI.stage.mouseY, true)==true)	showOver ();
			else	showOut ();
		}
		
		protected function showOut(event:MouseEvent=null):void{
			if(_isMeDown == false)	UI.stage.removeEventListener( MouseEvent.MOUSE_UP, onUserMouseUp );
			if( _txt ){
				if(_isMeDown==false)	_txt.textColor = _colors.outColor;
				else	_txt.textColor = _colors.overColor;
			}
		}
		
		protected function showOver(event:MouseEvent=null):void{
			UI.stage.addEventListener( MouseEvent.MOUSE_UP, onUserMouseUp );
			if( _isTargetSkin && _isMeDown == false && isOtherButtonMouseDown == true ) return;
			if( _isTargetSkin && _isMeDown == false && UI.isUserMouseDown == true ) return;
			if(_isMeDown == false || _isTargetSkin == false){
				if(_txt)
					_txt.textColor = _colors.overColor;
			}
			else
			{
				if(_txt)
					_txt.textColor = _colors.downColor;
			}
		}
		
	}
}