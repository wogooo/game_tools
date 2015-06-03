package com.YFFramework.game.core.module.pet.manager
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-11 下午2:56:27
	 * 
	 */
	public class PetLevelXpManager{
		
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