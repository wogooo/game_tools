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
	 * 滤镜配置
	 */
	public class FilterConfig{
		
		public static const Black_Glow_Filter:Array = [new GlowFilter(0x000000,1,2,2,300)];
		public static const Black_name_filter:Array = [new GlowFilter(5143, 1, 2, 2, 5)];
		public static const body_white_filter:Array = [new ColorMatrixFilter([1, 0, 0, 0, 40, 0, 1, 0, 0, 40, 0, 0, 1, 0, 40, 0, 0, 0, 1, 0]), new GlowFilter(16777215, 1, 5, 5, 1, 1), new GlowFilter(16777215, 1, 3, 3, 1, 1, true)];
		/**灰色矩阵
		 */		
		public static const dead_filter:Array = [new ColorMatrixFilter([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0])];
		public static const Yellow_Small_Filter:Array = [new GlowFilter(0xffff00)];
		public static const text_filter:Array = [new GlowFilter(0x000000,1,2,2,2.55,BitmapFilterQuality.LOW)];
		
	
		/**新定义的白色滤镜
		 */
		public static const White_Glow_Filter:Array = [new GlowFilter(0xFFFFFF,1,8,8,3.91,BitmapFilterQuality.LOW)];
		/**新定义的黄色滤镜
		 */
		public static const Yellow_Glow_Filter:Array = [new GlowFilter(0xFFCC00,1,8,8,3.91,BitmapFilterQuality.LOW)];
		 
		public static const Blue_Glow_Filter:Array = [new GlowFilter(0x08f6ff,1,8,8,3.91,BitmapFilterQuality.LOW)];
		
		public function FilterConfig(){
		}
	}
}