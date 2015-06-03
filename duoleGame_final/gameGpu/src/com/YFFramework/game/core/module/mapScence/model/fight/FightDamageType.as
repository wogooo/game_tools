package com.YFFramework.game.core.module.mapScence.model.fight
{
	/**战斗伤害类型
	 * @author yefeng
	 * 2013 2013-7-15 下午5:41:38 
	 */
	public class FightDamageType
	{
		/**闪避
		 **/
		public static const MISS:int = 1;
		/**暴击
		 */		
		public static const CRIT:int = 2;
		
		/**幸运
		 */
		public static const LUCKY:int = 3;
		
		/**反弹
		 */
		public static const REBOUND:int = 4;
		/**加血
		 */
		public static const CURE:int = 5;
		
		
		/**伤害为 0 
		 */
//		public static const Other:int=7
		
		/**复活
		 */
		public static const REVIVE:int = 8;

		
		public function FightDamageType()
		{
		}
	}
}