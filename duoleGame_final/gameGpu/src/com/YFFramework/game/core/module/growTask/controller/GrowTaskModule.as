package com.YFFramework.game.core.module.growTask.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.growTask.manager.GrowTaskDyManager;
	import com.YFFramework.game.core.module.growTask.model.GrowTaskDyVo;
	import com.YFFramework.game.core.module.growTask.source.GrowTaskSource;
	import com.YFFramework.game.core.module.growTask.view.GrowTaskWindow;
	import com.YFFramework.game.core.module.im.manager.IMManager;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.data.RankDyManager;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.manager.EquipIDManager;
	import com.msg.grow_task.*;
	import com.net.MsgPool;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-7-15 下午4:55:26
	 */
	public class GrowTaskModule extends AbsModule{
		
		private var _growTaskWindow:GrowTaskWindow;
		
		public function GrowTaskModule()
		{
			_growTaskWindow = new GrowTaskWindow();
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GrowTaskUIClick,onUIClick);
			YFEventCenter.Instance.addEventListener(GrowTaskEvent.GrowTaskRewardReq,rewardReq);
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SGrowTaskList,SGrowTaskList,onGrowTaskList);//服务端发来成长任务数据
			MsgPool.addCallBack(GameCmd.SFinishGrowTask,SFinishGrowTask,onFinishTask);//完成某个任务
			MsgPool.addCallBack(GameCmd.SGetGrowTaskReward,SGetGrowTaskReward,onGetReward);//领取奖励返回
		}
		
		/**领取奖励回复
		 * @param msg
		 */
		private function onGetReward(msg:SGetGrowTaskReward):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				GrowTaskDyManager.Instance.removeTask(msg.taskId);
				_growTaskWindow.updateTasks();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GrowTaskEffUpdate);
			}
		}
		
		private function onFinishTask(msg:SFinishGrowTask):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				//NoticeUtil.setOperatorNotice("完成---"+GrowTaskDyManager.Instance.getGrowTaskVo(msg.taskId).taskDesc);
				GrowTaskDyManager.Instance.finishTask(msg.taskId);
				_growTaskWindow.updateTasks();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GrowTaskEffUpdate);
				var vo:GrowTaskDyVo = GrowTaskDyManager.Instance.getGrowTaskVo(msg.taskId);
				if(!GrowTaskDyManager.Instance.containsTaskType(vo.targetType)){
					switch(vo.targetType){
						case GrowTaskSource.GROW_TASK_TYPE_PLAYER_LV:
							YFEventCenter.Instance.removeEventListener(GlobalEvent.HeroLevelUp,onHeroLvUp);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_HAS_PET:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.PetChange,onPetChange);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_HERO_EQUIP:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroEquip);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_HERO_WING:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroWing);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_FRIEND_NUM:
							YFEventCenter.Instance.removeEventListener(GlobalEvent.AddFriendSuccess,onFriendNumber);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_MOUNT:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.MountChange,onMountChange);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_HERO_GEM:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroGem);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_HERO_SKILL:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.heroSkill,onHeroSkillChange);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_ARENA:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.activity_arena,onActivityArena);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_GUILD:
							YFEventCenter.Instance.removeEventListener(GrowTaskEvent.attend_guild,onAttendGuild);
							break;
						case GrowTaskSource.GROW_TASK_TYPE_GAME_MONEY://这里监听的是所有货币改变的事件，其实魔钻要单独计算的
							YFEventCenter.Instance.removeEventListener(GlobalEvent.MoneyChange,onGameMoney);
