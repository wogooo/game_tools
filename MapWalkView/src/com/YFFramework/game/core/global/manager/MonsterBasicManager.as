package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	
	import flash.utils.Dictionary;

	public class MonsterBasicManager
	{
		private static var _instance:MonsterBasicManager;
		private var _dict:Dictionary;
		public function MonsterBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():MonsterBasicManager
		{
			if(_instance==null)_instance=new MonsterBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var monsterBasicVo:MonsterBasicVo;
			for (var id:String in jsonData)
			{
				monsterBasicVo=new MonsterBasicVo();
//				monsterBasicVo.warn_range=jsonData[id].warn_range
				monsterBasicVo.name=jsonData[id].name
//				monsterBasicVo.path=jsonData[id].path
//				monsterBasicVo.ai_type=jsonData[id].ai_type
				monsterBasicVo.bubble3=jsonData[id].bubble3
				monsterBasicVo.bubble1=jsonData[id].bubble1
//				monsterBasicVo.fight_id=jsonData[id].fight_id
//				monsterBasicVo.reward_id=jsonData[id].reward_id
//				monsterBasicVo.monster_type=jsonData[id].monster_type
				monsterBasicVo.model_id=jsonData[id].model_id
				monsterBasicVo.unit_id=jsonData[id].unit_id
//				monsterBasicVo.direction=jsonData[id].direction
				monsterBasicVo.wordsInterval=jsonData[id].wordsInterval
//				monsterBasicVo.camp=jsonData[id].camp
				monsterBasicVo.move_speed=jsonData[id].move_speed
				monsterBasicVo.level=jsonData[id].level 
//				monsterBasicVo.chase_range=jsonData[id].chase_range
				monsterBasicVo.dialog=jsonData[id].dialog
//				monsterBasicVo.map_show=jsonData[id].map_show
//				monsterBasicVo.reward_exp=jsonData[id].reward_exp
				monsterBasicVo.bubble2=jsonData[id].bubble2
				monsterBasicVo.icon_id=jsonData[id].icon_id;
				_dict[monsterBasicVo.unit_id]=monsterBasicVo;
			}
		}
		public function getMonsterBasicVo(unit_id:int):MonsterBasicVo
		{
			return _dict[unit_id];
		}
		/**  怪物 大图像  人物主界面 大图像
		 */		
		public function getShowURL(basicId:int):String
		{
			var monsterBasicVo:MonsterBasicVo=getMonsterBasicVo(basicId);
			var url:String=URLTool.getMonsterIcon(monsterBasicVo.icon_id);
			return url;
		}
		
		
	}
}