package com.YFFramework.game.core.module.mapScence.model.fight
{
	/**  受到攻击的玩家爱的具体受伤信息
	 * @author yefeng
	 *2012-9-4下午10:25:13
	 */
	public class FightHurtVo
	{
		/**受击玩家的动态 id
		 */ 
		public var dyId:String;
		
		/**玩家掉落的血量
		 */ 
		public var hp:int;

		/**剩余的血量百分比    客户端需要在此值的基础上 除以 10000    因为服务端为了将其转化为int  人为乘了10000   所以这里需要除以10000
		 */
		public var hpPercent:int;

		public function FightHurtVo()
		{
		}
	}
}