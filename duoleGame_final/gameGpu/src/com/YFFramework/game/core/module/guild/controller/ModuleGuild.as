package com.YFFramework.game.core.module.guild.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.feed.model.FeedID;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildDataTransition;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.*;
	import com.YFFramework.game.core.module.guild.view.GuildTabWindow;
	import com.YFFramework.game.core.module.guild.view.guildJoin.*;
	import com.YFFramework.game.core.module.guild.view.guildMain.*;
	import com.YFFramework.game.core.module.guild.view.guildMain.addMember.*;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildVoteResult;
	import com.YFFramework.game.core.module.guild.view.guildMain.guildInfo.GuildVoteWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.TypeChannels;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.enumdef.RspMsg;
	import com.msg.guild.*;
	import com.net.MsgPool;
	
	import flash.utils.Dictionary;

	/***
	 *公会模块
	 *@author ludingchang 时间：2013-7-15 上午10:38:54
	 */
	public class ModuleGuild extends AbsModule
	{
		public function ModuleGuild()
		{
			super();
		}
		override public function init():void
		{
			addEvents();
			addSocketEvent();
		}
		private function addSocketEvent():void
		{
			// TODO 添加于服务器通信的接收事件
			MsgPool.addCallBack(GameCmd.SOtherGuildList,SOtherGuildList,reOtherGuildList);//其他公会列表返回
			MsgPool.addCallBack(GameCmd.SSearchGuild,SSearchGuild,reSearchGuild);//更具公会名查公会返回
			MsgPool.addCallBack(GameCmd.SCharacterGuildInfo,SCharacterGuildInfo,reCharacterGuildInfo);//角色请求公会信息返回
			MsgPool.addCallBack(GameCmd.SCreateGuild,SCreateGuild,reCreateGuild);//创建公会返回;
			MsgPool.addCallBack(GameCmd.SQueryGuildInfo,SQueryGuildInfo,reQueryGuildInfo);//查询单个公会信息返回
			MsgPool.addCallBack(GameCmd.SRequestJoinGuild,SRequestJoinGuild,reRequestJoinGuild);//请求加入公会返回
			MsgPool.addCallBack(GameCmd.SAppointPosition,SAppointPosition,reAppointPosition);//任命职位返回
			MsgPool.addCallBack(GameCmd.SSendNotice,SSendNotice,reSendNotice);//发布公告返回
			MsgPool.addCallBack(GameCmd.SKickGuildMember,SKickGuildMember,reKickGuildMember);//提出成员返回
			MsgPool.addCallBack(GameCmd.SShiftChairman,SShiftChairman,reShiftCharman);//移交会长返回
			MsgPool.addCallBack(GameCmd.SExitGuild,SExitGuild,reExitGuild);//退出公会返回
			MsgPool.addCallBack(GameCmd.SGuildDonate,SGuildDonate,reGuildDonate);//公会捐献返回
			MsgPool.addCallBack(GameCmd.SChangeGuildName,SChangeGuildName,reChangeGuildName);//公会改名
			MsgPool.addCallBack(GameCmd.SGetJoinRequestList,SGetJoinRequestList,reGetJoinRequestList);//请求 申请加入公会玩家列表 返回
		    MsgPool.addCallBack(GameCmd.SAcceptJoinRequest,SAcceptJoinRequest,reAcceptJoinRequest);//  接收/拒绝入会申请返回
			MsgPool.addCallBack(GameCmd.SGuildInviteOther,SGuildInviteOther,reGuildInviteOther);//邀请玩家返回
			MsgPool.addCallBack(GameCmd.SGuildSearchPlayer,SGuildSearchPlayer,reGuildSearchPlayer);//查询玩家信息返回
			MsgPool.addCallBack(GameCmd.SAcceptGuildInvite,SAcceptGuildInvite,reAcceptGuildInvite);//接受公会邀请返回
			MsgPool.addCallBack(GameCmd.SUpgradeBuilding,SUpgradeBuilding,reUpgradeBuilding);//公会建筑升级返回
			MsgPool.addCallBack(GameCmd.SAccuseChairman,SAccuseChairman,reAccuseChairman);//发起弹劾会长返回
			MsgPool.addCallBack(GameCmd.SVoteForAccuse,SVoteForAccuse,reVoteForAccuse);//投票反馈
			MsgPool.addCallBack(GameCmd.SQueryVote,SQueryVote,reQueryVote);//投票结果
			MsgPool.addCallBack(GameCmd.SLearnGuildSkill,SLearnGuildSkill,reLearnGuildSkill);//学习公会技能响应
			
			//数据刷新，由服务器主动推过来的
			MsgPool.addCallBack(GameCmd.SNoticeChangeNotify,SNoticeChangeNotify,onNoticeChangeNotify);//公告信息改变
			MsgPool.addCallBack(GameCmd.SEnterGuild,SEnterGuild,onEnterGuild);//玩家自己进入公会收到公会信息
			MsgPool.addCallBack(GameCmd.SEnterGuildNotify,SEnterGuildNotify,onEnterGuildNotify);//其他玩家进入公会时通知
			MsgPool.addCallBack(GameCmd.SPositionChangeNotify,SPositionChangeNotify,onPositionChange);//职位变动通知所有人
			MsgPool.addCallBack(GameCmd.SDonateNotify,SDonateNotify,onDonateNotify);//有人捐献，通知公会所有成员
			MsgPool.addCallBack(GameCmd.SExitGuildNotify,SExitGuildNotify,onExitGuildNotify);//有人离开公会
			MsgPool.addCallBack(GameCmd.SUpgradeBuildingNotify,SUpgradeBuildingNotify,onUpgrageBuildingNotify);//公会建筑升级通知
			MsgPool.addCallBack(GameCmd.SGuildMoneyChange,SGuildMoneyChange,onGuildMoneyChange);//公会资金改变了，通知
			MsgPool.addCallBack(GameCmd.SGuildInvite,SGuildInvite,onGuildInvite);//收到其他玩家邀请入会
			MsgPool.addCallBack(GameCmd.SShiftChairmanNotify,SShiftChairmanNotify,onShiftChairmanNotify);//移交会长通知
			MsgPool.addCallBack(GameCmd.SGuildMemberOffline,SGuildMemberOffline,onGuildMemberOffline);//公会成员下线
			MsgPool.addCallBack(GameCmd.SGuildMemberOnline,SGuildMemberOnline,onGuildMemberOnline);//公会成员上线
			MsgPool.addCallBack(GameCmd.SAccuseStartNotify,SAccuseStartNotify,onAccuseStartNotify);//通知在线成员开始弹劾
			MsgPool.addCallBack(GameCmd.SStopAccuse,SStopAccuse,onStopAccuse);//终止弹劾
			MsgPool.addCallBack(GameCmd.SAccuseResult,SAccuseResult,onAccuseResult);//弹劾最终结果
			MsgPool.addCallBack(GameCmd.SMemberLevelup,SMemberLevelup,onMemberLevelup);//有成员升级
			MsgPool.addCallBack(GameCmd.SMemberContributeChange,SMemberContributeChange,onMemberContributeChange);//公会贡献改变
			MsgPool.addCallBack(GameCmd.SRequestJoinNotify,SRequestJoinNotify,onRequestJoinNotify);//有人申请入会
		}
		
		private function onRequestJoinNotify(msg:SRequestJoinNotify):void
		{
			var newMember:GuildMemberVo=GuildDataTransition.msgToGuildMemberVo(msg.joinInfo);
			GuildInfoManager.Instence.reMembers.push(newMember);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildFlashIconUpdate);
			GuildTabWindow.Instence.update();
		}
		
		private function reLearnGuildSkill(msg:SLearnGuildSkill):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
				var dySkill:SkillDyVo
				if(msg.skillLevel==1)
				{
					dySkill=new SkillDyVo;
					dySkill.skillId=msg.skillId;
					dySkill.skillLevel=msg.skillLevel;
					SkillDyManager.Instance.addSkill(dySkill);
				}
				else
				{
					dySkill=SkillDyManager.Instance.getSkillDyVo(msg.skillId);
					if(dySkill)
						dySkill.skillLevel=msg.skillLevel;
				}
				GuildTabWindow.Instence.update();
			}
			else
