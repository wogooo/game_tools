package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.PetPlayerView;
	import com.YFFramework.core.world.movie.player.PlayerView;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.UAtkInfo;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	
	import flash.geom.Point;

	/**战斗控制中心    内部包含 所有的 特效播放
	 * 2012-7-5
	 *	@author yefeng
	 * 
	 *   技能类型   
	 *  单一攻击    ：    1   不管有无目标 都可以发出技能动画     2    只有 攻击对象存在 才能特效播放
	 * 
	 * 群攻    A   无点攻击   就是不需要鼠标的坐标点信息的攻击 === 1   可以发出技能  2  不可以发出技能  
	 * 群攻   B   带点 攻击    发送的通讯vo 需要带上坐标信息   这样的技能 是一定可以看到动画效果的  不管有无 攻击对象
 	 */
	public class FightView
	{
		public function FightView()
		{
		}
			
		/**  *更新战斗   这里是直接响应战斗    受击者直接根据数据表播放数据
		 * 
		 * 战斗脚本 
		 * *简单战斗
		 * @param attacker
		 * @param underAttackers
		 * @param fightId
		 * 
		 */
		private function updateFight1(fightUIVo:FightUIPtVo):void
		{
			
			////获取特效数据
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			playRoleAndFloorEffect(fightUIVo,effectBasicVo);
			//天空层特效
			var positionX:Number;
			var positionY:Number;
			
			var atk:PlayerView=fightUIVo.atk;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			var actionData:YF2dActionData;
			if(effectBasicVo.atkSkyId>0)  ///攻击者天空层
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				positionX=atk.roleDyVo.mapX;
				positionY=atk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.atkSkyTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.uAtkSkyId>0)  //受击者天空层
			{
				url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
				//当 为受击者 
				for each (uAtkInfo in fightUIVo.uAtkArr)    ////对所有的受击对象做 动画
				{
					uAtk=uAtkInfo.player;
					positionX=uAtk.roleDyVo.mapX;
					positionY=uAtk.roleDyVo.mapY;
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						LayerManager.SkySKillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.uAtkSkyTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		/**播放人物 和 地面层的效果
		 */ 
		private function playRoleAndFloorEffect(fightUIVo:FightUIPtVo,effectBasicVo:FightEffectBasicVo):void
		{
			atkFight(fightUIVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
			var actionData:YF2dActionData;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state==TypeRole.State_Mount) uAtk.play(TypeAction.Stand,oppsiteDirection);
					else 
					{
						if(uAtkInfo.hp>0) uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
						else 
						{
							uAtk.pureStop();
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
								uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
						}
					}
				}
				else 
				{
					if(uAtkInfo.hp>0)uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
					else 
					{
						uAtk.pureStop();
						if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
						{
							uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
						{
							uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
					}
				}
				//	print(this,"掉落血量"+uAtkInfo.hp);
				if(uAtk.isDead)uAtkInfo.hp=0;
				uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,effectBasicVo.uAtkTimeArr,bloodComplete,uAtk);
				////处理拉取效果
//				handleSlide(atk,uAtk,fightSkillBasicVo);
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtk=uAtkInfo.player;
						uAtk.addBackEffect(actionData,effectBasicVo.uAtkBackTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtk=uAtkInfo.player;
						uAtk.addFrontEffect(actionData,effectBasicVo.uAtkFrontTimeArr,false)
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
			//地面层特效
			var positionX:Number;
			var positionY:Number;
			if(effectBasicVo.atkFloorId>0) ///攻击者地面特效
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				positionX=atk.roleDyVo.mapX;
				positionY=atk.roleDyVo.mapY;
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.atkFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.uAtkFloorId>0)///受击者地面
			{
				url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				 //当 为受击者 
				for each (uAtkInfo in fightUIVo.uAtkArr)    ////对所有的受击对象做 动画
				{
					uAtk=uAtkInfo.player;
					positionX=uAtk.roleDyVo.mapX
					positionY=uAtk.roleDyVo.mapY
					if(SourceCache.Instance.getRes(url))
					{
						LayerManager.BgSkillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		private function completeFunc(data:Object):void
		{
		//	print(this,"攻击动画播放完毕");
			var attacker:PlayerView=data.atk;
			attacker.play(TypeAction.Stand);
			///技能播放完后就要解锁
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==attacker.roleDyVo.dyId)DataCenter.Instance.roleSelfVo.heroState.isLock=false; 
			else if(attacker is PetPlayerView)
			{
				///当为自己的宠物时  进行进行锁释放
				if(PetPlayerView(attacker).isOwnPet())
				{
					PetPlayerView(attacker).isLock=false;
				}
			}

		}
		
		private function bloodComplete(obj:Object):void
		{
			var underAttacker:PlayerView=obj as PlayerView;
			noticeRoleInfoChange(underAttacker);
		}
	
		/**受到攻击
		 */		
		private function uAktInjureComplete(data:Object):void
		{
			var underAttacker:PlayerView=data.uAtk;
			if(underAttacker.isPool==false)
			{
				underAttacker.play(TypeAction.Stand);
			}
		}
		
		private function uAtkDeadComplete(data:Object):void
		{
			var underAttacker:PlayerView=data.uAtk;
//			print(this,"怪物死亡动画播放完成...");
		}
		/**更新血量改变
		 *   玩家死亡 移出视野 用 RoleDyManager  侦听 
		 */		
		private function noticeRoleInfoChange(playerView:PlayerView):void
		{
			if(!playerView.isPool)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,playerView.roleDyVo);
		}
		
		/**玩家角色死亡
		 * 该方法的调用在 buff里面  buff导致玩家死亡调用该方法
		 */		
		public function updatePlayerDead(uAtk:PlayerView):void
		{
			uAtk.pureStop();
			uAtk.playDead();
		}
		/** 播放死亡特效   怪物播放死亡特效
		 */		
		private function playDeadEffect(deadPlayer:PlayerView,beginTime:Number=0):void
		{
			//怪物死亡播放死亡动画
			var actionData:YF2dActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.MonsterDeadEffect) as YF2dActionData;
			if(actionData)	
			{
				if(deadPlayer)
				{
					if(!deadPlayer.isPool)	
					{
						LayerManager.SkySKillLayer.playEffect(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,actionData,[beginTime],false);
						//	deadPlayer.addFrontEffect(actionData,[beginTime],false);
					}
				}
			}
			else SourceCache.Instance.loadRes(CommonEffectURLManager.MonsterDeadEffect);
		}
		/**处理怪物死亡滑动 效果   人物死亡是不进行处理的
		 * beginTime 开始滑动的时间
		 */
		private function handleDeadMoving(deadPlayer:PlayerView,atkPlayer:PlayerView,beginTime:int):void
		{
			
			if(deadPlayer&&atkPlayer)
			{
				deadPlayer.isDead=true;
				if(deadPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
				{
					//播放死亡特效
//					playDeadEffect(deadPlayer,beginTime);
					///人物死亡面朝角色方向
					var deadDirection:int=DirectionUtil.getDirection(atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY,deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY);
					//				if(DataCenter.Instance.roleSelfVo.heroState.willDo==deadPlayer)DataCenter.Instance.roleSelfVo.heroState.willDo=null;
					////做打击感
					var degree:Number=YFMath.getDegree(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY);
					////人物后退  ，进行震屏
					var distance:int=250+Math.random()*100;///人物后退距离
					var endPt:Point=YFMath.getLinePoint3(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,distance,degree);
					endPt=GridData.Instance.getMoveToEndPoint(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,endPt.x,endPt.y);
					var timeOut:TimeOut;
//					print(this,"roleDyVo:",deadPlayer.roleDyVo);
					if(endPt)  
					{	
						//	deadPlayer.pureMoveTo(endPt.x,endPt.y,10);
						timeOut=new TimeOut(beginTime,deadPlayerMove,{deadPlayer:deadPlayer,x:endPt.x,y:endPt.y,speed:35});
						timeOut.start();
					}
					else  ///不能进行滑动
					{
//						timeOut=new TimeOut(beginTime+1000,dispatchDeleteMonster,deadPlayer.roleDyVo.dyId);
						timeOut=new TimeOut(beginTime+1000,tweenToDeletePlayer,deadPlayer);
						timeOut.start();
					}
				}
			}
		}
		/** 处理死亡怪物的滑动效果
		 */		
		private function deadPlayerMove(obj:Object):void
		{
			var deadPlayer:PlayerView=obj.deadPlayer;
			if(!deadPlayer.isPool)
			{
				deadPlayer.pureMoveTo(obj.x,obj.y,obj.speed,tweenToDeletePlayer,deadPlayer); ///怪物移动
				////删除怪物角色  sceneRolesView处理 删除  只有为怪物时才进行删除
				///  1.5s后删除怪物
//				var time:TimeOut=new TimeOut(1200,dispatchDeleteMonster,deadPlayer.roleDyVo.dyId);
//				time.start();
			}
		}
		/** 人物变小 慢慢删除对象
		 * @param player
		 */		
		public function tweenToDeletePlayer(player:PlayerView):void
		{
			player.isDead=true;
			playDeadEffect(player,0);
//			player.tweenSmall(dispatchDeleteMonster,[player.roleDyVo.dyId],0.7);
			var time:TimeOut=new TimeOut(300,delayToTweenScale,player);
			time.start();
		}
		private function delayToTweenScale(player:PlayerView):void
		{
			if(!player.isPool)	player.tweenSmall(dispatchDeleteMonster,[player.roleDyVo.dyId],0.7);
		}
		
		/**通知删除怪物   怪物死亡
		 */ 
		private function dispatchDeleteMonster(obj:Object):void
		{
			var id:uint=uint(obj);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.DeleteDeadMonster,id);
			///删除怪物数据
			RoleDyManager.Instance.delRole(id);
		}
		
		
		/**主角技能强行终止函数
		 */ 
//		private function heroBreakFunc(obj:Object):void
//		{
//			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
//			
//			print(this,"意外中断......");
//		}
//		/**宠物攻击被强行中断
//		 */		
//		private function petBreakFunc(obj:Object):void
//		{
//			var pet:PetPlayerView=obj as PetPlayerView;
//			pet.isLock=false;
//		}
		
		/**攻击者播放完动画
		 */
		private function atkTotalComplete(data:Object):void
		{		
			var fightUIVo:FightUIPtVo=data.fightUIVo as FightUIPtVo;
			var effectBasicVo:FightEffectBasicVo=data.effectBasicVo as FightEffectBasicVo;
			var attacker:PlayerView=fightUIVo.atk;
	//		print(this,"时间到达");
			if(!attacker.isPool)
			{	
				// 当为当前玩家时   
				if(attacker.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					///解除锁定
					DataCenter.Instance.roleSelfVo.heroState.isLock=false;
					if(DataCenter.Instance.roleSelfVo.heroState.willDo)
					{
						if(DataCenter.Instance.roleSelfVo.heroState.willDo is Point)
						{
							if(DataCenter.Instance.roleSelfVo.heroState.isAtkSkill==false)	noticeWalk(DataCenter.Instance.roleSelfVo.heroState.willDo as Point);
						}
						else if(DataCenter.Instance.roleSelfVo.heroState.willDo is PlayerView)
						{
							var player:PlayerView=DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView;
							if(player)
							{
								if(!player.isPool)
								{
									if(player.roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId) moveToPlayerForFight(player);
								}
							}
						}
					}
					else 
					{
						///当为默认技能
//						if(fightUIVo.skillId==SkillDyManager.Instance.getDefaultSkill())  ///当使用的是默认技能时  
//						{
								if(fightUIVo.uAtkArr.length==1)
								{
									if(fightUIVo.uAtkArr[0].player.isPool==false&&fightUIVo.uAtkArr[0].player.isDead==false)
									{
//										print(this,"进入下一次战斗,此处设置技能目录");
										moveToPlayerForFight(fightUIVo.uAtkArr[0].player);
									}
//							}	
						}
					}
				}
				///当为玩家的宠物时
				else if(attacker is PetPlayerView)
				{
					///当为自己的宠物时  进行进行锁释放
					if(PetPlayerView(attacker).isOwnPet())
					{
						PetPlayerView(attacker).isLock=false;
					}
				}
			}
			fightUIVo.disposeToPool();
		}
		
		private function noticeFight(fightProtoVo:FightMoreVo):void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore,fightProtoVo);
		}
		
		
		/**向目标靠近  准备攻击    mapScenceView 响应该方法
		 */ 
		private function  moveToPlayerForFight(target:PlayerView):void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.MoveToPlayerForFight,target);
		}
		
		/**通知人物行走到该点
		 */
		private function noticeWalk(pt:Point):void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoveTopt,pt);
		} 
	
		/**处理滑动 推拉 效果
		 */ 
