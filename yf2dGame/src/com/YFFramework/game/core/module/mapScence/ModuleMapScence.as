package com.YFFramework.game.core.module.mapScence
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.core.ui.yfComponent.controls.YFAlert;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.core.world.model.MonsterMoveVo;
	import com.YFFramework.core.world.model.PlayerMoveResultVo;
	import com.YFFramework.core.world.model.PlayerMoveVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.login.model.LoginVo;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.BackSlideMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.MonsterDeadVo;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.SitChangeVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightSingleResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightSingleVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.AddOtherRoleListVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.CMDMapScence;
	import com.YFFramework.game.core.module.mapScence.model.proto.DropGoodsInfoVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.HeroEnterMapVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterStopMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterStopMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterWalkVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MountChangeResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MountChangeVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.OtherRoleInfoVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveToTargetResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.RemoveOtherRoleVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.RemoveRoleListVo;
	import com.YFFramework.game.core.module.mapScence.view.MapScenceView;
	import com.YFFramework.game.core.module.pet.model.PetPlayResultVo;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.YFFramework.game.debug.DebugPane;
	
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
		
		override public function show():void
		{
			initUI();
			addEvents();
		}
		private function initUI():void
		{
			_mapScenceView=new MapScenceView();
		}
		private function addEvents():void
		{
			///////////c -------------- socket 发送
			
			///主角人物移动 
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_HeroBeginMovePath,onSendSocketEvent);
			//主角在移动当中
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_HeroMoving,onSendSocketEvent);
			///人物切换坐骑状态
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_Mounting,onSendSocketEvent);///角色切换坐骑状态  /// 上坐骑
			///
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_DisMounting,onSendSocketEvent);///角色切换坐骑状态  /// 上坐骑

			
			///怪物处在移动当中
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterMoving,onSendSocketEvent);
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterBeginMove,onSendSocketEvent);
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_MonsterStopMove,onSendSocketEvent);///怪物停止移动
			
			///开始战斗
			///群攻  无 鼠标点
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore,onSendSocketEvent);///开始战斗
			///单一攻击
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightSingle,onSendSocketEvent);///开始战斗
			///具有鼠标点信息
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_FightMore_Pt,onSendSocketEvent);///开始战斗

			
			///主角瞬移
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_BlinkMove,onSendSocketEvent);
			/// 推开 或者拉取 角色时 的通讯  瞬间改变 该角色在服务端的位置     该通迅并不需要返回  只是改变 拉取 推离角色在服务端的位置
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_BackSlideMove,onSendSocketEvent);
			///拉取宠物 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PullPet,onSendSocketEvent);
			///宠物移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_PetMoving,onSendSocketEvent);
			////人物复活请求
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_RoleRevive,onSendSocketEvent);
			///切换场景
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_ChangeMapScence,onSendSocketEvent);
			///请求打坐
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_Sit,onSendSocketEvent);
			///请求离开打坐
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_OutSit,onSendSocketEvent);
			//	通知服务端拾取物物品
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_GetDropGoods,onSendSocketEvent);
			///玩家瞬移到某个地方
			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_SKipToPoint,onSendSocketEvent);
			///主角停止移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.C_HeroStopMove,onSendSocketEvent);

			

			
		////s ------------ socket返回 
			//玩家成功登陆进入游戏  
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSocketEvent);
			///人物 切换场景 进入新场景
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_HeroEnterMap,onSocketEvent);
			///其他角色玩家进入 可视范围
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleEnterView,onSocketEvent);
			///其他角色列表 进入可视范围 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleListEnterView,onSocketEvent);
			///  物品掉落 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_DropGoodsEnterView,onSocketEvent);

			//其他角色离开主角视野
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleExitView,onSocketEvent);
			///其他 角色列表离开主角视野
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleListExitView,onSocketEvent);

			//其他角色开始进行移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_OtherRoleBeginMovePath,onSocketEvent);
				///其他角色正在进行移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_otherRoleMoving,onSocketEvent);
			
			///玩家离线
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_AnimatorExitScence,onSocketEvent);
			////怪物死亡离开场景
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterExitScence,onSocketEvent);
			///人物死亡
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_RoleDead,onSocketEvent);
			///人物复活
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_RoleRevive,onSocketEvent);
			
			///玩家切换坐骑状态   上坐骑
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_Mounting,onSocketEvent);
			///下坐骑
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_DisMounting,onSocketEvent);

			///服务端返回战斗数据
			///群攻 鼠标点信息
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightMore,onSocketEvent);
			///群攻 有鼠标点信息
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightMore_Pt,onSocketEvent);
			///单一攻击
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FightSingle,onSocketEvent);

			////移形换影   瞬移 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_BlinkMove,onSocketEvent);
			///其他屏幕进行坐标校验拉取处理 滑动推拉校验 
		//	YFEventCenter.Instance.addEventListener(MapScenceEvent.S_BackSlideMove,onSocketEvent);
			
			///怪物开始移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterBeginMove,onSocketEvent);
			/// 怪物处于移动中
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterMoving,onSocketEvent);
			
			///怪物进入主角可视范围
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterEnterView,onSocketEvent);
			///怪物出生
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterBirth,onSocketEvent);
			
			///怪物离开主角可视范围
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterExitView,onSocketEvent);
			///怪物停止移动
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterStopMove,onSocketEvent);
			/////////////////////怪物ai -----------------------------------
			///怪物设置目标
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterSetTarget,onSocketEvent);
			///怪物解除目标
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterFreeTarget,onSocketEvent);
			///怪物向玩家靠近
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterNearToPlayer,onSocketEvent);
			//怪物对人物发起攻击
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_MonsterHitPlayer,onSocketEvent);

			////宠物 
			////宠物进入视野
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetEnterView,onSocketEvent);
			/**宠物离开玩家视野
			 */ 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetExitView,onSocketEvent);
			///宠物出战
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetPlay,onSocketEvent);
			//服务端返回拉取宠物的结果
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PullPet,onSocketEvent);
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetMoving,onSocketEvent);
			///宠物向目标玩家靠近 准备发起攻击
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_PetMoveToTarget,onSocketEvent);
			//服务端返回打坐
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_Sit,onSocketEvent);
			//服务端返回离开打坐
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_outSit,onSocketEvent);
			///  拾取物品失败
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FailToGetDropGoods,onSocketEvent);
			/// 跳转
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_SKipToPoint,onSocketEvent);
			///跳转失败
			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_FailSKipToPoint,onSocketEvent);
			///服务端返回主角停止移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.S_HeroStopMove,onSocketEvent);

			
		}
		
		/** 发送socket 消息
		 */ 
		private function onSendSocketEvent(e:YFEvent):void
		{
		//	var msg:Message=PoolCenter.Instance.getFromPool(Message) as Message;//new Message();
			switch(e.type)
			{
				///主角进行移动消息发送
//				case MapScenceEvent.C_HeroBeginMovePath:
//					var  playerBeginMoveVo:PlayerBeginMoveVo=e.param as PlayerBeginMoveVo;
//					YFSocket.Instance.sendMessage(CMDMapScence.C_HeroBeginMovePath,playerBeginMoveVo);
//					///对象回收
//					playerBeginMoveVo.disposeToPool();
//					break;
				///角色处在移动当中
				case MapScenceEvent.C_HeroMoving:
					var  playerMoveVo:PlayerMoveVo=e.param as PlayerMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_HeroMoving,playerMoveVo);
					playerMoveVo.disposeToPool();
					break;
				case MapScenceEvent.C_Mounting:
					var heroMountChange:MountChangeVo=e.param as MountChangeVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_Mounting,heroMountChange);
					break;
				case MapScenceEvent.C_DisMounting:
					var heroMountOut:MountChangeVo=e.param as MountChangeVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_DisMounting,heroMountOut);
					break;
				case MapScenceEvent.C_MonsterMoving:
				///怪物处在移动当中   
					var monsterMoveVo:MonsterMoveVo=e.param as MonsterMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterMoving,monsterMoveVo);
					monsterMoveVo.disposeToPool();
					break;
				case MapScenceEvent.C_MonsterBeginMove:
					////通知服务端怪物开始移动
					var monsterBeginMove:MonsterMoveVo=e.param as MonsterMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterBeginMove,monsterBeginMove);
					monsterBeginMove.disposeToPool();
					break;
				case MapScenceEvent.C_MonsterStopMove:
					///怪物停止移动
					var monsterStopMoveVo:MonsterStopMoveVo=e.param as MonsterStopMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_MonsterStopMove,monsterStopMoveVo);
					break;
				////战斗
				case MapScenceEvent.C_FightMore:
					///开始战斗  ///群攻  不带坐标点
					var fightMoreVo:FightMoreVo=e.param as FightMoreVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_FightMore,fightMoreVo);
					fightMoreVo.disposeToPool();
					break;
				case MapScenceEvent.C_FightMore_Pt:
					////群攻 带坐标点
					var fightMorePtVo:FightMorePtVo=e.param as FightMorePtVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_FightMorePt,fightMorePtVo);
					fightMorePtVo.disposeToPool();
					break;
				case MapScenceEvent.C_FightSingle:
					/// 单一 简单攻击
					var fightSingle:FightSingleVo=e.param as FightSingleVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_FightSingle,fightSingle);
					fightSingle.disposeToPool();
					break;
				case MapScenceEvent.C_BlinkMove:
					///主角瞬移
					var blinkMoveVo:BlinkMoveVo=e.param as BlinkMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_BlinkMove,blinkMoveVo);
					break;
				case MapScenceEvent.C_BackSlideMove:
					/// 推开 或者拉取 角色时 的通讯  瞬间改变 该角色在服务端的位置     该通迅并不需要返回  只是改变 拉取 推离角色在服务端的位置
					var backSlideMoveVo:BackSlideMoveVo=e.param as BackSlideMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_BackSlideMove,backSlideMoveVo);
					break;
				case MapScenceEvent.C_PullPet:
					///拉取寵物
					var pullPetVo:PullPetVo=e.param as PullPetVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_PullPet,pullPetVo);
					break;
				case MapScenceEvent.C_PetMoving:
					///宠物发生移动
					var petMoveVo:PetMoveVo=e.param as PetMoveVo;
					YFSocket.Instance.sendMessage(CMDMapScence.C_PetMoving,petMoveVo);
					petMoveVo.disposeToPool();
					break;
				case MapScenceEvent.C_RoleRevive:
					///人物复活请求
					YFSocket.Instance.sendMessage(CMDMapScence.C_RoleRevive);
					break;
				case MapScenceEvent.C_ChangeMapScence:
					///切换场景
					YFSocket.Instance.sendMessage(CMDMapScence.C_ChangeMapScence);
					break;
				case MapScenceEvent.C_Sit:
					//请求打坐
					YFSocket.Instance.sendMessage(CMDMapScence.C_Sit);
					break;
				case MapScenceEvent.C_OutSit:
					//请求离开打坐
					YFSocket.Instance.sendMessage(CMDMapScence.C_OutSit);
					break;
				case MapScenceEvent.C_GetDropGoods:
					//拾取物品
					var dropGoodsObj:Object=e.param;//  {id:dyId}
					YFSocket.Instance.sendMessage(CMDMapScence.C_GetDropGoods,dropGoodsObj);
					break;
				case MapScenceEvent.C_SKipToPoint:
					///跳转到目标点
					var skipPoint:Point=e.param as Point;
					YFSocket.Instance.sendMessage(CMDMapScence.C_SKipToPoint,skipPoint);
					break;
