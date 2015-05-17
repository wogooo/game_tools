package com.YFFramework.game.core.module.skill.model
{
	/**  技能  400-499
	 * 2012-9-4 下午5:12:26
	 *@author yefeng
	 */
	public class CMDSkill
	{
		
		/**请求技能列表
		 */ 
		public static const C_RequestSkillList:int=400;
		
		/**服务端返回技能列表
		 */ 
		public static const S_RequestSkillList:int=400;
		
		/**设置技能快捷方式
		 */		
		public static const C_SetSkillShortCut:int=401;
		/**服务端返回技能的设置
		 */		
		public static const S_SetSkillShortCut:int=401;
		/**删除技能快捷方式
		 */		
		public static const C_DeleteSkillShortCut:int=402;
		/**  服务端返回技能的删除
		 */		
		public static const S_DeleteSkillShortCut:int=402;	
		public function CMDSkill()
		{
		}
	}
}