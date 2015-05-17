package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**单人攻击   攻击者只能攻击一个目标对象
	 * 2012-10-15 上午9:35:05
	 *@author yefeng
	 */
	public class FightSingleVo extends AbsPool
	{
		/**受击者id 
		 */ 
		public var uAtkId:uint;
		
		/**使用的技能
		 */		
		public var skillId:int;
		public function FightSingleVo()
		{
		}
		override public function reset():void
		{
			skillId=0;
			uAtkId=0;
		}
	}
}