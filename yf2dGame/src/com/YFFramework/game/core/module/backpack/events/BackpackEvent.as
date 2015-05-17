package com.YFFramework.game.core.module.backpack.events
{
	/**背包模块事件
	 * 2012-8-17 下午4:23:13
	 *@author yefeng
	 */
	public class BackpackEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.backpack.events.";
		/**通知其他面板 执行物品删除
		 */		
		public static const NoticeOtherViewDeleteGoodsVo:String=Path+"NoticeOtherViewDeleteGoodsVo";
		/** 播放  CD
		 */		
		public static const PlayCD:String=Path+"PlayCD";
		
		/**服务端返回 背包列表
		 */		
		public static const S_RequestBackpackList:String=Path+"S_RequestBackpackList";
		/**客户端发送背包删除物品
		 */		
		public static const C_DeleteGoods:String=Path+"C_DeleteGoods";
		/**服务端 返回物品删除
		 */		
		public static const S_DeleteGoods:String=Path+"S_DeleteGoods";

		/**客户端发送背包内 物品进行拖动
		 */		
		public static const C_SimpleMoveGoods:String=Path+"C_SimpleMoveGoods";
		
		/** 服务端返回 背包内物品拖动
		 */		
		public static const S_SimpleMoveGoods:String=Path+"S_SimpleMoveGoods";

		/**客户端发送使用物品   一般指使用消耗性道具
		 */		
		public static const C_UseGoods:String=Path+"C_UseGoods";
		/**服务端返回使用物品
		 */
		public static const S_UseGoods:String=Path+"S_UseGoods";
		
		/**客户端请求  穿上装备  装备道具
		 */		
		public static const C_EquipGoods:String=Path+"C_EquipGoods";
		/**服务端返回  穿上装备  装备道具
		 */		
		public static const S_EquipGoods:String=Path+"S_EquipGoods";
		/**增加钱数
		 */		
		public static const S_AddMoney:String=Path+"S_AddMoney";
		/**删除钱数
		 */		
		public static const S_DelMoney:String=Path+"S_DelMoney";

		
		public function BackpackEvent()
		{
		}
	}
}