package com.YFFramework.game.core.module.guild.view.guildMain.skill
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildSkillManager;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildInfoDownCtrl;
	import com.YFFramework.game.core.module.story.view.DownTextContainer;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/***
	 *公会技能页
	 *@author ludingchang 时间：2013-8-3 上午11:04:50
	 */
	public class GuildSkillView extends AbsView
	{
		public static const uiName:String="guild_skill";
		private static const bgURL:String="guild/guild_skill_bg.swf";
		private var _bg:Sprite;
		private static const SKILL_NUMBER:int=9;
		private var _skillCtrls:Array;
		private var _downCtrl:GuildInfoDownCtrl;
		private var _selectInfo:GuildSkillSelectInfo;
		public function GuildSkillView(view:Sprite)
		{
			var pos:int=view.parent.getChildIndex(view);
			view.parent.addChildAt(this,pos);
			this.addChild(view);
			_bg=new Sprite;
			view.addChildAt(_bg,0);
			_selectInfo=new GuildSkillSelectInfo(view);
			_downCtrl=new GuildInfoDownCtrl(view);
			_skillCtrls=new Array;
			for(var i:int=1;i<=SKILL_NUMBER;i++)
			{
				var skillCtrl:GuildSkillSingleCtrl=new GuildSkillSingleCtrl(Xdis.getChild(view,"skill"+i));
				_skillCtrls[i]=skillCtrl;
				var skill:SkillBasicVo=GuildSkillManager.Instence.getSkill(i,1);//初始化格子
				skillCtrl.initData(skill);
			}
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
			_downCtrl.dispose();
			_downCtrl=null;
			_selectInfo.dispose();
			_selectInfo=null;
			super.dispose();
		}
		public function update():void
		{
			//更新右边选中描述,选中改变时更新
			var selected:int=GuildSkillManager.Instence.selectedSkill;
			var skillCtrl:GuildSkillSingleCtrl;
			for(var i:int=1;i<=SKILL_NUMBER;i++)
			{
				skillCtrl=_skillCtrls[i];
				skillCtrl.showHighlight(i==selected);
				skillCtrl.update();
			}
			_downCtrl.update();
			skillCtrl=_skillCtrls[selected];
			_selectInfo.update(skillCtrl.getUpgradeVo());
		}
		public function updateDownInfo():void
		{
			_downCtrl.update();
		}
	}
}