//				case MapScenceEvent.C_HeroStopMove:
//					///主角停止移动
//					YFSocket.Instance.sendMessage(CMDMapScence.C_HeroStopMove);
//					break;
			}
			
		}
		

		/**  成功登陆 初始化角色  socket 返回结果
		 */		
		private function onSocketEvent(e:YFEvent):void
		{
			var roledyVo:RoleDyVo;
			var otherRoleEnterMapVo:OtherRoleInfoVo;///其他角色进入可视范围
			
		//	var monsterBasicVo:MonsterBasicVo;///怪物基本属性
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onSocketEvent);
					///成功登陆后返回
					///创建角色
					var loginVo:LoginVo=e.param as LoginVo;
					roledyVo=new RoleDyVo();
			//		roledyVo.mountDyId=1131000;//坐骑id 
					roledyVo.state=TypeRole.State_Normal;
					roledyVo.bigCatergory=TypeRole.BigCategory_Player;
					roledyVo.dyId=loginVo.dyId;
					roledyVo.roleName=loginVo.name;
					roledyVo.sex=loginVo.sex;
					DataCenter.Instance.roleSelfVo.hp=loginVo.hp;
					DataCenter.Instance.roleSelfVo.maxHp=loginVo.maxHp;
					DataCenter.Instance.roleSelfVo.exp=loginVo.exp;
					DataCenter.Instance.roleSelfVo.maxExp=loginVo.maxExp;
					DataCenter.Instance.roleSelfVo.roleDyVo=roledyVo; ///设置数据
					DataCenter.Instance.roleSelfVo.level=loginVo.level;
					///创建主角色
					_mapScenceView._senceRolesView.createHero();
					
					RoleDyManager.Instance.addRole(roledyVo);
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,DataCenter.Instance.roleSelfVo.getHpPercent());
					_mapScenceView._senceRolesView.updateCloth(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,loginVo.clothBasicId);
					if(loginVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(DataCenter.Instance.roleSelfVo.roleDyVo.dyId,loginVo.weaponBasicId);
					
					///调试
					DebugPane.Instance;
					break;
				case MapScenceEvent.S_HeroEnterMap: ///主角进入新场景
					///主角  进入新场景
					var heroEnterMapVo:HeroEnterMapVo=e.param as HeroEnterMapVo;
					///进入场景 
					var bgMapVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(heroEnterMapVo.mapId);
					DataCenter.Instance.mapSceneBasicVo=bgMapVo;
					RoleDyManager.Instance.updateMapChange();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MapChange); ///smallMap模块进行侦听
					///主场景更新
					_mapScenceView.updateMapSenceView(heroEnterMapVo.mapX,heroEnterMapVo.mapY);
					break;
				case MapScenceEvent.S_OtherRoleEnterView:
					///其他角色进入场景触发
					otherRoleEnterMapVo=e.param as OtherRoleInfoVo;
					roledyVo=new RoleDyVo();
					roledyVo.state=otherRoleEnterMapVo.state;
					roledyVo.bigCatergory=TypeRole.BigCategory_Player
					roledyVo.mapX=otherRoleEnterMapVo.mapX;
					roledyVo.mapY=otherRoleEnterMapVo.mapY;
					roledyVo.dyId=otherRoleEnterMapVo.roleId
					roledyVo.roleName=otherRoleEnterMapVo.name;
					_mapScenceView._senceRolesView.addRole(roledyVo);
					RoleDyManager.Instance.addRole(roledyVo);
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,otherRoleEnterMapVo.hpPercent);
					if(otherRoleEnterMapVo.state==TypeRole.State_Normal)  ///正常状态下
					{
						_mapScenceView._senceRolesView.updateCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
					}
					else if(otherRoleEnterMapVo.state==TypeRole.State_Mount) ///坐骑状态下
					{
						_mapScenceView._senceRolesView.updateMountCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
					}
					else if(otherRoleEnterMapVo.state==TypeRole.State_Sit) ///打坐状态下
					{
						_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
						if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
					}
					///回收对象
					otherRoleEnterMapVo.disposeToPool();
					print(this,"其他角色进入可视范围...."+roledyVo.dyId,roledyVo.mapX+"may:"+roledyVo.mapX);
					break;
				case MapScenceEvent.S_OtherRoleListEnterView:
					//其他角色列表进入可视范围
					var addotherRoleList:AddOtherRoleListVo=e.param as AddOtherRoleListVo;
					
					for each (otherRoleEnterMapVo in addotherRoleList.otherRoleList)
					{
						roledyVo=new RoleDyVo();
						roledyVo.state=otherRoleEnterMapVo.state;
						roledyVo.bigCatergory=otherRoleEnterMapVo.playerType;
						roledyVo.mapX=otherRoleEnterMapVo.mapX;
						roledyVo.mapY=otherRoleEnterMapVo.mapY;
						roledyVo.dyId=otherRoleEnterMapVo.roleId;
						roledyVo.roleName=otherRoleEnterMapVo.name;
						if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster||roledyVo.bigCatergory==TypeRole.BigCategory_Pet||roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods)
						{///如果为怪物  读取怪物表 设置 怪物的名称
							roledyVo.basicId=otherRoleEnterMapVo.clothBasicId;
						}
						_mapScenceView._senceRolesView.addRole(roledyVo);
						RoleDyManager.Instance.addRole(roledyVo);
						///更新血量
						_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,otherRoleEnterMapVo.hpPercent);

						if(roledyVo.bigCatergory==TypeRole.BigCategory_Player) //玩家对象
						{
							if(otherRoleEnterMapVo.state==TypeRole.State_Normal)  ///正常状态下
							{
								_mapScenceView._senceRolesView.updateCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
							}
							else if(otherRoleEnterMapVo.state==TypeRole.State_Mount) ///坐骑状态下
							{
								_mapScenceView._senceRolesView.updateMountCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateMount(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
							}
							else if(otherRoleEnterMapVo.state==TypeRole.State_Sit) ///打坐状态下
							{
								_mapScenceView._senceRolesView.updateSitCloth(roledyVo.dyId,otherRoleEnterMapVo.clothBasicId);
								if(otherRoleEnterMapVo.weaponBasicId>0)	_mapScenceView._senceRolesView.updateSitWeapon(roledyVo.dyId,otherRoleEnterMapVo.weaponBasicId);
							}
						}
						else if(roledyVo.bigCatergory==TypeRole.BigCategory_Monster)///更新怪物
						{
							_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
						}
						else if(roledyVo.bigCatergory==TypeRole.BigCategory_Pet) ///更新宠物
						{
							_mapScenceView._senceRolesView.updatePetClothSKin(roledyVo.dyId,roledyVo.basicId);
						}
						else if(roledyVo.bigCatergory==TypeRole.BigCategory_GropGoods) ///更新物品掉落
						{
							_mapScenceView._senceRolesView.updateDropGoodsCloth(roledyVo.dyId,roledyVo.basicId);
						}

						///回收 
						otherRoleEnterMapVo.disposeToPool();
					}
					break;
				case MapScenceEvent.S_DropGoodsEnterView:
					///物品掉落进入视野
					var dropGoodsInfoVo:DropGoodsInfoVo=e.param as DropGoodsInfoVo;
					roledyVo=new RoleDyVo();
					roledyVo.bigCatergory=TypeRole.BigCategory_GropGoods;
					roledyVo.mapX=dropGoodsInfoVo.mapX;
					roledyVo.mapY=dropGoodsInfoVo.mapY;
					roledyVo.dyId=dropGoodsInfoVo.roleId;
					roledyVo.roleName=dropGoodsInfoVo.name;
					roledyVo.basicId=dropGoodsInfoVo.clothBasicId;
					RoleDyManager.Instance.addRole(roledyVo);
					_mapScenceView._senceRolesView.addRole(roledyVo);
					_mapScenceView._senceRolesView.updateDropGoodsCloth(roledyVo.dyId,dropGoodsInfoVo.clothBasicId);
					break;
