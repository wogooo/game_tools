package com.YFFramework.game.core.module.forge
{
	/**@author flashk
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.ForgeWindow;
	import com.YFFramework.game.core.module.forge.view.panel.EquipStrengthenPanel;
	import com.YFFramework.game.core.module.forge.view.panel.RemoveGemCOL;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideTaskManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.core.module.wing.event.WingEvent;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.lang.LangBasic;
	import com.msg.item.CBatchMergePropsReq;
	import com.msg.item.CEnhanceEquipReq;
	import com.msg.item.CEquipDecompReq;
	import com.msg.item.CEquipDeftLockReq;
	import com.msg.item.CEquipDeftReq;
	import com.msg.item.CEquipDeftUnLockReq;
	import com.msg.item.CEquipLevelUpReq;
	import com.msg.item.CInlayGemReq;
	import com.msg.item.CMergePropsReq;
	import com.msg.item.CRemoveGemReq;
	import com.msg.item.SEnhanceEquipRsp;
	import com.msg.item.SEqipLevelUpRsp;
	import com.msg.item.SEquipDecompRsp;
	import com.msg.item.SEquipDeftLockRsp;
	import com.msg.item.SEquipDeftRsp;
	import com.msg.item.SEquipDeftUnLockRsp;
	import com.msg.item.SInlayGemRsp;
	import com.msg.item.SMergePropsRsp;
	import com.msg.item.SModifyEquipEnhLevel;
	import com.msg.item.SModifyEquipGem;
	import com.msg.item.SRemoveGemRsp;
	import com.net.MsgPool;
	
	import flash.utils.getTimer;
	
	public class ForgeModule extends AbsModule
	{
		private var _window:ForgeWindow;
		private var _lastTime:int;
		private var _removeLastTime:int;

		public function ForgeModule()
		{
			_window = new ForgeWindow();
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function init():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.ForgeUIClick,onForgeClick);
			//打开对应界面
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_FORGE_PANEL,openForgePanel);
			
			//任务面包触发
			//打开装备升级面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.ForgeUIOpenForLevelUp,onForgeOpen);
			//打开装备强化面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.WeaponStrenthen,onForgeOpen);
			//打开宝石镶嵌面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.GemInlay,onForgeOpen);

			
			
			
			
			//装备强化回复，翅膀进化回复
			MsgPool.addCallBack(GameCmd.SEnhanceEquipRsp,SEnhanceEquipRsp,onSEnhanceEquipRsp);
			//镶嵌宝石回复
			MsgPool.addCallBack(GameCmd.SInlayGemRsp,SInlayGemRsp,onSInlayGemRsp);
			//修改装备：强化等级
			MsgPool.addCallBack(GameCmd.SModifyEquipEnhLevel,SModifyEquipEnhLevel,onSModifyEquipEnhLevel);
			//修改装备：镶嵌宝石
			MsgPool.addCallBack(GameCmd.SModifyEquipGem,SModifyEquipGem,onSModifyEquipGem);
			//宝石摘除回复
			MsgPool.addCallBack(GameCmd.SRemoveGemRsp,SRemoveGemRsp,onSRemoveGemRsp);
			//物品合成回复
			MsgPool.addCallBack(GameCmd.SMergePropsRsp,SMergePropsRsp,composeGemsResp);
			//装备分解回复
			MsgPool.addCallBack(GameCmd.SEquipDecompRsp,SEquipDecompRsp,equipDecompRsp);
			//装备进阶
			MsgPool.addCallBack(GameCmd.SEqipLevelUpRsp,SEqipLevelUpRsp,equipLevelUpRsp);
			/***************洗练**************/
			//装备洗练
			MsgPool.addCallBack(GameCmd.SEquipDeftRsp,SEquipDeftRsp,equipSophiResp);
			//装备洗练锁定
			MsgPool.addCallBack(GameCmd.SEquipDeftLockRsp,SEquipDeftLockRsp,equipSophiLockEquipResp);
			//装备洗练解锁
			MsgPool.addCallBack(GameCmd.SEquipDeftUnLockRsp,SEquipDeftUnLockRsp,equipSophiUnlockEquipResp);
		}
		
		private function onForgeClick(e:YFEvent):void{
			_window.switchOpenClose();
			if(_window.isOpen)
			{
				if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_ToClickEquip)  //升级装备
				{
					_window.openTab(2);
					NewGuideManager.DoGuide();
				}
				else 
				{
					_window.openTab(1);
				}
			}
		}
		
		/**打开锻造界面进行升级
		 */
		private function onForgeOpen(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.ForgeUIOpenForLevelUp:
					NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_MainUI;
					NewGuideManager.DoGuide();
					break;
				case GlobalEvent.WeaponStrenthen: //武器 强化
					_window.open();
					_window.openTab(1);
					break;
				case GlobalEvent.GemInlay: //宝石镶嵌
					_window.openTab(3);
					break;
			}
		}
		
		private function onSRemoveGemRsp(data:SRemoveGemRsp):void
		{
			var t:int = getTimer();
			//			if(t-_removeLastTime < 3000) return;//貌似有个cd
			_removeLastTime = t;
			
			var pos:int=data.equipPos;
			var equipDyVo:EquipDyVo;
			
			if(CharacterDyManager.Instance.getEquipInfoByPos(pos)){
				equipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(pos);
			}else{
				var itemDyVo:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(pos);
				equipDyVo = EquipDyManager.instance.getEquipInfo(itemDyVo.id);
			}
			equipDyVo.position = pos;
			
			var equipBasicVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
			if(equipBasicVo.type==TypeProps.EQUIP_TYPE_WINGS){
				YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveResp,data);
			}else{
				if(data.rsp == TypeProps.RSPMSG_SUCCESS)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1206,-1,RemoveGemCOL.gemNum);
					_window.removeGemCOL.updateAllList();
				}
				else
				{
					NoticeUtil.setOperatorNotice(LangBasic.removeFaild);
				}
			}
		}
		
		private function onSInlayGemRsp(msg:SInlayGemRsp):void
		{		
			var pos:int=msg.equipPos;
			var equipDyVo:EquipDyVo;

			if(CharacterDyManager.Instance.getEquipInfoByPos(pos)){
				equipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(pos);
			}else{
				var itemDyVo:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(pos);
				equipDyVo = EquipDyManager.instance.getEquipInfo(itemDyVo.id);
			}
			equipDyVo.position = pos;
			
			var equipBasicVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
			if(equipBasicVo.type==TypeProps.EQUIP_TYPE_WINGS){
//				if(msg.rsp == TypeProps.RSPMSG_SUCCESS){
//					NoticeManager.setNotice(NoticeType.Notice_id_1215);
//				}else{
//					NoticeManager.setNotice(NoticeType.Notice_id_1216);
//				}
				YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherResp,msg);
				//_window.wingFeather.onFeatherUpdate(equipDyVo);
			}
			else
			{
				if(msg.rsp == TypeProps.RSPMSG_SUCCESS) 
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1205);
				}
				else	
					NoticeManager.setNotice(NoticeType.Notice_id_1207);
			}
		}
		
