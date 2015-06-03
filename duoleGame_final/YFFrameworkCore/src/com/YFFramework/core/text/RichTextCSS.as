package com.YFFramework.core.text
{
	import flash.text.StyleSheet;

	/**@author yefeng
	 * 2013 2013-7-9 下午4:10:06 
	 */
	public class RichTextCSS
	{
		public function RichTextCSS()
		{
		}
		/**获取简单的CSS
		 */		
		public static function getTaskCSS():StyleSheet
		{
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover",{color:'#FF0000',fontSize:'12'});
			style.setStyle("a:active ",{color:'#FF0000',fontSize:'12'});
			return style;
		}
		/**获取聊天的CSS
		 */		
		public static function getChatCSS():StyleSheet
		{
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover",{color:'#FF3300',fontSize:'12'});
			return style;
		}
	}
}