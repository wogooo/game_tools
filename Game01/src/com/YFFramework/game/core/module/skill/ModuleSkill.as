package com.YFFramework.game.core.module.skill
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.CMDSkill;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.proto.DeleteSKillShortCutVo;
	import com.YFFramework.game.core.module.skill.model.proto.RequestSkillListResultVo;
	import com.YFFramework.game.core.module.skill.model.proto.SkillShortCutVo;
	import com.YFFramework.game.core.module.skill.view.SkillWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	/**  技能模块
	 * 2012-7-26 下午12:57:58
	 *@author yefeng
	 */
	public class ModuleSkill extends AbsModule
	{
		
		private var _skillWindow:SkillWindow;
		public function ModuleSkill()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function show():void
		{
			_skillWindow=new SkillWindow();
			addEvents();
		}
		/**
		 */		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillUIClick,onUIClick);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			
			
			
			////socket 发送
			//设置技能快捷方式
			YFEventCenter.Instance.addEventListener(SkillEvent.C_SetSkillShortCut,onSendSocket);
			///删除技能快捷方式
			YFEventCenter.Instance.addEventListener(SkillEvent.C_DeleteSkillShortCut,onSendSocket);
			
			
			
			///// socket 返回  
			YFEventCenter.Instance.addEventListener(SkillEvent.S_RequestSkillList,onSocketEvent);
			//設置技能快捷方式
			YFEventCenter.Instance.addEventListener(SkillEvent.S_SetSkillShortCut,onSocketEvent);
			//刪除技能快捷方式
			YFEventCenter.Instance.addEventListener(SkillEvent.S_DeleteSkillShortCut,onSocketEvent);
			//播放技能cd動畫
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKillPlayCD,onSocketEvent);
			
		}
		
		private function onUIClick(e:YFEvent):void
		{
			_skillWindow.toggle();	
		}
		
		/**
		 *请求技能列表 
		 */		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			//请求技能列表
			YFSocket.Instance.sendMessage(CMDSkill.C_RequestSkillList,null);
		}
		
		private function onSendSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case SkillEvent.C_SetSkillShortCut:
					///设置技能
					print(this,"设置技能快捷方式")
					var skillShortCutVo:SkillShortCutVo=e.param as SkillShortCutVo;
					YFSocket.Instance.sendMessage(CMDSkill.C_SetSkillShortCut,skillShortCutVo);
					break;
				case SkillEvent.C_DeleteSkillShortCut:
					//删除技能
					print(this,"删除技能快捷方式");
					var deleteSkillShortCutVo:DeleteSKillShortCutVo=e.param as DeleteSKillShortCutVo;
					YFSocket.Instance.sendMessage(CMDSkill.C_DeleteSkillShortCut,deleteSkillShortCutVo);
					break;
			}
		}
		
		
		
		
		/**服务端返回
		 */		
		private function onSocketEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case SkillEvent.S_RequestSkillList:
					var requestSkillListVo:RequestSkillListResultVo=e.param as RequestSkillListResultVo;
					var skillDyVo:SkillDyVo;
					for each (var skillDyObj:Object in requestSkillListVo.skillList)
					{
						skillDyVo=new SkillDyVo();
						skillDyVo.skillId=skillDyObj.id;
						skillDyVo.skillLevel=skillDyObj.level;
						skillDyVo.grid=skillDyObj.grid;
						SkillDyManager.Instance.addSkill(skillDyVo);
					}
					///设置默认技能
					SkillDyManager.Instance.setDefaultSkill(requestSkillListVo.defaultSkillId);
					_skillWindow.updateSkillList();
					break;
				case SkillEvent.S_SetSkillShortCut:
					///設置技能快捷方式
					var skillShortCutVo:SkillShortCutVo=e.param as SkillShortCutVo;
					///更新數據
					SkillDyManager.Instance.updateSKillGrid(skillShortCutVo.id,skillShortCutVo.grid);
					_skillWindow._skillMainUIView.updateSkillShortCut(skillShortCutVo);
					break;
				case SkillEvent.S_DeleteSkillShortCut:
					///刪除技能快捷方式
					var deleteSKillId:int=int(e.param);
					_skillWindow._skillMainUIView.updateDeleteSKillShortCut(deleteSKillId);
					break;
				case GlobalEvent.SKillPlayCD:
					//播放技能cd動畫
					var skilId:int=int(e.param);	
					_skillWindow._skillMainUIView.updatePlayCD(skilId);
					break;
			}
		}
		
	}
}