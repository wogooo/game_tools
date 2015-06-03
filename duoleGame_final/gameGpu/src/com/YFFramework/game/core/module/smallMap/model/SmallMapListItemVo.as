package com.YFFramework.game.core.module.smallMap.model
{
	/**  list Item  带的数据    
	 * @author yefeng
	 * 2013 2013-6-21 下午12:18:09 
	 */
	public class SmallMapListItemVo
	{
		/**坐标点类型
		 */		
		public static const TypePt:int=1;
		/** NPC类型
		 */		
		public static const TypeNPC:int=2;
		
		public var mapX:int;
		public var mapY:int;
		
		/**  npcid     当为  npc 时 需要设置该值
		 */		
		public var  npcId:int;
		/**类型  该 vo  的类型  是 坐标点类型 还是 玩家npc类型 
		 */		
		public var type:int;
		public function SmallMapListItemVo()
		{
		}
	}
}