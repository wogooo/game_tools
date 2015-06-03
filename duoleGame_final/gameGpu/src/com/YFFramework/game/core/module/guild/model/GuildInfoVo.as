package com.YFFramework.game.core.module.guild.model
{
	import com.YFFramework.core.utils.HashMap;

	/***
	 *公会详细信息Vo
	 *@author ludingchang 时间：2013-7-16 下午2:37:54
	 */
	public class GuildInfoVo
	{
		/***公会基本信息*/
		public var item:GuildItemVo;
		/**公会资金*/
		public var money:Number;
		/**公会资金上限*/
//		public var max_money:Number;
		/**公告*/
		public var gonggao:String;
		/**所有成员,存储类型GuildMemberVo*/
		public var members:Array;
		/**成员MAP*/
		public var membersMap:HashMap;
		/**研究院等级*/
		public var research_lv:int;
		/**商店等级*/
		public var shop_lv:int;
		/**房屋等级*/
		public var house_lv:int;
		/**仓库等级*/
//		public var storage_lv:int;
		/**精英数量*/
		public var eliteNum:int;
		/**副会长数量*/
		public var viceMasterNum:int;
	}
}