package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.manager.EnhanceEffectBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.ActionManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.SeachRoadVo;
	import com.YFFramework.game.core.module.mapScence.model.UseActionData;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightDamageType;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.UAtkInfo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.EquipCategory;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.mapScence.world.view.player.MonsterView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PetPlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.RolePlayerView;
	import com.YFFramework.game.core.module.newGuide.manager.GuaJiManager;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.geom.Point;

	/**战斗控制中心    内部包含 所有的 特效播放    攻击时  注意 没有攻击者的情况   
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
		/**飞行道具的最小比对距离
		 */
//		private static const MoveMinLen:int=40;
		/**运动技能减去的时间
		 */		
//		private static const Wait_Minus:Number=0;
		
		private static var _instance:FightView;
		public function FightView()
		{
		}
		public static function get Instance():FightView
		{
			if(_instance==null)_instance=new FightView();
			return _instance;
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
//			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=playRoleAndFloorEffect(fightUIVo);
			//天空层特效
			var positionX:Number;
			var positionY:Number;
			
			var atk:PlayerView=fightUIVo.atk;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			var actionData:ATFActionData;
			if(isUseAblePlayer(atk))  ///如果攻击者在视野内
			{
				if(effectBasicVo.atkSkyId>0)  ///攻击者天空层
				{
					url=URLTool.getSkill(effectBasicVo.atkSkyId);	
					positionX=atk.roleDyVo.mapX;
					positionY=atk.roleDyVo.mapY;//+effectBasicVo.atkSkyOffsetY;
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.SkySKillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.atkSkyTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
			}
			if(effectBasicVo.uAtkSkyId>0)  //受击者天空层
			{
				url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					//当 为受击者 
					for each (uAtkInfo in fightUIVo.uAtkArr)    ////对所有的受击对象做 动画
					{
						uAtk=uAtkInfo.player;
						positionX=uAtk.roleDyVo.mapX;
						positionY=uAtk.roleDyVo.mapY;
						LayerManager.SkySKillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.uAtkSkyTimeArr,false);
					}
				}	
				else SourceCache.Instance.loadRes(url);
			}
		}
		
		/**播放人物 和 地面层的效果
		 */ 
