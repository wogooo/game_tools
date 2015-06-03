package com.YFFramework.game.core.module.im.view
{
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.RadioButton;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class IMPersonalSetWindow extends Window
	{
		private static var _ins:IMPersonalSetWindow;
		
		private var _ui:Sprite;
		private var _suerButton:Button;
		private var _messageButton:Button;
		private var _myTextTxt:TextField;
		private var _myMessageMaxChars:int = 80;
		private var _ra5RadioButton:RadioButton;
		
		public function IMPersonalSetWindow()
		{
			_ui = initByArgument(328,290,"IMSetUI","个人设置");
			_suerButton = Xdis.getChild(_ui,"sure_button");
			_suerButton.changeTextColor(IMStyle.getIMButtonStyle());
			_messageButton = Xdis.getChild(_ui,"message_button");
			_messageButton.changeTextColor(IMStyle.getIMButtonStyle());
			_myTextTxt = new TextField();
			_myTextTxt.textColor = 0xFDF3AB;
			_myTextTxt.width = 260;
			_myTextTxt.height = 67;
			_myTextTxt.x = 37;
			_myTextTxt.y = 117;
			_myTextTxt.wordWrap = true;
			_myTextTxt.multiline = true;
			_myTextTxt.type = TextFieldType.INPUT;
			_myTextTxt.maxChars = _myMessageMaxChars;
			_myTextTxt.addEventListener(FocusEvent.FOCUS_IN,onMyTextFocusIn);
			_ui.addChild(_myTextTxt);
			_ra5RadioButton = Xdis.getChild(_ui,"a5_imSet_radioButton");
		}
		
		protected function onMyTextFocusIn(event:FocusEvent):void
		{
			_ra5RadioButton.selected = true;
		}
		
		public static function getInstanced():IMPersonalSetWindow
		{
			if(_ins == null){
				_ins = new IMPersonalSetWindow();
			}
			return _ins;
		}
		
	}
}