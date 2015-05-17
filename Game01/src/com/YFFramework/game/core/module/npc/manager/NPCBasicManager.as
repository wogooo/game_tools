package com.YFFramework.game.core.module.npc.manager
{
	import flash.utils.Dictionary;
	import com.YFFramework.game.core.module.npc.model.NPCBasicVo;

	/**2012-10-24 下午12:52:47
	 *@author yefeng
	 */
	public class NPCBasicManager
	{
		private static var _instance:NPCBasicManager;
		private var _dict:Dictionary;
		public function NPCBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():NPCBasicManager
		{
			if(_instance==null) _instance=new NPCBasicManager();
			return _instance;				
		}
		/**缓存数据
		 */			
		public function cacheData(obj:Object):void
		{
			var npcBasicVo:NPCBasicVo;
			for (var id:String in obj)
			{
				npcBasicVo=new NPCBasicVo();
				npcBasicVo.id=int(id);
				npcBasicVo.name=obj[id].name;
				npcBasicVo.words=obj[id].words;
				npcBasicVo.wordsInterval=obj[id].wordsInterval;
				npcBasicVo.defaultWord=obj[id].defaultWord;
				_dict[npcBasicVo.id]=npcBasicVo;
			}
		}
		/** 获取 npc 静态量
		 * id 为npc id
		 */		
		public function getNPCBasicVo(id:int):NPCBasicVo
		{
			return _dict[id];
		}
			
	}
}