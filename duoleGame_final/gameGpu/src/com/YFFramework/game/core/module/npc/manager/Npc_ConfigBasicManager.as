package com.YFFramework.game.core.module.npc.manager
{
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.utils.Dictionary;

	/**缓存 Npc_Config 数据表
	 */
	public class Npc_ConfigBasicManager
	{
		private static var _instance:Npc_ConfigBasicManager;
		private var _dict:Dictionary;
		public function Npc_ConfigBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Npc_ConfigBasicManager
		{
			if(_instance==null)_instance=new Npc_ConfigBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var npc_ConfigBasicVo:Npc_ConfigBasicVo;
			for (var id:String in jsonData)
			{
				npc_ConfigBasicVo=new Npc_ConfigBasicVo();
				npc_ConfigBasicVo.func_id3=jsonData[id].func_id3;
				npc_ConfigBasicVo.func_type3=jsonData[id].func_type3;
				npc_ConfigBasicVo.basic_id=jsonData[id].basic_id;
				npc_ConfigBasicVo.icon_id=jsonData[id].icon_id;
				npc_ConfigBasicVo.func_desc2=jsonData[id].func_desc2;
				npc_ConfigBasicVo.func_id1=jsonData[id].func_id1;
				npc_ConfigBasicVo.model_id=jsonData[id].model_id;
				npc_ConfigBasicVo.func_type2=jsonData[id].func_type2;
				npc_ConfigBasicVo.func_type1=jsonData[id].func_type1;
				npc_ConfigBasicVo.func_desc3=jsonData[id].func_desc3;
				npc_ConfigBasicVo.name=jsonData[id].name;
				npc_ConfigBasicVo.func_id2=jsonData[id].func_id2;
				npc_ConfigBasicVo.camp=jsonData[id].camp;
				npc_ConfigBasicVo.func_desc1=jsonData[id].func_desc1;
				npc_ConfigBasicVo.defaultDialog=jsonData[id].defaultDialog;
				npc_ConfigBasicVo.bubble1=jsonData[id].bubble1;
				npc_ConfigBasicVo.bubble2=jsonData[id].bubble2;
				npc_ConfigBasicVo.bubble3=jsonData[id].bubble3;
				npc_ConfigBasicVo.wordsInterval=jsonData[id].wordsInterval;
				_dict[npc_ConfigBasicVo.basic_id]=npc_ConfigBasicVo;
				npc_ConfigBasicVo.initWords();
			}
		}
		public function getNpc_ConfigBasicVo(basic_id:int):Npc_ConfigBasicVo
		{
			return _dict[basic_id];
		}
		/**获取小图标
		 */		
		public function getSmallIcon(npcBasicId:int):String
		{
			var npcBasicVo:Npc_ConfigBasicVo=getNpc_ConfigBasicVo(npcBasicId);
			return URLTool.getNpcSmallIcon(npcBasicVo.icon_id);
		}
		/**  获取半身像图标
		 */		
		public function getHalfIcon(npcBasicId:int):String
		{
			var npcBasicVo:Npc_ConfigBasicVo=getNpc_ConfigBasicVo(npcBasicId);
			return URLTool.getNPCHalfIcon(npcBasicVo.icon_id);
		}
		
		public function getNPCList():Dictionary{
			return _dict;
		}
	}
}