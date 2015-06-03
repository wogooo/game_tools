package com.YFFramework.game.core.module.mount.manager
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 上午11:46:02
	 * 
	 */
	public class MountBasicManager{
		
		private static var instance:MountBasicManager;
		private var _mountBasic:HashMap= new HashMap();
		
		public function MountBasicManager(){
		}
		
		public static function get Instance():MountBasicManager{
			return instance ||= new MountBasicManager();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var mount:MountBasicVo = new MountBasicVo();
				mount.basic_id = jsonData[id].basic_id;
				mount.mount_type = jsonData[id].mount_type;
				mount.physique = jsonData[id].physique;
				mount.strength = jsonData[id].strength;
				mount.agility = jsonData[id].agility;
				mount.intell = jsonData[id].intell;
				mount.spirit = jsonData[id].spirit;
				mount.quality = jsonData[id].quality;
				mount.speed = jsonData[id].speed/UpdateManager.UpdateRate;
				mount.displaySpeed = jsonData[id].speed;
//				mount.addPhy = jsonData[id].physique_add;
//				mount.addStr = jsonData[id].strength_add;
//				mount.addAgi = jsonData[id].agility_add;
//				mount.addInt = jsonData[id].intell_add;
//				mount.addSpi = jsonData[id].spirit_add;
				mount.icon_id = jsonData[id].icon_id;
				mount.model_id = jsonData[id].model_id;
				mount.parts = jsonData[id].parts;
				mount.advanceId = jsonData[id].advance_id;
				mount.advancePropId = jsonData[id].advance_prop_id;
				mount.advancePropNum = jsonData[id].advance_prop_num;
					
				_mountBasic.put(mount.basic_id,mount);
			}
		}
		/**获取对应的MountBasicVo 
		 * @param basicId	配属id
		 * @return 	MountBasicVo,坐骑基本属性，速度，模型id,图标id
		 */		
		public function getMountBasicVo(basicId:int):MountBasicVo{
			return _mountBasic.get(basicId);
		}
		
//		/**获取对应的坐骑图标地址 
//		 * @param lv	坐骑的阶数
//		 * @param basicId	坐骑的basicId
//		 * @return String 坐骑图标地址
//		 */		
//		public function getMountIconURL(lv:int,basicId:int):String{
//			var iconId:int;
//			switch(MountLvBasicManager.Instance.getMountLvBasic(lv).icon){
//				case 1:	
//					iconId=(_mountBasic.get(basicId) as MountBasicVo).icon_id1;
//					break;
//				case 2:	
//					iconId=(_mountBasic.get(basicId) as MountBasicVo).icon_id2;
//					break;
//				case 3:	
//					iconId=(_mountBasic.get(basicId) as MountBasicVo).icon_id3;
//					break;
//				case 4:	
//					iconId=(_mountBasic.get(basicId) as MountBasicVo).icon_id4;
//					break;
//			}
//			return URLTool.getMonsterIcon(iconId);
//		}
		
		/**获取对应的坐骑图标地址 
		 * @param basicId	坐骑的basicId
		 * @return String 坐骑图标地址
		 */		
		public function getMountIconURL(basicId:int):String{
			return URLTool.getMonsterIcon((_mountBasic.get(basicId) as MountBasicVo).icon_id);
		}
		
//		/**获取坐骑模型  id   模型  地址 需要通过  URLTool.getMountBody  URLTool.getMountHead    URLTool.getMountBodyNormal  URLTool.getMountHeadNormal  获取对应资源 
//		 * @param lv
//		 * @param basicId
//		 */		
//		public function getMountModelId(lv:int,basicId:int):int{
//			switch(MountLvBasicManager.Instance.getMountLvBasic(lv).icon){
//				case 1:	return (_mountBasic.get(basicId) as MountBasicVo).model_id1;
//				case 2:	return (_mountBasic.get(basicId) as MountBasicVo).model_id2;					
//				case 3:	return (_mountBasic.get(basicId) as MountBasicVo).model_id3;					
//				case 4:	return (_mountBasic.get(basicId) as MountBasicVo).model_id4;
//			}
//			return -1;
//		}
		
		/**获取坐骑模型  id   模型  地址 需要通过  URLTool.getMountBody  URLTool.getMountHead    URLTool.getMountBodyNormal  URLTool.getMountHeadNormal  获取对应资源 
		 * @param basicId
		 */		
		public function getMountModelId(basicId:int):int{
			return (_mountBasic.get(basicId) as MountBasicVo).model_id;
//			switch(MountLvBasicManager.Instance.getMountLvBasic(lv).icon){
//				case 1:	return (_mountBasic.get(basicId) as MountBasicVo).model_id1;
//				case 2:	return (_mountBasic.get(basicId) as MountBasicVo).model_id2;					
//				case 3:	return (_mountBasic.get(basicId) as MountBasicVo).model_id3;					
//				case 4:	return (_mountBasic.get(basicId) as MountBasicVo).model_id4;
//			}
//			return -1;
		}
	}
} 