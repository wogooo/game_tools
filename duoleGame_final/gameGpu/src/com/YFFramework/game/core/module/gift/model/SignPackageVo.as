package com.YFFramework.game.core.module.gift.model
{
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;

	/***
	 *签到礼包VO
	 *@author ludingchang 时间：2013-7-12 下午6:04:58
	 */
	public class SignPackageVo
	{
		/**礼包ID*/
		public var id:int;
		/**礼包名*/
		public var name:String;
		/**状态*/
		public var state:int;
		/**礼包里包含的道具的ID*/
		public var items:Vector.<ActiveRewardBasicVo>;
	}
}