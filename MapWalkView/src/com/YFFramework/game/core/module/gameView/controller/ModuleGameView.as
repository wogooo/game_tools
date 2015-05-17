package com.YFFramework.game.core.module.gameView.controller
{
	/**@author yefeng
	 * 2013 2013-3-25 下午5:20:58 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.MemberDyVo;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.pets.CSetPetFightAI;
	import com.msg.pets.PetResp;
	import com.msg.pets.SPetInfoResp;
	import com.msg.pets.SSetPetFightAI;
	import com.msg.pets.STakeBackPetReq;
	import com.msg.team_pro.SMemberChangeHpMp;
	import com.msg.team_pro.SMemberOffline;
	import com.msg.team_pro.SMemberOnline;
	import com.msg.team_pro.SPlayerLvChgNotify;
	import com.msg.team_pro.STeamInviteNotify;
	import com.net.MsgPool;
	import com.net.NetManager;
	
	public class ModuleGameView extends AbsModule
	{
		private var _gameView:GameView;
		public function ModuleGameView()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			_gameView=new GameView();
			addEvents();
			addSocketEvents();
		}
		/**处理事件
		 */		
		private function addEvents():void
		{
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGloableEvent);
			/// 人物转职成功后需要更新 更新人物图像
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onGloableEvent);

			
			///角色信息发生改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,onGloableEvent);
			///单击角色
			YFEventCenter.Instance.addEventListener(GlobalEvent.MouseClickOtherRole,onGloableEvent);
			/**删除角色
			 */ 
			RoleDyManager.Instance.addEventListener(RoleDyManager.DeleteRole,onDeleteRole);
			/**宠物相关
			 */ 
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetChange,onPetChange);			//宠物更新
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetHpChg,onPetChange);			//宠物更新
			YFEventCenter.Instance.addEventListener(PetEvent.AiModeReq,aiModeReq);				//宠物战斗属性改变请求
			//增加buff
			YFEventCenter.Instance.addEventListener(GlobalEvent.AddBuff,onGloableEvent);
			//删除buff
			YFEventCenter.Instance.addEventListener(GlobalEvent.DeleteBuff,onGloableEvent);
			///主角经验改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroExpChange,onGloableEvent);
			//打开邀请面板通知删除按钮
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveTeamInviteBtn,onOpenTeamInvite);
			//初始化组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.InitTeamIcons,onInitTeamIcon);
			//添加组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.AddTeamIcons,onAddTeamIcon);
			//刪除全部组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveAllTeamIcons,onRemoveAllTeamIcon);
			//刪除一個组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveTeamIcons,onRemoveTeamIcon);
			//刪除一個组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.SwitchTeamIcons,onSwitchTeamIcon);
			//显示“组”按钮
			YFEventCenter.Instance.addEventListener(GlobalEvent.DisplayTeamBtn,onDisplayTeamBtn);
		}
		/**  处理socket事件
		 */		
		private function addSocketEvents():void{
			MsgPool.addCallBack(GameCmd.SFightPetResp,PetResp,onFightPetResp);						//宠物出战回复
			MsgPool.addCallBack(GameCmd.STakeBackPetReq,STakeBackPetReq,onTakebackResp);			//宠物收回回复
			MsgPool.addCallBack(GameCmd.SSetPetFightAI,SSetPetFightAI,onAiModeResp);				//宠物战斗属性回复
			MsgPool.addCallBack(GameCmd.SPlayerLvChgNotify,SPlayerLvChgNotify,onMemberLvChgResp);   //队员等级改变回复
			MsgPool.addCallBack(GameCmd.SMemberChangeHpMp,SMemberChangeHpMp,onMemberHpMpChgResp);	//队员血量mp改变回复
			MsgPool.addCallBack(GameCmd.SMemberOffline,SMemberOffline,onMemberOfflineResp);			//队员离线回复
			MsgPool.addCallBack(GameCmd.SMemberOnline,SMemberOnline,onMemberOnlineResp);			//队员上线回复
		}
		
		private function onFightPetResp(msg:PetResp):void{
			_gameView.gameViewHandle.updateFightPet();
		}
		
		private function onTakebackResp(msg:STakeBackPetReq):void{
			_gameView.gameViewHandle.updateTakeBackPet();
		}
		
		/** 全局事件
		 */		
		private function onGloableEvent(e:YFEvent):void
		{
			var buffId:int=int(e.param);
			var roleDyVo:RoleDyVo;
			switch(e.type)
			{
				case GlobalEvent.AddBuff:
					//添加buff
					_gameView.gameViewHandle.updateAddBuff(buffId);
					break;
				case GlobalEvent.DeleteBuff:
					//删除buff
					_gameView.gameViewHandle.updateDeleteBuff(buffId);
					break;
				case GlobalEvent.HeroExpChange:
					//主角经验改变
					_gameView.gameViewHandle.updateHeroExp();
					break;
				//其他角色信息发生改变
				case GlobalEvent.RoleInfoChange:
					roleDyVo=e.param as RoleDyVo;
					_gameView.gameViewHandle.updateRoleInfo(roleDyVo);
					break;
				///鼠标单机其他角色
				case GlobalEvent.MouseClickOtherRole:
					roleDyVo=e.param as RoleDyVo;
					_gameView.gameViewHandle.showOtherRoleInfo(roleDyVo);
					break;
				case GlobalEvent.HeroChangeCareerSuccess:
					//转职成功
					_gameView.gameViewHandle.updateHeroImage();
					break;
				case GlobalEvent.GameIn:
					//进入游戏
					//更新经验
					_gameView.gameViewHandle.updateHeroExp();
					//更新图像
					_gameView.gameViewHandle.updateHeroImage();
					break;
			}
		}
		
		private function onDeleteRole(e:YFEvent):void
		{
			var deleteId:int=int(e.param);
			_gameView.gameViewHandle.deleteOtherRoleInfo(deleteId);
		}
		
		/**弹出组队按钮 
		 * @param e 收到的弹出组队按钮事件通知
		 */		
		private function onDisplayTeamBtn(e:YFEvent):void{
			_gameView.gameViewHandle.updateBtn("team");
		}
		
		/**移除组队按钮 
		 * @param e 收到的移除组队按钮事件通知
		 */	
		private function onOpenTeamInvite(e:YFEvent):void{
			_gameView.gameViewHandle.removeBtn("team");
		}

		/**宠物更改事件监听 
		 * @param e 收到的宠物更改事件通知
		 */		
		private function onPetChange(e:YFEvent):void{
			if(PetDyManager.Instance.getPetListSize()!=0){
				_gameView.gameViewHandle.addPetIconView();
				_gameView.gameViewHandle.updatePet(e.param as String);
			}else{
				_gameView.gameViewHandle.removePetIconView();
			}
		}
		
		/**宠物AI模式更改请求
		 * @param e 收到的宠物AI模式更改事件通知
		 */	
		private function aiModeReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CSetPetFightAI,(e.param) as CSetPetFightAI);
		}
		
		/**宠物AI模式更改回复
		 * @param msg 收到的协议
		 */	
		private function onAiModeResp(msg:SSetPetFightAI):void{
			PetDyManager.Instance.setAiMode(msg.fightAi);
			_gameView.gameViewHandle.updatePet("all");
		}
		
		/**初始化组队场景组件 
		 * @param e 收到的初始化组队场景组件事件通知
		 */		
		private function onInitTeamIcon(e:YFEvent):void{
			_gameView.gameViewHandle.initTeamMembers();
			_gameView.gameViewHandle.updateLeaderFlag();
		}
		
		/**添加组队场景组件 
		 * @param e 收到的添加组队场景组件事件通知
		 */	
		private function onAddTeamIcon(e:YFEvent):void{
			_gameView.gameViewHandle.addTeamMembers(e.param as int);
			_gameView.gameViewHandle.updateLeaderFlag();
		}
		
		/**移除全部组队场景组件 
		 * @param e 收到的移除全部组队场景组件事件通知
		 */		
		private function onRemoveAllTeamIcon(e:YFEvent):void{
			_gameView.gameViewHandle.removeAllTeamMembers();
			_gameView.gameViewHandle.updateLeaderFlag();
		}
		
		/**移除一个组队场景组件 
		 * @param e 收到的移除一个组队场景组件事件通知
		 */		
		private function onRemoveTeamIcon(e:YFEvent):void{
			_gameView.gameViewHandle.removeTeamMember(e.param as int);
			_gameView.gameViewHandle.updateLeaderFlag();
		}
		
		/**改变组队场景组件位置 
		 * @param e 收到的改变组队场景组件位置事件通知
		 */		
		private function onSwitchTeamIcon(e:YFEvent):void{
			_gameView.gameViewHandle.switchTeamMembers();
			_gameView.gameViewHandle.updateLeaderFlag();
		}
		
		/**队员等级更改通知 
		 * @param msg 收到的协议
		 */		
		private function onMemberLvChgResp(msg:SPlayerLvChgNotify):void{
			_gameView.gameViewHandle.updateMemberLv(msg.dyId,msg.level);
		}
		
		/**队员hp，mp改变通知
		 * @param msg 收到的协议 
		 */		
		private function onMemberHpMpChgResp(msg:SMemberChangeHpMp):void{
			TeamDyManager.Instance.getMemberDyVo(msg.dyId).hpPercent = msg.hpPercent/10000;
			TeamDyManager.Instance.getMemberDyVo(msg.dyId).mpPercent = msg.mpPercent/10000;
			_gameView.gameViewHandle.updateMemberHpMp(msg.dyId);
		}
		
		/**队员下线回复 
		 * @param msg 收到的协议
		 */		
		private function onMemberOfflineResp(msg:SMemberOffline):void{
			_gameView.gameViewHandle.offlineMemberIcon(msg.dyId);
		}
		
		/**队员上线回复 
		 * @param msg 收到的协议
		 */	
		private function onMemberOnlineResp(msg:SMemberOnline):void{
			_gameView.gameViewHandle.onlineMemberIcon(msg.dyId);
		}
	}
}