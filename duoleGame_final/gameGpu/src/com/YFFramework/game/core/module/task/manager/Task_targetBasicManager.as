package com.YFFramework.game.core.module.task.manager
{ 
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_targetBasicManager{
		
		private static var _instance:Task_targetBasicManager;
		private var _dict:Dictionary;
		
		public function Task_targetBasicManager(){
			_dict=new Dictionary();
		}
		
		public static function get Instance():Task_targetBasicManager{
			return _instance ||= new Task_targetBasicManager();
		}
		
		public  function cacheData(jsonData:Object):void{
			var task_targetBasicVo:Task_targetBasicVo;
			var key:String;
			for (var id:String in jsonData){
				task_targetBasicVo=new Task_targetBasicVo();
				task_targetBasicVo.tag_id=jsonData[id].tag_id;
				task_targetBasicVo.tag_num=jsonData[id].tag_num;
				task_targetBasicVo.tag_type=jsonData[id].tag_type;
				task_targetBasicVo.desc=jsonData[id].desc;
				task_targetBasicVo.task_tag_id=jsonData[id].task_tag_id;
				task_targetBasicVo.seach_type=jsonData[id].seach_type;
				task_targetBasicVo.seach_id=jsonData[id].seach_id;
				key=getSingleKey(task_targetBasicVo.task_tag_id,task_targetBasicVo.tag_type,task_targetBasicVo.tag_id);
				_dict[key]=task_targetBasicVo;
			}
		}
		
		/**
		 * @param npcID  npc 动态id 
		 * 获取 对话的数据 vo 
		 */		
		public function findTaskDialogTargetVO(npcID:int,tag_id:int,task_tag_id:int):Task_targetBasicVo
		{
			var npcPositionBasicVo:Npc_PositionBasicVo = Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcID);
			var taskTagetBasicVo:Task_targetBasicVo;
			for(var obj:Object in _dict){
				taskTagetBasicVo = _dict[obj];
				if(taskTagetBasicVo.tag_id == tag_id && taskTagetBasicVo.tag_type == TypeProps.TaskTargetType_NPCDialog&& taskTagetBasicVo.tag_id == npcPositionBasicVo.basic_id&&task_tag_id==taskTagetBasicVo.task_tag_id){
					return taskTagetBasicVo;
				}
			}
			return null;
		}
		
		public function getTask_targetBasicVo(task_tag_id:int,tag_type:int,tag_id:int):Task_targetBasicVo{
			return _dict[getSingleKey(task_tag_id,tag_type,tag_id)];
		}
		
		private function getSingleKey(task_tag_id:int,tag_type:int,tag_id:int):String{
			return task_tag_id+"_"+tag_type+"_"+tag_id;
		}
	}
}