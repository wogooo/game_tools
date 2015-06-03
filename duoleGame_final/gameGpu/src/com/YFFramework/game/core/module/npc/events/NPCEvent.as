package com.YFFramework.game.core.module.npc.events
{
	/**@author yefeng
	 * 2013 2013-5-2 下午4:57:49 
	 */
	public class NPCEvent
	{
		
		private static const Path:String="com.YFFramework.game.core.module.npc.events.";
		/** NPC传送到目标点
		 */		
		public static const TransferToPoint:String=Path+"TransferToPoint";
		
		
		/**选择职业
		 */
//		public static const C_SelectCareer:String=Path+"C_SelectCareer";
		/**选择职业,带职业参数
		 */
		public static const selectCareer:String=Path+"selectCareer";
		/**鼠标滑过职业选择界面，参数为当下滑过的序号
		 */
		public static const careerRollOver:String=Path+"careerRollOver";
		public function NPCEvent()
		{
		}
	}
}