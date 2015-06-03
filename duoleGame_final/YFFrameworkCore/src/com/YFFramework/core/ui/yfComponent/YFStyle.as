package com.YFFramework.core.ui.yfComponent
{

	/**  组件风格
	 *  2012-6-20
	 *	@author yefeng
	 */
	public class YFStyle
	{
//		public var color:uint;
//		/**  边框颜色  可能是窗口边框 也可能是文本边框
//		 */
//		public var borderColor:uint;
//		public var borderSize:uint;
//		public var radius:int;
//		public var fontName:String;
//		public var embedFonts:Boolean;
//		public var fontSize:int;
//		public var heightOffset:int = 0;
//		public var widthOffset:int = 0;
		
		/** 字体
		 */
		public var isBold:Boolean = false;
		
		public var fontSize:int=12;
		public static const font:String="_sans";
		/** 是否具有背景色   大于等于0表示具有背景色   背景色有可能 没有 也有可能有 也有可能是 链接类 
		 */
		public var backgroundColor:int=-1;   
		
		/**  弹起  划上 按下 禁用的颜色值
		 */		
		public var upColor:int;
		public var overColor:int;
		public var downColor:int;
		public var disableColor:int;
		
		/**链接的皮肤
		 */
		public var link:Object;
		/** 使用9切片时  各个线距离边距的距离  
		 */		
		public var scale9L:int=5;
		public var scale9R:int=5;
		public var scale9T:int=5;
		public var scale9B:int=5;
			
	}
}