package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.TaskStateVO;
	import com.YFFramework.game.core.module.task.model.TaskTagDyVo;
	import com.YFFramework.game.core.module.task.model.Task_loopBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.core.module.task.model.TypeTask;
	import com.msg.task.CurrentTaskInf;
	import com.msg.task.SAcceptableTaskList;
	import com.msg.task.SCurrentTaskList;
	import com.msg.task.TaskInf;
	import com.msg.task.TaskTagInf;
	
	import flash.utils.getTimer;

	/**任务数据中心 
	 * @author flashk
	 */
	public class TaskDyManager{
		
		private static var _ins:TaskDyManager;
		
		private var _nowTaskList:Vector.<TaskDyVo> = new Vector.<TaskDyVo>();
		private var _ableTaskList:Vector.<TaskDyVo> = new Vector.<TaskDyVo>();
		private var _cdTimes:Object = {};
		private var _ableData:Object;
		private var _nowChangeIndex:int;
	
		public function TaskDyManager(){
		}
		
		public function get nowChangeIndex():int
		{
			return _nowChangeIndex;
		}

		public function getCDTime(loopID:int):int
		{
			var loopVO:Task_loopBasicVo = Task_loopBasicManager.Instance.getTask_loopBasicVo(loopID);
			if(loopVO){
				if(_cdTimes["t"+loopVO.cd_type]){
					var l:int =loopVO.cd_time*1000 -  (getTimer()-_cdTimes["t"+loopVO.cd_type]);
					if(l>0){
						return l;
					}else{
						return -1;
					}
				}
			}
			return -1;
		}
		
		public static function getInstance():TaskDyManager{
			if(_ins == null){
				_ins = new TaskDyManager();
			}
			return _ins;
		}

		public function getTaskVOByBasicVO(bvo:TaskBasicVo):TaskDyVo
		{
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].taskID == bvo.task_id){
					return _nowTaskList[i];
				}
			}
			return null;
		}
		
		/**获取当前任务的 动态vo 
		 */
		public function getTaskVO(taskId:int):TaskDyVo
		{
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].taskID == taskId){
					return _nowTaskList[i];
				}
			}
			return null;
		}

		/**
		 * 获取当前NPC是否有可完成任务 
		 * @param npcID   静态 id  模版id    不是场景的动态id 
		 */
		public function getFinishNPCTasks(npcID:int):Vector.<TaskBasicVo>
		{
			var vct:Vector.<TaskBasicVo> = new Vector.<TaskBasicVo>();
			var vo:TaskBasicVo;
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				vo = TaskBasicManager.Instance.getTaskBasicVo(_nowTaskList[i].taskID);
				if(vo){
					if(vo.sub_npc_id == npcID && _nowTaskList[i].isFinish == true){
						if(_nowTaskList[i].loopId!=-1){
							vo.loopID = _nowTaskList[i].loopId;
						}
						vct.push(vo);
					}
				}
			}
			return vct;
		}
		
		
		
		
		/**
		 * 获取当前任务NPC对话的数据VO，如果没有，返回null 
		 * @param npcID   npc 动态id 
		 * @return 
		 * 
		 */
		public function getNPCDialogVO(npcID:int):TaskIDTargetVO
		{
			var vo:TaskBasicVo;
			var len:int = _nowTaskList.length;
			var taskTargetBasicVo:Task_targetBasicVo;
			var taskBasicVo:TaskBasicVo;
			for(var i:int=0;i<len;i++){
				var jLen:int = _nowTaskList[i].tagList.length;
				for(var j:int=0;j<jLen;j++){
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(_nowTaskList[i].taskID);
					taskTargetBasicVo = Task_targetBasicManager.Instance.findTaskDialogTargetVO(npcID,_nowTaskList[i].tagList[j].tagID,taskBasicVo.task_tag_id); ////此处  需要修改  应该填入 taskTagId 
					if(taskTargetBasicVo && _nowTaskList[i].tagList[j].isFinish==false){
						var taskIdTagetVo:TaskIDTargetVO = new TaskIDTargetVO();
						taskIdTagetVo.targetBasicVO = taskTargetBasicVo;
						taskIdTagetVo.taskID = _nowTaskList[i].taskID;
						return taskIdTagetVo;
						
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取当前NPC正在进行中的任务列表 
		 * @param npcID    静态 id  模版id    不是场景的动态id 
		 * @return 
		 * 
		 */
		public function getProgressNPCTasks(npcID:int):Vector.<TaskBasicVo>
		{
			var vct:Vector.<TaskBasicVo> = new Vector.<TaskBasicVo>();
			var vo:TaskBasicVo;
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				vo = TaskBasicManager.Instance.getTaskBasicVo(_nowTaskList[i].taskID);
				if(vo){
					if(vo.sub_npc_id == npcID && _nowTaskList[i].isFinish == false){
						vct.push(vo);
					}
				}
			}
			return vct;
		}
		/**得到当前任务 vo
		 */		
		public function getCurrentTaskDyVo(taskID:int):TaskDyVo{
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].taskID == taskID){
					return _nowTaskList[i];
				}
			}
			return null;
		}

		/**得到可接任务 vo
		 */		
		public function getAbleTaskDyVo(taskID:int):TaskDyVo{
			var len:int = _ableTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_ableTaskList[i].taskID == taskID){
					return _ableTaskList[i];
				}
			}
			return null;
		}
		
		/**可接列表的长度
		 */
		public function getAbleListLength():int
		{
			return _ableTaskList.length;
		}
		
		/**通过loopID获取taskdyvo
		 * @param loopId
		 * @return 
		 */		
		public function getTaskDyVoByLoopId(loopId:int):TaskDyVo{
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].loopId == loopId){
					return _nowTaskList[i];
				}
			}
			len = _ableTaskList.length;
			for(i=0;i<len;i++){
				if(_ableTaskList[i].loopId == loopId){
					return _ableTaskList[i];
				}
			}
			return null;
		}
		
		/**获取任务状态 
		 * @param taskID
		 * @return int	
		 */		
		public function getTaskState(taskID:int):int{
			var vo:TaskBasicVo;
			var len:int=_nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].taskID==taskID){
					if(_nowTaskList[i].isFinish)	return TaskState.FINISH;
					else	return TaskState.PROGRESS;
				}
			}
			len=_ableTaskList.length;
			for(i=0;i<len;i++){
				if(_ableTaskList[i].taskID==taskID){
					return TaskState.ACCEPT;
				}
			}
			return -1;
		}
		
		/**获取当前NPC可接受任务的列表 
		 * @param npcID   静态 id  模版id    不是场景的动态id 
		 */
		public function getAcceptNPCTasks(npcID:int):Vector.<TaskBasicVo>{
			var vct:Vector.<TaskBasicVo> = new Vector.<TaskBasicVo>();
			var vo:TaskBasicVo;
			var len:int = _ableTaskList.length;
			for(var i:int=0;i<len;i++){
				vo=TaskBasicManager.Instance.getTaskBasicVo(_ableTaskList[i].taskID);
				vo.loopID = _ableTaskList[i].loopId;
				if(vo.recv_npc_id == npcID)	vct.push(vo);
			}
			return vct;
		}
		
		/**把指定的任务从当前任务列表中删除
		 * @param taskID	指定的已完成的任务id
		 */		
		public function removeCrtTask(taskID:int):TaskDyVo{
			var taskDyVo:TaskDyVo;
			var len:int = _nowTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_nowTaskList[i].taskID == taskID){
					taskDyVo=_nowTaskList[i];
					 _nowTaskList.splice(i,1);
					 return taskDyVo;
				}
			}
			return null
		}
		
		/**把指定的任务从可接任务列表中删除
		 * @param taskID	指定的已完成的任务id
		 */
