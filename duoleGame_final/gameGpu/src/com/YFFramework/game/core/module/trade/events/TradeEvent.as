package com.YFFramework.game.core.module.trade.events
{
	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 上午11:23:53
	 * 
	 */
	public class TradeEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.trade.events.";
		
		public static const CloseInviteWindow:String = Path + "CloseInviteWindow";
		public static const AcceptTrade:String = Path + "AcceptTrade";
		public static const CancelTrade:String = Path + "CancelTrade";
		public static const LockReq:String = Path + "LockReq";
		public static const ConfirmTradeReq:String = Path + "ConfirmTradeReq";
		
		public function TradeEvent(){
		}
	}
}