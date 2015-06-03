package com.YFFramework.game.core.module.mapScence.model
{
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;

	/** 动作数据
	 * @author yefeng
	 * 2013 2013-5-24 上午10:29:12 
	 */
	public class UseActionData
	{
		/**该攻击能否使用 只有 当数据存在  时才能使用
		 */		
		public var canUse:Boolean;
		/**数据对象
		 */		
		public var actionData:ATFActionData;
		public function UseActionData()
		{
			canUse=false
		}
	}
}