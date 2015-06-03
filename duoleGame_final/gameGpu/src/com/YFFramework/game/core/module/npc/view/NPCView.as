package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.NPCTaskWindowVo;
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.sceneUI.view.CareerChangeWindow;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.manager.TaskIDTargetVO;
	import com.YFFramework.game.core.module.task.manager.Task_targetBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	
	import flash.utils.Dictionary;

	/**npc 处理
	 * 2012-10-24 下午2:30:52
	 *@author yefeng
	 */
	public class NPCView
	{
		
		/** 转职
		 */
//		public var careerChangeView:CareerChangeView;

		private var _windowDict:Dictionary;
		public function NPCView()
		{
			initUI();
			addEvents();
		}
		/** UI初始化
		 */		
		private function initUI():void
		{
			_windowDict=new Dictionary();
		}
		/**事件侦听
		 */		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.NPCClicker,onNPCClick);
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onMapChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SameMapChange,onMapChange); ///smallMap模块进行侦听
			
			//调试用
//			YFEventCenter.Instance.addEventListener(GlobalEvent.ShowSelectCareerWindowForDebug,onChangeCaerreDebug);
		}
		
//		private function onChangeCaerreDebug(e:YFEvent):void
//		{
//			popChangeCareerWindow(null);
//		}

		
		/**场景地图切换   清空窗口缓存
		 */		
		private function onMapChange(e:YFEvent):void
		{
			for each(var window:NPCBaseWindow in _windowDict)
			{
				window.dispose();
			}
			_windowDict=new Dictionary();
		}
		/**删除窗口
		 */		
		public function updateDeleteWindow(dyId:int):void
		{
			removeWindow(dyId);
		}
			
		/** npc click点击 触发事件 弹出相应的窗口
		 */		
		private function onNPCClick(e:YFEvent):void
		{
			var npcPositionId:int=int(e.param);
			////一个npc对应一个窗口
			var npcWindow:NPCBaseWindow;
			if(_windowDict[npcPositionId])
			{
				npcWindow=_windowDict[npcPositionId];
				npcWindow.open();
			}
			else
			{
				///判断  该 npc 是否有任务对话
				var taskIdTagetVo:TaskIDTargetVO=TaskDyManager.getInstance().getNPCDialogVO(npcPositionId);
				if(taskIdTagetVo) /// npc对话
				{
//					npcWindow=new TaskDialogWindow(npcPositionId,taskIdTagetVo);
//					TaskDialogWindow(npcWindow).closeCallBack=removeWindow;
//					_windowDict[npcPositionId]=npcWindow;
					handleNPCDialog(npcPositionId,taskIdTagetVo);
				}
				else  ////  进行接 任务  完成任务
				{
					var taskWindowVo:NPCTaskWindowVo=handleMainTrankTask(npcPositionId); //判断其是否有主线任务
					if(taskWindowVo)  //直接进入二级面板  接任务 或者完成任务
					{     
						if(taskWindowVo.taskId==NewGuideManager.ChangeCareerTaskId&&taskWindowVo.state==TaskState.FINISH)
						{
//							NoticeUtil.setOperatorNotice("弹出转职面板，待做???");
//							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ShowSelectCareerWindow);
							var taskNpcHandleVo:TaskNPCHandleVo=new TaskNPCHandleVo();
							taskNpcHandleVo.taskId=taskWindowVo.taskId;
							taskNpcHandleVo.loopId=taskWindowVo.loopId;
							taskNpcHandleVo.run_rings_id=taskWindowVo.run_rings_id;
							taskNpcHandleVo.npcDyId=taskWindowVo.npcDyId;
							popChangeCareerWindow(taskNpcHandleVo);
						}
						else 
						{
							handleTaskCall(taskWindowVo);
						}
						return ;
					}
					else    //第一级面板   具有选项卡
					{
//						npcWindow=new NpcWindow(npcPositionId,acceptTaskCall,handleTaskCall,progressTaskCall); //  弹出接受任务面板  完成任务面板
						npcWindow=new NpcWindow(npcPositionId,handleTaskCall,handleTaskCall,handleTaskCall); //  弹出接受任务面板  完成任务面板
						NpcWindow(npcWindow).windowCloseCall=removeWindow;
						_windowDict[npcPositionId]=npcWindow;
						npcWindow.open();
					}
				}
			}
			
		}
		
		/**处理 中间对话过程
		 * @param npcPositionId    npc唯一id 
		 * @param taskIdTagetVo    npc  任务对话处理数据vo 
		 */		
		private function handleNPCDialog(npcPositionId:int,taskIdTagetVo:TaskIDTargetVO):void
		{
			switch(taskIdTagetVo.targetBasicVO.seach_type)
			{
				case TypeProps.TaskTargetType_WeaponLevelUp:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ForgeUIOpenForLevelUp);  //打开锻造界面
					break;
				case TypeProps.TaskTargetType_OpenNewPack: //打开新手 礼包
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagPackOpenForOpenNewPack);  //打开新手 礼包   背包模块处理
					break;
				case TypeProps.TaskTargetType_WeaponStrengthen: //打开装备强化面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.WeaponStrenthen);  //打开装备强化面板
					break;
				case TypeProps.TaskTargetType_GemInlay: //打开宝石镶嵌面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GemInlay);  //打开宝石镶嵌面板
					break;
				case TypeProps.TaskTargetType_WingLevelUp: //打开翅膀进阶面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.WingLevelUp);  
					break;
				case TypeProps.TaskTargetType_OpenMall: //打开商城
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MallUIClick);  
					break;
				default:  //默认进行对话
					 
					if(taskIdTagetVo.targetBasicVO.seach_type==TypeProps.TaskTargetType_Stroy) //如果为旁白
					{
						var npcHandleVo:TaskNPCHandleVo=new TaskNPCHandleVo();
						var npcPostionVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcPositionId);
						npcHandleVo.npcDyId=npcPostionVo.npc_id;
						npcHandleVo.taskId=taskIdTagetVo.taskID;
						var storyShowVo:StoryShowVo=new StoryShowVo();
						storyShowVo.npcHandleVo=npcHandleVo;
						storyShowVo.id=taskIdTagetVo.targetBasicVO.seach_id;
						storyShowVo.storyPositionType=TypeStory.StoryPositionType_TaskDialog;
						YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,storyShowVo);
					}
					else //普通对话 
					{
						var npcWindow:NPCBaseWindow=new TaskDialogWindow(npcPositionId,taskIdTagetVo);
						TaskDialogWindow(npcWindow).closeCallBack=removeWindow;
						_windowDict[npcPositionId]=npcWindow;
						npcWindow.open();
					}
					break;
			}
		}
		
		
	
		
		
		
		
		
		
		/**判断其是否有主线任务
		 */		
		private function handleMainTrankTask(npcPosition:int):NPCTaskWindowVo
		{
			var npcTaskWindowVo:NPCTaskWindowVo;
			var positionVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcPosition);
			var _npcBasicVo:Npc_ConfigBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(positionVo.basic_id);
			var taskMainTrank:Vector.<TaskDyVo>=TaskDyManager.getInstance().getMainTrunkVoArr();  ///主线
			var mainTaskDyVo:TaskDyVo;
			for each(var taskDyVo:TaskDyVo in taskMainTrank)
			{
				if(!taskDyVo.isSubmit)
				{
					mainTaskDyVo=taskDyVo;
					break;
				}
			}
			
			if(mainTaskDyVo)  // 可以接受任务或者可以提交任务的 任务vo 
			{
				var cantriggger:Boolean=false;
				var taskState:int=TaskDyManager.getInstance().getTaskState(mainTaskDyVo.taskID);
				var taskBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(mainTaskDyVo.taskID);
				switch(taskState)
				{
					case TaskState.ACCEPT:
						if(taskBasicVo.recv_npc_id==_npcBasicVo.basic_id)
						{
							cantriggger=true;
						}
						break;
					case TaskState.FINISH:
						if(taskBasicVo.sub_npc_id==_npcBasicVo.basic_id)
						{
							cantriggger=true;
						}
						break;
				}
				if(cantriggger)
				{
					npcTaskWindowVo=NpcWindow.createNPCTaskWindowVo(positionVo,taskBasicVo,taskState);
				}
			}
			return npcTaskWindowVo;
		}
		
		/** 销毁该 面板
		 */	
		private function removeWindow(npcPositionId:int):void
		{
			var npcWindow:NPCBaseWindow=_windowDict[npcPositionId];	
			if(npcWindow)
			{
				npcWindow.dispose();
				_windowDict[npcPositionId]=null;
				delete _windowDict[npcPositionId];
			}
			StageProxy.Instance.setNoneFocus();
		}
		/**进行完成任务对话 关闭当前窗口 打开 完成任务对象窗口
		 */		
		private function handleTaskCall(npcTaskWindowVo:NPCTaskWindowVo):void
		{
			removeWindow(npcTaskWindowVo.npcDyId);
			var npcWindow:TaskHandleWindow=new TaskHandleWindow(npcTaskWindowVo);
			_windowDict[npcTaskWindowVo.npcDyId]=npcWindow;
			npcWindow.closeCallBack=removeWindow;
			npcWindow.open();

		}
