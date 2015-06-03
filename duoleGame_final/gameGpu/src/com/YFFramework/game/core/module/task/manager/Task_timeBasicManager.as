package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_timeBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_timeBasicManager
	{
		private static var _instance:Task_timeBasicManager;
		private var _dict:Dictionary;
		public function Task_timeBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Task_timeBasicManager
		{
			if(_instance==null)_instance=new Task_timeBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_timeBasicVo:Task_timeBasicVo;
			for (var id:String in jsonData)
			{
				task_timeBasicVo=new Task_timeBasicVo();
				task_timeBasicVo.beg_time=jsonData[id].beg_time;
				task_timeBasicVo.end_time=jsonData[id].end_time;
				task_timeBasicVo.time_id=jsonData[id].time_id;
				task_timeBasicVo.is_loop=jsonData[id].is_loop;
				_dict[task_timeBasicVo.time_id]=task_timeBasicVo;
			}
		}
		public function getTask_timeBasicVo(time_id:int):Task_timeBasicVo
		{
			return _dict[time_id];
		}
	}
}