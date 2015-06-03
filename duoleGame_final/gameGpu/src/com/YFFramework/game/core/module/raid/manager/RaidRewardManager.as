package com.YFFramework.game.core.module.raid.manager
{
	import com.YFFramework.game.core.module.raid.model.RaidRewardVo;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-11-6 下午2:25:54
	 */
	public class RaidRewardManager{
		
		private static var instance:RaidRewardManager;
		/**basicId为索引的dictionary 
		 */		
		private var _dict:Dictionary=new Dictionary();
		/**一个组的dictionary 
		 */		
		private var _groupDict:Dictionary = new Dictionary();
		
		public function RaidRewardManager(){
		}
		
		public function cacheData(jsonData:Object):void{
			var raidRewardVo:RaidRewardVo;
			for (var id:String in jsonData){
				raidRewardVo=new RaidRewardVo();
				raidRewardVo.basicId=jsonData[id].basic_id;
				raidRewardVo.rewardId=jsonData[id].reward_id;
				raidRewardVo.rewardLevel=jsonData[id].reward_level;
				raidRewardVo.itemType=jsonData[id].item_type;
				raidRewardVo.itemId=jsonData[id].item_id;
				raidRewardVo.itemNumber=jsonData[id].item_number;
				_dict[raidRewardVo.basicId]=raidRewardVo;
				if(_groupDict[raidRewardVo.rewardId+"."+raidRewardVo.rewardLevel]==null){
					_groupDict[raidRewardVo.rewardId+"."+raidRewardVo.rewardLevel] = new Array();
					_groupDict[raidRewardVo.rewardId+"."+raidRewardVo.rewardLevel].push(raidRewardVo);
				}else{
					_groupDict[raidRewardVo.rewardId+"."+raidRewardVo.rewardLevel].push(raidRewardVo);
				}
			}
		} 
		
		/**通过rewardId, rewardLevel获取Array of RaidRewardVo
		 * @param rewardId
		 * @param rewardLevel
		 * @return 
		 */		
		public function getRaidRewardVoArray(rewardId:int,rewardLevel:int):Array{
			var arr:Array = new Array();
			var len:int = _groupDict[rewardId+"."+rewardLevel].length;
			for(var i:int=0;i<len;i++){
				arr.push(_groupDict[rewardId+"."+rewardLevel][i]);
			}
			return arr;
		}
		
		/**通过唯一key值找到RaidRewardVo
		 * @param basicId
		 * @return 
		 */		
		public function getRaidRewardVo(basicId:int):RaidRewardVo{
			return _dict[basicId];
		}
		
		public static function get Instance():RaidRewardManager{
			return instance ||= new RaidRewardManager();
		}
	}
} 