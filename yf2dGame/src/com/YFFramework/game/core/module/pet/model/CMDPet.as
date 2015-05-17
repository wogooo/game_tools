package com.YFFramework.game.core.module.pet.model
{
	/**
	 * 600-699
	 * 2012-9-18 下午4:20:55
	 *@author yefeng
	 */
	public class CMDPet
	{
		/**请求宠物列表
		 */ 
		public static const C_RequestPetList:int=600;
		/**服务端返回宠物列表的请求
		 */		
		public static const S_RequestPetList:int=600;
		
		/**客户端请求宠物出战
		 */		
		public static const C_PetPlay:int=601;
		/** 服务端返回 宠物出战
		 */		
		public static const S_PetPlay:int=601;
		
		/**宠物收回
		 */		
		public static const C_PetCallBack:int=602;
		/**宠物收回返回
		 */		
		public static const S_PetCallBack:int=602;
		
		public function CMDPet()
		{
		}
	}
}