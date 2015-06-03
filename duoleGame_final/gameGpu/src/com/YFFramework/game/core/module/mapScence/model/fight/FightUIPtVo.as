package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;

	/**战斗UI数据   目标点攻击  
	 * 2012-10-15 下午4:13:32
	 *@author yefeng
	 */
	public class FightUIPtVo 
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
		
		/**当前选中的对象
		 */
//		public var selectPlayer:PlayerView;

		/**目标点坐标
		 */ 
		public var mapX:int;
		public var mapY:int;
		public function FightUIPtVo()
		{
			super();
		}

	}
}