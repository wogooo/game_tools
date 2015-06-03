package com.YFFramework.game.core.module.guild.model
{
	import com.msg.enumdef.GuildPosition;

	/***
	 *
	 *@author ludingchang 时间：2013-7-16 下午4:44:34
	 */
	public class TypeGuild
	{
		/**会长*/
		public static const position_master:int=GuildPosition.CHAIRMAN;
		/**副会长*/
		public static const position_vice_master:int=GuildPosition.VICE_CHAIRMAN;
		/**精英*/
		public static const position_elite:int=GuildPosition.ELITE;
		/**帮众*/
		public static const position_normal:int=GuildPosition.MEMBER;
		
		/**
		 *根据职位等级取职位名 
		 * @param position 职位等级
		 * @return 职位名
		 */		
		public static function getPositionName(position:int):String
		{
			switch(position)
			{
				case position_master:return "会长";
				case position_vice_master:return "副会长";
				case position_elite:return "精英";
				case position_normal:return "帮众";
			}
			return "";
		}
		
		/**
		 *是否可以发布公告 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return 是true/否false
		 * 
		 */		
		public static function canPostGonggao(pos:int):Boolean
		{
			//会长和副会长可以发公告
			if(pos==position_master || pos==position_vice_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以发布邀请 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return 是否
		 * 
		 */			
		public static function canPostInvater(pos:int):Boolean
		{
			if(pos==position_master || pos==position_vice_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以邀请入会 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return true/false
		 * 
		 */		
		public static function canAskInvater(pos:int):Boolean
		{
			if(pos==position_master || pos==position_vice_master)
				return true;
			else 
				return false;
		}
		/**
		 *是否可以招收成员 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return 
		 * 
		 */		
		public static function canAddMember(pos:int):Boolean
		{
			if(pos==position_master || pos==position_vice_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以升级建筑 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return 
		 * 
		 */		
		public static function canUpgradeBuilding(pos:int):Boolean
		{
			if(pos==position_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以移交会长 （拥有这项权利，只是条件之一）
		 * @param pos 职位
		 * @return 
		 * 
		 */		
		public static function canChangeMaster(pos:int):Boolean
		{
			if(pos==position_master)
				return true;
			else 
				return false;
		}
		/**
		 *是否可以解散工会（拥有这项权利，只是条件之一） 
		 * @param pos 职位
		 * @return 
		 */		
		public static function canBreakGuild(pos:int):Boolean
		{
			if(pos==position_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以任命 
		 * @param pos
		 * @return 
		 * 
		 */		
		public static function canSetPosition(pos:int):Boolean
		{
			if(pos==position_master || pos==position_vice_master)
				return true;
			else
				return false;
		}
		/**
		 *是否可以开除成员 
		 * @param pos
		 * @return 
		 * 
		 */		
		public static function canFireMember(pos:int):Boolean
		{
			if(pos==position_master || pos==position_vice_master)
				return true;
			else
				return false;
		}
	}
}