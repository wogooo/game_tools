package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicVo;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseRewardVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseVo;
	import com.YFFramework.game.core.module.activity.model.TypeRewardShow;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardShowManager;
	import com.YFFramework.game.core.module.raid.model.RaidRewardShowVo;
	import com.dolo.ui.data.ListItem;
	
	import flash.display.MovieClip;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-25 下午5:38:01
	 */
	public class DailyView extends ActiveViewBase
	{
		
		
		public function DailyView(mc:MovieClip){
			super(mc);
		}
		
		protected override function setRender():void
		{
			_list.itemRender = DailyRender;
		}
		
		protected override function getActiveBaseVo():ActiveBaseVo
		{
			var bvo:ActivityBasicVo = _list.selectedItem.vo;
			var vec:Vector.<RaidRewardShowVo>=RaidRewardShowManager.Instance.getRewardShowVoByIdAndType(TypeRewardShow.TypeActivity,bvo.active_id);
			var activeBaseVo:ActiveBaseVo=new ActiveBaseVo;
			activeBaseVo.desc=bvo.activity_desc;
			activeBaseVo.expStar=bvo.exp_star;
			activeBaseVo.moneyStar=bvo.money_star;
			activeBaseVo.propsStar=bvo.props_star;
			if(vec)
			{
				var i:int,len:int=vec.length;
				for(i=0;i<len;i++)
				{
					var reward:ActiveBaseRewardVo=new ActiveBaseRewardVo;
					reward.id=vec[i].itemId;
					reward.type=vec[i].rewardType;
					activeBaseVo.rewards.push(reward);
				}
			}
			return activeBaseVo;
		}
		
		/**任务排序
		 * @param x
		 * @param y
		 * @return 
		 */		
		private function sortFunc(x:ActivityBasicVo,y:ActivityBasicVo):int{
//			var taskBasicVoX:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(Task_libBasicManager.Instance.getTask_libBasicVoByLoopId(x.loop_id).task_id);
//			var taskBasicVoY:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(Task_libBasicManager.Instance.getTask_libBasicVoByLoopId(y.loop_id).task_id);
//			var taskDyVoX:TaskDyVo = TaskDyManager.getInstance().getTaskDyVoByLoopId(x.loop_id);
//			var taskDyVoY:TaskDyVo = TaskDyManager.getInstance().getTaskDyVoByLoopId(y.loop_id);
//			
//			var lv:int = DataCenter.Instance.roleSelfVo.roleDyVo.level;
//			if(lv>=x.lowest_lv && lv<=x.highest_lv && taskDyVoX!=null){
//				if(taskDyVoY==null || lv<y.lowest_lv || lv>y.highest_lv)	return -1;
//			}else if(lv<x.lowest_lv || lv>x.lowest_lv){
//				if(taskDyVoY==null && lv>=y.lowest_lv && lv<=y.highest_lv)	return -1;
//				else if(lv>=y.lowest_lv && lv<=y.highest_lv)	return 1;
//			}else if(taskDyVoX==null && lv>=x.lowest_lv && lv<=x.highest_lv){
//				if(taskDyVoY!=null)	return 1;
//			}
//			if(x.lowest_lv<y.lowest_lv)	return -1;
//			else if(x.lowest_lv>y.lowest_lv)	return 1;
//			else{
//				if(taskBasicVoX.task_id>taskBasicVoY.task_id)	return -1;
//				else return 1;
//			}
			return -1;
		}
		
		/**切换更新
		 */		
		public override function onTabUpdate():void{
			_list.removeAll();
			
			var item:ListItem;
			
			var arr:Array = ActivityBasicManager.Instance.getActivityTypes();
			var activityList:Array = new Array();
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				var vo:ActivityBasicVo = ActivityBasicManager.Instance.getActivityBasicVo(arr[i]);
				if(vo!=null)	activityList.push(vo);
			}
			activityList.sort(sortFunc);
			len = activityList.length;
			for(i=0;i<len;i++){
				vo = ActivityBasicVo(activityList[i]);
				item = new ListItem();
				item.vo = vo;
				item.name = vo.active_name;
				item.lv = vo.min_level;
				item.activityNum = ActivityDyManager.instance.getActivityTimes(vo.active_type);
				item.activityLimit = vo.limit_times;
				item.timeDesc = vo.time_desc;
//				item.flyBootVo = new FlyBootVo();
//				var dict:Dictionary = Npc_ConfigBasicManager.Instance.getNPCList();
//				for each (var npcVo:Npc_ConfigBasicVo in dict){
//					if(npcVo.func_type1==3 && npcVo.func_id1==vo.groupId || npcVo.func_type2==3 && npcVo.func_id2==vo.groupId || npcVo.func_type3==3 && npcVo.func_id3==vo.groupId){
//						var posVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpcPosVoByNpcBasicId(npcVo.basic_id);
//						item.flyBootVo.mapX = posVo.pos_x;
//						item.flyBootVo.mapY = posVo.pos_y;
//						item.flyBootVo.mapId = posVo.scene_id;
//						item.flyBootVo.seach_id = posVo.npc_id;
//						item.npcId = posVo.basic_id;
//					}
//				}
				
				if(item.activityNum==item.activityLimit)	item.color=TypeProps.COLOR_GRAY;
				else if(DataCenter.Instance.roleSelfVo.roleDyVo.level<vo.min_level||DataCenter.Instance.roleSelfVo.roleDyVo.level>vo.max_level)
					item.color=TypeProps.COLOR_RED;
				else	item.color=TypeProps.COLOR_WHITE;
					
				_list.addItem(item);
				if(i==0)	_list.selectedItem = item;
			}
		}
	}
} 