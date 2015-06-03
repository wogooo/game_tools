package com.YFFramework.game.core.module.guild.view.otherGuilds
{
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.OtherGuildListVo;
	
	import flash.display.Sprite;
	
	/***
	 *其他公会页
	 *@author ludingchang 时间：2013-7-22 下午1:12:32
	 */
	public class GuildOtherView  
	{
		private var _page:GuildOtherPageCtrl;
		public function GuildOtherView(view:Sprite)
		{
			_page=new GuildOtherPageCtrl(view);
			_page.resetTxt();
		}
		public function update():void
		{
			var vo:OtherGuildListVo=GuildInfoManager.Instence.otherGuildList;
			if(vo==null)
			{
				_page.updateList([]);
				_page.setPage(1,1);
			}
			else
			{
				_page.updateList(vo.guild_list);
				_page.setPage(vo.current_page,vo.total_page);
			}
		}
		public function dispose():void
		{
			_page=null;
		}
	}
}