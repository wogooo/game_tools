package com.YFFramework.game.core.module.gameView.controller
{
	/**@author yefeng
	 * 2013 2013-3-25 下午5:20:58 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.gameView.view.EffectHandle;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.hero.CSetHeroFightMode;
	import com.msg.hero.SAttackState;
	import com.msg.hero.SSetHeroFightMode;
	import com.msg.mount_pro.CRideMount;
	import com.msg.mount_pro.SMountList;
	import com.msg.mount_pro.SRideMount;
	import com.msg.pets.CSetPetFightAI;
	import com.msg.pets.PetResp;
	import com.msg.pets.SSetPetFightAI;
	import com.msg.pets.STakeBackPetReq;
	import com.msg.team_pro.SMemberChangeHpMp;
	import com.msg.team_pro.SMemberOffline;
	import com.msg.team_pro.SMemberOnline;
	import com.msg.team_pro.SPlayerLvChgNotify;
	import com.net.MsgPool;
	
	public class ModuleGameView extends AbsModule
	{
		private var _gameView:GameView;
		private var _effectHandler:EffectHandle;
		
		public function ModuleGameView()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			_gameView=new GameView();
			_effectHandler = new EffectHandle();
			addEvents();
			addSocketEvents();
		}
		/**处理事件
		 */		
		private function addEvents():void
		{
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGloableEvent);
			///角色信息发生改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,onGloableEvent);
			
			//其他人物、宠物、npc相关
			RoleDyManager.Instance.addEventListener(RoleDyManager.DeleteRole,onDeleteRole);
			YFEventCenter.Instance.addEventListener(GlobalEvent.MouseClickOtherRole,onGloableEvent);	///单击角色
			YFEventCenter.Instance.addEventListener(GlobalEvent.HideOtherRoleInfo,onDeleteRole2);	///隐藏角色图标

			
//			//宠物相关
//			YFEventCenter.Instance.addEventListener(GlobalEvent.PetChange,onPetChange);				//宠物更新
//			YFEventCenter.Instance.addEventListener(GlobalEvent.PetHpChg,onPetChange);				//宠物更新
//			YFEventCenter.Instance.addEventListener(PetEvent.AiModeReq,aiModeReq);					//宠物战斗属性改变请求
//			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroPetAddBuff,onPetAddBuff);		//宠物添加buff
//			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroPetDeleteBuff,onPetDelBuff);	//宠物删除buff
			
			//人物相关
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroAddBuff,onGloableEvent);			//增加buff
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroDeleteBuff,onGloableEvent);			//删除buff
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroExpChange,onGloableEvent);		//主角经验改变
			YFEventCenter.Instance.addEventListener(PKEvent.CFightModeChange,fightModeChangeReq);	//人物战斗模式改变请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onGloableEvent);// 人物转职成功后需要更新 更新人物图像
			
			//组队相关 
			YFEventCenter.Instance.addEventListener(GlobalEvent.InitTeamIcons,onInitTeamIcon);		//初始化组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.AddTeamIcons,onAddTeamIcon);		//添加组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveAllTeamIcons,onRemoveAllTeamIcon);	//刪除全部组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveTeamIcons,onRemoveTeamIcon);	//刪除一個组队组件
			YFEventCenter.Instance.addEventListener(GlobalEvent.SwitchTeamIcons,onSwitchTeamIcon);	//刪除一個组队组件
			
			//坐骑相关
			YFEventCenter.Instance.addEventListener(GlobalEvent.RideMountReq,rideMountReq);			//上马下马请求

			//弹出按钮相关
			YFEventCenter.Instance.addEventListener(GlobalEvent.DisplayBtn,onDisplayBtn);			//显示弹出按钮
			//显示好友弹出按钮
			YFEventCenter.Instance.addEventListener(GlobalEvent.DisplayFriendIcon,onDisplayFriendIconBtn);			//显示好友弹出按钮
			//移除场景好友弹出按钮
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveFriendIcon,onRemoveFriendIcon);

			
			YFEventCenter.Instance.addEventListener(GlobalEvent.RemoveEjectBtn,onRemoveEjectBtn);	//删除场景弹出按钮
			//切换场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onMapChange);	
			//npc 离开视野
			YFEventCenter.Instance.addEventListener(GlobalEvent.NPCExitView,onNPCExitView);
			//跳转到其他场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onMapChane);
			
			//主角升级
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLevelup);

		}
		/**
		 */
		private function onMapChane(e:YFEvent):void
		{
			_gameView.updateChangeMap();
		}
		/**删除  status
		 */		
		private function onNPCExitView(e:YFEvent):void
		{
			var deleteId:int=int(e.param);
			_gameView.gameViewHandle.deleteOtherRoleInfo(deleteId);
		}
		private function onDeleteRole(e:YFEvent):void
		{
			var deleteId:int=int(e.param);
			_gameView.gameViewHandle.deleteOtherRoleInfo(deleteId);
		}
		/**直接隐藏选中的角色的场景图标  角色顶部图标
		 */
		private function onDeleteRole2(e:YFEvent):void
		{
			_gameView.gameViewHandle.deleteOtherRoleInfo2();
		}
		
		/**切换场景
		 */		
		private function onMapChange(e:YFEvent):void
		{
			_gameView.gameViewHandle.updateMapChange();
		}
		/**  处理socket事件
		 */		
		private function addSocketEvents():void{
//			MsgPool.addCallBack(GameCmd.SFightPetResp,PetResp,onFightPetResp);						//宠物出战回复
//			MsgPool.addCallBack(GameCmd.STakeBackPetReq,STakeBackPetReq,onTakebackResp);			//宠物收回回复
//			MsgPool.addCallBack(GameCmd.SSetPetFightAI,SSetPetFightAI,onAiModeResp);				//宠物战斗属性回复
			MsgPool.addCallBack(GameCmd.SPlayerLvChgNotify,SPlayerLvChgNotify,onMemberLvChgResp);   //队员等级改变回复
			MsgPool.addCallBack(GameCmd.SMemberChangeHpMp,SMemberChangeHpMp,onMemberHpMpChgResp);	//队员血量mp改变回复
			MsgPool.addCallBack(GameCmd.SMemberOffline,SMemberOffline,onMemberOfflineResp);			//队员离线回复
			MsgPool.addCallBack(GameCmd.SMemberOnline,SMemberOnline,onMemberOnlineResp);			//队员上线回复
			MsgPool.addCallBack(GameCmd.SRideMount,SRideMount,onRideMountResp);						//坐骑上马下马回复
			MsgPool.addCallBack(GameCmd.SMountList,SMountList,onMountListResp);						//初始化是获取上马下马状态回复
			MsgPool.addCallBack(GameCmd.SSetHeroFightMode,SSetHeroFightMode,onFightModeChgResp);	//人物战斗模式改变回复
			MsgPool.addCallBack(GameCmd.SAttackState,SAttackState,onSAttackStateChange);			//战斗状态改变
		}
		
		/**进入战斗、离开战斗提示 
		 * @param msg
		 */		
		private function onSAttackStateChange(msg:SAttackState):void{
			DataCenter.Instance.roleSelfVo.isFight=msg.isFighting;
			_effectHandler.playFightState(msg.isFighting);
		}
		
		/** 全局事件
		 */
		private function onGloableEvent(e:YFEvent):void
		{
			var buffId:int=int(e.param);
			var roleDyVo:RoleDyVo;
			switch(e.type)
			{
				case GlobalEvent.HeroAddBuff://添加buff
					_gameView.gameViewHandle.updateAddBuff(buffId);	
					break;
				case GlobalEvent.HeroDeleteBuff://删除buff
					_gameView.gameViewHandle.updateDeleteBuff(buffId);
					break;
				case GlobalEvent.HeroExpChange://主角经验改变
					_gameView.gameViewHandle.updateHeroExp();
					break;
				case GlobalEvent.RoleInfoChange://其他角色信息发生改变
					roleDyVo=e.param as RoleDyVo;
					_gameView.gameViewHandle.updateRoleInfo(roleDyVo);
					break;
				case GlobalEvent.MouseClickOtherRole:///鼠标单机其他角色
					roleDyVo=e.param as RoleDyVo;
					_gameView.gameViewHandle.showOtherRoleInfo(roleDyVo);
					break;
				case GlobalEvent.HeroChangeCareerSuccess://转职成功
					
					_gameView.gameViewHandle.updateHeroImage();
					break;
				case GlobalEvent.GameIn://进入游戏,更新经验,更新图像
					_gameView.gameViewHandle.updateHeroExp();
					_gameView.gameViewHandle.updateHeroImage();
					_gameView.gameViewHandle.initHeroView();
					break;
			}
		}

		/**人物战斗模式改变请求 
		 * @param e	收到的人物战斗模式改变请求事件通知
		 */		
		private function fightModeChangeReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CSetHeroFightMode,(e.param) as CSetHeroFightMode);
		}
		
		
		/**人物战斗模式改变回复
		 * @param msg	收到的协议
		 */		
		private function onFightModeChgResp(msg:SSetHeroFightMode):void{
			DataCenter.Instance.roleSelfVo.pkMode = msg.fightMode;
			_gameView.gameViewHandle.updateHeroMode();
		}
		//更新等级
		private function onHeroLevelup(e:YFEvent):void
		{
			_gameView.gameViewHandle.updateHeroLevel()
		}
		
		/**
		 *显示弹出按钮 
		 * @param e	收到的显示弹出按钮事件通知
		 * 
		 */		
		private function onDisplayBtn(e:YFEvent):void{
			_gameView.gameViewHandle.updateBtn(e.param as String);
		}
		/**显示好友弹出按钮
		 */		
		private function onDisplayFriendIconBtn(e:YFEvent):void
		{
			var vo:PrivateTalkPlayerVo=e.param as PrivateTalkPlayerVo;
			_gameView.gameViewHandle.updateBtn(EjectBtnView.PrivateChat,vo);
		}
		/**移除场景好友弹出按钮
		 */		
		private function onRemoveFriendIcon(e:YFEvent):void
		{
			var vo:PrivateTalkPlayerVo=e.param as PrivateTalkPlayerVo;
			_gameView.gameViewHandle.removeBtn(EjectBtnView.PrivateChat,vo);
		}

		
		/**移除弹出按钮 
		 * @param e 收到的移除弹出按钮事件通知
		 */		
		private function onRemoveEjectBtn(e:YFEvent):void{
			_gameView.gameViewHandle.removeBtn((e.param) as String);
		}
		
