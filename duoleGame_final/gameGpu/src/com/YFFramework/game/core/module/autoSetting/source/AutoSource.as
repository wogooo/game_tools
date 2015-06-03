package com.YFFramework.game.core.module.autoSetting.source
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-20 下午2:48:46
	 */
	public class AutoSource{
		
		public static const FLUSH_UNIT_TYPE_MONSTER:int = 2;
		
		public static const FLUSH_SCENE_TYPE_NORMAL:int = 1;	//普通地图类型
		public static const FLUSH_SCENE_TYPE_RAID:int=2;		//副本地图类型
		
		public static const CAN_VIEW:int=1;
		
		public static const CT_EQUIPS:int = 1;          //是否捡装
		public static const CT_EQUIPS0:int = 2;         //装备品质1
		public static const CT_EQUIPS1:int = 3;         //装备品质2
		public static const CT_EQUIPS2:int = 4;         //装备品质3
		public static const CT_EQUIPS3:int = 5;         //装备品质4
		public static const CT_EQUIPS4:int = 6;         //装备品质5
		public static const CT_EQUIPS5:int = 7;         //装备品质6
		
		public static const CT_EQUIT_ARR:Array = [CT_EQUIPS0,CT_EQUIPS1,CT_EQUIPS2,CT_EQUIPS3,CT_EQUIPS4,CT_EQUIPS5];
		
		public static const CT_PROPS:int = 8;           //是否捡道
		public static const CT_PROPS0:int = 9;          //道具品质1
		public static const CT_PROPS1:int = 10;         //道具品质2
		public static const CT_PROPS2:int = 11;         //道具品质3
		public static const CT_PROPS3:int = 12;         //道具品质4
		public static const CT_PROPS4:int = 13;         //道具品质5
		
		public static const CT_PROPS_ARR:Array = [CT_PROPS0,CT_PROPS1,CT_PROPS2,CT_PROPS3,CT_PROPS4];
		
		public static const CT_HP_PERCENT:int = 1;     //需要吃药的生命百分比
		public static const CT_MP_PERCENT:int = 2;     //需要吃药的魔法百分比
		public static const CT_PET_HP_PERCENT:int = 3; //宠物需要吃药的生命百分比
		
		public static const CT_SKILL0:int=4;
		public static const CT_SKILL1:int=5;
		public static const CT_SKILL2:int=6;
		public static const CT_SKILL3:int=7;
		public static const CT_SKILL4:int=8;
		public static const CT_SKILL5:int=9;
		public static const CT_SKILL6:int=10;
		public static const CT_SKILL7:int=11;
		public static const CT_SKILL8:int=12;
		public static const CT_SKILL9:int=13;
		
		public static const CT_SKILL_ARR:Array=[CT_SKILL0,CT_SKILL1,CT_SKILL2,CT_SKILL3,CT_SKILL4,CT_SKILL5,CT_SKILL6,CT_SKILL7,CT_SKILL8,CT_SKILL9];
		
		/**血池最大量 2kW
		 */		
		public static const HP_POOL_MAX:int = 20000000;
		/**魔池最大量 2kW
		 */		
		public static const MP_POOL_MAX:int = 20000000; 
		/**宠物血池最大量 2kW
		 */		
		public static const Pet_Hp_Pool_Max:int = 20000000; 
		
		public function AutoSource(){
		}
	}
} 