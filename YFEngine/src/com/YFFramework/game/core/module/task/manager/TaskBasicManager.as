package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskStepBasicVo;
	
	import flash.utils.Dictionary;

	public class TaskBasicManager
	{
		private static var _instance:TaskBasicManager;
		private var _dict:Dictionary;
		public function TaskBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():TaskBasicManager
		{
			if(_instance==null) _instance=new TaskBasicManager();
			return _instance;
		}
		
		public function cacheData(obj:Object):void
		{
			var id:int;
			var taskBasicVo:TaskBasicVo;
			var taskStepBasicVo:TaskStepBasicVo;
			 for(var idStr:String in obj)
			 {
				 taskBasicVo=new TaskBasicVo();
				 taskBasicVo.taskName=obj.taskName;
				 taskBasicVo.taskId=obj.taskId;
				 taskBasicVo.type=obj.type;
				 taskBasicVo.preTaskId=obj.preTaskId;
				 taskBasicVo.maxLevel=obj.maxLevel;
				 taskBasicVo.minLevel=obj.minLevel;
				 taskBasicVo.gold=obj.gold;
				 taskBasicVo.exp=obj.exp;
				 taskBasicVo.totalStep=obj.totalStep;
				 taskBasicVo.goodsIdArr=obj.goodsIdArr;
				 taskBasicVo.stepArr=new Vector.<TaskStepBasicVo>();
				 ///各个步骤
				 taskStepBasicVo=fillStepData(obj["1"]);
				 taskBasicVo.stepArr.push(taskStepBasicVo);
				 if(obj["2"])
				 {
					 taskStepBasicVo=fillStepData(obj["2"]);
					 taskBasicVo.stepArr.push(taskStepBasicVo);
				 }
				 if(obj["3"])
				 {
					 taskStepBasicVo=fillStepData(obj["3"]);
					 taskBasicVo.stepArr.push(taskStepBasicVo);
				 }
				 
			 }
		}
		private function fillStepData(obj:Object):TaskStepBasicVo
		{
			var taskStepBasicVo:TaskStepBasicVo=new TaskStepBasicVo();
			taskStepBasicVo.stepId=obj.stepId;
			taskStepBasicVo.stepType=obj.stepType;
			taskStepBasicVo.state=obj.state;
			taskStepBasicVo.playTalk=obj.playTalk;
			taskStepBasicVo.npcTalk=obj.npcTalk;
			taskStepBasicVo.relativeX=obj.relativeX;
			taskStepBasicVo.relativeY=obj.relativeY;
			taskStepBasicVo.relativeId=obj.relativeId;
			taskStepBasicVo.guide0=obj.guide0;
			taskStepBasicVo.guide1=obj.guide1;
			taskStepBasicVo.guide2=obj.guide2;
			taskStepBasicVo.guide3=obj.guide3;
			return taskStepBasicVo;
		}
		
		
		
		
	}
}