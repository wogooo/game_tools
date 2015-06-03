package com.YFFramework.game.core.module.chat.view
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	/**
	 * 快捷输入历史 
	 * @author flashk
	 */
	public class TextInputKeyHistroy{
		
		/**最大记录数 
		 */
		private var _max:int = 10;
		private var _txt:TextField;
		private var _his:Array = [];
		private var _keyUpCode:int = Keyboard.UP;
		private var _keyDownCode:int = Keyboard.DOWN;
		private var _index:int = 0;
		private var _isSelectAll:Boolean = true;
		
		public function TextInputKeyHistroy(target:TextField,isKeyDown:Boolean=false)
		{
			_txt = target;
			if(isKeyDown){
				_txt.addEventListener(KeyboardEvent.KEY_DOWN,onTxtKeyGetEvent);
			}else{
				_txt.addEventListener(KeyboardEvent.KEY_UP,onTxtKeyGetEvent);
			}
		}
		
		public function get isSelectAll():Boolean
		{
			return _isSelectAll;
		}

		public function set isSelectAll(value:Boolean):void
		{
			_isSelectAll = value;
		}

		public function get keyDownCode():int
		{
			return _keyDownCode;
		}

		public function set keyDownCode(value:int):void
		{
			_keyDownCode = value;
		}

		public function get keyUpCode():int
		{
			return _keyUpCode;
		}

		public function set keyUpCode(value:int):void
		{
			_keyUpCode = value;
		}

		protected function onTxtKeyGetEvent(event:KeyboardEvent):void
		{
			if(event.keyCode == _keyUpCode){
				if(_index>0){
					_index--;
				}else{
					_index = _his.length-1;
				}
				setText();
			}else if(event.keyCode == _keyDownCode){
				if(_index<_his.length-1){
					_index++;
				}else{
					_index = 0;
				}
				setText();
			}
		}
		
		private function setText():void
		{
			if(_index>-1 && _index < _his.length){
				_txt.text = _his[_index];
			}
			if(_isSelectAll == true){
				_txt.setSelection(0,int.MAX_VALUE);
			}
		}
		
		public function get txt():TextField
		{
			return _txt;
		}

		public function get max():int
		{
			return _max;
		}

		public function set max(value:int):void
		{
			_max = value;
		}
		
		public function putInHistroy(str:String=null):void
		{
			var hisStr:String;
			if(str == null){
				hisStr = _txt.text;
			}else{
				hisStr = str;
			}
			_his.push(hisStr);
			if(_his.length > _max){
				_his.shift();
			}
			_index = _his.length;
		}

	}
}