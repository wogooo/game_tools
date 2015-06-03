package com.YFFramework.game.core.module.npc.model
{
	/**@author yefeng
	 * 2013 2013-5-20 下午1:58:59 
	 */
	
	
	/** 任务奖励图标数据
	 */	
	public class TaskRewardVo 
	{
		/**物品数量
		 */		
		public var num:int;
		/**物品类型 是 道具还是装备
		 */		
		public var type:int;
		/**  静态id 
		 */		
		public var  basicId:int;
		public function TaskRewardVo()
		{
			super();
		}
	}
}