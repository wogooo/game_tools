package com.YFFramework.game.ui.yf2d.view.avatar.pool
{
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;

	/**@author yefeng
	 * 2013 2013-8-29 下午1:36:30 
	 */
	public class SkillEffect2DViewArray
	{
		private  var arr:Vector.<SkillEffect2DView>;
		private  var _len:int;
		/**最大长度
		 */		
		private var _maxLen:int;
		public function SkillEffect2DViewArray(len:int)
		{
			arr=new Vector.<SkillEffect2DView>();
			_maxLen=len;
		}
		
		public function  push(skillEffect2DView:SkillEffect2DView):void
		{
			var index:int=arr.indexOf(skillEffect2DView);
			if(index==-1)
			{
				arr.push(skillEffect2DView);
				_len++;
			}
		}
		/** 获取一个对象
		 */		
		public function  pop():SkillEffect2DView
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