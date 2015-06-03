package com.YFFramework.game.core.module.raid.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.RaidNPCVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.demon.view.DemonMiniWindow;
	import com.YFFramework.game.core.module.demon.view.DemonWindow;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.TransferPointManager;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.core.module.raid.manager.RaidDyManager;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.manager.RaidTimeBasicManager;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.raid.view.CardMovieView;
	import com.YFFramework.game.core.module.raid.view.CloseSprite;
	import com.YFFramework.game.core.module.raid.view.ExitSprite;
	import com.YFFramework.game.core.module.raid.view.RaidAlert;
	import com.YFFramework.game.core.module.raid.view.RaidClosureView;
	import com.YFFramework.game.core.module.raid.view.RaidMiniPanel;
	import com.YFFramework.game.core.module.raid.view.RaidView;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.YFFramework.game.core.module.task.manager.Task_timeBasicManager;
	import com.YFFramework.game.core.module.task.model.Task_timeBasicVo;
	import com.YFFramework.game.core.module.task.view.TaskMiniPanel;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.Align;
	import com.msg.actv.CDemonInvadeLevel;
	import com.msg.common.ItemConsume;
	import com.msg.hero.CAcceptCompete;
	import com.msg.raid_pro.*;
	import com.net.MsgPool;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-27 下午2:10:23
	 */
	public class RaidModule extends AbsModule{
		
		private var _countTxt:TextField;
		private var _time:int;
		private var _exitSp:ExitSprite;
//		private var _closeSp:CloseSprite;
		private var _raidClosureView:RaidClosureView;
		private var _closureTime:int;
		private var _closureTimeId:uint;
		private var _miniPanel:RaidMiniPanel;
		
		public function RaidModule(){
			_exitSp = new ExitSprite();
//			_closeSp = new CloseSprite();
			_miniPanel = RaidMiniPanel.Instance;
		}
		
		override public function init():void{
			_miniPanel.init();
			_miniPanel.visible=false;
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterRaid,onCreateRaid);	//进入副本请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterRaidWONPC,onCreateRaidWONPC);	//进入副本请求(非npc入口)
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);			//登陆游戏请求基本信息
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onChgMap);		//切换场景通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.RequestChangeMap,reqChgMap);//离开副本通知
			YFEventCenter.Instance.addEventListener(RaidEvent.ExitRaidReq, exitRaid);		//请求退出副本
			YFEventCenter.Instance.addEventListener(GlobalEvent.CloseRaid,closeRaid);		//请求关闭副本
			
			YFEventCenter.Instance.addEventListener(MapScenceEvent.PlayerDead,onPlayerDead); //有怪物死亡时，副本引导界面需要显示余下的怪物数量
			
			YFEventCenter.Instance.addEventListener(RaidEvent.FetchRaidReward,fetchRaidReward);//请求获取副本奖励
		}
		
		private function onPlayerDead(e:YFEvent):void
		{
			var role:RoleDyVo=e.param as RoleDyVo;
			if(role&&role.bigCatergory==TypeRole.BigCategory_Monster&&RaidDyManager.Instence.currentRaid)
			{
				RaidDyManager.Instence.current_killed_enemy++;
				_miniPanel.update();
			}
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SEnterRaid,SEnterRaid,onEnterRaid);					//进入副本回复
			MsgPool.addCallBack(GameCmd.SExitAppear,SExitAppear,onExitAppear);				//可以显示离开传送点
			MsgPool.addCallBack(GameCmd.SLeaveCountDown,SLeaveCountDown,onLeaveable);		//可以离开副本回复
			MsgPool.addCallBack(GameCmd.SRaidInfo,SRaidInfo,onRaidInfo);					//副本信息回复
			MsgPool.addCallBack(GameCmd.SObtainRaid,SObtainRaid,onRaidCreated);				//副本实例被创建
			MsgPool.addCallBack(GameCmd.SLoseRaid,SLoseRaid,onRaidLose);					//副本实例失去
			MsgPool.addCallBack(GameCmd.SBeginCloseCount,SBeginCloseCount,onBeginCloseCount);//副本可以关闭
