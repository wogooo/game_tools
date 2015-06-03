package com.YFFramework.game.core.module.task.manager
{
	import com.YFFramework.game.core.module.task.model.Task_libBasicVo;
	
	import flash.utils.Dictionary;

	public class Task_libBasicManager
	{
		private static var _instance:Task_libBasicManager;
		private var _dict:Dictionary;
		public function Task_libBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Task_libBasicManager
		{
			if(_instance==null)_instance=new Task_libBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var task_libBasicVo:Task_libBasicVo;
			var key:String;
			for (var id:String in jsonData)
			{
				task_libBasicVo=new Task_libBasicVo();
				task_libBasicVo.lib_id=jsonData[id].lib_id;
				task_libBasicVo.task_id=jsonData[id].task_id;
				task_libBasicVo.weights=jsonData[id].weights;
				key=getSingleKey(task_libBasicVo.lib_id,task_libBasicVo.task_id);
				_dict[key]=task_libBasicVo;
			}
		}
		public function getTask_libBasicVo(lib_id:int,task_id:int):Task_libBasicVo
		{
			return _dict[getSingleKey(lib_id,task_id)];
		}
		
		/**根据loopId找到第一个task_libBasicVo
		 * @param loopId
		 * @return 
		 */		
		public function getTask_libBasicVoByLoopId(loopId:int):Task_libBasicVo{
			for each(var bvo:Task_libBasicVo in _dict){
				if(bvo.lib_id==loopId){
					return bvo;
				}
			}
			return null;
		}
		
		private function getSingleKey(lib_id:int,task_id:int):String
		{
			return lib_id+"_"+task_id;
		}
	}
}