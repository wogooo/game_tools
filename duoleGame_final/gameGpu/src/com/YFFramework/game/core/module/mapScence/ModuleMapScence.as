package com.YFFramework.game.core.module.mapScence
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.Gather_ConfigBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.Gather_ConfigBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.character.model.TitleDyManager;
	import com.YFFramework.game.core.module.chat.model.ChatMsgVo;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.demon.manager.DemonManager;
	import com.YFFramework.game.core.module.demon.model.DemonSkillType;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.HeroBuffDyManager;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.manager.PetBuffDyManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.UAtkInfo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.view.MapScenceView;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.PlayerMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.view.scene.ZiDongXunLuView;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.system.event.SystemEvent;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.YFFramework.game.debug.Log;
	import com.dolo.common.SystemTool;
	import com.msg.actv.CUseCannon;
	import com.msg.actv.CUseMoonWell;
	import com.msg.actv.SUseCannon;
	import com.msg.actv.SUseMoonWell;
	import com.msg.enumdef.EquipType;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CPickupItem;
	import com.msg.hero.CPickupMultiItems;
	import com.msg.hero.SChangeCareer;
	import com.msg.hero.SChangeCareerNotify;
	import com.msg.hero.SCompeteWin;
	import com.msg.hero.SFinishCompete;
	import com.msg.hero.SHeroUseItemNotify;
	import com.msg.hero.SHpChange;
	import com.msg.hero.SMpChange;
	import com.msg.hero.SNameColorNotify;
	import com.msg.hero.SOtherRoleLevelup;
	import com.msg.hero.SPickupItem;
	import com.msg.hero.SPickupMultiItems;
	import com.msg.hero.SRoleLevelup;
	import com.msg.hero.SShortMove;
	import com.msg.login.CClientInitOK;
	import com.msg.mapScene.CEnterNewMap;
	import com.msg.mapScene.CFly;
	import com.msg.mapScene.CGather;
	import com.msg.mapScene.CHeroMoving;
	import com.msg.mapScene.CPetMoving;
	import com.msg.mapScene.CPetPull;
	import com.msg.mapScene.CReviveHero;
	import com.msg.mapScene.OtherRoleInfo;
	import com.msg.mapScene.SEnterNewMap;
	import com.msg.mapScene.SFirstEnterInfo;
	import com.msg.mapScene.SGather;
	import com.msg.mapScene.SHeroDead;
	import com.msg.mapScene.SHeroEquipChange;
	import com.msg.mapScene.SHeroPull;
	import com.msg.mapScene.SMonsterBirth;
	import com.msg.mapScene.SMonsterMoving;
	import com.msg.mapScene.SOtherRoleHpMpChange;
	import com.msg.mapScene.SOtherRoleInfo;
	import com.msg.mapScene.SOtherRoleListExitView;
	import com.msg.mapScene.SOtherRoleMoving;
	import com.msg.mapScene.SPetCloseTarget;
	import com.msg.mapScene.SPetMoving;
	import com.msg.mapScene.SPetPull;
	import com.msg.mapScene.SPetRenameNotify;
	import com.msg.mapScene.SReviveHero;
	import com.msg.mount_pro.SChangeMountNotify;
	import com.msg.pets.SOtherPetLevelup;
	import com.msg.pets.SPetUseItemNotify;
	import com.msg.skill_pro.BeatBackTarget;
	import com.msg.skill_pro.CFight;
	import com.msg.skill_pro.CFightBeatBack;
	import com.msg.skill_pro.DamageInfo;
	import com.msg.skill_pro.SBuffDamage;
	import com.msg.skill_pro.SFight;
	import com.msg.skill_pro.SRemoveBuff;
	import com.msg.title_pro.SUseTitleNotify;
	import com.net.MsgPool;
	
	import flash.geom.Point;

	/**场景模块
	 * @author yefeng
	 *2012-4-20下午9:39:18
	 */
	
	public class ModuleMapScence extends AbsModule
	{
		private var _mapScenceView:MapScenceView;
		public function ModuleMapScence()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;//所属类型为游戏进行中的类型
			initUI();
		}
		
		override public function init():void
		{
			addEvents();
			addSocketCallback();
		}
		private function initUI():void
		{
			_mapScenceView=new MapScenceView();
//			StageProxy.Instance.mouseDown.regFunc(onFunc);
		}
