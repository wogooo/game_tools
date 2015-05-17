package com.YFFramework.game.core.module.mapScence
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.core.world.model.PlayerMoveResultVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightHurtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.view.MapScenceView;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.enumdef.EquipType;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CPickupItem;
	import com.msg.hero.SChangeCareer;
	import com.msg.hero.SChangeCareerNotify;
	import com.msg.hero.SHeroUseItemNotify;
	import com.msg.hero.SOtherRoleLevelup;
	import com.msg.hero.SPickupItem;
	import com.msg.hero.SRoleLevelup;
	import com.msg.mapScene.CEnterNewMap;
	import com.msg.mapScene.CHeroMoving;
	import com.msg.mapScene.CPetMoving;
	import com.msg.mapScene.CPetPull;
	import com.msg.mapScene.CReviveHero;
	import com.msg.mapScene.OtherRoleInfo;
	import com.msg.mapScene.SEnterNewMap;
	import com.msg.mapScene.SFirstEnterInfo;
	import com.msg.mapScene.SHeroDead;
	import com.msg.mapScene.SHeroEquipChange;
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
	import com.msg.pets.SPetUseItemNotify;
	import com.msg.skill_pro.CFight;
	import com.msg.skill_pro.DamageInfo;
	import com.msg.skill_pro.SBuffDamage;
	import com.msg.skill_pro.SFight;
	import com.msg.skill_pro.SRemoveBuff;
	import com.net.MsgPool;
	
	import flash.display.PixelSnapping;
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
		}
		
		override public function init():void
		{
			addEvents();
			addSocketCallback();
			initUI();
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
//			///////////c -------------- socket 发送
//			//主角在移动当中
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_HeroMoving,onSendSocketEvent);
			