//							trace("游戏币移除")
							break;
						case GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_DEMON:
							YFEventCenter.Instance.removeEventListener(DemonEvent.DemonLevelChange,onActivityDemon);
							break;
					}
				}
			}else{
//				NoticeUtil.setOperatorNotice("失败，测试用的---"+GrowTaskDyManager.Instance.getGrowTaskVo(msg.taskId).taskDesc);
//				NoticeUtil.setOperatorNotice("失败，测试用的---,有bug");
			}
		}
		
		private function onUIClick(e:YFEvent):void{
			_growTaskWindow.switchOpenClose();
			_growTaskWindow.updateTasks(true);
		}
		
		private function onGrowTaskList(msg:SGrowTaskList):void{
			if(msg!=null)	GrowTaskDyManager.Instance.updateStatus(msg.growTaskArr);
			GrowTaskDyManager.Instance.initTaskTypeArray();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GrowTaskEffUpdate);
			var typeArr:Array = GrowTaskDyManager.Instance.getTaskTypeArr();
			var len:int = typeArr.length;
			for(var i:int=0;i<len;i++){
				switch(typeArr[i]){
					case GrowTaskSource.GROW_TASK_TYPE_PLAYER_LV:
						YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLvUp);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HAS_PET:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.PetChange,onPetChange);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HERO_EQUIP:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroEquip);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HERO_WING:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroWing);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_FRIEND_NUM:
						YFEventCenter.Instance.addEventListener(GlobalEvent.AddFriendSuccess,onFriendNumber);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_MOUNT:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.MountChange,onMountChange);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HERO_GEM:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.HasHeroEquip,onHasHeroGem);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HERO_SKILL:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.heroSkill,onHeroSkillChange);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_ARENA:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.activity_arena,onActivityArena);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_GUILD:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.attend_guild,onAttendGuild);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_GAME_MONEY:
						YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onGameMoney);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_HERO_ATTR:
						YFEventCenter.Instance.addEventListener(GrowTaskEvent.hero_attr,onHeroAttr);
						break;
					case GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_DEMON:
						YFEventCenter.Instance.addEventListener(DemonEvent.DemonLevelChange,onActivityDemon);
						break;
				}
			}
		}
		
		/**拥有坐骑类型
		 * @param e
		 */
		private function onMountChange(e:YFEvent):void{
			var tasksAry:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_MOUNT);
