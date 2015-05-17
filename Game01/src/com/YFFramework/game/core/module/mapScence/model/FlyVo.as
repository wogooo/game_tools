package com.YFFramework.game.core.module.mapScence.model
{
	/**2012-7-31 下午12:28:01
	 *@author yefeng
	 */
	public class FlyVo
	{
		
		/**处于飞行状态
		 */
		public static const Flying:int=1;
		/** 不处于飞行状态
		 */
		public static const NotFly:int=0;
		
		/**  角色id 
		 */
		public var id:int;
		
		/** 是否处于飞行状态  值为  Flying  或者 Flying   由服务器端返回
		 */
		public var isFly:int;
		
		public function FlyVo()
		{
		}
	}
}