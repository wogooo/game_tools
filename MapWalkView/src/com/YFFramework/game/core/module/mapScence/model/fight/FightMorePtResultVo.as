package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**2012-10-15 上午11:06:42
	 *@author yefeng
	 */
	public class FightMorePtResultVo extends AbsPool
	{
		public var mapX:int;
		public var mapY:int;
		
		/**攻击者动态id 
		 */ 
		public var atkId:uint;
		/**受击者玩家的具体信息 保存的时候FightHurtVo 
		 */ 
		public var uAtkArr:Array;
		
		/**使用的技能
		 */ 
		public var skillId:int;
		
		public var skillLevel:int;
		public function FightMorePtResultVo()
		{
			super();
		}
		override public function reset():void
		{
			uAtkArr=null;
			atkId=0;
		}	

	}
}