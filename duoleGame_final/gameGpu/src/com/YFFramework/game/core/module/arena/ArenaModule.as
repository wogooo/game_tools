package com.YFFramework.game.core.module.arena
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-22 下午4:42:43
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.arena.data.ArenaBasicManager;
	import com.YFFramework.game.core.module.arena.data.ArenaRankManager;
	import com.YFFramework.game.core.module.arena.view.ArenaCountDownView;
	import com.YFFramework.game.core.module.arena.view.ArenaExitIcon;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.msg.pvp.CEnterArena;
	import com.msg.pvp.CExitArena;
	import com.msg.pvp.SArenaResult;
	import com.msg.pvp.SEnterArena;
	import com.msg.pvp.SExitArena;
	import com.msg.pvp.SOtherEnterArena;
	import com.msg.pvp.SScoreChange;
	import com.net.MsgPool;
	
	public class ArenaModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ArenaModule()
		{
			super();
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}

		public function enterArena(arena_id:int):void
		{
			var msg:CEnterArena=new CEnterArena();
			msg.arenaId=arena_id;
			MsgPool.sendGameMsg(GameCmd.CEnterArena,msg);
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.QuitArena,quitArena);
		}
		
		private function addSocketCallback():void
		{			
			MsgPool.addCallBack(GameCmd.SEnterArena,SEnterArena,enterArenaRsp);
			MsgPool.addCallBack(GameCmd.SOtherEnterArena,SOtherEnterArena,otherEnterArena);
			MsgPool.addCallBack(GameCmd.SScoreChange,SScoreChange,playerScoreChange);
			MsgPool.addCallBack(GameCmd.SExitArena,SExitArena,exitArena);//退出竞技
			MsgPool.addCallBack(GameCmd.SArenaResult,SArenaResult,arenaResult);//竞技结果
		}
		//======================================================================
		//        event handler
		//======================================================================
		//进入竞技场回复
		private function enterArenaRsp(msg:SEnterArena):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeUtil.setOperatorNotice("竞技场进入失败");
			}
			else
			{
				ArenaRankManager.instance.initAllPlayerInfo(msg.playerInfos);
				ArenaRankManager.instance.curArenaId=msg.arenaId;
				ArenaRankManager.instance.enter=true;
				
				var obj:Object={arena_id:msg.arenaId,ready_time:msg.readyTime};
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterArena,obj);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterActivity);
				ArenaExitIcon.instance.showExit();
			}
		}
		
		private function otherEnterArena(msg:SOtherEnterArena):void
		{
			ArenaRankManager.instance.updatePlayer(msg.otherInfo);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UpdateArenaInfo);
		}
		
		private function playerScoreChange(msg:SScoreChange):void
		{
			ArenaRankManager.instance.updatePlayer(msg.playerInfo);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UpdateArenaInfo);
		}
		
		private function exitArena(msg:SExitArena):void
		{			
			var activityId:int=ArenaBasicManager.Instance.getArenaBasicVo(msg.arenaId).activity_id;
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVo(activityId);
			
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseArena,msg.arenaId);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.QuitActivity);
			
			ArenaRankManager.instance.curArenaId=0;
			ArenaRankManager.instance.enter=false;
			
			ArenaCountDownView.instance.hideCount();
			ArenaExitIcon.instance.hideExit();
		}
		
		private function arenaResult(msg:SArenaResult):void
		{
			var vo:ActivityBasicVo=ActivityBasicManager.Instance.getActivityBasicVo(msg.activityId);
			if(vo.active_type == ActivityData.ACTIVITY_BRAVE)
			{
				if(msg.resultNotice.length > 0)
				{
					//目前只写一个，其余到notice表里去配
					if(msg.resultNotice[0].noticeType == 1)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_3,-1,vo.active_name,
							msg.resultNotice[0].firstName,msg.resultNotice[0].secondName,msg.resultNotice[0].thirdName);
					}
				}
				else
				{
					NoticeUtil.setOperatorNotice(vo.active_name+"人物不足");
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseActivity,vo.active_type);
				}
				
				//结束竞技后要重新竞技排名
				ModuleManager.rankModule.rankReq(RankSource.TITLE_ACTIVITY41);
			}
		}
		
		private function quitArena(e:YFEvent):void
		{
			var arenaId:int=e.param as int;
			var msg:CExitArena=new CExitArena();
			MsgPool.sendGameMsg(GameCmd.CExitArena,msg);
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 