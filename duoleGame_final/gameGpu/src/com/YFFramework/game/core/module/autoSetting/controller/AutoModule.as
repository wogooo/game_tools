package com.YFFramework.game.core.module.autoSetting.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.autoSetting.view.AutoFightWindow;
	import com.YFFramework.game.core.module.autoSetting.view.AutoWindow;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.msg.hero.CUseItem;
	import com.msg.sys.CAutoConfigRead;
	import com.msg.sys.CAutoConfigSave;
	import com.msg.sys.SAutoConfigRead;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-17 下午4:52:21
	 */
	public class AutoModule extends AbsModule{
		
		private var _autoWindow:AutoWindow;
		
		public function AutoModule(){
			_autoWindow = new AutoWindow();
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.AutoUIClick,onUIClick);			//打开面板请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onChangeMap);
			YFEventCenter.Instance.addEventListener(GlobalEvent.AutoMonsterUpdate,onChangeMap);
			YFEventCenter.Instance.addEventListener(AutoEvent.SAVE,onSave);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
			YFEventCenter.Instance.addEventListener(SkillEvent.LearnNewSkillSuccess,onLearnSkill);
			YFEventCenter.Instance.addEventListener(SkillEvent.RestSkill,onClearSkill);
			YFEventCenter.Instance.addEventListener(RaidEvent.EnterAllRaid,onEnterAllRaid);
			//进入副本的剧情播放完 时
			YFEventCenter.Instance.addEventListener(StoryEvent.RaidStoryStartComplete,onStroyEvent);
		}
		private function onStroyEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case StoryEvent.RaidStoryStartComplete:
					//副本开始时候的剧情  剧情结束后进行挂机
					startGuaji();
					break;
			}
		}
		private function onEnterAllRaid(e:YFEvent):void
		{
			var raidVo:RaidVo=e.param as RaidVo;
			if(raidVo.story_start_id>0)  //有剧情id 
			{
				var storyVo:StoryShowVo=new StoryShowVo();
				storyVo.id=raidVo.story_start_id;
				storyVo.storyPositionType=TypeStory.StoryPositionType_RaidStart;
				YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,storyVo);
			}
			else 
			{
				startGuaji(); //开始挂机
			}
		}
		
		/**开始挂机UI显示
		 */
		private function startGuaji():void
		{
			var autoFightWind:AutoFightWindow=new AutoFightWindow();
			autoFightWind.open();
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SAutoConfigRead,SAutoConfigRead,onAutoConfig);		//返回配置数据
		}
		
		/**技能洗点清除全部技能
		 * @param e 
		 */		
		private function onClearSkill(e:YFEvent):void{
			_autoWindow.clearSkills();
			AutoManager.Instance._skillArr = new Array(10);
			_autoWindow.updateAuto();
			_autoWindow.onSave();
		}
		
		/**新学习技能自动放在面板上
		 * @param e
		 */		
		private function onLearnSkill(e:YFEvent):void{
			var bvo:SkillBasicVo = SkillBasicManager.Instance.getSkillBasicVo(SkillDyVo(e.param).skillId,SkillDyVo(e.param).skillLevel);
			if(bvo.use_type==TypeSkill.UseType_Passive) return;
			
			var arr:Array = AutoManager.Instance._skillArr;
			for(var i:int=0;i<arr.length;i++){
				if(arr[i]==-1){
					arr[i] = SkillDyVo(e.param).skillId;
					break;
				}
			}
			_autoWindow.updateAuto();
			_autoWindow.onSave();
		}
		
		/**背包改变事件通知
		 * @param e
		 */		
		private function onBagChange(e:YFEvent):void{
			if(AutoManager.autoUseTempId!=-1){
				var pos:int = PropsDyManager.instance.getFirstPropsPos(AutoManager.autoUseTempId);
				if(pos!=0){
					var msg:CUseItem = new CUseItem();
					msg.itemPos = pos;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
					AutoManager.autoUseTempId=-1;
				}
			}
//			while(AutoManager.autoUseTempIdArr.length>0){
//				var pos:int = PropsDyManager.instance.getFirstPropsPos(AutoManager.autoUseTempIdArr[0]);
//				if(pos!=0){
//					var msg:CUseItem = new CUseItem();
//					msg.itemPos = pos;
//					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
//					AutoManager.autoUseTempIdArr.splice(0,1);
//				}
//			}
		}
		
		private function onUIClick(e:YFEvent):void{
			_autoWindow.switchOpenClose();
			_autoWindow.updateAuto();
		}
		
		/**自动挂机保存
		 * @param e
		 */		
		private function onSave(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAutoConfigSave,e.param as CAutoConfigSave);
		}
		
		/** 收到挂机设置回复
		 * @param msg
		 */		
		private function onAutoConfig(msg:SAutoConfigRead):void{
			AutoManager.Instance.loadConfig(msg.configBoolArr,msg.configIntArr);
		}
		
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAutoConfigRead,new CAutoConfigRead());
		}
		
		/**更换场景时重置怪物列表
		 * @param e
		 */		
		private function onChangeMap(e:YFEvent):void{
			if(_autoWindow.isOpen)	_autoWindow.onChangeScene();
			_autoWindow.updateMonster();
		}
	}
} 