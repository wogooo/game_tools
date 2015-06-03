package com.YFFramework.game.core.module.mount.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.mount.events.MountEvents;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.YFFramework.game.core.module.mount.view.MountWindow;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.preview.event.PreviewEvent;
	import com.msg.hero.SUpdateMountLucky;
	import com.msg.mount_pro.*;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 下午1:41:19
	 * 
	 */
	public class MountModule extends AbsModule{
		
		private var _mountWindow:MountWindow;
		
		public function MountModule(){
			_mountWindow = new MountWindow();

		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);						//进入游戏   请求坐骑列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.MountUIClick,onMountUIClick);			//打开坐骑面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);					//背包更新通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);				//金钱更新通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_MOUNT_PANEL,onOpenPanel);			//打开坐骑对应面板
				
			YFEventCenter.Instance.addEventListener(MountEvents.DropMountReq,dropMountReq);				//丢弃坐骑请求
			YFEventCenter.Instance.addEventListener(MountEvents.FightMountReq,fightMountReq);			//坐骑出战请求
			YFEventCenter.Instance.addEventListener(MountEvents.TakebackMountReq,takebackMountReq);		//坐骑收回请求
			YFEventCenter.Instance.addEventListener(MountEvents.AddSoulReq,addSoulReq);					//坐骑附灵请求
			YFEventCenter.Instance.addEventListener(MountEvents.AddSoulConfirmReq,addSoulConfirmReq);	//坐骑附灵确认请求
			YFEventCenter.Instance.addEventListener(MountEvents.TransferReq,transferReq);				//坐骑转换请求
			YFEventCenter.Instance.addEventListener(MountEvents.EnhanceReq,enhanceReq);					//坐骑进阶请求
			YFEventCenter.Instance.addEventListener(PreviewEvent.CloseMount,onMountPreviewClose);       //坐骑预览关闭
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SMountList,SMountList,onMountListResp);						//坐骑列表回复
			MsgPool.addCallBack(GameCmd.SGetNewMount,SGetNewMount,onNewMountResp);					//获得新坐骑回复
			MsgPool.addCallBack(GameCmd.SMountFight,SMountFight,onFightMountResp);					//坐骑出战回复
			MsgPool.addCallBack(GameCmd.SDropMount,SDropMount,onDropMountResp);						//放生坐骑回复
//			MsgPool.addCallBack(GameCmd.SMountAddExp,SMountAddExp,onAddExpResp);					//坐骑添加经验回复
			
			MsgPool.addCallBack(GameCmd.SAdvanceMount,SAdvanceMount,onAdvanceResp);					//坐骑进阶回复
			MsgPool.addCallBack(GameCmd.SAddSoul,SAddSoul,onAddSoulResp);							//坐骑附灵回复
