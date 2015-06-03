package com.YFFramework.game.core.module.skill.model
{
	/**
	 * 拖动数据 
	 * @author flashk
	 * 
	 */
	public dynamic class DragData
	{
		//从格子拖动
//		public static var dragFromGrid:String = "dragFromGrid";
		/** 从技能窗口格子 开始拖
		 */		
		public static const From_Skill_Grid:String="dragFromSkillWindow";
		/**从快捷栏拖技能
		 */		
		public static const From_QuickBox_SKill:String="From_QuickBox_SKill";
		/**从快捷栏拖道具
		 */		
		public static const From_QuickBox_Item:String="From_QuickBox_Item";
		//从背包拖动
		public static const FROM_BAG:String = "dragFromBag";
		public static const FROM_DEPOT:String = "dragFromDepot";
		//从角色拖动
		public static const FROM_CHARACTER:String = "dragFromCharacter";
		public static const FROM_TRADE:String = "dragFromTrade";
		
		/**挂机面板 */		
		public static const FROM_AUTO:String="dragFromAuto";
		/**翅膀面板 */		
		public static const FROM_WING:String="dragFromWing";
		//从寄售物品拖动
		public static const FROM_CONSIGNMENT:String = "dragFromConsignment";
		//求购——筛选面板下拖动
		public static const FROM_SIFT_WINDOW:String = "dragFromSiftWindow";
		
		/**从哪里拖到哪里	- 例如：FROM_BAG 
		 */		
		public var type:String;
		public var id:int;
		public var from:String;
		/**背包位置 
		 */
		public var fromID:int;
		public var to:String;
		public var toID:int;
		/**data包括type：物品类型：1.装备;2.道具。id:物品动态id 
		 */		
		public var data:Object;
		
		public function DragData()
		{
			
		}
		
	}
}