//		private function handleSlide(atk:PlayerView,uAtk:PlayerView,fightSkillBasicVo:FightEffectBasicVo):void
//		{
//			var effectEndPt:Point;
//			var effectDegree:Number; ///攻击者和受击者之间的距离
//			var effectSpeed:int=15;///拉取速度
//			var effectDirection:int;///站立方向
//			if(fightSkillBasicVo.effectType==TypeSkill.Effect_Pull)  ///拉取
//			{
//				effectDegree=YFMath.getDegree(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,atk.roleDyVo.mapX,atk.roleDyVo.mapY);
//				effectEndPt=YFMath.getLinePoint4(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,fightSkillBasicVo.effectLen,effectDegree);
//				effectEndPt=GridData.Instance.getMoveToEndPoint(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
//				if(effectEndPt)	effectDirection=DirectionUtil.getDirection(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
//			}
//			else if(fightSkillBasicVo.effectType==TypeSkill.Effect_push)/// 推开
//			{
//				effectDegree=YFMath.getDegree(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,atk.roleDyVo.mapX,atk.roleDyVo.mapY);
//				effectEndPt=YFMath.getLinePoint3(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,fightSkillBasicVo.effectLen,effectDegree);
//				effectEndPt=GridData.Instance.getMoveToEndPoint(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
//				if(effectEndPt)effectDirection=DirectionUtil.getDirection(effectEndPt.x,effectEndPt.y,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
//			}
//			if(effectEndPt)  ////能够进行拉取或者推离
//			{
//				uAtk.backSlideMoveTo(effectEndPt.x,effectEndPt.y,effectDirection,effectSpeed,moveToComplete,{uAtk:uAtk,direction:effectDirection},false,moveToComplete,{uAtk:uAtk,direction:effectDirection});
//				///移除鼠标效果
//				if(uAtk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) noticeRemoveMouseEffect();
//			}
//		}
		
		
		/**播放单一特效 比如骑上坐骑 升级     加血  加魔法 
		 */
		public function showEffect(playerView:PlayerView,skillId:int,skillLevel:int):void
		{
			var url:String;
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(skillId,skillLevel);
			var actionData:YF2dActionData;
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					playerView.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					playerView.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					playerView.addFrontEffect(actionData,effectBasicVo.atkSkyTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					playerView.addBackEffect(actionData,effectBasicVo.atkFloorTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}			
			
		}
		
		
		/**
		 * 定点  具有 一个目标点       受击者 技能播放 加上了技能的运动速度     一个运动技能   也就是造成直线攻击的效果
		 * 根据时间响应战斗      相应的是 运动技能的战斗  一条直线上的战斗 ,只有一个运动技能动画 ，    一个攻击完之后穿过去攻击另一个的效果   
		 */		
		private function updateFight2(fightUIVo:FightUIPtVo):void
		{
			////获取特效数据
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			atkFight(fightUIVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
			/////处理  被攻击者的时间响应  
			var speed:Number=effectBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			var startX:int=atk.roleDyVo.mapX;
			var startY:int=atk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number=0;
			var distance:Number=0;
//			//最远距离
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
			var actionData:YF2dActionData;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
				else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
				}
			///	if(!uAtk.roleDyVo.isMount) ///当不在坐骑上时
				
				endX=uAtk.roleDyVo.mapX;
				endY=uAtk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
				distance=YFMath.distance(startX,startY,endX,endY);
				waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
				
				if(isPlayHit)
				{
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(uAtkInfo.hp>0)uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
					else 
					{
						uAtk.pureStop();
						if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
						{
							uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
						{
							uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
					}
				}
				else uAtk.play(TypeAction.Stand,oppsiteDirection);
				
				//		print(this,"掉落血量"+uAtkInfo.hp);
				if(uAtk.isDead)uAtkInfo.hp=0;
				uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,uAtkTimesArr,bloodComplete,uAtk);
				////处理拉取效果
//				handleSlide(atk,uAtk,fightSkillBasicVo);     
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addBackEffect(actionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addFrontEffect(actionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				////攻击者地面 地面层特效
				if(effectBasicVo.atkFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkFloorId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				
				///受击者 天空层 和受击者地面层
				if(effectBasicVo.uAtkSkyId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				if(effectBasicVo.uAtkFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						for each(myTime in effectBasicVo.uAtkFloorTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}				
			}
			//// 处理天空层 或者地面层响应
			distance=YFMath.distance(startX,startY,fightUIVo.mapX,fightUIVo.mapY);
			waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
			//天空层特效
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.addSuperSpeedEffect(startX,startY,fightUIVo.mapX,fightUIVo.mapY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate);
				}	
				else SourceCache.Instance.loadRes(url);
			}
		}
		
		/**  根据时间响应战斗      相应的是 运动技能的战斗 多个运动技能动画 ，      一个受击者  一个运动技能动画 
		 *  不带目标点的攻击   
		 */		
		private function updateFight3(fightUIVo:FightUIPtVo):void
		{
			////获取特效数据
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			atkFight(fightUIVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
			
			var speed:Number=effectBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			
			var startX:int=atk.roleDyVo.mapX;
			var startY:int=atk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number;
			var distance:Number;
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
			var actionData:YF2dActionData;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
				else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
				}
				///	if(!uAtk.roleDyVo.isMount) ///当不在坐骑上时
				endX=uAtk.roleDyVo.mapX;
				endY=uAtk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;
				distance=YFMath.distance(startX,startY,endX,endY);
				waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);

				if(isPlayHit)
				{
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(uAtkInfo.hp>0) uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
					else 
					{
						uAtk.pureStop();
						if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
						{
							uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
						{
							uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
					}
				}
				else uAtk.play(TypeAction.Stand,oppsiteDirection);
				
				//		print(this,"掉落血量"+uAtkInfo.hp);
				if(uAtk.isDead)uAtkInfo.hp=0;
				uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,uAtkTimesArr,bloodComplete,uAtk);
				////处理拉取效果
//				handleSlide(atk,uAtk,fightSkillBasicVo); 
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addBackEffect(actionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addFrontEffect(actionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				/////天空层 地面层特效处理
				//天空层特效 运动层特效
				if(effectBasicVo.atkSkyId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkSkyId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.addSuperSpeedEffect(startX,startY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				//地面层特效
				if(effectBasicVo.atkFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkFloorId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				
				//天空层特效 受击者
				if(effectBasicVo.uAtkSkyId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				//地面层 特效 受击者
				if(effectBasicVo.uAtkFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
					actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
					if(actionData)
					{
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkFloorTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		/**  攻击一个玩家    产生的效果是   技能多次攻击  就是多击效果  多个运动技能打到一个玩家身上
		 */		
//		private function updateFight5(fightSimpleVo:FightUIPtVo):void
//		{
//			////获取特效数据
//			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightSimpleVo.skillId,fightSimpleVo.skillLevel);
//			atkFight(fightSimpleVo,effectBasicVo);
//			
//			var atk:PlayerView=fightSimpleVo.atk;
//			var url:String;
//			var uAtk:PlayerView;
//			var uAtkInfo:UAtkInfo=fightSimpleVo.uAtkArr[0];
//			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
//			
//			var speed:Number=effectBasicVo.speed; ///技能运行速度
//			var waitTime:Number;///到达受击对象的时间
//			var uAtkTimesArr:Array;//受击时间数组
//			
//			var startX:int=atk.roleDyVo.mapX;
//			var startY:int=atk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
//			var endX:int;
//			var endY:int;
//			var myTime:Number;
//			var distance:Number;
//			///被攻击者
//			var isPlayHit:Boolean=false; ///是否播放受击动画
//			uAtk=uAtkInfo.player;
//			var actionData:YF2dActionData;
//			if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
//			else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
//			{
//				if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
//			}
//			///	if(!uAtk.roleDyVo.isMount) ///当不在坐骑上时
//			endX=uAtk.roleDyVo.mapX;
//			endY=uAtk.roleDyVo.mapY+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
//			distance=YFMath.distance(startX,startY,endX,endY);
//			waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
//			uAtkTimesArr=[];
//			if(isPlayHit)
//			{
//				for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
//				{
//					uAtkTimesArr.push(myTime+waitTime);
//				}
//				if(uAtkInfo.hp>0)uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
//				else 
//				{
//					uAtk.pureStop();
//					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
//					{
//						uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
//					}
//					else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
//					{
//						uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
//					}
//					handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
//				}
//				
//			}
//			else uAtk.play(TypeAction.Stand,oppsiteDirection);
//			
//			//		print(this,"掉落血量"+uAtkInfo.hp);
//			if(uAtk.isDead)uAtkInfo.hp=0;
//			uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,uAtkTimesArr,bloodComplete,uAtk);
//			////处理拉取效果
////			handleSlide(atk,uAtk,fightSkillBasicVo); 
//			//被攻击者最下层特效
//			if(effectBasicVo.uAtkBackId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					uAtkTimesArr=[];
//					for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
//					{
//						uAtkTimesArr.push(myTime+waitTime);
//					}
//					uAtk.addBackEffect(actionData,uAtkTimesArr,false);
//				}
//				else SourceCache.Instance.loadRes(url);
//			}
//			
//			//被攻击者最上层特效
//			if(effectBasicVo.uAtkFrontId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.uAtkFrontId);
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					uAtkTimesArr=[];
//					for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
//					{
//						uAtkTimesArr.push(myTime+waitTime);
//					}
//					uAtk.addFrontEffect(actionData,uAtkTimesArr,false);
//				}
//				else SourceCache.Instance.loadRes(url);
//			}
//			//// 处理天空层 或者地面层响应
//			//地面层特效
//			if(effectBasicVo.atkSkyId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					LayerManager.BgSkillLayer.addSuperSpeedEffect(startX,startY,endX,endY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate);
//				}	
//				else SourceCache.Instance.loadRes(url);
//			}
//			//天空层特效
//			if(effectBasicVo.atkFloorId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
//				}	
//				else SourceCache.Instance.loadRes(url);
//			}
//			
//			//天空层特效
//			if(effectBasicVo.uAtkSkyId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					uAtkTimesArr=[];
//					for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
//					{
//						uAtkTimesArr.push(myTime+waitTime);
//					}
//					LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
//				}	
//				else SourceCache.Instance.loadRes(url);
//			}
//			//天空层特效
//			if(effectBasicVo.uAtkFloorId>0)
//			{
//				url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
//				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
//				if(actionData)
//				{
//					uAtkTimesArr=[];
//					for each(myTime in effectBasicVo.uAtkFloorTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
//					{
//						uAtkTimesArr.push(myTime+waitTime);
//					}
//					LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
//				}	
//				else SourceCache.Instance.loadRes(url);
//			}
//		}

		/**更新   技能无速度 但有目标点  在    updateFight1  的 基础修改个 天空层的技能  天空层特效定位 是根据鼠标来定位的
		 * @param fightUIVo
		 */		
		private function updateFight4(fightUIPtVo:FightUIPtVo):void
		{
			////获取特效数据
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIPtVo.skillId,fightUIPtVo.skillLevel);
			playRoleAndFloorEffect(fightUIPtVo,effectBasicVo);
			//天空层特效
			var atk:PlayerView=fightUIPtVo.atk;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			var actionData:YF2dActionData;
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.atkSkyTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			
			if(effectBasicVo.uAtkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.uAtkSkyId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.uAtkSkyTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.uAtkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
		}
			
		
		/**  攻击者的特效播放
		 */		
		private function atkFight(fightUIVo:FightUIPtVo,effectBasicVo:FightEffectBasicVo):void
		{
			////特效播放 
			var url:String;
			var actionData:YF2dActionData;
			var atk:PlayerView=fightUIVo.atk;
			var atkSKillDirection:int;///技能方向 当技能具有方向时 播放该方向的特效   一般是攻击者的技能具有方向
			if(fightUIVo.uAtkArr.length>0)
			{
				atkSKillDirection=DirectionUtil.getDirection(atk.roleDyVo.mapX,atk.roleDyVo.mapY,fightUIVo.uAtkArr[0].player.roleDyVo.mapX,fightUIVo.uAtkArr[0].player.roleDyVo.mapY);
			}
			else atkSKillDirection=-1;///使用 攻击者的默认方向 
			
			atk.stopMove();
			noticeRemoveMouseEffect();
			atk.splay(TypeAction.Attack,atk.activeDirection,effectBasicVo.atkTimeArr,completeFunc,{atk:atk},effectBasicVo.atkTotalTimes,atkTotalComplete,{fightUIVo:fightUIVo,effectBasicVo:effectBasicVo});
			if(fightUIVo.atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)   ////处于战斗状态 将其锁住
			{
				DataCenter.Instance.roleSelfVo.heroState.isLock=true;
//				print(this,"heroFIght");

			}
			else if(fightUIVo.atk is PetPlayerView)
			{
				///当为自己的宠物时  进行锁住
				if(PetPlayerView(fightUIVo.atk).isOwnPet())
				{
					PetPlayerView(fightUIVo.atk).isLock=true;
				}
			}
			
			
			//攻击者最下层特效
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);	
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkSKillDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
			//攻击者最上层
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);	
				actionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData)
				{
					atk.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false,effectBasicVo.atkFrontDirection,atkSKillDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
		}
		
		
		/**  推拉人物结束后
		 */		
		private function moveToComplete(obj:Object):void
		{
			var uAtk:PlayerView=obj.uAtk as PlayerView;
			var direction:int=obj.direction;
			if(!uAtk.isPool)
			{
				if(!uAtk.isDead)
				{
					uAtk.startPlay();
					uAtk.play(TypeAction.Stand,direction);
				}
			}
		}
		/**移除 场景鼠标效果
		 */		
		private function noticeRemoveMouseEffect():void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.RemoveMouseEffect);
		}
		
		
		
		/** 根据攻击类型  调用不同播放函数
		 * effect_type  战斗特效表 FIghtEffect 字段
		 */		
		public function updateFight(effect_type:int,fightUIVo:FightUIPtVo):void
		{
			switch(effect_type)
			{
				case TypeSkill.Fight_Effect_1:
					///单一攻击
					updateFight1(fightUIVo);
					break;
				case TypeSkill.Fight_Effect_2:
					///单一攻击
					updateFight2(fightUIVo);
					break;
				case TypeSkill.Fight_Effect_3:
					updateFight3(fightUIVo);
					break;
				case TypeSkill.Fight_Effect_4:
					updateFight4(FightUIPtVo(fightUIVo))
					break;
//				case TypeSkill.Fight_Effect_5:
//					updateFight5(fightUIVo);
//					break;
			}
			
		}
		
	}
}