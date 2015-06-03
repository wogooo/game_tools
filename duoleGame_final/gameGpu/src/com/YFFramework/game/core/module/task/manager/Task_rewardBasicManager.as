package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_rewardBasicManager
	{
		private static var _instance:Task_rewardBasicManager;
		private var _dict:Dictionary;
		/**任务奖励数组
		 */		
		private var _rewardIdArr:Dictionary;
		public function Task_rewardBasicManager()
		{
			_dict=new Dictionary();
			_rewardIdArr=new Dictionary();
		}
		public static function get Instance():Task_rewardBasicManager
		{
			if(_instance==null)_instance=new Task_rewardBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_rewardBasicVo:Task_rewardBasicVo;
			var key:String;
			for (var id:String in jsonData)
			{
				task_rewardBasicVo=new Task_rewardBasicVo();
				task_rewardBasicVo.rw_type=jsonData[id].rw_type;
				task_rewardBasicVo.rw_num=jsonData[id].rw_num;
				task_rewardBasicVo.rw_id=jsonData[id].rw_id;
				task_rewardBasicVo.task_reward_id=jsonData[id].task_reward_id;
				key=getSingleKey(task_rewardBasicVo.task_reward_id,task_rewardBasicVo.rw_type);
				_dict[key]=task_rewardBasicVo;
				if(!_rewardIdArr[task_rewardBasicVo.task_reward_id]) _rewardIdArr[task_rewardBasicVo.task_reward_id]=new Vector.<Task_rewardBasicVo>();
				_rewardIdArr[task_rewardBasicVo.task_reward_id].push(task_rewardBasicVo);
			}
		}
		
		public function getTaskRewards(task_rewardId:int):Vector.<Task_rewardBasicVo>
		{
//			var vct:Vector.<Task_rewardBasicVo> = new Vector.<Task_rewardBasicVo>();
//			var vo:Task_rewardBasicVo;
//			for(var obj:Object in _dict){
//				vo = _dict[obj];
//				if(vo.task_reward_id == taskID){
//					vct.push(vo);
//				}
//			}
//			return vct;
			return _rewardIdArr[task_rewardId];
		}
		
		public function getTask_rewardBasicVo(task_id:int,rw_type:int):Task_rewardBasicVo
		{
			return _dict[getSingleKey(task_id,rw_type)];
		}
		private function getSingleKey(task_id:int,rw_type:int):String
		{
			return task_id+"_"+rw_type;
		}
	}
}