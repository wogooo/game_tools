package com.YFFramework.game.core.module.friends
{
	/**@author yefeng
	 *2012-8-21下午10:24:33
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.friends.view.FriendsWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModuleFriends extends AbsModule
	{
		protected var _friendsWindow:FriendsWindow;
		public function ModuleFriends()
		{
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function show():void
		{
			_friendsWindow=new FriendsWindow();
			addEvents();
		}
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.FriendUIClick,onFriendClick);
		}
		private function onFriendClick(e:YFEvent):void
		{
			_friendsWindow.toggle();
		}
		
	}
}