//		private function onFunc():void
//		{
//			LayerManager.NoticeLayer.setOperatorNotice("您好");
//		}
		
		private function addEvents():void
		{
			//进入游戏 
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSendSocketEvent);
//			///////////c -------------- socket 发送
//			//主角在移动当中
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_HeroMoving,onSendSocketEvent);
			
			//			///拉取宠物 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PullPet,onSendSocketEvent);
			///宠物移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PetMoving,onSendSocketEvent);
				///开始战斗
				///群攻  无 鼠标点
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore,onSendSocketEvent);///开始战斗
				///具有鼠标点信息
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore_Pt,onSendSocketEvent);///开始战斗


			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMoreBeatBack,onSendSocketEvent);///开始战斗 击退 

			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore_PtBeatBack,onSendSocketEvent);///开始战斗

			

			//			////人物复活请求
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_RoleRevive,onSendSocketEvent);
			
			//			///切换场景
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_ChangeMapScence,onSendSocketEvent);
			///副本模块事件 请求离开副本
			YFEventCenter.Instance.addEventListener(GlobalEvent.RaidLeave,onSendSocketEvent);

			//			//	通知服务端拾取物物品
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_GetDropGoods,onSendSocketEvent);
			//批量拾取道具
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_GetMoreDropGoods,onSendSocketEvent);

			//			移形换影  主角瞬移
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_BlinkMove,onSendSocketEvent);
			//			///玩家瞬移到某个地方
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_SKipToPoint,onSendSocketEvent);
			//请求采集
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_RequestGather,onSendSocketEvent);
			///主角宠物升级 播放升级动画
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetLevelUp,onPetLevelUp);			
			///// recevive--------------
			
						//玩家角色血量改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,onHeroHpChange);
			
			///开始切磋 播放切磋特效
			YFEventCenter.Instance.addEventListener(GlobalEvent.BeginCompeting,onBeginCompeting);
			//自己称号改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.TITLE_UPDATE,onTittleUpdate);
			//人物 说话 场景进行冒泡说话
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatToScene,onChatScene);
			
			YFEventCenter.Instance.addEventListener(SystemEvent.SystemConfigChange,onSystemConfigChange);
			
			
			
			///魔神入侵副本 双击触发魔神大炮 进行全屏攻击 月井 和魔神大炮
			YFEventCenter.Instance.addEventListener(DemonEvent.TriggerDemonRaidSkill,onTriggerDemonRaidSkill);

			//			///人物切换坐骑状态
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_Mounting,onSendSocketEvent);///角色切换坐骑状态  /// 上坐骑
//			///
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_DisMounting,onSendSocketEvent);///角色切换坐骑状态  /// 上坐骑
//
//			
//			///怪物处在移动当中
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterMoving,onSendSocketEvent);
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterBeginMove,onSendSocketEvent);
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterStopMove,onSendSocketEvent);///怪物停止移动
//			
//
//			
//			/// 推开 或者拉取 角色时 的通讯  瞬间改变 该角色在服务端的位置     该通迅并不需要返回  只是改变 拉取 推离角色在服务端的位置
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_BackSlideMove,onSendSocketEvent);
//			///请求打坐
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_Sit,onSendSocketEvent);
//			///请求离开打坐
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_OutSit,onSendSocketEvent);
//			///主角停止移动
//
//			
//
//			
//		////s ------------ socket返回 
//			//玩家成功登陆进入游戏  
//			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSocketEvent);
//			///人物 切换场景 进入新场景
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_HeroEnterMap,onSocketEvent);
//			///其他角色玩家进入 可视范围
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleEnterView,onSocketEvent);
//			///其他角色列表 进入可视范围 
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleListEnterView,onSocketEvent);
//			///  物品掉落 
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_DropGoodsEnterView,onSocketEvent);
//
//			//其他角色离开主角视野
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleExitView,onSocketEvent);
//			///其他 角色列表离开主角视野
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleListExitView,onSocketEvent);
//
//			//其他角色开始进行移动
//				///其他角色正在进行移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_otherRoleMoving,onSocketEvent);
//			
//			///玩家离线
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_AnimatorExitScence,onSocketEvent);
//			////怪物死亡离开场景
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterExitScence,onSocketEvent);
//			///人物死亡
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_RoleDead,onSocketEvent);
//			///人物复活
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_RoleRevive,onSocketEvent);
//			
//			///玩家切换坐骑状态   上坐骑
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_Mounting,onSocketEvent);
//			///下坐骑
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_DisMounting,onSocketEvent);
//
//			///服务端返回战斗数据
//			///群攻 鼠标点信息
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightMore,onSocketEvent);
//			///群攻 有鼠标点信息
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightMore_Pt,onSocketEvent);
//			///单一攻击
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightSingle,onSocketEvent);
//
//			////移形换影   瞬移 
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_BlinkMove,onSocketEvent);
//			///其他屏幕进行坐标校验拉取处理 滑动推拉校验 
//		//	YFEventCenter.Instance.addEventListener(MapScenceEvent.S_BackSlideMove,onSocketEvent);
//			
//			///怪物开始移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterBeginMove,onSocketEvent);
//			/// 怪物处于移动中
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterMoving,onSocketEvent);
//			
//			///怪物进入主角可视范围
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterEnterView,onSocketEvent);
//			///怪物出生
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterBirth,onSocketEvent);
//			
//			///怪物离开主角可视范围
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterExitView,onSocketEvent);
//			///怪物停止移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterStopMove,onSocketEvent);
//			/////////////////////怪物ai -----------------------------------
//			///怪物设置目标
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterSetTarget,onSocketEvent);
//			///怪物解除目标
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterFreeTarget,onSocketEvent);
//			///怪物向玩家靠近
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterNearToPlayer,onSocketEvent);
//			//怪物对人物发起攻击
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterHitPlayer,onSocketEvent);
//
//			////宠物 
//			////宠物进入视野
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetEnterView,onSocketEvent);
//			/**宠物离开玩家视野
//			 */ 
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetExitView,onSocketEvent);
//			///宠物出战
//			YFEventCenter.Instance.addEventListener(GlobalEvent.PetPlay,onSocketEvent);
//			//服务端返回拉取宠物的结果
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PullPet,onSocketEvent);
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetMoving,onSocketEvent);
//			///宠物向目标玩家靠近 准备发起攻击
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetMoveToTarget,onSocketEvent);
//			//服务端返回打坐
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_Sit,onSocketEvent);
//			//服务端返回离开打坐
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_outSit,onSocketEvent);
//			///  拾取物品失败
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FailToGetDropGoods,onSocketEvent);
//			/// 跳转
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_SKipToPoint,onSocketEvent);
//			///跳转失败
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FailSKipToPoint,onSocketEvent);
			
		}
		
		/**接受服务端发过来的socket事件
		 */		
		private function addSocketCallback():void
		{
			///玩家第一次登录的信息
			MsgPool.addCallBack(GameCmd.SFirstEnterInfo,SFirstEnterInfo,createHeroCallback);
			///主角进入
			MsgPool.addCallBack(GameCmd.SEnterNewMap,SEnterNewMap,heroEnterMap);
			
			///短距离 移动   短距离移动，发送给对自己可视的所有玩家，移动导致的视野切换在此消息之后发
			MsgPool.addCallBack(GameCmd.SShortMove,SShortMove,onShortMove);
			
			
			///小飞鞋 协议返回  
			MsgPool.addCallBack(GameCmd.SFly,SEnterNewMap,onSkipPoint);
			// 主角 非法移动的拉取   拉取到正确的位置
			MsgPool.addCallBack(GameCmd.SHeroPull,SHeroPull,onSHeroPull);

			///其他玩家列表信息
			MsgPool.addCallBack(GameCmd.SOtherRoleInfo,SOtherRoleInfo,otherRoleListEnterView);
			///主角发生移动
			MsgPool.addCallBack(GameCmd.SOtherRoleMoving,SOtherRoleMoving,otherRoleMoving);
			///玩家离开视野
			MsgPool.addCallBack(GameCmd.SOtherRoleListExitView,SOtherRoleListExitView,otherRoleListExitView);  ///不包括宠物  只包含玩家和怪物
			//宠物 收回 
//			MsgPool.addCallBack(GameCmd.SPetBackLeave,SOtherRoleListExitView,petBack);  ///不包括宠物  只包含玩家和怪物
 
			 
			//怪物移动
			MsgPool.addCallBack(GameCmd.SMonsterMoving,SMonsterMoving,monsterMoving);
			///宠物移动 
			MsgPool.addCallBack(GameCmd.SPetMoving,SPetMoving,petMoving);
			///拉取宠物
			MsgPool.addCallBack(GameCmd.SPetPull,SPetPull,onPetPull);
			///战斗
			MsgPool.addCallBack(GameCmd.SFight,SFight,onFight);
			///怪物出生
			MsgPool.addCallBack(GameCmd.SMonsterBirth,SMonsterBirth,onMonsterBirth);
			///向怪物靠近
			MsgPool.addCallBack(GameCmd.SPetCloseTarget,SPetCloseTarget,petMoveToTarget);
			///人物复活
			MsgPool.addCallBack(GameCmd.SReviveHero,SReviveHero,reviveCallBack);
			///主角死亡
			MsgPool.addCallBack(GameCmd.SHeroDead,SHeroDead,heroDead);
			///当前玩家升级 
			MsgPool.addCallBack(GameCmd.SRoleLevelup,SRoleLevelup,roleLevelUp);
			///其他玩家升级
			MsgPool.addCallBack(GameCmd.SOtherRoleLevelup,SOtherRoleLevelup,otherOtherRoleLevelUp);
			///其他宠物升级
			MsgPool.addCallBack(GameCmd.SOtherPetLevelup,SOtherPetLevelup,otherPetLevelup);
			///其他玩家血量魔法值改变
			MsgPool.addCallBack(GameCmd.SOtherRoleHpMpChange,SOtherRoleHpMpChange,otherRoleHpMpChange);
			///人物换装 这个消息是广播的
			MsgPool.addCallBack(GameCmd.SHeroEquipChange,SHeroEquipChange,onHeroEquipChange);
			///掉落物品拾取返回
			MsgPool.addCallBack(GameCmd.SPickupItem,SPickupItem,onPickUpItem);
			//批量拾取道具
			MsgPool.addCallBack(GameCmd.SPickupMultiItems,SPickupMultiItems,onPickupMultiItems);
			
			
			///添加buff伤害
			MsgPool.addCallBack(GameCmd.SBuffDamage,SBuffDamage,buffDamage);
			///删除buff
			MsgPool.addCallBack(GameCmd.SRemoveBuff,SRemoveBuff,deleteBuff);
			///宠物重命名
			MsgPool.addCallBack(GameCmd.SPetRenameNotify,SPetRenameNotify,onPetReName);
			///宠物加血   
			MsgPool.addCallBack(GameCmd.SPetUseItemNotify,SPetUseItemNotify,onPetAddHp);
			//人物加血 加魔法
			MsgPool.addCallBack(GameCmd.SHeroUseItemNotify,SHeroUseItemNotify,onPlayerAddHpMp);
			///移形换影
			
			///主角转职成功
			MsgPool.addCallBack(GameCmd.SChangeCareer,SChangeCareer,sChangeCareerCallBack); 
			///其他玩家转职成功
			MsgPool.addCallBack(GameCmd.SChangeCareerNotify,SChangeCareerNotify,onOtherRoleChangeCareer); 
			///玩家上下坐骑
			MsgPool.addCallBack(GameCmd.SChangeMountNotify,SChangeMountNotify,onChangeMountNotify);
			//切磋胜利
			MsgPool.addCallBack(GameCmd.SCompeteWin,SCompeteWin,onSCompeteWin);
			
			///切磋结束返回
			MsgPool.addCallBack(GameCmd.SFinishCompete,SFinishCompete,onSFinishCompete);
			///玩家红名改变
			MsgPool.addCallBack(GameCmd.SNameColorNotify,SNameColorNotify,onSNameColorNotify);
			///更新玩家称号  广播  ，不包含自己
			MsgPool.addCallBack(GameCmd.SUseTitleNotify,SUseTitleNotify,onSUseTitleNotify);
			//采集成功
			MsgPool.addCallBack(GameCmd.SGather,SGather,onSGather);
			//当前玩家血量改变 该协议不进行 广播 
			MsgPool.addCallBack(GameCmd.SHpChange,SHpChange,onHpChange);
			//当我玩家魔法改变   不进行改变
			MsgPool.addCallBack(GameCmd.SMpChange,SMpChange,onMpChange);
			
			//魔神入侵副本返回
			//月井技能
			MsgPool.addCallBack(GameCmd.SUseMoonWell,SUseMoonWell,onSUseMoonWell);
			//大炮技能
			MsgPool.addCallBack(GameCmd.SUseCannon,SUseCannon,onSUseCannon);
		}
		/**月井成功返回
		 */		
		private function onSUseMoonWell(sUseMoonWell:SUseMoonWell):void
		{
			switch(sUseMoonWell.code)
			{
				case RspMsg.RSPMSG_SUCCESS:
					//更新玩家血量
					if(sUseMoonWell.hasHp)DataCenter.Instance.roleSelfVo.roleDyVo.hp=sUseMoonWell.hp;
					if(sUseMoonWell.hasMp)DataCenter.Instance.roleSelfVo.roleDyVo.mp=sUseMoonWell.mp;
					if(sUseMoonWell.hasGodessHp)RoleDyManager.Instance.updateHp(DemonManager.goddessDyId,sUseMoonWell.godessHp);
					_mapScenceView._senceRolesView.updateHp(DemonManager.goddessDyId);
					noticeHeroInfoChange();
					var demonRoleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(DemonManager.goddessDyId);
					if(demonRoleDyVo)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,demonRoleDyVo);
					_mapScenceView.updateYueJing(DemonManager.goddessDyId,ConstMapBasicManager.Instance.getTempId(DemonManager.FightEffect_YueJing_ConstId));
					YFEventCenter.Instance.dispatchEventWith(DemonEvent.UseYueJingSuccess);
					break;
				case RspMsg.RSPMSG_FAIL:
					print(this,"使用月井失败");
					break;
			}
		}
		/**使用大炮成功返回
		 */
		private function onSUseCannon(sUseCannon:SUseCannon):void
		{
			switch(sUseCannon.code)
			{
				case RspMsg.RSPMSG_SUCCESS:
					var roleDyVo:RoleDyVo;
					for each(var dyId:int in sUseCannon.deadMonsterIds) 
					{
						roleDyVo=RoleDyManager.Instance.getRole(dyId);
						if(roleDyVo)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,roleDyVo);
					}
					_mapScenceView.updateDaPaoDead(sUseCannon.deadMonsterIds,ConstMapBasicManager.Instance.getTempId(DemonManager.FightEffect_DaPao_ConstId));
					YFEventCenter.Instance.dispatchEventWith(DemonEvent.UseDaPaoSuccess);
					break;
				case RspMsg.RSPMSG_FAIL:
					print(this,"使用大炮失败");
					break;
			}
		}
		/**当前玩家血量改变
		 */		
		private function onHpChange(sHpChange:SHpChange):void
		{
			var roleDyVo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			roleDyVo.hp=sHpChange.hp;
			_mapScenceView._senceRolesView.updateHp(roleDyVo.dyId); //更新血量
			noticeHeroInfoChange();
		}
		private function onMpChange(sMpChange:SMpChange):void
		{
			var roleDyVo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			roleDyVo.mp=sMpChange.mp;
			noticeHeroInfoChange();
		}
		/**采集成功
		 */		
		private function onSGather(sGather:SGather):void
		{
			switch(sGather.code)
			{
				case RspMsg.RSPMSG_SUCCESS:	//采集成功
					NoticeUtil.setOperatorNotice("采集成功");
					break;
				case RspMsg.RSPMSG_FAIL: //采集失败
					NoticeUtil.setOperatorNotice("采集失败");
					break;
			}
			NewGuideManager.DoGuide();
		}
		
		/**系统设置
		 */
		private function onSystemConfigChange(e:YFEvent):void
		{
			_mapScenceView._senceRolesView.updateSystemConfig();
		}
		
		/**触发魔神入侵技能
		 */
		private function onTriggerDemonRaidSkill(e:YFEvent):void
		{
			var type:int=int(e.param);
			switch(type)
			{
				case DemonSkillType.DaPao:  //大炮
					var cUseCannon:CUseCannon=new CUseCannon();
					MsgPool.sendGameMsg(GameCmd.CUseCannon,cUseCannon);
					break;
				case DemonSkillType.YueJing:  //月井
					var cUseMoonWell:CUseMoonWell=new CUseMoonWell();
					MsgPool.sendGameMsg(GameCmd.CUseMoonWell,cUseMoonWell);
					break;
			}
		}
		/**场景进行冒泡说话
		 */		
		private function onChatScene(e:YFEvent):void
		{
			var chatMsgVo:ChatMsgVo=e.param as ChatMsgVo;
			_mapScenceView.updateSceneSayWord(chatMsgVo.dyId,chatMsgVo.msg);
		}
		/** 自己使用称号
		 */		
		private function onTittleUpdate(e:YFEvent):void
		{
			_mapScenceView._senceRolesView.updateTittle(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,TitleDyManager.instance.curTitleId);
		}
		/**  使用 称号 不包含自己
		 */		
		private function onSUseTitleNotify(sUseTitleNotify:SUseTitleNotify):void
		{
			_mapScenceView._senceRolesView.updateTittle(sUseTitleNotify.dyId,sUseTitleNotify.titleId);
		}
		
		/**开始切磋
		 */		
		private function onBeginCompeting(e:YFEvent):void
		{
			print(this,"切磋啊::",DataCenter.Instance.roleSelfVo.roleDyVo.competeId,DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			_mapScenceView.updateCompeteEffect(DataCenter.Instance.roleSelfVo.roleDyVo.competeId);
			_mapScenceView.updateCompeteEffect(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
		}
		/**切磋结束返回
		 */		
		private function onSFinishCompete(sFinishCompete:SFinishCompete):void
		{
			_mapScenceView.updateDeleteCompeteEffect(DataCenter.Instance.roleSelfVo.roleDyVo.competeId);
			_mapScenceView.updateDeleteCompeteEffect(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			RoleDyManager.Instance.updateRoleCompete(DataCenter.Instance.roleSelfVo.roleDyVo.competeId,-1);
			DataCenter.Instance.roleSelfVo.roleDyVo.competeId=-1;
		}
		/**更新玩家名字颜色
		 */		
		private function onSNameColorNotify(sNameColorNotify:SNameColorNotify):void
		{
			RoleDyManager.Instance.updateRoleNameColor(sNameColorNotify.dyId,sNameColorNotify.nameColor);
			_mapScenceView.updateRoleNameColor(sNameColorNotify.dyId);
		}
		/**切磋成功
		 */		
		private function onSCompeteWin(sCompeteWin:SCompeteWin):void
		{
			_mapScenceView.updateCompeteWin(sCompeteWin.dyId);
			YFEventCenter.Instance.dispatchEventWith(FeedEvent.PKWin);
		}

		private function onChangeMountNotify(sChangeMountNotify:SChangeMountNotify):void
		{
//			print(this,"坐骑id",sChangeMountNotify.mountBasicId);
			var state:int=TypeRole.State_Normal;//下坐骑
			if(sChangeMountNotify.mountBasicId>0) //上坐骑
			{
				state=TypeRole.State_Mount;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==sChangeMountNotify.dyId)
				{
					MountDyManager.isRiding=true;
				}
			}
			else 
			{
				state=TypeRole.State_Normal;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==sChangeMountNotify.dyId)
				{
					MountDyManager.isRiding=false;
				}
			}
			_mapScenceView.updateMountChange(sChangeMountNotify.dyId,sChangeMountNotify.mountBasicId,state);
		}
		/**主角转职成功
		 */		
		private function sChangeCareerCallBack(sChangeCareer:SChangeCareer):void
		{
			DataCenter.Instance.roleSelfVo.roleDyVo.career=sChangeCareer.career;
			CharacterDyManager.Instance.potential=sChangeCareer.potential;
			//			print(this,"转职成功");
			NoticeUtil.setOperatorNotice("转职成功");
			///改变默认技能
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroChangeCareerSuccess);
			_mapScenceView._senceRolesView.updateCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
		}
		/**其他玩家转职成功
		 */		
		private function onOtherRoleChangeCareer(sChangeCareerNotify:SChangeCareerNotify):void
		{
			RoleDyManager.Instance.updateCareer(sChangeCareerNotify.dyId,sChangeCareerNotify.career);
			_mapScenceView._senceRolesView.updateCloth(sChangeCareerNotify.dyId);
		}
		
		
		/**主角血量改变
		 */ 
		private function onHeroHpChange(e:YFEvent):void
		{
			var roleDyVo:RoleDyVo=RoleDyVo(e.param);
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==roleDyVo.dyId)
				_mapScenceView._senceRolesView.updateHp(roleDyVo.dyId);
		}
		/**宠物重命名
		 */		
		private function onPetReName(sPetUseItemNotify:SPetRenameNotify):void
		{
			_mapScenceView._senceRolesView.updateRoleName(sPetUseItemNotify.petId,sPetUseItemNotify.name);
		}
		/**宠物 加血   其他人的宠物 或者自己的宠物
		 */		
		private function onPetAddHp(sPetUseItemNotify:SPetUseItemNotify):void
		{
			if(sPetUseItemNotify.dyId==PetDyManager.fightPetId)
			{
				if(sPetUseItemNotify.buffId>0)
				{
					var buffBasicVo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(sPetUseItemNotify.buffId);
					if(buffBasicVo.icon_id>0)
					{
						PetBuffDyManager.Instance.addBuff(sPetUseItemNotify.buffId,sPetUseItemNotify.skillId,1); //添加进行buff 
					}
				}
			}
			_mapScenceView.updateShowEffect(sPetUseItemNotify.dyId,sPetUseItemNotify.skillId,sPetUseItemNotify.addHp,sPetUseItemNotify.hp,sPetUseItemNotify.addMana,sPetUseItemNotify.mp,sPetUseItemNotify.buffId);
			if(RoleDyManager.Instance.getRole(sPetUseItemNotify.dyId)){
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,RoleDyManager.Instance.getRole(sPetUseItemNotify.dyId));
			}
		}
		/**  人物加血加蓝  其他玩家或者自己
		 */		
		private function onPlayerAddHpMp(sHeroUseItemNotify:SHeroUseItemNotify):void
		{
			if(sHeroUseItemNotify.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				if(sHeroUseItemNotify.buffId>0)
				{
					var buffBasicVo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(sHeroUseItemNotify.buffId);
					if(buffBasicVo.icon_id>0)
					{
						HeroBuffDyManager.Instance.addBuff(sHeroUseItemNotify.buffId,sHeroUseItemNotify.skillId,1); //添加进行buff 
					}
				}
			}
			_mapScenceView.updateShowEffect(sHeroUseItemNotify.dyId,sHeroUseItemNotify.skillId,sHeroUseItemNotify.addHp,sHeroUseItemNotify.hp,sHeroUseItemNotify.addMana,sHeroUseItemNotify.mp,sHeroUseItemNotify.buffId);
			///通知主面板角色血量改变
			noticeHeroInfoChange();
		}
		/**  主角信息改变 主界面UI更新
		 */		
		private function noticeHeroInfoChange():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,DataCenter.Instance.roleSelfVo.roleDyVo);
		}
		
		/**删除buff
		 */		
		private function deleteBuff(sRemoveBuff:SRemoveBuff):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==sRemoveBuff.dyId)
			{
				Log.Instance.v("主角移除buff.....");
				HeroBuffDyManager.Instance.removeBuff(sRemoveBuff.buffId);
			}
			else if(sRemoveBuff.dyId==PetDyManager.fightPetId)
			{
				PetBuffDyManager.Instance.removeBuff(sRemoveBuff.buffId);
			}
			_mapScenceView.updateDeleteBuff(sRemoveBuff.dyId,sRemoveBuff.buffId);
			noticeDeleteBuff(sRemoveBuff.dyId,sRemoveBuff.buffId);
		}
		
		/**  buff伤害
		 * @param sBuffDamage
		 */		
		private function buffDamage(sBuffDamage:SBuffDamage):void
		{
			var hp:int=0,hpChange:int=0,mp:int=0,mpChange:int=0;
			if(sBuffDamage.hasHpChange)
			{
				hp=sBuffDamage.hp;
				hpChange=sBuffDamage.hpChange;
			}
			if(sBuffDamage.hasMpChange)
			{
				mp=sBuffDamage.mp;
				mpChange=sBuffDamage.mpChange;
			}
			_mapScenceView.updateBuffDamage(sBuffDamage.dyId,sBuffDamage.buffId,hp,hpChange,mp,mpChange);
		//	noticeAddBuff(sBuffDamage.dyId,sBuffDamage.buffId);
			if(sBuffDamage.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)	
			{
				noticeHeroInfoChange();
		//		print(this,"主角受到buff伤害.....");
			}
		}

		/** 拾取道具
		 */		
		private function onPickUpItem(sPickupItem:SPickupItem):void
		{
			if(sPickupItem.erroInfo==RspMsg.RSPMSG_SUCCESS)
			{
				print(this,"道具拾取成功");
				_mapScenceView._senceRolesView.updateGetDropGoods(sPickupItem.itemDyId);
//				NoticeUtil.setOperatorNotice("道具拾取成功");
			}
			else 
			{
				print(this,"道具拾取失败");
				NoticeUtil.setOperatorNotice("其他玩家道具不能拾取!");
			}
		}
		private function onPickupMultiItems(sPickupMultiItems:SPickupMultiItems):void
		{
			if(sPickupMultiItems)
			{
				print(this,"道具批量拾取成功");
				var len:int=sPickupMultiItems.itemDyIds.length;
				for(var i:int=0;i!=len;++i)
				{
					_mapScenceView._senceRolesView.updateGetDropGoods(sPickupMultiItems.itemDyIds[i]);
				}
				//				NoticeUtil.setOperatorNotice("道具拾取成功");
			}
		}

	
		/**角色装备改变 这个消息是广播的
		 */		
		private function onHeroEquipChange(sHeroEquipChange:SHeroEquipChange):void
		{
			var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(sHeroEquipChange.dyId) as RoleDyVo;
			switch(sHeroEquipChange.partType)
			{
				case EquipType.EQUIP_TYPE_CLOTHES: //衣服
					roleDyVo.clothEnhanceLevel=sHeroEquipChange.equipEnhanceLevel;
					roleDyVo.clothBasicId=sHeroEquipChange.equipId;
					if(roleDyVo.state==TypeRole.State_Normal)
					{
						_mapScenceView._senceRolesView.updateCloth(sHeroEquipChange.dyId,sHeroEquipChange.equipId);	
					}
					else if(roleDyVo.state==TypeRole.State_Mount)
					{
						_mapScenceView._senceRolesView.updateMountCloth(sHeroEquipChange.dyId,sHeroEquipChange.equipId);	
					}
					break;
				case EquipType.EQUIP_TYPE_WEAPON: ///武器
					roleDyVo.weaponEnhanceLevel=sHeroEquipChange.equipEnhanceLevel;
					roleDyVo.weaponBasicId=sHeroEquipChange.equipId;
					if(roleDyVo.state==TypeRole.State_Normal)
					{
						_mapScenceView._senceRolesView.updateWeapon(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					}
					break;
				case EquipType.EQUIP_TYPE_WINGS: ///翅膀
					roleDyVo.wingBasicId=sHeroEquipChange.equipId;
					if(roleDyVo.state==TypeRole.State_Normal)
					{
						_mapScenceView._senceRolesView.updateWing(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					}
					else if(roleDyVo.state==TypeRole.State_Mount)
					{
						_mapScenceView._senceRolesView.updateMountWing(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					}
					break;
			}
		}
			
		
		/**  通知添加buff主界面显示
		 */		
		private function noticeAddBuff(dyId:int,buffId:int,skillId:int,skilllevel:int):void
		{
			var buffBasicVo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(buffId);
			if(dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  //主角
			{
				if(buffBasicVo.icon_id>0)
				{
					HeroBuffDyManager.Instance.addBuff(buffId,skillId,skilllevel);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroAddBuff,buffId);
				}
			}
			else if(PetDyManager.Instance.hasPet(dyId)) //如果为宠物   //出战宠物
			{
				if(buffBasicVo.icon_id>0)
				{
					PetBuffDyManager.Instance.addBuff(buffId,skillId,skilllevel);
					//宠物血量改变
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroPetAddBuff,{buffId:buffId,petId:dyId});
				}
			}
			else //其他玩家血量改变
			{
				var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(dyId);
				if(roleDyVo)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,roleDyVo);
			}
		}
		/**删除  buff 通知主界面显示
		 * @param dyId
		 * @param buffId
		 * 
		 */		
		private function noticeDeleteBuff(dyId:int,buffId:int):void
		{
			if(dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroDeleteBuff,buffId);
			}
			else if(PetDyManager.Instance.hasPet(dyId)) //如果为宠物
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroPetDeleteBuff,{buffId:buffId,petId:dyId});
			}

		}
	
		/**玩家升级
		 */ 
		private function roleLevelUp(sRoleLevelup:SRoleLevelup):void
		{
			DataCenter.Instance.roleSelfVo.preLevel=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			DataCenter.Instance.roleSelfVo.roleDyVo.level=sRoleLevelup.level;
			DataCenter.Instance.roleSelfVo.roleDyVo.hp=sRoleLevelup.hp;
			DataCenter.Instance.roleSelfVo.roleDyVo.mp=sRoleLevelup.mp;
			_mapScenceView.updateRoleLevelUp(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
		//	LayerManager.shake(TypeDirection.Down); //进行震屏幕
			///开始转职
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=NewGuideManager.ChangeCareerLevel&&DataCenter.Instance.roleSelfVo.roleDyVo.career==TypeRole.CAREER_NEWHAND)
//			{
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ShowSelectCareerWindowForDebug);
//				print(this,"此处转职 调试用");
//			}
			///主角升级
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroLevelUp);
			ActivityDyManager.instance.findCanJoinActivity(false);
		}
		/**其他角色升级
		 */		
		private function otherOtherRoleLevelUp(sOtherRoleLevelup:SOtherRoleLevelup):void
		{
			RoleDyManager.Instance.updateLevel(sOtherRoleLevelup.dyId,sOtherRoleLevelup.level);
			_mapScenceView.updateRoleLevelUp(sOtherRoleLevelup.dyId);
		}
		/**其他宠物升级
		 */		
		private function otherPetLevelup(sOtherPetLevelup:SOtherPetLevelup):void
		{
			RoleDyManager.Instance.updateLevel(sOtherPetLevelup.dyId,sOtherPetLevelup.level);
			_mapScenceView.updateRoleLevelUp(sOtherPetLevelup.dyId);
			var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(sOtherPetLevelup.dyId);
			if(roleDyVo)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,roleDyVo);  ///信息发生改变
		}
		/**主角宠物升级 播放升级动画 
		 */		
		private function onPetLevelUp(e:YFEvent):void
		{
			var petDyVo:PetDyVo=e.param as PetDyVo; ///主角自己的宠物
			RoleDyManager.Instance.updateLevel(petDyVo.dyId,petDyVo.level);  //更新场景模型的数据
			_mapScenceView.updateRoleLevelUp(petDyVo.dyId);//播放升级动画
		}
		
		/**其他玩家的 血量 魔法值发生改变
		 */		
		private function otherRoleHpMpChange(sOtherRoleHpMpChange:SOtherRoleHpMpChange):void
		{
			var hp:int=0,mp:int=0,maxHp:int=0,maxMp:int=0;
			if(sOtherRoleHpMpChange.hasHpMax)
			{
				hp=sOtherRoleHpMpChange.hp;
				maxHp=sOtherRoleHpMpChange.hpMax;
			}
			if(sOtherRoleHpMpChange.hasMpMax)
			{
				mp=sOtherRoleHpMpChange.mp;
				maxMp=sOtherRoleHpMpChange.maxMp;
			}
			_mapScenceView.updateOtherRoleHpMp(sOtherRoleHpMpChange.dyId,hp,maxHp,mp,maxMp);
		}

		/**人物死亡   服务端只告诉死亡的客户端
		 */		
		private function heroDead(sHeroDead:SHeroDead):void
		{
//				var roleDeadId:int=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
				_mapScenceView.updateHeroRoleDead(sHeroDead.killerId);
		}
		/**  人物复活  这条消息是广播的
		 */		
		private function reviveCallBack(sReviveHero:SReviveHero):void
		{
			var roleRevive:RoleReviveVo=new RoleReviveVo();
			roleRevive.dyId=sReviveHero.dyId;
			roleRevive.hp=sReviveHero.hp;
			roleRevive.mp=sReviveHero.mp;
			_mapScenceView.updateReviveRole(roleRevive);
			//通知主界面UI进行血量更新
			var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(sReviveHero.dyId) as RoleDyVo;
			if(roleDyVo)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,roleDyVo);
		}
		
		/**  宠物向目标靠近 
		 */		
		private function petMoveToTarget(sPetCloseTarget:SPetCloseTarget): void
		{
			_mapScenceView.updatePetMoveToTarget(sPetCloseTarget.petId,sPetCloseTarget.targetId);
		}
		
		private function onMonsterBirth(sMonsterBirth:SMonsterBirth):void
		{  
			var roledyVo:RoleDyVo;
			var otherRoleInfo:OtherRoleInfo=sMonsterBirth.monsterInfo;
			var currentPos:Point;
				///服务端打包 发送，   所以需要除去自己的信息
			roledyVo=new RoleDyVo();
			roledyVo.state=otherRoleInfo.state;
			roledyVo.bigCatergory=TypeRole.BigCategory_Monster;//otherRoleInfo.playerType;
			currentPos=BytesUtil.int32ToShortPoint(otherRoleInfo.mapPos);
			roledyVo.mapX=currentPos.x;
			roledyVo.mapY=currentPos.y;
			roledyVo.dyId=otherRoleInfo.dyId;
			roledyVo.basicId=otherRoleInfo.basicId;
			roledyVo.hp=otherRoleInfo.hp;
			roledyVo.maxHp=otherRoleInfo.hpMax
			roledyVo.mp=otherRoleInfo.mp;
			roledyVo.maxMp=otherRoleInfo.mpMax;
			roledyVo.camp=otherRoleInfo.camp;//玩家阵营
			var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roledyVo.basicId);
			roledyVo.roleName=monsterBasicVo.getName();
			roledyVo.level=monsterBasicVo.level;
			_mapScenceView._senceRolesView.addRole(roledyVo,true);
			RoleDyManager.Instance.addRole(roledyVo);
				///更新血量
			_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
			_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
		}
		private function onFight(sFight:SFight):void
		{
//			if(sFight.skillId==SkillDyManager.Instance.getDefaultSkill())
//			{
//				print(this,"默认技能:"+sFight.skillId);
//			}
			
			///播放cd動畫  當為自己時  播放cd動畫
			if(sFight.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				if(SkillDyManager.Instance.getSkillDyVo(sFight.skillId))  //具有 这个技能  播放技能公共CD 
				{
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,sFight.skillId);
				}
				
				ZiDongXunLuView.Instance.hide();
			}

			///服务端返回战斗信息    指的是人物发起的战斗  具有目标点
			var fightUIPtVo:FightUIPtVo=new FightUIPtVo();
			fightUIPtVo.atk=_mapScenceView._senceRolesView.totalViewDict[sFight.atkId];
			fightUIPtVo.skillId=sFight.skillId;
			fightUIPtVo.skillLevel=sFight.skillLevel;
			if(sFight.hasAtkHp)
			{
				RoleDyManager.Instance.updateHp(sFight.atkId,sFight.atkHp);
				_mapScenceView._senceRolesView.updateHp(sFight.atkId);
			}
			if(sFight.hasAtkMp)
			{
				RoleDyManager.Instance.updateMp(sFight.atkId,sFight.atkMp);
			}
			if(sFight.hasAtkHp||sFight.hasAtkMp)
			{
				noticeHeroInfoChange();
			}
			if(sFight.hasTagPos)
			{
				var position:Point=BytesUtil.int32ToShortPoint(sFight.tagPos);   // int转化为 点坐标 
				fightUIPtVo.mapX=position.x;
				fightUIPtVo.mapY=position.y;
				print(this,"ptt..:",position.x,position.y,fightUIPtVo.skillId);
			}
			fightUIPtVo.uAtkArr=new Vector.<UAtkInfo>();
			var uAtkInfo:UAtkInfo;
			var player:PlayerView;
			var pointData:Point;
			for each(var damegeInfo:DamageInfo in sFight.damageInfoArr)
			{  
				player=_mapScenceView._senceRolesView.totalViewDict[damegeInfo.tagId];
				if(player)
				{
					uAtkInfo=new UAtkInfo();
					uAtkInfo.player=player;
					uAtkInfo.changeHp=damegeInfo.hpChange;
					uAtkInfo.changeMP=damegeInfo.mpChange;
					uAtkInfo.damageType=damegeInfo.damageType;
					uAtkInfo.hp=damegeInfo.hp;
					if(uAtkInfo.hp<=0)
					{
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.PlayerDead,RoleDyManager.Instance.getRole(damegeInfo.tagId));
					}
					if(damegeInfo.hasBeatBackPos)  //如果 为 击退 技能 
					{
						pointData=BytesUtil.int32ToShortPoint(damegeInfo.beatBackPos);
						uAtkInfo.endX=pointData.x;
						uAtkInfo.endY=pointData.y;
						uAtkInfo.hasBeatBack=true;
					}
					else uAtkInfo.hasBeatBack=false;
					fightUIPtVo.uAtkArr.push(uAtkInfo);
					
					//存在buffId 
					if(damegeInfo.buffId>0)
					{
						_mapScenceView.updateBuff(damegeInfo.tagId,damegeInfo.buffId);
						noticeAddBuff(damegeInfo.tagId,damegeInfo.buffId,sFight.skillId,sFight.skillLevel);
					}
				}
			} 
			////判断技能类型
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIPtVo.skillId,fightUIPtVo.skillLevel);
			////判断技能类型
			var fightType:int=TypeSkill.getFightType(skillBasicVo.use_type);
			switch(fightType)
			{
				case TypeSkill.FightType_MoreRole: /// 有角色才会触发
					_mapScenceView.updateFightMore(fightUIPtVo,false);
					break;
				case TypeSkill.FightType_MoreAll:///不管有无角色 都会触发
					_mapScenceView.updateFightMore(fightUIPtVo,true);
					break;
				case TypeSkill.FightType_MorePt:// 有坐标点才会触发
					_mapScenceView.updateFightMorePt(fightUIPtVo);
					break;
				case TypeSkill.FightType_BlinkMove:  //瞬移
					_mapScenceView.updateBlinkMove(fightUIPtVo);
					break;
				case TypeSkill.FightType_Switch:
					_mapScenceView.updateFightMore(fightUIPtVo,true);
					break;
			}