//				NoticeUtil.setOperatorNotice("技能学习失败！");
				NoticeManager.setNotice(NoticeType.Notice_id_1329);
		}
		
		private function onMemberContributeChange(msg:SMemberContributeChange):void
		{
			GuildInfoManager.Instence.findMemberById(msg.dyId).contribution=msg.contribution;
			GuildTabWindow.Instence.updateDownInfo();
		}
		
		private function onMemberLevelup(msg:SMemberLevelup):void
		{
			GuildInfoManager.Instence.findMemberById(msg.dyId).lv=msg.level;
			GuildTabWindow.Instence.update();
		}
		
		private function onAccuseResult(msg:SAccuseResult):void
		{
			if(msg.isSuccess)
			{
				var newMaster:GuildMemberVo=GuildInfoManager.Instence.changeMaster(msg.newChairmanId);
				print(this,"弹劾成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1317,TypeChannels.CHAT_CHANNEL_GUILD_NATIVE,newMaster.name);
			}
			else
			{
				accuseFailFeedBack();
			}
			GuildInfoManager.Instence.impeach_state=GuildImpeachState.NoImpeach;
			GuildTabWindow.Instence.update();
		}
		/**弹劾失败反馈*/
		private function accuseFailFeedBack():void
		{
			print(this,"弹劾失败");
			var guildInfo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			if(guildInfo)
			{
				var masterName:String=guildInfo.item.master;
				NoticeManager.setNotice(NoticeType.Notice_id_1318,TypeChannels.CHAT_CHANNEL_GUILD_NATIVE,masterName);
			}
		}
		
		private function onStopAccuse(msg:SStopAccuse):void
		{
			GuildInfoManager.Instence.impeach_state=GuildImpeachState.NoImpeach;
			GuildTabWindow.Instence.update();
			accuseFailFeedBack();
		}
		
		private function reQueryVote(msg:SQueryVote):void
		{
			var voteResult:GuildVoteResult=GuildVoteResult.Instence;
			voteResult.setData(msg.supportNumber,msg.notSupportNumber,msg.totalNumber);
			voteResult.open();
		}
		
		private function reVoteForAccuse(msg:SVoteForAccuse):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
				GuildInfoManager.Instence.impeach_state=GuildImpeachState.Reader;
				if(msg.hasVoteRes)
				{
					var voteResult:GuildVoteResult= GuildVoteResult.Instence;
					voteResult.setData(msg.voteRes.supportNumber,msg.voteRes.notSupportNumber,msg.voteRes.totalNumber);
					voteResult.open();
				}
			}
			else
				print(this,"投票失败");
		}
		
		private function onAccuseStartNotify(msg:SAccuseStartNotify):void
		{
			if(GuildInfoManager.Instence.hasRightToVote())
				GuildInfoManager.Instence.impeach_state=GuildImpeachState.Voter;
			else
				GuildInfoManager.Instence.impeach_state=GuildImpeachState.Reader;
			
			GuildInfoManager.Instence.impeacher_id=msg.dyId;
			GuildInfoManager.Instence.impeacher_time=msg.finishTime;
			GuildTabWindow.Instence.update();
			var impeacher_name:String=GuildInfoManager.Instence.findMemberById(msg.dyId).name;
			var master_name:String=GuildInfoManager.Instence.myGuildInfo.item.master;
			NoticeManager.setNotice(NoticeType.Notice_id_1316,TypeChannels.CHAT_CHANNEL_GUILD_NATIVE,impeacher_name,master_name);
		}
		
		private function reAccuseChairman(msg:SAccuseChairman):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
				GuildInfoManager.Instence.impeach_state=GuildImpeachState.Impeacher;
				var voteResult:GuildVoteResult=GuildVoteResult.Instence;
				voteResult.setData(msg.voteRes.supportNumber,msg.voteRes.notSupportNumber,msg.voteRes.totalNumber);
				voteResult.open();
				print(this,"发起弹劾成功");
			}
			else
			{
				print(this,"发起弹劾失败");
			}
		}
		
		private function reSearchGuild(msg:SSearchGuild):void
		{
			var otherList:OtherGuildListVo=new OtherGuildListVo;
			otherList.current_page=1;
			otherList.total_page=1;
			otherList.guild_list=[];
		    if(msg&&msg.guildInfo)
			{
				var guild:GuildItemVo;
				guild=GuildDataTransition.transGuildInfoToVo(msg.guildInfo);
				otherList.guild_list.push(guild);
			}
			GuildInfoManager.Instence.otherGuildList=otherList;
			if(GuildInfoManager.Instence.hasGuild)
			{//更新其他公会页
				GuildTabWindow.Instence.update();
			}
			else
			{//更新加入公会面板
				GuildJoinWindow.Instence.update();
			}
		}
		
		private function onGuildMemberOnline(msg:SGuildMemberOnline):void
		{
			var mem:GuildMemberVo=GuildInfoManager.Instence.findMemberById(msg.dyId);
			mem.last_time=0;
			GuildTabWindow.Instence.update();
		}
		
		private function onGuildMemberOffline(msg:SGuildMemberOffline):void
		{
			var mem:GuildMemberVo=GuildInfoManager.Instence.findMemberById(msg.dyId);
			mem.last_time=(new Date).time/1000;
			GuildTabWindow.Instence.update();
		}
		
		private function reUpgradeBuilding(msg:SUpgradeBuilding):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
