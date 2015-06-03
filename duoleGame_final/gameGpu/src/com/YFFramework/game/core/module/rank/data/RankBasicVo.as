package com.YFFramework.game.core.module.rank.data
{
	public class RankBasicVo
	{
		/** 类别（唯一索引） */		
		public var classic_type:int;
		/** 大类 */
		public var type:int;
		/** 大类名称 */	
		public var classic_name:String;
		/** 小类名称 */
		public var subClassic_name:String;
		/** 列的资源名 */		
		public var title_id:int;
		/** 要查询什么信息：1-角色；2-宠物；0-不查询 */		
		public var show_info:int;
		
		public function RankBasicVo()
		{
		}
	}
}