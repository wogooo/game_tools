package com.YFFramework.game.core.module.guild.event
{
	/***
	 *公会事件定义类
	 *@author ludingchang 时间：2013-7-17 下午1:16:42
	 */
	public class GuildInfoEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.guild.event.";
		
		//===================================================
		//加入公会界面（即人物没有公会时点击公会按钮时）
		//===================================================
		/**打开创建公会界面*/
		public static const ShowCreateWindow:String=Path+"ShowCreateWindow";
		/**查找公会*/
		public static const LookupGuild:String=Path+"LookupGuild";
		/**发送创建公会消息*/
		public static const CreateGuild:String=Path+"CreateGuild";
		/**查看公会详细信息*/
		public static const LookupGuildInfo:String=Path+"LookupGuildInfo";
		/**申请入会*/
		public static const ApplyGuild:String=Path+"ApplyGuild";
		/**发送公会重命名消息*/
		public static const ResetGuildName:String=Path+"ResetGuildName";
		
		
		//===================================================
		//公会信息页按钮事件
		//===================================================
		/**改名按钮，打开改名界面*/
		public static const ResetName:String=Path+"ResetName";
		/**弹劾，打开弹劾界面*/
		public static const Impeach:String=Path+"Impeach";
		/**发布公告，打开发布公告界面*/
		public static const Announce:String=Path+"Announce";
		/**成员招收，打开成员招收界面*/
		public static const AddMember:String=Path+"AddMember";
		/**职位任命按钮点击，打开职位任命界面*/
		public static const Appoint:String=Path+"Appoint";
		/***开除成员，打开开除成员警告窗口*/
		public static const Discharge:String=Path+"Discharge";
		/***移交会长，打开移交会长提示窗口*/
		public static const ChangeMaster:String=Path+"ChangeMaster";
		/**职位介绍，打开职位介绍界面*/
		public static const Introduce:String=Path+"Introduce";
		/**公会捐献，打开公会捐献界面*/
		public static const Contribution:String=Path+"Contribution";
		/**退出公会，打开退出公会提示窗口*/
		public static const ExitGuild:String=Path+"ExitGuild";
		/**发布邀请，在聊天频道发布邀请*/
		public static const PublishInvitor:String=Path+"PublishInvitor";
		/**返回公会，发送返回公会驻地消息给服务器*/
		public static const GoBackGuild:String=Path+"GoBackGuild";
		
		
		//===================================================
		//公会信息页成员表
		//===================================================
		/**选中一个成员*/
		public static const SelectedMember:String=Path+"SelectedMember";
		
		
		//===================================================
		//任命窗口
		//===================================================
		/**发送被任命者的信息给服务器*/
		public static const AppointMember:String=Path+"AppointMember";
		
		
		//===================================================
		//发布公告窗口
		//===================================================
		/**发送公告信息给服务器*/
		public static const PostGonggao:String=Path+"PostGonggao";
		
		
		//===================================================
		//贡献窗口
		//===================================================
		/**向服务器请求我要贡献XX公会资金*/
		public static const Donate:String=Path+"Donate";
		
		
		//===================================================
		//成员招收窗口
		//===================================================
		/**开关查询玩家窗口*/
		public static const LookupMember:String=Path+"LookupMember";
		/**发送同意加入公会消息*/
		public static const AddMemberOK:String=Path+"AddMemberOK";
		/**发送拒绝加入公会消息*/
		public static const AddMemberNo:String=Path+"AddMemberNo";
		
		
		/**聊天窗口发布的邀请返回*/
		public static const chatJoinGuildReq:String=Path+"chatJoinGuildReq";
		
		
		//===================================================
		//玩家查询窗口
		//===================================================
		/**请求查询某个玩家*/
		public static const LookupPlayer:String=Path+"LookupPlayer";
		/**发送邀请入会请求*/
		public static const InvatePlayer:String=Path+"InvatePlayer";
		
		
		//===================================================
		//玩家查看收到公会邀请窗口
		//===================================================
		/**发送同意入会消息*/
		public static const AcceptGuildInvite:String=Path+"AcceptGuildInvite";
		/**发送拒绝入会消息*/
		public static const RejectGuildInvite:String=Path+"RejectGuildInvite";
		
		
		//===================================================
		//其他公会页
		//===================================================
		/**请求其他公会列表，翻页时页要用*/
		public static const AskOtherGuildList:String=Path+"AskOtherGuildList";
		
		
		//===================================================
		//公会建筑页
		//===================================================
		/**发送建筑升级请求*/
		public static const BuildingUpgrade:String=Path+"BuildingUpgrade";
		
		//==================================================
		//投票窗口
		//==================================================
		/**投票，赞成*/
		public static const VoteYes:String = Path + "VoteYes";
		/**投票，反对*/
		public static const VoteNo:String = Path + "VoteNo";
		
		//==================================================
		//公会技能
		//==================================================
		/**技能选中*/
		public static const SkillSelect:String = Path + "SkillSelect";
		/**技能学习*/
		public static const SkillLearn:String = Path + "SkillLearn";
	}
}