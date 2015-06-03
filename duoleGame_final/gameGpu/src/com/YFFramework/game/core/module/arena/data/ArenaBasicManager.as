package com.YFFramework.game.core.module.arena.data
{
	import flash.utils.Dictionary;

	public class ArenaBasicManager
	{
		private static var _instance:ArenaBasicManager;
		private var _dict:Dictionary;
		public function ArenaBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():ArenaBasicManager
		{
			if(_instance==null)_instance=new ArenaBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var arenaBasicVo:ArenaBasicVo;
			for (var id:String in jsonData)
			{
				arenaBasicVo=new ArenaBasicVo();
				arenaBasicVo.revive_money=jsonData[id].revive_money;
				arenaBasicVo.activity_id=jsonData[id].activity_id;
				arenaBasicVo.arena_id=jsonData[id].arena_id;
				arenaBasicVo.exit_scene_id=jsonData[id].exit_scene_id;
				arenaBasicVo.is_back=jsonData[id].is_back;
				_dict[arenaBasicVo.arena_id]=arenaBasicVo;
			}
		}
		public function getArenaBasicVo(arena_id:int):ArenaBasicVo
		{
			return _dict[arena_id];
		}
	}
}