package com.YFFramework.game.core.module.mapScence.model.fight
{
	import com.YFFramework.core.center.pool.AbsPool;

	/**  战斗通讯协议
	 * 
	 *   群攻   无点  对多人发起攻击   该攻击 不带 目标终点
	 * 2012-9-4 上午11:13:55
	 *@author yefeng
	 */
	public class FightMoreVo extends AbsPool
	{
		/** 受击者技能数组   保存的是受击者 的动态id 
		 */ 
		public var uAtkArr:Array; ////  java转化 为  Object[] 类型数组	Object[] uAtkArr=(Object[])info.get("uAtkArr");

		/**使用的技能
		 */		
		public var skillId:int;
		/**  技能等级
		 */
	//	public var level:int;
		public function FightMoreVo()
		{
		}
		
		override public function reset():void
		{
			uAtkArr=null;
		}

	}
}