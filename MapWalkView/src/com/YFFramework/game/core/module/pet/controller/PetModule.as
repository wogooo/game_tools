package com.YFFramework.game.core.module.pet.controller
{
	/**@author yefeng
	 *2012-8-21下午10:24:33
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.PetWindow;
	import com.msg.pets.*;
	import com.msg.shop.CBuyItemReq;
	import com.msg.skill_pro.SFight;
	import com.net.MsgPool;
	
	public class PetModule extends AbsModule{
		
		private var _petWindow:PetWindow;
		
		public function PetModule(){
		}
		
		override public function init():void{
			_petWindow=new PetWindow();
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);				//进入游戏   请求宠物列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.P,onPetUIClick);				//键盘P打开宠物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUIClick,onPetUIClick);		//单击 打开宠物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChangeResp);		//背包改动通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_PET_PANEL,onOpen);			//打开面板请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.petDropHp,onDropHp);			//宠物掉血回复
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChg);		//金钱改变通知
			
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
			MsgPool.addCallBack(GameCmd.SPetAddSkillSlot,SAddSkillSlot,onComprehendResp);		//宠物领悟回复
			MsgPool.addCallBack(GameCmd.SPetLearnSkill,SPetLearnSkill,onNewSkillResp);			//宠物技能学习回复
			MsgPool.addCallBack(GameCmd.SPetForgetSkill,SPetForgetSkill,onForgetSkillResp);		//宠物技能遗忘回复
			MsgPool.addCallBack(GameCmd.SPetSophi,SPetSophi,onSuccResp);						//宠物洗练回复
			MsgPool.addCallBack(GameCmd.SPetSophiConfirm,SPetSophiConfirm,onSuccConfirmResp);	//宠物洗练确认回复
			MsgPool.addCallBack(GameCmd.SPetAddExperience,SPetAddExperience,onAddExpResp);		//宠物加经验回复
			MsgPool.addCallBack(GameCmd.SPetAddPoint,SPetAddPoint,onAddPointResp);				//宠物加点回复
			MsgPool.addCallBack(GameCmd.SGetPetResp,PetInfo,onGetPetResp);						//宠物获得回复
			MsgPool.addCallBack(GameCmd.SPetReset,SPetReset,onResetResp);						//宠物洗点回复
			MsgPool.addCallBack(GameCmd.SEnhancePet,SEnhancePet,onEnhanceResp);					//宠物强化回复
			MsgPool.addCallBack(GameCmd.SPetUseItemNotify,SPetUseItemNotify,onAddBloodResp);	//宠物加血回复
			MsgPool.addCallBack(GameCmd.SFight,SFight,onDropBloodResp);							//宠物掉血回复
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
			MsgPool.sendGameMsg(GameCmd.CPetAddSkillSlot,(e.param) as PetRequest);
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
			MsgPool.sendGameMsg(GameCmd.CPetSophi,(e.param) as PetRequest);
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
			MsgPool.sendGameMsg(GameCmd.CPetReset,(e.param) as PetRequest);
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
		
		/**
		 *宠物强化回复 
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
				NoticeUtil.setOperatorNotice("恭喜您，["+pet.roleName+"]的强化等级提升到"+pet.enhanceLv+"级。");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}else{
				NoticeUtil.setOperatorNotice("很遗憾，["+pet.roleName+"]强化失败");
			}
		}

		/**宠物加血回复 
		 * @param msg 收到的协议
		 */		
		private function onAddBloodResp(msg:SPetUseItemNotify):void{
			if(PetDyManager.Instance.hasPet(msg.dyId)){
				PetDyManager.Instance.getPetDyVo(msg.dyId).fightAttrs[TypeProps.HP]=msg.hp;
				_petWindow.updateAllPanel();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,"hp");
			}
		}
		
		/**宠物掉血回复 
		 * @param msg 收到的协议
		 */		
		private function onDropBloodResp(msg:SFight):void{
			for(var i:int=0;i<msg.damageInfoArr.length;i++){
				if(PetDyManager.Instance.hasPet(msg.damageInfoArr[i].tagId)){
					PetDyManager.Instance.getPetDyVo(msg.damageInfoArr[i].tagId).fightAttrs[TypeProps.HP]=msg.damageInfoArr[i].hp;
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
			if(msg.hasLevelUp==false){
				PetDyManager.Instance.getPetDyVo(msg.petId).exp = msg.exp;
				_petWindow.updateInfoPanel("addExp");
			}else{
				var pet:PetDyVo=PetDyManager.Instance.getPetDyVo(msg.petId);
				pet.exp = msg.exp;
				pet.level = msg.levelUp.level;
				pet.potential = msg.levelUp.potential;
				pet.power = msg.levelUp.petAttr.power;
				PetDyManager.Instance.setFightAttr(msg.petId,msg.levelUp.petAttr.petAttrs);
				_petWindow.updateAllPanel();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"lvup");
			}
		}
		
		/**宠物遗忘技能回复 
		 * @param msg 收到的协议
		 */		
		private function onForgetSkillResp(msg:SPetForgetSkill):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.dropSkill(msg.petId,msg.skillId);
				_petWindow.updateInfoPanel("forget");
			}
		}
		
		/**宠物收回回复 
		 * @param msg 收到的协议
		 */		
		private function onTakebackResp(msg:STakeBackPetReq):void{
			PetDyManager.Instance.setFightPetId(0);
			PetDyManager.Instance.getPetDyVo(msg.petId).fightAttrs[TypeProps.HP]=msg.hp;
			_petWindow.updateTackBack();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
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
				PetDyManager.Instance.setFightPetId(msg.petId);
				PetDyManager.crtPetId = msg.petId;
				PetDyManager.Instance.topFightPetId(msg.petId);
				PetDyManager.cdPool = new TimeOut(15000,sendCDOver);
				PetDyManager.cdPool.start();
				_petWindow.updateFightPet();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}
		
		/**宠物出战CD结束通知
		 * @param obj 
		 */		
		private function sendCDOver(obj:Object):void{
			_petWindow.updateAllPanel();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			PetDyManager.cdPool.dispose();
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
				PetDyManager.Instance.setPetOpenSlots(msg.petOpenSlots);
				_petWindow.updateAllPanel();
			}
		}
		
		/**宠物技能学习回复 
		 * @param msg 收到的协议
		 */		
		private function onNewSkillResp(msg:SPetLearnSkill):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.setSkill(msg.petId,msg.newSkill);
				_petWindow.updateLearnPanel();
				NoticeUtil.setOperatorNotice("宠物学习完成");
			}
		}
		
		/**宠物领悟回复 
		 * @param msg 收到的协议
		 */		
		private function onComprehendResp(msg:SAddSkillSlot):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.getPetDyVo(msg.petId).skillOpenSlots=msg.skillSlotNumber;
				_petWindow.updateComprePanel();
				NoticeUtil.setOperatorNotice("宠物领悟完成");
			}
		}
		
		/**宠物洗练回复
		 * @param msg 收到的协议
		 */		
		private function onSuccResp(msg:SPetSophi):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.setTempAttrs(msg.petId,msg.newApts);
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
				PetDyManager.crtPetId = msg.newPetId;
				PetDyManager.Instance.setFightAttr(msg.newPetId,msg.attrArr.petAttrs);
				PetDyManager.Instance.getPetDyVo(msg.newPetId).power=msg.attrArr.power;
				_petWindow.updateAllPanel();
				NoticeUtil.setOperatorNotice("宠物融合完成");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}
		
		/**宠物继承回复 
		 * @param msg 收到的协议
		 */		
		private function onInheritResp(msg:SInheritPet):void{
			if(msg.errorInfo==0){
				PetDyManager.Instance.dropPet(msg.removePetId);
				PetDyManager.Instance.addPetDyVo(msg.petInfo,msg.petInfo.petId);	
				PetDyManager.crtPetId = msg.petInfo.petId;
				_petWindow.updateAllPanel();
				NoticeUtil.setOperatorNotice("宠物继承完成");
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}
		
		/**宠物获得回复 
		 * @param msg 收到的协议
		 */		
		private function onGetPetResp(msg:PetInfo):void{
			PetDyManager.Instance.addPetDyVo(msg);
			PetDyManager.crtPetId = msg.petId;
			_petWindow.updateAllPanel();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
		}
		
		/**宠物列表回复 
		 * @param msg 收到的协议
		 */		
		private function onPetInfoResp(msg:SPetInfoResp):void{
			PetDyManager.Instance.setPetOpenSlots(msg.petOpenSlots);
			PetDyManager.Instance.setFightPetId(msg.fightPetId);
			PetDyManager.Instance.setAiMode(msg.petAi);
			PetDyManager.Instance.cachePetList(msg.petInfos);
			PetDyManager.Instance.initCrtPetId();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
		}
		
		/**宠物面板打开请求 
		 * @param e 收到的宠物面板打开请求事件通知
		 */		
		private function onOpen(e:YFEvent):void{
			_petWindow.popUpWindow(int(e.param)+1);
		}
		
		/**宠物掉血消息
		 * @param e 收到的宠物掉血消息事件通知
		 */		
		private function onDropHp(e:YFEvent):void{
			_petWindow.updateInfoPanel("hp");
		}
		
		/**金钱改变消息通知 
		 * @param e 收到的金钱改变消息通知
		 */		
		private function onMoneyChg(e:YFEvent):void{
			_petWindow.updateMoney();
		}
		
		/**宠物窗口打开 
		 * @param e 收到的宠物窗口打开事件通知
		 */		
		private function onPetUIClick(e:YFEvent):void{
			_petWindow.switchOpenClose();
			if(_petWindow.isOpen){
				_petWindow.switchTab(1);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
		}

		/**游戏登陆宠物列表请求 
		 * @param e 收到的游戏登陆宠物列表请求事件通知
		 */
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CPetInfoReq,new EmptyReq());
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
		}
	}
}