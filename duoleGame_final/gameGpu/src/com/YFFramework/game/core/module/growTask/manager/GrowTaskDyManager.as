package com.YFFramework.game.core.module.growTask.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.growTask.model.GrowTaskDyVo;
	import com.YFFramework.game.core.module.growTask.source.GrowTaskSource;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-15 下午4:56:07
	 */
	public class GrowTaskDyManager{
		
		private static var instance:GrowTaskDyManager;
		/**养成任务列表
		 */		
		private var _growTaskList:HashMap = new HashMap();
		/**养成任务类型列表
		 */		
		private var _growTaskType:Array = new Array();
		
		public function GrowTaskDyManager(){
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var vo:GrowTaskDyVo = new GrowTaskDyVo();
				vo.rewardId = jsonData[id].reward_id;
				vo.targetId = jsonData[id].target_id;
				vo.targetLevel = jsonData[id].target_level;
				vo.targetNumber = jsonData[id].target_number;
				vo.targetQuality = jsonData[id].target_quality;
				vo.targetType = jsonData[id].target_type;
				vo.taskDesc = jsonData[id].task_desc;
				vo.taskId = jsonData[id].task_id;
				vo.iconId = jsonData[id].icon_id;
			
				_growTaskList.put(vo.taskId,vo);
			}
		}
		
		/**获取GrowTaskVo
		 * @param taskId	任务ID
		 * @return 
		 */		
		public function getGrowTaskVo(taskId:int):GrowTaskDyVo{
			return _growTaskList.get(taskId);
		}
		
		/**删除任务，针对已领奖任务
		 * @param taskId
		 */		
		public function removeTask(taskId:int):void{
			_growTaskList.remove(taskId);
		}
		
		/**完成任务，把任务状态更新，如果这类任务全部完成，更新类型列表
		 * @param taskId
		 */		
		public function finishTask(taskId:int):void{
			var vo:GrowTaskDyVo = _growTaskList.get(taskId);
			vo.status = GrowTaskSource.GROW_TASK_FINISHED;
			if(getTaskListArrayByType(vo.targetType).length==0){
				var len:int = _growTaskType.length;
				for(var i:int=0;i<len;i++){
					if(_growTaskType[i]==vo.targetType){
						_growTaskType.splice(i,1);
						break;
					}
				}
			}
		}
		
		/**更新任务列表状态
		 * @param arr	Array:已完成和已领奖的任务列表
		 */		
		public function updateStatus(arr:Array):void{
			var len:int=arr.length;
			for(var i:int=0;i<len;i++){
				if(arr[i].status==GrowTaskSource.GROW_TASK_REWARDED)	_growTaskList.remove(arr[i].taskId);
				else	GrowTaskDyVo(_growTaskList.get(arr[i].taskId)).status = arr[i].status;
			}
		}
		
		/**
		 *是否有已完成（但未领取的成长任务） 
		 * @return 
		 */		
		public function hasFinishGrowTask():Boolean
		{
			var growTasks:Array=_growTaskList.values();
			var i:int,len:int=growTasks.length;
			for(i=0;i<len;i++)
			{
				var growTaskVo:GrowTaskDyVo=growTasks[i];
				if(growTaskVo.status==GrowTaskSource.GROW_TASK_FINISHED)
					return true;
			}
			return false;
		}
		
		/**初始化任务类型列表
		 */		
		public function initTaskTypeArray():void{
			var arr:Array = _growTaskList.values();
			var len:int = arr.length;
			for(var i:int = 0;i<len;i++){
				if(arr[i].status==GrowTaskSource.GROW_TASK_UNFINISH && !containsTaskType(arr[i].targetType)){
					_growTaskType.push(arr[i].targetType);
				}
			}
		}
		
		/**获取任务类型列表
		 * @return 
		 */		
		public function getTaskTypeArr():Array{
			return _growTaskType;
		}
		
		/**获取任务列表
		 * @return 
		 */		
		public function getTaskListArray():Array{
			return _growTaskList.values().sortOn(["status","taskId"],[Array.DESCENDING | Array.NUMERIC,Array.NUMERIC]);
		}
		
		/**根据类型获取任务列表
		 * @param typeId
		 * @return 
		 */		
		public function getTaskListArrayByType(typeId:int):Array{
			var arr:Array = new Array();
			var myList:Array = _growTaskList.values();
			var len:int = myList.length;
			for(var i:int=0;i<len;i++){
				if(myList[i].targetType == typeId && myList[i].status == GrowTaskSource.GROW_TASK_UNFINISH)	arr.push(myList[i]);
			}
			return arr.sortOn("taskId",Array.NUMERIC);
		}
		
		/**是否含有任务类型
		 * @param typeId
		 * @return 
		 */		
		public function containsTaskType(typeId:int):Boolean{
			var len:int = _growTaskType.length;
			for(var i:int=0;i<len;i++){
				if(_growTaskType[i]==typeId)	return true;
			}
			return false;
		}
		
		public static function get Instance():GrowTaskDyManager{
			return instance ||= new GrowTaskDyManager();
		}
		
	}
} 