//		/**翅膀进化请求
//		 * @param e
//		 */		
//		private function sendLvUpWing(e:YFEvent):void{
//			MsgPool.sendGameMsg(GameCmd.CEnhanceEquipReq,e.param as CEnhanceEquipReq);
//		}
		
		/**装备强化回复/翅膀进化回复
		 * @param data	收到的协议
		 */		
		private function onSEnhanceEquipRsp(msg:SEnhanceEquipRsp):void{		
			var equipDyVo:EquipDyVo;
			var equipBasicVo:EquipBasicVo;
			if(CharacterDyManager.Instance.getEquipInfoByPos(msg.pos)){
				equipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(msg.pos);
			}else{
				equipDyVo = EquipDyManager.instance.getEquipInfo(BagStoreManager.instantce.getPackInfoByPos(msg.pos).id);	
			}
			equipDyVo.position = msg.pos;
			equipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
			
			if(equipBasicVo.type==TypeProps.EQUIP_TYPE_WINGS)
			{
				YFEventCenter.Instance.dispatchEventWith(WingEvent.LvUpWingResp,msg);
//				if(data.rsp == TypeProps.RSPMSG_SUCCESS)	NoticeManager.setNotice(NoticeType.Notice_id_1217);
//				else	NoticeManager.setNotice(NoticeType.Notice_id_1218);
//				_window.wingLvUp.onLvUpUpdate(equipDyVo);
			}
			else//装备强化回复
			{
				_window.strengthenPanel.updateAllList();
				if(msg.rsp == TypeProps.RSPMSG_SUCCESS)//强化成功
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1201,-1,
						NoticeUtils.setColorText(EquipStrengthenPanel.equipName,EquipStrengthenPanel.quality),
						EquipStrengthenPanel.level+1);
					YFEventCenter.Instance.dispatchEventWith(FeedEvent.EquipStrength,EquipStrengthenPanel.level+1);
					if(_window.strengthenPanel.allStrengthenMode==true)
						_window.strengthenPanel.allStrengthenMode=false;
					equipDyVo.star=0;
				}					
				else
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1202);
					if(msg.addStar == 0)
						_window.strengthenPanel.allStrengthenMode=false;
					else
						equipDyVo.star += msg.addStar;					
					if(_window.strengthenPanel.allStrengthenMode==true)
						_window.strengthenPanel.oneStrengthen();
				}
				_window.strengthenPanel.updateStars();		
			}
		}
		
		private function onSModifyEquipGem(data:SModifyEquipGem):void
		{
			var vo:EquipDyVo = EquipDyManager.instance.getEquipInfo(data.equipId);
			vo.gem_1_id = data.gem_1Id;
			vo.gem_2_id = data.gem_2Id;
			vo.gem_3_id = data.gem_3Id;
			vo.gem_4_id = data.gem_4Id;
			vo.gem_5_id = data.gem_5Id;
			vo.gem_6_id = data.gem_6Id;
			vo.gem_7_id = data.gem_7Id;
			vo.gem_8_id = data.gem_8Id;
			
			if(_window.getTabIndex() == ForgeSource.INLAY_GEMS)
				_window.inlayGemCOL.updateAllList();
			
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.HasHeroEquip);
		}
		
		private function onSModifyEquipEnhLevel(data:SModifyEquipEnhLevel):void
		{
			var vo:EquipDyVo = EquipDyManager.instance.getEquipInfo(data.equipId);
			vo.enhance_level = data.enhanceLevel;
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.HasHeroEquip);
			
			//如果强化的是身上的装备且是紫装
			var bsVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
			if(EquipDyManager.instance.getEquipPosFromRole(vo.equip_id) > 0 && bsVo.quality >= TypeProps.QUALITY_PURPLE)
				YFEventCenter.Instance.dispatchEventWith(CharacterEvent.EquipStrengthLevelChange);
		}
		
