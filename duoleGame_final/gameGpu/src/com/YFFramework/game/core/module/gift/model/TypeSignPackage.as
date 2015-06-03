package com.YFFramework.game.core.module.gift.model
{
	/***
	 *签到礼包类型定义
	 *@author ludingchang 时间：2013-7-31 下午3:25:44
	 */
	public class TypeSignPackage
	{
		/**已领取*/
		public static const State_HasGet:int=1;
		/**可以领取*/
		public static const State_CanGet:int=2;
		/**条件未买足，不能领取*/
		public static const State_CannotGet:int=3;
		
		public static function getStateName(state:int):String
		{
			switch(state)
			{
				case State_CanGet:return "领取";
				case State_CannotGet:return "条件未满足";
				case State_HasGet:return "已领取";
			}
			return "";
		}
	}
}