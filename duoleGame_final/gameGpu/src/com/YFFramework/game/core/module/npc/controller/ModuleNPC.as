package com.YFFramework.game.core.module.npc.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.npc.events.NPCEvent;
	import com.YFFramework.game.core.module.npc.view.NPCView;
	import com.YFFramework.game.core.module.npc.view.WelcomeWindow;
	import com.YFFramework.game.core.module.sceneUI.view.CareerChangeWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CChangeCareer;
	import com.msg.mapScene.CNpcRequest;
	import com.msg.mapScene.SNpcRequest;
	import com.net.MsgPool;
	
	/**npc 任务相关模块     
	 * 2012-10-24 下午2:28:22
	 *@author yefeng
	 */
	public class ModuleNPC extends AbsModule
	{
		private var _npcView:NPCView;
		
		

		public function ModuleNPC()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_npcView=new NPCView();

		}
		override public function init():void
		{
			addEvents();
			addSocketCallback();
		}
		private function addEvents():void
		{
			/// socket 事件
			YFEventCenter.Instance.addEventListener(NPCEvent.TransferToPoint,onSendSocketEvent);  ///点击 NPC 对话 传送到指定点

			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			///npc离开场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.NPCExitView,onNPCExit);
			///主角选职业
//			YFEventCenter.Instance.addEventListener(NPCEvent.C_SelectCareer,selectCareer);

			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onChangeCarrerSuccess);
		}
			
		/**转职成功后的调用 */
		private function onChangeCarrerSuccess(e:YFEvent):void
		{
			//转职成功 发送完成任务事件
//			_npcView.careerChangeView.updateChangeCareerSuccess();
			var taskHandleVo:TaskNPCHandleVo=CareerChangeWindow.instance.taskHandleVo;
			if(taskHandleVo)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestFinishTask,taskHandleVo);
				CareerChangeWindow.instance.dispose();
			}		
		}
		private function onNPCExit(e:YFEvent):void
		{
			var npcId:int=int(e.param);
			_npcView.updateDeleteWindow(npcId);
		}
			
		private function onGameIn(e:YFEvent):void   
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
//			SourceCache.Instance.loadRes(CommonEffectURLManager.AcceptTaskEffect);
//			SourceCache.Instance.loadRes(CommonEffectURLManager.FinishTaskEffect);
			
			if(DataCenter.Instance.isFresh) //如果为新手  处于新手窗口
			{       
				var freshWindow:WelcomeWindow=new WelcomeWindow(); 
//				freshWindow.switchOpenClose();
				PopUpManager.addPopUp(freshWindow,LayerManager.PopLayer,0,0,0xFFFFFF,0.01,modalClick,freshWindow);
				PopUpManager.centerPopUpWidthWH(freshWindow,WelcomeWindow.Width,WelcomeWindow.Height);
			}
			//初始化新手引导 
			NewGuideManager.isInit=true;
//			//转职 判断
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=NewGuideManager.ChangeCareerLevel&&DataCenter.Instance.roleSelfVo.roleDyVo.career==TypeRole.CAREER_NEWHAND)
//			{
//				_npcView.popChangeCareerWindow();
//			}

		}
		private function modalClick(freshWindow:WelcomeWindow):void
		{
			freshWindow.onClick();
		}
		
		///发送 socket
		private function onSendSocketEvent(e:YFEvent):void
		{
			var data:Object=e.param;
			switch(e.type)
			{
				case NPCEvent.TransferToPoint:  ///传送到目标点
					var cNPCRequest:CNpcRequest=new CNpcRequest();
					cNPCRequest.funcId=data.funcId;
					cNPCRequest.funcType=data.funcType;
					cNPCRequest.npcId=data.npcDyId;
					MsgPool.sendGameMsg(GameCmd.CNpcRequest,cNPCRequest);
					break;
			}
		}
		private function addSocketCallback():void
		{
			MsgPool.addCallBack(GameCmd.SNpcRequest,SNpcRequest,onNpcCallback);
		}
		/** npc 回调
		 */		
		private function onNpcCallback(sNpcRequest:SNpcRequest):void
		{
			switch(sNpcRequest.code)
			{
				///成功 
				case RspMsg.RSPMSG_SUCCESS:
					print(this,"NPC请求成功");
					break;
				//失败
				case RspMsg.RSPMSG_FAIL:
					NoticeUtil.setOperatorNotice("请求失败");
					break;
			}
		}
		
		
		public function selectCareer(career:int):void
		{
			var cChangeCareer:CChangeCareer=new CChangeCareer();  ///转职结果的接受在场景模块ModuleMapScene
			cChangeCareer.newCareer=career;
			MsgPool.sendGameMsg(GameCmd.CChangeCareer,cChangeCareer);
		}

		
	}
}