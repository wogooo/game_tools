package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.module.task.manager.TaskIDTargetVO;
	import com.YFFramework.game.core.module.task.manager.Task_dialogBasicManager;
	import com.YFFramework.game.core.module.task.model.Task_dialogBasicVo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 对话任务面板
	 *  中间对话任务  task_tagetBasicVo对话 中间对话任务
	 * @author yefeng
	 * 2013 2013-5-11 下午5:42:21 
	 */
	public class TaskDialogWindow extends NPCBaseWindow
	{
		public var closeCallBack:Function;
		private var _taskIDTargetVo:TaskIDTargetVO;
		public function TaskDialogWindow(npcid:int,taskIDTargetVO:TaskIDTargetVO)
		{
			_taskIDTargetVo=taskIDTargetVO;
			super(npcid);
			showNewGuide();//
		}
		
		
		override protected function initContent():void
		{
			_button.label="完成对话"
			var dialogBasicVo:Task_dialogBasicVo=Task_dialogBasicManager.Instance.getTask_dialogBasicVo(_taskIDTargetVo.targetBasicVO.tag_num);
			_richText.setText(dialogBasicVo.dialog);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addBgContainerAction();
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeBgContainerAction();
		}
		override protected function onBgContainerClick(e:MouseEvent):void
		{
			onButtonClick();
		}

		
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			closeCallBack(positionVo.npc_id);
		}
		override protected function onButtonClick(e:MouseEvent=null):void
		{
			var npcHandleVo:TaskNPCHandleVo=new TaskNPCHandleVo();
			npcHandleVo.npcDyId=positionVo.npc_id;
			npcHandleVo.taskId=_taskIDTargetVo.taskID;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_NpcDialogTask,npcHandleVo);
			close();
		}
		
	}
}