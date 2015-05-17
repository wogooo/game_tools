package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.world.movie.player.PlayerView;

	/**战斗UI数据   目标点攻击  
	 * 2012-10-15 下午4:13:32
	 *@author yefeng
	 */
	public class FightUIPtVo extends AbsPool
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

		/**目标点坐标
		 */ 
		public var mapX:int;
		public var mapY:int;
		public function FightUIPtVo()
		{
			super();
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