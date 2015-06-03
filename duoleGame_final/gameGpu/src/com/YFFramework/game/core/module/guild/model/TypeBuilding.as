package com.YFFramework.game.core.module.guild.model
{
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.msg.enumdef.BuildingType;

	/***
	 *
	 *@author ludingchang 时间：2013-7-25 上午11:20:46
	 */
	public class TypeBuilding
	{
		/**大厅*/
		public static const HALL:int = BuildingType.HALL;
		/**研究所*/
		public static const RESEARCH:int = BuildingType.RESEARCH;
		/**房子*/
		public static const HOUSE:int = BuildingType.HOUSE;
		/**商店*/
		public static const SHOP:int = BuildingType.SHOP;
		/**仓库*/
		public static const STORAGE:int = BuildingType.STORAGE;
		
		public static const URL_HALL:String = "guild/hall.png" /**"guild/guild_building_hall.swf"*/;
		public static const URL_RESERACH:String ="guild/reserach.png" /**"guild/guild_building_reserach.swf"*/;
		public static const URL_HOUSE:String = "guild/house.png" /**"guild/guild_building_house.swf"*/;
		public static const URL_SHOP:String = "guild/shop.png" /**"guild/guild_building_shop.swf"*/;
		
		/**
		 *得到建筑名 
		 * @param type
		 * 
		 */		
		public static function getBuildingNameByType(type:int):String
		{
			switch(type)
			{
				case -1:return "未开放";
				case HALL:return "议事大厅";
				case RESEARCH:return "科技学院";
				case HOUSE:return "公会民居";
				case SHOP:return "公会商店";
				case STORAGE:return "仓库";
			}
			return "";
		}
		/**
		 *根据建筑类型取对应的图片URL 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getBuildingImgByType(type:int):String
		{
			switch(type)
			{
				case -1:return "";
				case HALL:return URL_HALL;
				case RESEARCH:return URL_RESERACH;
				case HOUSE:return URL_HOUSE;
				case SHOP:return URL_SHOP;
			}
			return "";
		}
		
	}
}