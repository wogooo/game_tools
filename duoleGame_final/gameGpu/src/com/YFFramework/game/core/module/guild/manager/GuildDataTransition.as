package com.YFFramework.game.core.module.guild.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.GuildInviteVo;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.GuildPlayerLookupInfoVo;
	import com.YFFramework.game.core.module.guild.model.OtherGuildListVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.msg.enumdef.GuildPosition;
	import com.msg.enumdef.RspMsg;
	import com.msg.guild.GuildDetailInfo;
	import com.msg.guild.GuildInfo;
	import com.msg.guild.GuildMember;
	import com.msg.guild.JoinRequestInfo;
	import com.msg.guild.OtherPlayer;
	import com.msg.guild.SGuildInvite;
	import com.msg.guild.SOtherGuildList;

	/***
	 *数据类型转换，vo于msg之间的转换
	 *@author ludingchang 时间：2013-7-17 下午4:57:10
	 */
	public class GuildDataTransition
	{
		public static function transGuildDetailInfoToVo(info:GuildDetailInfo):GuildInfoVo
		{
			var vo:GuildInfoVo=new GuildInfoVo;
			vo.gonggao=info.notice;
			vo.house_lv=info.houseLevel;
			vo.item=new GuildItemVo;
			vo.item.id=info.guildId;
			vo.item.lv=info.guildLevel;
			vo.item.member=info.guildMemberArr.length;
			vo.item.name=info.name;
			vo.item.total=info.maxMemberNumber;
			vo.money=info.money;
			vo.research_lv=info.researchLevel;
			vo.shop_lv=info.shopLevel;
			var mems:Array=info.guildMemberArr;
			var i:int,len:int=mems.length;
			var memVo:GuildMemberVo,data:GuildMember;
			vo.members=new Array(len);
			vo.membersMap=new HashMap;
			for(i=0;i<len;i++)
			{
				data=mems[i];
				memVo=transGuildMemberToVo(data);
				vo.members[i]=memVo;
				vo.membersMap.put(memVo.id,memVo);
				if(memVo.position==GuildPosition.CHAIRMAN)
					vo.item.master=memVo.name;
				else if(memVo.position==GuildPosition.ELITE)
					vo.eliteNum++;
				else if(memVo.position==GuildPosition.VICE_CHAIRMAN)
					vo.viceMasterNum++;
			}
			return vo;
		}
		public static function transGuildMemberToVo(mem:GuildMember):GuildMemberVo
		{
			var vo:GuildMemberVo=new GuildMemberVo;
			vo.career=mem.career;
			vo.contribution=mem.contribution;
			vo.last_time=mem.lastLogin;
			vo.lv=mem.level;
			vo.max_contribution=mem.maxContribution;
			vo.name=mem.name;
			vo.position=mem.position;
			vo.sex=mem.sex;
			vo.id=mem.dyId;
			return vo;
		}
		
		
		public static function transSOtherGuildListToVo(msg:SOtherGuildList):OtherGuildListVo
		{
			var vo:OtherGuildListVo=new OtherGuildListVo;
			if(msg==null)
			{
				vo.current_page=1;
				vo.total_page=1;
				vo.guild_list=[];
				return vo;
			}
			vo.current_page=msg.currentPage;
			vo.total_page=msg.totalPage;
			var guilds:Array=msg.guildInfoArr;
			var i:int,len:int=guilds.length;
			var guild_item:GuildItemVo,guild_info:GuildInfo;
			vo.guild_list=new Array(len);
			for(i=0;i<len;i++)
			{
				guild_info=guilds[i];
				guild_item=transGuildInfoToVo(guild_info);
				vo.guild_list[i]=guild_item;
			}
			return vo;
		}
		
		public static function transGuildInfoToVo(guild_info:GuildInfo):GuildItemVo
		{
			var guild_item:GuildItemVo=new GuildItemVo;
			guild_item.id=guild_info.guildId;
			guild_item.lv=guild_info.level;
			guild_item.master=guild_info.chairmanName;
			guild_item.member=guild_info.memberNumber;
			guild_item.name=guild_info.guildName;
			guild_item.total=guild_info.maxMemberNumber;
			return guild_item;
		}
		public static function transReMemberToVo(mems:Array):Array
		{
			var i:int,len:int=mems.length;
			var item:JoinRequestInfo;
			var temp:Array=new Array;
			for(i=0;i<len;i++)
			{
				item=mems[i];
				temp.push(msgToGuildMemberVo(item));
			}
			return temp;
		}
		public static function msgToGuildMemberVo(item:JoinRequestInfo):GuildMemberVo
		{
			var mem:GuildMemberVo=new GuildMemberVo;
			mem.id=item.dyId;
			mem.name=item.name;
			mem.career=item.career;
			mem.lv=item.level;
			mem.sex=item.sex;
			mem.last_time=item.reqTime;
			return mem;
		}
		public static function tranOtherPlyerToVo(o:OtherPlayer):GuildPlayerLookupInfoVo
		{
			var vo:GuildPlayerLookupInfoVo=new GuildPlayerLookupInfoVo;
			vo.career=o.career;
			if(o.hasGuildName)
				vo.guildName=o.guildName;
			else
				vo.guildName="";
//			vo.icon=;
			vo.id=o.dyId;
			vo.lv=o.level;
			vo.name=o.name;
			vo.sex=o.sex;
			return vo;
		}
		public static function tranSGuildInviteToVo(msg:SGuildInvite):GuildInviteVo
		{
			var vo:GuildInviteVo=new GuildInviteVo;
			vo.guildId=msg.guildId;
			vo.guildName=msg.guildName;
			vo.inviterName=msg.inviteName;
			return vo;
		}
	}
}