//		/**宠物出战回复
//		 * @param msg	收到的协议
//		 */		
//		private function onFightPetResp(msg:PetResp):void{
//			_gameView.gameViewHandle.updateFightPet();
//		}
//		
//		/**宠物收回回复
//		 * @param msg	收到的协议
//		 */	
//		private function onTakebackResp(msg:STakeBackPetReq):void{
//			_gameView.gameViewHandle.updateTakeBackPet();
//		}
//
//		/**宠物更改事件监听 
//		 * @param e 收到的宠物更改事件通知
//		 */		
//		private function onPetChange(e:YFEvent):void{		
//			if(PetDyManager.Instance.getPetListSize()!=0){
//				_gameView.gameViewHandle.addPetIconView();
//				_gameView.gameViewHandle.updatePet(e.param as String);
//			}else{
//				_gameView.gameViewHandle.removePetIconView();
//			}
//		}
//		
//		/**宠物增加buff
//		 * @param e 收到的宠物增加buff事件通知
//		 */		
//		private function onPetAddBuff(e:YFEvent):void{
//			var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(e.param.petId);
//			if(!pet.containsBuffId(e.param.buffId)){
//				pet.buffIdArray.push(e.param.buffId);
//				_gameView.gameViewHandle.updatePetBuff();
//			}
//			pet.fightAttrs[TypeProps.EA_HEALTH] = RoleDyManager.Instance.getRole(e.param.petId).hp;
//			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
//			
//		}
//		
//		/**宠物删除buff
//		 * @param e 收到的宠物删除buff事件通知
//		 */
//		private function onPetDelBuff(e:YFEvent):void{
//			PetDyManager.Instance.getPetDyVo(e.param.petId).removeBuffId(e.param.buffId);
//			_gameView.gameViewHandle.updatePetBuff();
//		}
//		
//		/**宠物AI模式更改请求
//		 * @param e 收到的宠物AI模式更改事件通知
//		 */
//		private function aiModeReq(e:YFEvent):void{
//			MsgPool.sendGameMsg(GameCmd.CSetPetFightAI,(e.param) as CSetPetFightAI);
//		}
//		
//		/**宠物AI模式更改回复
//		 * @param msg 收到的协议
//		 */	
//		private function onAiModeResp(msg:SSetPetFightAI):void{
//			PetDyManager.aiMode=msg.fightAi;
//			_gameView.gameViewHandle.updatePet("all");
//		}
		
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
		
		/**请求上马或下马 
		 * @param e 收到的请求上马或下马事件通知
		 */		
		private function rideMountReq(e:YFEvent):void{
			if(MountDyManager.fightMountId!=-1){
				var msg:CRideMount = new CRideMount();
				if(MountDyManager.isRiding==true)	msg.isMount=false;
				else	msg.isMount=true;
				//YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RideMountReq,msg);
				MsgPool.sendGameMsg(GameCmd.CRideMount,msg);
			}else{
				NoticeUtil.setOperatorNotice("没有出战坐骑");
			}
		}
		
		/**坐骑上马下马回复 
		 * @param msg	收到的协议
		 */		
		private function onRideMountResp(msg:SRideMount):void{
			if(msg.errorCode==0){
				MountDyManager.isRiding=msg.isMount;
				//_gameView.onRideChange();
			}else if(msg.errorCode==TypeProps.RSPMSG_RIDE_FIGHTING){
				NoticeUtil.setOperatorNotice("战斗状态中无法上马");
			}else if(msg.errorCode==TypeProps.RSPMSG_RIDE_NOMOUNT){
				NoticeUtil.setOperatorNotice("没有出战坐骑");	
			}
		}
		
		/**获得坐骑列表回复 
		 * @param msg	收到的协议
		 */		
		private function onMountListResp(msg:SMountList):void{
			MountDyManager.isRiding = msg.isMount;
			//_gameView.onRideChange();
		}
	}
}