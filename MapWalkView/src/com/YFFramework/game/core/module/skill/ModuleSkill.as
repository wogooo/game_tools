package com.YFFramework.game.core.module.skill
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.window.SkillGridManager;
	import com.YFFramework.game.core.module.skill.window.SkillTree;
	import com.YFFramework.game.core.module.skill.window.SkillWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.managers.UIManager;
	import com.msg.common.SkillInfo;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CRequestQuickBox;
	import com.msg.hero.SQuickBoxInfo;
	import com.msg.skill_pro.CRequestSkillList;
	import com.msg.skill_pro.SLearnSkill;
	import com.msg.skill_pro.SSkillList;
	import com.net.MsgPool;
	
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
		
		override public function init():void
		{
			_skillWindow=new SkillWindow();
			addEvents();
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onHeroChangeCareerSuccess);
		}
		
		private function onHeroChangeCareerSuccess(event:YFEvent):void
		{
			var isOpen:Boolean = _skillWindow.isOpen;
			var xy:Array = [_skillWindow.x,_skillWindow.y];
			if(isOpen == true){
				_skillWindow.parent.removeChild(_skillWindow);
			}
			SkillTree.reset();
			_skillWindow = new SkillWindow();
			if(isOpen){
				_skillWindow.open();
				_skillWindow.alpha = 1;
				_skillWindow.x = xy[0];
				_skillWindow.y = xy[1];
			}
		}
		
		/**
		 */		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillUIClick,onUIClick);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			///请求技能列表
			MsgPool.addCallBack(GameCmd.SSkillList,SSkillList,skillListCallBack);		
			MsgPool.addCallBack(GameCmd.SLearnSkill,SLearnSkill,onServerSLearnSkill);
			MsgPool.addCallBack(GameCmd.SQuickBoxInfo,SQuickBoxInfo,onServerSQuickBoxInfo);
		}
		
		private function onServerSQuickBoxInfo(data:SQuickBoxInfo):void
		{
			var arr:Array = data.quickBoxArr;
			for(var i:Object in arr){
				SkillGridManager.getInstance().resetGrid(arr[i]);
			}
		}
		
		private function onServerSLearnSkill(data:SLearnSkill):void
		{
			if(data.code == RspMsg.RSPMSG_SUCCESS){
				Alert.show(LangBasic.skillLearnSuccess,LangBasic.skill);
			}else if(data.code == RspMsg.RSPMSG_FAIL){
				Alert.show(LangBasic.skillLearnFaild,LangBasic.skill);
			}
		}
		
		private function onUIClick(e:YFEvent):void
		{
			UIManager.switchOpenClose(_skillWindow);
		}
		
		/**服务端返回技能列表信息
		 */		
		private function skillListCallBack(sSkillList:SSkillList):void
		{
			///缓存技能列表
			var skillDyVo:SkillDyVo;
			for each(var skillInfo:SkillInfo in sSkillList.skillListArr){
				skillDyVo=new SkillDyVo();
				skillDyVo.skillId=skillInfo.skillId;
				skillDyVo.skillLevel=skillInfo.skillLevel;
				SkillDyManager.Instance.addSkill(skillDyVo);
			}
			SkillDyManager.Instance.setDefaultSkill(sSkillList.defaultSkill);
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
		
	}
}