package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.StrRatioVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-25 上午11:48:48
	 * 
	 */
	public class StrRatioManager{
		
		private var _ratioDict:Dictionary;
		private static var instance:StrRatioManager;
		
		public function StrRatioManager(){
			_ratioDict = new Dictionary();
		}
		
		public static function get Instance():StrRatioManager{
			return instance ||= new StrRatioManager();
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			var str:StrRatioVo;
			for  (var strLv:String  in jsonData){
				str = new StrRatioVo;
				str.ratio = jsonData[strLv].ratio;
				str.consts = jsonData[strLv].consts;
				str.mul = jsonData[strLv].mul;
				_ratioDict[strLv] = str;
			}
		}
		
		public function getStrRatioVo(strLv:int):StrRatioVo{
			return _ratioDict[strLv];
		}
		
		/**获取当前强化等级系数 
		 * @param strLv	当前强化等级
		 * @return Number	强化系数
		 */		
		public function getStrRatio(strLv:int):Number{
			return (_ratioDict[strLv] as StrRatioVo).ratio;
		}
		
		/**按照道具数量和当前强化等级算出下一级强化的成功率
		 * @param strLv		当前强化等级
		 * @param quantity	道具数量
		 * @return Number	成功率
		 */		
		public function getSuccRate(strLv:int,quantity:int):Number{
			var strVo:StrRatioVo = _ratioDict[strLv] as StrRatioVo;
			var succRate:Number = quantity*strVo.mul+strVo.consts;
			if(succRate>1)	return 1;
			else	return succRate;
		}
		
		/**100%成功率所需要的道具数量
		 * @param nxtStrLv 	下一级强化等级
		 * @return int		100%成功率所需要的道具数量
		 */		
		public function get100SuccQuantity(nxtStrLv:int):int{
			var strVo:StrRatioVo = _ratioDict[nxtStrLv] as StrRatioVo;
			return Math.ceil((1-strVo.consts)/strVo.mul)
		}
		
	}
} 