//			MsgPool.addCallBack(GameCmd.SStopCloseCount,SStopCloseCount,onStopCloseCount);	//副本不可以关闭
			MsgPool.addCallBack(GameCmd.SCloseRaid,SCloseRaid,onCloseRaid);					//副本关闭回复
			MsgPool.addCallBack(GameCmd.SRaidGrade,SRaidGrade,onRaidGrade);					//副本结算回复
			MsgPool.addCallBack(GameCmd.SFetchRaidReward,SFetchRaidReward,onFetchRaidReward);//副本奖励获得回复
			MsgPool.addCallBack(GameCmd.SWaveInfo,SWaveInfo,onSWaveInfo);					//怪物波数回复
			
			///剧情控制协议  用来控制副本什么时候退出
			MsgPool.addCallBack(GameCmd.SStartTailStory,SStartTailStory,onSStartTailStory);//开始剧情
 
			//打我副本后的 剧情  播放完时
			YFEventCenter.Instance.addEventListener(StoryEvent.RaidStoryEndComplete,onStroyEvent);
			
			//进入副本后收到副本信息，后补的
			MsgPool.addCallBack(GameCmd.SRaidInit,SRaidInit,onRaidInit);                  //副本初始化信息

		}
		
		private function onRaidInit(msg:SRaidInit):void
		{
			RaidDyManager.Instence.current_total_enemy=msg.totalEnemyNumber;
			RaidDyManager.Instence.current_killed_enemy=msg.killedEnemyNumber;
			if(msg.hasTotalWave)
				RaidDyManager.Instence.setWaveInfo(msg.currentWave,msg.totalWave,msg.waitTime);
			else
				RaidDyManager.Instence.setWaveInfo(1,1,0);
//			RaidDyManager.Instence.raidStart();
//			_miniPanel.startTimer();
			trace("raid init");
		}
		private function onSStartTailStory(sStartTailStory:SStartTailStory):void
		{
			var raidVo:RaidVo=null;
			if(RaidManager.raidId>0)
			{
				raidVo=RaidManager.Instance.getRaidVo(RaidManager.raidId);
			}
			if(raidVo.story_end_id>0&&raidVo)  //有剧情id 
			{
				var storyVo:StoryShowVo=new StoryShowVo();
				storyVo.id=raidVo.story_end_id;
				storyVo.storyPositionType=TypeStory.StoryPositionType_RaidEnd;
				YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,storyVo);
			}
			else 
			{
				sendFinishStory();
			}

		}
		/**结束剧情动画
		 */
		private function sendFinishStory():void
		{
			var cEndStoryFinish:CEndStoryFinish=new CEndStoryFinish();
			MsgPool.sendGameMsg(GameCmd.CEndStoryFinish,cEndStoryFinish); 
		}
		/**剧情结束 完成副本
		 */		
		private function onStroyEvent(e:YFEvent):void
		{
			//副本开始时候的剧情  剧情结束后进行挂机
			sendFinishStory();
		}


		
		
		/**怪物波数回复
		 * @param msg
		 */
		private function onSWaveInfo(msg:SWaveInfo):void{
			RaidDyManager.Instence.setWaveInfo(msg.currentWave,msg.totalWave,msg.waitTime);
			_miniPanel.update();
		}
		
		/**副本奖励回复
		 * @param msg
		 */		
		private function onFetchRaidReward(msg:SFetchRaidReward):void{
			if(_raidClosureView){
				if(_raidClosureView.hasDisposed==false){
					clearInterval(_closureTimeId);
					_closureTime=5;
					_raidClosureView.updateTime(_closureTime);
					_raidClosureView.updateReward(msg.rewardBasicId);
					_closureTimeId = setInterval(closureCountDown,1000);
				}else{
					clearInterval(_closureTimeId);
					_raidClosureView=null;
				}
			}
		}
		
		/**获取副本奖励
		 * @param e
		 */		
		private function fetchRaidReward(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CFetchRaidReward,(e.param) as CFetchRaidReward);
		}
		
		/**副本评分回复
		 * @param msg
		 */		
		private function onRaidGrade(msg:SRaidGrade):void{
			_raidClosureView = new RaidClosureView();
			_closureTime=20;
			_closureTimeId = setInterval(closureCountDown,1000);
			_raidClosureView.updateGrade(msg.grade);
			_raidClosureView.updateTime(_closureTime);
		}
		/**关闭副本倒计时
		 */		
		private function closureCountDown():void{
			_closureTime--;
			_raidClosureView.updateTime(_closureTime);
			if(_closureTime==0){
				clearInterval(_closureTimeId);
				_raidClosureView.close();
				_raidClosureView=null;
			}
		}
		
		/**关闭副本回复
		 * @param msg
		 */
		private function onCloseRaid(msg:SCloseRaid):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
