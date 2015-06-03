package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_dialogBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.core.module.task.model.TypeTask;
	
	import flash.utils.Dictionary;

	public class TaskBasicManager
	{
		private static var _instance:TaskBasicManager;
		private var _dict:Dictionary;
		public function TaskBasicManager()
		{
			_dict=new Dictionary();
		}

		public function get dict():Dictionary
		{
			return _dict;
		}

		public static function get Instance():TaskBasicManager
		{
			if(_instance==null)_instance=new TaskBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var taskBasicVo:TaskBasicVo;
			for (var id:String in jsonData)
			{
				taskBasicVo=new TaskBasicVo();
				taskBasicVo.task_type=jsonData[id].task_type;
				taskBasicVo.pre_task=jsonData[id].pre_task;
				taskBasicVo.task_reward_id=jsonData[id].task_reward_id;
				taskBasicVo.reward_script=jsonData[id].reward_script;
				taskBasicVo.complete_dialog=jsonData[id].complete_dialog;
				taskBasicVo.description=jsonData[id].description;
				taskBasicVo.accept_dialog=jsonData[id].accept_dialog;
				taskBasicVo.recv_npc_id=jsonData[id].recv_npc_id;
				taskBasicVo.highest_lv=jsonData[id].highest_lv;
				taskBasicVo.submit_desc=jsonData[id].submit_desc;
				taskBasicVo.lowest_lv=jsonData[id].lowest_lv;
				taskBasicVo.sub_npc_id=jsonData[id].sub_npc_id;
				taskBasicVo.accept_desc=jsonData[id].accept_desc;
				taskBasicVo.task_id=jsonData[id].task_id;
				taskBasicVo.recv_need_script=jsonData[id].recv_need_script;
				taskBasicVo.undone_dialog=jsonData[id].undone_dialog;
				taskBasicVo.task_tag_id=jsonData[id].task_tag_id;
				taskBasicVo.sub_need_script=jsonData[id].sub_need_script;
				taskBasicVo.quality=jsonData[id].quality;
				taskBasicVo.can_give_up=jsonData[id].can_give_up;
				taskBasicVo.name=jsonData[id].name;
				taskBasicVo.moneyStar=jsonData[id].money_star;
				taskBasicVo.propsStar=jsonData[id].props_star;
				taskBasicVo.expStar=jsonData[id].exp_star;
				taskBasicVo.rev_story_id=jsonData[id].rev_story_id;
				taskBasicVo.sub_story_id=jsonData[id].sub_story_id;
				taskBasicVo.reach_story_id=jsonData[id].reach_story_id;
				_dict[taskBasicVo.task_id]=taskBasicVo;
			}
		}
		
		/**添加任务目标数据(task target data)
		 * @param jsonData
		 */		
//		public function addTargetData(jsonData:Object):void{
//			var taskTargetVo:Task_targetBasicVo;
//			for(var id:String in jsonData){
//				taskTargetVo.tag_id=jsonData[id].tag_id;
//				taskTargetVo.tag_num=jsonData[id].tag_num;
//				taskTargetVo.tag_type=jsonData[id].tag_type;
//				taskTargetVo.desc=jsonData[id].desc;
//				taskTargetVo.task_tag_id=jsonData[id].task_tag_id;
//				TaskBasicVo(_dict[taskTargetVo.task_tag_id]).targetArr.push(taskTargetVo);
//			}	
//		}
		
		public function getTaskBasicVo(task_id:int):TaskBasicVo
		{
			return _dict[task_id];
		}
		
		/**通过loopId找到TaskBasicVo
		 * @param loopId
		 * @return 
		 */		
//		public function getTaskBasicVoByLoopId(loopId:int):TaskBasicVo{
//			for each (var bvo:TaskBasicVo in _dict){
//				if(bvo.loopID==loopId){
//					return bvo;
//				}
//			}
//			return null;
//		}
		
	}
}