//		private function onSEquipEnhanceTransRsp(data:SEquipEnhanceTransRsp):void
//		{
//			if(data.rsp == TypeProps.RSPMSG_SUCCESS)
//			{
//				NoticeManager.setNotice(NoticeType.Notice_id_1204);
//				_window.levelUp.updateAllList();
//			}
//			else
//			{
//				NoticeManager.setNotice(NoticeType.Notice_id_1208);
//			}
//		}
		
		/**
		 * 强化装备 
		 * @param pos 装备所在位置
		 * @param stoneNum 使用强化石数量
		 * 
		 */
		public function strengthenEquip(pos:int,stoneNum:int,stoneID:int):void
		{
			var msg:CEnhanceEquipReq = new CEnhanceEquipReq();
			msg.pos = pos;
			msg.stone = PropsDyManager.instance.getPropsPosArray(stoneID,stoneNum);
			MsgPool.sendGameMsg(GameCmd.CEnhanceEquipReq,msg);
		}
		
		/**
		 * 镶嵌宝石 
		 * @param equipPos
		 * @param inlayPos
		 * @param gemPos
		 * 
		 */
		public function inlayGem(equipPos:int,inlayPos:int,gemPos:int):void
		{
			var msg:CInlayGemReq = new CInlayGemReq();
			msg.equipPos = equipPos;
			msg.inlayPos = inlayPos+1;
			msg.gemPos = gemPos;
			MsgPool.sendGameMsg(GameCmd.CInlayGemReq,msg);
		}
		
		public function removeGem(equopPos:int,gemPos:int):void
		{
			var msg:CRemoveGemReq = new CRemoveGemReq();
			msg.equipPos = equopPos;
			msg.inlayPos = gemPos+1;
			MsgPool.sendGameMsg(GameCmd.CRemoveGemReq,msg);
		}
		
		public function composePropsReq(formId:int,materialAry:Array):void
		{
			var msg:CMergePropsReq=new CMergePropsReq();
			msg.formId=formId;
			msg.material=materialAry;
			MsgPool.sendGameMsg(GameCmd.CMergePropsReq,msg);
		}
		
		public function composeAllPropsReq(formId:int,materialAry:Array):void
		{
			var msg:CBatchMergePropsReq=new CBatchMergePropsReq();
			msg.formId=formId;
			msg.material=materialAry;
			MsgPool.sendGameMsg(GameCmd.CBatchMergePropsReq,msg);
		}
		
		private function composeGemsResp(msg:SMergePropsRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_FAIL)
				NoticeManager.setNotice(NoticeType.Notice_id_1213);
			else if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1214);
			}
			_window.composeCOL.composeGemRsp();
		}
		
		public function equipDecompReq(posAry:Array):void
		{
			var msg:CEquipDecompReq=new CEquipDecompReq();
			msg.pos=posAry;
			MsgPool.sendGameMsg(GameCmd.CEquipDecompReq,msg);
		}
		
		private function equipDecompRsp(msg:SEquipDecompRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_FAIL)
				NoticeManager.setNotice(NoticeType.Notice_id_1219);
			else if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1220);
			}			
			_window.equipDisolveCOL.clearLeftPanel();
			
		}
		
		public function equipLevelUp(pos:int,items:Array):void
		{
			var msg:CEquipLevelUpReq=new CEquipLevelUpReq();
			msg.pos=pos;
			msg.stone=items;
			MsgPool.sendGameMsg(GameCmd.CEquipLevelUpReq,msg);
		}
		
		private function equipLevelUpRsp(msg:SEqipLevelUpRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1208);