//			YFEventCenter.Instance.addEventListener(GlobalEvent.PetFight,onPetFight);
			
			//			///拉取宠物 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PullPet,onSendSocketEvent);
			///宠物移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PetMoving,onSendSocketEvent);
				///开始战斗
				///群攻  无 鼠标点
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore,onSendSocketEvent);///开始战斗
				///单一攻击
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightSingle,onSendSocketEvent);///开始战斗
				///具有鼠标点信息
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore_Pt,onSendSocketEvent);///开始战斗

			//			////人物复活请求
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_RoleRevive,onSendSocketEvent);
			
			//			///切换场景
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_ChangeMapScence,onSendSocketEvent);
			//			//	通知服务端拾取物物品
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_GetDropGoods,onSendSocketEvent);
			//			移形换影  主角瞬移
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_BlinkMove,onSendSocketEvent);
			
			
			
			
			
			
			
			///// recevive--------------
			
						//玩家角色血量改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,onHeroHpChange);
			
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
//			///玩家瞬移到某个地方
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_SKipToPoint,onSendSocketEvent);
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
			///其他玩家列表信息
			MsgPool.addCallBack(GameCmd.SOtherRoleInfo,SOtherRoleInfo,otherRoleListEnterView);
			///主角发生移动
			MsgPool.addCallBack(GameCmd.SOtherRoleMoving,SOtherRoleMoving,otherRoleMoving);
			///玩家离开视野
			MsgPool.addCallBack(GameCmd.SOtherRoleListExitView,SOtherRoleListExitView,otherRoleListExitView);
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
			///其他玩家血量魔法值改变
			MsgPool.addCallBack(GameCmd.SOtherRoleHpMpChange,SOtherRoleHpMpChange,otherRoleHpMpChange);
			///人物换装
			MsgPool.addCallBack(GameCmd.SHeroEquipChange,SHeroEquipChange,onHeroEquipChange);
			///掉落物品拾取返回
			MsgPool.addCallBack(GameCmd.SPickupItem,SPickupItem,onPickUpItem);
			
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
		}
		
		/**主角转职成功
		 */		
		private function sChangeCareerCallBack(sChangeCareer:SChangeCareer):void
		{
			DataCenter.Instance.roleSelfVo.roleDyVo.career=sChangeCareer.career;
			DataCenter.Instance.roleSelfVo.roleDyVo.potential=sChangeCareer.potential;
			//			print(this,"转职成功");
			NoticeUtil.setOperatorNotice("转职成功");
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
			_mapScenceView.updateShowEffect(sPetUseItemNotify.dyId,sPetUseItemNotify.skillId,sPetUseItemNotify.addHp,sPetUseItemNotify.hp,sPetUseItemNotify.addMana,sPetUseItemNotify.mp,sPetUseItemNotify.buffId);
		}
		/**  人物加血加蓝  其他玩家或者自己
		 */		
		private function onPlayerAddHpMp(sHeroUseItemNotify:SHeroUseItemNotify):void
		{
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
			noticeAddBuff(sBuffDamage.dyId,sBuffDamage.buffId);
			noticeHeroInfoChange();
		}

		/** 拾取道具
		 */		
		private function onPickUpItem(sPickupItem:SPickupItem):void
		{
			if(sPickupItem.erroInfo==RspMsg.RSPMSG_SUCCESS)
			{
				print(this,"道具拾取成功");
//				NoticeUtil.setOperatorNotice("道具拾取成功");
			}
			else 
			{
				print(this,"道具拾取失败");
				NoticeUtil.setOperatorNotice("其他玩家道具不能拾取!");
			}
		}
	
		/**主角装备改变
		 */		
		private function onHeroEquipChange(sHeroEquipChange:SHeroEquipChange):void
		{
			switch(sHeroEquipChange.partType)
			{
				case EquipType.EQUIP_TYPE_CLOTHES: //衣服
					_mapScenceView._senceRolesView.updateCloth(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					break;
				case EquipType.EQUIP_TYPE_WEAPON: ///武器
					_mapScenceView._senceRolesView.updateWeapon(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					break;
				case EquipType.EQUIP_TYPE_WINGS: ///翅膀
					_mapScenceView._senceRolesView.updateWing(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
					break;
//				case EquipType.EQUIP_TYPE_SHIELD:  //盾牌
//					_mapScenceView._senceRolesView.updateShield(sHeroEquipChange.dyId,sHeroEquipChange.equipId);
//					break;
			}
		}
			
		
		/**  通知添加buff主界面显示
		 */		
		private function noticeAddBuff(dyId:int,buffId:int):void
		{
			if(dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AddBuff,buffId);
			}
			else if(PetDyManager.Instance.hasPet(dyId)) //如果为宠物
			{
				//宠物血量改变
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg,RoleDyManager.Instance.getRole(dyId).hp);
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
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DeleteBuff,buffId);
			}
		}
	
		/**玩家升级
		 */ 
		private function roleLevelUp(sRoleLevelup:SRoleLevelup):void
		{
			DataCenter.Instance.roleSelfVo.roleDyVo.level=sRoleLevelup.level;
			DataCenter.Instance.roleSelfVo.roleDyVo.hp=sRoleLevelup.hp;
			DataCenter.Instance.roleSelfVo.roleDyVo.mp=sRoleLevelup.mp;
			_mapScenceView.updateRoleLevelUp(DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			///开始转职
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=10&&DataCenter.Instance.roleSelfVo.roleDyVo.career==TypeRole.CAREER_NEWHAND) YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ShowSelectCareerWindow);
			///主角升级
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroLevelUp);
		}
		/**其他角色升级
		 */		
		private function otherOtherRoleLevelUp(sOtherRoleLevelup:SOtherRoleLevelup):void
		{
			RoleDyManager.Instance.updateLevel(sOtherRoleLevelup.dyId,sOtherRoleLevelup.level);
			_mapScenceView.updateRoleLevelUp(sOtherRoleLevelup.dyId);
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
				var roleDeadId:uint=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
				_mapScenceView.updateRoleDead(roleDeadId);
		}
		/**  人物复活
		 */		
		private function reviveCallBack(sReviveHero:SReviveHero):void
		{
			var roleRevive:RoleReviveVo=new RoleReviveVo();
			roleRevive.dyId=sReviveHero.dyId;
			roleRevive.hp=sReviveHero.hp
			_mapScenceView._senceRolesView.updateReviveRole(roleRevive);
			//通知主界面UI进行血量更新
		//	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,DataCenter.Instance.roleSelfVo.roleDyVo);
			noticeHeroInfoChange();
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
			var currentPos:Object;
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
			roledyVo.maxMp=otherRoleInfo.mpMax
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
			///服务端返回战斗信息    指的是人物发起的战斗  具有目标点
			var fightMorePtRessultVo:FightMorePtResultVo=PoolCenter.Instance.getFromPool(FightMorePtResultVo) as FightMorePtResultVo;
			fightMorePtRessultVo.atkId=sFight.atkId;
			fightMorePtRessultVo.skillId=sFight.skillId;
			fightMorePtRessultVo.skillLevel=sFight.skillLevel;
			if(sFight.hasAtkHp)
			{
				RoleDyManager.Instance.updateHp(sFight.atkId,sFight.atkHp);
				_mapScenceView._senceRolesView.updateHp(fightMorePtRessultVo.atkId);
			}
			if(sFight.hasAtkMp)
			{
				RoleDyManager.Instance.updateMp(sFight.atkId,sFight.atkMp);
			}
			if(sFight.hasAtkHp&&sFight.hasAtkMp)
			{
				noticeHeroInfoChange();
			}
			if(sFight.tagPos)
			{
				var position:Object=BytesUtil.int32ToShortPoint(sFight.tagPos);   // int转化为 点坐标
				fightMorePtRessultVo.mapX=position.x;
				fightMorePtRessultVo.mapY=position.y;
			}
			fightMorePtRessultVo.uAtkArr=[];
			var fightHurtVo:FightHurtVo;
			for each(var damegeInfo:DamageInfo in sFight.damageInfoArr)
			{
				fightHurtVo=new FightHurtVo();	
				fightHurtVo.dyId=damegeInfo.tagId;
				fightHurtVo.changeHp=damegeInfo.hpChange;
				fightHurtVo.changeMP=damegeInfo.mpChange;
				fightHurtVo.buffId=damegeInfo.buff_id;
				fightHurtVo.damageType=damegeInfo.damageType;
				fightHurtVo.hp=damegeInfo.hp;
				fightMorePtRessultVo.uAtkArr.push(fightHurtVo);
			}
			////判断技能类型
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightMorePtRessultVo.skillId,fightMorePtRessultVo.skillLevel);
			///播放cd動畫  當為自己時  播放cd動畫
			if(fightMorePtRessultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightMorePtRessultVo.skillId);
