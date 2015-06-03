package com.YFFramework.game.ui.yf2d.view.avatar.pool
{
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	
	/**@author yefeng
	 * 2013 2013-7-6 下午4:53:55 
	 */
	public class YF2dMovieClipArray
	{
		private  var arr:Vector.<ATFMovieClip>;
		private  var _len:int;
		/**最大长度
		 */		
		private var _maxLen:int;
		public function YF2dMovieClipArray(len:int)
		{
			arr=new Vector.<ATFMovieClip>();
			_maxLen=len;
		}
		
		public function  push(yf2dMovieClip:ATFMovieClip):void
		{
			var index:int=arr.indexOf(yf2dMovieClip);
			if(index==-1)
			{
				arr.push(yf2dMovieClip);
				_len++;
			}
		}
		/** 获取一个对象
		 */		
		public function  pop():ATFMovieClip
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