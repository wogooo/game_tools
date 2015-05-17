package utils
{
	import flash.utils.Dictionary;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5上午10:38:53
	 */
	public class CommonUtil
	{
		public function CommonUtil()
		{
		}
		
		/**得到哈希数组的长度
		 */
		public static function GetDictLen(dict:Dictionary):int
		{
			var len:int=0;
			for each (var item:Object in dict)
			{
				len++;
			}
			return len;
		}
		
		
		
		/**得到url的具体信息    动作 ---方向  ----帧数
		 */
		public static function GetURLData(url:String):Vector.<int>
		{
			var index:int=url.lastIndexOf("/");
			url=url.substring(index+1); ///得到了 x-y-z.png格式的url
			index=url.indexOf(".");
			url=url.substring(0,index); ///变成 x-y-z形式的字符串
			
			var arr:Array=url.split("-");
			return Vector.<int>([int(arr[0]),int(arr[1]),int(arr[2])]);
		}
		
		
	
		
		
	}
}