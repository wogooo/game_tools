package com.YFFramework.game.core.module.pet.events
{
	/**2012-9-18 下午4:28:42
	 *@author yefeng
	 */
	public class PetEvent
	{
		
		private static const Path:String="com.YFFramework.game.core.module.pet.events.";
		/**服务端返回 宠物列表
		 */		
		public static const S_RequestPetList:String=Path+"S_RequestPetList";
		/**客户端请求宠物出战
		 */		
		public static const C_PetPlay:String=Path+"C_PetPlay";
		
		/**服务端返回宠物出战
		 */ 
		public static const S_PetPlay:String=Path+"S_PetPlay";
		/**宠物收回
		 */		
		public static const C_PetCallBack:String=Path+"C_PetCallBack";
		/**宠物收回
		 */		
		public static const S_PetCallBack:String=Path+"S_PetCallBack";
		
		
		
		
		////ui面板
		/**宠物面板某个子列表被选中
		 */		
		public static const PetListCellViewSelect:String=Path+"PetListCellViewSelect";
		
		public function PetEvent()
		{
		}
	}
}