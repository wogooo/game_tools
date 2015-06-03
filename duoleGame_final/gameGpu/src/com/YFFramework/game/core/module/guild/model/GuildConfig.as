package com.YFFramework.game.core.module.guild.model
{
	import com.YFFramework.game.core.global.manager.ConfigDataManager;

	/***
	 *有关公会的配置，变量为从ConfigData表读取
	 *@author ludingchang 时间：2013-8-6 下午3:47:19
	 */
	public class GuildConfig
	{
		/**最小创建公会的等级*/
		public static var GuildMinCreateLv:int;
		/**最小进入公会的等级*/
		public static var GuildMinEnterLv:int;
		/**公告最多可以输入多少个字*/
		public static const GonggaoMaxChars:int=200;
		/**公会创建需要的钱*/
		public static var GuildCreaeMoney:int;
		/**公会改名需要的钱*/
		public static const GuildChangeNameMoney:int=100000;
		/**最大申请公会数*/
		public static const GuildMaxApply:int=20;
		/**最大申请数清空时间间隔*/
		public static const MaxApplyTime:Number=12*3600000;
		/**发布邀请CD*/
		public static const PublicInvatorCoolDown:int=60000;
		/**每天最大免费发布邀请的次数*/
		public static const PublicInvatorMaxFreeCount:int=2;
		/**每天最大收费发布的次数*/
		public static const publicInvatorMaxMoneyCount:int=10;
		/**公会名字最大字符数*/
		public static const GuildNameMaxChars:int=8;
		/**发起弹劾需要的贡献*/
		public static var ImpeachNeedContribution:int;
		/**投票需要的贡献*/
		public static const VoteNeedContribution:int=100;
		/**公会建筑最高等级*/
		public static const GuildBuildingMaxLevel:int=10;
		/**公会商店的ID*/
		public static const GuildShopID:int=101;
		/**投票截止时间*/
		public static const ImpeachTime:int=24*3600;
		/**会长7天不在线的秒数*/
		public static const ImpeachConditionTime:int=7*24*3600;
		/**一个捐献道具可以得到的公会资金量*/
		public static var EachItemGetMoney:int=1000;
		/**一个捐献道具可以得到的公会贡献量*/
		public static var EachItemGetContribution:int=100;
		public function GuildConfig()
		{
		}
	}
}