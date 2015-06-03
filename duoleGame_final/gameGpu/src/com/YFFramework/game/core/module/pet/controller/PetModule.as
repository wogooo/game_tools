package com.YFFramework.game.core.module.pet.controller
{
	/**@author yefeng
	 *2012-8-21下午10:24:33
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.gameView.view.PetIconView;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.PetWindow;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.msg.chat.Channels;
	import com.msg.hero.SMagicSoulChange;
	import com.msg.pets.*;
	import com.msg.shop.CBuyItemReq;
	import com.msg.skill_pro.SFight;
	import com.net.MsgPool;
	
	public class PetModule extends AbsModule{
		
		private var _petWindow:PetWindow;
		/**主角的宠物 主界面UI*/		
		private var _petView:PetIconView;
		
		public function PetModule(){
			_petWindow=new PetWindow();
			_petView = new PetIconView();
			_petView.x=205;
			_petView.y=90;

		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);				//进入游戏   请求宠物列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUIClick,onPetUIClick);		//单击 打开宠物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChangeResp);		//背包改动通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_PET_PANEL,onOpen);				//打开面板请求
//			YFEventCenter.Instance.addEventListener(GlobalEvent.PetHpChg,onHpChg);				//宠物掉血回复
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChg);		//金钱改变通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroDead,onHeroDead);           //主角死亡
			
			YFEventCenter.Instance.addEventListener(PetEvent.OpenSlotReq,expandSlotReq);		//增加宠物栏请求
			YFEventCenter.Instance.addEventListener(PetEvent.RenameReq,renameReq);				//宠物改名请求
			YFEventCenter.Instance.addEventListener(PetEvent.CombineReq,combineReq);			//宠物融合请求
			YFEventCenter.Instance.addEventListener(PetEvent.InheritReq,inheritReq);			//宠物继承请求
			YFEventCenter.Instance.addEventListener(PetEvent.FightPetReq,fightPetReq);			//请求宠物出战请求
			YFEventCenter.Instance.addEventListener(PetEvent.TakeBackReq,takeBackReq);			//宠物收回请求
			YFEventCenter.Instance.addEventListener(PetEvent.ReleaseReq,dropReq);				//宠物放生请求
			YFEventCenter.Instance.addEventListener(PetEvent.QuickBuyReq,buyReq);				//快速购买道具请求
			YFEventCenter.Instance.addEventListener(PetEvent.ComprehendReq,comprehendReq);		//宠物领悟请求
			YFEventCenter.Instance.addEventListener(PetEvent.LearnReq,learnReq);				//学习技能请求
			YFEventCenter.Instance.addEventListener(PetEvent.ForgetSkillReq,forgetSkillReq);	//忘记技能请求
			YFEventCenter.Instance.addEventListener(PetEvent.SuccReq,succReq);					//宠物洗练请求
			YFEventCenter.Instance.addEventListener(PetEvent.SuccConfirmReq,succConfirmReq);	//宠物洗练确认请求
			YFEventCenter.Instance.addEventListener(PetEvent.AddPointReq,addPointReq);			//宠物加点请求
			YFEventCenter.Instance.addEventListener(PetEvent.ResetReq,resetReq);				//宠物洗点请求
			YFEventCenter.Instance.addEventListener(PetEvent.EnhanceReq,enhanceReq);			//宠物强化请求
			
			//宠物相关
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetChange,onPetChange);				//宠物更新
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetHpChg,onPetChange);				//宠物更新
			YFEventCenter.Instance.addEventListener(PetEvent.AiModeReq,aiModeReq);					//宠物战斗属性改变请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroPetAddBuff,onPetAddBuff);		//宠物添加buff
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroPetDeleteBuff,onPetDelBuff);	//宠物删除buff
			
			YFEventCenter.Instance.addEventListener(PetEvent.RefreshSkill,refreshSkills);			//刷新宠物技能请求
			YFEventCenter.Instance.addEventListener(PetEvent.SubSkill,subSkill);					//技能替换请求
			YFEventCenter.Instance.addEventListener(PetEvent.SkillLvUp,upgradeSkill);				//技能升级请求
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SPetInfoResp,SPetInfoResp,onPetInfoResp);				//宠物信息回复
			MsgPool.addCallBack(GameCmd.SFightPetResp,PetResp,onFightPetResp);					//宠物出战回复
			MsgPool.addCallBack(GameCmd.SPetRenameResp,SPetRenameResp,onRenameResp);			//宠物改名回复
			MsgPool.addCallBack(GameCmd.SCombinePet,SCombinePet,onCombineResp);					//宠物融合回复
			MsgPool.addCallBack(GameCmd.SExpandSlotResp,SExpandSlotResp,onExpandSlotResp);		//增加宠物栏回复
			MsgPool.addCallBack(GameCmd.SInheritPet,SInheritPet,onInheritResp);					//宠物继承回复
			MsgPool.addCallBack(GameCmd.STakeBackPetReq,STakeBackPetReq,onTakebackResp);		//宠物收回回复
			MsgPool.addCallBack(GameCmd.SPetChangeHappyResp,SPetChangeHappy,onCGHappyResp);		//宠物快乐度回复
			MsgPool.addCallBack(GameCmd.SDropPetResp,PetResp,onDropResp);						//宠物放生回复
			MsgPool.addCallBack(GameCmd.SPetAddSkillSlot,SAddSkillSlot,onAddSkillSlotResp);		//宠物开技能格子回复
			MsgPool.addCallBack(GameCmd.SPetSophi,SPetSophi,onSuccResp);						//宠物洗练回复
			MsgPool.addCallBack(GameCmd.SPetSophiConfirm,SPetSophiConfirm,onSuccConfirmResp);	//宠物洗练确认回复
			MsgPool.addCallBack(GameCmd.SPetAddExperience,SPetAddExperience,onAddExpResp);		//宠物加经验回复
			MsgPool.addCallBack(GameCmd.SPetAddPoint,SPetAddPoint,onAddPointResp);				//宠物加点回复
			MsgPool.addCallBack(GameCmd.SGetPetResp,PetInfo,onGetPetResp);						//宠物获得回复
			MsgPool.addCallBack(GameCmd.SPetReset,SPetReset,onResetResp);						//宠物洗点回复
			MsgPool.addCallBack(GameCmd.SEnhancePet,SEnhancePet,onEnhanceResp);					//宠物强化回复
			MsgPool.addCallBack(GameCmd.SPetUseItemNotify,SPetUseItemNotify,onAddBloodResp);	//宠物加血回复
			MsgPool.addCallBack(GameCmd.SFight,SFight,onDropBloodResp);							//宠物掉血回复
			MsgPool.addCallBack(GameCmd.SPetAttrChange,SPetAttrChange,onPetAttrChgResp);		//宠物Buff属性改变回复
			
			MsgPool.addCallBack(GameCmd.SSetPetFightAI,SSetPetFightAI,onAiModeResp);				//宠物战斗属性回复
			MsgPool.addCallBack(GameCmd.SMagicSoulChange,SMagicSoulChange,onMagicSoul);			//魔元回复
			
			MsgPool.addCallBack(GameCmd.SRefreshPetSkill,SRefreshPetSkill,onRefreshResp);		//技能刷新回复
			MsgPool.addCallBack(GameCmd.SReplaceSkill,SReplaceSkill,onReplace);					//技能替换回复
			MsgPool.addCallBack(GameCmd.SUpgradePetSkill,SUpgradePetSkill,onUpgradeSkill);		//技能升级回复
		}
		
		private function onAddSkillSlotResp(msg:SAddSkillSlot):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				PetDyManager.Instance.getPetDyVo(msg.petId).skillOpenSlots=msg.skillSlotNumber;
				_petWindow.updateLearnPanel();
