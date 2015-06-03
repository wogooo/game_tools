package com.YFFramework.game.core.global.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-9 下午2:35:16
	 */
	public class PetBasicVo{
		
		public var config_id:int;
		public var show_id:int;
		/** 宠物类型 */
		public var pet_type:int;
		public var pet_type_name:String;
		public var strength:int;
		public var agile:int;
		public var intelligence:int;
		public var physique:int;
		public var spirit:int;
		public var strength_apt:int;
		public var agile_apt:int;
		public var intelligence_apt:int;
		public var physique_apt:int;
		public var spirit_apt:int;
		public var phy_add:int;
		public var str_add:int;
		public var agi_add:int;
		public var int_add:int;
		public var spi_add:int;
		/**模型id 
		 */		
		public var model_id:int;
		/**头像id 
		 */		
		public var head_id:int;
		
		public var speed:int;
		
		public function PetBasicVo(){
		}
	}
} 