package com.YFFramework.core.center.manager.keyboard
{
	/**  键盘事件
	 * 2012-7-10
	 *	@author yefeng
	 */
	public class KeyBoardItem
	{
		
		private var _upFunc:Function;
		private var _downFunc:Function;
		
		private var _keyCode:int;
		public function KeyBoardItem(keyCode:int,downFunc:Function,upFunc:Function=null)
		{
			_upFunc=upFunc;
			_downFunc=downFunc;
			_keyCode=keyCode;
			if(_downFunc!=null) KeyboardManager.Instance.regDownKeyCode(keyCode,downFunc);
			if(_upFunc!=null)	KeyboardManager.Instance.regUpKeyCode(keyCode,upFunc);
		}
		
		public function dispose():void
		{
			if(_downFunc!=null) KeyboardManager.Instance.delDownKeyCode(_keyCode,_downFunc);
			if(_upFunc!=null)	KeyboardManager.Instance.delUpKeyCode(_keyCode,_upFunc);
			_upFunc=null;
			_downFunc=null;
		}
		
	}
}