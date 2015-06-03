package com.YFFramework.game.core.module.activity.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseRewardVo;
	import com.YFFramework.game.core.module.activity.model.ActiveBaseVo;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.systemReward.view.IconCtrl;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.manager.Task_libBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_loopBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_libBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_loopBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-23 下午1:46:41
	 */
	public class TaskView extends ActiveViewBase
	{
		
		
		public function TaskView(mc:MovieClip){
			super(mc);
		}
		protected override function setRender():void
		{
			_list.itemRender=TaskRender;
		}
		protected override function getActiveBaseVo():ActiveBaseVo
		{
			var bvo:TaskBasicVo = _list.selectedItem.vo;
			var vec:Vector.<Task_rewardBasicVo> = Task_rewardBasicManager.Instance.getTaskRewards(bvo.task_reward_id);
			var temp:ActiveBaseVo=new ActiveBaseVo;
			temp.desc=bvo.description;
			temp.expStar=bvo.expStar;
			temp.moneyStar=bvo.moneyStar;
			temp.propsStar=bvo.propsStar;
			var i:int,len:int=vec.length;
			for(i=0;i<len;i++)
			{
				var reward:ActiveBaseRewardVo=new ActiveBaseRewardVo;
				reward.id=vec[i].rw_id;
				reward.type=vec[i].rw_type;
				temp.rewards.push(reward);
			}
			return temp;
		}
		
		
		/**任务排序
		 * @param x
		 * @param y
		 * @return 
		 */		
		private function sortFunc(x:Task_loopBasicVo,y:Task_loopBasicVo):int
		{
			var task_libBasicVo:Task_libBasicVo;
			task_libBasicVo=Task_libBasicManager.Instance.getTask_libBasicVoByLoopId(x.loop_id);
			var taskBasicVoX:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(task_libBasicVo.task_id);
			
			task_libBasicVo=Task_libBasicManager.Instance.getTask_libBasicVoByLoopId(y.loop_id);
			var taskBasicVoY:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(task_libBasicVo.task_id);
			var taskDyVoX:TaskDyVo = TaskDyManager.getInstance().getTaskDyVoByLoopId(x.loop_id);
			var taskDyVoY:TaskDyVo = TaskDyManager.getInstance().getTaskDyVoByLoopId(y.loop_id);
			
			var lv:int = DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(lv>=x.lowest_lv && lv<=x.highest_lv && taskDyVoX!=null){
				if(taskDyVoY==null || lv<y.lowest_lv || lv>y.highest_lv)	return -1;
			}else if(lv<x.lowest_lv || lv>x.lowest_lv){
				if(taskDyVoY==null && lv>=y.lowest_lv && lv<=y.highest_lv)	return -1;
				else if(lv>=y.lowest_lv && lv<=y.highest_lv)	return 1;
			}else if(taskDyVoX==null && lv>=x.lowest_lv && lv<=x.highest_lv){
				if(taskDyVoY!=null)	return 1;
			}
			if(x.lowest_lv<y.lowest_lv)	return -1;
			else if(x.lowest_lv>y.lowest_lv)	return 1;
			else{
				if(taskBasicVoX.task_id>taskBasicVoY.task_id)	return -1;
				else return 1;
			}
			return -1;
		}
		
		/**切换更新 
		 */		
		public override function onTabUpdate():void
		{
			_list.removeAll();
			
			var item:ListItem;
			var arr:Array = Task_loopBasicManager.Instance.getAllLoopVo();
			arr.sort(sortFunc);
			var len:int=arr.length;
			var bvo:Task_loopBasicVo;
			for(var i:int=0;i<len;i++){
				bvo = arr[i];
				item = new ListItem();
				item.lv = bvo.lowest_lv;
				var taskBasicVo:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(Task_libBasicManager.Instance.getTask_libBasicVoByLoopId(bvo.loop_id).task_id);
				item.name = taskBasicVo.name;
				var taskDyVo:TaskDyVo = TaskDyManager.getInstance().getTaskDyVoByLoopId(bvo.loop_id);
				if(taskDyVo!=null){
					item.taskNum = bvo.accept_limit-taskDyVo.remainTimes;
					item.color = TypeProps.COLOR_WHITE;
				}else{
					if(DataCenter.Instance.roleSelfVo.roleDyVo.level<bvo.lowest_lv){
						item.taskNum=0;
						item.color = TypeProps.COLOR_RED;
					}else{
						item.taskNum = bvo.accept_limit;
						item.color = TypeProps.COLOR_GRAY;
					}
				}
				item.taskLimit = bvo.accept_limit;
				item.flyBootVo = new FlyBootVo();
				var posVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpcPosVoByNpcBasicId(taskBasicVo.recv_npc_id);
				item.flyBootVo.mapX = posVo.pos_x;
				item.flyBootVo.mapY = posVo.pos_y;
				item.flyBootVo.mapId = posVo.scene_id;
				item.flyBootVo.seach_id = posVo.npc_id;
				item.npcId = posVo.basic_id;
				item.vo = taskBasicVo;
				_list.addItem(item);
				if(i==0)	_list.selectedItem = item;
			}
		}
	}
} 