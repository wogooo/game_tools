package com.YFFramework.game.core.module.mapScence.model
{
	/**@author yefeng
	 *2012-10-29下午11:57:16
	 * 玩家打坐状态 发生改变 是打坐 还是  离开打坐
	 */
	public class SitChangeVo
	{
		/** 打坐 或者离开打坐的玩家
		 */
		public var dyId:String;
		
		/**人物的静态id
		 */
		public var clothBasicId:int;
		/**武器的静态id 
		 */
		public var weaponBasicId:int;

		public function SitChangeVo()
		{
		}
	}
}