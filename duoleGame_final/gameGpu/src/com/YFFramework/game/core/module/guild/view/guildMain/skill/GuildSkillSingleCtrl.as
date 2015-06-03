package com.YFFramework.game.core.module.guild.view.guildMain.skill
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.GuildSkillManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/***
	 *公会技能单个技能控制
	 *@author ludingchang 时间：2013-11-4 下午5:59:09
	 */
	public class GuildSkillSingleCtrl
	{
		/**位置*/
		private var _pos:int;
		private var _vo:SkillBasicVo;
		private var _skill_name:TextField;
		private var _skill_level:TextField;
		private var _skill_icon:IconImage;
		private var _bg:BitmapControl;
		public function GuildSkillSingleCtrl(view:Sprite)
		{
			_skill_name=view.getChildByName("skill_name") as TextField;
			_skill_level=view.getChildByName("skill_level") as TextField;
			_skill_icon=Xdis.getChild(view,"icon_iconImage");
			_skill_icon.mouseEnabled=false;
			_bg=new BitmapControl(Skins.bagGridSkin);
			_bg.addEventListener(MouseEvent.CLICK,onClick);
			view.addChildAt(_bg,1);
			_bg.x=_skill_icon.x;
			_bg.y=_skill_icon.y;
			_bg.setXYOffset(-4,-4);
		}
		
		private function onClick(e:MouseEvent):void
		{
			GuildSkillManager.Instence.selectedSkill=_pos;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.SkillSelect);
		}
		
		public function initData(data:SkillBasicVo):void
		{
			_vo=data;
		}
		public function update():void
		{
			var learned:Boolean=false;
			var skill:SkillBasicVo=GuildSkillManager.Instence.getLearnedSkill(_vo.skill_id);
			if(skill)
			{
				learned=true;
			}
			else
				skill=_vo;
			
			var skill_max_lv:int=GuildInfoManager.Instence.maxSkillLevel;
			if(skill.skill_level>skill_max_lv)//如果已经学会的等级已经超过了当前公会可学习的技能等级上限，则将技能VO替换为公会最高可学习的等级的技能的VO
				skill=SkillBasicManager.Instance.getSkillBasicVo(skill.skill_id,skill_max_lv);
			
			_skill_icon.url=URLTool.getSkillIcon(skill.icon_id);
			_skill_level.text=skill.skill_level+"/"+GuildSkillManager.Instence.maxSkillLevel(skill.list_pos);
			_skill_name.text=skill.name;
			_pos=skill.list_pos;
			
			if(learned)
			{
				Xtip.registerLinkTip(_bg,SkillTip,TipUtil.skillTipInitFunc,skill.skill_id,skill.skill_level,false);
				_skill_icon.filters=[];
			}
			else
			{
				_skill_icon.filters=FilterConfig.dead_filter;
				Xtip.registerLinkTip(_bg,SkillTip,TipUtil.skillTipInitFunc,skill.skill_id,1,true);
			}
		}
		/**
		 *使自己高亮 /取消高亮
		 * @param highlight：显示（true）\取消（false） 高亮
		 */		
		public function showHighlight(highlight:Boolean):void
		{
				_bg.select=highlight;
		}
		/**取升级后需要显示的技能VO*/
		public function getUpgradeVo():SkillBasicVo
		{
			var skill:SkillBasicVo=GuildSkillManager.Instence.getLearnedSkill(_vo.skill_id);
			if(skill)//学习过该技能
			{
				var next_kill:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skill.skill_id,skill.skill_level+1);
				if(next_kill)//有下一级技能
					return next_kill;
				else
					return skill;
			}
			else
				return _vo;
		}
	}
}