//			fightMorePtRessultVo.disposeToPool();
			
		}
		
		
		/**宠物移动
		 */		
		private function petMoving(sPetMoving:SPetMoving):void
		{
				//宠物发生移动
			var petMovingVo:PetMoveResultVo=new PetMoveResultVo();//PoolCenter.Instance.getFromPool(PetMoveResultVo,null) as PetMoveResultVo;
			var currentPos:Point=BytesUtil.int32ToShortPoint(sPetMoving.currentPosition);
			petMovingVo.id=sPetMoving.id;
			petMovingVo.direction=sPetMoving.direction;
			petMovingVo.mapX=currentPos.x;
			petMovingVo.mapY=currentPos.y;
			petMovingVo.speed=sPetMoving.speed;
			petMovingVo.path=positionArrToPointArr(sPetMoving.path);	
			_mapScenceView.updatePetMovePath(petMovingVo);	
//			petMovingVo.disposeToPool();
		}
		/**拉取宠物
		 */		
		private function onPetPull(sPetPull:SPetPull):void
		{
			//					///服务端返回拉取宠物的结果
//			if(!PetDyManager.Instance.hasPet(sPetPull.id)) //非自己的宠物才进行拉取
//			{
				var pullPetVo:PullPetVo=new PullPetVo();
				pullPetVo.dyId=sPetPull.id;
				var currentPos:Point=BytesUtil.int32ToShortPoint(sPetPull.currentPosition);
				pullPetVo.mapX=currentPos.x;
				pullPetVo.mapY=currentPos.y;
				_mapScenceView.updatePullPet(pullPetVo);
//			}
//			else 
//			{
//				//宠物拉取 ，自己不需要广播
//				print(this,"宠物拉取 ，自己不需要广播");
//			}
		}
		/**  怪物移动
		 */		
		private function monsterMoving(sMonsterMoving:SMonsterMoving):void
		{
			//					//怪物处在移动中
			var monsterMovingVo:PlayerMoveResultVo=new PlayerMoveResultVo();//PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
			var currentPos:Point=BytesUtil.int32ToShortPoint(sMonsterMoving.currentPosition);
			monsterMovingVo.id=sMonsterMoving.dyId;
			monsterMovingVo.mapX=currentPos.x;
			monsterMovingVo.mapY=currentPos.y;
			monsterMovingVo.path=tilePositionArrToPointArr(sMonsterMoving.path);
			monsterMovingVo.speed=sMonsterMoving.speed/UpdateManager.UpdateRate;
			_mapScenceView.updatePlayerMovePath(monsterMovingVo,true,true);	

		}
		
		/**其他角色发生移动
		 */		
		private function otherRoleMoving(sOtherRoleMoving:SOtherRoleMoving):void
		{
			var playerMovingVo:PlayerMoveResultVo=new PlayerMoveResultVo();//PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
			var currentPos:Point=BytesUtil.int32ToShortPoint(sOtherRoleMoving.currentPostion);
			playerMovingVo.id=sOtherRoleMoving.id;
			playerMovingVo.mapX=currentPos.x;
			playerMovingVo.mapY=currentPos.y;
			playerMovingVo.speed=sOtherRoleMoving.speed;
			playerMovingVo.path=positionArrToPointArr(sOtherRoleMoving.path);
			_mapScenceView.updatePlayerMovePath(playerMovingVo,true,true);
//			playerMovingVo.disposeToPool(); 
		}
		/**宠物出战
		 */
