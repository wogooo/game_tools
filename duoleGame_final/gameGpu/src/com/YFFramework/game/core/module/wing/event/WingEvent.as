package com.YFFramework.game.core.module.wing.event
{
	/**
	 * @version 1.0.0
	 * creation time：2013-9-27 下午1:26:37
	 */
	public class WingEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.wing.event.";
		
		public static const LvUpWingReq:String = Path + "LvUpWingReq";
		public static const LvUpWingResp:String = Path + "LvUpWingResp";
		public static const FeatherReq:String = Path + "FeatherReq";
		public static const FeatherResp:String = Path + "FeatherResp";
		public static const FeatherRemoveReq:String = Path + "FeatherRemoveReq";
		public static const FeatherRemoveResp:String = Path + "FeatherRemoveResp";
		/**翅膀升级完成后通知背包模块更新数据*/		
		public static const WingLvUpBagUpdate:String = Path + "WingLvUpBagUpdate";
		
		public function WingEvent(){
		}
		
	}
} 