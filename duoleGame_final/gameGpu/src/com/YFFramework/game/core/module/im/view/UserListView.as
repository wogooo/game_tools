package com.YFFramework.game.core.module.im.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildInvitePlayerVo;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.view.render.IMNodeRender;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.rank.view.ShowDetailPanelManager;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;

	/** 面板列表  对应   好友面板   IMUI   元件中的 view1  view2  view3  view4  面板 
	 * PS:此类已经弃用，现在用的是AbsUserListView
	 * @author yefeng
	 * 2013 2013-6-21 下午5:05:18 
	 */
	public class UserListView
	{
		private var _list:List;
		/**下拉菜单
		 */		
		private var _menu:Menu;
		/**单击后 等这么长时间才会显示
		 */		
		private var _menuShowTime:TimeOut;
		public function UserListView(ui:Sprite,listName:String)
		{
			_list = Xdis.getChild(ui,"all_list");
			_list.itemRender=IMNodeRender;
			
			initMenu();
			_list.addEventListener(Event.CHANGE,onListChange);
			//设置双击
			_list.dbClickCall=listDBClick;
			_list.canDBClick=true;
			
			
		
		}
		/**添加玩家
		 */		
		private function addRole(data:IMDyVo):void
		{
			_list.addItem(data);
		}
		/**
		 * 删除玩家 
		 */		
		private function removeRole(data:IMDyVo):void
		{
			_list.removeItem(data);
		}
		/**清空所有的数据
		 */		
		public function clearAll():void
		{
			_list.removeAll();
		}
		/** 根据数据刷新 所有的UI 
		 * arr 保存的是 IMDyVo 数据
		 */		
		public function updateView(arr:Array):void
		{
			clearAll();
			var len:int=arr.length;
			var imDyVo:IMDyVo;
			for(var i:int=0;i!=len;++i)
			{
				imDyVo=arr[i];
				addRole(imDyVo);
			}
		}
		
		
		
		
		/**初始化菜单
		 */		
		private function initMenu():void
		{
			_menu=new Menu();
			_menu.addItem("私聊",onMenuClick);
			_menu.addItem("删除",onMenuClick);
			_menu.addItem("黑名单",onMenuClick);
			_menu.addItem("观察",onMenuClick);
			_menu.addItem("组队",onMenuClick);
			_menu.addItem("复制姓名",onMenuClick);
			_menu.addItem("邀请入会",onMenuClick);
			
		}
		
		private function onListChange(e:Event):void
		{
		//	_menu.show();
			if(_menuShowTime)_menuShowTime.dispose();
			_menuShowTime=new TimeOut(200,_menu.show);
			_menuShowTime.start();
		}
		/** list Item 双击回调
		 */		
		private function listDBClick(imDyVo:IMDyVo):void
		{
			_menuShowTime.dispose();
			var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
			privateTalkPlayerVo.dyId=imDyVo.dyId;
			privateTalkPlayerVo.name=imDyVo.name;
			privateTalkPlayerVo.sex=imDyVo.sex;
			privateTalkPlayerVo.vipLevel=imDyVo.vipLevel;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);  //进行私聊
		}
		/**下拉菜单响应 
		 * @param index   下拉菜单的 响应索引   对应的菜单索引        私聊  删除  黑名单  观察  密语  组队  复制姓名  邀请入会
		 * @param label    对应的菜单文本
		 */		
		private function onMenuClick(index:uint,label:String):void
		{
			var imDyVo:IMDyVo=_list.selectedItem as IMDyVo;
			switch(index)
			{
				case 0:  				//私聊
					var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
					privateTalkPlayerVo.dyId=imDyVo.dyId;
					privateTalkPlayerVo.name=imDyVo.name;
					privateTalkPlayerVo.sex=imDyVo.sex;
					privateTalkPlayerVo.vipLevel=imDyVo.vipLevel;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);  //进行私聊
					break;
				case 1:				//   删除
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_DeleteFriend,imDyVo);  //进行私聊
					break;	
				case 2:				//黑名单
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddToBlackList,imDyVo.dyId);
					break;
				case 3:			//观察
					ShowDetailPanelManager.instance.characterReq(imDyVo.dyId);
					break;
				case 4:				//	组队
					var roleDyVo:RoleDyVo=new RoleDyVo;
					roleDyVo.dyId=imDyVo.dyId;
					roleDyVo.roleName=imDyVo.name;
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.InviteReq,roleDyVo);	
					break;
				case 5:				//复制姓名
					System.setClipboard(imDyVo.name);
					break;
				case 6:				//邀请入会
					var player:GuildInvitePlayerVo=new GuildInvitePlayerVo;
					player.dyId=imDyVo.dyId;
					player.lv=imDyVo.level;
					player.guildName=imDyVo.guild;
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.InvatePlayer,player);
					break;
			}
		}
		
	}
}