//		private function onPetFight(e:YFEvent):void
//		{
//			var fightPetId:uint=uint(e.param);
//			_mapScenceView.updatePetFight(fightPetId);
//			
//		}
		/**玩家第一次登录后的信息
		 */ 
		private function createHeroCallback(firsterEnterInfo:SFirstEnterInfo):void
		{
			///在登录成功SLogin发回的 数据
			///创建主角色
			var roledyVo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			roledyVo.state=firsterEnterInfo.state;
			roledyVo.nameColor=firsterEnterInfo.nameColor;
			roledyVo.competeId=firsterEnterInfo.competeTarget;
			roledyVo.clothEnhanceLevel=firsterEnterInfo.equipInfo.clothEnhanceLevel;
			roledyVo.weaponEnhanceLevel=firsterEnterInfo.equipInfo.weaponEnhanceLevel;
			roledyVo.clothBasicId=firsterEnterInfo.equipInfo.clothId;
			roledyVo.weaponBasicId=firsterEnterInfo.equipInfo.weaponId;
			roledyVo.wingBasicId=firsterEnterInfo.equipInfo.wingId;
			_mapScenceView._senceRolesView.createHero();
			RoleDyManager.Instance.addRole(roledyVo);  
			if(roledyVo.competeId>0)_mapScenceView.updateCompeteEffect(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			///更新血量
			_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
			if(roledyVo.state==TypeRole.State_Normal)
			{
				_mapScenceView._senceRolesView.updateCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.clothId);
				if(firsterEnterInfo.equipInfo.weaponId>0)
					_mapScenceView._senceRolesView.updateWeapon(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.weaponId);
				if(firsterEnterInfo.equipInfo.wingId>0)
					_mapScenceView._senceRolesView.updateWing(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.wingId);
			}
			else if(roledyVo.state==TypeRole.State_Mount)
			{
				var monsterBasicVo:MountBasicVo=MountBasicManager.Instance.getMountBasicVo(firsterEnterInfo.mountId);
				DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=monsterBasicVo.speed;
				_mapScenceView._senceRolesView.updateMountCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.clothId);
				_mapScenceView._senceRolesView.updateMount(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.mountId);
				if(firsterEnterInfo.equipInfo.wingId>0)
					_mapScenceView._senceRolesView.updateMountWing(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.wingId);
			}
			DataCenter.Instance.roleSelfVo.hpPool = firsterEnterInfo.hpPool;
			DataCenter.Instance.roleSelfVo.mpPool = firsterEnterInfo.mpPool;
			DataCenter.Instance.roleSelfVo.petHpPool = firsterEnterInfo.petHpPool;
			CharacterDyManager.Instance.magicSoul = firsterEnterInfo.magicSoul;
			//场景初始化完成 
			ModuleManager.moduleCharacter.heroInfoReq();
		}
		/**其他玩家进入视野
		 */		
