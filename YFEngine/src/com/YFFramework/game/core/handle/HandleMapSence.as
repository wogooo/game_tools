package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.PlayerMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.MonsterDeadVo;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.SitChangeVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightSingleResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.AddOtherRoleListVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.CMDMapScence;
	import com.YFFramework.game.core.module.mapScence.model.proto.DropGoodsInfoVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.HeroEnterMapVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterStopMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterWalkVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MountChangeResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.OtherRoleInfoVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveToTargetResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.RemoveOtherRoleVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.RemoveRoleListVo;
	
	import flash.geom.Point;
	
	/**100-199命令
	 * 2012-8-3 上午10:37:32
	 *@author yefeng
	 */
	public class HandleMapSence extends AbsHandle
	{
		public function HandleMapSence()
		{
			super();
			_minCMD=100;
			_maxCMD=199;
		}
		
		override public function socketHandle(data:Object):Boolean
		{
			var info:Object=data.info;
			var otherRoleEnterMapVo:OtherRoleInfoVo;
			var removeOtherRoleVo:RemoveOtherRoleVo;///移出主角视野的 玩家vo
			var playerClientMoveVo:PlayerMoveResultVo;
			
			switch(data.cmd)
			{
				//主角进入场景
				case CMDMapScence.S_HeroEnterMap:
					var heroEnterMapVo:HeroEnterMapVo=new HeroEnterMapVo();
					heroEnterMapVo.mapId=info.mapId;
					heroEnterMapVo.mapX=info.mapX;
					heroEnterMapVo.mapY=info.mapY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_HeroEnterMap,heroEnterMapVo);
					return true;
					break;
				
				///其他角色进行移动
//				case CMDMapScence.S_OtherRoleBeginMove:
//					playerClientMoveVo=PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
//					playerClientMoveVo.id=info.id;
//					playerClientMoveVo.mapX=info.mapX;
//					playerClientMoveVo.mapY=info.mapY;
//					playerClientMoveVo.speed=info.speed;
//					var path:Array=[];
//					for each (var ptObj:Object in info.path )
//						path.push(new Point(ptObj.x,ptObj.y));
//					playerClientMoveVo.path=path;
//					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_OtherRoleBeginMovePath,playerClientMoveVo);
//					return true;
//					break;
				case CMDMapScence.S_OtherRoleMoving:
					///服务端返回其他角色正在进行移动
					playerClientMoveVo=PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
					playerClientMoveVo.id=info.id;
					playerClientMoveVo.mapX=info.mapX;
					playerClientMoveVo.mapY=info.mapY;
					playerClientMoveVo.speed=info.speed;
					var otherRolePath:Array=[];
					var pathPt:Point;
					for each (var pathObj:Object in info.path)
					{
						pathPt=new Point(pathObj.x,pathObj.y);
						otherRolePath.push(pathPt);
					}

					playerClientMoveVo.path=otherRolePath;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_otherRoleMoving,playerClientMoveVo);
					return true;
					break;
				///其他角色进入场景
				case CMDMapScence.S_OtherRoleEnterView:
					otherRoleEnterMapVo =PoolCenter.Instance.getFromPool(OtherRoleInfoVo) as OtherRoleInfoVo;
					otherRoleEnterMapVo.roleId=info.roleId;
					otherRoleEnterMapVo.mapX=info.mapX;
					otherRoleEnterMapVo.mapY=info.mapY;
					otherRoleEnterMapVo.name=info.name;
					otherRoleEnterMapVo.clothBasicId=info.clothBasicId;
					otherRoleEnterMapVo.weaponBasicId=info.weaponBasicId; 
					otherRoleEnterMapVo.hpPercent=info.hpPercent;
					otherRoleEnterMapVo.state=info.state;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_OtherRoleEnterView,otherRoleEnterMapVo);
					return true;
					break;
				///其他角色列表进入可视范围
				case CMDMapScence.S_OtherRoleListEnterView:
					var  otherRoleInfoVo:OtherRoleInfoVo;
					var addOtherRoleList:AddOtherRoleListVo=new AddOtherRoleListVo();
					var addOtherRoleListArr:Array=[];
					for each(var otherRoleInfoObj:Object in info.otherRoleList)
					{
						otherRoleInfoVo=PoolCenter.Instance.getFromPool(OtherRoleInfoVo) as OtherRoleInfoVo;
						otherRoleInfoVo.mapX=otherRoleInfoObj.mapX;
						otherRoleInfoVo.mapY=otherRoleInfoObj.mapY;
						otherRoleInfoVo.name=otherRoleInfoObj.name;
						otherRoleInfoVo.roleId=otherRoleInfoObj.roleId;
						otherRoleInfoVo.clothBasicId=otherRoleInfoObj.clothBasicId;
						otherRoleInfoVo.weaponBasicId=otherRoleInfoObj.weaponBasicId;
						otherRoleInfoVo.playerType=otherRoleInfoObj.playerType;
						otherRoleInfoVo.hpPercent=otherRoleInfoObj.hpPercent;
						otherRoleInfoVo.state=otherRoleInfoObj.state;
						addOtherRoleListArr.push(otherRoleInfoVo);
					}
					addOtherRoleList.otherRoleList=addOtherRoleListArr;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_OtherRoleListEnterView,addOtherRoleList);
					return true;
					break;
				case CMDMapScence.S_OtherRoleExitView:
					//其他角色离开视野
					 var removeRoleId:String=info.roleId;//要移出的的角色  动态id
					 removeOtherRoleVo=PoolCenter.Instance.getFromPool(RemoveOtherRoleVo) as RemoveOtherRoleVo;
					 removeOtherRoleVo.roleId=removeRoleId;
					 YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_OtherRoleExitView,removeOtherRoleVo);
					return true;
					break;
				case CMDMapScence.S_OtherRoleListExitView:
					///其他角色列表离开视野
					var removeListArr:Array=[];
					var removeOtherRoleList:RemoveRoleListVo=new RemoveRoleListVo();
					for each(var removeRoleObj:Object in info.otherRoleList)
					{
						removeOtherRoleVo=PoolCenter.Instance.getFromPool(RemoveOtherRoleVo) as RemoveOtherRoleVo;
						removeOtherRoleVo.roleId=removeRoleObj.roleId;
						removeListArr.push(removeOtherRoleVo);
					}
					removeOtherRoleList.otherRoleList=removeListArr;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_OtherRoleListExitView,removeOtherRoleList);
					return true;
					break;
				case CMDMapScence.S_AnimatorExitScence:
					//角色玩家离线 或者怪物死完  或者宠物收回 
					var exitRoleId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_AnimatorExitScence,exitRoleId);
					return true;
					break;
				
				case CMDMapScence.S_Mounting:
					///玩家切换坐骑
					var mountChangeVo:MountChangeResultVo=new MountChangeResultVo();
					mountChangeVo.dyId=info.dyId;
					mountChangeVo.clothBasicId=info.clothBasicId;
					mountChangeVo.weaponBasicId=info.weaponBasicId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_Mounting,mountChangeVo);
					return true;
					break;
				case CMDMapScence.S_DisMounting:
					///玩家切换坐骑
					var disMount:MountChangeResultVo=new MountChangeResultVo();
					disMount.dyId=info.dyId;
					disMount.clothBasicId=info.clothBasicId;
					disMount.weaponBasicId=info.weaponBasicId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_DisMounting,disMount);
					return true;
					break;
				case CMDMapScence.S_MonsterBeginMove:
					///怪物开始移动
					var monsterbeginMoveVo:PlayerMoveResultVo =PoolCenter.Instance.getFromPool(PlayerMoveResultVo,null) as PlayerMoveResultVo;
					monsterbeginMoveVo.id=info.id;
					monsterbeginMoveVo.mapX=info.mapX;
					monsterbeginMoveVo.mapY=info.mapY;
					var monsterbeginMovePath:Array=[];
					for each (var monsterPt:Object in info.path )
						monsterbeginMovePath.push(new Point(monsterPt.x,monsterPt.y));
					monsterbeginMoveVo.path=monsterbeginMovePath;
					monsterbeginMoveVo.speed=info.speed;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterBeginMove,monsterbeginMoveVo);
					return true;
					break;
				case CMDMapScence.S_MonsterMoving:
					//怪物处于移动当中
					var monsterMovingVo:PlayerMoveResultVo =PoolCenter.Instance.getFromPool(PlayerMoveResultVo,null) as PlayerMoveResultVo;
					monsterMovingVo.id=info.id;
					monsterMovingVo.mapX=info.mapX;
					monsterMovingVo.mapY=info.mapY;
					var monsterMovingPath:Array=[];
					for each (var monsterMovingPt:Object in info.path )
					{
						monsterMovingPath.push(new Point(monsterMovingPt.x,monsterMovingPt.y));
					}
					monsterMovingVo.path=monsterMovingPath;//monsterMovingPath;
					monsterMovingVo.speed=info.speed;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterMoving,monsterMovingVo);
					return true;
					break;
				case CMDMapScence.S_MonsterEnterView:
					//怪物进入视野
					var monsterInfoVo :OtherRoleInfoVo=PoolCenter.Instance.getFromPool(OtherRoleInfoVo,null) as OtherRoleInfoVo;
					monsterInfoVo.roleId=info.roleId;
					monsterInfoVo.name=info.name;
					monsterInfoVo.mapX=info.mapX;
					monsterInfoVo.mapY=info.mapY;
					monsterInfoVo.hpPercent=info.hpPercent;
					monsterInfoVo.clothBasicId=info.clothBasicId;
					print(this,"添加怪物："+monsterInfoVo.roleId);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterEnterView,monsterInfoVo);
					return true;
					break;
				case CMDMapScence.S_MonsterBirth:
					//怪物进入视野
					var monsterBirthInfoVo :OtherRoleInfoVo=PoolCenter.Instance.getFromPool(OtherRoleInfoVo,null) as OtherRoleInfoVo;
					monsterBirthInfoVo.roleId=info.roleId;
					monsterBirthInfoVo.name=info.name;
					monsterBirthInfoVo.mapX=info.mapX;
					monsterBirthInfoVo.mapY=info.mapY;
					monsterBirthInfoVo.hpPercent=info.hpPercent;
					monsterBirthInfoVo.clothBasicId=info.clothBasicId;
					print(this,"怪物出生，添加怪物："+monsterBirthInfoVo.roleId);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterBirth,monsterBirthInfoVo);
					return true;
					break;

				
				case CMDMapScence.S_MonsterExitView:
					///怪物离开视野
					var removeMonsterVo:RemoveOtherRoleVo=PoolCenter.Instance.getFromPool(RemoveOtherRoleVo,null) as RemoveOtherRoleVo;
					removeMonsterVo.roleId=info.roleId;
					print(this,"删除怪物"+removeMonsterVo.roleId);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterExitView,removeMonsterVo);
					return true;
					break;
				case CMDMapScence.S_MonsterStopMove:
					///怪物停止移动
					var monsterStopMoveResultVo:MonsterStopMoveResultVo=PoolCenter.Instance.getFromPool(MonsterStopMoveResultVo,null) as MonsterStopMoveResultVo;
					monsterStopMoveResultVo.dyId=info.dyId;
					monsterStopMoveResultVo.mapX=info.mapX;
					monsterStopMoveResultVo.mapY=info.mapY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterStopMove,monsterStopMoveResultVo);
			//		print(this,"怪物停止移动。。。。");
				//	DebugPane.Instance.log("handle:怪物停止移动。。。。");
					return true;
					break;
				
				////  怪物ai 逻辑----------------------------------------------------
				
				case CMDMapScence.S_MonsterSetTarget:
					//怪物设置目标对象	
					var monserTargetDyId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterSetTarget,monserTargetDyId)
					return true;
					break;
				case CMDMapScence.S_MonsterFreeTarget:
					//怪物解除目标对象	
					var monserFreeTargetDyId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterFreeTarget,monserFreeTargetDyId)
					return true;
					break;
				case CMDMapScence.S_MonsterNearToPlayer:
					//  怪物向玩家靠近
					var monsterNearToPlayer:MonsterWalkVo=PoolCenter.Instance.getFromPool(MonsterWalkVo,null) as MonsterWalkVo;
					monsterNearToPlayer.monsterDyId=info.monsterDyId;
					monsterNearToPlayer.x=info.x;
					monsterNearToPlayer.y=info.y;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterNearToPlayer,monsterNearToPlayer);
				//	print(this,"怪物向玩家靠近");
					return true;
					break;
				case CMDMapScence.S_MonsterHitPlayer:
					///怪物攻击玩家
				//	var _myTestTime:Number=getTimer();
			//		print(this,"怪物攻击玩家"+"info.atkId:"+info.atkId+"info.skillId "+info.skillId+" info.uAtkArr "+info.uAtkArr+"info.skillLevel "+info.skillLevel );
					var monsterFightResultVo:FightMoreResultVo=PoolCenter.Instance.getFromPool(FightMoreResultVo,null) as FightMoreResultVo;
					monsterFightResultVo.atkId=info.atkId;
					monsterFightResultVo.skillId=info.skillId;
					monsterFightResultVo.uAtkArr=info.uAtkArr;
					monsterFightResultVo.skillLevel=info.skillLevel;
					if(monsterFightResultVo.atkId!=null)   ////通讯bug  消息过快拿到的数据不完整
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterHitPlayer,monsterFightResultVo);
					else monsterFightResultVo.disposeToPool();
				//	print(this,"monsterFight:time::",getTimer()-_myTestTime,"fps:",Stats.Instance.getFps());
					return true;
					break;
				case CMDMapScence.S_MonsterWalkAround:
					///怪物在该区域巡逻
					var monsterWalkRound:MonsterWalkVo=PoolCenter.Instance.getFromPool(MonsterWalkVo,null) as MonsterWalkVo;
					monsterWalkRound.monsterDyId=info.monsterDyId;
					monsterWalkRound.x=info.x;
					monsterWalkRound.y=info.y;
					///调用   S_MonsterNearToPlayer 接口
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterNearToPlayer,monsterWalkRound);
				//	print(this,"怪物在该区域巡逻");
					return true;
					break;
				case CMDMapScence.S_MonsterMoveBack:
					//   怪物回到出身点
					var monsterMoveBack:MonsterWalkVo=PoolCenter.Instance.getFromPool(MonsterWalkVo,null) as MonsterWalkVo;
					monsterMoveBack.monsterDyId=info.monsterDyId;
					monsterMoveBack.x=info.x;
					monsterMoveBack.y=info.y;
					///调用   S_MonsterNearToPlayer 接口
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterNearToPlayer,monsterMoveBack);
		//			print(this,"怪物回到出身点");
					return true;
					break;
				
				case CMDMapScence.S_FightMore:
					///服务端返回战斗的信息
					var fightResultVo:FightMoreResultVo=PoolCenter.Instance.getFromPool(FightMoreResultVo,null) as FightMoreResultVo;
					fightResultVo.atkId=info.atkId;
					fightResultVo.skillId=info.skillId;
					fightResultVo.skillLevel=info.skillLevel;
					fightResultVo.uAtkArr=info.uAtkArr;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_FightMore,fightResultVo);
					return true;
					break;
				case CMDMapScence.S_FightMorePt:
					///服务端返回战斗的信息
					var fightResultPtVo:FightMorePtResultVo=PoolCenter.Instance.getFromPool(FightMorePtResultVo,null) as FightMorePtResultVo;
					fightResultPtVo.atkId=info.atkId;
					fightResultPtVo.skillId=info.skillId;
					fightResultPtVo.skillLevel=info.skillLevel;
					fightResultPtVo.uAtkArr=info.uAtkArr;
					fightResultPtVo.mapX=info.mapX;
					fightResultPtVo.mapY=info.mapY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_FightMore_Pt,fightResultPtVo);
					return true;
					break;
				case CMDMapScence.S_FightSingle:
					///服务端返回战斗的信息
					var fightSingleVo:FightSingleResultVo=PoolCenter.Instance.getFromPool(FightSingleResultVo,null) as FightSingleResultVo;
					fightSingleVo.atkId=info.atkId;
					fightSingleVo.skillId=info.skillId;
					fightSingleVo.skillLevel=info.skillLevel;
					fightSingleVo.fightHurtVo=info.fightHurtVo
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_FightSingle,fightSingleVo);
					return true;
					break;
				/// 瞬移 移形换影
				case CMDMapScence.S_BlinkMove:
					var blinkMoveResultVo:BlinkMoveResultVo=new BlinkMoveResultVo();
					blinkMoveResultVo.dyId=info.dyId;
					blinkMoveResultVo.mapX=info.mapX;
					blinkMoveResultVo.mapY=info.mapY;
					blinkMoveResultVo.endX=info.endX;
					blinkMoveResultVo.endY=info.endY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_BlinkMove,blinkMoveResultVo);
					return true;
					break;
