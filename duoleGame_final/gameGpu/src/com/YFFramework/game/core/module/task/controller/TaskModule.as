package com.YFFramework.game.core.module.task.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.event.TaskEvent;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.YFFramework.game.core.module.task.view.TaskMiniPanel;
	import com.YFFramework.game.core.module.task.view.TaskWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.lang.LangBasic;
	import com.msg.enumdef.RspMsg;
	import com.msg.task.*;
	import com.net.MsgPool;
	
	import flash.utils.getTimer;

	/**任务系统 
	 * @author flashk
	 */
	public class TaskModule extends AbsModule{
		
		private static var _ins:TaskModule;
		
		private var _taskWindow:TaskWindow;
		private var _miniPanel:TaskMiniPanel;
		
		public function TaskModule(){
			_ins = this;
			_belongScence=TypeScence.ScenceGameOn;
			_taskWindow = new TaskWindow();
			_miniPanel = new TaskMiniPanel();

		}

		/**初始化
		 */
		override public function init():void{
			_miniPanel.init();
			//引用  自动触发方法 开启自动寻路
			NewGuideManager.taskGuideFunc=_miniPanel.autoTrigger;
			NewGuideManager.taskFlyBootFunc=_miniPanel.flyBootTrigger;
			
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_RequestAcceptTask,onC_RequestAcceptTask);
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_RequestFinishTask,onC_RequestFinishTask);
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_NpcDialogTask,onC_NpcDialogTask);
			YFEventCenter.Instance.addEventListener(GlobalEvent.TaskUIClick,onUIClick);
			YFEventCenter.Instance.addEventListener(TaskEvent.ABLE_CHANGE,onAbleChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
		}
		/** 进入  游戏 
		 */		
		private function onGameIn(e:YFEvent):void
		{
			getCurrentTask();
			getAcceptableTask();

		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SCurrentTaskList,SCurrentTaskList,onCrtTaskList);		//当前任务列表回复
			MsgPool.addCallBack(GameCmd.SAcceptableTaskList,SAcceptableTaskList,onAbleTaskList);//可接任务列表回复
			MsgPool.addCallBack(GameCmd.SAcceptTaskRsp,SAcceptTaskRsp,onAcceptTask);			//同意接受任务回复
			MsgPool.addCallBack(GameCmd.SFinishTaskRsp,SFinishTaskRsp,onFinishTask);			//完成任务回复
			MsgPool.addCallBack(GameCmd.SGiveUpTaskRsp,SGiveUpTaskRsp,onGiveUpTask);			//放弃任务回复
			MsgPool.addCallBack(GameCmd.SNpcDialogRsp,SNpcDialogRsp,onSNpcDialogRsp);			//暂时没用，以后去掉？
			MsgPool.addCallBack(GameCmd.SDelAcptTaskList,SDelAcptTaskList,onDelAbleTask);		//删除一些不再可接的任务
		}
		
		private function onUIClick(e:YFEvent):void{
			_taskWindow.switchOpenClose();
		}
		
		private function onDelAbleTask(msg:SDelAcptTaskList):void{
			if(msg){
				var len:int=msg.taskList.length;
				for(var i:int=0;i<len;i++){
					TaskDyManager.getInstance().removeAbleTask(msg.taskList[i].taskId);
					updateAbleUI(false);
				}
			}
		}
		
		/**服务器返回当前任务列表 
		 * @param msg	收到的协议
		 */
		private function onCrtTaskList(msg:SCurrentTaskList):void{
			if(msg){
				
				var isMainTrankChange:Boolean=TaskDyManager.getInstance().updateCrtTaskList(msg);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.taskGetNowList);
				updateNowTaskUI(isMainTrankChange);
				
				//任务数据vo 
				var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getTaskVO(msg.taskList[0].taskId);
				if(taskDyVo.isFinish)  //进行对话  完成任务 进行对话
				{
					var taskBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					if(taskBasicVo.reach_story_id>0)
					{
						YFEventCenter.Instance.dispatchEventWith(StoryEvent.ReachTaskStory,taskBasicVo.reach_story_id);
					}
				}
			}
		}
		
		/**服务器返回可接任务列表 
		 * @param msg	收到的协议
		 */
		private function onAbleTaskList(msg:SAcceptableTaskList):void{
			var triggerTaskWalk:Boolean=true;//自动寻路 //还是直接跳到 主城任务
			var isMainTask:Boolean=false;
			if(msg){
				isMainTask=TaskDyManager.getInstance().updateAbleTaskList(msg);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.taskGetAbleList);
				if(TaskInf(msg.taskList[0]).taskId==NewGuideManager.SkipToMainCityGetTaskId)  //如果为跳到主城的可接列表
				{
					triggerTaskWalk=false; //跳到主城
				}
			}
			var trigger:Boolean=isMainTask;
			if(triggerTaskWalk==false)
			{
				trigger=triggerTaskWalk;
			}
			_miniPanel.updateAbleTask(TaskDyManager.getInstance().ableTaskList,trigger);
			_taskWindow.ableCOL.updateAbleTask(TaskDyManager.getInstance().ableTaskList);
			if(!triggerTaskWalk)  //不进行自动寻路 则是 直接跳到主城的任务
			{
				NewGuideManager.taskFlyBootFunc(); //跳到 主城
				//跳到主城
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterMainCity);
			}
			if(TaskDyManager.getInstance().nowTaskList.length==0 && TaskDyManager.getInstance().ableTaskList.length >0){
				switchUITabTo(2);
			}
		}
		
		/**接受任务服务器返回     可接任务列表的删除 是在onDelAbleTask  SDelAcptTaskList 协议里面
		 * @param msg
		 */
		private function onAcceptTask(msg:SAcceptTaskRsp):void{
			if(msg.rsp == RspMsg.RSPMSG_SUCCESS){
				TaskDyManager.getInstance().removeAbleTask(msg.taskInf.taskId);
				switchUITabTo(1);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.acceptTaskOK,msg.taskInf.taskId);
				///接受任务成功后返回
				var taskBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(msg.taskInf.taskId);
				if(taskBasicVo.rev_story_id>0)  //有剧情id 
				{
					YFEventCenter.Instance.dispatchEventWith(StoryEvent.AcceptTaskStory,taskBasicVo.rev_story_id);
				}
				
			}else{
				if(msg.rsp == RspMsg.RSPMSG_TASK_LOOP_IN_CD){
					NoticeUtil.setOperatorNotice("任务链在CD中，请稍后重试");
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.acceptTaskFaild,msg.taskInf.taskId);
				NoticeUtil.setOperatorNotice("距离太远,接受任务失败");
			}
		} 
		
		/**完成任务服务器返回 
		 * @param msg
		 */
		private function onFinishTask(msg:SFinishTaskRsp):void
		{
			if(msg.rsp == RspMsg.RSPMSG_SUCCESS){
				
				///接受任务成功后返回
				var taskBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(msg.taskInf.taskId);
				if(taskBasicVo.sub_story_id>0)  //有剧情id 
				{
					YFEventCenter.Instance.dispatchEventWith(StoryEvent.FinishTaskStory,taskBasicVo.sub_story_id);
				}
				
				TaskDyManager.getInstance().removeCrtTask(msg.taskInf.taskId);
				var triggeTask:Boolean=true;
				if(msg.taskInf.taskId==NewGuideManager.SkipToMainCityFinishTaskId)
				{
					triggeTask=false
				}
				triggeTask=false;  ///完成任务可以不用触发 任务引导 因为是先发送的可接任务列表再发送的完成任务列表
				updateNowTaskUI(triggeTask);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.finishTaskOK,msg.taskInf.taskId);
				if(TaskDyManager.getInstance().nowTaskList.length==0 && TaskDyManager.getInstance().ableTaskList.length >0){
					switchUITabTo(2);
				}
			}else{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.finishTaskFaild,msg.taskInf.taskId);
				NoticeUtil.setOperatorNotice(LangBasic.taskFinishFaild);
			}
		}
		
		/**放弃任务服务器返回 
		 * @param msg
		 */
		private function onGiveUpTask(msg:SGiveUpTaskRsp):void{
			if(msg.rsp==RspMsg.RSPMSG_SUCCESS){
				TaskDyManager.getInstance().removeCrtTask(msg.taskInf.taskId);
				updateNowTaskUI();
				if(TaskDyManager.getInstance().nowTaskList.length==0)	switchUITabTo(2);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.giveUpTaskOK,msg.taskInf.taskId);
			}else{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.giveUpTaskFaild,msg.taskInf.taskId);
			}
		}
		
		/**NPC对话任务返回 
		 * @param data
		 */
		private function onSNpcDialogRsp(data:SNpcDialogRsp):void{
		}

		/**
		 * 更新可接任务UI显示 
		 * 
		 */
		private function updateAbleUI(trigger:Boolean=true):void
		{
			_miniPanel.updateAbleTask(TaskDyManager.getInstance().ableTaskList,trigger);
			_taskWindow.ableCOL.updateAbleTask(TaskDyManager.getInstance().ableTaskList);
		}
		
		/**
		 * 接受NPC系统的完成对话事件 
		 * @param event
		 * 
		 */
		private function onC_NpcDialogTask(event:YFEvent):void
		{
			var taskHandleVO:TaskNPCHandleVo=event.param as TaskNPCHandleVo;
			dialogNPC(taskHandleVO.taskId,taskHandleVO.npcDyId,taskHandleVO.loopId,taskHandleVO.run_rings_id);	
		}
		
		/**
		 * 可接任务列表更改 
		 * @param event
		 * 
		 */
		private function onAbleChange(event:YFEvent):void
		{
			updateAbleUI();
		}
		
		/**
		 * 完成任务返回 
		 * @param event
		 * 
		 */
		private function onC_RequestFinishTask(event:YFEvent):void
		{
			var taskNpcHandle:TaskNPCHandleVo=event.param as TaskNPCHandleVo;
			finishTask(taskNpcHandle.taskId,taskNpcHandle.npcDyId,taskNpcHandle.loopId,taskNpcHandle.run_rings_id);
		}
		
		/**
		 * 接受任务返回 
		 * @param event
		 * 
		 */
		private function onC_RequestAcceptTask(event:YFEvent):void
		{
			var taskNpcHandle:TaskNPCHandleVo=event.param as TaskNPCHandleVo;
			acceptTask(taskNpcHandle.taskId,taskNpcHandle.npcDyId,taskNpcHandle.loopId,taskNpcHandle.run_rings_id);	
		}

		/**
		 * 切换任务窗口和小面板到指定Tab 
		 * @param index
		 * 
		 */
		public function switchUITabTo(index:int):void
		{
			_taskWindow.tabs.switchToTab(index);
			_miniPanel.tabs.switchToTab(index);
		}
		
		public static function getInstance():TaskModule
		{
			return _ins;
		}
		
		/**
		 * 接受任务 
		 * @param taskID 任务ID
		 * @param npcID NPC动态ID
		 * 
		 */
		public function acceptTask(taskID:int,npcID:int,loopID:int,run_rings_id:int):void
		{
			var msg:CAcceptTaskReq = new CAcceptTaskReq();
			msg.taskInf = new TaskInf();
			if(loopID>0){
				msg.taskInf.loopId = loopID;
//				if(TaskDyManager.getInstance().getCDTime(loopID)>0){
//					NoticeUtil.setOperatorNotice("任务链在CD中，请稍后重试");
//					return;
//				}
			}
			if(run_rings_id>0)
			{
				msg.taskInf.runId=run_rings_id
			}
			msg.taskInf.taskId = taskID;
			msg.npcId = npcID;
			MsgPool.sendGameMsg(GameCmd.CAcceptTaskReq,msg);
		}
		
		/**
		 * 完成任务 
		 * @param taskID 任务ID
		 * @param npcID NPC动态ID
		 * 
		 */
		public function finishTask(taskID:int,npcID:int,loopID:int,run_rings_id:int):void
		{
			var vo:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(taskID);
			var vct:Vector.<Task_rewardBasicVo> = Task_rewardBasicManager.Instance.getTaskRewards(vo.task_reward_id);
			var len:int = vct.length;
			var equVct:Vector.<ObjectAmount> = new Vector.<ObjectAmount>();
			var popsVct:Vector.<ObjectAmount> = new Vector.<ObjectAmount>();
			var oa:ObjectAmount;
			for(var i:int=0;i<len;i++){
				switch(vct[i].rw_type)
				{
					case RewardTypes.EQUIP:
						oa = new ObjectAmount();
						oa.id = vct[i].rw_id;
						oa.amount = vct[i].rw_num;
						equVct.push(oa);
						break;
					case RewardTypes.PROPS:
						oa = new ObjectAmount();
						oa.id = vct[i].rw_id;
						oa.amount = vct[i].rw_num;
						popsVct.push(oa);
						break;
				}
			}
//			if(BagStoreManager.instantce.containsEnoughSpace(equVct,popsVct)==false){
//				NoticeUtil.setOperatorNotice(LangBasic.cantPutInBagTask);
//				return;
//			}
			var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getCurrentTaskDyVo(taskID);
			taskDyVo.isSubmit=true;
//			print(this,"id="+taskDyVo.taskID,"taskDyVo.isSubmit:",taskDyVo.isSubmit);
			var msg:CFinishTaskReq = new CFinishTaskReq();
			msg.taskInf = new TaskInf();
			if(loopID>0){
				msg.taskInf.loopId = loopID;
			}
			if(run_rings_id>0)
			{
				msg.taskInf.runId=run_rings_id
			}

			msg.taskInf.taskId = taskID;
			msg.npcId = npcID;
			MsgPool.sendGameMsg(GameCmd.CFinishTaskReq,msg);
		}
		
		/**
		 * 放弃任务 
		 * @param taskID 任务ID
		 * 
		 */
		public function giveUpTask(taskID:int,loopID:int,run_rings_id:int):void
		{
			var msg:CGiveUpTaskReq = new CGiveUpTaskReq();
			msg.taskInf = new TaskInf();
			if(loopID>0){
				msg.taskInf.loopId = loopID;
			}
			if(run_rings_id>0)
			{
				msg.taskInf.runId=run_rings_id
			}
					
			msg.taskInf.taskId = taskID;
			MsgPool.sendGameMsg(GameCmd.CGiveUpTaskReq,msg);
		}

		/**
		 * 完成NPC对话 
		 * @param taskID  任务ID
		 * @param npcID  NPC动态ID
		 * 
		 */
		public function dialogNPC(taskID:int,npcID:int,loopID:int,run_rings_id:int):void
		{
			var msg:CNpcDialogReq = new CNpcDialogReq();
			msg.taskInf = new TaskInf();
			if(loopID>0){
				msg.taskInf.loopId = loopID;
			}
			if(run_rings_id>0)
			{
				msg.taskInf.runId=run_rings_id
			}
			
			msg.taskInf.taskId = taskID;
			msg.npcId = npcID;
			MsgPool.sendGameMsg(GameCmd.CNpcDialogReq,msg);
		}
		
		/**获取当前任务列表：请求
		 */
		public function getCurrentTask():void{
			MsgPool.sendGameMsg(GameCmd.CGetCurrentTaskReq,new CGetCurrentTaskReq());
		}
		
		/**获取当前任务列表：请求
		 */
		public function getAcceptableTask():void{
			MsgPool.sendGameMsg(GameCmd.CGetAcceptableTaskReq,new CGetAcceptableTaskReq());
		}
		
		/**更新当前任务UI显示 
		 */
		private function updateNowTaskUI(triggeTask:Boolean=true):void{
			_miniPanel.updateCurrentTask(triggeTask);
			_taskWindow.nowCOL.updateTaskList(TaskDyManager.getInstance().nowTaskList);
		}
		
	}
}