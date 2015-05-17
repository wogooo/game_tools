package com.YFFramework.game.core.module.backpack.model
{
	/**背包模块 200-299
	 * 2012-8-17 上午10:58:55
	 *@author yefeng
	 */
	public class CMDBackpack
	{
		/**
		 * 客户端请求仓库列表
		 */
		public static const C_RequestBackpackList:int=200;
		/**
		 * 服务端返回仓库列表
		 */
		public static const S_RequestBackpackList:int=200;
		
		/**客户端发送背包删除丢弃物品
		 */		
		public static const C_DeleteGoods:int=201;
		/**服务端返回背包删除丢弃物品
		 */		
		public static const S_DeleteGoods:int=201;
		
		/**背包内发生物品拖动
		 */		
		public static const C_SimpleMoveGoods:int=205;
		/**服务端返回  背包内物品拖动
		 */		
		public static const S_SimpleMoveGoods:int=205;
		
		/** 客户端发送 使用物品
		 */ 
		public static const C_UseGoods:int=211;
		/** 服务端返回使用物品 
		 */		
		public static const S_UseGoods:int=211;
		
		
		/**增加钱数
		 */
		public static  const   S_AddMoney:int=220;
		/** 删除钱数  花去钱数
		 */
		public static  const   S_DelMoney:int=221;
		
		
	}
}