//		private function otherRoleListEnterView(sOtherRoleInfo:SOtherRoleInfo):void
		private function otherRoleListEnterView(otherRoleInfo:OtherRoleInfo):void  ///此包 在 NetEngine处 被拆开  此包太耗性能了 现在是拆包多帧处理 
		{
//			var t:Number=getTimer();
			
			var roledyVo:RoleDyVo;
			var monsterBasicVo:MonsterBasicVo;
			var pos:Point;
//			for each(var otherRoleInfo:OtherRoleInfo in sOtherRoleInfo.otherRoles)  //此包已经被拆开
//			{
				///服务端打包 发送，   所以需要除去自己的信息
				if(otherRoleInfo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) return ;// continue
				roledyVo=new RoleDyVo();
				roledyVo.state=otherRoleInfo.state;
				roledyVo.bigCatergory=otherRoleInfo.playerType;
				pos=BytesUtil.int32ToShortPoint(otherRoleInfo.mapPos);
				roledyVo.mapX=pos.x;
				roledyVo.mapY=pos.y;
				roledyVo.dyId=otherRoleInfo.dyId;
				roledyVo.roleName=otherRoleInfo.name;
				roledyVo.sex=otherRoleInfo.sex;
				roledyVo.basicId=otherRoleInfo.basicId;
				roledyVo.hp=otherRoleInfo.hp;
				roledyVo.maxHp=otherRoleInfo.hpMax;
				roledyVo.mp=otherRoleInfo.mp;
				roledyVo.maxMp=otherRoleInfo.mpMax;
				roledyVo.level=otherRoleInfo.level;
				roledyVo.career=otherRoleInfo.career;
				roledyVo.nameColor=otherRoleInfo.nameColor;
				roledyVo.ownId=otherRoleInfo.ownerId;
				roledyVo.camp=otherRoleInfo.camp;//玩家阵营
				roledyVo.tittleId=otherRoleInfo.titleId;
				roledyVo.vipLevel=otherRoleInfo.vipLevel;
				roledyVo.vipType=otherRoleInfo.vipType;
				///怪物 设置  名称
				if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster)
				{
					monsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roledyVo.basicId);
					roledyVo.roleName=monsterBasicVo.getName();
					roledyVo.level=monsterBasicVo.level;
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods)  ///为物品掉落
				{
					roledyVo.itemType=otherRoleInfo.itemType;
					if(otherRoleInfo.itemType==TypeProps.ITEM_TYPE_EQUIP)  ///为装备
					{
					 	var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(otherRoleInfo.basicId); 
						roledyVo.roleName=equipBasicVo.name;
					}   
					else if(otherRoleInfo.itemType==TypeProps.ITEM_TYPE_PROPS)  ///为道具 
					{
						var propBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(otherRoleInfo.basicId);
						roledyVo.roleName=propBasicVo.name;
					}
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_Gather)  ///为物品掉落
				{
					var gatherBasicVo:Gather_ConfigBasicVo=Gather_ConfigBasicManager.Instance.getGather_ConfigBasicVo(otherRoleInfo.basicId);
					roledyVo.roleName=gatherBasicVo.name;
				}
				RoleDyManager.Instance.addRole(roledyVo);
				_mapScenceView._senceRolesView.addRole(roledyVo);
				//判断是否为切磋对象
				if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId==roledyVo.dyId)  //为切磋对象
				{
					roledyVo.competeId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
					_mapScenceView.updateCompeteEffect(roledyVo.dyId);
				}
				
				if(roledyVo.bigCatergory==TypeRole.BigCategory_Player) //玩家对象
				{
					roledyVo.clothBasicId=otherRoleInfo.equipInfo.clothId;
					roledyVo.wingBasicId=otherRoleInfo.equipInfo.wingId;
					roledyVo.weaponBasicId=otherRoleInfo.equipInfo.weaponId;
					//强化等级  强化
					roledyVo.clothEnhanceLevel=otherRoleInfo.equipInfo.clothEnhanceLevel;
					roledyVo.weaponEnhanceLevel=otherRoleInfo.equipInfo.weaponEnhanceLevel;
					///更新tittle   只有人物有称号
					_mapScenceView._senceRolesView.updateTittle(otherRoleInfo.dyId,otherRoleInfo.titleId);
					
					var clothId:int=otherRoleInfo.equipInfo.clothId;
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
					if(otherRoleInfo.state==TypeRole.State_Normal)  ///正常状态下
					{
						_mapScenceView._senceRolesView.updateCloth(roledyVo.dyId,clothId);
						if(otherRoleInfo.equipInfo.weaponId>0)	_mapScenceView._senceRolesView.updateWeapon(roledyVo.dyId,otherRoleInfo.equipInfo.weaponId);
						if(otherRoleInfo.equipInfo.wingId>0)	_mapScenceView._senceRolesView.updateWing(roledyVo.dyId,otherRoleInfo.equipInfo.wingId);
					}
					else if(otherRoleInfo.state==TypeRole.State_Mount) ///坐骑状态下
					{
						_mapScenceView._senceRolesView.updateMountCloth(roledyVo.dyId,clothId);
						if(otherRoleInfo.mountId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleInfo.mountId);
						if(otherRoleInfo.equipInfo.wingId>0)	_mapScenceView._senceRolesView.updateMountWing(roledyVo.dyId,otherRoleInfo.equipInfo.wingId);
					}
					else if(otherRoleInfo.state==TypeRole.State_Sit) ///打坐状态下
					{
						_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,clothId);
						if(otherRoleInfo.equipInfo.weaponId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleInfo.equipInfo.weaponId,otherRoleInfo.sex);
						if(otherRoleInfo.equipInfo.wingId>0)	_mapScenceView._senceRolesView.updateWing(roledyVo.dyId,otherRoleInfo.equipInfo.wingId);
					}
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster)///更新怪物
				{
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
					_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
//					print(this,"怪物...."+roledyVo.dyId);
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_Pet) ///更新宠物
				{
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
					_mapScenceView._senceRolesView.updatePetClothSKin(roledyVo.dyId,roledyVo.basicId);
					///宠物出战
					if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==otherRoleInfo.ownerId)_mapScenceView.updatePetFight(roledyVo.dyId);
					
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods) ///更新物品掉落
				{
					_mapScenceView._senceRolesView.updateDropGoodsCloth(roledyVo.dyId,roledyVo.basicId,otherRoleInfo.itemType);
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_Gather)//更新采集物
				{
					_mapScenceView._senceRolesView.updateGatherPlayerCloth(roledyVo.dyId,roledyVo.basicId);
				}
				////处理buff特效id 
				for each(var buffId:int in otherRoleInfo.buffIdArr)
				{
					_mapScenceView.updateBuff(roledyVo.dyId,buffId);
				}
