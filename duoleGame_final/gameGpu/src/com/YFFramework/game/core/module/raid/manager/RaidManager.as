package com.YFFramework.game.core.module.raid.manager
{
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.raid.model.RaidNumVo;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-27 下午2:14:28
	 */
	public class RaidManager{
		
		private static var instance:RaidManager;
		private var _raids:HashMap=new HashMap();
		private var _raidGroups:HashMap = new HashMap();
		public static var raidId:int=-1;
		public static var demonFirstDead:Boolean=false;
		
		public function RaidManager(){
		}
		
		/** 缓存数据   json数据
		 */		
		public function cacheData(jsonData:Object):void{
			for(var id:String  in jsonData){
				var raid:RaidVo = new RaidVo();
				raid.raidId=jsonData[id].raid_id;
				raid.groupId=jsonData[id].group_id;
				raid.raidType=jsonData[id].raid_type;
				raid.raidName=jsonData[id].raid_name;
				raid.minLv=jsonData[id].min_lv;
				raid.maxLv=jsonData[id].max_lv;
				raid.timeId=jsonData[id].time_id;
				raid.energy=jsonData[id].energy;
				raid.raidLimit=jsonData[id].raid_limit;
				raid.createTerm=jsonData[id].create_term;
				raid.nextRaidId=jsonData[id].next_raid_id;
				raid.raidDesc=jsonData[id].raid_desc;
				raid.moneyStar=jsonData[id].money_star;
				raid.propsStar=jsonData[id].props_star;
				raid.expStar=jsonData[id].exp_star;
				raid.activityId = jsonData[id].activity_id;
				raid.enter_map_id=jsonData[id].enter_map_id;
				raid.exit_map_id=jsonData[id].exit_map_id;	
				raid.rewardId = jsonData[id].reward_id;
				raid.rewardShowId = jsonData[id].show_reward_id;
				raid.floor = jsonData[id].floor;
				raid.totalFloor = jsonData[id].total_floor;
				raid.deadTimes = jsonData[id].dead_times;
				raid.duration = jsonData[id].duration;
				raid.win = jsonData[id].win;
				raid.raidNum=0;
				raid.deadNum=0;
				raid.story_start_id=jsonData[id].story_start_id;
				raid.story_end_id=jsonData[id].story_end_id;

				_raids.put(raid.raidId,raid);
				if(_raidGroups.get(raid.groupId)==null){
					_raidGroups.put(raid.groupId,new Array());
					(_raidGroups.get(raid.groupId) as Array).push(raid);
				}else{
					(_raidGroups.get(raid.groupId) as Array).push(raid);
				}
			}
		}
		
		/**获得副本组id
		 * @return 
		 */		
		public function getRaidGroups():Array{
			var arr:Array = _raidGroups.values();
			var len:int = arr.length;
			var retArr:Array = new Array();
			for(var i:int=0;i<len;i++){
				retArr.push(arr[i][0].groupId);
			}
			return retArr;
		}
		
		/**副本显示条件判断；查看副本能否显示在NPC面板上
		 * @param groupId	副本组ID
		 * @return Boolean	true:可以显示；false：不可以显示
		 */		
		public function isViewable(groupId:int):Boolean{
			var arr:Array = getRaidsByGroupId(groupId);
			var len:int = arr.length;
			var canView:Boolean=false;
			for(var i:int=0;i<len;i++){
				var raid:RaidVo = arr[i];
				if(raid.isCreated){
					canView=true;
					break;
				}else if(raid.raidNum<raid.raidLimit && DataCenter.Instance.roleSelfVo.roleDyVo.level<=raid.maxLv && DataCenter.Instance.roleSelfVo.roleDyVo.level>=raid.minLv){
					if(raid.timeId==0){
						canView=true;
						break;
					}else{
						if(RaidTimeBasicManager.Instance.checkValidTime(raid.timeId)==true){
							canView=true;
							break;
						}
					}
				}
			}
			return canView;
		}
		
		/**副本显示条件判断；查看副本能否显示在NPC面板上 - 加强板，如果能显示，返回RaidNumVo,不能显示返回null
		 * @param groupId	副本组ID
		 * @return Boolean	如果能显示，返回RaidNumVo,不能显示返回null
		 */		
		public function isViewable2(groupId:int):RaidNumVo{
			var arr:Array = getRaidsByGroupId(groupId);
			var len:int = arr.length;
			var vo:RaidNumVo;
			for(var i:int=0;i<len;i++){
				var raid:RaidVo = arr[i];
				if(raid.isCreated){
					vo = new RaidNumVo();
					vo.raidLimit = raid.raidLimit;
					vo.raidNum = raid.raidNum;
					break;
				}else if(raid.raidNum<raid.raidLimit && DataCenter.Instance.roleSelfVo.roleDyVo.level<=raid.maxLv && DataCenter.Instance.roleSelfVo.roleDyVo.level>=raid.minLv){
					if(raid.timeId==0){
						vo = new RaidNumVo();
						vo.raidLimit = raid.raidLimit;
						vo.raidNum = raid.raidNum;
						break;
					}else{
						if(RaidTimeBasicManager.Instance.checkValidTime(raid.timeId)==true){
							vo = new RaidNumVo();
							vo.raidLimit = raid.raidLimit;
							vo.raidNum = raid.raidNum;
							break;
						}
					}
				}
			}
			return vo;
		}
		
		/**副本判断可否取消；取消副本能否显示在NPC面板上
		 * @param groupId	副本组ID
		 * @return Boolean	true:可以显示；false：不可以显示
		 */
		public function isCancelable(groupId:int):Boolean{
			var arr:Array = getRaidsByGroupId(groupId);
			var len:int=arr.length;
			var canCancel:Boolean=false;
			for(var i:int=0;i<len;i++){
				var vo:RaidVo = arr[i];
				if(vo.isCreated){
					if(TeamDyManager.LeaderId==0){
						canCancel=true;
						break;
					}else if(TeamDyManager.LeaderId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
						canCancel=true;
						break;
					}
				}
			}
			return canCancel;
		}
		
		/**获得副本列表
		 * @return Array
		 */		
		public function getRaidList():Array{
			return _raids.values();
		}
		
		/**获取RaidBasicVo
		 * @param raidId	指定的副本静态id
		 * @return RaidBasicVo
		 */		
		public function getRaidVo(raidId:int):RaidVo{
			return _raids.get(raidId);
		}
		
		/**获得副本组的全部副本vo
		 * @param groupId
		 * @return 
		 */		
		public function getRaidsByGroupId(groupId:int):Array{
			var arr:Array=new Array();
			var len:int = _raids.size();
			for each(var vo:RaidVo in _raids.getDict()){
				if(vo.groupId==groupId){
					arr.push(vo);
				}
			}
			return arr;
		}
		
		/**通过group id获取对应的raid id
		 * @param groupId
		 * @return 没有的话返回-1
		 */		
		public function getRaidIdByGroupId(groupId:int):int{
			for each(var vo:RaidVo in _raids.getDict()){
				if(vo.groupId==groupId && vo.isCreated){
					return vo.raidId;
				}
			}
			for each(vo in _raids.getDict()){
				if(vo.groupId==groupId && DataCenter.Instance.roleSelfVo.roleDyVo.level>=vo.minLv && DataCenter.Instance.roleSelfVo.roleDyVo.level<=vo.maxLv){
					return vo.raidId;
				}
			}
			return -1;
		}
		
		/**通过group id获取对应的raid vo
		 * @param groupId
		 * @return 没有的话返回null
		 */		
		public function getRaidVoByGroupId(groupId:int):RaidVo{
			for each(var vo:RaidVo in _raids.getDict()){
				if(vo.groupId==groupId && vo.isCreated){
					return vo;
				}
			}
			for each(vo in _raids.getDict()){
				if(vo.groupId==groupId && DataCenter.Instance.roleSelfVo.roleDyVo.level>=vo.minLv && DataCenter.Instance.roleSelfVo.roleDyVo.level<=vo.maxLv){
					return vo;
				}
			}
			return null;
		}
		
		/**通过group id获取最对应的raid vo
		 * @param groupId
		 * @return 没有的话返回null
		 */		
		public function getNearestRaidVoByGroupId(groupId:int):RaidVo{		
			for each(var vo:RaidVo in _raids.getDict()){
				if(vo.groupId==groupId && vo.isCreated){
					return vo;
				}
			}
			for each(vo in _raids.getDict()){
				if(vo.groupId==groupId && DataCenter.Instance.roleSelfVo.roleDyVo.level>=vo.minLv && DataCenter.Instance.roleSelfVo.roleDyVo.level<=vo.maxLv){
					return vo;
				}
			}
			for each(vo in _raids.getDict()){
				if(vo.groupId==groupId && DataCenter.Instance.roleSelfVo.roleDyVo.level<vo.minLv){
					return vo;
				}
			}
			return null;
		}
		
		public static function get Instance():RaidManager{
			return instance ||= new RaidManager();
		}
	}
}