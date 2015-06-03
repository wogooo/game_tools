package com.dolo.ui.sets
{
	/**
	 * 按钮文字颜色样式 
	 * @author Administrator
	 * 
	 */
	public class ButtonTextStyle
	{
		/**
		 * 弹起颜色 
		 */
		public var outColor:uint;
		/**
		 * 划过颜色 
		 */
		public var overColor:uint;
		/**
		 * 按下颜色 
		 */
		public var downColor:uint;
		/**
		 * 选中颜色 
		 */
		public var selectColor:uint;
		
//		public function ButtonTextStyle(out:uint=0x000000,over:uint=0xB9F1FF,down:uint=0x666666,select:uint= 0xB9F1FF)
//		{
//			outColor = out;
//			overColor = over;
//			downColor = down;
//			selectColor = select;
//		}
		public function ButtonTextStyle(out:uint=0x000000,over:uint=0x660033,down:uint=0x000000,select:uint= 0x000000)
		{
			outColor = out;
			overColor = over;
			downColor = down;
			selectColor = select;
		}
		
	}
}