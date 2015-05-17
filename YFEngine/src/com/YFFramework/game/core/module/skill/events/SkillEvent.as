package com.YFFramework.game.core.module.skill.events
{
	/**2012-7-26 下午1:14:23
	 *@author yefeng
	 */
	public class SkillEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.skill.events.";
		/**请求技能列表返回
		 */		
		public static const S_RequestSkillList:String=Path+"S_RequestSkillList";
		/**设置技能快捷方式
		 */		
		public static const C_SetSkillShortCut:String=Path+"C_SetSkillShortCut";
		/**服务端返回技能的设置
		 */		
		public static const S_SetSkillShortCut:String=Path+"S_SetSkillShortCut";
		/**删除技能快捷方式
		 */		
		public static const C_DeleteSkillShortCut:String=Path+"C_DeleteSkillShortCut";
		/**  服务端返回技能的删除
		 */		
		public static const S_DeleteSkillShortCut:String=Path+"S_DeleteSkillShortCut";

		public function SkillEvent()
		{
		}
	}
}