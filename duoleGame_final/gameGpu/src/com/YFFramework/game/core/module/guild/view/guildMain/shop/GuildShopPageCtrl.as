package com.YFFramework.game.core.module.guild.view.guildMain.shop
{
	import com.YFFramework.game.core.module.guild.view.GuildNormalPage;
	
	import flash.display.Sprite;
	
	/***
	 *
	 *@author ludingchang 时间：2013-9-14 下午3:34:41
	 */
	public class GuildShopPageCtrl extends GuildNormalPage
	{
		public function GuildShopPageCtrl(view:Sprite)
		{
			super(view);
		}
		
		override protected function initPageList():void
		{
			_pageList=new GuildShopItemList;
		}
		
		override protected function getMaxCount():int
		{
			return 9;
		}
	}
}