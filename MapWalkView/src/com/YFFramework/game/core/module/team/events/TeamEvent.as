package com.YFFramework.game.core.module.team.events
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 下午2:03:31
	 * 
	 */
	public class TeamEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.team.events.";
		
		public static const NearPlayersReq:String = Path + "NearPlayersReq";
		public static const NearTeamsReq:String = Path + "NearTeamsReq";
		public static const InviteReq:String = Path + "InviteReq";
		public static const AccInviteReq:String = Path + "AccInviteReq";
		public static const LeaveReq:String = Path + "LeaveReq";
		public static const JoinReq:String = Path + "JoinReq";
		public static const AccJoinReq:String = Path + "AccJoinReq";
		public static const KickMemberReq:String = Path + "KickMemberReq";
		public static const ChangeLeaderReq:String = Path + "ChangeLeaderReq";
		public static const CloseInviteWindow:String = Path + "CloseInviteWindow";
		
		public function TeamEvent(){
		}
	}
} 