package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	import com.YFFramework.game.core.module.activity.model.TypeActivity;
	
	import flash.utils.Dictionary;

	public class ActivityBasicManager
	{
		private static var _instance:ActivityBasicManager;
		
		/**缓存副本类型的 活动
		 */
		private var _raidCache:Dictionary;
		private var _dict:Dictionary;
		/**以activity type为key的dictionary 
		 */		
		private var _activityTypesDict:Dictionary;
		public function ActivityBasicManager()
		{
			_dict=new Dictionary();
			_raidCache=new Dictionary();
			_activityTypesDict=new Dictionary();
		}
		public static function get Instance():ActivityBasicManager
		{
			if(_instance==null)_instance=new ActivityBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var activityBasicVo:ActivityBasicVo;
			for (var id:String in jsonData)
			{
				activityBasicVo=new ActivityBasicVo();
				activityBasicVo.identity=jsonData[id].identity;
				activityBasicVo.start_time4=jsonData[id].start_time4;
				activityBasicVo.start_time2=jsonData[id].start_time2;
				activityBasicVo.start_notice_time=jsonData[id].start_notice_time;
				activityBasicVo.active_name=jsonData[id].active_name;
				activityBasicVo.sign_continue_time=jsonData[id].sign_continue_time;
				activityBasicVo.continue_time=jsonData[id].continue_time;
				activityBasicVo.scene_id=jsonData[id].scene_id;
				activityBasicVo.min_level=jsonData[id].min_level;
				activityBasicVo.extra_item_id=jsonData[id].extra_item_id;
				activityBasicVo.open_date=jsonData[id].open_date;
				activityBasicVo.dialog_id=jsonData[id].dialog_id;
				activityBasicVo.world_level=jsonData[id].world_level;
				activityBasicVo.npc_id=jsonData[id].npc_id;
				activityBasicVo.vip_cond=jsonData[id].vip_cond;
				activityBasicVo.sign_time=jsonData[id].sign_time;
				activityBasicVo.scene_type=jsonData[id].scene_type;
				activityBasicVo.extra_vip_cond=jsonData[id].extra_vip_cond;
				activityBasicVo.extra_money_type=jsonData[id].extra_money_type;
				activityBasicVo.guild_cond_id=jsonData[id].guild_cond_id;
				activityBasicVo.start_time3=jsonData[id].start_time3;
				activityBasicVo.max_level=jsonData[id].max_level;
				activityBasicVo.open_times=jsonData[id].open_times;
				activityBasicVo.is_cycle=jsonData[id].is_cycle;
				activityBasicVo.notice_interval=jsonData[id].notice_interval;
				activityBasicVo.extra_times=jsonData[id].extra_times;
				activityBasicVo.item_number=jsonData[id].item_number;
				activityBasicVo.extra_item_number=jsonData[id].extra_item_number;
				activityBasicVo.active_id=jsonData[id].active_id;
				activityBasicVo.item_id=jsonData[id].item_id;
				activityBasicVo.start_time1=jsonData[id].start_time1;
				activityBasicVo.is_regular=jsonData[id].is_regular;
				activityBasicVo.start_time5=jsonData[id].start_time5;
				activityBasicVo.notice_id=jsonData[id].notice_id;
				activityBasicVo.cycle_days=jsonData[id].cycle_days;
				activityBasicVo.open_interval=jsonData[id].open_interval;
				activityBasicVo.ready_time=jsonData[id].ready_time;
				activityBasicVo.limit_times=jsonData[id].limit_times;
				activityBasicVo.extra_money=jsonData[id].extra_money;
				activityBasicVo.part_type=jsonData[id].part_type;
				activityBasicVo.limit_type=jsonData[id].limit_type;
				activityBasicVo.icon_id=jsonData[id].icon_id;
				activityBasicVo.icon_level=jsonData[id].icon_level;
				activityBasicVo.active_type=jsonData[id].active_type;
				activityBasicVo.time_desc = jsonData[id].time_desc;
				activityBasicVo.activity_desc = jsonData[id].activity_desc;
				activityBasicVo.money_star = jsonData[id].money_star;
				activityBasicVo.exp_star = jsonData[id].exp_star;
				activityBasicVo.props_star = jsonData[id].props_star;
				_dict[activityBasicVo.active_id]=activityBasicVo;
				
				if(activityBasicVo.scene_type==TypeActivity.SceneType_Raid)  //如果为副本类型
				{
					_raidCache[activityBasicVo.scene_id]=activityBasicVo;
				}
				if(_activityTypesDict[activityBasicVo.active_type]==null){
					_activityTypesDict[activityBasicVo.active_type]=new Array();
					(_activityTypesDict[activityBasicVo.active_type] as Array).push(activityBasicVo);
				}else{
					(_activityTypesDict[activityBasicVo.active_type] as Array).push(activityBasicVo);
				}
			}	
		}
		
		/**获得获得类型Array,包含activie_id
		 * @return 
		 */		
		public function getActivityTypes():Array{
			var retArr:Array = new Array();
			for each(var arr:Array in _activityTypesDict){
				retArr.push(arr[0].active_id);
			}
			return retArr;
		}
		
		/**判断副本是否属于活动
		 * 副本id 获取 活动数据 如果 返回为 null 则表示 该副本不是活动 
		 */
		public function getActivityBasicVoByRaidId(raidId:int):ActivityBasicVo
		{
			return _raidCache[raidId];
		}
		/**
		 * @param active_id  活动id 获取数据
		 */
		public function getActivityBasicVo(active_id:int):ActivityBasicVo
		{
			return _dict[active_id];
		}
		
		public function getActivityBasicVoByType(active_type:int):ActivityBasicVo
		{
			for each(var vo:ActivityBasicVo in _dict)
			{
				if(vo.active_type == active_type)
					return vo;
			}
			return null;
		}
		
		public function getAllActivities():Array
		{
			var ary:Array=[];
			for each(var vo:ActivityBasicVo in _dict)
			{
				ary.push(vo);
			}
			
			ary.sortOn("active_id",Array.NUMERIC);
			return ary;
		}
		
		/** 将活动次数表里的已参加次数全部初始化为0
		 */		
		public function initActivitiesTimes():void
		{
			for each(var vo:ActivityBasicVo in _dict)
			{
				ActivityDyManager.instance.setActivityTimes(vo.active_type,0);
			}
		}
	}
}