package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**2012-10-15 上午9:37:08
	 *@author yefeng
	 */
	public class FightSingleResultVo extends AbsPool
	{
		/** 攻击者id 
		 */		
		public var atkId:String;
		/**受击者信息 fightHurtVo是  FightHurtVo 类型的Object 变量 java传过来
		 */ 
		public var fightHurtVo:Object;

		/**使用的技能
		 */		
		public var skillId:int;
		/**使用的技能
		 */	
		public var skillLevel:int;

		public function FightSingleResultVo()
		{
			super();
		}
		
		override public function reset():void
		{
			fightHurtVo=null;
			skillId=0;
		}

	}
}