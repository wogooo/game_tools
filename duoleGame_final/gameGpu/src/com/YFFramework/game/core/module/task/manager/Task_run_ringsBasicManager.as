package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_run_ringsBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_run_ringsBasicManager
	{
		private static var _instance:Task_run_ringsBasicManager;
		private var _dict:Dictionary;
		public function Task_run_ringsBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Task_run_ringsBasicManager
		{
			if(_instance==null)_instance=new Task_run_ringsBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_run_ringsBasicVo:Task_run_ringsBasicVo;
			for (var id:String in jsonData)
			{
				task_run_ringsBasicVo=new Task_run_ringsBasicVo();
				task_run_ringsBasicVo.run_limit=jsonData[id].run_limit;
				task_run_ringsBasicVo.run_rings_id=jsonData[id].run_rings_id;
				_dict[task_run_ringsBasicVo.run_rings_id]=task_run_ringsBasicVo;
			}
		}
		public function getTask_run_ringsBasicVo(run_rings_id:int):Task_run_ringsBasicVo
		{
			return _dict[run_rings_id];
		}
	}
}