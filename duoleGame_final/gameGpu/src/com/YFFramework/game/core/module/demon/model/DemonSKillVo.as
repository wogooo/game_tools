package com.YFFramework.game.core.module.demon.model
{
	/**副本特殊技能 数据vo 
	 * @author yefeng
	 * 2013 2013-10-11 下午4:01:55 
	 */
	public class DemonSKillVo
	{
			/**副本特殊技能的类型        1  表示  大炮   2  表示月井  值 在 RaidSkillType里
			*/
		public var raidSkillType:int;
		/**剩余的次数
		 */
		public var leftTimes:int;
		public function DemonSKillVo()
		{
		}
	}
}