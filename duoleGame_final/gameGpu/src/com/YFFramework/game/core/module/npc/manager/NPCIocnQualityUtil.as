package com.YFFramework.game.core.module.npc.manager
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	
	import flash.display.MovieClip;

	/**根据 任务品质 获取对应的任务小图标
	 * @author yefeng
	 * 2013 2013-6-19 上午11:42:28 
	 */
	public class NPCIocnQualityUtil
	{
		public function NPCIocnQualityUtil()
		{
		}
		
		/** 根据任务品质和状态获取对应的图标
		 * @param state 任务状态
		 * @param quality  品质
		 */		
		public static  function getTaskItemMC(state:int,quality:int,npcTalkType:int=0):MovieClip
		{
			var mc:MovieClip;
			switch(state)
			{
				case TaskState.ACCEPT: //可接任务状态
					mc=ClassInstance.getInstance("common_yellow_kejie");  ///存储在 common包里面
//					if(TypeProps.TaskQuality_White)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Green)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Blue)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Purple)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Orange)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Red)
//					{
//						
//					}
					break;
				case TaskState.FINISH://完成Rt
					mc=ClassInstance.getInstance("common_yellow_kewancheng");
//					if(TypeProps.TaskQuality_White)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Green)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Blue)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Purple)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Orange)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Red)
//					{
//						
//					}
					break;
				case TaskState.PROGRESS: //进行 中
					if(npcTalkType!=TypeProps.TaskTargetType_NPCDialog)	mc=ClassInstance.getInstance("common_task_jinxingzhong");
					else mc=ClassInstance.getInstance("common_yellow_kewancheng");
//					if(TypeProps.TaskQuality_White)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Green)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Blue)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Purple)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Orange)
//					{
//						
//					}
//					else if(TypeProps.TaskQuality_Red)
//					{
//						
//					}
					break;
			}
			return mc;
		}
	}
}