package com.YFFramework.game.core.module.mount.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.module.mount.model.MountLvBasicVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 上午11:46:23
	 * 
	 */
	public class MountLvBasicManager{
		
		private static var instance:MountLvBasicManager;
		private var _mountLvBasic:HashMap;
		
		
		public static function get Instance():MountLvBasicManager{
			return instance ||= new MountLvBasicManager();
		}
		
		public function MountLvBasicManager(){
			_mountLvBasic = new HashMap();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var mount:MountLvBasicVo = new MountLvBasicVo();
				mount.level = jsonData[id].level;
				mount.exp = jsonData[id].exp;
				mount.mul = jsonData[id].mul;
				mount.icon = jsonData[id].icon;
				mount.model = jsonData[id].model;
				
				_mountLvBasic.put(mount.level,mount);
			}
		}
		
		/**获取MountLvBasic
		 * @param lv	坐骑阶数
		 * @return MountLvBasic
		 */		
		public function getMountLvBasic(lv:int):MountLvBasicVo{
			return _mountLvBasic.get(lv);
		}
	}
} 