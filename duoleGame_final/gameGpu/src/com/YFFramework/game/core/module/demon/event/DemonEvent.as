package com.YFFramework.game.core.module.demon.event
{
	/**@author yefeng
	 * 2013 2013-10-11 下午5:04:55 
	 */
	public class DemonEvent
	{
		private static var Path:String="com.YFFramework.game.core.module.demon.event.";

		/**进入魔族入侵副本
		 */		
		public static const DemonRaid:String = Path + "DemonRaid";
		
		/**触发魔族入侵副本特殊技能
		 */
		public static const TriggerDemonRaidSkill:String=Path+"TriggerRaidSkill";


		/**  魔族入侵报名*/	
		public static const SignRaidActivity:String=Path+"SignRaidActivity";

		
		/**使用大炮成功
		 */
		public static const UseDaPaoSuccess:String=Path+"UseDaPaoSuccess";

		/**使用月井成功
		 */
		public static const UseYueJingSuccess:String=Path+"UseYueJingSuccess";
		/**历史最高波数改变
		 */		
		public static const DemonLevelChange:String=Path+"DemonLevelChange";
		public function DemonEvent()
		{
		}
	}
}