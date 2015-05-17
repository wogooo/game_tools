package com.YFFramework.game.core.module.login.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**网站id登录
	 */	
	public class LoignCheckUI extends AbsView
	{
		private var _mc:MovieClip;
		public function LoignCheckUI()
		{
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_mc=ClassInstance.getInstance("loginUI_checkLoginView");
			addChild(_mc);
			TextField(_mc.txt).restrict="A-Z 0-9 a-z";
			var name:String=ShareObjectManager.Instance.getString("testName");
			if(name)TextField(_mc.txt).text=name;

		}
		override protected function addEvents():void
		{
			super.addEvents();
			_mc.okBtn.addEventListener(MouseEvent.CLICK,onClick);
//			_mc.cancelBtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _mc.okBtn:
					var checkname:String=StringUtil.trim(_mc.txt.text);
					YFEventCenter.Instance.dispatchEventWith(LoginEvent.C_CheckLogin,checkname);
					
					ShareObjectManager.Instance.put("testName",TextField(_mc.txt).text);
					break;
//				case _mc.cancelBtn:
//					break;
			}
		}
		
		
	}
}