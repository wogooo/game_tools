package com.YFFramework.game.core.module.im.view
{
	/**@author yefeng
	 * 2013 2013-6-22 下午5:18:11 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.manager.RequestFriendManager;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.YFFramework.game.core.module.im.view.render.FriendListRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	
	/** 请求好友列表 窗口  点击小图标打开的 请求好友列表窗口
	 */	
	public class FriendListWindow extends PopMiniWindow
	{
		private var _mc:Sprite;
		private var _list:List;

		public function FriendListWindow()
		{
			super();
			_mc = initByArgument(369,345,"invitePanel");
			_list = Xdis.getChild(_mc,"invite_list");
			_list.itemRender = FriendListRender;
			YFEventCenter.Instance.addEventListener(IMEvent.CheckCloseFriendListWindow,onCheckCloseWindow);
		}
		/**检测是否可以关闭  窗口
		 */		
		private function onCheckCloseWindow(e:YFEvent):void
		{
			if(_list.length==0)	
			{
				this.close();
				RequestFriendManager.Instance.clear();
			}
		}
		
		public function updateView():void
		{
			_list.removeAll();
			var item:RequestFriendVo;
			var idArr:Array=RequestFriendManager.Instance.getArray();
			var len:int=idArr.length;
			for(var i:int=0;i<len;i++){
				item = RequestFriendManager.Instance.getRole(idArr[i]);
				_list.addItem(item);
			}
			

		}
	}
}