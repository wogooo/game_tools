package com.YFFramework.game.core.module.guild.view.guildMain.building
{
	import com.YFFramework.game.core.module.guild.view.GuildNormalPage;
	
	import flash.display.Sprite;
	
	/***
	 *
	 *@author ludingchang 时间：2014-1-15 上午9:32:49
	 */
	public class GuildBuildPageCtrl extends GuildNormalPage
	{
		public function GuildBuildPageCtrl(view:Sprite)
		{
			super(view);
		}
		
		override protected function initPageList():void
		{
			_pageList=new GuildBuildItemList;
		}
		
		override protected function getMaxCount():int
		{
			return 4;
		}
	}
}