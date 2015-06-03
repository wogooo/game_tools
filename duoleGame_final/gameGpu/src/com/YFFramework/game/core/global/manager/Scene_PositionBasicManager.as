package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.Scene_PositionBasicVo;
	
	import flash.utils.Dictionary;

	/** 存储 位置
	 */
	public class Scene_PositionBasicManager
	{
		private static var _instance:Scene_PositionBasicManager;
		private var _dict:Dictionary;
		public function Scene_PositionBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Scene_PositionBasicManager
		{
			if(_instance==null)_instance=new Scene_PositionBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var scene_PositionBasicVo:Scene_PositionBasicVo;
			for (var id:String in jsonData)
			{
				scene_PositionBasicVo=new Scene_PositionBasicVo();
				scene_PositionBasicVo.pos_x=jsonData[id].pos_x;
				scene_PositionBasicVo.pos_y=jsonData[id].pos_y;
				scene_PositionBasicVo.pos_id=jsonData[id].pos_id;
				scene_PositionBasicVo.scene_id=jsonData[id].scene_id;
				_dict[scene_PositionBasicVo.pos_id]=scene_PositionBasicVo;
			}
		}
		public function getScene_PositionBasicVo(pos_id:int):Scene_PositionBasicVo
		{
			return _dict[pos_id];
		}
	}
}