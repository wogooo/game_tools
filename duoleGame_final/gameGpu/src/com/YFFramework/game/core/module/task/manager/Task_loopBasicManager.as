package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_loopBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_loopBasicManager
	{
		private static var _instance:Task_loopBasicManager;
		private var _dict:Dictionary;
		public function Task_loopBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Task_loopBasicManager
		{
			if(_instance==null)_instance=new Task_loopBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_loopBasicVo:Task_loopBasicVo;
			for (var id:String in jsonData)
			{
				task_loopBasicVo=new Task_loopBasicVo();
				task_loopBasicVo.need_script=jsonData[id].need_script;
				task_loopBasicVo.highest_lv=jsonData[id].highest_lv;
				task_loopBasicVo.start_task_id=jsonData[id].start_task_id;
				task_loopBasicVo.time_id=jsonData[id].time_id;
				task_loopBasicVo.cd_type=jsonData[id].cd_type;
				task_loopBasicVo.reward_script=jsonData[id].reward_script;
				task_loopBasicVo.accept_limit=jsonData[id].accept_limit;
				task_loopBasicVo.task_lib_id=jsonData[id].task_lib_id;
				task_loopBasicVo.loop_id=jsonData[id].loop_id;
				task_loopBasicVo.cd_time=jsonData[id].cd_time;
				task_loopBasicVo.lowest_lv=jsonData[id].lowest_lv;
				task_loopBasicVo.total_times=jsonData[id].total_times;
				task_loopBasicVo.show_accept=jsonData[id].show_accept;
				_dict[task_loopBasicVo.loop_id]=task_loopBasicVo;
			}
		}
		public function getTask_loopBasicVo(loop_id:int):Task_loopBasicVo
		{
			return _dict[loop_id];
		}
		
		/**返回全部循环任务
		 * @return 
		 */	
		public function getAllLoopVo():Array{
			var arr:Array = new Array();
			for each (var bvo:Task_loopBasicVo in _dict){
				arr.push(bvo);
			}
			return arr;
		}
	}
}