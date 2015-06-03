package com.YFFramework.game.core.module.im.view
{
	/**@author yefeng
	 * 2013 2013-6-27 下午6:10:47 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildInvitePlayerVo;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.dolo.ui.controls.Menu;
	
	import flash.display.Sprite;
	import flash.system.System;
	
	public class FriendListView extends AbsUserListView
	{
		public function FriendListView(ui:Sprite, listName:String)
		{
			super(ui, listName);
			
		}
		
		override protected function initMenu():void
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
//					privateTalkPlayerVo.vipLevel=imDyVo.vipLevel;

					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);  //进行私聊
					break;
				case 1:				//   删除
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_DeleteFriend,imDyVo);  //进行私聊
					break;	
				case 2:				//黑名单
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddToBlackList,imDyVo.dyId);
					break;
				case 3:			//观察
					ModuleManager.rankModule.otherPlayerReq(imDyVo.dyId);
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