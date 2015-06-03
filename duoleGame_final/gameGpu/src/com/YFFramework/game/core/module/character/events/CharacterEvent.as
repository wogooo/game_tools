package com.YFFramework.game.core.module.character.events
{
	/**人物模块 事件
	 * 2012-8-23 下午3:52:45
	 *@author yefeng
	 */
	public class CharacterEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.character.events.";
		/**客户端请求脱下装备
		 */		
		public static const C_PutOffEquip:String=Path+"C_PutOffEquip";
		
		public static const C_AddPointReq:String=Path+"AddPointReq";
		/**
		 * 客户端穿上装备 
		 */		
		public static const C_PutOnEquip:String=Path+"C_PutOnEquip";
		
		/**打开称号面板 
		 */		
//		public static const C_OpenTitlePanel:String=Path+"C_OpenTitlePanel";
		
		/**关闭称号面板 
		 */		
//		public static const C_CloseTitlePanel:String=Path+"C_CloseTitlePanel";
		/**关闭称号面板(带参数从0起，分类-1)  */	
		public static const title_type_change:String=Path+"title_type_change";
		/**
		 *修理装备 
		 */		
		public static const C_CRepairEquipReq:String=Path+"C_CRepairEquipReq";
		
		/** 套装强化属性改变 */		
		public static const EquipStrengthLevelChange:String=Path+"SuitStrengthChange";
		
		public function CharacterEvent()
		{
		}
	}
}