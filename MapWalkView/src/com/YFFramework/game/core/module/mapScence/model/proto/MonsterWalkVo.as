package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**  怪物行走
	 * @author yefeng
	 *2012-8-30下午10:39:11
	 */
	import com.YFFramework.core.center.pool.AbsPool;
	
	public class MonsterWalkVo extends AbsPool
	{
		/**
		 * 攻击的怪物动态id
		 */
		public var  monsterDyId:String;
		
		/**  怪物移动到的目标点
		 */
		public var x:int;
		public var y:int;
		
		public function MonsterWalkVo()
		{
			super();
		}
		override public function reset():void
		{
			super.reset();
			monsterDyId=null;
		}
			
		
	}
}