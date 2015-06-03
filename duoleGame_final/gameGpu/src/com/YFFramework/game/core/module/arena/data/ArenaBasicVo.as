package com.YFFramework.game.core.module.arena.data
{
	public class ArenaBasicVo
	{

		public var arena_id:int;
		/**复活需要消耗的魔钻 
		 */		
		public var revive_money:int;
		/** 活动表id */		
		public var activity_id:int;
		/** 退出后所在地图ID */		
		public var exit_scene_id:int;
		/** 退出后是否回到原来位置 */		
		public var is_back:int;

		public function ArenaBasicVo()
		{
		}
	}
}