//				case CMDMapScence.S_BackSlideMove: ///对其他屏幕的玩家进行坐标校验处理
//					var backSlideMove:BackSlideMoveVo=new BackSlideMoveVo(); 
//					backSlideMove.dyId=info.dyId;
//					backSlideMove.mapX=info.mapX;
//					backSlideMove.mapY=info.mapY;
//					backSlideMove.endX=info.endX;
//					backSlideMove.endY=info.endY;
//					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_BackSlideMove,backSlideMove);
//					return true;
//					break;
				//// 宠物
				case CMDMapScence.S_PetEnterView:
					//宠物进入视野
					var petInfoVo :OtherRoleInfoVo=PoolCenter.Instance.getFromPool(OtherRoleInfoVo,null) as OtherRoleInfoVo;
					petInfoVo.roleId=info.roleId;
					petInfoVo.name=info.name;
					petInfoVo.mapX=info.mapX;
					petInfoVo.mapY=info.mapY;
					petInfoVo.hpPercent=info.hpPercent;
					petInfoVo.clothBasicId=info.clothBasicId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_PetEnterView,petInfoVo);
					return true;
					break;
				case CMDMapScence.S_PetExitView:
					///宠物离开玩家视野
					var removePetVo:RemoveOtherRoleVo=PoolCenter.Instance.getFromPool(RemoveOtherRoleVo,null) as RemoveOtherRoleVo;
					removePetVo.roleId=info.roleId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_PetExitView,removePetVo);
					return true;
					break;
				case CMDMapScence.S_PullPet:
					///拉取宠物
					var pullPetVo:PullPetVo=new PullPetVo();
					pullPetVo.dyId=info.dyId;
					pullPetVo.mapX=info.mapX;
					pullPetVo.mapY=info.mapY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_PullPet,pullPetVo);
					return true;
					break;
				case CMDMapScence.S_PetMoving:
					///宠物发生移动 
					var petMovingVo:PetMoveResultVo =PoolCenter.Instance.getFromPool(PetMoveResultVo,null) as PetMoveResultVo;
					petMovingVo.id=info.id;
					petMovingVo.mapX=info.mapX;
					petMovingVo.mapY=info.mapY;
					petMovingVo.direction=info.direction;
					var petMovingPath:Array=[];
					for each (var petMovingPt:Object in info.path )
					{
						petMovingPath.push(new Point(petMovingPt.x,petMovingPt.y));
					}
					petMovingVo.path=petMovingPath;//monsterMovingPath;
					petMovingVo.speed=info.speed;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_PetMoving,petMovingVo);
					return true;
					break;
				case CMDMapScence.S_PetMoveToTarget:
					///宠物向目标玩家靠近 准备攻击
					var petMoveToTargetResultVo:PetMoveToTargetResultVo=new PetMoveToTargetResultVo();
					petMoveToTargetResultVo.petId=info.petId;
					petMoveToTargetResultVo.tId=info.tId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_PetMoveToTarget,petMoveToTargetResultVo);
					return true;
					break;
				////怪物死完   怪物死完离开场景
				case CMDMapScence.S_MonsterExitScence:
					var monsterDeadVo:MonsterDeadVo=new MonsterDeadVo();
					monsterDeadVo.atkId=info.atkId;
					monsterDeadVo.deadId=info.deadId;
					monsterDeadVo.skillId=info.skillId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_MonsterExitScence,monsterDeadVo);
					return true;
					break;
				////人物死亡
				case CMDMapScence.S_RoleDead:
				//	var _time:Number=getTimer();
					///人物死完
					var deadRoleDyId:String=String(info);
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_RoleDead,deadRoleDyId);
				//	print(this,"时间role:dead::",getTimer()-_time,"fps:",Stats.Instance.getFps());

					return true;
					break;
				////人物复活
				case CMDMapScence.S_RoleRevive:
					///人物复活
					var roleRevive:RoleReviveVo=new RoleReviveVo();
					roleRevive.dyId=info.dyId;
					roleRevive.hp=info.hp;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_RoleRevive,roleRevive);
					return true;
					break;
				case CMDMapScence.S_Sit:
					//打坐
					var sitChangeVo:SitChangeVo=new SitChangeVo();
					sitChangeVo.dyId=info.dyId;
					sitChangeVo.clothBasicId=info.clothBasicId;
					sitChangeVo.weaponBasicId=info.weaponBasicId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_Sit,sitChangeVo);
					return true;
					break;
				case CMDMapScence.S_outSit:
					//离开打坐状态
					var outSitChangeVo:SitChangeVo=new SitChangeVo();
					outSitChangeVo.dyId=info.dyId;
					outSitChangeVo.clothBasicId=info.clothBasicId;
					outSitChangeVo.weaponBasicId=info.weaponBasicId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_outSit,outSitChangeVo);
					return true;
					break;
				case CMDMapScence.S_DropGoodsEnterView:
					var dropGoodsInfoVo:DropGoodsInfoVo=new DropGoodsInfoVo();
					dropGoodsInfoVo.clothBasicId=info.clothBasicId;
					dropGoodsInfoVo.mapX=info.mapX;
					dropGoodsInfoVo.mapY=info.mapY;
					dropGoodsInfoVo.name=info.name;
					dropGoodsInfoVo.roleId=info.roleId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_DropGoodsEnterView,dropGoodsInfoVo);
					return true;
					break;
				case CMDMapScence.S_FailToGetDropGoods:
					//拾取物品失败
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_FailToGetDropGoods);
					return true;
					break;
				case CMDMapScence.S_SKipToPoint:
					///跳转
					var skipToPoint:Point=new Point();   ///服务端  的 SkipToPointResultVo
					skipToPoint.x=info.mapX;
					skipToPoint.y=info.mapY;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_SKipToPoint,skipToPoint);
					return true;
					break;
				case CMDMapScence.S_FailSKipToPoint:  ///跳转失败 因为该点是障碍点
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_FailSKipToPoint);
					return true;
					break;
				
//				case CMDMapScence.S_HeroStopMove:
//					///主角停止移动
//					var stopMoveId:String=String(info);
//					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.S_HeroStopMove,stopMoveId);
//					return true;
//					break;
			}
			
			return false 	
		}
		

		
	}
}