package com.YFFramework.game.core.module.guild.manager
{
	import com.YFFramework.game.core.module.guild.model.Guild_BuildingBasicVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	
	import flash.utils.Dictionary;

	public class Guild_BuildingBasicManager
	{
		private static var _instance:Guild_BuildingBasicManager;
		private var _dict:Dictionary;
		public function Guild_BuildingBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():Guild_BuildingBasicManager
		{
			if(_instance==null)_instance=new Guild_BuildingBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var guild_BuildingBasicVo:Guild_BuildingBasicVo;
			for (var id:String in jsonData)
			{
				guild_BuildingBasicVo=new Guild_BuildingBasicVo();
				guild_BuildingBasicVo.hall_level=jsonData[id].hall_level;
				guild_BuildingBasicVo.explain=jsonData[id].explain;
				guild_BuildingBasicVo.effect_value=jsonData[id].effect_value;
				guild_BuildingBasicVo.building_id=jsonData[id].building_id;
				guild_BuildingBasicVo.level=jsonData[id].level;
				guild_BuildingBasicVo.name=jsonData[id].name;
				guild_BuildingBasicVo.money_consume=jsonData[id].money_consume;
				guild_BuildingBasicVo.id=jsonData[id].id;
				_dict[guild_BuildingBasicVo.id]=guild_BuildingBasicVo;
			}
		}
		public function getGuild_BuildingBasicVo(id:int):Guild_BuildingBasicVo
		{
			return _dict[id];
		}
		
		
		
		/**
		 *根据类型和等级取VO 
		 * @param type 建筑类型
		 * @param lv 建筑等级
		 * @return 
		 * 
		 */		
		public function getGuild_BuildingBasicVoByTypeAndLv(type:int,lv:int):Guild_BuildingBasicVo
		{
			for each(var vo:Guild_BuildingBasicVo in _dict)
			{
				if(vo.building_id==type&&vo.level==lv)
					return vo;
			}
			return null;
		}
		/**根据仓库等级取公会资金上限
		 * @param lv 公会仓库等级
		 * @return 公会资金上限
		 * */
		public function getMaxMoneyByGuildStorageLv(lv:int):Number
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(TypeBuilding.STORAGE,lv);
			return vo.effect_value;
		}
		
		/**
		 *根据房子等级获取公会可容纳最大成员数 
		 * @param lv 房子等级
		 * @return 最大成员数
		 */		
		public function getMaxMemberByGuildHouseLv(lv:int):int
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(TypeBuilding.HOUSE,lv);
			return vo.effect_value;
//			return (lv+1)*15;
		}
		/**
		 *得到升级需要的资金量 
		 * @param type 建筑类型
		 * @param lv 当前等级
		 * @return 升级需要的资金
		 */		
		public function getUpgradeMoney(type:int,lv:int):int
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(type,lv);
			return vo.money_consume;
		}
		
		/**
		 *得到建筑说明 
		 * @param type 类型
		 * @param lv 等级
		 * @return 建设说明
		 * 
		 */		
		public function getBuildingInfoByType(type:int,lv:int):String
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(type,lv);
			return vo.explain;
		}
		/**升级时需要的大厅等级
		 * @param type 类型
		 * @param lv 等级
		 * return 升级需要的大厅的最小等级
		 * */
		public function getUpgradeHallLv(type:int,lv:int):int
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(type,lv);
			return vo.hall_level;
		}
		/**得到效果值*/
		public function getEffectValue(type:int,lv:int):int
		{
			var vo:Guild_BuildingBasicVo=getGuild_BuildingBasicVoByTypeAndLv(type,lv);
			return vo.effect_value;
		}
	}
}