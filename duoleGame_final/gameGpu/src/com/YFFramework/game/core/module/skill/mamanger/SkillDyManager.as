package com.YFFramework.game.core.module.skill.mamanger
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.model.SkillCareerTreePositon;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.msg.enumdef.Career;
	
	import flash.utils.Dictionary;

	/** 缓存 SkillDyVo   服务器发过来的 技能数据
	 *   角色当前 具有的技能列表
	 *   技能动态id  
	 * 2012-9-4 上午11:09:21
	 *@author yefeng
	 */
	public class SkillDyManager
	{
		
		private static var _instance:SkillDyManager;
		/**缓存数据 id--SkillDyVo
		 */		
		private var _dict:Dictionary;
		/**默认的普通攻击  技能
		 */ 
		private var _defaultSkillId:int=-1;
		
		public function SkillDyManager()
		{
			_dict=new Dictionary();
		}
		/**技能
		 */ 
		public static function get Instance():SkillDyManager
		{
			if(_instance==null)_instance=new SkillDyManager();
			return _instance;
		}
			
		
		/**添加技能
		 */		
		public function addSkill(skillDyVo:SkillDyVo):void
		{
			_dict[skillDyVo.skillId]=skillDyVo;
		}
		/**清空所有的技能
		 */		
		public function clear():void
		{
			_dict=new Dictionary();
			_defaultSkillId=-1;
		}
		/**洗点后重置技能
		 */		
		public function reset():void
		{
			var defaultSkill:SkillDyVo=getSkillDyVo(_defaultSkillId);
			_dict=new Dictionary();
			addSkill(defaultSkill);
		}
		
		
		public function getAllSkill():Vector.<SkillDyVo>
		{
			var vct:Vector.<SkillDyVo> = new Vector.<SkillDyVo>();
			for(var obj:Object in _dict)
			{
				vct.push(_dict[obj]);
			}
			return vct;
		}
		 
		/**删除技能
		 */		
		public function delSkill(skillId:int):void
		{
			var skillDyVo:SkillDyVo=_dict[skillId];
			if(skillDyVo)
			{
				_dict[skillId]=null;
				delete _dict[skillId];	
			}
		}
		
		/**获取 技能动态vo 
		 * 
		 */		
		public function getSkillDyVo(skillId:int):SkillDyVo
		{
			return _dict[skillId];
		}
		
		
		
		/**刪除技能格子
		 */		
		public function deleteSkillGrid(skillId:int):void
		{
			var skillDyVo:SkillDyVo=_dict[skillId];
		}
		
		/**获取技能id 
		 */		
		public function getDefaultSkill():int
		{
			return _defaultSkillId;
		}
		
		/**设置默认技能
		 */
		public function setDefaultSkill(defalutSkillId:int):void
		{
			_defaultSkillId=defalutSkillId;
		}
		
		/**获取技能播放数据 level 是从   1 开始
		 */		
//		public function getFightEffectBasicVo(skillId:int,level:int):FightEffectBasicVo
//		{
//			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,level);
//			var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo( skillBasicVo.man_effect_id);
//			return fightEffectVo;
//		}
		public function getDict():Dictionary
		{
			return _dict;
		}
			
		/** 是否有可学习的技能  有则返回true  没有 则返回false 
		 * ps:貌似有bug
		 */
		public function hasCanLearnSkill():Boolean
		{
			var career:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
			if(career==Career.CAREER_NEWHAND)//新手不会有技能
				return false;
			var  hashMap:HashMap=SkillBasicManager.Instance.getSkillList(career);
			var arr:Array=hashMap.values();
			////初始化所有的UI
			var skillDyVo:SkillDyVo;
			var mySkillBasicVo:SkillBasicVo;
			for each(var skillBasicVo:SkillBasicVo in arr)
			{
				if(skillBasicVo.list_pos>0&&skillBasicVo.skill_big_category==TypeSkill.BigCategory_Career)
				{
					skillDyVo=SkillDyManager.Instance.getSkillDyVo(skillBasicVo.skill_id);
					if(!skillDyVo)   //不存在技能列表
					{  
						if(CharacterDyManager.Instance.yueli>=skillBasicVo.see_consume//是否显示“+”号
							&& DataCenter.Instance.roleSelfVo.roleDyVo.level>=skillBasicVo.character_level
							&& DataCenter.Instance.roleSelfVo.note>=skillBasicVo.note_consume)
						{
							return  true;
						}
					}
				}
			}
			return false;
		}
		/**查找下一个可升级的技能<br>
		 * 如果没有就为空
		 * */
		public function findNextCanLearnSkill(now_pos:int):SkillBasicVo
		{
			var career:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
			var role_lv:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(career==Career.CAREER_NEWHAND)//新手没有技能
				return null;
			var skill:SkillBasicVo;
			var skillDyVo:SkillDyVo;
			var pos:int=now_pos;
			var role_see:int=CharacterDyManager.Instance.yueli;
			var role_note:int=DataCenter.Instance.roleSelfVo.note;
			do
			{
				skill=SkillBasicManager.Instance.getSkill(career,pos);//根据职业和位子获取技能ID
				if(skill)
				{
					skillDyVo=getSkillDyVo(skill.skill_id);//根据技能ID获取技能等级
					if(skillDyVo)//技能已经学过
						skill=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel+1);//当前技能下一等级VO
					if(skill&&skill.character_level<=role_lv&&skill.see_consume<=role_see&&skill.note_consume<=role_note)
						return skill;
				}
				pos=getNextPos(pos);
			}
			while(pos!=now_pos)
			return null;
		}
		
		/**获取下1个技能位置*/
		private function getNextPos(pos:int):int
		{//技能位置重1开始，
			if(pos+1<=SkillCareerTreePositon.Len)
				pos++;
			else if(pos+1>SkillCareerTreePositon.Len)
				pos=pos+1-SkillCareerTreePositon.Len;
			return pos;
		}
		
		/**
		 *是否已经学习了技能xxx 
		 * @param skillid 技能ID
		 * @return 
		 * 
		 */		
		private function hasLearnSkill(skillid:int):Boolean
		{
			return (_dict[skillid]!=null);
		}
		
		/**是否能够触发技能 通过技能消耗
		 */
		public function canTriggerSkillByConsume(skillBasicVo:SkillBasicVo,showNotice:Boolean=true):Boolean
		{
			var cantrigger:Boolean=false;
			switch(skillBasicVo.consume_type)
			{
				case SkillModuleType.Consume_MP:
					if(DataCenter.Instance.roleSelfVo.roleDyVo.mp >= skillBasicVo.consume_value)
					{
						cantrigger=true;
					}
					//									NoticeUtil.setOperatorNotice("魔法不够");
					else 
					{
						if(showNotice)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_904);
						}
					}
					break;
				case SkillModuleType.Consume_HP:
					if(DataCenter.Instance.roleSelfVo.roleDyVo.hp >= skillBasicVo.consume_value)
					{
						cantrigger=true;
					}
					else 
					{
						if(showNotice)
						{
							NoticeUtil.setOperatorNotice("血量不够");
						}
					}
					break;
				case SkillModuleType.Consume_HPPercent:
					if(DataCenter.Instance.roleSelfVo.roleDyVo.hp>=skillBasicVo.consume_value*0.01*DataCenter.Instance.roleSelfVo.roleDyVo.maxHp)
					{
						cantrigger=true;
					}
					else 
					{
						if(showNotice)
						{
							NoticeUtil.setOperatorNotice("血量不够");
						}
					}
					break;
				case SkillModuleType.Consume_MPPercent:
					if(DataCenter.Instance.roleSelfVo.roleDyVo.mp>=skillBasicVo.consume_value*0.01*DataCenter.Instance.roleSelfVo.roleDyVo.maxMp)
					{
						cantrigger=true;
					}
					else 
					{
						if(showNotice)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_904);
						}
					}
					break;
				default:
					cantrigger=true;
					break;
			}
			return cantrigger;

		}
		
		
	
	}
}