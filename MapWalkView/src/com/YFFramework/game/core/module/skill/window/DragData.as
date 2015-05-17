package com.YFFramework.game.core.module.skill.window
{
	/**
	 * 拖动数据 
	 * @author flashk
	 * 
	 */
	public dynamic class DragData
	{
		public static var dragFromGrid:String = "dragFromGrid";
		public static var FROM_BAG:String = "dragFromBag";
		public static var FROM_DEPOT:String = "dragFromDepot";
		public static var FROM_CHARACTER:String = "dragFromCharacter";
		
		public var type:String;
		public var id:int;
		public var from:String;
		public var fromID:int;
		public var to:String;
		public var toID:int;
		public var data:Object;
		
		public function DragData()
		{
			
		}
		
	}
}