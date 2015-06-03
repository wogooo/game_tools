package com.YFFramework.game.core.module.raid.manager
{
	import com.YFFramework.game.core.module.raid.model.RaidRewardShowVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-11-6 下午3:14:14
	 */
	public class RaidRewardShowManager{
		
		private static var instance:RaidRewardShowManager;
		private var _dict:Dictionary=new Dictionary();
		
		public function RaidRewardShowManager(){
		}
		
		public function cacheData(jsonData:Object):void{
			var raidRewardShowVo:RaidRewardShowVo;
			for (var id:String in jsonData){
				raidRewardShowVo=new RaidRewardShowVo();
				raidRewardShowVo.rewardId=jsonData[id].reward_id;
				raidRewardShowVo.rewardType=jsonData[id].reward_type;
				raidRewardShowVo.itemId=jsonData[id].item_id;
				raidRewardShowVo.type=jsonData[id].type;
			
				if(_dict[raidRewardShowVo.key]==null){
					_dict[raidRewardShowVo.key] = new Vector.<RaidRewardShowVo>();
					_dict[raidRewardShowVo.key].push(raidRewardShowVo);
				}else{
					_dict[raidRewardShowVo.key].push(raidRewardShowVo);
				}
			}
		}
		
		/**
		 *跟具类型和id取raidRewardShowVo 
		 * @param type TypeRewardShow里定义的枚举值
		 * @param id 唯一id(副本在副本表里有对应的raidRewardShowId字段,活动就是活动ID，boss就是boss的flushId)
		 * @return RaidRewardVo数组
		 * 
		 */		
		public function getRewardShowVoByIdAndType(type:int,id:int):Vector.<RaidRewardShowVo>
		{
			var key:String=type+"_"+id;
			return _dict[key];
		}
		
		public static function get Instance():RaidRewardShowManager{
			return instance ||= new RaidRewardShowManager();
		}
	}
} 