//			MsgPool.addCallBack(GameCmd.SAddSoulConfirm,SAddSoulConfirm,onAddSoulConfirmResp);		//坐骑附灵确认回复
//			MsgPool.addCallBack(GameCmd.SExchangeMount,SExchangeMount,onExgMountResp);				//坐骑转换回复
			MsgPool.addCallBack(GameCmd.STakebackMount,STakebackMount,onTakebackResp);				//坐骑收回回复
			MsgPool.addCallBack(GameCmd.SUpdateMountLucky,SUpdateMountLucky,onMountLucky);			//坐骑星运改变
		}
		
		/**坐骑星运改变回复
		 * @param msg
		 */	
		private function onMountLucky(msg:SUpdateMountLucky):void{
			CharacterDyManager.Instance.mountStarNum = Math.floor(msg.lucky/100);
			CharacterDyManager.Instance.mountLuckNum = msg.lucky%100;
			if(_mountWindow.isOpen && _mountWindow._tabs.nowIndex==2){
				_mountWindow.onTabChange();
			}
			if(msg.isLucky)
				_mountWindow.showLuckEff();
		}
		
		private function onOpenPanel(e:YFEvent):void{
			_mountWindow.popUpWindow(int(e.param));
		}
		
		//		/**坐骑进阶回复
		//		 * @param msg	收到的协议
		//		 */		
		//		private function onAddExpResp(msg:SMountAddExp):void{
		//			var mount:MountDyVo=MountDyManager.Instance.getMount(msg.mountId);
		//			mount.exp = msg.exp;
		//			if(msg.hasLevel){
		//				mount.level = msg.level;
		//				_mountWindow.onTabChange();
		//				NoticeUtil.setOperatorNotice("恭喜你，坐骑【"+MountBasicManager.Instance.getMountBasicVo(mount.basicId).mount_type+"】的阶数提升到"+mount.level+"阶");
		//				YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.HasMount);
		//			}else{
		//				_mountWindow.onTabChange();
		//			}
		//		}
		
		/**坐骑进阶回复 
		 * @param msg 
		 */
		private function onAdvanceResp(msg:SAdvanceMount):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				var vo:MountDyVo = MountDyManager.Instance.getMount(msg.mountId);
				vo.basicId = msg.newBasicId;
				_mountWindow.onTabChange();
				NoticeUtil.setOperatorNotice("恭喜你，坐骑进阶成功");
				YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.MountChange);
				_mountWindow.showLvEff();
			}
			_mountWindow.checkAutoEnhance();
		}
		
		/**坐骑进阶请求 
		 * @param e 收到的坐骑进阶请求事件通知
		 */
		private function enhanceReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAdvanceMount,(e.param) as CAdvanceMount);
		}
		
		/**坐骑转换请求 
		 * @param e 收到的坐骑转换请求事件通知
		 */
		private function transferReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CExchangeMount,(e.param) as CExchangeMount);
		}
		
		/**坐骑附灵请求 
		 * @param e 收到的坐骑附灵请求事件通知
		 */
		private function addSoulReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAddSoul,(e.param) as CAddSoul);
		}
		
		/**坐骑附灵确认请求 
		 * @param e 收到的坐骑附灵确认请求事件通知
		 */
		private function addSoulConfirmReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAddSoulConfirm,(e.param) as CAddSoulConfirm);
		}
		
		/**坐骑出战请求 
		 * @param e 收到的坐骑出战请求事件通知
		 */
		private function fightMountReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CMountFight,(e.param) as CMountFight);
		}
		
		/**坐骑收回请求 
		 * @param e 收到的坐骑收回请求事件通知
		 */
		private function takebackMountReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CTakebackMount,new CTakebackMount());
		}
		
		/**坐骑放生请求 
		 * @param e 收到的坐骑放生请求事件通知
		 */
		private function dropMountReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CDropMount,(e.param) as CDropMount);
		}
		
		/**背包改变通知
		 * @param e 收到的背包改变通知事件通知
		 */
		private function onBagChange(e:YFEvent):void{
			_mountWindow.onBagChange();
		}
		
		/**金钱改变通知
		 * @param e 收到的金钱改变通知事件通知
		 */
		private function onMoneyChange(e:YFEvent):void{
			_mountWindow.onMoneyChange();
		}
		
		/**坐骑收回回复
		 * @param msg	收到的协议
		 */
		private function onTakebackResp(msg:STakebackMount):void{
			MountDyManager.fightMountId=-1;
			_mountWindow.onTabChange();
		}
		
