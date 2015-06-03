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
		
		
		/**男性 图标id     具体 获取  图像  请到 avartar目录下对应的文件夹获取图像
		 */		
		public var maleIcon:int;
		
		/**女性 图标id 
		 */
		public var femaleIcon:int;

		
		
//		
//		/**男性图像   主界面左上角的图像
//		 */		
//		public var male_ShowId:int;
//		/**女性大图像 主界面左上角的图像
//		 */		
//		public var female_ShowId:int;
//		/**男性小图像      组队图像  请求组队时 的组队图像
//		 */		
//		public var maleIcon:int;
//		
//		/**女性小图像     组队图像  
//		 */
//		public var femaleIcon:int;
//		
//		/**男性中图像  组队图像   已经是队员的图像
//		 */		
//		public var maleTeamIcon:int;
//		
//		/**女性中图像
//		 */
//		public var femaleTeamIcon:int;

		public function CharacterPointBasicVo()
		{
		}
	}
}