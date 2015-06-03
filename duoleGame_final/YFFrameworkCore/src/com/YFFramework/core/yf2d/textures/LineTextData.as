package com.YFFramework.core.yf2d.textures
{
	/**单行文本数据
	 * @author yefeng
	 * 2013 2013-5-29 上午10:18:06 
	 */
	public class LineTextData
	{
		/**文本
		 */		
		public var text:String;
		/** 颜色
		 */		
		public var color:uint;
		/**大小
		 */		
		public var size:int;
		public function LineTextData()
		{
		}
		public function dispose():void
		{
			text=null;
		}
	}
}