//		/**坐骑转换回复 
//		 * @param msg	收到的协议
//		 */		
//		private function onExgMountResp(msg:SExchangeMount):void{
//			MountDyManager.Instance.exgMount(msg.mainMountId,msg.deputyMountId);
//			_mountWindow.onTabChange();
//			NoticeUtil.setOperatorNotice("坐骑转换成功");
//		}
		

		
//		/**坐骑附灵确认回复
//		 * @param msg	收到的协议
//		 */
//		private function onAddSoulConfirmResp(msg:SAddSoulConfirm):void{
//			var mount:MountDyVo=MountDyManager.Instance.getMount(msg.mountId);
//			mount.addPhy=mount.tempAddArr[0];
//			mount.addStr=mount.tempAddArr[1];
//			mount.addAgi=mount.tempAddArr[2];
//			mount.addInt=mount.tempAddArr[3];
//			mount.addSpi=mount.tempAddArr[4];
//			mount.tempAddArr.splice(0);
//			_mountWindow.onTabChange();
//			NoticeUtil.setOperatorNotice("坐骑【"+MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getMount(msg.mountId).basicId).mount_type+"】附灵成功");
//		}
		
		/**坐骑附灵回复
		 * @param msg	收到的协议
		 */
		private function onAddSoulResp(msg:SAddSoul):void{
			var mount:MountDyVo=MountDyManager.Instance.getMount(msg.mountId);
//			mount.tempAddArr[0]=msg.addSoulAttr.physique;
//			mount.tempAddArr[1]=msg.addSoulAttr.strength;
//			mount.tempAddArr[2]=msg.addSoulAttr.agility;
//			mount.tempAddArr[3]=msg.addSoulAttr.intelligence;
//			mount.tempAddArr[4]=msg.addSoulAttr.spirit;
			var bvo:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
			
//			mount.physiqueTemp = msg.mountAddAttr.physique - bvo.physique;
//			mount.strengthTemp = msg.mountAddAttr.strength - bvo.strength;
//			mount.intellTemp = msg.mountAddAttr.intelligence - bvo.intell;
//			mount.agilityTemp = msg.mountAddAttr.agility - bvo.agility;
//			mount.spiritTemp = msg.mountAddAttr.spirit - bvo.spirit;
			
			mount.addPhy = msg.mountAddAttr.physique;
			mount.addStr = msg.mountAddAttr.strength;
			mount.addAgi = msg.mountAddAttr.agility;
			mount.addInt = msg.mountAddAttr.intelligence;
			mount.addSpi = msg.mountAddAttr.spirit;
//			mount.physique = msg.mountAttr.physique;
//			mount.strength = msg.mountAttr.strength;
//			mount.agility = msg.mountAttr.agility;
//			mount.intell = msg.mountAttr.intelligence;
//			mount.spirit = msg.mountAttr.spirit;
			
			_mountWindow.onTabChange();
			
			mount.physiqueTemp = -1;
			mount.strengthTemp = -1;
			mount.intellTemp = -1;
			mount.agilityTemp = -1;
			mount.spiritTemp = -1;
			NoticeUtil.setOperatorNotice("坐骑【"+MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getMount(msg.mountId).basicId).mount_type+"】获得附灵属性");
		}
	
		/**放生坐骑回复
		 * @param msg	收到的协议
		 */
		private function onDropMountResp(msg:SDropMount):void{
			NoticeUtil.setOperatorNotice("坐骑【"+MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getMount(msg.mountId).basicId).mount_type+"】被放生了");
			MountDyManager.Instance.dropMount(msg.mountId);
			MountDyManager.Instance.initCrtMountId();
			if(MountDyManager.fightMountId==msg.mountId)	MountDyManager.fightMountId=-1;
			_mountWindow.onTabChange();
		}
		
		/**获得坐骑回复
		 * @param msg	收到的协议
		 */
		private function onNewMountResp(msg:SGetNewMount):void{
			MountDyManager.crtMountId = msg.mountInfo.mountId;
			MountDyManager.Instance.addMount(msg.mountInfo);
			_mountWindow.onTabChange();
			//NoticeUtil.setOperatorNotice("获得新坐骑【"+MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getMount(msg.mountInfo.mountId).basicId).mount_type+"】");
			var bvo:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(msg.mountInfo.basicId);
			NoticeManager.setNotice(NoticeType.Notice_id_1101,-1,DataCenter.Instance.roleSelfVo.roleDyVo.roleName,bvo.mount_type,bvo.mount_type);
//			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.HasMount);
		}
		
		/**坐骑出战回复
		 * @param msg	收到的协议
		 */
		private function onFightMountResp(msg:SMountFight):void{
			MountDyManager.Instance.updateFight(msg.mountId);
			_mountWindow.onTabChange();
			
			
			if(NewGuideStep.MountGuideStep!=-1)
			{
				NewGuideStep.MountGuideStep=NewGuideStep.MountWindowRectCloseBtn;
				NewGuideManager.DoGuide();
			}
		}

		/**坐骑列表回复
		 * @param msg	收到的协议
		 */
		private function onMountListResp(msg:SMountList):void{
			MountDyManager.fightMountId = msg.fightMountId;
			MountDyManager.isRiding = msg.isMount;
			var len:int=msg.mountInfoArr.length;
			for(var i:int=0;i<len;i++){
				MountDyManager.Instance.addMount(msg.mountInfoArr[i]);
			}
			MountDyManager.Instance.initCrtMountId();
		}
		
		/**登陆时候获取申请
		 * @param e 收到的登陆时候获取申请事件通知
		 */	
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CMountList,new CMountList());
		}
		
		/**打开坐骑面板 
		 * @param e 收到的打开坐骑面板事件通知
		 */		
		private function onMountUIClick(e:YFEvent):void{
			_mountWindow.switchOpenClose();
			if(_mountWindow.isOpen)	
			{
				_mountWindow.onOpen();
				///
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
				{
					if(NewGuideStep.MountGuideStep==NewGuideStep.MountWindowRectFightBtn)
					{
						NewGuideManager.DoGuide();
					}
				}
			}
		}
		
		private function onMountPreviewClose(e:YFEvent):void
		{
			_mountWindow.closePreview();
		}
		
	}
} 