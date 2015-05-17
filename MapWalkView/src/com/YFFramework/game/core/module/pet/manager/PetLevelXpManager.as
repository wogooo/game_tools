package com.YFFramework.game.core.module.pet.manager
{
	/**2012-8-17 下午4:01:34
	 *@author yefeng
	 */
	public class PetLevelXpManager
	{
		private var _xpArr:Array;
		private static var instance:PetLevelXpManager;

		public function PetLevelXpManager(){
			_xpArr = new Array();
		}
		
		public static function get Instance():PetLevelXpManager{
			return instance ||= new PetLevelXpManager();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			var index:int = 1;
			for  (var xp:String  in jsonData){
				_xpArr[index] = jsonData[xp].experience;
				index++;
			}
		}
		
		public function getXp(level:int):int{
			return _xpArr[level];
		}
	}
}