//				print(this,"播放技能CD动画待做...");
			}
			////判断技能类型
			var fightType:int=TypeSkill.getFightType(skillBasicVo.use_type);
			switch(fightType)
			{
				case TypeSkill.FightType_MoreRole: /// 有角色才会触发
					_mapScenceView.updateFightMore(fightMorePtRessultVo,false);
					break;
				case TypeSkill.FightType_MoreAll:///不管有无角色 都会触发
					_mapScenceView.updateFightMore(fightMorePtRessultVo,true);
					break;
				case TypeSkill.FightType_MorePt:// 有坐标点才会触发
					_mapScenceView.updateFightMorePt(fightMorePtRessultVo);
					break;
			}
			fightMorePtRessultVo.disposeToPool();
		}
		
		
		/**宠物移动
		 */		
		private function petMoving(sPetMoving:SPetMoving):void
		{
				//宠物发生移动
			var petMovingVo:PetMoveResultVo=PoolCenter.Instance.getFromPool(PetMoveResultVo,null) as PetMoveResultVo;
			var currentPos:Object=BytesUtil.int32ToShortPoint(sPetMoving.currentPosition);
			petMovingVo.id=sPetMoving.id;
			petMovingVo.direction=sPetMoving.direction;
			petMovingVo.mapX=currentPos.x;
			petMovingVo.mapY=currentPos.y;
			petMovingVo.speed=sPetMoving.speed;
			petMovingVo.path=positionArrToPointArr(sPetMoving.path);	
			_mapScenceView.updatePetMovePath(petMovingVo);	
			petMovingVo.disposeToPool();
		}
		/**拉取宠物
		 */		
		private function onPetPull(sPetPull:SPetPull):void
		{
			//					///服务端返回拉取宠物的结果
			var pullPetVo:PullPetVo=new PullPetVo();
			pullPetVo.dyId=sPetPull.id;
			var currentPos:Object=BytesUtil.int32ToShortPoint(sPetPull.currentPosition);
			pullPetVo.mapX=currentPos.x;
			pullPetVo.mapY=currentPos.y;
			_mapScenceView.updatePullPet(pullPetVo);
		}
		/**  怪物移动
		 */		
		private function monsterMoving(sMonsterMoving:SMonsterMoving):void
		{
			//					//怪物处在移动中
			var monsterMovingVo:PlayerMoveResultVo=PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
			var currentPos:Object=BytesUtil.int32ToShortPoint(sMonsterMoving.currentPosition);
			monsterMovingVo.id=sMonsterMoving.dyId;
			monsterMovingVo.mapX=currentPos.x;
			monsterMovingVo.mapY=currentPos.y;
			monsterMovingVo.path=tilePositionArrToPointArr(sMonsterMoving.path);
			monsterMovingVo.speed=sMonsterMoving.speed/UpdateManager.UpdateRate;
			_mapScenceView.updatePlayerMovePath(monsterMovingVo,true,true);	
			monsterMovingVo.disposeToPool();

		}
		/** 其他玩家离开视野
		 * @param 
		 */		
		private function otherRoleListExitView(sOtherRoleListExitView:SOtherRoleListExitView):void
		{
			for each (var id:int in sOtherRoleListExitView.dyIdArr)
			{
				RoleDyManager.Instance.delRole(id);
				_mapScenceView._senceRolesView.delRole(id);
			}
		}
			
		
		/**其他角色发生移动
		 */		
		private function otherRoleMoving(sOtherRoleMoving:SOtherRoleMoving):void
		{
			var playerMovingVo:PlayerMoveResultVo=PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
			var currentPos:Object=BytesUtil.int32ToShortPoint(sOtherRoleMoving.currentPostion);
			playerMovingVo.id=sOtherRoleMoving.id;
			playerMovingVo.mapX=currentPos.x;
			playerMovingVo.mapY=currentPos.y;
			playerMovingVo.speed=sOtherRoleMoving.speed;
			playerMovingVo.path=positionArrToPointArr(sOtherRoleMoving.path);
			_mapScenceView.updatePlayerMovePath(playerMovingVo,true,true);
			playerMovingVo.disposeToPool(); 
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
			_mapScenceView._senceRolesView.createHero();
			RoleDyManager.Instance.addRole(roledyVo);  
			///更新血量
			_mapScenceView._senceRolesView.updateHp(roledyVo.dyId);
			_mapScenceView._senceRolesView.updateCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.clothId);
			if(firsterEnterInfo.equipInfo.weaponId>0)
				_mapScenceView._senceRolesView.updateWeapon(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.weaponId);
			if(firsterEnterInfo.equipInfo.wingId>0)
				_mapScenceView._senceRolesView.updateWing(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,firsterEnterInfo.equipInfo.wingId);
		}
		/**其他玩家进入视野
		 */		
		private function otherRoleListEnterView(sOtherRoleInfo:SOtherRoleInfo):void
		{
			var roledyVo:RoleDyVo;
			var monsterBasicVo:MonsterBasicVo;
			var pos:Object;
			for each(var otherRoleInfo:OtherRoleInfo in sOtherRoleInfo.otherRoles)
			{
				///服务端打包 发送，   所以需要除去自己的信息
				if(otherRoleInfo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) continue;
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
				///怪物 设置  名称
				if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster)
				{
					monsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roledyVo.basicId);
					roledyVo.roleName=monsterBasicVo.getName();
					roledyVo.level=monsterBasicVo.level;
				}
				else if(roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods)  ///为物品掉落
				{
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
				
				RoleDyManager.Instance.addRole(roledyVo);
				_mapScenceView._senceRolesView.addRole(roledyVo);
				if(roledyVo.bigCatergory==TypeRole.BigCategory_Player) //玩家对象
				{
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
						if(otherRoleInfo.equipInfo.weaponId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleInfo.equipInfo.weaponId);
					}
					else if(otherRoleInfo.state==TypeRole.State_Sit) ///打坐状态下
					{
						_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,clothId);
						if(otherRoleInfo.equipInfo.weaponId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleInfo.equipInfo.weaponId,otherRoleInfo.sex);
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
			}
		}
		/**
		 */		
		private function heroEnterMap(sEnterNewMap:SEnterNewMap):void
		{
			//					///主角  进入新场景
				///进入场景 
				var bgMapVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(sEnterNewMap.mapId);
				DataCenter.Instance.mapSceneBasicVo=bgMapVo;
				RoleDyManager.Instance.updateMapChange();
				///主场景更新
				_mapScenceView.updateMapSenceView(sEnterNewMap.mapX,sEnterNewMap.mapY);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MapChange); ///smallMap模块进行侦听
		}
		/** 发送socket 消息
		 */ 
		private function onSendSocketEvent(e:YFEvent):void
		{
			var cFight:CFight;
			var currentPosition:int;
			switch(e.type)
			{
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
//					cPetMoving.currentPosition.x=petMoveVo.curentPostion.x;
//					cPetMoving.currentPosition.y=petMoveVo.curentPostion.y;
					cPetMoving.direction=petMoveVo.direction;
					cPetMoving.speed=petMoveVo.speed;
					cPetMoving.path=pointArrToPositionArr(petMoveVo.path);
					petMoveVo.disposeToPool();
					MsgPool.sendGameMsg(GameCmd.CPetMoving,cPetMoving);
					break;
				///宠物拉取
				case MapScenceEvent.C_PullPet:
					///拉取寵物
					var pullPetVo:PullPetVo=e.param as PullPetVo;
					currentPosition=BytesUtil.ShortPointToInt32(pullPetVo.mapX,pullPetVo.mapY);
					var cPetPull:CPetPull=new CPetPull();
					cPetPull.currentPosition=currentPosition;
//					cPetPull.currentPosition.x=pullPetVo.mapX;
//					cPetPull.currentPosition.y=pullPetVo.mapY;
					MsgPool.sendGameMsg(GameCmd.CPetPull,cPetPull);
					break;
				////战斗
				case MapScenceEvent.C_FightMore:
					/// 单一 简单攻击
					var fightMoreVo:FightMoreVo=e.param as FightMoreVo;
					cFight=new CFight();
					cFight.skillId=fightMoreVo.skillId;
					cFight.tagIdArr=fightMoreVo.uAtkArr;
					MsgPool.sendGameMsg(GameCmd.CFight,cFight);
					fightMoreVo.disposeToPool();
					break;
				case MapScenceEvent.C_FightMore_Pt:
					////群攻 带坐标点
					var fightMorePtVo:FightMorePtVo=e.param as FightMorePtVo;
					currentPosition=BytesUtil.ShortPointToInt32(fightMorePtVo.mapX,fightMorePtVo.mapY);
					cFight=new CFight();
					cFight.skillId=fightMoreVo.skillId;
					cFight.tagIdArr=fightMoreVo.uAtkArr;
					cFight.tagPos=currentPosition;
//					cFight.tagPos.x=fightMorePtVo.mapX;
//					cFight.tagPos.y=fightMorePtVo.mapY;
					MsgPool.sendGameMsg(GameCmd.CFight,cFight);
					fightMorePtVo.disposeToPool();
					break;
				case MapScenceEvent.C_RoleRevive:
					///人物复活请求
					var reviveData:Boolean=Boolean(e.param);
					var cReviveHero:CReviveHero=new CReviveHero();
					cReviveHero.freeRevive=reviveData;
					MsgPool.sendGameMsg(GameCmd.CReviveHero,cReviveHero);
					break;
				case MapScenceEvent.C_ChangeMapScence:
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
				case MapScenceEvent.C_BlinkMove:
					///主角瞬移
					var blinkMoveVo:BlinkMoveVo=e.param as BlinkMoveVo;
					
//					YFSocket.Instance.sendMessage(CMDMapScence.C_BlinkMove,blinkMoveVo);
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
//				case MapScenceEvent.C_SKipToPoint:
//					///跳转到目标点
//					var skipPoint:Point=e.param as Point;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_SKipToPoint,skipPoint);
//					break;
			}
		}
	
		/** position数组转化为 point数组 
		 */		
		private function positionArrToPointArr(arr:Array):Array
		{
			var len:int=arr.length;
			var newArr:Array=[];
			var currentPos:Object;
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
			var currentPos:Object;
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
		
		
		/**  成功登陆 初始化角色  socket 返回结果
		 */		
		private function onSocketEvent(e:YFEvent):void
		{
//			var roledyVo:RoleDyVo;
//			var otherRoleEnterMapVo:OtherRoleInfoVo;///其他角色进入可视范围
//			
//		//	var monsterBasicVo:MonsterBasicVo;///怪物基本属性
//			switch(e.type)
//			{
//				case GlobalEvent.GameIn:
//					YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onSocketEvent);
//					///成功登陆后返回
//					///创建角色
//					var loginVo:LoginVo=e.param as LoginVo;
//					roledyVo=new RoleDyVo();
//			//		roledyVo.mountDyId=1131000;//坐骑id 
//					roledyVo.state=TypeRole.State_Normal;
//					roledyVo.bigCatergory=TypeRole.BigCategory_Player;
//					roledyVo.dyId=loginVo.dyId;
//					roledyVo.roleName=loginVo.name;
//					roledyVo.sex=loginVo.sex;
//					DataCenter.Instance.roleSelfVo.hp=loginVo.hp;
//					DataCenter.Instance.roleSelfVo.maxHp=loginVo.maxHp;
//					DataCenter.Instance.roleSelfVo.exp=loginVo.exp;
//					DataCenter.Instance.roleSelfVo.maxExp=loginVo.maxExp;
//					DataCenter.Instance.roleSelfVo.roleDyVo=roledyVo; ///设置数据
//					DataCenter.Instance.roleSelfVo.level=loginVo.level;
//					///创建主角色
//					_mapScenceView._senceRolesView.createHero();
//					
//					RoleDyManager.Instance.addRole(roledyVo);
//					///更新血量
//					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,DataCenter.Instance.roleSelfVo.getHpPercent());
//					_mapScenceView._senceRolesView.updateCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,loginVo.clothBasicId);
//					if(loginVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,loginVo.weaponBasicId);
//					
//					///调试
//					DebugPane.Instance;
//					break;
//				case MapScenceEvent.S_HeroEnterMap: ///主角进入新场景
//					///主角  进入新场景
//					var heroEnterMapVo:HeroEnterMapVo=e.param as HeroEnterMapVo;
//					///进入场景 
//					var bgMapVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(heroEnterMapVo.mapId);
//					DataCenter.Instance.mapSceneBasicVo=bgMapVo;
//					RoleDyManager.Instance.updateMapChange();
//					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MapChange); ///smallMap模块进行侦听
//					///主场景更新
//					_mapScenceView.updateMapSenceView(heroEnterMapVo.mapX,heroEnterMapVo.mapY);
//					break;
//				case MapScenceEvent.S_OtherRoleEnterView:
//					///其他角色进入场景触发
//					otherRoleEnterMapVo=e.param as OtherRoleInfoVo;
//					roledyVo=new RoleDyVo();
//					roledyVo.state=otherRoleEnterMapVo.state;
//					roledyVo.bigCatergory=TypeRole.BigCategory_Player
//					roledyVo.mapX=otherRoleEnterMapVo.mapX;
//					roledyVo.mapY=otherRoleEnterMapVo.mapY;
//					roledyVo.dyId=otherRoleEnterMapVo.roleId
//					roledyVo.roleName=otherRoleEnterMapVo.name;
//					_mapScenceView._senceRolesView.addRole(roledyVo);
//					RoleDyManager.Instance.addRole(roledyVo);
//					///更新血量
//					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,otherRoleEnterMapVo.hpPercent);
//					if(otherRoleEnterMapVo.state==TypeRole.State_Normal)  ///正常状态下
//					{
//						_mapScenceView._senceRolesView.updateCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//					}
//					else if(otherRoleEnterMapVo.state==TypeRole.State_Mount) ///坐骑状态下
//					{
//						_mapScenceView._senceRolesView.updateMountCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//					}
//					else if(otherRoleEnterMapVo.state==TypeRole.State_Sit) ///打坐状态下
//					{
//						_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//					}
//					///回收对象
//					otherRoleEnterMapVo.disposeToPool();
//					print(this,"其他角色进入可视范围...."+roledyVo.dyId,roledyVo.mapX+"may:"+roledyVo.mapX);
//					break;
//				case MapScenceEvent.S_OtherRoleListEnterView:
//					//其他角色列表进入可视范围
//					var addotherRoleList:AddOtherRoleListVo=e.param as AddOtherRoleListVo;
//					
//					for each (otherRoleEnterMapVo in addotherRoleList.otherRoleList)
//					{
//						roledyVo=new RoleDyVo();
//						roledyVo.state=otherRoleEnterMapVo.state;
//						roledyVo.bigCatergory=otherRoleEnterMapVo.playerType;
//						roledyVo.mapX=otherRoleEnterMapVo.mapX;
//						roledyVo.mapY=otherRoleEnterMapVo.mapY;
//						roledyVo.dyId=otherRoleEnterMapVo.roleId;
//						roledyVo.roleName=otherRoleEnterMapVo.name;
//						if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster||roledyVo.bigCatergory==TypeRole.BigCategory_Pet||roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods)
//						{///如果为怪物  读取怪物表 设置 怪物的名称
//							roledyVo.basicId=otherRoleEnterMapVo.clothBasicId;
//						}
//						_mapScenceView._senceRolesView.addRole(roledyVo);
//						RoleDyManager.Instance.addRole(roledyVo);
//						///更新血量
//						_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,otherRoleEnterMapVo.hpPercent);
//
//						if(roledyVo.bigCatergory==TypeRole.BigCategory_Player) //玩家对象
//						{
//							if(otherRoleEnterMapVo.state==TypeRole.State_Normal)  ///正常状态下
//							{
//								_mapScenceView._senceRolesView.updateCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//							}
//							else if(otherRoleEnterMapVo.state==TypeRole.State_Mount) ///坐骑状态下
//							{
//								_mapScenceView._senceRolesView.updateMountCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//							}
//							else if(otherRoleEnterMapVo.state==TypeRole.State_Sit) ///打坐状态下
//							{
//								_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
//								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
//							}
//						}
//						else if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster)///更新怪物
//						{
//							_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
//						}
//						else if(roledyVo.bigCatergory==TypeRole.BigCategory_Pet) ///更新宠物
//						{
//							_mapScenceView._senceRolesView.updatePetClothSKin(roledyVo.dyId,roledyVo.basicId);
//						}
//						else if(roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods) ///更新物品掉落
//						{
//							_mapScenceView._senceRolesView.updateDropGoodsCloth(roledyVo.dyId,roledyVo.basicId);
//						}
//
//						///回收 
//						otherRoleEnterMapVo.disposeToPool();
//					}
//					break;
//				case MapScenceEvent.S_DropGoodsEnterView:
//					///物品掉落进入视野
//					var dropGoodsInfoVo:DropGoodsInfoVo=e.param as DropGoodsInfoVo;
//					roledyVo=new RoleDyVo();
//					roledyVo.bigCatergory=TypeRole.BigCategory_GropGoods;
//					roledyVo.mapX=dropGoodsInfoVo.mapX;
//					roledyVo.mapY=dropGoodsInfoVo.mapY;
//					roledyVo.dyId=dropGoodsInfoVo.roleId;
//					roledyVo.roleName=dropGoodsInfoVo.name;
//					roledyVo.basicId=dropGoodsInfoVo.clothBasicId;
//					RoleDyManager.Instance.addRole(roledyVo);
//					_mapScenceView._senceRolesView.addRole(roledyVo);
//					_mapScenceView._senceRolesView.updateDropGoodsCloth(roledyVo.dyId,dropGoodsInfoVo.clothBasicId);
//					break;
//				case MapScenceEvent.S_otherRoleMoving:
//					//其他角色正在进行移动
//					var playerMovingVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
//					_mapScenceView.updatePlayerMovePath(playerMovingVo,true,true);
//					playerMovingVo.disposeToPool();
//					break;
//				
//				
//				case MapScenceEvent.S_OtherRoleExitView:
//					//其他角色离开主角视野
//					var removeOtherRoleVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
//					RoleDyManager.Instance.delRole(removeOtherRoleVo.roleId);
//					_mapScenceView._senceRolesView.delRole(removeOtherRoleVo.roleId);
//					print(this,"其他角色离开可视范围..."+removeOtherRoleVo.roleId);
//					removeOtherRoleVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_OtherRoleListExitView:
//					///其他角色列表离开主角视野
//					var removeOtherRoleList:RemoveRoleListVo=e.param as RemoveRoleListVo;
//					for each (var removeOtherRole:RemoveOtherRoleVo in removeOtherRoleList.otherRoleList)
//					{
//						RoleDyManager.Instance.delRole(removeOtherRole.roleId);
//						_mapScenceView._senceRolesView.delRole(removeOtherRole.roleId);
//						removeOtherRole.disposeToPool();
//					}
//					
//					break;
//				case MapScenceEvent.S_AnimatorExitScence:
//					///玩家离线
//					var exitRoleId:uint=uint(e.param);
//					RoleDyManager.Instance.delRole(exitRoleId);
//					_mapScenceView._senceRolesView.delRole(exitRoleId);
//			//		print(this,"用户"+exitRoleId+"离线");
//					break;
//				///怪物死亡
//				case MapScenceEvent.S_MonsterExitScence:
//				//	print(this,"怪物死亡");
//					var monsterDeadVo:MonsterDeadVo=e.param as MonsterDeadVo;
//					RoleDyManager.Instance.delRole(monsterDeadVo.deadId);
//					_mapScenceView.updateMonsterDead(monsterDeadVo);
//					break;
//				///人物死亡
//				case MapScenceEvent.S_RoleDead:
//				//	print(this,"人物死亡");
//					var roleDead:uint=uint(e.param);
//					_mapScenceView.updateRoleDead(roleDead);
//			//		print(this,"时间:dead::",getTimer()-_time,"fps:",Stats.Instance.getFps());
//					break;
//				
//				case MapScenceEvent.S_RoleRevive:
//					///人物复活
//					var roleRevive:RoleReviveVo=e.param as RoleReviveVo;
//					_mapScenceView._senceRolesView.updateReviveRole(roleRevive)
//					break;				
//				case MapScenceEvent.S_Mounting:
//					///玩家切换坐骑状态   上坐骑
//					var mountChangeVo:MountChangeResultVo=e.param as MountChangeResultVo;
//					_mapScenceView.updateMountChange(mountChangeVo,TypeRole.State_Mount);
//					break;
//				case MapScenceEvent.S_DisMounting:
//					///玩家切换坐骑状态  下坐骑
//					var disMounting:MountChangeResultVo=e.param as MountChangeResultVo;
//					_mapScenceView.updateMountChange(disMounting,TypeRole.State_Normal);
//					break;
//				case MapScenceEvent.S_MonsterBeginMove:
//					///怪物开始移动
//					var monsterbeginMoveVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
//					_mapScenceView.updatePlayerMovePath(monsterbeginMoveVo,false,false);					
//					monsterbeginMoveVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_MonsterMoving:
//					//怪物处在移动中
//					var monsterMovingVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
//					_mapScenceView.updatePlayerMovePath(monsterMovingVo,true,true);	
//					monsterMovingVo.disposeToPool();
//					break;
//				
//				case MapScenceEvent.S_MonsterEnterView:
//					///怪物进入玩家可视范围	
//					var monsterInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
//					roledyVo=new RoleDyVo();
//					roledyVo.bigCatergory=TypeRole.BigCategory_Monster;
//					roledyVo.mapX=monsterInfoVo.mapX;
//					roledyVo.mapY=monsterInfoVo.mapY;
//					roledyVo.dyId=monsterInfoVo.roleId;
//					roledyVo.basicId=monsterInfoVo.clothBasicId;
//					roledyVo.roleName=monsterInfoVo.name;
//					_mapScenceView._senceRolesView.addRole(roledyVo);
//					RoleDyManager.Instance.addRole(roledyVo);
//					///更新血量
//					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,monsterInfoVo.hpPercent);
//					_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
//					monsterInfoVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_MonsterBirth:
//					///怪物出生
//					var monsterBirthInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
//					roledyVo=new RoleDyVo();
//					roledyVo.bigCatergory=TypeRole.BigCategory_Monster;
//					roledyVo.mapX=monsterBirthInfoVo.mapX;
//					roledyVo.mapY=monsterBirthInfoVo.mapY;
//					roledyVo.dyId=monsterBirthInfoVo.roleId;
//					roledyVo.basicId=monsterBirthInfoVo.clothBasicId;
//					roledyVo.roleName=monsterBirthInfoVo.name;
//					_mapScenceView._senceRolesView.addRole(roledyVo,true);
//					RoleDyManager.Instance.addRole(roledyVo);
//					///更新血量
//					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,monsterBirthInfoVo.hpPercent);
//					_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
//					monsterBirthInfoVo.disposeToPool();
//
//					break;
//				case MapScenceEvent.S_MonsterExitView:
//					///怪物离开玩家可视范围
//					var removeMonsterVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
//					RoleDyManager.Instance.delRole(removeMonsterVo.roleId);
//					_mapScenceView._senceRolesView.delRole(removeMonsterVo.roleId);
//					removeMonsterVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_FightMore:
//					///服务端返回战斗信息    指的是人物发起的战斗
//					var fightMoreResultVo:FightMoreResultVo=e.param as FightMoreResultVo; ////函数内部释放
//					///播放cd動畫  當為自己時  播放cd動畫
//					if(fightMoreResultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
//					{
//						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightMoreResultVo.skillId);
//					}
//					_mapScenceView.updateFightMore(fightMoreResultVo);
//					break;
//				case MapScenceEvent.S_FightMore_Pt:
//					///服务端返回战斗信息    指的是人物发起的战斗  具有目标点
//					var fightMorePtRessultVo:FightMorePtResultVo=e.param as FightMorePtResultVo; ////函数内部释放
//					///播放cd動畫  當為自己時  播放cd動畫
//					if(fightMorePtRessultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
//					{
//						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightMorePtRessultVo.skillId);
//					}
//					_mapScenceView.updateFightMorePt(fightMorePtRessultVo);
//					break;
//				case MapScenceEvent.S_FightSingle:
//					///服务端返回战斗信息    指的是人物发起的战斗  简单战斗 
//					var fightSingleResultVo:FightSingleResultVo=e.param as FightSingleResultVo; ////函数内部释放
//					///播放cd動畫  當為自己時  播放cd動畫
//					if(fightSingleResultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
//					{
//						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightSingleResultVo.skillId);
//					}
//					_mapScenceView.updateFightSingle(fightSingleResultVo);
//					break;
//				case MapScenceEvent.S_BlinkMove:
//					///移形换影  瞬移
//					var blinkMoveResultVo:BlinkMoveResultVo=e.param as BlinkMoveResultVo;
//					_mapScenceView.updateBlinkMove(blinkMoveResultVo);
//					break;
//				case MapScenceEvent.S_MonsterHitPlayer:
//					//怪物发起的攻击  更新战斗
//					var monsterFightResultVo:FightMoreResultVo=e.param as FightMoreResultVo; ////函数内部释放 
//					_mapScenceView.updateMonsterFight(monsterFightResultVo);
//					break;
//				case MapScenceEvent.S_MonsterStopMove:
//					//怪物停止移动
//					var monsterStopMoveResultVo:MonsterStopMoveResultVo=e.param as MonsterStopMoveResultVo;
//					_mapScenceView._senceRolesView.updateMonsterStopMove(monsterStopMoveResultVo);
//					monsterStopMoveResultVo.disposeToPool();
//					break;//
//				
//				
//				/////////////// 怪物ai--------------------
//				case MapScenceEvent.S_MonsterSetTarget:
//					///设置怪物目标
//					var setTargetDyId:String=String(e.param);
//					_mapScenceView._senceRolesView.setMonsterTarget(setTargetDyId);
//					break;
//				case MapScenceEvent.S_MonsterFreeTarget:
//					///解除怪物目标
//					var freeTargetDyId:String=String(e.param);
//					_mapScenceView._senceRolesView.freeMonsterTarget(freeTargetDyId);
//					break;
//				case MapScenceEvent.S_MonsterNearToPlayer:
//					///怪物向目标玩家靠近
//					var monsterNearToPlayer:MonsterWalkVo=e.param as MonsterWalkVo;
//					_mapScenceView.updateMonsterMoveToPoint(monsterNearToPlayer);
//					monsterNearToPlayer.disposeToPool();
//					break;
//				
//				////////////////////宠物 。。。。---------------------------------------------------------------
//				case MapScenceEvent.S_PetEnterView:
//					///宠物进入视野
//					var petInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
//					roledyVo=new RoleDyVo();
//					roledyVo.bigCatergory=TypeRole.BigCategory_Pet;
//					roledyVo.mapX=petInfoVo.mapX;
//					roledyVo.mapY=petInfoVo.mapY;
//					roledyVo.dyId=petInfoVo.roleId;
//					roledyVo.roleName=petInfoVo.name;
//					roledyVo.basicId=petInfoVo.clothBasicId; ///获取怪物静态id 
//					_mapScenceView._senceRolesView.addRole(roledyVo);
//					RoleDyManager.Instance.addRole(roledyVo);
//					///更新血量
//					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,petInfoVo.hpPercent);
//
//					_mapScenceView._senceRolesView.updatePetClothSKin(roledyVo.dyId,roledyVo.basicId);
//					petInfoVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_PetExitView:
//					var removePetVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
//					RoleDyManager.Instance.delRole(removePetVo.roleId);
//					_mapScenceView._senceRolesView.delRole(removePetVo.roleId);
//					removePetVo.disposeToPool();
//					break;
//				case GlobalEvent.PetPlay:
//					///  宠物出战
//					var petResultVo:PetPlayResultVo=e.param as PetPlayResultVo;
//					_mapScenceView.updatePetPlay(petResultVo);
//					break;
//				case MapScenceEvent.S_PullPet:
//					///服务端返回拉取宠物的结果
//					var pullPetVo:PullPetVo=e.param as PullPetVo;
//					_mapScenceView.updatePullPet(pullPetVo);
//					break;
//				case MapScenceEvent.S_PetMoving:
//					//宠物发生移动
//					var petMovingVo:PetMoveResultVo=e.param as PetMoveResultVo;
//					_mapScenceView.updatePetMovePath(petMovingVo);	
//					petMovingVo.disposeToPool();
//					break;
//				case MapScenceEvent.S_PetMoveToTarget:
//					//宠物向目标玩家靠近 准备发起攻击
//					var petMoveToTargetResultVo:PetMoveToTargetResultVo=e.param as PetMoveToTargetResultVo;
//					_mapScenceView.updatePetMoveToTarget(petMoveToTargetResultVo.petId,petMoveToTargetResultVo.tId);
//					break;
//				case MapScenceEvent.S_Sit:
//					///服务端返回打坐
//					var sitChangeVo:SitChangeVo=e.param as SitChangeVo;
//					_mapScenceView._senceRolesView.updateSitCloth(sitChangeVo.dyId,sitChangeVo.clothBasicId);
//					_mapScenceView._senceRolesView.updateSitWeapon(sitChangeVo.dyId,sitChangeVo.weaponBasicId);				
//					print(this,"服务端返回打坐");
//					break;
//				case MapScenceEvent.S_outSit:
//					//服务端返回取消打坐
//					var outSitChangeVo:SitChangeVo=e.param as SitChangeVo
//					_mapScenceView._senceRolesView.updateCloth(outSitChangeVo.dyId,outSitChangeVo.clothBasicId);
//					_mapScenceView._senceRolesView.updateWeapon(outSitChangeVo.dyId,outSitChangeVo.weaponBasicId);
//					_mapScenceView._senceRolesView.removePlayerFrontEffect(outSitChangeVo.dyId);///移除 玩家特效
//					print(this,"服务端返回取消打坐");
//					break;
//				
//				case MapScenceEvent.S_FailToGetDropGoods:
//					print(this,"拾取物品失败");
//					YFAlert.show("拾取物品失败");
//					break;
//				case MapScenceEvent.S_SKipToPoint:
//					///跳转
//					print(this,"进行SKipToPoint");
//					var skipToPoint:Point=e.param as Point;
//					_mapScenceView.updateSkipToPoint(skipToPoint);
//					break;
//				case MapScenceEvent.S_FailSKipToPoint:
//					YFAlert.show("此地图点不能到达");
//					break;
//			}
		}
		
	}
}