//		/** 进行接受人物对话  关闭当前窗口，打开完成任务对象窗口
//		 */		
//		private function acceptTaskCall(npcTaskWindowVo:NPCTaskWindowVo):void
//		{
//			removeWindow(npcTaskWindowVo.npcDyId);
//			var npcWindow:TaskHandleWindow=new TaskHandleWindow(npcTaskWindowVo);
//			_windowDict[npcTaskWindowVo.npcDyId]=npcWindow;
//			npcWindow.closeCallBack=removeWindow;
//			npcWindow.open();
//		}
//		/** 任务进行中 的调用
//		 */		
//		private function progressTaskCall(npcTaskWindowVo:NPCTaskWindowVo):void
//		{
//			removeWindow(npcTaskWindowVo.npcDyId);
//			var npcWindow:TaskHandleWindow=new TaskHandleWindow(npcTaskWindowVo);
//			_windowDict[npcTaskWindowVo.npcDyId]=npcWindow;
//			npcWindow.closeCallBack=removeWindow;
//			npcWindow.open();
//		}		
		
		/** 弹出 选职业面板
		 */		
		public function popChangeCareerWindow(taskHandleVo:TaskNPCHandleVo):void
		{
//			if(careerChangeView)
//			{
//				if(careerChangeView.isDispose)
//				{
//					careerChangeView=new CareerChangeView(taskHandleVo);
//					careerChangeView.open();
//				}
//				else careerChangeView.open();
//			}
//			else 
//			{
//				careerChangeView=new CareerChangeView(taskHandleVo);
//				careerChangeView.open();
//			}
			CareerChangeWindow.instance.open();
			CareerChangeWindow.instance.taskHandleVo=taskHandleVo;			
		}

		
	}
}