//				NoticeUtil.setOperatorNotice("建筑升级成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1330);
			else
//				NoticeUtil.setOperatorNotice("建筑升级失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1331);
		}
		
		private function onShiftChairmanNotify(msg:SShiftChairmanNotify):void
		{
			print("移交会长，新会长ID:"+msg.newChairmanId);
			GuildInfoManager.Instence.changeMaster(msg.newChairmanId);
			GuildTabWindow.Instence.update();
		}
		
		private function reAcceptGuildInvite(msg:SAcceptGuildInvite):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.("接受公会邀请成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1332);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("接受公会邀请失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1333);
			}
		}
		
		private function onGuildInvite(msg:SGuildInvite):void
		{
			if(!SystemConfigManager.rejectGuild)
			{
				var vo:GuildInviteVo=GuildDataTransition.tranSGuildInviteToVo(msg);
				GuildInfoManager.Instence.addInviteData(vo);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.RequestGuild);
			}
		}
		
		private function reGuildSearchPlayer(msg:SGuildSearchPlayer):void
		{
			if(msg&&msg.hasPlayerInfo)
			{
				var vo:GuildPlayerLookupInfoVo=GuildDataTransition.tranOtherPlyerToVo(msg.playerInfo);
				GuildLookupPlayerWindow.Instence.setData(vo);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1310);
				GuildLookupPlayerWindow.Instence.setData(null);
			}
		}
		
		private function reGuildInviteOther(msg:SGuildInviteOther):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("邀请发送成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1334);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("邀请发送失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1335);
			}
		}
		
		private function onGuildMoneyChange(msg:SGuildMoneyChange):void
		{
			print("=====公会资金改变了"+msg.money+"======");
			GuildInfoManager.Instence.myGuildInfo.money+=msg.money;
			GuildTabWindow.Instence.update();
			GuildContributionWindow.Instence.update();
		}
		
		private function onUpgrageBuildingNotify(msg:SUpgradeBuildingNotify):void
		{
			var name:String=TypeBuilding.getBuildingNameByType(msg.buildingType);
			print(this,"====建筑"+name+"升级到了"+msg.level+"级======");
			GuildInfoManager.Instence.changeBuildingLv(msg.buildingType,msg.level);
			GuildTabWindow.Instence.update();
			GuildContributionWindow.Instence.update();
			if(msg.buildingType!=TypeBuilding.HALL)
				NoticeManager.setNotice(NoticeType.Notice_id_1320,-1,name,msg.level);
			else
				NoticeManager.setNotice(NoticeType.Notice_id_1321,-1,msg.level);
		}
		
		private function onExitGuildNotify(msg:SExitGuildNotify):void
		{
			print("====玩家："+msg.dyId+"离开了公会====");
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==msg.dyId)//玩家自己，被T了
			{
				GuildInfoManager.Instence.hasGuild=false;
				GuildTabWindow.Instence.close();
				NoticeManager.setNotice(NoticeType.Notice_id_1306,TypeChannels.CHAT_CHANNEL_GUILD,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
				CharacterDyManager.Instance.unionName="";
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildExit);
				closeAll();
			}
			else
			{
				GuildInfoManager.Instence.findMemberById(msg.dyId,true);
				GuildTabWindow.Instence.update();
			}
		}
		
		private function onDonateNotify(msg:SDonateNotify):void
		{
			print("====玩家："+msg.dyId+"为公会捐献了:"+msg.contribution+"其已累计捐献："+msg.maxContribution);
			var member:GuildMemberVo=GuildInfoManager.Instence.findMemberById(msg.dyId);
			if(member)
			{
				member.contribution=msg.contribution;
				member.max_contribution=msg.maxContribution;
			}
			GuildTabWindow.Instence.update();
		}
		
		private function onPositionChange(msg:SPositionChangeNotify):void
		{
			var member:GuildMemberVo=GuildInfoManager.Instence.findMemberById(msg.dyId);
			if(member)
			{
				member.position=msg.position;
				var posName:String=TypeGuild.getPositionName(msg.position);
				print("=====玩家："+member.name+"职位变为:"+posName+"=====");
				if(member.id==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1305,TypeChannels.CHAT_CHANNEL_GUILD,member.name,posName);
					if(TypeGuild.canAddMember(member.position))//自己的职位变动后有添加成员权限的，刷新入会申请者名单
						getJoinRequestList();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildFlashIconUpdate);
				}
			}
			GuildTabWindow.Instence.update();
		}
		
		private function onEnterGuildNotify(msg:SEnterGuildNotify):void
		{
			var vo:GuildMemberVo=GuildDataTransition.transGuildMemberToVo(msg.memberInfo);
			print("====玩家："+vo.name+"加入公会======");
			GuildInfoManager.Instence.addMember(vo);
			GuildTabWindow.Instence.update();
		}
		
		private function onEnterGuild(msg:SEnterGuild):void
		{
			var vo:GuildInfoVo=GuildDataTransition.transGuildDetailInfoToVo(msg.guildInfo);
			GuildInfoManager.Instence.myGuildInfo=vo;
			GuildInfoManager.Instence.hasGuild=true;
			NoticeManager.setNotice(NoticeType.Notice_id_1308,-1,msg.guildInfo.name);
			CharacterDyManager.Instance.unionName=vo.item.name;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildEnter);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FeedSend,FeedID.JOIN_GUILD);
			closeAll();
			GuildTabWindow.Instence.open();
			NoticeManager.setNotice(NoticeType.Notice_id_1304,TypeChannels.CHAT_CHANNEL_GUILD,DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
		}
		
		private function onNoticeChangeNotify(msg:SNoticeChangeNotify):void
		{
			GuildInfoManager.Instence.myGuildInfo.gonggao=msg.notice;
			GuildTabWindow.Instence.update();
		}
		
		private function reAcceptJoinRequest(msg:SAcceptJoinRequest):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
				trace("允许/拒绝 入会申请成功");
			else
				trace("允许/拒绝 入会申请失败");
			getJoinRequestList();//刷新数据
		}
		
		private function reGetJoinRequestList(msg:SGetJoinRequestList):void
		{
			if(msg==null)
				GuildInfoManager.Instence.reMembers=[];
			else
			{
				var temp:Array=GuildDataTransition.transReMemberToVo(msg.joinInfoArr);
				GuildInfoManager.Instence.reMembers=temp;
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildFlashIconUpdate);
			GuildTabWindow.Instence.update();
		}
		
		private function reChangeGuildName(msg:SChangeGuildName):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.("公会改名成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1336);
			}
			else if(msg.errorInfo==RspMsg.RSPMSG_GUILD_NAME_EXIST)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1301);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("公会改名失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1337);
			}
		}
		
		private function reGuildDonate(msg:SGuildDonate):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("捐献成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1338);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("捐献失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1339);
			}
		}
		
		private function reExitGuild(msg:SExitGuild):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
				GuildInfoManager.Instence.myGuildInfo=null;
				GuildInfoManager.Instence.hasGuild=false;
				GuildTabWindow.Instence.close();
