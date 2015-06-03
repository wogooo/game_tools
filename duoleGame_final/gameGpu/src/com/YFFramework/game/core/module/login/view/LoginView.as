package com.YFFramework.game.core.module.login.view
{

	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	
	import flash.events.Event;
	
	public class LoginView extends AbsView
	{
//		private var _loginCheckView:LoignCheckUI;
		public var _createHeroUI:CreateHeroUI;
		public function LoginView()
		{
//			super(400,300);
		}
		
		override protected function initUI():void
		{
			super.initUI();
//			_loginCheckView=new LoignCheckUI();
//			addChild(_loginCheckView);
//			PopUpManager.centerPopUp(this);
		}
		/**显示角色创建面板
		 */ 
		public function showCreateHeroUI():void
		{
			_createHeroUI=new CreateHeroUI();
			addChild(_createHeroUI);
//			if(contains(_loginCheckView))removeChild(_loginCheckView);
			PopUpManager.centerPopUp(this);
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			if(parent) parent.removeChild(this);
//			if(contains(_loginCheckView))removeChild(_loginCheckView);
			if(_createHeroUI)
			{
				if(contains(_createHeroUI))removeChild(_createHeroUI);
				_createHeroUI.dispose();
			}
//			_loginCheckView.dispose();
//			_loginCheckView=null;
			_createHeroUI=null;
		}
	}
}