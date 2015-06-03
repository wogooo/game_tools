package com.YFFramework.game.core.module.guild.view.guildMain.activity
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *
	 *@author ludingchang 时间：2013-8-3 下午1:15:05
	 */
	public class GuildActivityView extends AbsView
	{
		public static const uiName:String="guild_activity";
		private static const bgURL:String="guild/guild_activity_bg.swf";
		private var _bg:Sprite;
		public function GuildActivityView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
		}
		public function checkBackgroud():void
		{
			if(_bg.numChildren==0)
			{
				trace("load "+bgURL);
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bg);
			}
		}
		override public function dispose(e:Event=null):void
		{
			_bg=null;
			super.dispose();
		}
	}
}