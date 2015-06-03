package com.YFFramework.game.core.module.guild.view.guildMain.building
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *公会建筑页
	 *@author ludingchang 时间：2013-7-25 上午11:01:11
	 */
	public class GuildBuildingView extends AbsView
	{
		public static const uiName:String="guild_building";
		private static const bgURL:String="guild/guild_building_bg.swf";
		private static const buildings:Array=[TypeBuilding.HALL,TypeBuilding.HOUSE,TypeBuilding.RESEARCH,TypeBuilding.SHOP];
		private var _bg:Sprite;
		private var _page:GuildBuildPageCtrl;
		public function GuildBuildingView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
			
			_page=new GuildBuildPageCtrl(view);
			update();
		}
		
		public function update():void
		{
			var guildVo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			if(guildVo==null)
				return;
			_page.updateList(buildings);
		}
		
		override public function dispose(e:Event=null):void
		{
			_bg=null;
			super.dispose();
			_page.dispose();
			_page=null;
		}
		public function checkBackgroud():void
		{
			if(_bg.numChildren==0)
			{
				trace("load "+bgURL);
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bg);
			}
		}
	}
}