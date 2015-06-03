package com.YFFramework.game.core.module.skill.events
{
	/**@author yefeng
	 * 2013 2013-6-9 上午11:38:10 
	 */
	public class SkillEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.skill.events.";
		/**请求 学习技能
		 */		
		public static const C_LearnSkill:String=Path+"C_LearnSkill";
		
		/**设置技能快捷方式
		 */
		public static const C_SetQuickBox:String=Path+"C_SetQuickBox";
		/**技能学习成功
		 */		
		public static const LearnNewSkillSuccess:String=Path+"LearnNewSkillSuccess";
		/**重置技能
		 */
		public static const  RestSkill:String=Path+"RestSkill";
		public function SkillEvent()
		{
		}
	}
}