//				NoticeUtil.setOperatorNotice("退出公会成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1340);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("退出公会失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1341);
			}
		}
		
		private function reShiftCharman(msg:SShiftChairman):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("移交会长成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1342);
				GuildAppointWindow.Instence.close();
			}
			else
			{
//				NoticeUtil.setOperatorNotice("移交会长失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1343);
			}
		}
		
		private function reKickGuildMember(msg:SKickGuildMember):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("开除成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1344);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("开除失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1345);
			}
		}
		
		private function reSendNotice(msg:SSendNotice):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("发布公告成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1346);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("发布公告失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1347);
			}
		}
		
		private function reAppointPosition(msg:SAppointPosition):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("职位任命成功");
				NoticeManager.setNotice(NoticeType.Notice_id_1348);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("职位任命失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1349);
			}
		}
		
		private function reRequestJoinGuild(msg:SRequestJoinGuild):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
//				NoticeUtil.setOperatorNotice("您已成功申请该公会，请等待公会管理员审核");
				NoticeManager.setNotice(NoticeType.Notice_id_1350);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("申请失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1351);
			}
		}
		
		private function reQueryGuildInfo(msg:SQueryGuildInfo):void
		{
			var vo:GuildInfoVo=new GuildInfoVo;
			vo.money=msg.money;
			vo.gonggao=msg.notice;
			vo.item=GuildDataTransition.transGuildInfoToVo(msg.simpleInfo);
			
			GuildInfoWindow.Instence.open();
			GuildInfoWindow.Instence.setInfoAndGonggao(vo);
		}
		
		private function reCreateGuild(msg:SCreateGuild):void
		{
			if(msg.errorInfo==RspMsg.RSPMSG_SUCCESS)
			{
				var vo:GuildInfoVo=GuildDataTransition.transGuildDetailInfoToVo(msg.guildInfo);
				GuildInfoManager.Instence.myGuildInfo=vo;
				GuildCreateWindow.Instence.close();
				GuildJoinWindow.Instence.close();
				GuildTabWindow.Instence.open();
				GuildTabWindow.Instence.update();
			}
			else if(msg.errorInfo==RspMsg.RSPMSG_GUILD_NAME_EXIST)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1301);
			}
			else
			{
//				NoticeUtil.setOperatorNotice("创建公会失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1352);
			}
		}
		
		private function reCharacterGuildInfo(msg:SCharacterGuildInfo):void
		{
			if(msg&&msg.hasGuildInfo)//已加入公会
			{
				GuildInfoManager.Instence.hasGuild=true;
				
				var info:GuildDetailInfo=msg.guildInfo;
				var vo:GuildInfoVo=GuildDataTransition.transGuildDetailInfoToVo(info);
				GuildInfoManager.Instence.myGuildInfo=vo;
				
				if(msg.hasAccuserId)
				{
					GuildInfoManager.Instence.impeacher_id=msg.accuserId;
					GuildInfoManager.Instence.impeacher_time=msg.finishTime;
					if(msg.voteState==true)//已经投票
						GuildInfoManager.Instence.impeach_state=GuildImpeachState.Reader;
					else
						GuildInfoManager.Instence.impeach_state=GuildImpeachState.Voter;
				}
				else
					GuildInfoManager.Instence.impeach_state=GuildImpeachState.NoImpeach;
				
				if(GuildInfoManager.Instence.hasRightToAddMember())//有加人权的再请求申请入会者名单
					getJoinRequestList();
			}
			else//未加入公会
			{
				GuildInfoManager.Instence.hasGuild=false;
			}
		}
		private function reOtherGuildList(msg:SOtherGuildList):void
		{
			var vo:OtherGuildListVo=GuildDataTransition.transSOtherGuildListToVo(msg);
			GuildInfoManager.Instence.otherGuildList=vo;
			if(GuildInfoManager.Instence.hasGuild)
			{//更新其他公会页
				GuildTabWindow.Instence.update();
			}
			else
			{//更新加入公会面板
				GuildJoinWindow.Instence.update();
			}
		}
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
			//游戏进入时请求基本公会信息
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			
			// TODO 添加ui事件接收
			YFEventCenter.Instance.addEventListener(GlobalEvent.GuildUIClick,onUiClick);//打开关闭
			YFEventCenter.Instance.addEventListener(GlobalEvent.GuildInviteClick,onInviteClick);//公会邀请界面打开
			
			//加入公会面板
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.ShowCreateWindow,onShowCreate);//打开创建公会面板
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.LookupGuild,onLookupGuild);//查找公会
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.CreateGuild,onCreateGuild);//创建公会
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.LookupGuildInfo,onLookupGuildInfo);//查看某个公会的信息
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.ApplyGuild,onApplyGuild);//申请入会
			
			//公会信息面板
