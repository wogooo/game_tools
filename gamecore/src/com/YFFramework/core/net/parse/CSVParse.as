package com.YFFramework.core.net.parse
{
	import com.YFFramework.core.net.loader.file.FileLoader;

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午12:31:04
	 * 解析CSV文件  csv中的文本是以 逗号 "," 隔开的   
	 */
	public final class CSVParse
	{
		/**csvFileStr指的是CSV文件 内容的字符串
		 * 返回的是每一行 一个元素的数组 也就是返回的数组每一个元素代表一行     该字符串是以行来进行分割的
		 */		
		public static function Parse(csvFileStr:String):Array
		{
			var arr:Array=csvFileStr.split("\r\n");
			return arr;
		}
		/**   将每一行在进行分割 是以 逗号 ",进行分割的" 返回的是某一行中各个信息
		 */		
		public static function  GetCellArr(str:String):Array
		{
			return str.split(",");
		}
	}
}