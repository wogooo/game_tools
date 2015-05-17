package com.YFFramework.game.core.module.mapScence.model.proto
{
	/***宠物更新坐标   切换场景时 主角宠物需要更新坐标hongse
	 * @author yefeng
	 *2012-10-28下午6:32:07
	 */
	public class PetUpdatePositonVo
	{
		/**宠物id 
		 */ 
		public var dyId:String;
		/**新坐标
		 */		
		public var mapX:int;
		/**新坐标
		 */
		public var mapY:int;
		public function PetUpdatePositonVo()
		{
		}
	}
}