//		private function playRoleAndFloorEffect(fightUIVo:FightUIPtVo,effectBasicVo:FightEffectBasicVo):void
		private function playRoleAndFloorEffect(fightUIVo:FightUIPtVo):FightEffectBasicVo
		{
			var effectBasicVo:FightEffectBasicVo=atkFight(fightUIVo);
			if(!effectBasicVo)effectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(TypeRole.Sex_Man,fightUIVo.skillId,fightUIVo.skillLevel);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			
//			var oppsiteDirection:int ;//=TypeDirection.getOppsiteDirection(atk.activeDirection);
//			if(isUseAblePlayer(atk))
//			{
//				oppsiteDirection=TypeDirection.getOppsiteDirection(atk.activeDirection);
//			}
//			else oppsiteDirection=-1;
			var actionData:ATFActionData;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(isUseAblePlayer(uAtk))
				{
					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
//						if(RoleDyVo(uAtk.roleDyVo).state==TypeRole.State_Mount) uAtk.play(TypeAction.Stand,oppsiteDirection);
//						else 
//						{
							if(uAtkInfo.hp>0) 
							{
							//	if(uAtk.roleDyVo.hp==0)  //表示为复活技能  
								if(uAtkInfo.damageType==FightDamageType.REVIVE)
								{
									if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==uAtk.roleDyVo.dyId)
									{
										uAtk.roleDyVo.mp=uAtkInfo.mp;		//更改魔法值
										YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.FightForRevive);  //移除 复活框 
									}
									uAtk.startCloth();
									//复活
//									uAtk.splay(TypeAction.Stand,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
									uAtk.splay(TypeAction.Stand,uAtk.activeDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
								}
								else 
								{
									if(!uAtkInfo.hasBeatBack)
									{
										handlePlayerInjureDeadLoading(uAtk);
//										uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
										uAtk.splay(TypeAction.Injure,uAtk.activeDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
									}
									else 
									{
										handleBeatBack(uAtkInfo,0);
									}
								}
							}
							else 
							{
								uAtk.pureStop();
								handlePlayerInjureDeadLoading(uAtk);
								if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
								{
									uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
								}
								else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
								{
//									uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
									uAtk.splay(TypeAction.Dead,uAtk.activeDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
								}
								handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
							}
//						}
					}
					else 
					{
						if(uAtkInfo.hp>0)
						{
							if(!uAtkInfo.hasBeatBack)
							{
								handlePlayerInjureDeadLoading(uAtk);
//								uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Injure,uAtk.activeDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
							}
							else  //有 击退效果
							{
								handleBeatBack(uAtkInfo,0);
							}	
						}
						else 
						{
							uAtk.pureStop();
							handlePlayerInjureDeadLoading(uAtk);
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
//								uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Dead,uAtk.activeDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
//							if(fightUIVo.skillId==305)
//							{
//								trace("ok");
//							}
							handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
						}
					}
					//	print(this,"掉落血量"+uAtkInfo.hp);
					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,effectBasicVo.bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isReferToHero(atk,uAtk));
					////处理拉取效果
					//				handleSlide(atk,uAtk,fightSkillBasicVo);
					//被攻击者最下层特效
					if(effectBasicVo.uAtkBackId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							uAtk=uAtkInfo.player;
							uAtk.addFrontEffect(actionData,effectBasicVo.uAtkFrontTimeArr,false)
						}
						else SourceCache.Instance.loadRes(url);
					}
					
					//当 为受击者 
					if(effectBasicVo.uAtkFloorId>0)///受击者地面
					{
						url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							positionX=uAtk.roleDyVo.mapX
							positionY=uAtk.roleDyVo.mapY
							LayerManager.BgSkillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
						}
						else SourceCache.Instance.loadRes(url);
					}
				}
			}
			//地面层特效
			var positionX:Number;
			var positionY:Number;
			if(effectBasicVo.atkFloorId>0) ///攻击者地面特效
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				if(isUseAblePlayer(atk))
				{
					positionX=atk.roleDyVo.mapX;
					positionY=atk.roleDyVo.mapY;
				}
				else 
				{
					positionX=uAtk.roleDyVo.mapX;
					positionY=uAtk.roleDyVo.mapY;
				}
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.atkFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			return effectBasicVo;
		}
		
		/**播放完成后触发
		 */
		private function completeFunc(data:Object):void
		{
		//	print(this,"攻击动画播放完毕");
			var atk:PlayerView=data.atk;
			var direction:int=-1;
			if(data.direction)direction=data.direction; //有 方向属性就播放该方向  没有则不播  为默认值-1 
			if(isUseAblePlayer(atk))
			{
				handleplayerFightStand(atk,direction);
				///技能播放完后就要解锁
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==atk.roleDyVo.dyId)DataCenter.Instance.roleSelfVo.heroState.isLock=false; 
				else if(atk is PetPlayerView)
				{
					///当为自己的宠物时  进行进行锁释放
					if(PetPlayerView(atk).isOwnPet())
					{
						PetPlayerView(atk).isLock=false;
					}
				}
			}
		}
		
		/**是否和主角相关
		 */
		private function isRalativeToHero(player:PlayerView):Boolean
		{
			if(isUseAblePlayer(player))
			{
				if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(player.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) return true;
				}
				else if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
				{
					if(PetDyManager.Instance.hasPet(player.roleDyVo.dyId))
					{
						return true;
					}
				}
			}
			return false;
		}
		/**是否和主角相关 相关则返回true
		 */
		private function isReferToHero(atk:PlayerView,uAtk:PlayerView):Boolean
		{
			var hero_1:Boolean=isRalativeToHero(atk);
			var hero_2:Boolean=isRalativeToHero(uAtk);
			var bool:Boolean= hero_1||hero_2;
			return bool;
		}

		
		/**处理击退效果 
		 * time等待时间
		 */
		private function handleBeatBack(uAtkInfo:UAtkInfo,time:Number):void
		{
//			var player:PlayerView=uAtkInfo.player;
//			player.deadMove(uAtkInfo.endX,uAtkInfo.endY,12,slideComplete,player);
			var t:TimeOut=new TimeOut(time,beatBack,uAtkInfo);
			t.start();
		}
		/**击退
		 */
		private function beatBack(uAtkInfo:UAtkInfo):void
		{
			var player:PlayerView=uAtkInfo.player;
			player.deadMove(uAtkInfo.endX,uAtkInfo.endY,12,slideComplete,player);

		}
			
		/**滑动结束
		 */
		private function slideComplete(player:PlayerView):void
		{
			if(isUseAblePlayer(player))
			{
				player.play(TypeAction.Stand);
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
			if(underAttacker.isDispose==false)
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
			if(!playerView.isDispose)YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,playerView.roleDyVo);
		}
		
		/**玩家角色死亡
		 * 该方法的调用在 buff里面  buff导致玩家死亡调用该方法
		 */		
		public function updatePlayerDead(uAtk:PlayerView):void
		{
			handlePlayerInjureDeadLoading(uAtk);
			uAtk.pureStop();
//			uAtk.playDead();
//			uAtk.isDead=true;
			uAtk.updateHp();
			uAtk.play(TypeAction.Dead,TypeDirection.DeafultDead,false);
		}
		/** 播放死亡特效   怪物播放死亡特效
		 */		
		private function playDeadEffect(deadPlayer:PlayerView,beginTime:Number=0):void
		{
			//怪物死亡播放死亡动画
			var actionData:ATFActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.MonsterDeadEffect) as ATFActionData;
			if(actionData)	
			{
					if(isUseAblePlayer(deadPlayer))
						LayerManager.SkySKillLayer.playEffect(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,actionData,[beginTime],false);
						//	deadPlayer.addFrontEffect(actionData,[beginTime],false);
			}
			else SourceCache.Instance.loadRes(CommonEffectURLManager.MonsterDeadEffect);
		}
		/**处理怪物死亡滑动 效果   人物死亡是不进行处理的
		 * beginTime 开始滑动的时间
		 */
		private function handleDeadMoving(deadPlayer:PlayerView,atkPlayer:PlayerView,beginTime:int):void
		{
			
//				deadPlayer.isDead=true;
				if(deadPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
				{
					//播放死亡特效
					///人物死亡面朝角色方向
					var deadDirection:int;
					if(isUseAblePlayer(atkPlayer))
					{
						deadDirection=DirectionUtil.getDirection(atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY,deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY);
					}
					else 
					{
						deadDirection=-1;
					}
					////做打击感
					var degree:Number=0;
					if(isUseAblePlayer(atkPlayer))
					{
						degree=YFMath.getDegree(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY);
					}
					////人物后退  ，进行震屏
					var distance:int=250+Math.random()*100;///人物后退距离
					var endPt:Point=YFMath.getLinePoint3(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,distance,degree);
					if(endPt.x<0||endPt.x>DataCenter.Instance.mapSceneBasicVo.width||endPt.y<0||endPt.y>DataCenter.Instance.mapSceneBasicVo.height)  //如果超出地图范围
					{
						endPt=GridData.Instance.getMoveToEndPoint(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,endPt.x,endPt.y);  //不进行 障碍点处理
					}
					var timeOut:TimeOut;
//					print(this,"roleDyVo:",deadPlayer.roleDyVo);
					if(endPt)  
					{	
						timeOut=new TimeOut(beginTime,deadPlayerMove,{deadPlayer:deadPlayer,x:endPt.x,y:endPt.y,atkPlayer:atkPlayer});//,speed:35
						timeOut.start();
					}
					else  ///不能进行滑动
					{
						timeOut=new TimeOut(beginTime+1000,tweenToDeletePlayer,deadPlayer);
						timeOut.start();
					}
				}
				else if(deadPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  //  为玩家时  处理玩机的 皮肤 
				{
					if(!deadPlayer.getClothInjureDead())
					{
						deadPlayer.resetSkin();
					}
				}
		}
		/** 处理死亡怪物的滑动效果
		 */		
		private function deadPlayerMove(obj:Object):void
		{
			var deadPlayer:PlayerView=obj.deadPlayer;
			var atkPlayer:PlayerView=obj.atkPlayer;
			if(!deadPlayer.isDispose)
			{
				if(Math.random()>=0.8) 
				{
					deadPlayer.updateBlinkMove(obj.x,obj.y,35,tweenToDeletePlayer,deadPlayer,false,true);  //移形换影的死亡方式
				}
				else  // 人物向上抛的死亡方式
				{
					MonsterView(deadPlayer).deadMove(obj.x,obj.y,12,tweenToDeletePlayer,deadPlayer,false);
				}
				///触发震屏幕
				if(isUseAblePlayer(atkPlayer))
				{
					if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==atkPlayer.roleDyVo.dyId)
					{
						if(Math.random()<0.2)
						{
							var shakeTimer:TimeOut=new TimeOut(90,LayerManager.shake,HeroPositionProxy.direction);
							shakeTimer.start();
//							LayerManager.shake(HeroPositionProxy.direction);
						}
					}
				}
			}
		}
		
		/** 人物变小 慢慢删除对象
		 * @param player
		 */		
		public function tweenToDeletePlayer(player:PlayerView):void
		{
//			player.isDead=true;
			playDeadEffect(player,0);
			var time:TimeOut=new TimeOut(300,delayToTweenScale,player);
			time.start();
		}
		private function delayToTweenScale(player:PlayerView):void
		{
			if(!player.isDispose)	player.tweenSmall(dispatchDeleteMonster,[player.roleDyVo.dyId],0.7);
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
		/**攻击者播放完动画
		 */
		private function atkTotalComplete(data:Object):void
		{		
			var fightUIVo:FightUIPtVo=data.fightUIVo as FightUIPtVo;
			var effectBasicVo:FightEffectBasicVo=data.effectBasicVo as FightEffectBasicVo;
			var attacker:PlayerView=fightUIVo.atk;
	//		print(this,"时间到达");
			if(!attacker.isDispose&&attacker.isDead==false) ///角色没有死亡
			{	
				// 当为当前玩家时   
				if(attacker.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					///解除锁定
					DataCenter.Instance.roleSelfVo.heroState.isLock=false;
					if(DataCenter.Instance.roleSelfVo.heroState.willDo)  ///停止继续攻击
					{
						if(DataCenter.Instance.roleSelfVo.heroState.willDo is Point)
						{
							if(DataCenter.Instance.roleSelfVo.heroState.isAtkSkill==false)	noticeWalk(DataCenter.Instance.roleSelfVo.heroState.willDo as Point);
						}
						else if(DataCenter.Instance.roleSelfVo.heroState.willDo is PlayerView) 
						{
							var player:PlayerView=DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView;
							if(player.isDispose==false&&player.isDead==false)
							{
								if(RoleDyManager.Instance.canFight(player.roleDyVo,DataCenter.Instance.roleSelfVo.pkMode))
								{
									if(player.roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId) moveToPlayerForFight(player);
								}
								else if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)  //为npc 向 NPC靠近
								{
									YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToNPC,player.roleDyVo.dyId); //向NPC靠近
								}
							}
						}
						else if(DataCenter.Instance.roleSelfVo.heroState.willDo is SeachRoadVo)  //如果为跨场景寻路
						{
							YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.CheckPath); //向NPC靠近 检测路径
						}

					}
					else //继续攻击
					{
//							if(fightUIVo.skillId==SkillDyManager.Instance.getDefaultSkill())
//							{
								if(fightUIVo.uAtkArr.length>=1&&GuaJiManager.Instance.getStart()==false)//没有挂机的情况下
								{
									var uAtkInfo:UAtkInfo=fightUIVo.uAtkArr[0];
									var selectPlayer:PlayerView=uAtkInfo.player;
									if(isCanFightPlayer(selectPlayer)&&uAtkInfo.hp>0)
									{
										moveToPlayerForFight(selectPlayer);
									}
								}
//							}

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
	
		/**播放单一特效 比如骑上坐骑 升级     加血  加魔法  使用普通特效 
		 */
		public function showEffect(playerView:PlayerView,skillId:int,skillLevel:int):void
		{
			var url:String;
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
//			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(skillId,skillLevel);
			var sex:int=TypeRole.Sex_Man;//性别
			if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)sex=playerView.roleDyVo.sex;
			var effectBasicVo:FightEffectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(sex,skillId,skillLevel);
			var actionData:ATFActionData;
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					playerView.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					playerView.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					playerView.addFrontEffect(actionData,effectBasicVo.atkSkyTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
//			var oppsiteDirection:int=-1;

			if(isUseAblePlayer(atk))
			{
				var atkStandDir:int=DirectionUtil.getDirection(atk.roleDyVo.mapX,atk.roleDyVo.mapY,fightUIVo.mapX,fightUIVo.mapY);
				atk.play(TypeAction.Attack,atkStandDir,false);
				//				oppsiteDirection=TypeDirection.getOppsiteDirection(atkStandDir);
			}

			var effectBasicVo:FightEffectBasicVo=atkFight(fightUIVo);
			if(!effectBasicVo)effectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(TypeRole.Sex_Man,fightUIVo.skillId,fightUIVo.skillLevel);

			/////处理  被攻击者的时间响应  
			var speed:Number=effectBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			var endX:int;
			var endY:int;
			var myTime:Number=0;
			var distance:Number=0;
			
			var startX:int;//=atk.roleDyVo.mapX;
			var startY:int;//=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;// 运动技能向上抬高			+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
			
			
//			//最远距离
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
			var actionData:ATFActionData;
			var bloodArr:Array;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(isUseAblePlayer(uAtk))
				{
					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
					else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
					}
					///	if(!uAtk.roleDyVo.isMount) ///当不在坐骑上时
					endX=uAtk.roleDyVo.mapX;
					endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;//运动技能向上抬高	+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
					if(isUseAblePlayer(atk))  ///攻击者存在
					{
						startX=atk.roleDyVo.mapX;
						startY=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
					}
					else 
					{
						startX=endX;
						startY=endY;
					}
					
					distance=YFMath.distance(startX,startY,endX,endY);
					waitTime=(distance+0.00001)*1000/(speed*UpdateManager.UpdateRate);
					
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(isPlayHit)
					{
						if(uAtkInfo.hp>0)
						{
							if(!uAtkInfo.hasBeatBack)
							{
								handlePlayerInjureDeadLoading(uAtk);
//								uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Injure,uAtk.activeDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
							}
							else  //有 击退效果
							{
								handleBeatBack(uAtkInfo,waitTime);
							}	
						}
						else 
						{
							handlePlayerInjureDeadLoading(uAtk);
							uAtk.pureStop();
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
//								uAtk.splay(TypeAction.Dead,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Dead,uAtk.activeDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
						}
					}
					else 
					{
//						uAtk.play(TypeAction.Stand,oppsiteDirection);
						uAtk.play(TypeAction.Stand,uAtk.activeDirection);
					}
					
					bloodArr=[];
					for each(myTime in effectBasicVo.bloodArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						bloodArr.push(myTime+waitTime);
					}
					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isReferToHero(atk,uAtk));
					
					//被攻击者最下层特效
					if(effectBasicVo.uAtkBackId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					///受击者 天空层 和受击者地面层
					if(effectBasicVo.uAtkSkyId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							uAtkTimesArr=[];
							for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
							{
								uAtkTimesArr.push(myTime+waitTime);
							}
							LayerManager.SkySKillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
					if(effectBasicVo.uAtkFloorId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
			}
			endX=fightUIVo.mapX;
			endY=fightUIVo.mapY;
			if(isUseAblePlayer(atk))  ///攻击者存在
			{
				startX=atk.roleDyVo.mapX;
				startY=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
			}
			else 
			{
				startX=endX;
				startY=endY;
			}
			//// 处理天空层 或者地面层响应
			distance=YFMath.distance(startX,startY,fightUIVo.mapX,fightUIVo.mapY);
			waitTime=(distance+0.00001)*1000/(speed*UpdateManager.UpdateRate);
			//天空层特效
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					
					var atkDirection:int=1;
					if(isUseAblePlayer(atk))atkDirection=atk.activeDirection;
					var skyOffset:Array=effectBasicVo.getSkyOffset(atkDirection); //便宜量
					
					var myRotateRad:Number=YFMath.getRad(startX,startY,endX,endY);///  
					var skillRotatePoint:Point=YFMath.getSkillRotatePoint(startX,startY,effectBasicVo.atkSkySkillLen,myRotateRad);
					var moveSkillX:Number=skillRotatePoint.x+skyOffset[0];  //飞行道具起始坐标
					var moveSkillY:Number=skillRotatePoint.y+skyOffset[1]; //飞行道具起始坐标
					var myTestDis:Number=YFMath.distance(startX,startY,endX,endY);
					if(myTestDis>=effectBasicVo.atkSkySkillLen)  //比对距离
					{
						//矫正旋转 角度
						myRotateRad=YFMath.getRad(moveSkillX,moveSkillY,endX,endY);///
						var myEndPt:Point=YFMath.getSkillRotatePoint(endX,endY,effectBasicVo.atkSkySkillLen*0.3,myRotateRad);
						LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,moveSkillX,moveSkillY,myEndPt.x,myEndPt.y,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
					}
					else 
					{
						LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,startX,startY,endX,endY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
					}


				}	
				else SourceCache.Instance.loadRes(url);
			}
			///处理目标点进行爆炸处理
			////攻击者地面 地面层特效
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					if(isUseAblePlayer(atk))
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					else 	
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
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
//			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=atkFight(fightUIVo);
			if(!effectBasicVo)effectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(TypeRole.Sex_Man,fightUIVo.skillId,fightUIVo.skillLevel);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
//			var oppsiteDirection:int=-1;//
//			if(isUseAblePlayer(atk))
//			{
//				oppsiteDirection=TypeDirection.getOppsiteDirection(atk.activeDirection);
//			}
			var speed:Number=effectBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			
			var startX:int;//=atk.roleDyVo.mapX;
			var startY:int;//=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;//运动技能向上抬高	+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number;
			var distance:Number;
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
			var actionData:ATFActionData;
			var bloodArr:Array;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(isUseAblePlayer(uAtk))
				{
					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
					else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
					}
					endX=uAtk.roleDyVo.mapX;
					endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;//运动技能向上抬高		+effectBasicVo.atkSkyOffsetY;
					
					if(isUseAblePlayer(atk))  ///攻击者存在
					{
						startX=atk.roleDyVo.mapX;
						startY=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
					}
					else 
					{
						startX=endX;
						startY=endY;
					}
					distance=YFMath.distance(startX,startY,endX,endY);
					waitTime=(distance+0.00001)*1000/(speed*UpdateManager.UpdateRate);
					
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(isPlayHit)
					{
						if(uAtkInfo.hp>0) 
						{
							if(!uAtkInfo.hasBeatBack)
							{
								handlePlayerInjureDeadLoading(uAtk);
//								uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Injure,uAtk.activeDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
							}
							else  //有 击退效果
							{
								handleBeatBack(uAtkInfo,waitTime);
							}	
						}
						else 
						{
							handlePlayerInjureDeadLoading(uAtk);
							uAtk.pureStop();
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
//								uAtk.splay(TypeAction.Dead,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Dead,uAtk.activeDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
						}
					}
					else 
					{
//						uAtk.play(TypeAction.Stand,oppsiteDirection);
						uAtk.play(TypeAction.Stand,uAtk.activeDirection);
					}
					
					//		print(this,"掉落血量"+uAtkInfo.hp);
//					if(uAtk.isDead)uAtkInfo.hp=0;
					//				if(effectBasicVo.bloodSplit==TypeSkill.Blood_Split)  //血量拆分
					//					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,uAtkTimesArr,bloodComplete,uAtk,uAtkInfo.damageType);
					//				else	//血量不进行拆分
					//					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,[uAtkTimesArr[0]],bloodComplete,uAtk,uAtkInfo.damageType);
					bloodArr=[];
					for each(myTime in effectBasicVo.bloodArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						bloodArr.push(myTime+waitTime);
					}
					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isReferToHero(atk,uAtk));
					
					////处理拉取效果
					//				handleSlide(atk,uAtk,fightSkillBasicVo); 
					//被攻击者最下层特效
					if(effectBasicVo.uAtkBackId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							
							var atkDirection:int=uAtk.activeDirection;
							if(isUseAblePlayer(atk))atkDirection=atk.activeDirection;
							var skyOffset:Array=effectBasicVo.getSkyOffset(atkDirection); //便宜量
							
							
							var myRotateRad:Number=YFMath.getRad(startX,startY,endX,endY);///  
							var skillRotatePoint:Point=YFMath.getSkillRotatePoint(startX,startY,effectBasicVo.atkSkySkillLen,myRotateRad);
							var moveSkillX:Number=skillRotatePoint.x+skyOffset[0];  //飞行道具起始坐标
							var moveSkillY:Number=skillRotatePoint.y+skyOffset[1]; //飞行道具起始坐标
							
							var myTestDis:Number=YFMath.distance(startX,startY,endX,endY);
							if(myTestDis>=effectBasicVo.atkSkySkillLen)  //比对距离
							{
								//矫正旋转 角度
//								myRotateRad=YFMath.getRad(moveSkillX,moveSkillY,endX,endY);///
								var myEndPt:Point=YFMath.getSkillRotatePoint(endX,endY,effectBasicVo.atkSkySkillLen*0.3,myRotateRad);
								LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,moveSkillX,moveSkillY,myEndPt.x,myEndPt.y,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
							}
							else 
							{
								LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,startX,startY,endX,endY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
							}
						}	
						else SourceCache.Instance.loadRes(url);
					} 
					//天空层特效 受击者
					if(effectBasicVo.uAtkSkyId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							uAtkTimesArr=[];
							for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
							{
								uAtkTimesArr.push(myTime+waitTime);
							}
							
							LayerManager.SkySKillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
					//地面层 特效 受击者
					if(effectBasicVo.uAtkFloorId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
			//地面层特效
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					if(isUseAblePlayer(atk))
					{
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					}
					else 
					{
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					}
				}	
				else SourceCache.Instance.loadRes(url);
			}
		}
	
		/**更新   技能无速度 但有目标点  在    updateFight1  的 基础修改个 天空层的技能  天空层特效定位 是根据鼠标来定位的
		 * @param fightUIVo
		 */		
		private function updateFight4(fightUIPtVo:FightUIPtVo):void
		{
			////获取特效数据
			var effectBasicVo:FightEffectBasicVo=playRoleAndFloorEffect(fightUIPtVo);
			//天空层特效
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			var actionData:ATFActionData;
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.atkSkyTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}

			if(effectBasicVo.uAtkSkyId>0)  //受击者天空层
			{
				url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
				//当 为受击者 
				var positionX:Number=0;
				var positionY:Number=0;
				for each (uAtkInfo in fightUIPtVo.uAtkArr)    ////对所有的受击对象做 动画
				{
					uAtk=uAtkInfo.player;
					if(isUseAblePlayer(uAtk))
					{
						positionX=uAtk.roleDyVo.mapX;
						positionY=uAtk.roleDyVo.mapY;
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							LayerManager.SkySKillLayer.playEffect(positionX,positionY,actionData,effectBasicVo.uAtkSkyTimeArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
				}
			}
			
			if(effectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.bgFloorId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,actionData,effectBasicVo.bgFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			//播放粒子点
			var particleX:int=fightUIPtVo.mapX;
			var particleY:int=fightUIPtVo.mapY;
			if(particleX==0&&particleY==0)
			{
				if(isUseAblePlayer(fightUIPtVo.atk)) 
				{
					particleX=fightUIPtVo.atk.roleDyVo.mapX;
					particleY=fightUIPtVo.atk.roleDyVo.mapY;
				}
			}
			LayerManager.BgSkillLayer.playPointParticle(effectBasicVo.particle_id,particleX,particleY,0);

		}
		
		
		
		/**具有目标点   飞行技能   技能  飞行到目标点  产生爆炸  并且对爆炸周围产生伤害的  播放效果
		 * @param fightUIVo
		 */		
		private function updateFight5(fightUIVo:FightUIPtVo):void
		{
			var effectBasicVo:FightEffectBasicVo=atkFight(fightUIVo);  //攻击这播放动作
			if(!effectBasicVo)effectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(TypeRole.Sex_Man,fightUIVo.skillId,fightUIVo.skillLevel);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
//			var oppsiteDirection:int=-1;
			var startX:int=fightUIVo.mapX;//=atk.roleDyVo.mapX;
			var startY:int=fightUIVo.mapY;//=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;// 运动技能向上抬高			+effectBasicVo.atkSkyOffsetY;//-BgMapScrollport.HeroHeight*0.5;
			var endX:int=fightUIVo.mapX;
			var endY:int=fightUIVo.mapY;
			if(isUseAblePlayer(atk))
			{
//				oppsiteDirection=TypeDirection.getOppsiteDirection(atk.activeDirection);
				startX=atk.roleDyVo.mapX;
				startY=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;;
			}
			/////处理  被攻击者的时间响应  
			var speed:Number=effectBasicVo.speed; ///技能运行速度
			var uAtkTimesArr:Array;//受击时间数组
			var myTime:Number=0;
			var distance:Number=YFMath.distance(startX,startY,endX,endY);;
			var waitTime:Number=(distance+0.00001)*1000/(speed*UpdateManager.UpdateRate);///到达受击对象的时间
			//			//最远距离
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
			var actionData:ATFActionData;
			var bloodArr:Array;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(isUseAblePlayer(uAtk))
				{
					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
					else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
					}
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(isPlayHit)
					{
						if(uAtkInfo.hp>0)
						{
							if(!uAtkInfo.hasBeatBack)
							{
								handlePlayerInjureDeadLoading(uAtk);
//								uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Injure,uAtk.activeDirection,uAtkTimesArr,uAktInjureComplete,{uAtk:uAtk});
							}
							else  //有 击退效果
							{
								handleBeatBack(uAtkInfo,waitTime);
							}	
						}
						else 
						{
							handlePlayerInjureDeadLoading(uAtk);
							uAtk.pureStop();
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
//								uAtk.splay(TypeAction.Dead,oppsiteDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
								uAtk.splay(TypeAction.Dead,uAtk.activeDirection,uAtkTimesArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							handleDeadMoving(uAtk,atk,uAtkTimesArr[0]);
						}
					}
					else 
					{
//						uAtk.play(TypeAction.Stand,oppsiteDirection);
						uAtk.play(TypeAction.Stand,uAtk.activeDirection);
					}
					
					//		print(this,"掉落血量"+uAtkInfo.hp);
//					if(uAtk.isDead)uAtkInfo.hp=0;
					bloodArr=[];
					for each(myTime in effectBasicVo.bloodArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						bloodArr.push(myTime+waitTime);
					}
					uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isReferToHero(atk,uAtk));
					
					////处理拉取效果
					//				handleSlide(atk,uAtk,fightSkillBasicVo);     
					//被攻击者最下层特效
					if(effectBasicVo.uAtkBackId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					
					///受击者 天空层 和受击者地面层
					if(effectBasicVo.uAtkSkyId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkSkyId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							uAtkTimesArr=[];
							for each(myTime in effectBasicVo.uAtkSkyTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
							{
								uAtkTimesArr.push(myTime+waitTime);
							}
							LayerManager.SkySKillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,uAtkTimesArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
					if(effectBasicVo.uAtkFloorId>0)
					{
						url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
			}
			//// 处理天空层 或者地面层响应
			//天空层特效
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					var atkDirection:int=TypeDirection.Down;
					if(isUseAblePlayer(atk))atkDirection=atk.activeDirection;
					var skyOffset:Array=effectBasicVo.getSkyOffset(atkDirection); //便宜量
					
					var myRotateRad:Number=YFMath.getRad(startX,startY,endX,endY);///  
					var skillRotatePoint:Point=YFMath.getSkillRotatePoint(startX,startY,effectBasicVo.atkSkySkillLen,myRotateRad);
					var moveSkillX:Number=skillRotatePoint.x+skyOffset[0];  //飞行道具起始坐标
					var moveSkillY:Number=skillRotatePoint.y+skyOffset[1]; //飞行道具起始坐标
					var myTestDis:Number=YFMath.distance(startX,startY,endX,endY);
					if(myTestDis>=effectBasicVo.atkSkySkillLen)  //比对距离
					{
						//矫正旋转 角度
						myRotateRad=YFMath.getRad(moveSkillX,moveSkillY,endX,endY);///
						var myEndPt:Point=YFMath.getSkillRotatePoint(endX,endY,effectBasicVo.atkSkySkillLen*0.3,myRotateRad);
						LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,moveSkillX,moveSkillY,myEndPt.x,myEndPt.y,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
					}
					else 
					{
						LayerManager.SkySKillLayer.addSuperSpeedEffect(myRotateRad,startX,startY,endX,endY,effectBasicVo.atkSkyTimeArr,speed,actionData,effectBasicVo.atkSkyRotate,effectBasicVo.particle_id);
					}
				}	
				else SourceCache.Instance.loadRes(url);
			}
			
			////攻击者地面 地面层特效
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					if(isUseAblePlayer(atk))
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					else if(isUseAblePlayer(uAtk))
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			
			//地面层
			if(effectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.bgFloorId);
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					var bgTimeArr:Array=[];
					for each(myTime in effectBasicVo.bgFloorTimeArr)
					{
						bgTimeArr.push(myTime+waitTime);
					}
					LayerManager.BgSkillLayer.playEffect(fightUIVo.mapX,fightUIVo.mapY,actionData,bgTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			//播放粒子点
			var particleX:int=fightUIVo.mapX;
			var particleY:int=fightUIVo.mapY;
			if(particleX==0&&particleY==0)
			{
				if(isUseAblePlayer(atk))
				{
					particleX=atk.roleDyVo.mapX;
					particleY=atk.roleDyVo.mapY;
				}
			}
			LayerManager.BgSkillLayer.playPointParticle(effectBasicVo.particle_id,particleX,particleY,0);
		}
		
	
		/**处理  攻击者 攻击动作的加载 和播放
		 */
		private function handleplayerFight(atk:PlayerView,fightUIVo:FightUIPtVo):FightEffectBasicVo
		{
			var clothFight:UseActionData;
			var clothFightAction:ATFActionData;
			
			var isRolePlayer:Boolean=atk is RolePlayerView; ///是否为角色玩家
			if(isRolePlayer) //为玩家 
			{
				var weaponFight:UseActionData;
				var weaponFightAction:ATFActionData;
				var wingFight:UseActionData;
				var wingFightAction:ATFActionData;
				
				//加载光效
				var clothFightEffect:UseActionData;
				var clothFightEffectAction:ATFActionData;
				
				var weaponFightEffect:UseActionData;
				var weaponFightEffectAction:ATFActionData;

				clothFightAction=atk.getClothFight();
				if(!clothFightAction)
				{
					clothFight=getUseActionData(atk,EquipCategory.Cloth,TypeAction.Attack);
					if(clothFight.actionData)
					{
						atk.updateClothFight(clothFight.actionData);
					}
				}
				weaponFightAction=RolePlayerView(atk).getWeaponFight();
				if(!weaponFightAction)
				{
					weaponFight=getUseActionData(atk,EquipCategory.Weapon,TypeAction.Attack);
					if(weaponFight.actionData)
					{
						RolePlayerView(atk).updateWeaponFight(weaponFight.actionData);
					}
				}
				wingFightAction=RolePlayerView(atk).getWingFight();
				if(!wingFightAction)
				{
					wingFight=getUseActionData(atk,EquipCategory.Wing,TypeAction.Attack);
					if(wingFight.actionData)
					{
						RolePlayerView(atk).updateWingFight(wingFight.actionData);
					}
				}
				 //衣服光效
				clothFightEffectAction=RolePlayerView(atk).getClothEffectFight();
				if(!clothFightEffectAction)
				{
					//加载光效
					clothFightEffect=getUseActionData(atk,EquipCategory.ClothEffect,TypeAction.Attack);
					if(clothFightEffect.actionData)
					{
						RolePlayerView(atk).updateClothEffectFight(clothFightEffect.actionData);
					}
				}
				//武器光效
				weaponFightEffectAction=RolePlayerView(atk).getWeaponEffectFight();
				if(!weaponFightEffectAction)
				{
					weaponFightEffect=getUseActionData(atk,EquipCategory.WeaponEffect,TypeAction.Attack);
					if(weaponFightEffect.actionData)
					{
						RolePlayerView(atk).updateWeaponEffectFight(weaponFightEffect.actionData);
					}
				}
			}
			else  //为怪物  宠物 
			{
				clothFightAction=atk.getClothFight();
				if(!clothFightAction)
				{
					clothFight=getUseActionData(atk,EquipCategory.Cloth,TypeAction.Attack);
					if(clothFight.actionData)
					{
						atk.updateClothFight(clothFight.actionData);
					}
				}
			}
			
			var effectBasicVo:FightEffectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(atk.roleDyVo.sex,fightUIVo.skillId,fightUIVo.skillLevel);
			
			atk.splay(TypeAction.Attack,atk.activeDirection,effectBasicVo.atkTimeArr,completeFunc,{atk:atk},effectBasicVo.atkTotalTimes,atkTotalComplete,{fightUIVo:fightUIVo,effectBasicVo:effectBasicVo});
			//如果为主角
			handleContinueFight(atk,fightUIVo,effectBasicVo,effectBasicVo.atkTotalTimes);
			return effectBasicVo;
		}
		/** 普通攻击后继续使用
		 */
		private function handleContinueFight(atk:PlayerView,fightUIVo:FightUIPtVo,effectBasicVo:FightEffectBasicVo,totalTime:Number):void
		{
			if(atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				if(fightUIVo.uAtkArr.length>0)
				{
					if(fightUIVo.uAtkArr[0].player)
					{
						var skillBasiVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
						var waitTime:Number=skillBasiVo.cooldown_time;  //一次发起攻击的时间
						if(fightUIVo.skillId==SkillDyManager.Instance.getDefaultSkill()) //如果为默认技能  //CD之后 继续攻击
						{
							waitTime=skillBasiVo.cooldown_time;
						}
						else //不为默认技能
						{
							waitTime=1000; 
						}
						if(totalTime<waitTime)
						{
							DataCenter.Instance.roleSelfVo.heroState.willDo=fightUIVo.uAtkArr[0].player;
							var t:TimeOut=new TimeOut(waitTime,atkTotalComplete,{fightUIVo:fightUIVo,effectBasicVo:effectBasicVo});
							t.start();
						}
					}
				}
			}

		}
		
		/**处理  攻击者的战斗待机的加载 和播放
		 */
		private function handleplayerFightStand(atk:PlayerView,direction:int):void
		{
			if(atk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player&&atk.roleDyVo.career!=TypeRole.CAREER_NEWHAND) //播放战斗待机
			{
				//处理战斗待机
				var clothAtk_1:UseActionData=getUseActionData(atk,EquipCategory.Cloth,TypeAction.FightStand);
				var weaponAtk_1:UseActionData=getUseActionData(atk,EquipCategory.Weapon,TypeAction.FightStand);
				var wingAtk_1:UseActionData=getUseActionData(atk,EquipCategory.Wing,TypeAction.FightStand);
				//加载  武器光效 
				var clothFightStandEffect:UseActionData=getUseActionData(atk,EquipCategory.ClothEffect,TypeAction.FightStand);
				var weaponFightStandEffect:UseActionData=getUseActionData(atk,EquipCategory.WeaponEffect,TypeAction.FightStand);
				
				if(clothFightStandEffect.actionData)
				{
					RolePlayerView(atk).updateClothEffectFightStand(clothFightStandEffect.actionData);
				}
				if(weaponFightStandEffect.actionData)
				{
					RolePlayerView(atk).updateWeaponEffectFightStand(weaponFightStandEffect.actionData);
				}
				if(clothAtk_1.canUse&&weaponAtk_1.canUse&&wingAtk_1.canUse) //数据存在
				{
					atk.updateClothFightStand(clothAtk_1.actionData);
					RolePlayerView(atk).updateWeaponFightStand(weaponAtk_1.actionData);
					RolePlayerView(atk).updateWingFightStand(wingAtk_1.actionData);
					atk.play(TypeAction.FightStand,direction);
				}
				else  
				{
					atk.play(TypeAction.Stand,direction);  ///战斗待机位置
				}
			}
			else  //不为玩家(除去新手)类型 
			{
				atk.play(TypeAction.Stand,direction);  ///战斗待机位置
			}
		}
		/**处理  受击者 受击死亡动作的加载
		 */
		public function handlePlayerInjureDeadLoading(uAtk:PlayerView):void
		{
			var clothInjureDead:UseActionData;
			var  clothInjureAction:ATFActionData;
			var isRolePlayer:Boolean=uAtk is RolePlayerView; ///是否为角色玩家
			
			if(isRolePlayer) //为玩家 
			{
				//加载光效
				var clothEffectInjureDead:UseActionData;
				var clothEffectInjureDeadAction:ATFActionData;
				
				var weaponEffectInjureDead:UseActionData;
				var weaponEffectInjureDeadAction:ATFActionData;
				
				var weaponInjureDead:UseActionData;
				var weaponInjureDeadAction:ATFActionData;
				
				var wingInjureDead:UseActionData;
				var wingInjureDeadAction:ATFActionData;
				
				
//				var checkDead:Boolean=false;
				
				clothInjureAction=uAtk.getClothInjureDead();
				if(!clothInjureAction)
				{
					clothInjureDead=getUseActionData(uAtk,EquipCategory.Cloth,TypeAction.Injure);
					if(clothInjureDead.actionData)
					{
						uAtk.updateClothInjureDead(clothInjureDead.actionData);
//						checkDead=true;
					}
				}
				weaponInjureDeadAction=RolePlayerView(uAtk).getWeaponInjureDead();
				if(!weaponInjureDeadAction)
				{
					weaponInjureDead=getUseActionData(uAtk,EquipCategory.Weapon,TypeAction.Injure);
					if(weaponInjureDead.actionData)
					{
						RolePlayerView(uAtk).updateWeaponInjureDead(weaponInjureDead.actionData);
						//					checkDead=true;
					}
				}
				wingInjureDeadAction=RolePlayerView(uAtk).getWingInjureDead();
				if(!wingInjureDeadAction)
				{
					wingInjureDead=getUseActionData(uAtk,EquipCategory.Wing,TypeAction.Injure);
					if(wingInjureDead.actionData)
					{
						RolePlayerView(uAtk).updateWingInjureDead(wingInjureDead.actionData);
						//					checkDead=true;
					}
				}
				clothEffectInjureDeadAction=RolePlayerView(uAtk).getClothEffectInjureDead();
				if(!clothEffectInjureDeadAction)
				{
					//加载光效
					clothEffectInjureDead=getUseActionData(uAtk,EquipCategory.ClothEffect,TypeAction.Injure);
					if(clothEffectInjureDead.actionData)
					{
						RolePlayerView(uAtk).updateClothEffectInjureDead(clothEffectInjureDead.actionData);
						//					checkDead=true;
					}
				}
				weaponEffectInjureDeadAction=RolePlayerView(uAtk).getWeaponEffectInjureDead();
				if(!weaponEffectInjureDeadAction)
				{
					weaponEffectInjureDead=getUseActionData(uAtk,EquipCategory.WeaponEffect,TypeAction.Injure);
					if(weaponEffectInjureDead.actionData)
					{
						RolePlayerView(uAtk).updateWeaponEffectInjureDead(weaponEffectInjureDead.actionData);
						//					checkDead=true;
					}
				}
//				if(checkDead)
//				checkStayDead(uAtk);
			}
			else  //为怪物  宠物 
			{
				clothInjureAction=uAtk.getClothInjureDead();
				if(!clothInjureAction)
				{
					clothInjureDead=getUseActionData(uAtk,EquipCategory.Cloth,TypeAction.Injure);
					if(clothInjureDead.actionData)
					{
						uAtk.updateClothInjureDead(clothInjureDead.actionData);
					}
				}
			}
		}
		/**检测是否已经死亡
		 */
		public function checkStayDead(uAtk:PlayerView):void
		{
			if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
			{
				if(uAtk.isDead)
				{
					uAtk.stayDead();
				}
			}
		}
		/**处理特殊攻击Atk_1 的加载和播放
		 */
		private function handleRolePlayerAtk_1(atk:RolePlayerView,fightUIVo:FightUIPtVo):FightEffectBasicVo
		{
			var clothAtk_1:UseActionData;
			var weaponAtk_1:UseActionData;
			var wingAtk_1:UseActionData;
			//加载光效
			var clothAtk_1Effect:UseActionData;
			var weaponAtk_1Effect:UseActionData;
			
			clothAtk_1=getUseActionData(atk,EquipCategory.Cloth,TypeAction.SpecialAtk_1);
			weaponAtk_1=getUseActionData(atk,EquipCategory.Weapon,TypeAction.SpecialAtk_1);
			wingAtk_1=getUseActionData(atk,EquipCategory.Wing,TypeAction.SpecialAtk_1);
			//加载光效
			clothAtk_1Effect=getUseActionData(atk,EquipCategory.ClothEffect,TypeAction.SpecialAtk_1);
			weaponAtk_1Effect=getUseActionData(atk,EquipCategory.WeaponEffect,TypeAction.SpecialAtk_1);
			if(clothAtk_1Effect.actionData)
			{
				RolePlayerView(atk).updateClothEffectAtk_1(clothAtk_1Effect.actionData);
			}
			if(weaponAtk_1Effect.actionData)
			{
				RolePlayerView(atk).updateWeaponEffectAtk_1(weaponAtk_1Effect.actionData);
			}
			var effectBasicVo:FightEffectBasicVo;
			if(clothAtk_1.canUse&&weaponAtk_1.canUse&&wingAtk_1.canUse) //特殊攻击
			{
				effectBasicVo=SkillBasicManager.Instance.getAtk_1FightEffectBasicVo(atk.roleDyVo.sex,fightUIVo.skillId,fightUIVo.skillLevel);
				atk.updateClothAtk_1(clothAtk_1.actionData);
				RolePlayerView(atk).updateWeaponAtk_1(weaponAtk_1.actionData);
				RolePlayerView(atk).updateWingAtk_1(wingAtk_1.actionData);
				atk.splay(TypeAction.SpecialAtk_1,atk.activeDirection,effectBasicVo.atkTimeArr,completeFunc,{atk:atk},effectBasicVo.atkTotalTimes,atkTotalComplete,{fightUIVo:fightUIVo,effectBasicVo:effectBasicVo});
				//如果为主角
				handleContinueFight(atk,fightUIVo,effectBasicVo,effectBasicVo.atkTotalTimes);
			}
			else  //普通攻击
			{
				effectBasicVo=handleplayerFight(atk,fightUIVo);
			}
			return effectBasicVo;
		}

		
		
		
		/**  攻击者的特效播放
		 */		
		private function atkFight(fightUIVo:FightUIPtVo):FightEffectBasicVo
		{
			var effectBasicVo:FightEffectBasicVo;//=SkillDyManager.Instance.getFightEffectBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			////特效播放 
			var url:String;
			var actionData:ATFActionData;
			var atk:PlayerView=fightUIVo.atk;
			var atkSKillDirection:int;///技能方向 当技能具有方向时 播放该方向的特效   一般是攻击者的技能具有方向
			if(isUseAblePlayer(atk))  ///如果攻击者存在
			{
				if(fightUIVo.uAtkArr.length>0)
				{
					if(isUseAblePlayer(fightUIVo.uAtkArr[0].player))
					{
						atkSKillDirection=DirectionUtil.getDirection(atk.roleDyVo.mapX,atk.roleDyVo.mapY,fightUIVo.uAtkArr[0].player.roleDyVo.mapX,fightUIVo.uAtkArr[0].player.roleDyVo.mapY);
					}
					else atkSKillDirection=-1;
				}
				else atkSKillDirection=-1;///使用 攻击者的默认方向 
				atk.stopMove();
				if(atk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  //为玩家
				{
					if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==atk.roleDyVo.dyId) //如果为自己
					{
						switch(ActionManager.Instance.getAtkAction()) //普通攻击
						{
							case ActionManager.NormalAtk: //普通攻击
								effectBasicVo=handleplayerFight(atk,fightUIVo);
								break;
							case ActionManager.SpecialAtk_1: //特殊攻击
								if(RolePlayerView(atk).roleDyVo.career!=TypeRole.CAREER_NEWHAND)
								{
									effectBasicVo=handleRolePlayerAtk_1(RolePlayerView(atk),fightUIVo);
								}
								else 
								{
									effectBasicVo=handleplayerFight(atk,fightUIVo);
								}
								break;
						} 
						ActionManager.Instance.change();
					}
					else   //其他玩家 
					{
						if(Math.random()<0.5) //普通 攻击 
						{
							effectBasicVo=handleplayerFight(atk,fightUIVo);
						}
						else 	//特殊攻击 
						{
							if(RolePlayerView(atk).roleDyVo.career!=TypeRole.CAREER_NEWHAND)
							{
								effectBasicVo=handleRolePlayerAtk_1(RolePlayerView(atk),fightUIVo);
							}
							else 
							{
								effectBasicVo=handleplayerFight(atk,fightUIVo);
							}
						}
					}
				}
				else  ///怪物  宠物当作男性处理	普通 攻击   当作  男的 普通攻击处理 
				{
					effectBasicVo=handleplayerFight(atk,fightUIVo);
				}
				
				if(fightUIVo.atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)   ////处于战斗状态 将其锁住
				{
					DataCenter.Instance.roleSelfVo.heroState.isLock=true;
					noticeRemoveMouseEffect();
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
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						atk.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false,effectBasicVo.atkFrontDirection,atkSKillDirection);
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
			return effectBasicVo;
		}
		
		/**加载特殊动作       如果有直接返回
		 * roleDyVo 玩家 
		 * equipType    模型部位
		 * atkType 战斗 类型 值在 TypeAction里面  大于  6 的值
		 */		
		private function getUseActionData(player:PlayerView,equipType:int,atkType:int):UseActionData
		{
			var roleDyVo:RoleDyVo=player.roleDyVo;
			var url:String;
			var equipBasicVo:EquipBasicVo;
			var modelId:int;
			var flag:Object=DataCenter.Instance.getMapId();
			var actionData:ATFActionData;
			var useActionData:UseActionData=new UseActionData();
			
			switch(roleDyVo.bigCatergory)
			{
				case TypeRole.BigCategory_Player:  //玩家类型
					var clothBasicId:int=player.roleDyVo.clothBasicId;
					var weaponBasicId:int=player.roleDyVo.weaponBasicId;
					var wingBasicId:int=player.roleDyVo.wingBasicId;
					///标记
					if(roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
					{
						flag=SourceCache.ExistAllScene;
					}
					switch(equipType)
					{
						case EquipCategory.Cloth:
							if(clothBasicId>0)
							{
								equipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(clothBasicId);
								modelId=equipBasicVo.getModelId(roleDyVo.sex);
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getClothAtk(modelId);
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getClothFightStand(modelId);
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getClothInjureDead(modelId);
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getClothFight(modelId);
										break;
								}
							}
							else 
							{
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getClothAtk(TypeRole.getDefaultSkin(roleDyVo.sex,roleDyVo.career));
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getClothFightStand(TypeRole.getDefaultSkin(roleDyVo.sex,roleDyVo.career));
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getClothInjureDead(TypeRole.getDefaultSkin(roleDyVo.sex,roleDyVo.career));
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getClothFight(TypeRole.getDefaultSkin(roleDyVo.sex,roleDyVo.career));
										break;
								}
							}
							actionData=SourceCache.Instance.getRes(url) as ATFActionData;
							if(actionData)	  //存在
							{
								useActionData.canUse=true;
							}
							else //不存在
							{
								SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
								SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:clothBasicId},flag);
								useActionData.canUse=false;
							}
							break;
						case EquipCategory.Weapon:
							if(weaponBasicId>0)
							{
								equipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(weaponBasicId);
								modelId=equipBasicVo.getModelId(roleDyVo.sex);
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getWeaponAtk(modelId);
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getWeaponFightStand(modelId);
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getWeaponInjureDead(modelId);
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getWeaponFight(modelId);
										break;
								}
								actionData=SourceCache.Instance.getRes(url) as ATFActionData;
								if(actionData)	
								{
									useActionData.canUse=true;
								}
								else 
								{
									SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
									SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:weaponBasicId},flag);
									useActionData.canUse=false;
								}
							}
							else ///不存在武器
							{
								useActionData.canUse=true;
							}
							break;
						case EquipCategory.Wing:
							if(wingBasicId>0)
							{
								equipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(wingBasicId);
								modelId=equipBasicVo.getModelId(roleDyVo.sex);
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getWingAtk(modelId);
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getWingFightStand(modelId);
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getWingInjureDead(modelId);
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getWingFight(modelId);
										break;
								}
								actionData=SourceCache.Instance.getRes(url) as ATFActionData;
								if(actionData)	
								{
									useActionData.canUse=true;
								}
								else 
								{
									SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
									SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:wingBasicId},flag);
									useActionData.canUse=false;
								}
							}
							else  //不存在翅膀
							{
								useActionData.canUse=true;
							}
							break;
						case EquipCategory.WeaponEffect: //武器特效  不管有没有武器特效 都可以显示
							//武器 强化等级
							var weaponEnHanceLevel:int=player.roleDyVo.weaponEnhanceLevel;
							var weaponEffectId:int=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Weapon,player.roleDyVo.sex,weaponEnHanceLevel,player.roleDyVo.career);
							if(weaponEffectId>0)//如果特效存在
							{
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getWeaponEffectAtk(weaponEffectId);
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getWeaponEffectFightStand(weaponEffectId);
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getWeaponEffectInjureDead(weaponEffectId);
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getWeaponEffectFight(weaponEffectId);
										break;
								}
								actionData=SourceCache.Instance.getRes(url) as ATFActionData;
								if(actionData)	
								{
									useActionData.canUse=true;
								}
								else 
								{
									SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
									SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:weaponEnHanceLevel},flag);
									useActionData.canUse=false;
								}
							}
							else ///不存在武器
							{
								useActionData.canUse=true;
							}
							break;
						case EquipCategory.ClothEffect:			//衣服特效 不管有没有衣服特效 都可以显示
							//衣服强化等级 
							var clothEnHanceLevel:int=player.roleDyVo.clothEnhanceLevel;
							var clothEffectId:int=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Cloth,player.roleDyVo.sex,clothEnHanceLevel,player.roleDyVo.career);
							if(clothEffectId>0)//如果特效存在
							{
								switch(atkType)
								{
									case TypeAction.SpecialAtk_1:  //特殊攻击
										url=URLTool.getClothEffectAtk(clothEffectId);
										break;
									case TypeAction.FightStand:  //战斗待机
										url=URLTool.getClothEffectFightStand(clothEffectId);
										break;
									case TypeAction.Injure: //如果为受击 
									case TypeAction.Dead: //如果为死亡
										url=URLTool.getClothEffectInjureDead(clothEffectId);
										break;
									case TypeAction.Attack: //如果为攻击
										url=URLTool.getClothEffectFight(clothEffectId);
										break;
									
								}
								actionData=SourceCache.Instance.getRes(url) as ATFActionData;
								if(actionData)	
								{
									useActionData.canUse=true;
								}
								else 
								{
									SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
									SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:clothEnHanceLevel},flag);
									useActionData.canUse=false;
								}
							}
							else ///不存在武器
							{
								useActionData.canUse=true;
							}
							break;
					}
					break;
				
				case TypeRole.BigCategory_Monster://怪物类型
					var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roleDyVo.basicId);
					switch(atkType)
					{
						case TypeAction.Injure: //如果为受击 
						case TypeAction.Dead: //如果为死亡
							url=URLTool.getMonsterInjureDead(monsterBasicVo.model_id);
							break;
						case TypeAction.Attack: //如果为攻击
							url=URLTool.getMonsterFight(monsterBasicVo.model_id);
							break;
					}
					actionData=SourceCache.Instance.getRes2(url,flag) as ATFActionData;
					if(actionData)	
					{
						useActionData.canUse=true;
					}
					else 
					{
						SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
						SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:roleDyVo.basicId},flag);
						useActionData.canUse=false;
					}
					break;
				case TypeRole.BigCategory_Pet://怪物类型
					var petConfigVo:PetBasicVo=PetBasicManager.Instance.getPetConfigVo(roleDyVo.basicId);
					switch(atkType)
					{
						case TypeAction.Injure: //如果为受击 
						case TypeAction.Dead: //如果为死亡
							url=URLTool.getMonsterInjureDead(petConfigVo.model_id);
							break;
						case TypeAction.Attack: //如果为攻击
							url=URLTool.getMonsterFight(petConfigVo.model_id);
							break;
					}
					actionData=SourceCache.Instance.getRes2(url,flag) as ATFActionData;
					if(actionData)	
					{
						useActionData.canUse=true;
					}
					else 
					{
						SourceCache.Instance.addEventListener(url,onUseActionDataComplete);
						SourceCache.Instance.loadRes(url,{player:player,equipType:equipType,atkType:atkType,id:roleDyVo.basicId},flag);
						useActionData.canUse=false;
					}
					break;
			}
			useActionData.actionData=actionData;
			return useActionData;
		}
		/**特殊动作1 加载完成
		 */	
		private function onUseActionDataComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onUseActionDataComplete);
			var arr:Vector.<Object>=e.param as Vector.<Object>;
			var player:PlayerView;
			var equipType:int; //装备类型
			var atkType:int; //特殊动作类型
			var id:int; ///  装备静态id 
			var actionData:ATFActionData=SourceCache.Instance.getRes(url) as ATFActionData;
			var clothBasicId:int;
			var weaponBasicId:int;
			var wingBasicId:int;
			for each(var obj:Object in arr)
			{
				if(obj)
				{
					player=obj.player;
					equipType=obj.equipType;
					atkType=obj.atkType;
					id=obj.id;
					if(isUseAblePlayer(player))
					{
						switch(player.roleDyVo.bigCatergory)
						{
							case TypeRole.BigCategory_Player:
								
								clothBasicId=player.roleDyVo.clothBasicId;
								weaponBasicId=player.roleDyVo.weaponBasicId;
								wingBasicId=player.roleDyVo.wingBasicId;
								switch(equipType)
								{
									case EquipCategory.Cloth:  //衣服特殊动作
										if(clothBasicId==id)
										{
											switch(atkType)
											{
												case TypeAction.SpecialAtk_1://特殊攻击 1 
													player.updateClothAtk_1(actionData);
													break;
												case TypeAction.FightStand:// 战斗待机
													player.updateClothFightStand(actionData);
													break;
												case TypeAction.Injure: //如果为受击 
												case TypeAction.Dead: //如果为死亡
													player.updateClothInjureDead(actionData);
													break;
												case TypeAction.Attack: //如果为攻击
													player.updateClothFight(actionData);
													break;
											}
										}
										break;
									case EquipCategory.Weapon://武器特殊动作
										if(weaponBasicId==id)
										{
											switch(atkType)
											{
												case TypeAction.SpecialAtk_1://特殊攻击 1 
													RolePlayerView(player).updateWeaponAtk_1(actionData);
													break;
												case TypeAction.FightStand:// 战斗待机
													RolePlayerView(player).updateWeaponFightStand(actionData);
													break;
												case TypeAction.Injure: //如果为受击 
												case TypeAction.Dead: //如果为死亡
													RolePlayerView(player).updateWeaponInjureDead(actionData);
													break;
												case TypeAction.Attack: //如果为攻击
													RolePlayerView(player).updateWeaponFight(actionData);
													break;
											}
										}
										break;
									case EquipCategory.Wing: //翅膀特殊动作
										if(wingBasicId==id)
										{
											switch(atkType)
											{
												case TypeAction.SpecialAtk_1://特殊攻击 1 
													RolePlayerView(player).updateWingAtk_1(actionData);
													break;
												case TypeAction.FightStand:// 战斗待机
													RolePlayerView(player).updateWingFightStand(actionData);
													break;
												case TypeAction.Injure: //如果为受击 
												case TypeAction.Dead: //如果为死亡
													RolePlayerView(player).updateWingInjureDead(actionData);
													break;
												case TypeAction.Attack: //如果为攻击
													RolePlayerView(player).updateWingFight(actionData);
													break;
											}
										}
									case EquipCategory.WeaponEffect: //武器光效
										var weaponEnHanceLevel:int=player.roleDyVo.weaponEnhanceLevel;
										if(weaponEnHanceLevel==id)
										{
											switch(atkType)
											{
												case TypeAction.SpecialAtk_1://特殊攻击 1 
													RolePlayerView(player).updateWeaponEffectAtk_1(actionData);
													break;
												case TypeAction.FightStand:// 战斗待机
													RolePlayerView(player).updateWeaponEffectFightStand(actionData);
													break;
												case TypeAction.Injure: //如果为受击 
												case TypeAction.Dead: //如果为死亡
													RolePlayerView(player).updateWeaponEffectInjureDead(actionData);
													break;
												case TypeAction.Attack: //如果为攻击
													RolePlayerView(player).updateWeaponEffectFight(actionData);
													break;
											}
										}
										break;
									case EquipCategory.ClothEffect: //衣服光效
										var clothEnHanceLevel:int=player.roleDyVo.clothEnhanceLevel;
										if(clothEnHanceLevel==id)
										{
											switch(atkType)
											{
												case TypeAction.SpecialAtk_1://特殊攻击 1 
													RolePlayerView(player).updateClothEffectAtk_1(actionData);
													break;
												case TypeAction.FightStand:// 战斗待机
													RolePlayerView(player).updateClothEffectFightStand(actionData);
													break;
												case TypeAction.Injure: //如果为受击 
												case TypeAction.Dead: //如果为死亡
													RolePlayerView(player).updateClothEffectInjureDead(actionData);
													break;
												case TypeAction.Attack: //如果为攻击
													RolePlayerView(player).updateClothEffectFight(actionData);
													break;
											}
										}
										break;
								}
								checkStayDead(player);
								break;
							case TypeRole.BigCategory_Monster:
							case TypeRole.BigCategory_Pet:
								if(id==player.roleDyVo.basicId)
								{
									switch(atkType)
									{
										case TypeAction.SpecialAtk_1://特殊攻击 1 
											player.updateClothAtk_1(actionData);
											break;
										case TypeAction.FightStand:// 战斗待机
											player.updateClothFightStand(actionData);
											break;
										case TypeAction.Injure: //如果为受击 
										case TypeAction.Dead: //如果为死亡
											player.updateClothInjureDead(actionData);
											break;
										case TypeAction.Attack: //如果为攻击
											player.updateClothFight(actionData);
											break;
									}
								}
								break;
						}
					}
				}
			}
		}
		
		
		/**
		 * 瞬步
		 */
		private function updateFight11(fightUIVo:FightUIPtVo):void
		{
			var atk:PlayerView=fightUIVo.atk;
			var uAtkInfoLen:int=fightUIVo.uAtkArr.length;
			var startX:Number=0;
			var startY:Number=0;
			var endPt:Point=new Point();
			
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var direction:int=TypeDirection.Right;
			if(isUseAblePlayer(atk))
			{
				startX=atk.roleDyVo.mapX;
				startY=atk.roleDyVo.mapY;
			}
			if(uAtkInfoLen>0)
			{
				direction=DirectionUtil.getDirection(startX,startY,fightUIVo.mapX,fightUIVo.mapY);
				direction=TypeDirection.getOppsiteDirection(direction);
			}
			if(isUseAblePlayer(atk))
			{
				//动画播放完后站的位置
				//开始瞬步
		//		atk.updateBlinkMove(fightUIVo.mapX,fightUIVo.mapY,30,completeFunc,{atk:atk,direction:direction});
				atk.skipTo(fightUIVo.mapX,fightUIVo.mapY);
				completeFunc({atk:atk,direction:direction});   //播放 战斗待机 或者待机
			}
			//播放  相关特效
			updateSpecailFight(startX,startY,fightUIVo);
		}
		
		
		/**冲锋
		 */
		private function updateFigh12(fightUIVo:FightUIPtVo):void
		{
			var atk:PlayerView=fightUIVo.atk;
			var uAtkInfoLen:int=fightUIVo.uAtkArr.length;
			var startX:Number=0;
			var startY:Number=0;
			var endPt:Point=new Point();
			
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var direction:int=TypeDirection.Right;
			if(isUseAblePlayer(atk))
			{
				startX=atk.roleDyVo.mapX;
				startY=atk.roleDyVo.mapY;
				if(atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)DataCenter.Instance.roleSelfVo.heroState.isLock=true;
			}
			if(uAtkInfoLen>0)
			{
				direction=DirectionUtil.getDirection(startX,startY,fightUIVo.mapX,fightUIVo.mapY);
			}
			if(isUseAblePlayer(atk))
			{
				//动画播放完后站的位置
				//开始瞬步
				atk.updateBlinkMove(fightUIVo.mapX,fightUIVo.mapY,25,completeFunc,{atk:atk,direction:direction});
			}
			//播放  相关特效
			updateSpecailFight(startX,startY,fightUIVo);
		}
		/** 瞬移
		 */		
		private function updateFight13(fightUIVo:FightUIPtVo):void
		{
			var atk:PlayerView=fightUIVo.atk;
			var sex:int=TypeRole.Sex_Man;
			var atkDirection:int=TypeDirection.Right;
			if(isUseAblePlayer(atk))
			{
				sex=atk.roleDyVo.sex;
				atkDirection=atk.activeDirection;
				var effectBasicVo:FightEffectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(sex,fightUIVo.skillId,fightUIVo.skillLevel);
				var url:String;
				var actionData:ATFActionData;
				
				/// 第一个点 也就是起始点的特效
				//攻击者最下层特效
				if(effectBasicVo.atkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkBackId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
					}
					else SourceCache.Instance.loadRes(url);
				}
				/// 第一个点 也就是起始点的特效
				//攻击者地面层
				if(effectBasicVo.atkFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkFloorId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						//					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
						LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkFloorTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//第二个点的特效
				//攻击者最上层
				if(effectBasicVo.atkSkyId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkSkyId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.SkySKillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkSkyTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				///第二个点的特效
				if(effectBasicVo.bgFloorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.bgFloorId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(fightUIVo.mapX,fightUIVo.mapY,actionData,effectBasicVo.bgFloorTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				//跟随特效
				if(effectBasicVo.atkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.atkFrontId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						atk.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false,effectBasicVo.atkFrontDirection,atkDirection);
					}
					else SourceCache.Instance.loadRes(url);
				}
			}

		}
		
		/**特殊  攻击    :   冲锋  瞬步   对目标攻击 单体   攻击者不播放攻击动作  其他所有都播
		 */
		private function updateSpecailFight(atkStartX:Number,atkStartY:Number,fightUIVo:FightUIPtVo):void
		{
			var atk:PlayerView=fightUIVo.atk;
			var sex:int=TypeRole.Sex_Man;
			var atkDirection:int=TypeDirection.Right;
			if(isUseAblePlayer(atk))
			{
				sex=atk.roleDyVo.sex;
				atkDirection=atk.activeDirection;
			}
			var effectBasicVo:FightEffectBasicVo=SkillBasicManager.Instance.getNormalFightEffectBasicVo(sex,fightUIVo.skillId,fightUIVo.skillLevel);
			var url:String;
			var actionData:ATFActionData;
			
			/// 第一个点 也就是起始点的特效
			//攻击者最下层特效
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
//					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
					LayerManager.BgSkillLayer.playEffect(atkStartX,atkStartY,actionData,effectBasicVo.atkBackTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			/// 第一个点 也就是起始点的特效
			//攻击者地面层
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
//					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
					LayerManager.BgSkillLayer.playEffect(atkStartX,atkStartY,actionData,effectBasicVo.atkFloorTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			//第二个点的特效
			//攻击者最上层
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.playEffect(fightUIVo.mapX,fightUIVo.mapY,actionData,effectBasicVo.atkSkyTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			///第二个点的特效
			if(effectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.bgFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(fightUIVo.mapX,fightUIVo.mapY,actionData,effectBasicVo.bgFloorTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			//跟随特效
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					atk.addFrontEffect(actionData,effectBasicVo.atkFrontTimeArr,false,effectBasicVo.atkFrontDirection,atkDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			// 处理受击者
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int ;
			if(isUseAblePlayer(atk))
			{
				oppsiteDirection=TypeDirection.getOppsiteDirection(atk.activeDirection);
			}
			else oppsiteDirection=-1; 
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state==TypeRole.State_Mount) uAtk.play(TypeAction.Stand,oppsiteDirection);
					else 
					{
						if(uAtkInfo.hp>0) 
						{
							if(!uAtkInfo.hasBeatBack)
							{
								handlePlayerInjureDeadLoading(uAtk);
								uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
							}
							else  //有 击退效果
							{
								handleBeatBack(uAtkInfo,0);
							}	
						}
						else 
						{
							handlePlayerInjureDeadLoading(uAtk);
							uAtk.pureStop();
							if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
							{
								uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
							{
								uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
							}
							handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
						}
					}
				}
				else 
				{
					if(uAtkInfo.hp>0)
					{
						
						if(!uAtkInfo.hasBeatBack)
						{
							handlePlayerInjureDeadLoading(uAtk);
							uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAktInjureComplete,{uAtk:uAtk});
						}
						else  //有 击退效果
						{
							handleBeatBack(uAtkInfo,0);
						}	
					}
					else 
					{
						handlePlayerInjureDeadLoading(uAtk);
						uAtk.pureStop();
						if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
						{
							uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
						{
							uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						handleDeadMoving(uAtk,atk,effectBasicVo.uAtkTimeArr[0]);
					}
				}
				uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,effectBasicVo.bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isReferToHero(atk,uAtk));
				////处理拉取效果
				//				handleSlide(atk,uAtk,fightSkillBasicVo);
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						uAtk=uAtkInfo.player;
						uAtk.addFrontEffect(actionData,effectBasicVo.uAtkFrontTimeArr,false)
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//当 为受击者 
				if(effectBasicVo.uAtkFloorId>0)///受击者地面
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		
		/**移除 场景鼠标效果
		 */		
		private function noticeRemoveMouseEffect():void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.RemoveMouseEffect);
		}
		
		/**副本里触发的辅助技能     攻击者 只需配 天空层特效   特效是从 屏幕中央开始发出的
		 * 魔神大炮
		 * fightEffectId
		 * fightUIVo 具有     uAtkArr   
		 */		
		public  function updateRaidSkill(fightEffectId:int,fightUIVo:FightUIPtVo):void
		{
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(fightEffectId);
			
			var url:String;
			var actionData:ATFActionData;
			/// 第一个点 也就是起始点的特效
		
			
			//第二个点的特效
			//攻击者最上层
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.playEffect(StageProxy.Instance.getWidth()*0.5,StageProxy.Instance.getHeight()*0.5,actionData,effectBasicVo.atkSkyTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			///第二个点的特效
			if(effectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.bgFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(StageProxy.Instance.getWidth()*0.5,StageProxy.Instance.getHeight()*0.5,actionData,effectBasicVo.bgFloorTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			// 处理受击者
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=-1 ;
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state==TypeRole.State_Mount) uAtk.play(TypeAction.Stand,oppsiteDirection);
					else  
					{ //处理 死亡
						handlePlayerInjureDeadLoading(uAtk);
						uAtk.pureStop();
						if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
						{
							uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
						{
							uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
						}
						handleDeadMoving(uAtk,null,effectBasicVo.uAtkTimeArr[0]);
					}
				}
				else 
				{
					//处理 死亡
					handlePlayerInjureDeadLoading(uAtk);
					uAtk.pureStop();
					if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player) ///为玩家 播放死亡
					{
						uAtk.splay(TypeAction.Dead,TypeDirection.DeafultDead,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
					}
					else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///为玩家 播放受击
					{
						uAtk.splay(TypeAction.Dead,oppsiteDirection,effectBasicVo.uAtkTimeArr,uAtkDeadComplete,{uAtk:uAtk});
					}
					handleDeadMoving(uAtk,null,effectBasicVo.uAtkTimeArr[0]);
				}
				uAtk.addBloodText(uAtkInfo.changeHp,uAtkInfo.hp,effectBasicVo.bloodArr,bloodComplete,uAtk,uAtkInfo.damageType,isRalativeToHero(uAtk));
				////处理拉取效果
				//				handleSlide(atk,uAtk,fightSkillBasicVo);
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						uAtk=uAtkInfo.player;
						uAtk.addFrontEffect(actionData,effectBasicVo.uAtkFrontTimeArr,false)
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//当 为受击者 
				if(effectBasicVo.uAtkFloorId>0)///受击者地面
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		
		/**副本里触发的辅助技能     攻击者 只需配 天空层特效   特效是从 屏幕中央开始发出的
		 * 魔神大炮  月井技能
		 * fightEffectId
		 * fightUIVo 具有     uAtkArr   atk
		 */		
		public  function updateRaidSkillYueJing(fightEffectId:int,fightUIVo:FightUIPtVo):void
		{
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(fightEffectId);
			
			var url:String;
			var actionData:ATFActionData;
			
			
			var atk:PlayerView=fightUIVo.atk;
			var sex:int=TypeRole.Sex_Man;
			var atkDirection:int=TypeDirection.Right;
			if(isUseAblePlayer(atk))
			{
				sex=atk.roleDyVo.sex;
				atkDirection=atk.activeDirection;
			}
			/// 第一个点 也就是起始点的特效
			//攻击者最下层特效
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			/// 第一个点 也就是起始点的特效
			//攻击者地面层
			if(effectBasicVo.atkFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					atk.addBackEffect(actionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			//第二个点的特效
			//攻击者最上层
			if(effectBasicVo.atkSkyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkSkyId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.SkySKillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.atkSkyTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			///第二个点的特效
			if(effectBasicVo.bgFloorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.bgFloorId);	
				actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					LayerManager.BgSkillLayer.playEffect(atk.roleDyVo.mapX,atk.roleDyVo.mapY,actionData,effectBasicVo.bgFloorTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
	
			
			// 处理受击者
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int ;
			if(isUseAblePlayer(atk))
			{
				oppsiteDirection=TypeDirection.getOppsiteDirection(atk.activeDirection);
			}
			else oppsiteDirection=-1; 
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				
				////处理拉取效果
				//				handleSlide(atk,uAtk,fightSkillBasicVo);
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
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
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						uAtk=uAtkInfo.player;
						uAtk.addFrontEffect(actionData,effectBasicVo.uAtkFrontTimeArr,false)
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//当 为受击者 
				if(effectBasicVo.uAtkFloorId>0)///受击者地面
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFloorId);	
					actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
					if(actionData)
					{
						LayerManager.BgSkillLayer.playEffect(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,actionData,effectBasicVo.uAtkFloorTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
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
				case TypeSkill.Fight_Effect_5:
					updateFight5(fightUIVo);
					break;
				case TypeSkill.Special_Fight_Effect_11:  //顺步
					updateFight11(fightUIVo);
					break;
				case TypeSkill.Special_Fight_Effect_12: //冲锋
					updateFigh12(fightUIVo);
					break;
				case TypeSkill.Special_Fight_Effect_13:  //瞬移
					updateFight13(fightUIVo);
					break;
			}
		}
		/**没有死亡的玩家
		 * @param player
		 */		
		private function isCanFightPlayer(player:PlayerView):Boolean
		{
			if(player)
			{
				if(!player.isDispose) 
				{
					if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
						if(player.isDead) return false;
					}
					return true;
				}
			}
			return false;
		}
		
		/**没有销毁的玩家 
		 */
		private function isUseAblePlayer(player:PlayerView):Boolean
		{
			if(player)
			{
				if(!player.isDispose) 
				{
					return true;
				}
			}
			return false;
		}
	}
}