//				_closeSp.removeEntry(msg.raidId);
				_exitSp.removeExit();
			}
		}
		
		/**关闭副本请求
		 * @param e
		 */		
		private function closeRaid(e:YFEvent):void{
			var msg:CCloseRaid = new CCloseRaid();
			msg.raidId = RaidManager.Instance.getRaidIdByGroupId((e.param as RaidNPCVo).raidId);
			MsgPool.sendGameMsg(GameCmd.CCloseRaid, msg);
		}
		
//		/**结束倒数副本关闭时间
//		 * @param msg
//		 */		
//		private function onStopCloseCount(msg:SStopCloseCount):void{
//			_closeSp.removeEntry(msg.raidId);
//		}
		
		/**开始倒数副本关闭时间
		 * @param msg
		 */		
		private function onBeginCloseCount(msg:SBeginCloseCount):void{
//			var time:int;
//			if(msg.hasRestSeconds)	time=msg.restSeconds;
//			else 	time=1;
//			_closeSp.addClose();
//			_closeSp.addEntry(msg.raidId,time);
			if(TaskMiniPanel.getInstance()._isMiniNow)	TaskMiniPanel.getInstance().onMiniBtnClick();
		}
		
		/**离开副本请求
		 * @param e
		 */		
		private function exitRaid(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CExitRaid,new CExitRaid());
		}
		
		/**副本实例被关闭
		 * @param msg
		 */		
		private function onRaidLose(msg:SLoseRaid):void{
			RaidManager.raidId=-1;
			var arr:Array = RaidManager.Instance.getRaidsByGroupId(msg.groupId);
			for(var i:int=0;i<arr.length;i++){
				RaidVo(arr[i]).isCreated = false;
				RaidVo(arr[i]).deadNum = 0;
			}
//			RaidManager.Instance.getRaidVo(msg.raidId).isCreated=false;
//			RaidManager.Instance.getRaidVo(msg.raidId).deadNum=0;
			_exitSp.removeExit();
//			_closeSp.removeEntry(msg.raidId);
			if(DemonMiniWindow.Instance.visible==true){
				DemonMiniWindow.Instance.visible=false;
				TaskMiniPanel.getInstance().visible=true;
				MsgPool.sendGameMsg(GameCmd.CDemonInvadeLevel,new CDemonInvadeLevel());
			}
			if(TaskMiniPanel.getInstance()._isMiniNow)	TaskMiniPanel.getInstance().onMiniBtnClick();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.QuitActivity);
			RaidMiniPanel.Instance.visible=false;
			_miniPanel.stopTimer();
		}
		
		/**副本实例被创建
		 * @param msg
		 */
		private function onRaidCreated(msg:SObtainRaid):void{
			RaidManager.Instance.getRaidVo(msg.raidId).isCreated=true;
		}
		
		/**切换场景
		 * @param e
		 */		
		private function reqChgMap(e:YFEvent):void{
			var nextId:int = RaidManager.Instance.getRaidVo(RaidManager.raidId).nextRaidId;
			if(nextId==-1)
				Alert.show("是否确定退出副本【"+RaidManager.Instance.getRaidVo(RaidManager.raidId).raidName+"】","副本",onExit,["确认","取消"]);
			else
			{
				if(TransferPointManager.Instance.autoMove)  //自动进入
				{
					enterRaid(); //直接进入下一个场景
				}
				else 
				{
					Alert.show("是否进入【"+RaidManager.Instance.getRaidVo(nextId).raidName+"】副本","副本",onExit,["确认","取消"]);
				}
			}
		}
		
		/**确认切换场景
		 * @param e
		 */		
		private function onExit(e:AlertCloseEvent):void{
			if(e.clickButtonIndex==1)	
			{
				enterRaid();
			}
		}
		/**进入下一个场景
		 */
		private function enterRaid():void
		{
			MsgPool.sendGameMsg(GameCmd.CRaidWayPoint,new CRaidWayPoint());
		}
		
		/**切换地图时需要把倒计时清除
		 * @param e
		 */		
		private function onChgMap(e:YFEvent):void{
			if(_countTxt){
				LayerManager.PopLayer.removeChild(_countTxt);
				_countTxt = null;
			}
			_exitSp.removeExit();
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			if(mapSceneBasicVo.type==TypeRole.MapScene_Raid||mapSceneBasicVo.type==TypeRole.MapScene_Arena){
				if(!CardMovieView.CardMovieLoaded){ 
					CardMovieView.preLoading();
				}
			}
			
		}
		
		/**请求获取副本信息 
		 * @param e
		 */		
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CRaidInfo,new CRaidInfo());
		}
		
		/**添加副本信息
		 * @param msg
		 */		
		private function onRaidInfo(msg:SRaidInfo):void{
			if(msg){
				len = msg.raids.length;
				for(i=0;i<len;i++){
					var arr:Array = RaidManager.Instance.getRaidsByGroupId(msg.raids[i].groupId);
					var len2:int = arr.length;
					for(var j:int=0;j<len2;j++){
						arr[j].raidNum = msg.raids[i].raidNum;
						arr[j].isCreated =msg.raids[i].created;
					}
//					RaidManager.Instance.getRaidVo(msg.raids[i].raidId).raidNum=msg.raids[i].raidNum;
//					RaidManager.Instance.getRaidVo(msg.raids[i].raidId).isCreated=msg.raids[i].created;
//					if(RaidInfo(msg.raids[i]).hasCloseTime){
//						_closeSp.addClose();
//						_closeSp.addEntry(msg.raids[i].raidId,msg.raids[i].closeTime);
//					}
				}
			}else{
				arr = RaidManager.Instance.getRaidList();
				var len:int = arr.length;
				for(var i:int=0;i<len;i++){
					arr[i].raidNum=0;
					arr[i].isCreated=false;
				}
			}
		}
		
		/**可以显示传送点
		 * @param msg
		 */		
		private function onExitAppear(msg:SExitAppear):void{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ExitAppearable,true);
		}
		
		/**可以离开副本回复,到时10秒自动退出
		 * @param msg
		 */		
		private function onLeaveable(msg:SLeaveCountDown):void{
			var raidAlert:RaidAlert;
			var raidVo:RaidVo = RaidManager.Instance.getRaidVo(RaidManager.raidId);
			if(raidVo.deadNum>=raidVo.deadTimes){
				raidAlert=new RaidAlert();
				raidAlert.updateContent("您的复活次数已用完！");
				raidAlert.open();
			}else{
				raidAlert = new RaidAlert();
				raidAlert.updateContent("【"+RaidManager.Instance.getRaidVo(RaidManager.raidId).raidName+"】已通关！");
				raidAlert.open();
				YFEventCenter.Instance.dispatchEventWith(FeedEvent.RaidWin);//朋友网feed分享
			}
		}
		
