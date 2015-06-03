package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.core.global.model.Trap_ConfigBasicVo;
	
	import flash.utils.Dictionary;

	public class Trap_ConfigBasicManager
	{
		private static var _instance:Trap_ConfigBasicManager;
		private var _dict:Dictionary;
		public function Trap_ConfigBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Trap_ConfigBasicManager
		{
			if(_instance==null)_instance=new Trap_ConfigBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var trap_ConfigBasicVo:Trap_ConfigBasicVo;
			for (var id:String in jsonData)
			{
				trap_ConfigBasicVo=new Trap_ConfigBasicVo();
				trap_ConfigBasicVo.range=jsonData[id].range;
				trap_ConfigBasicVo.model_id=jsonData[id].model_id;
				trap_ConfigBasicVo.trap_id=jsonData[id].trap_id;
				trap_ConfigBasicVo.skill_id=jsonData[id].skill_id;
				_dict[trap_ConfigBasicVo.trap_id]=trap_ConfigBasicVo;
			}
		}
		public function getTrap_ConfigBasicVo(trap_id:int):Trap_ConfigBasicVo
		{
			return _dict[trap_id];
		}
		/**获取陷阱资源模型
		 */		
		public function getTrapModelURL(trapBasicId:int):String
		{
			var trapBasicVo:Trap_ConfigBasicVo=getTrap_ConfigBasicVo(trapBasicId);
			return URLTool.getTrap(trapBasicVo.model_id);
		}
	}
}