//		public function removeAbleTask(taskID:int):void{
//			var len:int = _ableTaskList.length;
//			for(var i:int=0;i<len;i++){
//				if(_ableTaskList[i].taskID == taskID){
//					_ableTaskList.splice(i,1);
//					break;
//				}
//			}
//		}
		
		/**把指定的任务从可接任务列表中删除  清除指定的可接任务 
		 * @param taskID	指定清除的可接任务id
		 */		
		public function removeAbleTask(taskID:int):void{
			var len:int=_ableTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_ableTaskList[i].taskID==taskID){
					_ableTaskList.splice(i,1);
			//		YFEventCenter.Instance.dispatchEventWith(TaskEvent.ABLE_CHANGE,taskID);
					break;
				}
			}
		}
		
		/**获取npc状态
		 * @param npcID 静态ID
		 * @return 
		 */
		public function getNPCState(npcID:int):TaskStateVO{
			var len:int=_nowTaskList.length;
			var vo:TaskBasicVo;
			var stateVo:TaskStateVO=new TaskStateVO();
			for(var i:int=0;i<len;i++){
				vo=TaskBasicManager.Instance.getTaskBasicVo(_nowTaskList[i].taskID);
				if(_nowTaskList[i].isFinish && vo){
					if(vo.sub_npc_id==npcID){
						stateVo.state=TaskState.FINISH;
						stateVo.vo=vo;
						stateVo.tagList=_nowTaskList[i].tagList;
						return stateVo;
					}
				}
			}
			len=_ableTaskList.length;
			for(i=0;i<len;i++){
				vo=TaskBasicManager.Instance.getTaskBasicVo(_ableTaskList[i].taskID);
				if(vo.recv_npc_id==npcID){
					stateVo.state=TaskState.ACCEPT;
					stateVo.vo=vo;
					stateVo.tagList=_ableTaskList[i].tagList;
					return stateVo;
				}
			}
			len=_nowTaskList.length;
			for(i=0;i<len;i++){
				vo=TaskBasicManager.Instance.getTaskBasicVo(_nowTaskList[i].taskID);
				if(!_nowTaskList[i].isFinish && vo){
					if(vo.sub_npc_id==npcID){
						stateVo.state=TaskState.PROGRESS;
						stateVo.vo=vo;
						stateVo.tagList=_nowTaskList[i].tagList;
						return stateVo;
					}
				}
			}
			stateVo.state=TaskState.NONE;
			return stateVo;
		}
		
		/**获取可接任务列表
		 * @return 
		 */		
		public function get ableTaskList():Vector.<TaskDyVo>{
			return _ableTaskList;
		}
		
		/**获取当前任务列表
		 * @return 
		 */		
		public function get nowTaskList():Vector.<TaskDyVo>{
			return _nowTaskList;
		}
		
		/**更新可接任务列表
		 * @param data
		 * 返回的是  如果更新的是主线列表 则为true 否则为false
		 */		
		public function updateAbleTaskList(data:SAcceptableTaskList):Boolean{
			var len:int=data.taskList.length;
			var taskDyVo:TaskDyVo;
			var mainChange:Boolean=false;
			var taskBasicVo:TaskBasicVo;
//			if(TaskInf(data.taskList[0]).hasLoopId)	removeAbleLoopTasks();
//			else	removeAbleNonLoopTasks();
			for(var i:int=0;i<len;i++){
				if(!containsAbleTask(TaskInf(data.taskList[i]).taskId)){
					taskDyVo=new TaskDyVo();
					taskDyVo.taskListType=TaskDyVo.AbleList;
					taskDyVo.taskID=TaskInf(data.taskList[i]).taskId;
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					if(!taskBasicVo)
						print(this,"任务id:"+taskDyVo.taskID+"没有对应的数据！");
					else if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK) 
						mainChange=true;
					
					if(TaskInf(data.taskList[i]).hasLoopId){
						taskDyVo.loopId=TaskInf(data.taskList[i]).loopId;
						taskDyVo.remainTimes = TaskInf(data.taskList[i]).remainTime;
					}
					if(TaskInf(data.taskList[i]).hasRunId){
						taskDyVo.run_rings_id=TaskInf(data.taskList[i]).runId;
						taskDyVo.run_remain = TaskInf(data.taskList[i]).runLimit;
					}

					_ableTaskList.push(taskDyVo);
				}
			}
			_ableTaskList.sort(nowSortFun);
			return mainChange;
