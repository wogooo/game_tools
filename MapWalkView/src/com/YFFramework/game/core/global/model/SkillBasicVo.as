package com.YFFramework.game.core.global.model
{
	import flash.utils.getTimer;

	/**技能表基础模型
	 */	
	public class SkillBasicVo
	{
		/** 自增id 
		 */		
		public var id:int;

		public var skill_level:int;
		
		public var skill_id:int;
		
		public var effect_id:int;

		public var effect_type:int;
			
		/** 技能作用作用范围 
		 */		
		public var effect_range:int;
		
		/** 技能使用距离
		 */		
		public var use_distance:int;
		
		/** 作用人数
		 */		
		public var affect_number:int;
		
		public var icon_id:int;
		
		public var name:String;
		/**  被动技能  值在TYpeSKill.UseType__
		 */
		public var use_type:int;
		
		/**技能大类 类型   在TypeSkill里面   0 代表职业技能 1 代表通用技能 2  代表 工会技能   TypeSkill.BigCategory_
		 */		
		public var skill_bigCategory:int;
		

		public var fix_damage:int;
		public var extra_damage:int;
		public var description:String;
		public var extra_hitrate:int;
		public var buff_id:int;
		public var list_pos:int;
		public var affect_group:int;
		public var trap_type:int;
		public var buff_hitrate:int;
		public var cooldown_time:int;
		public var fix_damage_type:int;
		public var consume_type:int;
		public var extra_value2:int;
		public var note_consume:int;
		public var damage_factor:int;
		public var before_skill:int;
		public var buff_time:int;
		public var trap_time:int;
		public var other_consume:int;
		public var exclude_skill:int;
		public var range_param:int;
		public var extra_type1:int;
		public var character_level:int;
		public var see_consume:int;
		public var extra_effect:int;
		public var effect_desc:String;
		public var profession:int;
		public var extra_value1:int;
		public var extra_type2:int;
		public var trap_id:int;
		public var range_shape:int;
		public var consume_value:int;
		
		
		/**上一次播放技能的时间
		 */		
		private var _preFireTime:Number;


		public function SkillBasicVo()
		{
			_preFireTime=0;

		}
		
		/** 是否能进行该特效的播放
		 */		
		public function canfire():Boolean
		{
			if(getTimer()-_preFireTime>=cooldown_time) 
			{
				_preFireTime=getTimer();
				return true;
			}
			return false;
		}

	}
}