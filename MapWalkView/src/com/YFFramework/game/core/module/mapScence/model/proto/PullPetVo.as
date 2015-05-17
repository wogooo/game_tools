package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**拉取宠物   宠物离主角太远时 采用拉取 
	 * 2012-9-19 下午5:51:06
	 *@author yefeng
	 */
	public class PullPetVo
	{
		/**宠物动态id 
		 */ 
		public var dyId:uint;
		/**拉取后宠物的坐标
		 */		
		public var mapX:int;
		/**拉取后宠物的坐标
		 */		
		public var mapY:int;
		
		public function PullPetVo()
		{
		}
	}
}