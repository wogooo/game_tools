package com.YFFramework.game.core.module.mapScence.model.fight
{
	/**  受到攻击的玩家爱的具体受伤信息
	 * @author yefeng
	 *2012-9-4下午10:25:13
	 */
	public class FightHurtVo
	{
		/**受击玩家的动态 id
		 */ 
		public var dyId:uint;
		
		/**玩家掉落/增加的血量  血量改变量 
		 */ 
		public var changeHp:int;
		/**改变的魔法
		 */		
		public var changeMP:int;

		/** 伤害类型
		 */		 
		public var  damageType:int; // 伤害类型，1:扣血，2:加血，3:闪避，4:暴击			DamageType
		/**  dyId当前血量
		 */
		public var hp:int;
		/**当前魔法
		 */		
		public var mp:int;
		/** buffId 
		 */		
		public var buffId:int;
		public function FightHurtVo()
		{
		}
	}
}