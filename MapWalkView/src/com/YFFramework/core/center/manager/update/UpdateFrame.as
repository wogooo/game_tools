package com.YFFramework.core.center.manager.update
{
	import flash.utils.Dictionary;

	/** 更新帧 ， 这里指的是 每多少帧执行一次注册的函数
	 * author :夜枫
	 * 时间 ：2012-1-4 下午04:28:00
	 */
	public class UpdateFrame implements IUpdate
	{
		/** 每多少帧进行更新一次
		 */
		private var updateRate:int;
		private var index:int;
		private var funcDict:Vector.<Function>;
		/**_updateRate表示每多少帧执行一次注册的函数
		 */
		public function UpdateFrame(_updateRate:int=30)
		{
			updateRate=_updateRate;
			index=0;
			funcDict=new Vector.<Function>();
		}
		/**enterFrame里执行
		 */		
		public function update():void
		{
			++index;
			if(index==updateRate)
			{
				//执行
				for each (var func:Function in funcDict)
					func();//执行注册了函数
			//	index =index%updateRate;
				index =0;
			}
		}
		
		/**注册需要更新的函数
		 */		
		public function  regFunc(func:Function):void
		{
			var index:int=funcDict.indexOf(func);
			if(index==-1)funcDict.push(func);
		}
		/** 卸载更新函数
		 */		
		public function  delFunc(func:Function):void
		{
			var index:int=funcDict.indexOf(func);
			if(index!=-1) funcDict.splice(index,1)
		}
		/** 是否已经进行了注册 
		 */
		public function isReg(func:Function):Boolean
		{
			var index:int=funcDict.indexOf(func);
			if(index==-1)return false;
			return true;
		}
		
	}
}