//			var len:int = tasksAry.length;
//			var vo:MountDyVo;
			var bvo:MountBasicVo;
			var mounts:Array=MountDyManager.Instance.getAllMount();
			for each(var task:GrowTaskDyVo in tasksAry)
			{				
//				if(task.targetId!=0){
				for each(var mount:MountDyVo in mounts)
				{
					bvo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
					if(mount.basicId == task.targetId && bvo.quality>=task.targetQuality)
					{
						sendFinishTask(task.taskId);
					}
				}				
//				}
//				else{
//					var mountArr:Array = MountDyManager.Instance.getMountsIdArr();
//					var len2:int = mountArr.length;
//					var numOfOKMounts:int = 0;
//					for(var j:int=0;j<len2;j++){
//						vo = MountDyManager.Instance.getMount(mountArr[j]);
//						bvo = MountBasicManager.Instance.getMountBasicVo(vo.basicId);
//						if(bvo.quality>=task.targetQuality){
//							numOfOKMounts++;
//						}
//					}
//					if(numOfOKMounts>=task.targetNumber){
//						sendFinishTask(task.taskId);
//					}
//				}
			}
		}
		
		/**好友数量类型
		 * @param e
		 */
		private function onFriendNumber(e:YFEvent):void{
			var arr:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_FRIEND_NUM);
			var len:int = arr.length;
			var frdNum:int = IMManager.Instance.friendList.getArray().length;
			for(var i:int=0;i<len;i++){
				if(frdNum>=GrowTaskDyVo(arr[i]).targetNumber){
					sendFinishTask(GrowTaskDyVo(arr[i]).taskId);
				}
			}
		}
		
		/**身上宝石类型
		 * @param e
		 */
		private function onHasHeroGem(e:YFEvent):void{
			var arr:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HERO_GEM);
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				var equipArr:Array = CharacterDyManager.Instance.getAllEquips();
				var len2:int = equipArr.length;
				var numOfOKGems:int=0;
				for(var j:int=0;j<len2;j++){
					var vo:EquipDyVo = equipArr[j];
					var bvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
					if(bvo.type!=TypeProps.EQUIP_TYPE_WINGS)	numOfOKGems += vo.getGemNum(GrowTaskDyVo(arr[i]).targetQuality);
				}
				if(numOfOKGems>=GrowTaskDyVo(arr[i]).targetNumber){
					sendFinishTask(GrowTaskDyVo(arr[i]).taskId);
				}
			}
		}
		
		/**翅膀任务 */
		private function onHasHeroWing(e:YFEvent):void{
			var tasks:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HERO_WING);
			var wingTmpId:int;
			var bvo:EquipBasicVo;
			var dyVo:EquipDyVo;
			for each(var taskVo:GrowTaskDyVo in tasks){				
				dyVo = CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);						
				if(dyVo)//有没有翅膀
				{
					wingTmpId=EquipIDManager.getCareerEquipID(taskVo.targetId);//因为表里填的是任意翅膀，要把模板id转化成对应职业的翅膀 
					bvo = EquipBasicManager.Instance.getEquipBasicVo(wingTmpId);
					if(dyVo.template_id == wingTmpId)
					{
						sendFinishTask(taskVo.taskId);
					}
				}
			}
		}
		
		/**身上装备类型  */		
		private function onHasHeroEquip(e:YFEvent):void{
			var arr:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HERO_EQUIP);
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				var bvo:EquipBasicVo;
				var vo:EquipDyVo;
				if(GrowTaskDyVo(arr[i]).targetId!=0){//指定装备
					bvo = EquipBasicManager.Instance.getEquipBasicVo(GrowTaskDyVo(arr[i]).targetId);
					vo = CharacterDyManager.Instance.getEquipInfoByPos(bvo.type);
					if(vo.equip_id==GrowTaskDyVo(arr[i]).targetId && vo.enhance_level>=GrowTaskDyVo(arr[i]).targetLevel && 
						bvo.quality>=GrowTaskDyVo(arr[i]).targetQuality && bvo.type!=TypeProps.EQUIP_TYPE_WINGS){
						sendFinishTask(GrowTaskDyVo(arr[i]).taskId);
					}
				}else{
					var equipArr:Array = CharacterDyManager.Instance.getAllEquips();
					var len2:int = equipArr.length;
					var numOfOKEquips:int=0;
					for(var j:int=0;j<len2;j++){
						vo = equipArr[j];
						bvo = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
						if(vo.enhance_level>=GrowTaskDyVo(arr[i]).targetLevel && bvo.quality>=GrowTaskDyVo(arr[i]).targetQuality && 
							bvo.type!=TypeProps.EQUIP_TYPE_WINGS){
							numOfOKEquips++;
						}
					}
					if(numOfOKEquips>=GrowTaskDyVo(arr[i]).targetNumber){
						sendFinishTask(GrowTaskDyVo(arr[i]).taskId);
					}
				}
			}
		}
		
		/**拥有宠物类型
		 * @param e
		 */		
		private function onPetChange(e:YFEvent):void{
			var taskAry:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HAS_PET);
			var petsAry:Array = PetDyManager.Instance.getAllPetsInfo();
			var quality:int=0;
			var petBsVo:PetBasicVo;
			for each(var task:GrowTaskDyVo in taskAry)
			{
				for each(var pet:PetDyVo in petsAry)
				{
					petBsVo=PetBasicManager.Instance.getPetConfigVo(pet.basicId);
					quality=PetDyManager.Instance.getGrowQuality(pet.dyId);
					if(task.targetId == petBsVo.pet_type && pet.level>=task.targetLevel &&  quality>= task.targetQuality)
					{
						sendFinishTask(task.taskId);
					}
				}
			}
		}
		
		/**角色等级类型
		 * @param e
		 */		
		private function onHeroLvUp(e:YFEvent):void{
			var myLevel:int = DataCenter.Instance.roleSelfVo.roleDyVo.level;
			var arr:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_PLAYER_LV);
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				if(myLevel>=GrowTaskDyVo(arr[i]).targetLevel){
					sendFinishTask(GrowTaskDyVo(arr[i]).taskId);
				}
			}
		}
		
		/** 角色技能升级改变 */
		private function onHeroSkillChange(e:YFEvent):void
		{
			var arr:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HERO_SKILL);
			var skill:SkillDyVo;
			for each(var grow:GrowTaskDyVo in arr)
			{
				skill=SkillDyManager.Instance.getSkillDyVo(grow.targetId);
				if(skill && skill.skillLevel == grow.targetLevel)
					sendFinishTask(grow.taskId);
			}
		}
		
		/** 竞技场活动 */
		private function onActivityArena(e:YFEvent):void
		{
			var ary:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_ARENA);
			var score:int;
			for each(var grow:GrowTaskDyVo in ary)
			{
				score=RankDyManager.instance.getMyArenaScore(grow.targetId);
				if(grow.targetNumber >= score)
					sendFinishTask(grow.taskId);
			}
		}
		
		/** 加入公会 */
		private function onAttendGuild(e:YFEvent):void
		{
			var ary:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_GUILD);
			for each(var grow:GrowTaskDyVo in ary)
			{
				if(CharacterDyManager.Instance.unionName != '')
				{
					sendFinishTask(grow.taskId);
				}
			}
		}
		
		/** 拥有多少游戏币(暂时不包括魔钻) */
		private function onGameMoney(e:YFEvent):void
		{
			var ary:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_GAME_MONEY);
			for each(var grow:GrowTaskDyVo in ary)
			{
				var note:int=DataCenter.Instance.roleSelfVo.note;
				if((grow.targetId == RewardTypes.COUPON && grow.targetNumber <= DataCenter.Instance.roleSelfVo.coupon) ||
					grow.targetId == RewardTypes.NOTE && grow.targetNumber <= DataCenter.Instance.roleSelfVo.note)
				{
					sendFinishTask(grow.taskId);
				}
			}
		}
		
		/** 人物属性改变 */
		private function onHeroAttr(e:YFEvent):void
		{
			var ary:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_HERO_ATTR);
			for each(var grow:GrowTaskDyVo in ary)
			{
				if((grow.targetId == TypeProps.EA_HEALTH_LIMIT && grow.targetNumber <= DataCenter.Instance.roleSelfVo.roleDyVo.maxHp) ||
					(grow.targetId == TypeProps.EA_MANA_LIMIT && grow.targetNumber <= DataCenter.Instance.roleSelfVo.roleDyVo.maxMp) ||
					CharacterDyManager.Instance.propArr[grow.targetId] >= grow.targetNumber)
				{
					sendFinishTask(grow.taskId);
				}
			}
		}
		
		/** 魔族入侵活动波数 */
		private function onActivityDemon(e:YFEvent):void
		{
			var ary:Array = GrowTaskDyManager.Instance.getTaskListArrayByType(GrowTaskSource.GROW_TASK_TYPE_ACTIVITY_DEMON);
			var max:int=e.param as int;
			for each(var grow:GrowTaskDyVo in ary)
			{
				if(grow.targetNumber <= max)
				{
					sendFinishTask(grow.taskId);
				}
			}
		}
		
		/**发送完成任务请求
		 * @param taskId
		 */		
		private function sendFinishTask(taskId:int):void{
			var msg:CFinishGrowTask = new CFinishGrowTask();
			msg.taskId = taskId;
			MsgPool.sendGameMsg(GameCmd.CFinishGrowTask,msg);
		}
		
		/**领取奖励请求
		 * @param e
		 */		
		private function rewardReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CGetGrowTaskReward,(e.param) as CGetGrowTaskReward);
		}
		
		/**初始化列表请求
		 * @param e
		 */		
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CGrowTaskList,new CGrowTaskList());
		}
	}
} 