//			_ableTaskList.sort(
//			TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID).task_type
		}
		private function containsAbleTask(taskId:int):Boolean{
			var len:int=_ableTaskList.length;
			for(var i:int=0;i<len;i++){
				if(_ableTaskList[i].taskID==taskId)	return true;
			}
			return false;
		}
		
		/**移除全部循环任务
		 */		
		public function removeAbleLoopTasks():void{
			for(var i:int=0;i<_ableTaskList.length;i++){
				if(_ableTaskList[i].loopId!=-1){
					_ableTaskList.splice(i,1);
					i--;
				}
			}
		}
		
		/**移除全部主线和支线任务
		 */		
		public function removeAbleNonLoopTasks():void{
			for(var i:int=0;i<_ableTaskList.length;i++){
				if(_ableTaskList[i].loopId==-1){
					_ableTaskList.splice(i,1);
					i--;
				}
			}
		}
		
		/**更新当前任务列表
		 * 如果有主线的变更则返回true 否则为false
		 * @param data
		 */		
		public function updateCrtTaskList(msg:SCurrentTaskList):Boolean{
			var len:int=msg.taskList.length;
			var taskDyVo:TaskDyVo;
			var tempTaskDyVo:TaskDyVo;
			var taskBasicVo:TaskBasicVo;
			var isMainChange:Boolean=false;//是否主线发生变更
			for(var i:int=0;i<len;i++){
				tempTaskDyVo=removeCrtTask(CurrentTaskInf(msg.taskList[i]).taskId);
				taskDyVo=new TaskDyVo();
				taskDyVo.taskListType=TaskDyVo.CurrentList;
				if(tempTaskDyVo)taskDyVo.isSubmit=tempTaskDyVo.isSubmit;
				taskDyVo.taskID=CurrentTaskInf(msg.taskList[i]).taskId;
				taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
				if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK)isMainChange=true;
				var taskTagDyVo:TaskTagDyVo;
				var len2:int=CurrentTaskInf(msg.taskList[i]).tagList.length;
				var finishTags:int=0;
				for(var j:int=0;j<len2;j++){
					taskTagDyVo=new TaskTagDyVo();
					taskTagDyVo.curNum=TaskTagInf(CurrentTaskInf(msg.taskList[i]).tagList[j]).curNum;
					taskTagDyVo.tagID=TaskTagInf(CurrentTaskInf(msg.taskList[i]).tagList[j]).tagId;
					taskTagDyVo.tagType=TaskTagInf(CurrentTaskInf(msg.taskList[i]).tagList[j]).tagType;
					taskTagDyVo.totalNum=TaskTagInf(CurrentTaskInf(msg.taskList[i]).tagList[j]).totalNum;
					if(taskTagDyVo.isFinish)	finishTags++;
					taskDyVo.tagList.push(taskTagDyVo);
					if(TaskTagInf(CurrentTaskInf(msg.taskList[i]).tagList[j]).tagType==TypeProps.TaskTargetType_NPCSimpleDialog)taskDyVo.isFinish=true;
				}
				if(finishTags==taskDyVo.tagList.length)	taskDyVo.isFinish=true;
				if(CurrentTaskInf(msg.taskList[i]).hasLoopInf){
					taskDyVo.loopId=CurrentTaskInf(msg.taskList[i]).loopInf.loopId;
					taskDyVo.curProgress=CurrentTaskInf(msg.taskList[i]).loopInf.curProgress;
					taskDyVo.remainTimes=CurrentTaskInf(msg.taskList[i]).loopInf.remainTimes;
				}
				if(CurrentTaskInf(msg.taskList[i]).hasRunInf){ //跑环任务的相关信息
					taskDyVo.run_rings_id=CurrentTaskInf(msg.taskList[i]).runInf.runId;
					taskDyVo.run_Progress=CurrentTaskInf(msg.taskList[i]).runInf.curProgress;
					taskDyVo.run_remain=CurrentTaskInf(msg.taskList[i]).runInf.remainTimes;
				}
				_nowTaskList.push(taskDyVo);
				if(taskDyVo.loopId!=-1 && taskDyVo.curProgress==1){
					var loopVo:Task_loopBasicVo=Task_loopBasicManager.Instance.getTask_loopBasicVo(taskDyVo.loopId);
					if(loopVo)	_cdTimes["t"+loopVo.cd_type]=getTimer();
				}
			}
			_nowTaskList.sort(nowSortFun);
			return isMainChange;
		}
		
		/**任务模型排序，主>支>循, 同类按照id排序
		 * @param a	TaskDyVo
		 * @param b	TaskDyVo
		 * @return 
		 */		
		private function nowSortFun(a:TaskDyVo,b:TaskDyVo):Number{
			var abvo:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(a.taskID);
			var bbvo:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(b.taskID);
			if(abvo.task_type > bbvo.task_type)	return 1;
			else if(abvo.task_type < bbvo.task_type)	return -1;
			else{
				if(abvo.task_id > bbvo.task_id)	return 1;
				else	return -1;
			}
		}
		/**主线任务数组   当主线 为2  个时 说明提交的任务还没有返回 这个时候不应该触发新手引导
		 */		
		public function getMainTrunkVoArr():Vector.<TaskDyVo>
		{
			var num:int=0;
			var taskDyVo:TaskDyVo;
			var taskBasicVo:TaskBasicVo;
			var arr:Vector.<TaskDyVo>=new Vector.<TaskDyVo>();
			for each(taskDyVo in _nowTaskList)
			{
				if(!taskDyVo.isSubmit)
				{
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK)
					{
						arr.push(taskDyVo);
					}
				}
			}
			for each(taskDyVo in _ableTaskList)
			{
				if(!taskDyVo.isSubmit)
				{
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK)
					{
						arr.push(taskDyVo);
					}
				}
			}
			return arr;
		}
		
		
		/**获取主线的当前任务
		 */		
		public function getMainTrunkCurrentTaskVo():TaskDyVo
		{
			var taskDyVo:TaskDyVo=null;
			var taskBasicVo:TaskBasicVo;
			for each(taskDyVo in _nowTaskList)
			{
				if(!taskDyVo.isSubmit)
				{
					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK)
					{
						return taskDyVo;
					}
				}
			}
			return null;
		}
		
		public function getMainTrunkAbleListTaskVo():TaskDyVo
		{
			var taskDyVo:TaskDyVo=null;
			var taskBasicVo:TaskBasicVo;
			for each(taskDyVo in _ableTaskList)
			{
				taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
				if(taskBasicVo.task_type==TypeTask.TASK_TYPE_TRUNK)
				{
					return taskDyVo;
				}
			}
			return null;
		}
		
		/**获取主线的当前任务 的任务目标
		 */
		public function getMainTrunkCurrentTaskTargetBasicVo():Task_targetBasicVo
		{
			var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskVo();
			if(taskDyVo)
			{
				if(taskDyVo.tagList.length==1)
				{
					var taskBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
					var taskTagVo:TaskTagDyVo=taskDyVo.tagList[0];
					var taskTagetBasicVo:Task_targetBasicVo=Task_targetBasicManager.Instance.getTask_targetBasicVo(taskBasicVo.task_tag_id,taskTagVo.tagType,taskTagVo.tagID);
					return taskTagetBasicVo;
				}
			}
			return null;
		}
		
		/**是否具有采集采集物id为 basic_id的采集任务  
		 * 当前任务 是否具有采集任务 
		 * 没有接受采集任务的不能进行采集
		 */
		public function hasGatherTask(basic_id:int):Boolean
		{
			var taskDyVo:TaskDyVo=null;
			var len:int;
			var taskTargetBasicVo:Task_targetBasicVo;
			var taskTagDyVo:TaskTagDyVo;
			var taskBasicVo:TaskBasicVo;
			for each(taskDyVo in _nowTaskList)
			{
				if(!taskDyVo.isSubmit)
				{
					if(!taskDyVo.isFinish)  //采集任务没有完成
					{
						taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(taskDyVo.taskID);
						len=taskDyVo.tagList.length;
						for(var i:int=0;i!=len;++i)
						{
							taskTagDyVo=taskDyVo.tagList[i];
							taskTargetBasicVo=Task_targetBasicManager.Instance.getTask_targetBasicVo(taskBasicVo.task_tag_id,taskTagDyVo.tagType,taskTagDyVo.tagID);
							if(taskTargetBasicVo.seach_type==TypeProps.TaskTargetType_Gather&&taskTargetBasicVo.tag_id==basic_id)  //采集类型
							{
								return true; 
							}
						}
					}
				}
			}
			return false;
		}
		
		
		
		
		/**是否 具有 任务
		 */
//		public function hasTask():Boolean
//		{
//			var nowListlen:int=_nowTaskList.length;
//			var ableListLen:int=_ableTaskList.length;
//			if(nowListlen>0||ableListLen>0)
//			{
//				return true;
//			}
//			return false;
//		}
		
	}
}