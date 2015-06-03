package com.YFFramework.game.core.module.mount.events
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-25 上午11:31:53
	 * 
	 */
	public class MountEvents{
		
		private static const Path:String="com.YFFramework.game.core.module.mount.events.";
		
		public static const DropMountReq:String = Path + "DropMountReq";
		public static const FightMountReq:String = Path + "FightMountReq";
		public static const TakebackMountReq:String = Path + "TakebackMountReq";
		public static const AddSoulReq:String = Path + "AddSoulReq";
		public static const AddSoulConfirmReq:String = Path + "AddSoulConfirmReq";
		public static const TransferReq:String = Path + "TransferReq";
		public static const EnhanceReq:String = Path + "EnhanceReq";
		
		public function MountEvents(){
		}
	}
} 