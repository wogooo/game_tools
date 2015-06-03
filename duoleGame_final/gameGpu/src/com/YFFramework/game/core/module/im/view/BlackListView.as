package com.YFFramework.game.core.module.im.view
{
	/**@author yefeng
	 * 2013 2013-6-27 下午6:12:59 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.dolo.ui.controls.Menu;
	
	import flash.display.Sprite;
	import flash.system.System;
	
	public class BlackListView extends AbsUserListView
	{
		public function BlackListView(ui:Sprite, listName:String)
		{
			super(ui, listName);
		}
		
		override protected function initListDB():void
		{
			_list.canDBClick=false;
		}

		/**初始化菜单  删除 好友 观察 组队 复制姓名 邀请入会
		 */		
		override protected function initMenu():void
		{
			_menu=new Menu();
			_menu.addItem("删除",onMenuClick);
//			_menu.addItem("好友",onMenuClick);
			_menu.addItem("观察",onMenuClick);
//			_menu.addItem("组队",onMenuClick);
			_menu.addItem("复制姓名",onMenuClick);
//			_menu.addItem("邀请入会",onMenuClick);

		}
		private function onMenuClick(index:uint,label:String):void
		{
			var imDyVo:IMDyVo=_list.selectedItem as IMDyVo;
			switch(index)
			{
				case 0:  //删除
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_DeleteBlackList,imDyVo.dyId);
					break;
				case 1:		//观察
					ModuleManager.rankModule.otherPlayerReq(imDyVo.dyId);
					break;
				case 2:		//复制姓名
					System.setClipboard(imDyVo.name);
					break;	
			}
		}
	}
}