//				NoticeManager.setNotice(NoticeType.Notice_id_1004);
			}
		}
	
		/**技能升级回复
		 * @param msg
		 */		
		private function onUpgradeSkill(msg:SUpgradePetSkill):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				var vo:PetDyVo = PetDyManager.Instance.getPetDyVo(msg.petId);
				var arr:Array = vo.skillAttrs;
				var newArr:Array = vo.newLearnSkills;
				var len:int = arr.length;
				for(var i:int=0;i<len;i++){
					if(arr[i].skillId==msg.skillId){
						arr[i].skillLevel = msg.skillLevel;
						if(arr[i].skillId==newArr[i].skillId){
							newArr[i].skillLevel= msg.skillLevel;
						}
					}
				}
			}
			_petWindow.updateLearnPanel();
		}
		
		/**宠物技能升级请求 
		 * @param e
		 */		
		private function upgradeSkill(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CUpgradePetSkill,e.param as CUpgradePetSkill);
		}
		
		/**技能替换回复
		 * @param msg 
		 */		
		private function onReplace(msg:SReplaceSkill):void{
			var vo:PetDyVo = PetDyManager.Instance.getPetDyVo(msg.petId);
			var arr:Array = msg.skillSlots;
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				vo.skillAttrs[arr[i].slotId] = new SkillDyVo();
				vo.skillAttrs[arr[i].slotId].skillId = arr[i].skillId;
				vo.skillAttrs[arr[i].slotId].skillLevel = arr[i].skillLevel;
				vo.newLearnSkills[arr[i].slotId] = new SkillDyVo();
				vo.newLearnSkills[arr[i].slotId].skillId = arr[i].skillId;
				vo.newLearnSkills[arr[i].slotId].skillLevel = arr[i].skillLevel;
			}
			_petWindow.updateLearnPanel();
		}
		
		/**技能刷新回复
		 * @param msg
		 */		
		private function onRefreshResp(msg:SRefreshPetSkill):void{
			var vo:PetDyVo = PetDyManager.Instance.getPetDyVo(msg.petId);
			var arr:Array = msg.skillSlots;
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				vo.newLearnSkills[arr[i].slotId] = new SkillDyVo();
				vo.newLearnSkills[arr[i].slotId].skillId = arr[i].skillId;
				vo.newLearnSkills[arr[i].slotId].skillLevel = arr[i].skillLevel;
			}
			_petWindow.updateLearnPanel();
		}
		
		/**技能替换请求
		 * @param e
		 */		
		private function subSkill(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CReplaceSkill,e.param as CReplaceSkill);
		}
		
		/**刷新宠物技能请求
		 * @param e
		 */		
		private function refreshSkills(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CRefreshPetSkill,e.param as CRefreshPetSkill);
		}
		
		/**魔元改变回复
		 * @param msg
		 */		
		private function onMagicSoul(msg:SMagicSoulChange):void{
			CharacterDyManager.Instance.magicSoul = msg.magicSoul;
			_petWindow.updateMagicSoul();
		}
		
		/**增加宠物栏请求 
		 * @param e 收到的增加宠物栏请求事件通知
		 */
		private function expandSlotReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CExpandSlotReq,new EmptyReq());
		}
		
		/**宠物改名请求 
		 * @param e 收到的宠物改名请求事件通知
		 */		
		private function renameReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetRenameReq,(e.param) as CPetRenameReq);
		}
		
		/**宠物融合请求 
		 * @param e 收到的宠物融合请求事件通知
		 */		
		private function combineReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CCombinePet,(e.param) as CCombinePet);
		}
		
		/**宠物继承请求
		 * @param e 收到的宠物继承请求事件通知
		 */		
		private function inheritReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CInheritPet,(e.param) as CInheritPet);
		}
		
		/**宠物出战请求 
		 * @param e 收到的宠物出战请求事件通知
		 */		
		private function fightPetReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CFightPetReq,(e.param) as PetRequest);
		}
		
		/**宠物收回请求 
		 * @param e 收到的宠物收回请求事件通知
		 */		
		private function takeBackReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CTakeBackPetReq,(e.param) as PetRequest);
		}
		
		/**宠物放生请求 
		 * @param e 收到的宠物放生请求事件通知
		 */		
		private function dropReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CDropPetReq,(e.param) as PetRequest);
		}
		
		/**购买宠物道具请求 
		 * @param e 收到的购买宠物道具请求事件通知
		 */		
		private function buyReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CBuyItemReq,(e.param) as CBuyItemReq);
		}
		
		/**宠物领悟请求 
		 * @param e 收到的宠物领悟请求事件通知
		 */		
		private function comprehendReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetAddSkillSlot,(e.param) as CAddSkillSlot);
		}
		
		/**宠物技能学习请求 
		 * @param e 收到的宠物技能学习请求事件通知
		 */		
		private function learnReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetLearnSkill,(e.param) as CPetLearnSkill);
		}
		
		/**宠物技能遗忘请求
		 * @param e 收到的宠物技能遗忘请求事件通知
		 */		
		private function forgetSkillReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetForgetSkill,(e.param) as CPetForgetSkill);
		}
		
		/**宠物洗练请求 
		 * @param e 收到的宠物洗练请求事件通知
		 */		
		private function succReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetSophi,(e.param) as CPetSophi);
		}
		
		/**宠物洗练确认请求 
		 * @param e 收到的宠物洗练确认请求事件通知
		 */		
		private function succConfirmReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetSophiConfirm,(e.param) as PetRequest);
		}
		
		/**宠物加点请求 
		 * @param e 收到的宠物加点请求事件通知
		 */		
		private function addPointReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetAddPoint,(e.param) as CPetAddPoint);
		}
		
		/**宠物洗点请求 
		 * @param e 收到的宠物洗点请求事件通知
		 */		
		private function resetReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetReset,(e.param) as CPetReset);
		}
		
		/**
		 *宠物强化请求 
		 * @param e 收到的宠物强化请求事件通知
		 */		
		private function enhanceReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CEnhancePet,(e.param) as CEnhancePet);
		}
		
		/**宠物窗口打开回复
		 * @param e 收到的宠物窗口打开回复事件通知
		 */		
		private function onBagChangeResp(e:YFEvent):void{
			_petWindow.updateItem();
		}
		
		/**宠物buff属性改变通知
		 * @param msg 收到的协议
		 */		
		private function onPetAttrChgResp(msg:SPetAttrChange):void{
			var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(msg.petId);
			if(pet){
				pet.power = msg.attr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.attr.petAttrs);
				_petWindow.updateInfoPanel("all");
			}
		}
		
		/**宠物强化回复 
		 * @param msg 收到的协议
		 */		
		private function onEnhanceResp(msg:SEnhancePet):void{
			var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(msg.petId);
			if(msg.errorInfo==0){
				pet.enhanceLv = msg.enhanceLevel;
				pet.power = msg.petAttr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.petAttr.petAttrs);
				PetDyManager.Instance.calStat(msg.petId);
				_petWindow.updateAllPanel();
				//NoticeUtil.setOperatorNotice("恭喜您，["+pet.roleName+"]的强化等级提升到"+pet.enhanceLv+"级。");
				NoticeManager.setNotice(NoticeType.Notice_id_1001,-1,pet.roleName,pet.enhanceLv);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}else{
				//NoticeUtil.setOperatorNotice("很遗憾，["+pet.roleName+"]强化失败");
				NoticeManager.setNotice(NoticeType.Notice_id_1002,-1,pet.roleName);
			}
		}
		
		/**宠物加血回复 
		 * @param msg 收到的协议
		 */		
		private function onAddBloodResp(msg:SPetUseItemNotify):void{
			if(PetDyManager.Instance.hasPet(msg.dyId)){
				PetDyManager.Instance.getPetDyVo(msg.dyId).fightAttrs[TypeProps.EA_HEALTH]=msg.hp;
				_petWindow.updateAllPanel();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}
		}
		
		/**宠物掉血回复 
		 * @param msg 收到的协议
		 */		
		private function onDropBloodResp(msg:SFight):void{
			var len:int=msg.damageInfoArr.length;
			for(var i:int=0;i<len;i++){
				if(PetDyManager.Instance.hasPet(msg.damageInfoArr[i].tagId)){
					PetDyManager.Instance.getPetDyVo(msg.damageInfoArr[i].tagId).fightAttrs[TypeProps.EA_HEALTH]=msg.damageInfoArr[i].hp;
					_petWindow.updateInfoPanel("hp");
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
				}
			}
		}
		
		/**宠物加点回复 
		 * @param msg 收到的协议
		 */		
		private function onAddPointResp(msg:SPetAddPoint):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.getPetDyVo(msg.petId).power = msg.petAttr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.petAttr.petAttrs);
				PetDyManager.Instance.getPetDyVo(msg.petId).potential = msg.potential;
				_petWindow.updateAllPanel();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}
		}
		
		/**宠物加经验回复 
		 * @param msg 收到的协议
		 */		
		private function onAddExpResp(msg:SPetAddExperience):void{
			var pet:PetDyVo=PetDyManager.Instance.getPetDyVo(msg.petId);
			if(pet){
				if(msg.hasLevelUp==false){
					NoticeManager.setNotice(NoticeType.Notice_id_802,-1,pet.roleName,msg.exp-pet.exp);
					pet.exp = msg.exp;
					_petWindow.updateInfoPanel("addExp");
				}else{
					pet.exp = msg.exp;
					pet.level = msg.levelUp.level;
					pet.potential = msg.levelUp.potential;
					pet.power = msg.levelUp.petAttr.power;
					PetDyManager.Instance.setFightAttr(msg.petId,msg.levelUp.petAttr.petAttrs);
					NoticeManager.setNotice(NoticeType.Notice_id_201,-1,pet.roleName,pet.level);
					_petWindow.updateAllPanel();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"lvup");
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetLevelUp,pet); //宠物升级 场景模块进行接受处理 播放升级动画
					YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.PetChange);//成长任务宠物升级
				}
			}
		}
		
		/**宠物收回回复 
		 * @param msg 收到的协议
		 */
		private function onTakebackResp(msg:STakeBackPetReq):void{
			updateTakeBackPet();
			var pet:PetDyVo=PetDyManager.Instance.getFightPetDyVo();
			if(pet&&pet.buffIdArray)//取不到宠物就直接return
			{
				pet.buffIdArray.length=0;//把宠物BUFF去掉
				_petView.removeAllBuff();
			}
			PetDyManager.fightPetId=0;
			PetDyManager.Instance.getPetDyVo(msg.petId).fightAttrs[TypeProps.EA_HEALTH]=msg.hp;
			_petWindow.updateTackBack();
			if(msg.isDead){//只有宠物死亡后才会自动出战，主角死了宠物也死了
				PetDyManager.backupFightPetId = msg.petId;
				_petWindow.autoFight();
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"takeback");
		}
		
		/**宠物快乐度改变回复 
		 * @param msg 收到的协议
		 */
		private function onCGHappyResp(msg:SPetChangeHappy):void{
			PetDyManager.Instance.getPetDyVo(msg.petId).happy = msg.happy;
			_petWindow.updateInfoPanel("happy");
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"happy");
		}
		
		/**宠物改名回复 
		 * @param msg 收到的协议
		 */		
		private function onRenameResp(msg:SPetRenameResp):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.getPetDyVo(msg.petId).roleName = msg.name;
				_petWindow.updateInfoPanel("rename");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"name");
			}
		}
		
		/**宠物出战改变回复
		 * @param msg 收到的协议
		 */		
		private function onFightPetResp(msg:PetResp):void{
			if(msg.errorInfo==0){
				_petView.updateFightPet();
				PetDyManager.fightPetId=msg.petId;
				PetDyManager.crtPetId = msg.petId;
				PetDyManager.Instance.topFightPetId(msg.petId);
				_petWindow.updateFightPet();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
				
				if(NewGuideStep.PetGuideStep!=-1)
				{
					NewGuideStep.PetGuideStep=NewGuideStep.PetCloseWindow;
					NewGuideManager.DoGuide();
				}
			}
		}
		
		/**宠物放生回复 
		 * @param msg 收到的协议
		 */		
		private function onDropResp(msg:PetResp):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.dropPet(msg.petId);
				_petWindow.updateInfoPanel("drop");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}
		
		/**宠物栏增加回复 
		 * @param msg 收到的协议
		 */		
		private function onExpandSlotResp(msg:SExpandSlotResp):void{
			if(msg.errorInfo==0){
				PetDyManager.petOpenSlots=msg.petOpenSlots;
				_petWindow.updateAllPanel();
			}
		}
		
		
		/**宠物洗练回复
		 * @param msg 收到的协议
		 */		
		private function onSuccResp(msg:SPetSophi):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.setFightAttr(msg.petId,msg.newApts);
				_petWindow.updateAllPanel();
				NoticeUtil.setOperatorNotice("宠物洗练完成");
			}
		}
		
		/**宠物洗练确认回复 
		 * @param msg 收到的协议
		 */		
		private function onSuccConfirmResp(msg:SPetSophiConfirm):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.getPetDyVo(msg.petId).power = msg.petAttr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.petAttr.petAttrs);
				PetDyManager.Instance.clearTempAttrs(msg.petId);
				_petWindow.updateAllPanel();
				NoticeUtil.setOperatorNotice("宠物资质替换完成");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}
		}
		
		/**宠物洗点回复 
		 * @param msg 收到的协议
		 */		
		private function onResetResp(msg:SPetReset):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.getPetDyVo(msg.petId).potential=msg.potential;
				PetDyManager.Instance.getPetDyVo(msg.petId).power=msg.petAttr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.petAttr.petAttrs);
				_petWindow.updateAllPanel();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}
		}
		
		/**宠物融合回复 
		 * @param msg 收到的协议
		 */		
		private function onCombineResp(msg:SCombinePet):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.dropPet(msg.removePetId);
				if(msg.removePetId==PetDyManager.fightPetId)	PetDyManager.fightPetId=0;
				PetDyManager.crtPetId = msg.newPetId;
				PetDyManager.Instance.setFightAttr(msg.newPetId,msg.attrArr.petAttrs);
				PetDyManager.Instance.getPetDyVo(msg.newPetId).power=msg.attrArr.power;
				_petWindow.updateAllPanel();
				//NoticeUtil.setOperatorNotice("宠物融合完成");
				NoticeManager.setNotice(NoticeType.Notice_id_1006,-1,PetDyManager.Instance.getPetDyVo(msg.newPetId).roleName);
				
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}
		
		/**宠物继承回复 
		 * @param msg 收到的协议
		 */
		private function onInheritResp(msg:SInheritPet):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.dropPet(msg.removePetId);
				if(msg.removePetId==PetDyManager.fightPetId)	PetDyManager.fightPetId=0;
				PetDyManager.Instance.addPetDyVo(msg.petInfo,msg.petInfo.petId);	
				PetDyManager.crtPetId = msg.petInfo.petId;
				_petWindow.updateAllPanel();
				NoticeUtil.setOperatorNotice("宠物继承完成");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
				YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.PetChange);//成长任务，继承后宠物品质会改变
			}
		}
		
		/**宠物获得回复 
		 * @param msg 收到的协议
		 */
		private function onGetPetResp(msg:PetInfo):void{
			//NoticeUtil.setOperatorNotice("恭喜你获得宠物【"+PetBasicManager.Instance.getPetConfigVo(msg.configId).pet_type_name+"】");
			NoticeManager.setNotice(NoticeType.Notice_id_1008,Channels.CHAT_CHANNEL_SYSTEM,DataCenter.Instance.roleSelfVo.roleDyVo.roleName,msg.petNickname,msg.petNickname);
			PetDyManager.Instance.addPetDyVo(msg);
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.PetChange);
			if(PetDyManager.Instance.getPetListSize()==1){
				PetDyManager.crtPetId = msg.petId;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");				
			}			
			_petWindow.updateAllPanel();
		}
		
		/**宠物列表回复 
		 * @param msg 收到的协议
		 */		
		private function onPetInfoResp(msg:SPetInfoResp):void{
			PetDyManager.petOpenSlots=msg.petOpenSlots;
			PetDyManager.fightPetId=msg.fightPetId;
			PetDyManager.aiMode=msg.petAi;
			PetDyManager.Instance.cachePetList(msg.petInfos);
			PetDyManager.Instance.initCrtPetId();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
		}
		
		/**宠物面板打开请求 
		 * @param e 收到的宠物面板打开请求事件通知
		 */		
		private function onOpen(e:YFEvent):void{
			_petWindow.popUpWindow(int(e.param));
		}
		
		/**金钱改变消息通知 
		 * @param e 收到的金钱改变消息通知
		 */		
		private function onMoneyChg(e:YFEvent):void{
			_petWindow.updateMoney();
		}
		
		/**角色死亡，如果有出战宠物就把出战宠物收回*/
		private function onHeroDead(e:YFEvent):void
		{
			// TODO 收回宠物
			if(PetDyManager.fightPetId!=0)//fightPetId等于0的时候表示没有出战宠物，不需要回收
			{
				var msg:PetRequest=new PetRequest;
				msg.petId=PetDyManager.fightPetId;
				MsgPool.sendGameMsg(GameCmd.CTakeBackPetReq,msg);
			}
		}
		
		/**宠物窗口打开 
		 * @param e 收到的宠物窗口打开事件通知
		 */		
		private function onPetUIClick(e:YFEvent):void{
			_petWindow.switchOpenClose();
			if(_petWindow.isOpen){
				_petWindow.switchTab(1);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
				
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
				{
					if(NewGuideStep.PetGuideStep==NewGuideStep.PetFight)
					{
						NewGuideManager.DoGuide();
					}
				}
			}
		}
		
		/**游戏登陆宠物列表请求 
		 * @param e 收到的游戏登陆宠物列表请求事件通知
		 */
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetInfoReq,new EmptyReq());
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			
			if(!LayerManager.UILayer.contains(_petView))LayerManager.UILayer.addChild(_petView);
		}
		
		/**添加宠物场景组件 
		 */		
		public function addPetIconView():void{
			_petView.visible=true;
		}
		
		/**移除宠物场景组件 
		 */		
		public function removePetIconView():void{
			_petView.visible=false;
		}
		
		/**更新宠物
		 */	
		public function updatePet(type:String):void{
			var pet:PetDyVo;
			if(PetDyManager.fightPetId==0)	pet = PetDyManager.Instance.getCrtPetDyVo();
			else	pet = PetDyManager.Instance.getFightPetDyVo();
			_petView.updateInfo(type,pet);
		}
		
		/**宠物出战更新 
		 */		
		public function updateFightPet():void{
			_petView.updateFightPet();
		}
		
		/**宠物收回更新 
		 */		
		public function updateTakeBackPet():void{
			_petView.updateTakeBack();
		}
		
		
		/**宠物更改事件监听 
		 * @param e 收到的宠物更改事件通知
		 */		
		private function onPetChange(e:YFEvent):void{		
			if(PetDyManager.Instance.getPetListSize()!=0){
				addPetIconView();
				updatePet(e.param as String);
				_petWindow.updateInfoPanel("hp");
			}else{
				removePetIconView();
			}
		}
		
		/**宠物增加buff
		 * @param e 收到的宠物增加buff事件通知
		 */		
		private function onPetAddBuff(e:YFEvent):void{
			var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(e.param.petId);
			if(!pet.containsBuffId(e.param.buffId)){
				pet.buffIdArray.push(e.param.buffId);
				_petView.addBuff(e.param.buffId);
			}
			pet.fightAttrs[TypeProps.EA_HEALTH] = RoleDyManager.Instance.getRole(e.param.petId).hp;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");	
		}
		
		/**宠物删除buff
		 * @param e 收到的宠物删除buff事件通知
		 */
		private function onPetDelBuff(e:YFEvent):void{
			PetDyManager.Instance.getPetDyVo(e.param.petId).removeBuffId(e.param.buffId);
			_petView.deleteBuff(e.param.buffId);
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
			PetDyManager.aiMode=msg.fightAi;
			updatePet("all");
		}
	}
}