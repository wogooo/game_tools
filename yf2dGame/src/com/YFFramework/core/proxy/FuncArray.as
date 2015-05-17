package com.YFFramework.core.proxy
{
	/**函数收集
	 * @author yefeng
	 *2012-8-18上午8:47:05
	 */
	public class FuncArray
	{
		private var arr:Vector.<Function>;
		public function FuncArray()
		{
			arr=new Vector.<Function>();
		}
		/**注册函数
		 */		
		public function regFunc(func:Function):void
		{
			var index:int=arr.indexOf(func);
			if(index==-1) arr.push(func);
		}
		/**删除函数
		 */		
		public function delFunc(func:Function):void
		{
			var index:int=arr.indexOf(func);
			if(index!=-1) arr.splice(index,1);
		}
		/**响应
		 */		
		public function trigger():void
		{
			for each(var func:Function in arr)
			{
				func();
			}
		}
		
	}
}