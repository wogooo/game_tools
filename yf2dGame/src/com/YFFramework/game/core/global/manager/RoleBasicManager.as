package com.YFFramework.game.core.global.manager
{
	
	import com.YFFramework.game.core.global.model.RoleBasicVo;
	
	import flash.utils.Dictionary;

	/** 角色 基本表   对应 roleBasic.csv
	 * 2012-8-15 下午1:57:18
	 *@author yefeng
	 */
	public class RoleBasicManager
	{
		private static var _instance:RoleBasicManager;
		private var _dict:Dictionary;
		public function RoleBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():RoleBasicManager
		{
			if(_instance==null) _instance=new RoleBasicManager();
			return _instance;
		}
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void
		{
			var  roleBasicVo:RoleBasicVo;///角色基础属性vo 
			var key:String;
			for  (var career:String  in jsonData)
			{
				roleBasicVo=new RoleBasicVo();
				roleBasicVo.carrer=int(career);
				roleBasicVo.sex=jsonData[career].sex;
				roleBasicVo.hp=jsonData[career].hp;
				roleBasicVo.pAtk=jsonData[career].pAtk;
				roleBasicVo.pDefence=jsonData[career].pDefence;
				roleBasicVo.mAtk=jsonData[career].mAtk;
				roleBasicVo.mDefence=jsonData[career].mDefence;
				roleBasicVo.hitTarge=jsonData[career].hitTarge;
				roleBasicVo.dodge=jsonData[career].dodge;
				key=getSingleKey(roleBasicVo.carrer,roleBasicVo.sex);
				_dict[key]=roleBasicVo;
			}
		}
		/**唯一 key 
		 */		
		private function getSingleKey(carrer:int,sex:int):String
		{
			return carrer+"_"+sex;
		}
		/**获得角色基础vo 
		 */		
		public function getRoleBasicVo(carrer:int,sex:int):RoleBasicVo
		{
			return _dict[getSingleKey(carrer,sex)]
		}
		
		
	}
}