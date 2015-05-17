package com.YFFramework.game.core.global.model
{
	public class CharacterPointBasicVo
	{

		public var profession:int;
		
		/**
		 * 智力 
		 */		
		public var int_add:int;
		
		/**
		 * 精神
		 */		
		public var spi_add:int;
		
		/**
		 * 敏捷 
		 */		
		public var agi_add:int;
		
		/**
		 * 体质 
		 */		
		public var phy_add:int;
		
		/**
		 * 力量 
		 */		
		public var str_add:int;
		/**男性图像
		 */		
		public var male_ShowId:int;
		/**女性大图像
		 */		
		public var female_ShowId:int;
		/**男性小图像
		 */		
		public var maleIcon:int;
		
		/**女性小图像
		 */
		public var femaleIcon:int;
		
		/**男性中图像
		 */		
		public var maleTeamIcon:int;
		
		/**女性中图像
		 */
		public var femaleTeamIcon:int;

		public function CharacterPointBasicVo()
		{
		}
	}
}