package com.YFFramework.game.core.global.model
{
	import com.YFFramework.core.debug.print;
	
	import flash.utils.getTimer;

	/**技能表基础模型
	 */	
	public class SkillBasicVo
	{
		/**公共CD时间
		 */		
		public static const CommonCDTime:int=900;
		
		/**技能时间便宜量  用于技能打出修正
		 */
		public static const TimeOffset:int=70;
		/** 自增id 
		 */		
		public var id:int;

		/**技能等级
		 */		
		public var skill_level:int;
		
		/**技能id
		 */		
		public var skill_id:int;
		/** 男角色 技能特效id 普通攻击的特效id   fightEffect表的键值 
		 */		
		public var man_effect_id:int;
		
		/** 男角色 技能特效id 特殊攻击1的特效id   fightEffect表的键值 
		 */
		public var man_effect_atk1_id:int;
		/**女角色 技能特效id 普通攻击的特效id   fightEffect表的键值 
		 */		
		public var woman_effect_id:int;
		/** 女角色 技能特效id 特殊攻击1的特效id   fightEffect表的键值 
		 */
		public var woman_effect_atk1_id:int;
		
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
		/**  被动技能  值在TYpeSKill.UseType__     判断其是否是主动技能还是被动技能 
		 */
		public var use_type:int;
		
		/**技能大类 类型   在TypeSkill里面   0 代表职业技能 1 代表通用技能 2  代表 工会技能   TypeSkill.BigCategory_
		 */		
		public var skill_big_category:int;
		
//		public var fix_damage:int;
		public var extra_damage:int;
		public var description:String;
		public var extra_hitrate:int;
		public var buff_id:int;
		/**特殊效果 类型    值 在TypeSkill_ SpecialEffetType_
		 */		
		public var special_effect:int;
		/**特殊 技能参数  比如 击退多少像素
		 */
		public var special_param:int;

		/**该技能格在树上的位置
		 */		
		public var list_pos:int;
		public var affect_group:int;
		public var trap_type:int;
		public var buff_hitrate:int;
		public var cooldown_time:int;
//		public var fix_damage_type:int;
		public var extra_value2:int;
		/**银锭*/
		public var note_consume:int;
		public var damage_factor:int;
		public var before_skill:int;
		/** buff作用时间 */
		public var buff_time:int;
		public var trap_time:int;
		public var other_consume:int;
		public var exclude_skill:int;
		public var range_param:int;
		public var extra_type1:int;
		public var character_level:int;
		/**消耗的阅历值
		 */		
		public var see_consume:int;
		public var effect_desc:String;
		public var profession:int;
		public var extra_value1:int;
		public var extra_type2:int;
		public var range_shape:int;
		
		
		/**消耗类型  具体值在  SkillModuleType Consume_
		 */
		public var consume_type:int;

		/**消耗值
		 */		
		public var consume_value:int;
		/**上一次播放技能的时间
		 */		
		private var _preFireTime:Number;
		
		/**陷阱id
		 */
		public var trap_id:int;
		/**  技能使用限制
		 */
		public var use_limit:int;
		/**技能品质 
		 */		
		public var quality:int;
		
		/**技能是否可以触发
		 */		
		private var _skillCanFire:Boolean;
		
		private  var _commonCDTIme:Number;
		
		public function SkillBasicVo()
		{
			_preFireTime=-1000000;
			_commonCDTIme=-1000000;
			_skillCanFire=false;
		}
		
		/** 是否能进行该特效的播放  内部自动 CD 该方法谨慎调用
		 */		
//		public function canfire():Boolean
//		{
//			if(getTimer()-_preFireTime>=cooldown_time) 
//			{
//				print(this,"不能触发技能啊..................................cooldown_time="+cooldown_time,"getTimer()-_preFireTime:",getTimer()-_preFireTime);
//
//				_preFireTime=getTimer();
//
//				return true;
//			}
////			print(this,"不能触发技能啊..................................cooldown_time="+cooldown_time,"getTimer()-_preFireTime:",getTimer()-_preFireTime);
//			return false;
//		}
		/**重置CD
		 */		
		public function resetCD():void
		{
			_preFireTime=-100000;
		}
		
		/**技能是否可以触发
		 */		
		public function skillCanfire():Boolean
		{
			if(getTimer()-_preFireTime+TimeOffset>=cooldown_time&&(getTimer()-_commonCDTIme>=CommonCDTime)) 
			{
				return true
			}
//			print(this,getTimer()-_preFireTime-cooldown_time,getTimer()-_commonCDTIme-CommonCDTime);
			return false;
		}
		
		public function updateCD():void
		{
			_preFireTime=getTimer();
		}
		/**更新公共CD
		 */		
		public  function updateCommonCD():void
		{
			_commonCDTIme=getTimer();
		}
		
		/**是否 处在 自己的技能CD中    如果 在自己的技能CD中 则不播放公共CD 
		 */
		public function isInCD():Boolean
		{
			if(getTimer()-_preFireTime>=cooldown_time) return false;
			return true;
		}
		
		/**返回播放CD的时间
		 */
		public function getCDViewTime():int
		{
			return cooldown_time+300;
		}
		
		public function getCommonCDViewTime():int
		{
			return CommonCDTime+300;
		}

	}
}