//				case MapScenceEvent.S_OtherRoleBeginMovePath:
//					///其他角色开始进行移动    其他屏幕角色开始移动
//					var playerBeginMoveVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
//					_mapScenceView.updatePlayerMovePath(playerBeginMoveVo,false,true);
//					playerBeginMoveVo.disposeToPool();
//					break;
				case MapScenceEvent.S_otherRoleMoving:
					//其他角色正在进行移动
					var playerMovingVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
					_mapScenceView.updatePlayerMovePath(playerMovingVo,true,true);
					playerMovingVo.disposeToPool();
					break;
				
				
				case MapScenceEvent.S_OtherRoleExitView:
					//其他角色离开主角视野
					var removeOtherRoleVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
					RoleDyManager.Instance.delRole(removeOtherRoleVo.roleId);
					_mapScenceView._senceRolesView.delRole(removeOtherRoleVo.roleId);
					print(this,"其他角色离开可视范围..."+removeOtherRoleVo.roleId);
					removeOtherRoleVo.disposeToPool();
					break;
				case MapScenceEvent.S_OtherRoleListExitView:
					///其他角色列表离开主角视野
					var removeOtherRoleList:RemoveRoleListVo=e.param as RemoveRoleListVo;
					for each (var removeOtherRole:RemoveOtherRoleVo in removeOtherRoleList.otherRoleList)
					{
						RoleDyManager.Instance.delRole(removeOtherRole.roleId);
						_mapScenceView._senceRolesView.delRole(removeOtherRole.roleId);
						removeOtherRole.disposeToPool();
					}
					
					break;
				case MapScenceEvent.S_AnimatorExitScence:
					///玩家离线
					var exitRoleId:String=String(e.param);
					RoleDyManager.Instance.delRole(exitRoleId);
					_mapScenceView._senceRolesView.delRole(exitRoleId);
			//		print(this,"用户"+exitRoleId+"离线");
					break;
				///怪物死亡
				case MapScenceEvent.S_MonsterExitScence:
				//	print(this,"怪物死亡");
					var monsterDeadVo:MonsterDeadVo=e.param as MonsterDeadVo;
					RoleDyManager.Instance.delRole(monsterDeadVo.deadId);
					_mapScenceView.updateMonsterDead(monsterDeadVo);
					break;
				///人物死亡
				case MapScenceEvent.S_RoleDead:
				//	print(this,"人物死亡");
			//		var _time:Number=getTimer();
					var roleDead:String=String(e.param);
					_mapScenceView.updateRoleDead(roleDead);
			//		print(this,"时间:dead::",getTimer()-_time,"fps:",Stats.Instance.getFps());
					break;
				
				case MapScenceEvent.S_RoleRevive:
					///人物复活
					var roleRevive:RoleReviveVo=e.param as RoleReviveVo;
					_mapScenceView._senceRolesView.updateReviveRole(roleRevive)
					break;				
				case MapScenceEvent.S_Mounting:
					///玩家切换坐骑状态   上坐骑
					var mountChangeVo:MountChangeResultVo=e.param as MountChangeResultVo;
					_mapScenceView.updateMountChange(mountChangeVo,TypeRole.State_Mount);
					break;
				case MapScenceEvent.S_DisMounting:
					///玩家切换坐骑状态  下坐骑
					var disMounting:MountChangeResultVo=e.param as MountChangeResultVo;
					_mapScenceView.updateMountChange(disMounting,TypeRole.State_Normal);
					break;
				case MapScenceEvent.S_MonsterBeginMove:
					///怪物开始移动
					var monsterbeginMoveVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
					_mapScenceView.updatePlayerMovePath(monsterbeginMoveVo,false,false);					
					monsterbeginMoveVo.disposeToPool();
					break;
				case MapScenceEvent.S_MonsterMoving:
					//怪物处在移动中
					var monsterMovingVo:PlayerMoveResultVo=e.param as PlayerMoveResultVo;
					_mapScenceView.updatePlayerMovePath(monsterMovingVo,true,true);	
					monsterMovingVo.disposeToPool();
					break;
				
				case MapScenceEvent.S_MonsterEnterView:
					///怪物进入玩家可视范围	
					var monsterInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
					roledyVo=new RoleDyVo();
					roledyVo.bigCatergory=TypeRole.BigCategory_Monster;
					roledyVo.mapX=monsterInfoVo.mapX;
					roledyVo.mapY=monsterInfoVo.mapY;
					roledyVo.dyId=monsterInfoVo.roleId;
					roledyVo.basicId=monsterInfoVo.clothBasicId;
					roledyVo.roleName=monsterInfoVo.name;
					_mapScenceView._senceRolesView.addRole(roledyVo);
					RoleDyManager.Instance.addRole(roledyVo);
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,monsterInfoVo.hpPercent);
					_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
					monsterInfoVo.disposeToPool();
					break;
				case MapScenceEvent.S_MonsterBirth:
					///怪物出生
					var monsterBirthInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
					roledyVo=new RoleDyVo();
					roledyVo.bigCatergory=TypeRole.BigCategory_Monster;
					roledyVo.mapX=monsterBirthInfoVo.mapX;
					roledyVo.mapY=monsterBirthInfoVo.mapY;
					roledyVo.dyId=monsterBirthInfoVo.roleId;
					roledyVo.basicId=monsterBirthInfoVo.clothBasicId;
					roledyVo.roleName=monsterBirthInfoVo.name;
					_mapScenceView._senceRolesView.addRole(roledyVo,true);
					RoleDyManager.Instance.addRole(roledyVo);
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,monsterBirthInfoVo.hpPercent);
					_mapScenceView._senceRolesView.updateMonsterClothSKin(roledyVo.dyId,roledyVo.basicId);
					monsterBirthInfoVo.disposeToPool();

					break;
				case MapScenceEvent.S_MonsterExitView:
					///怪物离开玩家可视范围
					var removeMonsterVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
					RoleDyManager.Instance.delRole(removeMonsterVo.roleId);
					_mapScenceView._senceRolesView.delRole(removeMonsterVo.roleId);
					removeMonsterVo.disposeToPool();
					break;
				case MapScenceEvent.S_FightMore:
					///服务端返回战斗信息    指的是人物发起的战斗
					var fightMoreResultVo:FightMoreResultVo=e.param as FightMoreResultVo; ////函数内部释放
					///播放cd動畫  當為自己時  播放cd動畫
					if(fightMoreResultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightMoreResultVo.skillId);
					}
					_mapScenceView.updateFightMore(fightMoreResultVo);
					break;
				case MapScenceEvent.S_FightMore_Pt:
					///服务端返回战斗信息    指的是人物发起的战斗  具有目标点
					var fightMorePtRessultVo:FightMorePtResultVo=e.param as FightMorePtResultVo; ////函数内部释放
					///播放cd動畫  當為自己時  播放cd動畫
					if(fightMorePtRessultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightMorePtRessultVo.skillId);
					}
					_mapScenceView.updateFightMorePt(fightMorePtRessultVo);
					break;
				case MapScenceEvent.S_FightSingle:
					///服务端返回战斗信息    指的是人物发起的战斗  简单战斗 
					var fightSingleResultVo:FightSingleResultVo=e.param as FightSingleResultVo; ////函数内部释放
					///播放cd動畫  當為自己時  播放cd動畫
					if(fightSingleResultVo.atkId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,fightSingleResultVo.skillId);
					}
					_mapScenceView.updateFightSingle(fightSingleResultVo);
					break;
				case MapScenceEvent.S_BlinkMove:
					///移形换影  瞬移
					var blinkMoveResultVo:BlinkMoveResultVo=e.param as BlinkMoveResultVo;
					_mapScenceView.updateBlinkMove(blinkMoveResultVo);
					break;
