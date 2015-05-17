package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	
	import flash.utils.Dictionary;

	/**@author yefeng
	 *2012-8-28下午10:35:55
	 */
	public class MonsterBasicManager
	{
		private static var _dict:Dictionary;
		
		private static var _instance:MonsterBasicManager;
		public function MonsterBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function  get Instance():MonsterBasicManager
		{
			if(_instance==null) _instance=new MonsterBasicManager();
			return _instance;
		}
		public function cacheData(jsonData:Object):void
		{
			var monsterBasicVo:MonsterBasicVo;
			for  (var id:String  in jsonData)
			{
				monsterBasicVo=new MonsterBasicVo();
				monsterBasicVo.basicId=int(id);
				monsterBasicVo.name=jsonData[id].name;
				monsterBasicVo.resId=jsonData[id].resId;
				monsterBasicVo.speed=jsonData[id].speed;
				monsterBasicVo.words=jsonData[id].words;
				monsterBasicVo.wordsInterval=jsonData[id].wordsInterval;
				_dict[monsterBasicVo.basicId]=monsterBasicVo;
			}
		}
		
		public function getMonsterBasicVo(basicId:int):MonsterBasicVo
		{
			return _dict[basicId];
		}
		
		
	}
}