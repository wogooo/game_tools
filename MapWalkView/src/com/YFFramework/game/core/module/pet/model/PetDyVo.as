package com.YFFramework.game.core.module.pet.model
{
	import com.YFFramework.core.world.model.MonsterDyVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-11 下午2:56:27
	 * 
	 */
	public class PetDyVo extends MonsterDyVo
	{
		public var potential:int;
		public var power:int;
		public var happy:int;
		public var skillOpenSlots:int;
		public var exp:int;
		/**魔法  最大魔法 血量 最大血量 成长率 体质-精神 体质资质-精神资质 速度 攻击力 魔法攻击力 防御力 魔法防御力
		 */		
		public var fightAttrs:Array;
		public var skillAttrs:Array;
		public var enhanceLv:int;
		public var defaultSkillId:int;
		public var succTempAttrs:Array;

		public function PetDyVo(){
			fightAttrs = new Array();
			skillAttrs = new Array();
			succTempAttrs = new Array();
		}
	}
} 