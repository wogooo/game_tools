package com.YFFramework.core.world.model
{
	/**2012-8-28 上午11:23:21
	 *@author yefeng
	 */
	public class PlayerMoveResultVo extends PlayerClientMoveVo
	{
		/**发生移动的角色id 
		 */
		public var id:String;
		
		/**角色坐标
		 */ 
		public var mapX:int;
		
		/**角色坐标
		 */ 	
		public var mapY:int;

		public function PlayerMoveResultVo()
		{
			super();
		}
	}
}