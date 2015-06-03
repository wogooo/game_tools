package com.dolo.ui.tools
{

	/**
	 * HTML 格式化辅助 
	 * @author flashk
	 * 
	 */
	public class HTMLFormat
	{
		/**
		 * 将某个字符串转为带颜色的受flash支持的HTML字符串 
		 * @param textStr
		 * @param color 颜色
		 * @param isBold 是否加粗
		 * @return 
		 * 
		 */
		public static function color(textStr:String,color:uint,isBold:Boolean=false):String
		{
			var str:String;
			str = '<font color="#'+color.toString(16)+'">'+textStr+'</font>';
			if(isBold == true){
				str = '<b>'+str+'</b>';
			}
			return str;
		}
	}
}