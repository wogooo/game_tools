package com.YFFramework.core.net.parse
{
	

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
			var arr:Array=str.split(/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/g);
		//	var arr:Array=str.split(/,"\G(,|\r?\n|\r|^)" &"(?:""([^""]*+(?>""""[^""]*+)*)""|([^"",\r\n]*+))");
			var newArr:Array=[];
			/// 将 具有双引号的东西去掉
			var reg:RegExp=/\"/g; 
			var myReg:RegExp=/\'/g; //将单引号变成双引号 
			for each(var str:String in arr)
			{
				str=str.replace(reg,""); ///// 去掉所有的的双引号
				str=str.replace(myReg,'"');/// 将单引号变成双引号
				newArr.push(str);
			}
			return newArr;
			
		}
		
		
		/**将这样的对象  变成数组   200_0;f200_0;0_f200;0_200             数组 数组  表示  
		 *  f 表示负号      变成 这样的数组  [{x:,y:},{x:,y:}]
		 */  
//		public static function parseToArray(str:String):Array
//		{
//			var arr:Array=str.split(";");
//			var len:int=arr.length;
//			var cellArr:Array;;
//			var cellStr:String;
//			var returnArr:Array=[];
//			for (var i:int=0;i!=len;++i)
//			{
//				cellStr=arr[i];
//				cellArr=cellStr.split("_");
//				returnArr.push({x:getValue(cellArr[0]),y:getValue(cellArr[1])});
//			}
//			return returnArr;
//		}
//		
//		private static  function getValue(str:String):int
//		{
//			var index:int=str.indexOf("f");
//			if(index!=-1) return -int(str.substring(1));
//			return int(str);
//		}
		
	}
}