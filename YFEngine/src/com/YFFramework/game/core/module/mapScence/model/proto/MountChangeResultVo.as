package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**
	 * 坐骑状态发生变化时产生的数据结构 vo 
	 * 2012-7-26 下午1:43:53
	 *@author yefeng
	 */
	public class MountChangeResultVo
	{
		/** 切换坐骑状态的玩家 id 
		 */
		public var dyId:String;
		/** 衣服id 
		 */		
		public var clothBasicId:int;
		/**武器id 或者 坐骑id 
		 */		
		public var weaponBasicId:int;
		
		public function MountChangeResultVo()
		{
		}
	}
}