//			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AddMember,onAddMember);//请求成员招收表
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.Appoint,onAppoint);//职位任命
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.ChangeMaster,onChangeMaster);//移交会长
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.Contribution,onContribution);//公会捐献
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.Discharge,onDischarg);//开除成员
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.ExitGuild,onExitGuild);//退出公会
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.Impeach,onImpeach);//点击弹劾按钮
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.PublishInvitor,onPublishInvitor);//发布邀请
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.GoBackGuild,onGoBackGuild);//返回公会
			
			//任命职位窗口
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AppointMember,onAppointMember);//任命公会成员职位
			
			//发布公告窗口
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.PostGonggao,onPostGonggao);//请求发布公告
			
			//公会捐献窗口
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.Donate,onDonate);//捐献
			
			//成员招收窗口
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AddMemberOK,onAddMemberOk);//允许入会申请
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AddMemberNo,onAddMemberNo);//拒绝入会申请
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.LookupMember,onLookupMember);//开关查询玩家窗口
			
			//聊天窗口入会申请
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.chatJoinGuildReq,onApplyGuild);//入会申请
			
			//查询玩家信息
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.InvatePlayer,onInvatePlayer);//邀请玩家入会
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.LookupPlayer,onLookupPlayer);//查询玩家信息
			
			//玩家查看入会邀请列表
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AcceptGuildInvite,onAcceptGuildInvite);//接收入会邀请
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.RejectGuildInvite,onRejectGuildInvite);//拒绝入会邀请
			
			//其他公会页
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.AskOtherGuildList,askOtherGuildList);//请求其他公会信息
			
			//公会建筑页
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.BuildingUpgrade,onBuildingUpgrade);//公会建筑升级
			
			//弹劾投票
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.VoteYes,onVoteYes);
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.VoteNo,onVoteNo);
			
			//公会技能
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.SkillSelect,onSkillSelect);//公会技能选中切换
			YFEventCenter.Instance.addEventListener(GuildInfoEvent.SkillLearn,onSkillLearn);//学习技能
		}
		
		private function onMoneyChange(e:YFEvent):void
		{
			if(GuildInfoManager.Instence.hasGuild)
				GuildTabWindow.Instence.updateDownInfo();
		}
		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			MsgPool.sendGameMsg(GameCmd.CCharacterGuildRequest,new CCharacterGuildRequest);//初始化公会信息
		}
		
		private function onSkillLearn(e:YFEvent):void
		{
			var skill:SkillBasicVo=e.param as SkillBasicVo;
			var msg:CLearnGuildSkill=new CLearnGuildSkill;
			msg.skillId=skill.skill_id;
			MsgPool.sendGameMsg(GameCmd.CLearnGuildSkill,msg);
			trace(msg);
		}
		
		private function onSkillSelect(e:YFEvent):void
		{
			// 跟新技能学习界面，使选中位置高亮，其余位置去掉高亮，技能学习右边描述跟新
			GuildTabWindow.Instence.update();
		}
		
		private function onVoteNo(e:YFEvent):void
		{
			// TODO 向服务器发送投反对票消息
			trace("投了反对票*=*=*=*=**=*=");
			var msg:CVoteForAccuse=new CVoteForAccuse;
			msg.support=false;
			MsgPool.sendGameMsg(GameCmd.CVoteForAccuse,msg);
		}
		
		private function onVoteYes(e:YFEvent):void
		{
			// TODO 向服务器发送投赞成票消息
			trace("投了支持票*=*=*=*=**=*=");
			var msg:CVoteForAccuse=new CVoteForAccuse;
			msg.support=true;
			MsgPool.sendGameMsg(GameCmd.CVoteForAccuse,msg);
		}
		
		private function onBuildingUpgrade(e:YFEvent):void
		{
			var vo:GuildBuildingUpgradeVo=e.param as GuildBuildingUpgradeVo;
			var msg:CUpgradeBuilding=new CUpgradeBuilding;
			msg.buildingType=vo.type;
			print("=====请求公会建筑升级，建筑类型"+vo.type);
			MsgPool.sendGameMsg(GameCmd.CUpgradeBuilding,msg);
		}
		
		private function onGoBackGuild(e:YFEvent):void
		{
			var msg:CEnterGuildDomain=new CEnterGuildDomain;
			MsgPool.sendGameMsg(GameCmd.CEnterGuildDomain,msg);
			print("======请求进入公会驻地==");
		}
		
		private function onPublishInvitor(e:YFEvent):void
		{
			var cd:ChatData=new ChatData;
			var vo:GuildItemVo=GuildInfoManager.Instence.myGuildInfo.item;
			cd.data=vo;
			cd.displayName="申请入会";
			cd.myId=vo.id;
			cd.myQuality=2;
			cd.myType=ChatType.Chat_Type_Guild;
			
			var cd2:ChatData=new ChatData;
			cd2.data=vo;
			cd2.displayName=vo.name;
			cd2.myId=vo.id;
			cd2.myQuality=2;
			cd2.myType=ChatType.Chat_Type_GuildInfo;
			
			var txt:String="["+cd2.displayName+","+cd2.myType+","+cd2.myId+"]"+"公会诚邀各位英雄加入，共创辉煌！"
				+"["+cd.displayName+","+cd.myType+","+cd.myId+"]";
			var dic:Dictionary=new Dictionary;
			dic["【"+cd.displayName+"】"+"_"+cd.myType+"_"+cd.myId]=cd;
			dic["【"+cd2.displayName+"】"+"_"+cd2.myType+"_"+cd.myId]=cd2;
			var sendStr:String=ChatTextUtil.convertSendDataToString(txt,dic);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatAutoSend,sendStr);
		}
		
		private function onRejectGuildInvite(e:YFEvent):void
		{
			var vo:GuildInviteVo=e.param as GuildInviteVo;
			GuildInfoManager.Instence.removeInvite(vo);
			GuildInviteWindow.Instence.update();
		}
		
		private function onAcceptGuildInvite(e:YFEvent):void
		{
			var vo:GuildInviteVo=e.param as GuildInviteVo;
			var msg:CAcceptGuildInvite=new CAcceptGuildInvite;
			msg.guildId=vo.guildId;
			MsgPool.sendGameMsg(GameCmd.CAcceptGuildInvite,msg);
			
			GuildInfoManager.Instence.removeInvite(vo);
			GuildInviteWindow.Instence.update();
		}
		
		private function onInviteClick(e:YFEvent):void
		{
			if(GuildInfoManager.Instence.invite_data.length==1)
			{//显示提示框
				var alert:GuildInviteAlert=new GuildInviteAlert;
				alert.update();
				alert.open();
				GuildInfoManager.Instence.invite_data.length=0;
			}
			else
			{//显示表
				GuildInviteWindow.Instence.open();
			}
		}

		private function handleInviteClick(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				MsgPool.sendGameMsg(GameCmd.CAcceptGuildInvite,e.data);
			}
		}
		
		private function onLookupMember(e:YFEvent):void
		{
			GuildLookupPlayerWindow.Instence.open();
		}
		
		private function onLookupPlayer(e:YFEvent):void
		{
			var vo:GuildPlayerLookupVo=e.param as GuildPlayerLookupVo;
			var msg:CGuildSearchPlayer=new CGuildSearchPlayer;
			msg.name=vo.name;
			MsgPool.sendGameMsg(GameCmd.CGuildSearchPlayer,msg);
		}
		
		private function onInvatePlayer(e:YFEvent):void
		{
			var vo:GuildInvitePlayerVo=e.param as GuildInvitePlayerVo;
			var guildinfo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			if(!GuildInfoManager.Instence.hasGuild)
//				NoticeUtil.setOperatorNotice("你没有公会，无法邀请");
				NoticeManager.setNotice(NoticeType.Notice_id_1353);
			else if(!TypeGuild.canAskInvater(GuildInfoManager.Instence.me.position))
//				NoticeUtil.setOperatorNotice("你的公会职位不能邀请");
				NoticeManager.setNotice(NoticeType.Notice_id_1354);
			else if(vo.lv<GuildConfig.GuildMinEnterLv)
//				NoticeUtil.setOperatorNotice("对方等级不足，无法邀请");
				NoticeManager.setNotice(NoticeType.Notice_id_1355);
			else if(guildinfo&&guildinfo.item&&guildinfo.item.member==guildinfo.item.total)
				NoticeManager.setNotice(NoticeType.Notice_id_1311);
			else if(vo.guildName&&vo.guildName!="")
//				NoticeUtil.setOperatorNotice("对方已有公会，无法邀请。");
				NoticeManager.setNotice(NoticeType.Notice_id_1356);
			else
			{
				var msg:CGuildInviteOther=new CGuildInviteOther;
				msg.dyId=vo.dyId;
				MsgPool.sendGameMsg(GameCmd.CGuildInviteOther,msg);
			}
		}
		
		private function onAddMemberNo(e:YFEvent):void
		{
			var vo:GuildMemberVo=e.param as GuildMemberVo;
			var msg:CAcceptJoinRequest=new CAcceptJoinRequest;
			msg.dyId=vo.id;
			msg.accept=false;
			MsgPool.sendGameMsg(GameCmd.CAcceptJoinRequest,msg);
		}
		
		private function onAddMemberOk(e:YFEvent):void
		{
			var vo:GuildMemberVo=e.param as GuildMemberVo;
			var msg:CAcceptJoinRequest=new CAcceptJoinRequest;
			msg.dyId=vo.id;
			msg.accept=true;
			MsgPool.sendGameMsg(GameCmd.CAcceptJoinRequest,msg);
		}		
		
		//=================================
		//公会捐献窗口
		//=================================
		private function onDonate(e:YFEvent):void
		{
			var vo:GuildContributionVo=e.param as GuildContributionVo;
			var msg:CGuildDonate=new CGuildDonate;
			msg.useNumber=vo.num;
			msg.useItems=vo.items;
			MsgPool.sendGameMsg(GameCmd.CGuildDonate,msg);
		}
		
		//=================================
		//发布公告窗口
		//=================================
		
		private function onPostGonggao(e:YFEvent):void
		{
			var vo:GuildGonggaoVo=e.param as GuildGonggaoVo;
			var msg:CSendNotice=new CSendNotice;
			msg.notice=vo.gonggao;
			MsgPool.sendGameMsg(GameCmd.CSendNotice,msg);
		}
		
		//=================================
		//任命职位窗口
		//=================================
		
		private function onAppointMember(e:YFEvent):void
		{
			var vo:GuildAppointVo=e.param as GuildAppointVo;
			var msg:CAppointPosition=new CAppointPosition;
			msg.dyId=vo.dy_id;
			msg.position=vo.position;
			MsgPool.sendGameMsg(GameCmd.CAppointPosition,msg);
		}		
		
		
		//=================================
		//已加入公会
		//=================================
		
		private function onAddMember(e:YFEvent):void
		{
			getJoinRequestList();
		}
		private function getJoinRequestList():void
		{
			var msg:CGetJoinRequestList=new CGetJoinRequestList;
			MsgPool.sendGameMsg(GameCmd.CGetJoinRequestList,msg);
		}
		
		private function onAppoint(e:YFEvent):void
		{
			GuildAppointWindow.Instence.switchOpenClose();
		}
		
		private function onChangeMaster(e:YFEvent):void
		{
			var vo:GuildMemberVo=GuildInfoManager.Instence.selected_member;
			var msg:CShiftChairman=new CShiftChairman;
			msg.dyId=vo.id;
			var name:String=GuildWarningWindowHtml.getChangeMasterHtml(vo.name);
			Alert.show(name,"移交会长",handleChangeMaster,["移交","取消"],true,msg);
		}
		private function handleChangeMaster(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				MsgPool.sendGameMsg(GameCmd.CShiftChairman,e.data);
			}
		}
		
		private function onContribution(e:YFEvent):void
		{
			GuildContributionWindow.Instence.open();
		}
		
		private function onDischarg(e:YFEvent):void
		{
			var vo:GuildMemberVo=GuildInfoManager.Instence.selected_member;
			var msg:CKickGuildMember=new CKickGuildMember;
			msg.dyId=vo.id;
			var name:String=GuildWarningWindowHtml.getDischargHtml(vo.name);
			Alert.show(name,"开除成员",handleDischarg,["开除","取消"],true,msg);
		}
		private function handleDischarg(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				MsgPool.sendGameMsg(GameCmd.CKickGuildMember,e.data);
			}
		}
		
		
		private function onExitGuild(e:YFEvent):void
		{
			var msg:CExitGuild=new CExitGuild;
			var vo:GuildItemVo=GuildInfoManager.Instence.myGuildInfo.item;
			var name:String=GuildWarningWindowHtml.getExitGuildHtml(vo.name);
			Alert.show(name,"退出公会",handleExitGuild,["退出","取消"],true,msg);
		}
		private function handleExitGuild(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				MsgPool.sendGameMsg(GameCmd.CExitGuild,e.data);
			}
		}
		
		private function onImpeach(e:YFEvent):void
		{
			var state:int=GuildInfoManager.Instence.impeach_state;
			switch(state)
			{
				case GuildImpeachState.NoImpeach://当前没有弹劾，提示是否要发起弹劾
					var name:String=GuildInfoManager.Instence.myGuildInfo.item.master;
					var str:String=GuildWarningWindowHtml.getImpeachWarningHtml(name,GuildConfig.ImpeachNeedContribution);
					Alert.show(str,"弹劾",handleImpeach,["弹劾","取消"]);
					break;
				case GuildImpeachState.Impeacher:
				case GuildImpeachState.Reader://投票结果
					var msg:CQueryVote=new CQueryVote;
					MsgPool.sendGameMsg(GameCmd.CQueryVote,msg);
					break;
				case GuildImpeachState.Voter://投票
					var voteWindow:GuildVoteWindow=GuildVoteWindow.Instence;
					var impeacherVo:GuildMemberVo=GuildInfoManager.Instence.findMemberById(GuildInfoManager.Instence.impeacher_id);
					voteWindow.setContent(impeacherVo.name,GuildInfoManager.Instence.impeacher_time);
					voteWindow.open();
					break;
			}
			/////test
//			var vo:StoryShowVo=new StoryShowVo;
//			vo.id=2;
//			YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,vo);
//			NoticeUtil.setOperatorNotice("该功能未开放");
		}
		private function handleImpeach(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex==1)
			{
				//发送弹劾协议
				print("发起弹劾**************************");
				var msg:CAccuseChairman=new CAccuseChairman;
				MsgPool.sendGameMsg(GameCmd.CAccuseChairman,msg);
			}
		}
		
		
		//=========================================
		//未加入公会
		//=========================================
		private function onApplyGuild(e:YFEvent):void
		{
			// TODO 向服务器发送对应协议及VO
			var vo:GuildItemVo=e.param as GuildItemVo;
			var msg:CRequestJoinGuild=new CRequestJoinGuild;
			msg.guildId=vo.id;
			MsgPool.sendGameMsg(GameCmd.CRequestJoinGuild,msg);
		}
		
		private function onLookupGuildInfo(e:YFEvent):void
		{
			// TODO 向服务器发送对应协议及VO
			var vo:GuildItemVo=e.param as GuildItemVo;
			var msg:CQueryGuildInfo=new CQueryGuildInfo;
			msg.guildId=vo.id;
			MsgPool.sendGameMsg(GameCmd.CQueryGuildInfo,msg);
		}
		
		private function onShowCreate(e:YFEvent):void
		{
			GuildCreateWindow.Instence.open();
		}
		
		private function onLookupGuild(e:YFEvent):void
		{//先不做
			var vo:GuildJoinLookupVo=e.param as GuildJoinLookupVo;
			//向服务器发送对应协议及VO
			var msg:CSearchGuild=new CSearchGuild;
			msg.guildName=vo.name;
			MsgPool.sendGameMsg(GameCmd.CSearchGuild,msg);
		}
		
		private function onCreateGuild(e:YFEvent):void
		{
			//向服务器发送对应协议
			var vo:GuildCreateVo=e.param as GuildCreateVo;
			var msg:CCreateGuild=new CCreateGuild;
			msg.guildName=vo.name;
			MsgPool.sendGameMsg(GameCmd.CCreateGuild,msg);
		}
		
		private function onUiClick(e:YFEvent):void
		{
			// TODO 请求公会信息
			if(GuildInfoManager.Instence.hasGuild)
			{
				GuildTabWindow.Instence.switchOpenClose();
			}
			else
			{
				GuildJoinWindow.Instence.switchOpenClose();
				if(GuildJoinWindow.Instence.isOpen)
				{
					askOtherGuildList(null);
				}
			}
		}
		private function askOtherGuildList(e:YFEvent):void
		{
			var sendMsg:COtherGuildList=new COtherGuildList;
			if(e && e.param)
			{
				var vo:OtherGuildPageVo=e.param as OtherGuildPageVo;
				sendMsg.page=vo.page;
			}
			else
				sendMsg.page=1;
			MsgPool.sendGameMsg(GameCmd.COtherGuildList,sendMsg);//请求其他公会信息
		}
		/**关掉所有面板*/
		private function closeAll():void
		{
			GuildAppointWindow.Instence.close();
			GuildContributionWindow.Instence.close();
			GuildCreateWindow.Instence.close();
			GuildInfoWindow.Instence.close();
			GuildInviteWindow.Instence.close();
			GuildJoinWindow.Instence.close();
			GuildLookupPlayerWindow.Instence.close();
			GuildTabWindow.Instence.close();
		}
	}
}