//			}
			
			
		}
		
		
		/** 其他玩家离开视野
		 * @param 
		 */		
//		private function otherRoleListExitView(sOtherRoleListExitView:SOtherRoleListExitView):void
//		{
//			for each (var id:int in sOtherRoleListExitView.dyIdArr)
//			{
//				RoleDyManager.Instance.delRole(id);
//				_mapScenceView._senceRolesView.delRole(id);
//			}
//		}
		/** 其他玩家离开视野  网络层将此包拆开了
		 *  id 离开玩家的id 
		 * @param 
		 */		
		private function otherRoleListExitView(id:int):void
		{
			RoleDyManager.Instance.delRole(id);
			_mapScenceView._senceRolesView.delRole(id);
		}
		
		/**宠物收回
		 */		
//		private function petBack(sOtherRoleListExitView:SOtherRoleListExitView):void
//		{
//			for each (var id:int in sOtherRoleListExitView.dyIdArr)
//			{
//				RoleDyManager.Instance.delRole(id);
//				_mapScenceView._senceRolesView.delRole(id);
//			}
//		}

		
		private function onShortMove(sShortMove:SShortMove):void
		{
			_mapScenceView.updateShortMove(sShortMove.dyId,sShortMove.posX,sShortMove.posY); 
		}
		
		/**   同场景 或者 非 同长焦的 跳转
		 */		
		private function heroEnterMap(sEnterNewMap:SEnterNewMap):void
		{
			//					///主角  进入新场景
				///进入场景 
				if(DataCenter.Instance.getMapId()!=sEnterNewMap.mapId)  /// 切换场景
				{
					//进行GC  
					SystemTool.gc();
					//改变玩家阵营信息
					DataCenter.Instance.roleSelfVo.roleDyVo.camp=sEnterNewMap.camp;
					var bgMapVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(sEnterNewMap.mapId);
					DataCenter.Instance.preMapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
					DataCenter.Instance.mapSceneBasicVo=bgMapVo;
					RoleDyManager.Instance.updateDifMapChange();
					///主场景更新
					_mapScenceView.updateHeroStopMove();
					_mapScenceView.updateMapSenceView(sEnterNewMap.mapX,sEnterNewMap.mapY);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterDifferentMap); ///smallMap模块进行侦听
					
					if(DataCenter.Instance.preMapSceneBasicVo)
					{
						if(DataCenter.Instance.preMapSceneBasicVo.type==TypeRole.MapScene_Raid&&DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
						{
							NewGuideManager.DoGuide();
						}
					}
				}
				else //同地图跳转 
				{
					var skipToPoint:Point=new Point(sEnterNewMap.mapX,sEnterNewMap.mapY);
					_mapScenceView.updateHeroStopMove();
					RoleDyManager.Instance.updateSameMapChange();
					_mapScenceView.updateSameMapChange(skipToPoint);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SameMapChange); ///smallMap模块进行侦听
				} 
		}
		/**主角 非法移动的拉取   拉取到正确的位置
		 */		
		private function onSHeroPull(sHeroPull:SHeroPull):void
		{
			var position:Point=BytesUtil.int32ToShortPoint(sHeroPull.currentPosition);
			_mapScenceView.pullHero(position.x,position.y);
		}
		/**小飞鞋 使用  瞬间跳转地图
		 */		
		private function onSkipPoint(sEnterNewMap:SEnterNewMap):void
		{
				heroEnterMap(sEnterNewMap);
				_mapScenceView.updateSkipToPointForWillDo();
			
		}
		
		/** 发送socket 消息
		 */ 
		private function onSendSocketEvent(e:YFEvent):void
		{
			var cFight:CFight;
			var currentPosition:int;
			var fightMoreVo:FightMoreVo;
			var cFightBeatBack:CFightBeatBack;
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					var cClientInitOK:CClientInitOK=new CClientInitOK();
					MsgPool.sendGameMsg(GameCmd.CClientInitOK,cClientInitOK);
					break;
				///角色处在移动当中
				case MapScenceEvent.C_HeroMoving:
					var playerMoveVo:Object=e.param;
					currentPosition=BytesUtil.ShortPointToInt32(playerMoveVo.curentPostion.x,playerMoveVo.curentPostion.y);
					var cHeroMoving:CHeroMoving=new CHeroMoving();
					cHeroMoving.currentPostion=currentPosition;
//					cHeroMoving.currentPostion.x=playerMoveVo.curentPostion.x;
//					cHeroMoving.currentPostion.y=playerMoveVo.curentPostion.y;
					cHeroMoving.speed=playerMoveVo.speed;
					cHeroMoving.path=pointArrToPositionArr(playerMoveVo.path);
					MsgPool.sendGameMsg(GameCmd.CHeroMoving,cHeroMoving);
					break;
				///宠物移动
				case MapScenceEvent.C_PetMoving:
					///宠物发生移动
					var petMoveVo:PetMoveVo=e.param as PetMoveVo;
					currentPosition=BytesUtil.ShortPointToInt32(petMoveVo.curentPostion.x,petMoveVo.curentPostion.y);
					var cPetMoving:CPetMoving=new CPetMoving();
					cPetMoving.currentPosition=currentPosition;	
					cPetMoving.direction=petMoveVo.direction;
					cPetMoving.speed=petMoveVo.speed;
					cPetMoving.path=pointArrToPositionArr(petMoveVo.path);
					MsgPool.sendGameMsg(GameCmd.CPetMoving,cPetMoving);
					break;
				///宠物拉取
				case MapScenceEvent.C_PullPet:
					///拉取寵物
					var pullPetVo:PullPetVo=e.param as PullPetVo;
					currentPosition=BytesUtil.ShortPointToInt32(pullPetVo.mapX,pullPetVo.mapY);
					var cPetPull:CPetPull=new CPetPull();
					cPetPull.currentPosition=currentPosition;
					MsgPool.sendGameMsg(GameCmd.CPetPull,cPetPull);
					break;
				////战斗
				case MapScenceEvent.C_FightMore:
					/// 单一 简单攻击
					fightMoreVo=e.param as FightMoreVo;
					cFight=new CFight();
					cFight.skillId=fightMoreVo.skillId;
					if(fightMoreVo.uAtkArr)cFight.tagIdArr=fightMoreVo.uAtkArr;
					if(fightMoreVo.pt)
					{
						currentPosition=BytesUtil.ShortPointToInt32(fightMoreVo.pt.x,fightMoreVo.pt.y);
						cFight.tagPos=currentPosition;
					}
					MsgPool.sendGameMsg(GameCmd.CFight,cFight);
					break;
				case MapScenceEvent.C_FightMore_Pt:
					////群攻 带坐标点
					fightMoreVo=e.param as FightMoreVo;
					currentPosition=BytesUtil.ShortPointToInt32(fightMoreVo.pt.x,fightMoreVo.pt.y);
					cFight=new CFight();
					cFight.skillId=fightMoreVo.skillId;
					cFight.tagIdArr=fightMoreVo.uAtkArr;
					cFight.tagPos=currentPosition;
					MsgPool.sendGameMsg(GameCmd.CFight,cFight);
					break;
				case MapScenceEvent.C_FightMoreBeatBack:  //击退 无点
					fightMoreVo=e.param as FightMoreVo;
//					currentPosition=BytesUtil.ShortPointToInt32(fightMoreVo.pt.x,fightMoreVo.pt.y);
					cFightBeatBack=new CFightBeatBack();
					cFightBeatBack.skillId=fightMoreVo.skillId;
//					cFightBeatBack.skillTagPos=currentPosition;
					cFightBeatBack.tagInfoArr=getBeatBackTargetArr(fightMoreVo);
					MsgPool.sendGameMsg(GameCmd.CFightBeatBack,cFightBeatBack);
					break;
				case MapScenceEvent.C_FightMore_PtBeatBack: //击退 有点 
					fightMoreVo=e.param as FightMoreVo;
					currentPosition=BytesUtil.ShortPointToInt32(fightMoreVo.pt.x,fightMoreVo.pt.y);
					cFightBeatBack=new CFightBeatBack();
					cFightBeatBack.skillId=fightMoreVo.skillId;
					cFightBeatBack.skillTagPos=currentPosition; 
					cFightBeatBack.tagInfoArr=getBeatBackTargetArr(fightMoreVo);
					MsgPool.sendGameMsg(GameCmd.CFightBeatBack,cFightBeatBack);
					break;
				case MapScenceEvent.C_RoleRevive:
					///人物复活请求
					var reviveData:Boolean=Boolean(e.param);
					var cReviveHero:CReviveHero=new CReviveHero();
					cReviveHero.freeRevive=reviveData;
					MsgPool.sendGameMsg(GameCmd.CReviveHero,cReviveHero);
					break;
				case MapScenceEvent.C_ChangeMapScence: //切换场景
				case GlobalEvent.RaidLeave:  //离开副本 
					var cEnterNewMap:CEnterNewMap=new CEnterNewMap();
					MsgPool.sendGameMsg(GameCmd.CEnterNewMap,cEnterNewMap);
					///切换场景
					break;
				case MapScenceEvent.C_GetDropGoods:  ///拾取物品图标
					//拾取物品
					var dropGoodsObj:Object=e.param;//  {id:dyId}
					var cPickItem:CPickupItem=new CPickupItem();
					cPickItem.itemDyId=dropGoodsObj.id;
					MsgPool.sendGameMsg(GameCmd.CPickupItem,cPickItem);
					break;
				case MapScenceEvent.C_GetMoreDropGoods: //获取大量道具
					var  moreDropGoods:Array=e.param as Array;
					var cPickupMultiItems:CPickupMultiItems=new CPickupMultiItems();
					cPickupMultiItems.itemDyIds=moreDropGoods;
					MsgPool.sendGameMsg(GameCmd.CPickupMultiItems,cPickupMultiItems);
					break;
				case MapScenceEvent.C_SKipToPoint:
					///跳转到目标点
					if(DataCenter.Instance.mapSceneBasicVo.type!=TypeRole.MapScene_Raid)
					{
						var flayBootVo:FlyBootVo=e.param as FlyBootVo;
//						var flyPorpsPos:int=PropsDyManager.instance.getFirstPropsPostionFromBagByPropType(TypeProps.PROPS_TYPE_FLY);
//						if(flyPorpsPos>0)
//						{
//							_mapScenceView._senceRolesView.heroView.stopMove();
							var cFly:CFly=new CFly();
							cFly.sceneId=flayBootVo.mapId;
							cFly.tagX=flayBootVo.mapX;
							cFly.tagY=flayBootVo.mapY;
							cFly.itemPos=flayBootVo.flyItemPos;
							MsgPool.sendGameMsg(GameCmd.CFly,cFly);
//						}
//						else 
//						{
//							NoticeUtil.setOperatorNotice("背包没有传送道具");
//						}
					}
					else 
					{
						NoticeUtil.setOperatorNotice("副本地图不能使用小飞鞋");
					}

					break;
				case MapScenceEvent.C_BlinkMove:
					///主角瞬移
					var blinkMoveVo:BlinkMoveVo=e.param as BlinkMoveVo;
					
//					YFSocket.Instance.sendMessage(CMDMapScence.C_BlinkMove,blinkMoveVo);
					break;
				case MapScenceEvent.C_RequestGather: //请求采集
					var  gatherId:int=int(e.param);
					var cGather:CGather=new CGather();
					cGather.dyId=gatherId;
					MsgPool.sendGameMsg(GameCmd.CGather,cGather);
					break;
//				case MapScenceEvent.C_Mounting:
//					var heroMountChange:MountChangeVo=e.param as MountChangeVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_Mounting,heroMountChange);
//					break;
//				case MapScenceEvent.C_DisMounting:
//					var heroMountOut:MountChangeVo=e.param as MountChangeVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_DisMounting,heroMountOut);
//					break;
//				case MapScenceEvent.C_MonsterMoving:
//				///怪物处在移动当中   
//					var monsterMoveVo:MonsterMoveVo=e.param as MonsterMoveVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterMoving,monsterMoveVo);
//					monsterMoveVo.disposeToPool();
//					break;
//				case MapScenceEvent.C_MonsterBeginMove:
//					////通知服务端怪物开始移动
//					var monsterBeginMove:MonsterMoveVo=e.param as MonsterMoveVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterBeginMove,monsterBeginMove);
//					monsterBeginMove.disposeToPool();
//					break;
//				case MapScenceEvent.C_MonsterStopMove:
//					///怪物停止移动
//					var monsterStopMoveVo:MonsterStopMoveVo=e.param as MonsterStopMoveVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterStopMove,monsterStopMoveVo);
//					break;

//				case MapScenceEvent.C_BackSlideMove:
//					/// 推开 或者拉取 角色时 的通讯  瞬间改变 该角色在服务端的位置     该通迅并不需要返回  只是改变 拉取 推离角色在服务端的位置
//					var backSlideMoveVo:BackSlideMoveVo=e.param as BackSlideMoveVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_BackSlideMove,backSlideMoveVo);
//					break;
//				case MapScenceEvent.C_RoleRevive:
//					///人物复活请求
//					YFSocket.Instance.sendMessage(CMDMapScence.C_RoleRevive);
//					break;
//				case MapScenceEvent.C_Sit:
//					//请求打坐
//					YFSocket.Instance.sendMessage(CMDMapScence.C_Sit);
//					break;
//				case MapScenceEvent.C_OutSit:
//					//请求离开打坐
//					YFSocket.Instance.sendMessage(CMDMapScence.C_OutSit);
//					break;
			}
		}
	
		/**获取击退玩家信息数组
		 */
		private function getBeatBackTargetArr(fightUIVo:FightMoreVo):Array
		{
			var beatBackTarget:BeatBackTarget;
			var len:int=fightUIVo.uAtkPosArr.length;
			var arr:Array=[];
			for(var i:int=0;i!=len;++i)
			{
				beatBackTarget=new BeatBackTarget();
				beatBackTarget.targetId=fightUIVo.uAtkArr[i];
				beatBackTarget.beatBackPos=fightUIVo.uAtkPosArr[i];
				arr.push(beatBackTarget);
			}
			return arr;
		}
		/** position数组转化为 point数组 
		 */		
		private function positionArrToPointArr(arr:Array):Array
		{
			var len:int=arr.length;
			var newArr:Array=[];
			var currentPos:Point;
			for(var i:int=0;i!=len;++i)
			{
				currentPos=BytesUtil.int32ToShortPoint(arr[i]);
				newArr.push(new Point(currentPos.x,currentPos.y));
			}
			return newArr;
		}
		/**  服务端发回的是  格子， 客户端需要转化为像素点
		 * @param arr  tile 点  格子点<int32类型  代表2个点>  返回的是flash point 类型的点
		 * @return 
		 */		
		private function tilePositionArrToPointArr(arr:Array):Array
		{
			var len:int=arr.length;
			var newArr:Array=[];
			var pt:Point;
			var currentPos:Point;
			for(var i:int=0;i!=len;++i)
			{
				currentPos=BytesUtil.int32ToShortPoint(arr[i]);
				pt=RectMapUtil.getFlashCenterPosition(currentPos.x,currentPos.y);
				newArr.push(pt);
			}
			return newArr;
		}
		/**point数组转化为 position数组
		 */		
		private function pointArrToPositionArr(arr:Array):Array
		{
			var len:int=arr.length;
			var newArr:Array=[];
			var pos:int;
			for(var i:int=0;i!=len;++i)
			{
//				pos=new Position();
//				pos.x=arr[i].x;
//				pos.y=arr[i].y;
				pos=BytesUtil.ShortPointToInt32(arr[i].x,arr[i].y);
				newArr.push(pos);
			}
			return newArr;
		}
		
		
		
		
	}
}