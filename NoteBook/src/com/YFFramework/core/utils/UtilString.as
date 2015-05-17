package com.YFFramework.core.utils
{
	/**  2012-7-12
	 *	@author yefeng
	 */
	public class UtilString
	{
		public function UtilString()
		{
		}
		
		/**得到字符串后缀 .的后面 后缀 比如  a.swf 得到  swf 
		 */		
		public static function getSuffix(url:String):String
		{
			var index:int=url.lastIndexOf(".");
			var suffix:String=url;
			if(index!=-1)
			{
				suffix=url.substring(index+1);//后缀
			}
			return suffix;
		}
		/**得到文件的名称 比如  a/b.swf 得到  b.swf
		 */
		public static function getFileName(url:String):String
		{
			var index:int=url.lastIndexOf("/");
			var name:String=url;
			if(index!=-1)
			{
				name=url.substring(index+1);
			}
			return name;
		}
		
		/**得到没有点 的名称  比如   a/b.swf  得到  b
		 */
		public static function getExactName(url:String):String
		{
			var str:String=getFileName(url);
			var index:int=str.lastIndexOf(".");
			if(index!=-1)
			{
				str=str.substring(0,index);
				return str;
			}
			return str;
		}
		
	}
}