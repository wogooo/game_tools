package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.module.npc.model.NPCTaskWindowVo;
	import com.YFFramework.game.core.module.npc.model.TaskRewardVo;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	import com.YFFramework.game.core.module.task.manager.EquipIDManager;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**接收任务面板   第二级  打开的 实际接受任务的面板
	 * @author yefeng
	 * 2013 2013-5-10 下午2:50:05 
	 */
	public class TaskHandleWindow extends NPCBaseWindow
	{
//		private static const MyGlowFilter:GlowFilter=new GlowFilter(0xFF0000,1,10,10);
		public var closeCallBack:Function;
		private var _taskBasicVo:TaskBasicVo;
		/**任务状态
		 */		
		private var taskState:int; 
		private var _npcTaskWindowVo:NPCTaskWindowVo;
		
		
		/**奖励容器
		 */		
		private var _rewardContainer:AbsView;
		
		private var iconContainer:HContainer
		
		private var _isSend:Boolean=false;
		public function TaskHandleWindow(npcTaskWindowVo:NPCTaskWindowVo)
		{
			_npcTaskWindowVo=npcTaskWindowVo;
			_taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(npcTaskWindowVo.taskId);
			super(npcTaskWindowVo.npcDyId);
			showNewGuide();
		}
		override protected function addEvents():void
		{
			super.addEvents();
			addBgContainerAction();
			addEventListener(MouseEvent.CLICK,onBgContainerClick);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeBgContainerAction();
			removeEventListener(MouseEvent.CLICK,onBgContainerClick);
		}
		override protected function onBgContainerClick(e:MouseEvent):void
		{
			onButtonClick();
		}
		/**初始化背景
		 */		
		override protected function initBgContainer():void
		{
			bgContainer=new AbsView();
			addChild(bgContainer);
//			var dialogbg:AbsView=new AbsView(false);
			_bgDialogBitmap=new Bitmap();
			var rewardLineBg:AbsView=new AbsView(false);
			bgContainer.addChild(_bgDialogBitmap);
			bgContainer.addChild(rewardLineBg);
			rewardLineBg.x=225;
			rewardLineBg.y=115;
			loadDialogBg();
		}
		
		/**初始化内容
		 */		
		override protected function initContent():void
		{
			taskState=TaskDyManager.getInstance().getTaskState(_taskBasicVo.task_id);
			switch(taskState)
			{
				case TaskState.ACCEPT://可接		
					_button.label="接受任务";
					_richText.setText(_taskBasicVo.accept_dialog,exeFunc);
					initReward();
					break;
				case TaskState.PROGRESS://进行中		
					_button.label="继续任务";
					_richText.setText(_taskBasicVo.undone_dialog,exeFunc);
					initReward();
					break;
				case TaskState.FINISH://可接		
					_button.label="完成任务";
					_richText.setText(_taskBasicVo.complete_dialog,exeFunc);
					initReward();
					break;
			}
		}
		override public function close(event:Event=null):void
		{
			super.close(event);
			closeCallBack(positionVo.npc_id);
		}
		/** 初始化  奖励面板
		 */		
		private function initReward():void
		{
			_rewardContainer=new AbsView(false);
			addChild(_rewardContainer);
			_rewardContainer.x=240;
			_rewardContainer.y=150;
			var txtContainer:HContainer=new HContainer(20,false);
			txtContainer.mouseChildren=txtContainer.mouseEnabled=false;
			_rewardContainer.addChild(txtContainer);
			iconContainer=new HContainer(10,false);
			_rewardContainer.addChild(iconContainer);
			iconContainer.y=23;
			var txt:TextField;
			var str:String="";
			var rewardsArr:Vector.<Task_rewardBasicVo>=Task_rewardBasicManager.Instance.getTaskRewards(_taskBasicVo.task_reward_id);
			var taskRewardIcon:TaskRewardIconView;
			var taskIconVo:TaskRewardVo;
			for each(var taskRewardBasicVo:Task_rewardBasicVo in rewardsArr)
			{
				switch(taskRewardBasicVo.rw_type) //装备
				{
					case RewardTypes.EQUIP: //装备
						taskIconVo=new TaskRewardVo();
						taskIconVo.basicId=EquipIDManager.getCareerEquipID(taskRewardBasicVo.rw_id);//taskRewardBasicVo.rw_id;
						taskIconVo.type=taskRewardBasicVo.rw_type;
						taskIconVo.num=taskRewardBasicVo.rw_num;
						taskRewardIcon=new TaskRewardIconView(taskIconVo);
						iconContainer.addChild(taskRewardIcon);
						
						break;
					case RewardTypes.PROPS: //道具
						taskIconVo=new TaskRewardVo();
						taskIconVo.basicId=taskRewardBasicVo.rw_id;
						taskIconVo.type=taskRewardBasicVo.rw_type;
						taskIconVo.num=taskRewardBasicVo.rw_num;
						taskRewardIcon=new TaskRewardIconView(taskIconVo);
						iconContainer.addChild(taskRewardIcon);
						break;
					case RewardTypes.EXP: // 经验
						txt=new TextField();
						str=HTMLUtil.setFont("经验奖励:  ","#FFFF00");
						str+=HTMLUtil.setFont(taskRewardBasicVo.rw_num+"","#FFFFFF");;
						txt.htmlText=str;
						txtContainer.addChild(txt);
						txt.selectable=false;
						txt.width=250;
						txt.width=txt.textWidth+15;
//						txt.filters=[MyGlowFilter];
						break;
					case RewardTypes.COUPON: //礼券
						txt=new TextField();
						str=HTMLUtil.setFont("礼券奖励:  ","#FFFF00");
						str+=HTMLUtil.setFont(taskRewardBasicVo.rw_num+"","#FFFFFF");;
						txt.htmlText=str;
						txtContainer.addChild(txt);
//						txt.filters=[MyGlowFilter];
						txt.width=250;
						txt.width=txt.textWidth+15;
						txt.selectable=false;
						break;
					case RewardTypes.SILVER: // 银币
						txt=new TextField();
						str=HTMLUtil.setFont("银币奖励:  ","#FFFF00");
						str+=HTMLUtil.setFont(taskRewardBasicVo.rw_num+"","#FFFFFF");;
						txt.htmlText=str;
						txtContainer.addChild(txt);
//						txt.filters=[MyGlowFilter];
						txt.selectable=false;
						txt.width=250;
						txt.width=txt.textWidth+15;
						break;
				}
			}
			txtContainer.updateView();
			iconContainer.updateView();
		}
		
		
		
		
		
		
		override protected function onButtonClick(e:MouseEvent=null):void
		{
			if(!_isSend)
			{
				var taskNpcVo:TaskNPCHandleVo=new TaskNPCHandleVo();
				taskNpcVo.npcDyId=positionVo.npc_id;
				taskNpcVo.taskId=_taskBasicVo.task_id;
				taskNpcVo.loopId=_npcTaskWindowVo.loopId;
				taskNpcVo.run_rings_id=_npcTaskWindowVo.run_rings_id;
 				switch(taskState)
				{
					case TaskState.ACCEPT://可接		
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestAcceptTask,taskNpcVo);
						break;
					case TaskState.FINISH://可完成		
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestFinishTask,taskNpcVo);
						initIconContainer();
						break;
				}
				super.onButtonClick(e);
				_isSend=true;
			}
		}
		
		/**初始化iconContainer
		 */
		private function initIconContainer():void
		{
			var len:int=iconContainer.numChildren;
			var taskRewardIcon:TaskRewardIconView;
			for(var i:int=0;i!=len;++i)
			{
				taskRewardIcon=(iconContainer.getChildAt(i) as TaskRewardIconView).clone();
				LayerManager.DisableLayer.addChild(taskRewardIcon);
				taskRewardIcon.doTween();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_rewardContainer&&_rewardContainer.parent)_rewardContainer.parent.removeChild(_rewardContainer);
			_rewardContainer.dispose();
			_rewardContainer=null;
			if(iconContainer.parent)iconContainer.parent.removeChild(iconContainer);
			iconContainer.dispose();
			iconContainer=null;
		}
				
	}
}