//				case MapScenceEvent.S_BackSlideMove:
//					///滑动推拉效果处理  对其他屏幕玩家 进行坐标校验处理
//					var moveSlideMoveVo:BackSlideMoveVo=e.param as BackSlideMoveVo;
//					break;
				case MapScenceEvent.S_MonsterHitPlayer:
					//怪物发起的攻击  更新战斗
					var monsterFightResultVo:FightMoreResultVo=e.param as FightMoreResultVo; ////函数内部释放 
					_mapScenceView.updateMonsterFight(monsterFightResultVo);
					break;
				case MapScenceEvent.S_MonsterStopMove:
					//怪物停止移动
					var monsterStopMoveResultVo:MonsterStopMoveResultVo=e.param as MonsterStopMoveResultVo;
					_mapScenceView._senceRolesView.updateMonsterStopMove(monsterStopMoveResultVo);
					monsterStopMoveResultVo.disposeToPool();
					break;//
				
				
				/////////////// 怪物ai--------------------
				case MapScenceEvent.S_MonsterSetTarget:
					///设置怪物目标
					var setTargetDyId:String=String(e.param);
					_mapScenceView._senceRolesView.setMonsterTarget(setTargetDyId);
					break;
				case MapScenceEvent.S_MonsterFreeTarget:
					///解除怪物目标
					var freeTargetDyId:String=String(e.param);
					_mapScenceView._senceRolesView.freeMonsterTarget(freeTargetDyId);
					break;
				case MapScenceEvent.S_MonsterNearToPlayer:
					///怪物向目标玩家靠近
					var monsterNearToPlayer:MonsterWalkVo=e.param as MonsterWalkVo;
					_mapScenceView.updateMonsterMoveToPoint(monsterNearToPlayer);
					monsterNearToPlayer.disposeToPool();
					break;
				
				////////////////////宠物 。。。。---------------------------------------------------------------
				case MapScenceEvent.S_PetEnterView:
					///宠物进入视野
					var petInfoVo :OtherRoleInfoVo=e.param as OtherRoleInfoVo;
					roledyVo=new RoleDyVo();
					roledyVo.bigCatergory=TypeRole.BigCategory_Pet;
					roledyVo.mapX=petInfoVo.mapX;
					roledyVo.mapY=petInfoVo.mapY;
					roledyVo.dyId=petInfoVo.roleId;
					roledyVo.roleName=petInfoVo.name;
					roledyVo.basicId=petInfoVo.clothBasicId; ///获取怪物静态id 
					_mapScenceView._senceRolesView.addRole(roledyVo);
					RoleDyManager.Instance.addRole(roledyVo);
					///更新血量
					_mapScenceView._senceRolesView.updateHp(roledyVo.dyId,petInfoVo.hpPercent);

					_mapScenceView._senceRolesView.updatePetClothSKin(roledyVo.dyId,roledyVo.basicId);
					petInfoVo.disposeToPool();
					break;
				case MapScenceEvent.S_PetExitView:
					var removePetVo:RemoveOtherRoleVo=e.param as RemoveOtherRoleVo;
					RoleDyManager.Instance.delRole(removePetVo.roleId);
					_mapScenceView._senceRolesView.delRole(removePetVo.roleId);
					removePetVo.disposeToPool();
					break;
				case GlobalEvent.PetPlay:
					///  宠物出战
					var petResultVo:PetPlayResultVo=e.param as PetPlayResultVo;
					_mapScenceView.updatePetPlay(petResultVo);
					break;
				case MapScenceEvent.S_PullPet:
					///服务端返回拉取宠物的结果
					var pullPetVo:PullPetVo=e.param as PullPetVo;
					_mapScenceView.updatePullPet(pullPetVo);
					break;
				case MapScenceEvent.S_PetMoving:
					//宠物发生移动
					var petMovingVo:PetMoveResultVo=e.param as PetMoveResultVo;
					_mapScenceView.updatePetMovePath(petMovingVo);	
					petMovingVo.disposeToPool();
					break;
				case MapScenceEvent.S_PetMoveToTarget:
					//宠物向目标玩家靠近 准备发起攻击
					var petMoveToTargetResultVo:PetMoveToTargetResultVo=e.param as PetMoveToTargetResultVo;
					_mapScenceView.updatePetMoveToTarget(petMoveToTargetResultVo.petId,petMoveToTargetResultVo.tId);
					break;
				case MapScenceEvent.S_Sit:
					///服务端返回打坐
					var sitChangeVo:SitChangeVo=e.param as SitChangeVo;
					_mapScenceView._senceRolesView.updateSitCloth(sitChangeVo.dyId,sitChangeVo.clothBasicId);
					_mapScenceView._senceRolesView.updateSitWeapon(sitChangeVo.dyId,sitChangeVo.weaponBasicId);				
					print(this,"服务端返回打坐");
					break;
				case MapScenceEvent.S_outSit:
					//服务端返回取消打坐
					var outSitChangeVo:SitChangeVo=e.param as SitChangeVo
					_mapScenceView._senceRolesView.updateCloth(outSitChangeVo.dyId,outSitChangeVo.clothBasicId);
					_mapScenceView._senceRolesView.updateWeapon(outSitChangeVo.dyId,outSitChangeVo.weaponBasicId);
					_mapScenceView._senceRolesView.removePlayerFrontEffect(outSitChangeVo.dyId);///移除 玩家特效
					print(this,"服务端返回取消打坐");
					break;
				
				case MapScenceEvent.S_FailToGetDropGoods:
					print(this,"拾取物品失败");
					YFAlert.show("拾取物品失败");
					break;
				case MapScenceEvent.S_SKipToPoint:
					///跳转
					print(this,"进行SKipToPoint");
					var skipToPoint:Point=e.param as Point;
					_mapScenceView.updateSkipToPoint(skipToPoint);
					break;
				case MapScenceEvent.S_FailSKipToPoint:
					YFAlert.show("此地图点不能到达");
					break;
//				case MapScenceEvent.S_HeroStopMove:
//					///主角停止移动
//					var stopMovePlayer:String=String(e.param);
//					_mapScenceView._senceRolesView.updatePlayerStopMove(stopMovePlayer);
//					break;
			}
		}
		
	}
}