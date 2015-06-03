package com.YFFramework.game.core.module.skill.controller
{
	/**@author yefeng
	 * 2013 2013-7-23 下午3:43:04 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.mamanger.QuickBoxManager;
	import com.YFFramework.game.core.module.skill.mamanger.SKillEffectLoadingManager;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.QuickBoxDyVo;
	import com.YFFramework.game.core.module.skill.model.SetQuikBoxVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.YFFramework.game.core.module.skill.view.SkillNewWindow;
	import com.YFFramework.game.core.module.skill.view.SkillQuickPane;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.common.SkillInfo;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CRequestQuickBox;
	import com.msg.hero.CSetQuickBox;
	import com.msg.hero.QuickBox;
	import com.msg.hero.SQuickBoxInfo;
	import com.msg.hero.SSetQuickBox;
	import com.msg.skill_pro.CLearnSkill;
	import com.msg.skill_pro.CRequestSkillList;
	import com.msg.skill_pro.SLearnSkill;
	import com.msg.skill_pro.SResetSkill;
	import com.msg.skill_pro.SSkillList;
	import com.net.MsgPool;
	
	import flash.utils.Dictionary;
	
	public class ModuleNewSkill extends AbsModule
	{
		
		/**技能面板
		 */
		private var _skillWindow:SkillNewWindow;
		public function ModuleNewSkill()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;

		}
		override public function init():void
		{
			_skillWindow=new SkillNewWindow();
			addEvents();
		}
		
		/**
		 * 添加事件 
		 * 
		 */
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			//点击 打开技能面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillUIClick,onUIClick);
			//转职成功
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onHeroChangeCareerSuccess);
			//学习技能
			YFEventCenter.Instance.addEventListener(SkillEvent.C_LearnSkill,onSkillEvent);
			// 设置快捷方式
			YFEventCenter.Instance.addEventListener(SkillEvent.C_SetQuickBox,onSkillEvent);
			//背包改变  更新快捷栏数量 改变数量
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
			//播放CD
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagDrugUseItemResp,onBagChange);
			/**主角升级*/
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLevelUp);
			/**钱改变*/
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
			/**阅历改变*/
			YFEventCenter.Instance.addEventListener(GlobalEvent.SeeChange,onSeeChange);

			
			///请求技能列表
			MsgPool.addCallBack(GameCmd.SSkillList,SSkillList,skillListCallBack);		
			//技能学习/升级返回 
			MsgPool.addCallBack(GameCmd.SLearnSkill,SLearnSkill,onServerSLearnSkill);
			// 快捷方式列表
			MsgPool.addCallBack(GameCmd.SQuickBoxInfo,SQuickBoxInfo,onServerSQuickBoxInfo);
			//监听服务器的请求返回协议
			MsgPool.addCallBack(GameCmd.SSetQuickBox,SSetQuickBox,onServerSSetQuickBox);
			// 转职后重置技能
			MsgPool.addCallBack(GameCmd.SResetSkill,SResetSkill,onSResetSkill);
		}
		
		private function onSeeChange(e:YFEvent):void
		{
			_skillWindow.updateLearnInfo();
		}
		
		private function onMoneyChange(e:YFEvent):void
		{
			_skillWindow.updateLearnInfo();
		}
		
		private function onHeroLevelUp(e:YFEvent=null):void
		{
			//显示技能可升级图标
			if(SkillDyManager.Instance.findNextCanLearnSkill(1)&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=12)
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.newSkill);
			_skillWindow.updateLearnInfo();
		}
		/**背包数量改变更新快捷栏的数量
		 */		
		private function onBagChange(e:YFEvent):void
		{
			var dict:Dictionary=QuickBoxManager.Instance.getDict();
			 for each(var quickBoxDyVo:QuickBoxDyVo in dict) 
			 {
				 if(quickBoxDyVo.type==SkillModuleType.QuickType_BT_ITEM)  //如果为道具类型 则进行更新 数据
				 {
//					 var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(quickBoxDyVo.id);
					 var num:int=PropsDyManager.instance.getPropsQuantity(quickBoxDyVo.id);  //获取道具总数量
					 if(num==0) //不存在 则删除
					 {
						 QuickBoxManager.Instance.removeQuickBoxDyVo(quickBoxDyVo.key_id);
					 }
				 }
			 }
			 _skillWindow.skillQuickPane.updateQuickBoxUI();
		}
		
		/**
		 *请求技能列表 
		 */		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			//请求技能列表
			var requestSkillList:CRequestSkillList=new CRequestSkillList();
			MsgPool.sendGameMsg(GameCmd.CRequestSkillList,requestSkillList);
			MsgPool.sendGameMsg(GameCmd.CRequestQuickBox,new CRequestQuickBox());
		}
		/**点击打开技能面板
		 */		
		private function onUIClick(e:YFEvent):void
		{
			_skillWindow.switchOpenClose();
			_skillWindow.updateCareerSkillUI();
			
			if(_skillWindow.isOpen)
			{
				if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillGuideRectStudyBtn)
				{
					NewGuideManager.DoGuide();
				}
			}
		}
		
		/**学习技能
		 */		
		private function onSkillEvent(e:YFEvent):void
		{
			var skillId:int;
			switch(e.type)
			{
				case SkillEvent.C_LearnSkill://学习技能
					skillId=int(e.param) ;
					var cLearnSkill:CLearnSkill=new CLearnSkill();
					cLearnSkill.skillId=skillId;
					MsgPool.sendGameMsg(GameCmd.CLearnSkill,cLearnSkill);
					break;
				case SkillEvent.C_SetQuickBox://设置快捷方式
					var setQuickBoxDyVo:SetQuikBoxVo=e.param as SetQuikBoxVo;
					var cSetQuickBox:CSetQuickBox=new CSetQuickBox();
					cSetQuickBox.fromBoxInfo=new QuickBox();
					cSetQuickBox.fromBoxInfo.keyId=setQuickBoxDyVo.fromKeyId;
					cSetQuickBox.fromBoxInfo.boxType=setQuickBoxDyVo.boxType;
					cSetQuickBox.fromBoxInfo.boxId=setQuickBoxDyVo.boxId;
					cSetQuickBox.targetKeyId=setQuickBoxDyVo.target_key_id;
					MsgPool.sendGameMsg(GameCmd.CSetQuickBox,cSetQuickBox);
					break;
			}
		}
		
		
		/**服务端返回技能列表信息
		 */		
		private function skillListCallBack(sSkillList:SSkillList):void
		{
			SkillDyManager.Instance.clear();
			///缓存技能列表
			var skillDyVo:SkillDyVo;
			for each(var skillInfo:SkillInfo in sSkillList.skillListArr){
				skillDyVo=new SkillDyVo();
				skillDyVo.skillId=skillInfo.skillId;
				skillDyVo.skillLevel=skillInfo.skillLevel;
				SkillDyManager.Instance.addSkill(skillDyVo);
				//加载技能特效
				if(DataCenter.Instance.mapSceneBasicVo.type!=TypeRole.MapScene_SafeArea) //非安全区域才进行特效加载 
				{
					SKillEffectLoadingManager.loadSkill(skillDyVo);
				}
			}
			SkillDyManager.Instance.setDefaultSkill(sSkillList.defaultSkill);
			
			onHeroLevelUp();//检查是否有可加点技能
		}
		
		/**
		 * 技能学习/升级返回 
		 * @param data
		 * 
		 */
		private function onServerSLearnSkill(sLearnSkill:SLearnSkill):void
		{
			var skillDyVo:SkillDyVo=null;
			switch(sLearnSkill.code)
			{
				case RspMsg.RSPMSG_SUCCESS: //技能升级成功
					var skillBasicVo:SkillBasicVo;
					if(sLearnSkill.skillLevel==1)
					{
						skillDyVo=new SkillDyVo();
						skillDyVo.skillId=sLearnSkill.skillId;
						skillDyVo.skillLevel=sLearnSkill.skillLevel;
						SkillDyManager.Instance.addSkill(skillDyVo);
//						NoticeUtil.setOperatorNotice("技能学习成功");
						_skillWindow.updateAutoPullSkill(skillDyVo.skillId);
						YFEventCenter.Instance.dispatchEventWith(SkillEvent.LearnNewSkillSuccess,skillDyVo);
						//加载技能特效
						SKillEffectLoadingManager.loadSkill(skillDyVo);
						
						skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
					}
					else //技能升级成功 
					{
						skillDyVo=SkillDyManager.Instance.getSkillDyVo(sLearnSkill.skillId);
						skillDyVo.skillLevel=sLearnSkill.skillLevel;
//						NoticeUtil.setOperatorNotice("技能升级成功");
						if(!QuickBoxManager.Instance.getQuickBoxDyVoId(SkillModuleType.QuickType_BT_SKILL,skillDyVo.skillId)) ////该技能不再快捷栏
						{
							_skillWindow.updateAutoPullSkill(skillDyVo.skillId);
						}
						skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
					}
					
					NoticeManager.setNotice(NoticeType.Notice_id_902,-1,skillBasicVo.see_consume);
					NoticeManager.setNotice(NoticeType.Notice_id_903,-1,skillBasicVo.name,skillBasicVo.skill_level);
					_skillWindow.setSelectNextSkill();
					_skillWindow.updateCareerSkillUI();
					_skillWindow.skillQuickPane.updateQuickBoxNum();
					//成长任务里称号
					YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.heroSkill);
					break;
				case RspMsg.RSPMSG_FAIL: //技能升级失败
					NoticeUtil.setOperatorNotice("学习技能失败");
					break;
			}
		}

		/**设置快捷方式 返回
		 */		
		private function onServerSSetQuickBox(sSetQuickBox:SSetQuickBox):void
		{
			switch(sSetQuickBox.code)
			{
				case RspMsg.RSPMSG_SUCCESS:
					QuickBoxManager.Instance.updateQuickBoxPosition(sSetQuickBox.oldBoxInfo.boxType,sSetQuickBox.oldBoxInfo.boxId,sSetQuickBox.oldBoxInfo.keyId); 
					QuickBoxManager.Instance.updateQuickBoxPosition(sSetQuickBox.newBoxInfo.boxType,sSetQuickBox.newBoxInfo.boxId,sSetQuickBox.newBoxInfo.keyId);
					_skillWindow.skillQuickPane.updateQuickBoxUI();
					//NoticeUtil.setOperatorNotice("快捷栏设置成功");
					break;
				case RspMsg.RSPMSG_FAIL: //技能升级失败
//					NoticeUtil.setOperatorNotice("快捷栏设置失败");
					break;
			}
		}
		
		/** 快捷栏信息返回
		 */
		private function onServerSQuickBoxInfo(sQuickBoxInfo:SQuickBoxInfo):void
		{
			if(sQuickBoxInfo)
			{
				if(sQuickBoxInfo.quickBoxArr)
				{
					for each(var quickBox:QuickBox in sQuickBoxInfo.quickBoxArr)
					{
						QuickBoxManager.Instance.initQuickBoxInfo(quickBox.boxType,quickBox.boxId,quickBox.keyId);
					}
					_skillWindow.skillQuickPane.updateQuickBoxUI();
				}
			}
		}

		/**技能洗点清空所有的技能
		 */
		private function onSResetSkill(sResetSkill:SResetSkill):void
		{
			SkillDyManager.Instance.reset();
			QuickBoxManager.Instance.clearSkill();
			_skillWindow.skillQuickPane.updateQuickBoxUI();
			_skillWindow.skillQuickPane.resetSkill();
			_skillWindow.updateResetAlSkill();
			_skillWindow.updateCareerSkillUI();
			NoticeUtil.setOperatorNotice("洗点成功");
			YFEventCenter.Instance.dispatchEventWith(SkillEvent.RestSkill);
		}
		/**
		 * 转职成功重置窗口UI和数据模型
		 * @param event
		 */
		private function onHeroChangeCareerSuccess(event:YFEvent=null):void
		{
			SkillDyManager.Instance.clear();
			_skillWindow.updateResetAlSkill();
			_skillWindow.updateCareerSkillUI();
		}
		

	}
}