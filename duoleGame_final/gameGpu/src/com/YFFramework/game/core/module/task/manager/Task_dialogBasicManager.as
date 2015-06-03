package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_dialogBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_dialogBasicManager
	{
		private static var _instance:Task_dialogBasicManager;
		private var _dict:Dictionary;
		public function Task_dialogBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Task_dialogBasicManager
		{
			if(_instance==null)_instance=new Task_dialogBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_dialogBasicVo:Task_dialogBasicVo;
			for (var id:String in jsonData)
			{
				task_dialogBasicVo=new Task_dialogBasicVo();
				task_dialogBasicVo.dialog=jsonData[id].dialog;
				task_dialogBasicVo.id=jsonData[id].id;
				_dict[task_dialogBasicVo.id]=task_dialogBasicVo;
			}
		}
		public function getTask_dialogBasicVo(id:int):Task_dialogBasicVo
		{
			return _dict[id];
		}
	}
}