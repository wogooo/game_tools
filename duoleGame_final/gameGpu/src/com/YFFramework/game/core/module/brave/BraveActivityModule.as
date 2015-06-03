package com.YFFramework.game.core.module.brave
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-22 下午1:39:55
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.arena.data.ArenaRankManager;
	import com.YFFramework.game.core.module.arena.view.ArenaCountDownView;
	import com.YFFramework.game.core.module.brave.view.BraveMiniRankView;
	import com.YFFramework.game.core.module.task.view.TaskMiniPanel;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.actv.SSignActivity;
	import com.msg.pvp.CEnterArena;
	import com.msg.pvp.SEnterArena;
	import com.net.MsgPool;
	
	public class BraveActivityModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const ACTIVITY_TYPE:int=4;
		private var vo:ActivityBasicVo;
		private var _join:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BraveActivityModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
			vo=ActivityBasicManager.Instance.getActivityBasicVoByType(ACTIVITY_TYPE);
		}
		//======================================================================
		//        public function
		//======================================================================
		
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.BraveUIClick,onClickIcon);
			//参加竞技场成功
			YFEventCenter.Instance.addEventListener(GlobalEvent.JoinedActivity,canJoinArena);
			//成功进入竞技场
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterArena,onEnterArena);
			YFEventCenter.Instance.addEventListener(GlobalEvent.UpdateArenaInfo,updateArenaInfo);
			YFEventCenter.Instance.addEventListener(GlobalEvent.CloseArena,closeArena);
		}
		
		private function addSocketCallback():void
		{			
//			MsgPool.addCallBack(GameCmd.SEnterArena,SEnterArena,onEnterBraveRsp);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onClickIcon(e:YFEvent):void
		{
			if(_join == false)
			{
				ModuleManager.moduleActivity.joinActivityReq(ACTIVITY_TYPE);
			}
		}
		
		private function canJoinArena(e:YFEvent):void
		{
			var activityType:int=e.param as int;
			if(activityType == vo.active_type)
			{
				_join=true;
				ModuleManager.arenaModule.enterArena(vo.scene_id);
			}
		}
		
		private function onEnterArena(e:YFEvent):void
		{
			var obj:Object=e.param as Object;
			if(obj.arena_id == vo.scene_id)
			{
				if(obj.ready_time > 0)
					ArenaCountDownView.instance.startCount(obj.ready_time);
				TaskMiniPanel.getInstance().visible=false;
				BraveMiniRankView.instance.initView();
			}
		}
		
		private function updateArenaInfo(e:YFEvent):void
		{
			if(ArenaRankManager.instance.curArenaId == vo.scene_id)
				BraveMiniRankView.instance.updateScore();
		}
		
		private function closeArena(e:YFEvent):void
		{
			var arenaId:int=e.param as int;
			if(arenaId == vo.scene_id)
			{
				BraveMiniRankView.instance.closeView();
				TaskMiniPanel.getInstance().visible=true;
				_join=false;
			}			
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 