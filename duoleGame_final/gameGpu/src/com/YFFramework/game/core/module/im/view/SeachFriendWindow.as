package com.YFFramework.game.core.module.im.view
{
	/**@author yefeng
	 * 2013 2013-6-28 下午6:10:05 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**搜索好友 面板
	 */	
	public class SeachFriendWindow extends PopMiniWindow
	{
		/** flash链接名ui 
		 */		
		private var _ui:Sprite;
		/**搜索好友
		 */		
		private var _addFriendBtn:Button;
		/**输入文本
		 */		
		private var _inputTxt:TextField;
		public function SeachFriendWindow()
		{
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
			_ui=initByArgument(285,95,"skin_SeachFriend",WindowTittleName.LookUp);
			_addFriendBtn=Xdis.getChild(_ui,"addFriend_button");
			_inputTxt=Xdis.getChild(_ui,"inputTxt");//输入文本
			_inputTxt.maxChars=6;
		}
		private function addEvents():void
		{
			_addFriendBtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function removeEvents():void
		{
			_addFriendBtn.removeEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			var privateRequestVo:PrivateTalkPlayerVo=new  PrivateTalkPlayerVo(); 
			privateRequestVo.name=StringUtil.trim(_inputTxt.text);
			YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddFriend,privateRequestVo);
			_inputTxt.text="";
			close();
		}
		override public function dispose():void
		{
			super.dispose();
			_ui=null;
			_addFriendBtn=null;
			_inputTxt.text="";
			_inputTxt=null;
		}
		
	}
}