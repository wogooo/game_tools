package com.YFFramework.game.core.module.guild.view
{
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/***
	 *需要用户输入的文本框<br>
	 * 用户点击的时候置空，丢失焦点的时候判断是否文空，空则设为默认状态
	 *@author ludingchang 时间：2013-7-31 上午11:31:07
	 */
	public class InputText
	{
		private var _txt:TextField;
		private var _defStr:String;
		private var _isClear:Boolean;
		
		private var _txtColor:uint;
		private var _defaultColor:uint=0x88888888;
		
		public var isSelected:Boolean;
		/**
		 * 构造函数
		 * @param txt：文本引用
		 * @param str：默认文字
		 * @param isClear:点击时是否置空
		 */		
		public function InputText(txt:TextField,str:String,isClear:Boolean=true)
		{
			_txt=txt;
			_defStr=str;
			_isClear=isClear;
			_txtColor=txt.textColor;
			_txt.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			reset();
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			if(_txt.text=="")
				reset();
		}
		public function reset():void
		{
			_txt.addEventListener(TextEvent.TEXT_INPUT,onTxtInput);
			_txt.text=_defStr;
			_txt.textColor=_defaultColor;
			isSelected=false;
			if(_isClear)
				_txt.addEventListener(MouseEvent.CLICK,onTxtClick);
		}
		
		protected function onTxtClick(event:MouseEvent):void
		{
			if(!isSelected)
			{
				_txt.text="";
				_txt.textColor=_txtColor;
				_txt.removeEventListener(MouseEvent.CLICK,onTxtClick);
			}
		}
		
		protected function onTxtInput(event:TextEvent):void
		{
			isSelected=true;
			_txt.textColor=_txtColor;
			_txt.removeEventListener(TextEvent.TEXT_INPUT,onTxtInput);
		}
		/**文本字段*/
		public function get text():String
		{
			return _txt.text;
		}
		public function set text(str:String):void
		{
			_txt.text=str;
		}
		public function setMaxChars(c:int):void
		{
			_txt.maxChars=c;
		}
		/**设置默认文本*/
		public function changeDefStr(str:String):void
		{
			_defStr=str;
			reset();
		}
	}
}