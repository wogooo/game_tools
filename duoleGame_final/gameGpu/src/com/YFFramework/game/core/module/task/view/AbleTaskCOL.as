package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_targetBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.debug.Debug;
	
	import flash.display.Sprite;

	/**
	 * 任务窗口可接任务控制 
	 * @author flashk
	 * 
	 */
	public class AbleTaskCOL extends TaskCOLBase
	{
		public function AbleTaskCOL(target:Sprite)
		{
			super(target);
		}
		
		public function updateAbleTask(vos:Vector.<TaskDyVo>):void
		{
			cleanTree();
			var len:int = vos.length;
			var taskBasicVo:TaskBasicVo;
			for(var i:int=0;i<len;i++){
				taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vos[i].taskID);
				taskBasicVo.loopID=vos[i].loopId;
				taskBasicVo.run_rings_id=vos[i].run_rings_id;
				addOneTask(taskBasicVo);
			}
			_tree.selectNextAbleSelect();
		}
		
		override protected function setRichTextInfo():void
		{
			_targetRichText.setText(_nowSelectVO.accept_desc,exeFunc,flyExeFunc); 
		}
		
		override protected  function exeFunc(obj:Object):void
		{
			TaskViewAndOperate.getInstance().ableTextUserClick(obj);
		}
		
		override protected  function flyExeFunc(obj:Object):void
		{
			TaskViewAndOperate.getInstance().flyExeFunc(obj);
		}
		
	}
}