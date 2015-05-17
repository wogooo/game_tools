package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.model.PetBasicVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-9 下午2:34:00
	 * 
	 */
	public class PetBasicManager{
		
		private static var instance:PetBasicManager;
		private var _petHashMap:HashMap;
		
		public function PetBasicManager(){
			_petHashMap = new HashMap();
		}
		
		public static function get Instance():PetBasicManager{
			return instance ||= new PetBasicManager();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var petInfo:PetBasicVo = new PetBasicVo();
				petInfo.config_id = jsonData[id].config_id;
				petInfo.show_id = jsonData[id].show_id;
				petInfo.pet_type = jsonData[id].pet_type;
				
				petInfo.strength = jsonData[id].strength;
				petInfo.agile = jsonData[id].agile;
				petInfo.intelligence = jsonData[id].intelligence;
				petInfo.physique = jsonData[id].physique;
				petInfo.spirit = jsonData[id].spirit;
				petInfo.strength_apt = jsonData[id].strength_apt;
				petInfo.agile_apt = jsonData[id].agile_apt;
				petInfo.intelligence_apt = jsonData[id].intelligence_apt;
				petInfo.physique_apt = jsonData[id].physique_apt;
				petInfo.spirit_apt = jsonData[id].spirit_apt;
				petInfo.model_id=jsonData[id].model_id;
				petInfo.head_id=jsonData[id].head_id;
				petInfo.phy_add = jsonData[id].phy_add;
				petInfo.str_add = jsonData[id].str_add;
				petInfo.agi_add = jsonData[id].agi_add;
				petInfo.int_add = jsonData[id].int_add;
				petInfo.spi_add = jsonData[id].spi_add;
				
				_petHashMap.put(petInfo.config_id,petInfo);
			}
		}
		
		public function getPetConfigVo(petBasicId:int):PetBasicVo{
			return _petHashMap.get(petBasicId);
		}

		/**获得宠物小图标地址
		 * @param petBasicId
		 * @return String 宠物小图标地址
		 */
		public function getShowURL(petBasicId:int):String{
			return URLTool.getMonsterIcon((_petHashMap.get(petBasicId) as PetBasicVo).show_id);
		}
		
	}
} 