package com.YFFramework.core.center.manager.keyboard
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午07:21:06
	 */
	internal class KeyboardData
	{
		
		private var funcArr:Vector.<Function>;
		public function KeyboardData()
		{
			funcArr=new Vector.<Function>();
		}
		internal function regFunc(func:Function):void
		{
			var index:int=funcArr.indexOf(func);
			if(index==-1) funcArr.push(func);				
		}
		internal function delFunc(func:Function):void
		{
			var index:int=funcArr.indexOf(func);
			if(index!=-1) funcArr.splice(index,1);
		}
		internal function trigger():void
		{
			for each (var item:Function in funcArr)
				item();
		}
		
	}
}