//				trace('进阶失败！')
			}
			else if(msg.rsp == TypeProps.RSPMSG_PACK_FULL)
				NoticeManager.setNotice(NoticeType.Notice_id_302);
			else if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				_window.levelUp.showLevelUp();
//				var id:uint=setTimeout(function():void{
					NoticeManager.setNotice(NoticeType.Notice_id_1204);	
					var equipdy:EquipDyVo;
					if(msg.pos >=101)
					{
						var item:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(msg.pos);
						equipdy=EquipDyManager.instance.getEquipInfo(item.id);
					}
					else
					{
						equipdy=CharacterDyManager.Instance.getEquipInfoByPos(msg.pos);
					}		
					var preEquipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipdy.template_id); //升级前的装备
					///升级后 
					equipdy.template_id=msg.templateId;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EQUIP_LEVEL_UP,msg.pos);
					_window.levelUp.updateAllList();
					
					///处理新手引导  装备强化  获取  第2把武器
					var secondEquip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVoByIndex(DataCenter.Instance.roleSelfVo.roleDyVo.career,preEquipBasicVo.type,1);
					//如果 进阶后街的装备  等级  和 第二把武器 一样 表示   强化完成
					handleForageTask(equipdy.template_id,secondEquip.level);
					
//					clearTimeout(id);
//				},1200);
			}
		}
		
		
		/**处理强化任务  客户端处理   客户端模拟强化任务  
		 *  装备强化     将  template_id强化到  tagetlevel 等级   时候    且  该强化任务是主线任务的时候完成任务
		 */
		private function handleForageTask(template_id:int,tagetlevel:int):void
		{
			var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(template_id);
			if(equipBasicVo.level==tagetlevel)
			{
				// 如果所接的任务为装备升级任务
				var taskTagetBasicVo:Task_targetBasicVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo();
				var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskVo();
				if(taskTagetBasicVo&&taskDyVo)
				{
					if(taskTagetBasicVo.seach_type==TypeProps.TaskTargetType_WeaponLevelUp)  //当前 主线任务为装备升级时 进行处理  
					{
						//模拟对话任务进行完成
						NewGuideTaskManager.Instance.sendEvent(taskDyVo.taskID);
						NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_ToCloseForageWindow;
					//	NewGuideManager.DoGuide();
					}
				} 
			}

		}
		
		private function openForgePanel(e:YFEvent):void
		{
			var panelId:int=e.param as int;
			if(_window.isOpen == false)
			{
				_window.open();
				_window.openTab(panelId);
			}
			
		}
		
		public function equipSophiLockEquipReq(pos:int,attrType:int,items:Array):void
		{
			var msg:CEquipDeftLockReq=new CEquipDeftLockReq();
			msg.pos=pos;
			msg.attrId=attrType;
			msg.stone=items;
			MsgPool.sendGameMsg(GameCmd.CEquipDeftLockReq,msg);
		}
		
		private function equipSophiLockEquipResp(msg:SEquipDeftLockRsp):void
		{
//			trace("服务器返回：",TypeProps.getAttrName(msg.attrId),"锁定成功")
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				var index:int=changeEquipAttr(msg.attrId,true);
				_window.equipSophi.lockOrNotAttr(msg.attrId,true,index);
				_window.equipSophi.updateMaterialList();				
			}
			else
				NoticeUtil.setOperatorNotice("装备洗练锁定属性不成功");
		}
		
		public function equipSophiUnlockEquipReq(pos:int,attrType:int):void
		{
			var msg:CEquipDeftUnLockReq=new CEquipDeftUnLockReq();
			msg.pos=pos;
			msg.attrId=attrType;
			MsgPool.sendGameMsg(GameCmd.CEquipDeftUnLockReq,msg);
		}
		
		private function equipSophiUnlockEquipResp(msg:SEquipDeftUnLockRsp):void
		{
//			trace("服务器返回：",TypeProps.getAttrName(msg.attrId),"解锁成功")
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				var index:int=changeEquipAttr(msg.attrId,false);
				_window.equipSophi.lockOrNotAttr(msg.attrId,false,index);
			}
			else
				NoticeUtil.setOperatorNotice("装备洗练解锁属性不成功");
		}
		
		private function changeEquipAttr(attrId:int,lock:Boolean):int
		{
			var dyVo:EquipDyVo=_window.equipSophi.curEquipDyVo;
			var index:int=0
			if(attrId == dyVo.app_attr_t1)
			{
				dyVo.app_attr_lock1 = lock;
				index=0;
			}
			else if(attrId == dyVo.app_attr_t2)
			{
				dyVo.app_attr_lock2 = lock;
				index=1;
			}
			else if(attrId == dyVo.app_attr_t3)
			{
				dyVo.app_attr_lock3 = lock;
				index=2;
			}
			else if(attrId == dyVo.app_attr_t4)
			{
				dyVo.app_attr_lock4 = lock;
				index=3;
			}
			return index;
		}
		
		public function equipSophiReq(pos:int):void
		{
			var msg:CEquipDeftReq=new CEquipDeftReq();
			msg.pos=pos;
			MsgPool.sendGameMsg(GameCmd.CEquipDeftReq,msg);
		}
		
		private function equipSophiResp(msg:SEquipDeftRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				var dyVo:EquipDyVo=_window.equipSophi.curEquipDyVo;
				dyVo.app_attr_t1=msg.appAttrT1;
				dyVo.app_attr_t2=msg.appAttrT2;
				dyVo.app_attr_t3=msg.appAttrT3;
				dyVo.app_attr_t4=msg.appAttrT4;
				
				dyVo.app_attr_v1=Math.ceil(msg.appAttrV1);
				dyVo.app_attr_v2=Math.ceil(msg.appAttrV2);
				dyVo.app_attr_v3=Math.ceil(msg.appAttrV3);
				dyVo.app_attr_v4=Math.ceil(msg.appAttrV4);
				
				dyVo.app_attr_color1=msg.appAttrC1;
				dyVo.app_attr_color2=msg.appAttrC2;
				dyVo.app_attr_color3=msg.appAttrC3;
				dyVo.app_attr_color4=msg.appAttrC4;
				
				dyVo.app_attr_lock1=msg.appAttrL1;
				dyVo.app_attr_lock2=msg.appAttrL2;
				dyVo.app_attr_lock3=msg.appAttrL3;
				dyVo.app_attr_lock4=msg.appAttrL4;
				dyVo.deft_lock_num=msg.deftLockNum;
				_window.equipSophi.updateAllList();
			}
		}
		
	}
}