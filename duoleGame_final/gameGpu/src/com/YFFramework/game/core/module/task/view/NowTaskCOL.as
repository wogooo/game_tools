package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.manager.Task_loopBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_run_ringsBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_loopBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_run_ringsBasicVo;
	import com.YFFramework.game.debug.Debug;
	import com.YFFramework.game.debug.Log;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.TaskType;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 任务窗口当前任务控制 
	 * @author flashk
	 * 
	 */
	public class NowTaskCOL extends TaskCOLBase
	{
		private var _richSp:RichTextSprite;
		
		public function NowTaskCOL(target:Sprite)
		{
			super(target);
			_richSp = new RichTextSprite();
			_richSp.isAddSpace = false;
			_richSp.x = _targetRichText.x;
			_richSp.y = _targetRichText.y;
			_ui.addChild(_richSp);
			if(_targetRichText.parent){
				_targetRichText.parent.removeChild(_targetRichText);
			}
		}
		
		override protected function setRichTextInfo():void
		{
			_richSp.clear();
			TaskViewAndOperate.getInstance().viewOneNowTask(_richSp,TaskDyManager.getInstance().getCurrentTaskDyVo(_nowSelectVO.task_id));
		}
		
		public function updateTaskList(vos:Vector.<TaskDyVo>):void
		{
			cleanTree();
			addAll(vos);
			_tree.selectNextAbleSelect();
		} 
		
		override protected function addOneTaskVO(vo:TaskDyVo):void 
		{
			 
		}
		
		override protected function cleanTree():void
		{
			super.cleanTree();
			_richSp.clear();
		}
		
		override protected function onTreeSelectChange(event:Event):void
		{
			super.onTreeSelectChange(event);
			if(_nowSelectVO.can_give_up == 1){
				_cannelButton.visible = true;
				_cannelButton.y = _cannelButtonY;
			}else{
				_cannelButton.visible = false;
			}
			var vo:TaskDyVo = TaskDyManager.getInstance().getTaskVOByBasicVO(_nowSelectVO);
			if(_nowSelectVO.task_type == TaskType.TASK_TYPE_LOOP && vo )
			{
				if(vo.loopId!=-1)
				{
					var loopVO:Task_loopBasicVo = Task_loopBasicManager.Instance.getTask_loopBasicVo(vo.loopId);
					if(loopVO)
					{
						_stateTxt.text = vo.curProgress+"/"+loopVO.total_times+"(剩余"+vo.remainTimes+")";
						Xtip.registerTip(_stateTxt,"循环任务链进度");
					}
				}
				if(vo.run_rings_id>0)  //跑环任务
				{
					var task_run_ringBasicVo:Task_run_ringsBasicVo = Task_run_ringsBasicManager.Instance.getTask_run_ringsBasicVo(vo.run_rings_id);
					if(task_run_ringBasicVo)
					{
						_stateTxt.text = vo.run_Progress+"/"+task_run_ringBasicVo.run_limit+"(剩余"+vo.run_remain+")";
						Xtip.registerTip(_stateTxt,"跑环任务链进度");
					}
				}
			}
			else
			{
				_stateTxt.text = "";
				Xtip.clearTip(_stateTxt);
			}
		}
		
	}
}