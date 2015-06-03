package com.YFFramework.game.core.module.newGuide.manager
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;

	/**任务引导  通过对话任务模拟  装备强化    等等一系列的操作   
	 * @author yefeng
	 * 2013 2013-10-22 下午5:38:13 
	 */
	public class NewGuideTaskManager
	{
		private static var _instance:NewGuideTaskManager;
		public function NewGuideTaskManager()
		{
		}
		public static function get Instance():NewGuideTaskManager
		{
			if(!_instance)_instance=new NewGuideTaskManager();
			return  _instance;
		}
		/**模拟成对话任务
		 */
		public function sendEvent(taskId:int):void
		{
			//模拟对话任务进行完成
			var npcHandleVo:TaskNPCHandleVo=new TaskNPCHandleVo();
			npcHandleVo.taskId=taskId;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_NpcDialogTask,npcHandleVo);

		}
	}
}