package com.YFFramework.game.core.module.mapScence.model.proto
{
	/**物品掉落 物品掉落信息
	 * 2012-10-30 下午8:19:26
	 *@author yefeng
	 */
	public class DropGoodsInfoVo
	{
		/**角色id
		 */ 
		public  var roleId:String;
		/** 角色进入场景的 位置 
		 */
		public var mapX:int;
		/** 角色进入场景的 位置 
		 */
		public var mapY:int;
		
		/** 角色名称
		 */
		public var name:String;
		
		/** 对人物来说就是 套装的 的静态id   对  怪物来说 就是 怪物的静态id  
		 */
		public var clothBasicId:int;
		
		public function DropGoodsInfoVo()
		{
		}
	}
}