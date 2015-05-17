package com.YFFramework.game.core.global.util
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-8-24 下午04:32:59
	 * 
	 * 
	 * 滤镜配置
	 */
	public class FilterConfig
	{
		public static const Yellow_Glow_Filter:Array = [new GlowFilter(0xffff00,1,6,6,500,3)];
		public static const Black_Glow_Filter:Array = [new GlowFilter(0x000000,1,2,2,300)];
		public static const Black_name_filter:Array = [new GlowFilter(5143, 1, 2, 2, 5)];
		public static const body_white_filter:Array = [new ColorMatrixFilter([1, 0, 0, 0, 40, 0, 1, 0, 0, 40, 0, 0, 1, 0, 40, 0, 0, 0, 1, 0]), new GlowFilter(16777215, 1, 5, 5, 1, 1), new GlowFilter(16777215, 1, 3, 3, 1, 1, true)];
		public static const dead_filter:Array = [new ColorMatrixFilter([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0])];
		public static const white_glow_filter:Array = [new GlowFilter(0xFFFFFF,1,3,3,5,BitmapFilterQuality.HIGH)];
		public static const yellow_small_filter:Array = [new GlowFilter(0xffff00)];

		public function FilterConfig(){
		}
	}
} 