//		/** 离开副本通知关闭
//		 */		
//		private function countDown():void{
//			_countTxt.text = "副本将会在"+_time+"秒后关闭!!";			
//			_time--;
//			if(_time<0){
//				clearInterval(_timeId);
//				LayerManager.PopLayer.removeChild(_countTxt);
//				_countTxt = null;
//				RaidManager.raidId=-1;
//				MsgPool.sendGameMsg(GameCmd.CExitRaid,new CExitRaid());
//			}
//		}
		
		/**进入副本回复
		 * @param msg
		 */		
		private function onEnterRaid(msg:SEnterRaid):void{
			var raidVo:RaidVo;
			if(msg.errorInfo==TypeProps.RSPMSG_RAID_TIMELIMIT){
				raidVo=RaidManager.Instance.getRaidVo(msg.raidId);
				Alert.show("副本的开放时间：\n"+RaidTimeBasicManager.Instance.getTimeString(raidVo.timeId)+"\n暂时不能入哦~~","副本");
			}else if(msg.errorInfo==TypeProps.RSPMSG_RAID_LEVEL_NOT_FIT){
				NoticeUtil.setOperatorNotice("等级不符合要求！");
			}else{
//				_exitSp.removeExit();
				RaidManager.raidId = msg.raidId;
				raidVo=RaidManager.Instance.getRaidVo(msg.raidId);
				var arr:Array = RaidManager.Instance.getRaidsByGroupId(raidVo.groupId);
				var len:int = arr.length;
				for(var i:int=0;i<len;i++){
					RaidVo(arr[i]).raidNum = msg.enterTimes;
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ExitAppearable,msg.isExitAppear);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AutoMonsterUpdate);
				YFEventCenter.Instance.dispatchEventWith(RaidEvent.EnterAllRaid,raidVo);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterActivity);
				if(RaidManager.Instance.getRaidVo(msg.raidId).activityId==DemonWindow.activityType){
					if(DemonWindow.Instance.isOpen){
						DemonWindow.Instance.switchOpenClose();
						YFEventCenter.Instance.dispatchEventWith(DemonEvent.DemonRaid);
					}
				}else{
					_exitSp.addExit(msg.restTime);
					if(!TaskMiniPanel.getInstance()._isMiniNow)	TaskMiniPanel.getInstance().onMiniBtnClick();
					_miniPanel.visible=true;
					RaidDyManager.Instence.raid_rest_time=msg.restTime;
					RaidDyManager.Instence.currentRaid=raidVo;
					RaidDyManager.Instence.raidStart();
					_miniPanel.startTimer();
					_miniPanel.update();
					trace("raid enter");
				}
			}
		}
		
		/**不通过npc进入副本
		 * @param e
		 */		
		private function onCreateRaidWONPC(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CEnterRaid,e.param as CEnterRaid);
		}
		
		/**创建副本
		 * @param e
		 */
		private function onCreateRaid(e:YFEvent):void{
			var raidNPCVo:RaidNPCVo = e.param as RaidNPCVo;
			//this is group id
			raidNPCVo.raidId = RaidManager.Instance.getRaidIdByGroupId(raidNPCVo.raidId);			
			var raidVo:RaidVo=RaidManager.Instance.getRaidVo(raidNPCVo.raidId);
			if(raidVo.isCreated==true){
				sendEnterRaid(raidNPCVo);
			}else if(raidVo.raidType==TypeProps.RaidTypeTeam && TeamDyManager.Instance.getMembers().length>1 && TeamDyManager.LeaderId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
				NoticeUtil.setOperatorNotice("组队状态下，只有队长才能创建该副本!");	
			}else{
				if(raidVo.createTerm!=""){
					var createTerms:Array = raidVo.createTerm.split("|");
					var isCreatable:Boolean=true;
					for(var i:int=0;i<createTerms.length;i++){
						var terms:Array = createTerms[i].split("_");
						var itemConsume:ItemConsume;
						switch(terms[0]){
							case "1":
								if(PropsDyManager.instance.getPropsQuantity(int(terms[1]))<int(terms[2])){
									isCreatable=false;
									NoticeUtil.setOperatorNotice("该副本需要"+terms[2]+"个"+PropsBasicManager.Instance.getPropsBasicVo(int(terms[1])).name+"才能创建副本!");
								}else{
									var arr:Array=PropsDyManager.instance.getPropsPosArray(int(terms[1]),int(terms[2]));
									for(var j:int=0;j<arr.length;j++){
										(e.param as RaidNPCVo).propsArr.push(arr[j]);
									}
								}
								break;
							case "2":
								if(PropsDyManager.instance.getPropsQuantity(int(terms[1]))<int(terms[2])){
									isCreatable=false;
									NoticeUtil.setOperatorNotice("该副本需要"+terms[2]+"个"+PropsBasicManager.Instance.getPropsBasicVo(int(terms[1])).name+"才能创建副本!");
								}else{
									arr=PropsDyManager.instance.getPropsPosArray(int(terms[1]),int(terms[2]));
									for(j=0;j<arr.length;j++){
										(e.param as RaidNPCVo).propsArr.push(arr[j]);
									}
								}
								break;
						}
						if(!isCreatable)	break;
					}
					if(isCreatable){
						//Alert.show("是否创建副本【"+raidVo.raidName+"】","副本",onCreateRaidConfirm,["确认","取消"],true,e.param);
						sendEnterRaid(raidNPCVo);
					}
				}
			}
		}
				
		/**发送进入副本请求
		 * @param data
		 */		
		private function sendEnterRaid(data:RaidNPCVo):void{
			var msg:CEnterRaid=new CEnterRaid();
			msg.raidId = data.raidId;
			msg.npcId = data.npcId;
			var raid:RaidVo = RaidManager.Instance.getRaidVo(msg.raidId);
			if(raid.createTerm!=""){
				var propsArr:Array=new Array;
				var createTerms:Array = raid.createTerm.split("|");
				for(var i:int=0;i<createTerms.length;i++){
					var terms:Array = createTerms[i].split("_");
					switch(terms[0]){
						case "1":
							var arr:Array = PropsDyManager.instance.getPropsPosArray(int(terms[1]),int(terms[2]));
							for each(var obj:Object in arr){
								propsArr.push(obj);
							}
							break;
					}
				}
				msg.items = propsArr;
			}
			
			MsgPool.sendGameMsg(GameCmd.CEnterRaid,msg);
		}
	}
} 
