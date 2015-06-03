package com.YFFramework.game.ui.yf2d.view.avatar.pool
{
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;

	/**@author yefeng
	 * 2013 2013-7-6 下午4:53:55 
	 */
	public class Part2dCombineArray
	{
		private  var arr:Vector.<Part2DCombine>;
		private  var _len:int;
		/**最大长度
		 */		
		private var _maxLen:int;
		public function Part2dCombineArray(len:int)
		{
			arr=new Vector.<Part2DCombine>();
			_maxLen=len;
			_len=0;
		}
		
		public function  push(part2DCombine:Part2DCombine):void
		{
			var index:int=arr.indexOf(part2DCombine);
			if(index==-1)
			{
				arr.push(part2DCombine);
				_len++;
			}
		}
		/** 获取一个对象
		 */		
		public function  pop():Part2DCombine
		{
			_len--;
			return arr.pop()
		}
		/**数组长度
		 */		
		public function get length():int
		{
			return _len;	
		}
		/**是否能够继续放物品
		 */		
		public function canPush():Boolean
		{
			if(_len<_maxLen)return true;
			return false;
		}
		
	}
}