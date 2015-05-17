package com.YFFramework.game.core.module.skill.model.proto
{
	/**服务端返回的技能列表
	 * @author yefeng
	 *2012-10-15下午10:54:54
	 */
	public class RequestSkillListResultVo
	{
		///技能列表  里面保存的是  SkillDyVo 的 object对象
		public var skillList:Array;
		/**默认技能id 
		 */ 
		public var defaultSkillId:int;
		public function RequestSkillListResultVo()
		{
		}
	}
}