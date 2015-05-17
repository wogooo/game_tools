package com.YFFramework.game.core.module.mapScence.model
{
	/** buff改变
	 * @author yefeng
	 * 2013 2013-3-26 下午7:37:25 
	 */
	public class BuffChangeVo
	{
		public var dy_id = 1;       // 中buff者的ID
		required int32 buff_id = 2;
		required int32 calc_type = 3;   // 效果计算类型
		optional int32 hp_change = 4;   // 血量改变
		optional int32 hp = 6;          // 生命值，对角色和宠物
		optional int32 mp_change = 7;   // 魔法改变
		optional int32 mp = 9;          // 魔法值，对角色和宠物

		public function BuffChangeVo()
		{
		}
	}
}