package com.YFFramework.game.core.module.guild.view.guildMain.skill
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.GuildSkillManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	/***
	 *
	 *@author ludingchang 时间：2013-11-5 下午5:10:56
	 */
	public class GuildSkillSelectInfo
	{
		private var _name_txt:TextField;
		private var _icon:IconImage;
		private var _level_txt:TextField;
		private var _eff1_txt:TextField;
		/**需要等级*/
		private var _needLv_txt:TextField;
		/**需要贡献*/
		private var _needGX_txt:TextField;
		/**需要银锭*/
		private var _needNote_txt:TextField;
		private var _learn_btn:Button;
		private var _skill_vo:SkillBasicVo;
		public function GuildSkillSelectInfo(view:Sprite)
		{
			_eff1_txt=Xdis.getTextChild(view,"skill_eff");
			_name_txt=Xdis.getTextChild(view,"skill_name");
			_level_txt=Xdis.getTextChild(view,"skill_level");
			_icon=Xdis.getChild(view,"icon_iconImage");
			_needGX_txt=Xdis.getTextChild(view,"need_gx");
			_needLv_txt=Xdis.getTextChild(view,"need_lv");
			_needNote_txt=Xdis.getTextChild(view,"need_note");
			_learn_btn=Xdis.getChildAndAddClickEvent(onLearn,view,"learn_button");
		}
		
		private function onLearn(e:MouseEvent):void
		{//点击学习按钮
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.SkillLearn,_skill_vo);
		}
		public function update(skill:SkillBasicVo):void
		{
			_skill_vo=skill;
			_icon.url=URLTool.getSkillIcon(skill.icon_id);
			_name_txt.text=skill.name;
//			_level_txt.text=skill.skill_level+"/"+GuildSkillManager.Instence.maxSkillLevel(skill.list_pos);
			_level_txt.text="等级："+skill.skill_level;
			_needGX_txt.text=skill.see_consume.toString();//贡献值在表中为阅历值
			_needLv_txt.text=skill.character_level.toString();
			_needNote_txt.text=skill.note_consume.toString();
			_eff1_txt.text="\t"+skill.effect_desc;
			checkEnable();
		}
		private static const NORMAL_COR:uint=0xfff0b6;
		private static const RED_COR:uint=0xff0000;
		private function checkEnable():void
		{
			var learn_skill:SkillBasicVo=GuildSkillManager.Instence.getLearnedSkill(_skill_vo.skill_id);
			if(learn_skill&&learn_skill.skill_level==_skill_vo.skill_level)
			{
				_learn_btn.label="满级";
				_learn_btn.enabled=false;
				_needGX_txt.textColor=NORMAL_COR;
				_needLv_txt.textColor=NORMAL_COR;
				_needNote_txt.textColor=NORMAL_COR;
				return;
			}
			else
			{
				_learn_btn.label="学习";
			}
					
			var con:Number=GuildInfoManager.Instence.me.contribution;
			var isCon:Boolean=false,isLv:Boolean=false,isNote:Boolean=false,isSkillLv:Boolean;
			if(con>=_skill_vo.see_consume)
			{
				_needGX_txt.textColor=NORMAL_COR;
				isCon=true;
			}
			else
				_needGX_txt.textColor=RED_COR;
			
			var lv:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(lv>=_skill_vo.character_level)
			{
				_needLv_txt.textColor=NORMAL_COR;
				isLv=true;
			}
			else
				_needLv_txt.textColor=RED_COR;
			
			var note:int=DataCenter.Instance.roleSelfVo.note;
			if(note>=_skill_vo.note_consume)
			{
				_needNote_txt.textColor=NORMAL_COR;
				isNote=true;
			}
			else
				_needNote_txt.textColor=RED_COR;
			
			isSkillLv=!(_skill_vo.skill_level>GuildInfoManager.Instence.maxSkillLevel)//技能等级必须小于等于可学习的技能的最高等级
			
			_learn_btn.enabled=(isCon&&isLv&&isNote&&isSkillLv);//4个条件都满足才有效
				
		}
		public function dispose():void
		{
			_eff1_txt=null;
			_name_txt=null;
			_level_txt=null;
			_icon=null;
			_needGX_txt=null;
			_needLv_txt=null;
			_needNote_txt=null
			_learn_btn.removeMouseClickEventListener(onLearn);
			_learn_btn=null;
		}
		
	}
}