package com.YFFramework.game.core.module.guild.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildImpeachState;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.GuildInviteVo;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.OtherGuildListVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;

	/***
	 *公会信息管理类
	 *@author ludingchang 时间：2013-7-17 下午5:09:54
	 */
	public class GuildInfoManager
	{
		private static var _inst:GuildInfoManager;
		
		private var _me:GuildMemberVo;
		
		public var myGuildInfo:GuildInfoVo;
		public var otherGuildList:OtherGuildListVo;
		public var selected_member:GuildMemberVo;
		/** 预备公会成员（请求加入我的公会的申请者列表）
		 */		
		public var reMembers:Array;//GuildMemberVo
		/**邀请公会列表（别的公会发给我的邀请我加入公会的信息列表）*/
		public var invite_data:Array;
		/**是否有公会*/
		public var hasGuild:Boolean=false;
		/**申请列表(我申请请求加入别人公会的公会列表)*/
		public var applys:Array;
		/**今日已发布的邀请次数*/
		public var invater_count:int;
		/**弹劾状态*/
		public var impeach_state:int=GuildImpeachState.NoImpeach;
		/**发起弹劾的人的ID*/
		public var impeacher_id:int;
		/**投票截止时间*/
		public var impeacher_time:int;
		
		public static function get Instence():GuildInfoManager
		{
			if(!_inst)
				_inst=new GuildInfoManager;
			return _inst;
		}
		
		public function GuildInfoManager()
		{
			invite_data=[];
			reMembers=[];
			applys=[];
			otherGuildList=new OtherGuildListVo;
			otherGuildList.current_page=1;
			otherGuildList.guild_list=[];
			otherGuildList.total_page=1;
		}
		
		/**
		 *根据ID查成员 
		 * @param id 成员id
		 * @param del 是否删除该成员
		 * @return 成员vo
		 * 
		 */		
		public function findMemberById(id:int,del:Boolean=false):GuildMemberVo
		{
			var member:GuildMemberVo;
			if(myGuildInfo)
			{
				member=myGuildInfo.membersMap.get(id);
				if(member && del)
				{
					var members:Array=myGuildInfo.members;
					var i:int,len:int=members.length;
					var temp:GuildMemberVo;
					for(i=0;i<len;i++)
					{
						temp=members[i];
						if(temp.id==id)
						{
							members.splice(i,1);
							len--;
							myGuildInfo.item.member=myGuildInfo.members.length;
							if(temp.position==TypeGuild.position_elite)
								myGuildInfo.eliteNum--;
							else if(temp.position==TypeGuild.position_vice_master)
								myGuildInfo.viceMasterNum--;
							myGuildInfo.membersMap.remove(member.id);
							break;
						}
					}
				}
			}
			return member;
		}
		
		/**
		 *取某职位的所有成员 
		 * @param pos：职位
		 * @return 成员数组
		 * 
		 */		
		public function findMemberByPostion(pos:int):Vector.<GuildMemberVo>
		{
			var members:Array=myGuildInfo.members;
			var i:int,len:int=members.length;
			var temp:GuildMemberVo;
			var result:Vector.<GuildMemberVo>=new Vector.<GuildMemberVo>;
			for(i=0;i<len;i++)
			{
				temp=members[i];
				if(temp.position==pos)
				{
					result.push(temp);
				}
			}
			return result;
		}
		
		/**
		 * 根据ID判断是否和自己是同一个公会
		 * @param dyId 角色ID
		 * @return 同公会（true）\否则（false）
		 * 
		 */		
		public function isGuildMate(dyId:int):Boolean
		{
			var vo:GuildMemberVo=findMemberById(dyId);
			if(vo)
				return true;
			else 
				return false;
		}
		/**
		 *添加成员 
		 * @param member 新成员信息
		 * 
		 */		
		public function addMember(member:GuildMemberVo):void
		{
			myGuildInfo.item.member=myGuildInfo.members.push(member);
			myGuildInfo.membersMap.put(member.id,member);
			if(member.position==TypeGuild.position_elite)
				myGuildInfo.eliteNum++;
			else if(member.position==TypeGuild.position_vice_master)
				myGuildInfo.viceMasterNum++;
		}
		
		/**
		 *添加邀请数据 
		 * @param vo
		 * 
		 */		
		public function addInviteData(vo:GuildInviteVo):void
		{
			var i:int,len:int=invite_data.length;
			var temp:GuildInviteVo,id:int=vo.guildId;
			for(i=0;i<len;i++)
			{
				temp=invite_data[i];
				if(temp.guildId==id)
				{
					invite_data.splice(i,1);
					break;
				}
			}
			invite_data.push(vo);
			if(invite_data.length>20)
				invite_data.shift();
		}
		/**
		 *从邀请列表中移除指定项 
		 * @param vo
		 * 
		 */		
		public function removeInvite(vo:GuildInviteVo):void
		{
			var index:int=invite_data.indexOf(vo);
			if(index!=-1)
			{
				invite_data.splice(index,1);
			}
		}
		/**
		 *移交会长 
		 * @param newMaster 新会长ID
		 * 
		 */		
		public function changeMaster(newMaster:int):GuildMemberVo
		{
			var members:Array=myGuildInfo.members;
			var i:int,len:int=members.length;
			var old_master:GuildMemberVo;
			var new_master:GuildMemberVo;
			var temp:GuildMemberVo;
			for(i=0;i<len;i++)
			{
				temp=members[i];
				if(temp.id==newMaster)
				{
					new_master=temp;//找到新会长
					if(old_master)//老会长也已经找到
						break;
				}
				if(temp.position==TypeGuild.position_master)
				{
					old_master=temp;//找到老会长
					if(new_master)//新会长已经找到
						break;
				}
			}
			//老会长变为普通成员，新会长成为会长
			old_master.position=TypeGuild.position_normal;
			new_master.position=TypeGuild.position_master;
			myGuildInfo.item.master=new_master.name;
			return new_master;
		}
		
		/**自己的公会信息*/
		public function get me():GuildMemberVo
		{
			_me=findMemberById(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			return _me;
		}
		/**剩余副会长位置数量*/
		public function getRestViceMasterNum():int
		{
			return totalViceMaster()-myGuildInfo.viceMasterNum;
		}
		/**剩余精英位置数*/
		public function getRestEliteNum():int
		{
			return totalElite()-myGuildInfo.eliteNum;
		}
		/**剩余普通成员的位置数*/
		public function getRestNormalNum():int
		{
			return totalNoraml()-(myGuildInfo.item.member-1-myGuildInfo.eliteNum-myGuildInfo.viceMasterNum);
		}
		/**共有副会长位置数*/
		public function totalViceMaster(lv:int=-1):int
		{
			if(lv==-1)
				lv=myGuildInfo.item.lv;
			return int((lv+3)/2);
		}
		/**共有精英数*/
		public function totalElite(lv:int=-1):int
		{
			if(lv==-1)
				lv=myGuildInfo.item.lv;
			return (lv+1)*5;
		}
		/**共可容纳的普通成员数*/
		public function totalNoraml():int
		{
			return myGuildInfo.item.total-1-totalElite()-totalViceMaster();
		}
		
		public function changeBuildingLv(type:int,lv:int):void
		{
			switch(type)
			{
				case TypeBuilding.HALL:
					myGuildInfo.item.lv=lv;
					break;
				case TypeBuilding.RESEARCH:
					myGuildInfo.research_lv=lv;
					break;
				case TypeBuilding.HOUSE:
					myGuildInfo.house_lv=lv;
					myGuildInfo.item.total=Guild_BuildingBasicManager.Instance.getMaxMemberByGuildHouseLv(lv);
					break;
				case TypeBuilding.SHOP:
					myGuildInfo.shop_lv=lv;
					break;
			}
		}
		/**
		 *获取对应类型的等级 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getBuildingLv(type:int):int
		{
			switch(type)
			{
				case TypeBuilding.HALL:return myGuildInfo.item.lv;
				case TypeBuilding.HOUSE:return myGuildInfo.house_lv;
				case TypeBuilding.RESEARCH:return myGuildInfo.research_lv;
				case TypeBuilding.SHOP:return myGuildInfo.shop_lv;
			}
			return -1;
		}

		/**
		 *是否有投票的权利 
		 * @return 有（true）\没有（false）
		 * 
		 */		
		public function hasRightToVote():Boolean
		{
			return me.max_contribution>=GuildConfig.VoteNeedContribution;
		}
		
		/**（由公会研究院决定的）技能等级上限*/
		public function get maxSkillLevel():int
		{
			return Guild_BuildingBasicManager.Instance.getEffectValue(TypeBuilding.RESEARCH,myGuildInfo.research_lv);
		}
		
		/**是否有人申请入会*/
		public function hasRemembers():Boolean
		{
			return reMembers.length>0;
		}
		/**是否有权利加人*/
		public function hasRightToAddMember():Boolean
		{
			return TypeGuild.canAddMember(me.position);
		}
		/**添加成员通知图标闪烁*/
		public function flashAddMemberIcon():Boolean
		{
			return hasRemembers()&&hasRightToAddMember();
		}
	}
}