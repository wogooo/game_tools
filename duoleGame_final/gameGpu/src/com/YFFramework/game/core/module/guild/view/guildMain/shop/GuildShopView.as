package com.YFFramework.game.core.module.guild.view.guildMain.shop
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ArrayUtil;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildInfoDownCtrl;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *公会商店页
	 *@author ludingchang 时间：2013-8-3 下午1:13:39
	 */
	public class GuildShopView extends AbsView
	{
		public static const uiName:String="guild_shop";
		private static const bgURL:String="guild/guild_shop_bg.swf";
		private var _bg:Sprite;

		private var _page:GuildShopPageCtrl;

		private var _down:GuildInfoDownCtrl;
		public function GuildShopView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
			
			_page=new GuildShopPageCtrl(view);
			_down=new GuildInfoDownCtrl(view);
		}
		
		public function checkBackgroud():void
		{
			if(_bg.numChildren==0)
			{
				trace("load "+bgURL);
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bg);
			}
		}
		
		public function update():void
		{
			_page.updateList(ShopBasicManager.Instance.getDataByIDAndTab(GuildConfig.GuildShopID,1));
			_down.update();
		}
		
		public function updateDownInfo():void
		{
			_down.update();
		}
		
		override public function dispose(e:Event=null):void
		{
			_bg=null;
			_page.dispose();
			_down.dispose();
			_page=null;
			_down=null;
			super.dispose();
		}
	}
}