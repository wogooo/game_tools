package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.world.movie.player.PlayerView;

	/** 战斗UI数据   无目标点攻击
	 * 2012-7-27 下午2:35:41
	 *@author yefeng
	 */
	public class FightUIVo extends AbsPool
	{
		/**  攻击者
		 */
		public var atk:PlayerView;
		/**受击者数组
		 */
		public var uAtkArr:Vector.<UAtkInfo>;
		/**战斗id 
		 */
		public var skillId:int;
		/**技能等级
		 */
		public var skillLevel:int;
		public function FightUIVo()
		{
		}
		/**子类重写
		 * 重置对象至初始状态
		 */		
		override public function reset():void
		{
			atk=null;
			uAtkArr=null;
		}

	}
}