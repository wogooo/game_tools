package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.PetPlayerView;
	import com.YFFramework.core.world.movie.player.PlayerView;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.FightSkillBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.FightSkillBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIVo;
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
		private function updateFight1(fightUIVo:FightUIVo):void
		{
			
			////获取特效数据
			var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getEffectBasicVo(fightSkillBasicVo.fightEffectId);
			playRoleAndFloorEffect(fightUIVo,fightSkillBasicVo,effectBasicVo);
			//天空层特效
			var positionType:int;
			var positionX:Number;
			var positionY:Number;
			
			var atk:PlayerView=fightUIVo.atk;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			if(effectBasicVo.skyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.skyId);	
				positionType=effectBasicVo.skyPositionType;   ///获取参照物类型
				if(positionType==TypeSkill.SkillPosition_Atk)
				{
					positionX=atk.roleDyVo.mapX+effectBasicVo.floorOffset[0];
					positionY=atk.roleDyVo.mapY+effectBasicVo.floorOffset[1];
					if(SourceCache.Instance.getRes(url))
					{
						LayerManager.BgSkillLayer.playEffect(positionX,positionY,SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.floorTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				else 
				{  //当 为受击者 
					for each (uAtkInfo in fightUIVo.uAtkArr)    ////对所有的受击对象做 动画
					{
						uAtk=uAtkInfo.player;
						positionX=uAtk.roleDyVo.mapX+effectBasicVo.floorOffset[0];
						positionY=uAtk.roleDyVo.mapY+effectBasicVo.floorOffset[1];
						if(SourceCache.Instance.getRes(url))
						{
							LayerManager.SkySKillLayer.playEffect(positionX,positionY,SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.floorTimeArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
				}
			}
			
		}
		
		/**播放人物 和 地面层的效果
		 */ 
		private function playRoleAndFloorEffect(fightUIVo:FightUIVo,fightSkillBasicVo:FightSkillBasicVo,effectBasicVo:FightEffectBasicVo):void
		{
			atkFight(fightUIVo,fightSkillBasicVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
			for each (uAtkInfo in fightUIVo.uAtkArr)
			{
				uAtk=uAtkInfo.player;
				if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					if(RoleDyVo(uAtk.roleDyVo).state==TypeRole.State_Mount) uAtk.play(TypeAction.Stand,oppsiteDirection);
					else uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,underAtackerComplete,{uAtk:uAtk});
				}
				else uAtk.splay(TypeAction.Injure,oppsiteDirection,effectBasicVo.uAtkTimeArr,underAtackerComplete,{uAtk:uAtk});
				//	print(this,"掉落血量"+uAtkInfo.hp);
				var bloodHpPercent:Number=uAtkInfo.hpPercent/10000; ///除以 10000进行还原  服务端 该数值乘以了 10000 所以这里需要乘以 10000
				if(uAtk.isDead)bloodHpPercent=0;
				uAtk.addBloodText(uAtkInfo.hp,bloodHpPercent,effectBasicVo.uAtkTimeArr[0]+200);
				////处理拉取效果
				handleSlide(atk,uAtk,fightSkillBasicVo);
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					if(SourceCache.Instance.getRes(url))
					{
						uAtk=uAtkInfo.player;
						uAtk.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.uAtkBackTimeArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					if(SourceCache.Instance.getRes(url))
					{
						uAtk=uAtkInfo.player;
						uAtk.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.uAtkFrontTimeArr,false)
					}
					else SourceCache.Instance.loadRes(url);
				}
			}
			//地面层特效
			var positionType:int;
			var positionX:Number;
			var positionY:Number;
			if(effectBasicVo.floorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.floorId);	
				positionType=effectBasicVo.floorPositionType;  ////  获取参照物类型
				if(positionType==TypeSkill.SkillPosition_Atk) ///
				{
					positionX=atk.roleDyVo.mapX+effectBasicVo.floorOffset[0];
					positionY=atk.roleDyVo.mapY+effectBasicVo.floorOffset[1];
					if(SourceCache.Instance.getRes(url))
					{
						LayerManager.BgSkillLayer.playEffect(positionX,positionY,SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.floorTimeArr,false);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				else 
				{  //当 为受击者 
					for each (uAtkInfo in fightUIVo.uAtkArr)    ////对所有的受击对象做 动画
					{
						uAtk=uAtkInfo.player;
						positionX=uAtk.roleDyVo.mapX+effectBasicVo.floorOffset[0];
						positionY=uAtk.roleDyVo.mapY+effectBasicVo.floorOffset[1];
						if(SourceCache.Instance.getRes(url))
						{
							LayerManager.BgSkillLayer.playEffect(positionX,positionY,SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.floorTimeArr,false);
						}	
						else SourceCache.Instance.loadRes(url);
					}
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
	
		
		private function underAtackerComplete(data:Object):void
		{
			var underAttacker:PlayerView=data.uAtk;
			if(underAttacker.isPool==false)
			{
				if(!underAttacker.isDead)underAttacker.play(TypeAction.Stand);
				else underAttacker.playDead();
				
			}
		}
		
		private function underAtackerDeadComplete(data:Object):void
		{
			var underAttacker:PlayerView=data.uAtk;
			if(underAttacker.isPool==false)
			{
				underAttacker.pureStop();
				underAttacker.playDead(underAttacker.activeDirection);
			}
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
			var fightUIVo:FightUIVo=data.fightUIVo as FightUIVo;
			var fightSkillBasicVo:FightSkillBasicVo=data.fightSkillBasicVo as FightSkillBasicVo;
			var attacker:PlayerView=fightUIVo.atk;
	//		print(this,"时间到达");
			if(!attacker.isPool)
			{	
				
			//	attacker.play(TypeAction.Stand);
				// 当为当前玩家时   
				if(attacker.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					///解除锁定
					DataCenter.Instance.roleSelfVo.heroState.isLock=false;
					if(DataCenter.Instance.roleSelfVo.heroState.willDo)
					{
						if(DataCenter.Instance.roleSelfVo.heroState.willDo is Point)	noticeWalk(DataCenter.Instance.roleSelfVo.heroState.willDo as Point);
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
		//					print(this,"动画播放完毕，准备下一次动作....");
						}
					}
					else 
					{
						///当为默认技能
					//	if(fightUIVo.skillId==SkillDyManager.Instance.getDefaultSkill())
						if(fightSkillBasicVo.atkType==TypeSkill.Atk_Single_Default||fightSkillBasicVo.atkType==TypeSkill.Atk_Single_One)
						{
			//				print(this,"11111");
					//		if(!DataCenter.Instance.roleSelfVo.heroState.isBreak)
					//		{
				//				print(this,"22222");
								if(fightUIVo.uAtkArr.length==1)
								{
					//				print(this,"3333");
									if(!fightUIVo.uAtkArr[0].player.isPool)
									{
						//				print(this,"进入下一次战斗");
										moveToPlayerForFight(fightUIVo.uAtkArr[0].player);
									}
						//		}
							}	
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
		private function handleSlide(atk:PlayerView,uAtk:PlayerView,fightSkillBasicVo:FightSkillBasicVo):void
		{
			var effectEndPt:Point;
			var effectDegree:Number; ///攻击者和受击者之间的距离
			var effectSpeed:int=15;///拉取速度
			var effectDirection:int;///站立方向
			if(fightSkillBasicVo.effectType==TypeSkill.Effect_Pull)  ///拉取
			{
				effectDegree=YFMath.getDegree(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,atk.roleDyVo.mapX,atk.roleDyVo.mapY);
				effectEndPt=YFMath.getLinePoint4(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,fightSkillBasicVo.effectLen,effectDegree);
				effectEndPt=GridData.Instance.getMoveToEndPoint(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
				if(effectEndPt)	effectDirection=DirectionUtil.getDirection(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
			}
			else if(fightSkillBasicVo.effectType==TypeSkill.Effect_push)/// 推开
			{
				effectDegree=YFMath.getDegree(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,atk.roleDyVo.mapX,atk.roleDyVo.mapY);
				effectEndPt=YFMath.getLinePoint3(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,fightSkillBasicVo.effectLen,effectDegree);
				effectEndPt=GridData.Instance.getMoveToEndPoint(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectEndPt.x,effectEndPt.y);
				if(effectEndPt)effectDirection=DirectionUtil.getDirection(effectEndPt.x,effectEndPt.y,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
			}
			if(effectEndPt)  ////能够进行拉取或者推离
			{
				uAtk.backSlideMoveTo(effectEndPt.x,effectEndPt.y,effectDirection,effectSpeed,moveToComplete,{uAtk:uAtk,direction:effectDirection},false,moveToComplete,{uAtk:uAtk,direction:effectDirection});
				///移除鼠标效果
				if(uAtk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) noticeRemoveMouseEffect();
			}
		}
		
		
		/**播放单一特效 比如骑上坐骑 升级   等等
		 */
		public function showEffect(playerView:PlayerView,skillId:int,skillLevel:int):void
		{
			var url:String;
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId);
			var fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(skillLevel));
			var effectBasicVo:FightEffectBasicVo=SkillDyManager.Instance.getFightEffectBasicVo(skillId,skillLevel);
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);
				if(SourceCache.Instance.getRes(url))
				{
					playerView.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.atkTimeArr,false,effectBasicVo.atkTotalTimes);
				}
				else SourceCache.Instance.loadRes(url);
			}
			if(effectBasicVo.atkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkBackId);
				if(SourceCache.Instance.getRes(url))
				{
					playerView.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.atkTimeArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
		}
		
		
		/**  定点  具有 一个目标点       受击者 技能播放 加上了技能的运动速度     一个运动技能   也就是造成直线攻击的效果
		 * 根据时间响应战斗      相应的是 运动技能的战斗  一条直线上的战斗 ,只有一个运动技能动画 ，    一个攻击完之后穿过去攻击另一个的效果   
		 */		
		private function updateFight2(fightUIVo:FightUIPtVo):void
		{
			////获取特效数据
			var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getEffectBasicVo(fightSkillBasicVo.fightEffectId);

			atkFight(fightUIVo,fightSkillBasicVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);

			/////处理  被攻击者的时间响应  
			
			var speed:int=fightSkillBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			var startX:int=atk.roleDyVo.mapX;
			var startY:int=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number=0;
			var distance:Number=0;
			
//			//最远距离
//			var maxX:Number;
//			var maxY:Number;
//			var maxDistance:Number=0;//最远距离
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
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
				endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
				distance=YFMath.distance(startX,startY,endX,endY);
				waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
				
				if(isPlayHit)
				{
//					if(distance>maxDistance)
//					{
//						maxDistance=distance;
//						maxX=endX;
//						maxY=endY;
//					}
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					if(uAtkInfo.hpPercent>0)uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,underAtackerComplete,{uAtk:uAtk});
					else 
					{
					//	uAtk.stopMove(oppsiteDirection);
						var _tweenSuperSkill:TweenSuperSkill=TweenSuperSkill.excute([waitTime],underAtackerDeadComplete,{uAtk:uAtk});
				//		uAtk.splay(TypeAction.Dead,uAtk.activeDirection,[waitTime]);
					}
				}
				else uAtk.play(TypeAction.Stand,oppsiteDirection);
				
				//		print(this,"掉落血量"+uAtkInfo.hp);
				var bloodHpPercent:Number=uAtkInfo.hpPercent/10000; ///除以 10000进行还原  服务端 该数值乘以了 10000 所以这里需要乘以 10000
				if(uAtk.isDead)bloodHpPercent=0;
				uAtk.addBloodText(uAtkInfo.hp,bloodHpPercent,uAtkTimesArr[0]+200);
				////处理拉取效果
				handleSlide(atk,uAtk,fightSkillBasicVo);     
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					if(SourceCache.Instance.getRes(url))
					{
//						uAtk=uAtkInfo.player;
//						endX=uAtk.roleDyVo.mapX;
//						endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//						distance=YFMath.distance(startX,startY,endX,endY);
//						waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					if(SourceCache.Instance.getRes(url))
					{
//						uAtk=uAtkInfo.player;
//						endX=uAtk.roleDyVo.mapX;
//						endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//						distance=YFMath.distance(startX,startY,endX,endY);
//						waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
					
				}
			}

			//// 处理天空层 或者地面层响应
			distance=YFMath.distance(startX,startY,fightUIVo.mapX,fightUIVo.mapY);
			waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
			//地面层特效
			if(effectBasicVo.floorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.floorId);	
				if(SourceCache.Instance.getRes(url))
				{
					LayerManager.BgSkillLayer.addSpeedEffect(startX,startY,fightUIVo.mapX,fightUIVo.mapY,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			//天空层特效
			if(effectBasicVo.skyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.skyId);	
				if(SourceCache.Instance.getRes(url))
				{
				//	waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
					LayerManager.SkySKillLayer.addSpeedEffect(startX,startY,fightUIVo.mapX,fightUIVo.mapY,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
				}	
				else SourceCache.Instance.loadRes(url);
			}
		}
		
		/**  根据时间响应战斗      相应的是 运动技能的战斗 多个运动技能动画 ，      一个受击者  一个运动技能动画 
		 *  不带目标点的攻击   
		 */		
		private function updateFight3(fightUIVo:FightUIVo):void
		{
			////获取特效数据
			var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getEffectBasicVo(fightSkillBasicVo.fightEffectId);

			atkFight(fightUIVo,fightSkillBasicVo,effectBasicVo);
			var atk:PlayerView=fightUIVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);

			var speed:int=fightSkillBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			
			var startX:int=atk.roleDyVo.mapX;
			var startY:int=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number;
			var distance:Number;
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			
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
				endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
				distance=YFMath.distance(startX,startY,endX,endY);
				waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);

				if(isPlayHit)
				{
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,underAtackerComplete,{uAtk:uAtk});
				}
				else uAtk.play(TypeAction.Stand,oppsiteDirection);
				
				//		print(this,"掉落血量"+uAtkInfo.hp);
				var bloodHpPercent:Number=uAtkInfo.hpPercent/10000; ///除以 10000进行还原  服务端 该数值乘以了 10000 所以这里需要乘以 10000
				if(uAtk.isDead)bloodHpPercent=0;
				uAtk.addBloodText(uAtkInfo.hp,bloodHpPercent,uAtkTimesArr[0]+200);
				////处理拉取效果
				handleSlide(atk,uAtk,fightSkillBasicVo); 
				//被攻击者最下层特效
				if(effectBasicVo.uAtkBackId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
					if(SourceCache.Instance.getRes(url))
					{
//						uAtk=uAtkInfo.player;
//						endX=uAtk.roleDyVo.mapX;
//						endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//						distance=YFMath.distance(startX,startY,endX,endY);
//						waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//被攻击者最上层特效
				if(effectBasicVo.uAtkFrontId>0)
				{
					url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
					if(SourceCache.Instance.getRes(url))
					{
//						uAtk=uAtkInfo.player;
//						endX=uAtk.roleDyVo.mapX;
//						endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//						distance=YFMath.distance(startX,startY,endX,endY);
//						waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						uAtkTimesArr=[];
						for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
						{
							uAtkTimesArr.push(myTime+waitTime);
						}
						uAtk.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
					}
					else SourceCache.Instance.loadRes(url);
				}
				
				//// 处理天空层 或者地面层响应
				//地面层特效
				if(effectBasicVo.floorId>0)
				{
					url=URLTool.getSkill(effectBasicVo.floorId);	
					if(SourceCache.Instance.getRes(url))
					{
				//		waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						LayerManager.BgSkillLayer.addSpeedEffect(startX,startY,endX,endY,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
					}	
					else SourceCache.Instance.loadRes(url);
				}
				//天空层特效
				if(effectBasicVo.skyId>0)
				{
					url=URLTool.getSkill(effectBasicVo.skyId);	
					if(SourceCache.Instance.getRes(url))
					{
				//		waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
						LayerManager.BgSkillLayer.addSpeedEffect(startX,startY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
					}	
					else SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		/**  攻击一个玩家    产生的效果是   技能多次攻击  就是多击效果  多个运动技能打到一个玩家身上
		 */		
		private function updateFight4(fightSimpleVo:FightUIVo):void
		{
			////获取特效数据
			var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(fightSimpleVo.skillId,fightSimpleVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getEffectBasicVo(fightSkillBasicVo.fightEffectId);
			
			atkFight(fightSimpleVo,fightSkillBasicVo,effectBasicVo);
			
			var atk:PlayerView=fightSimpleVo.atk;
			var url:String;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo=fightSimpleVo.uAtkArr[0];
			var oppsiteDirection:int=TypeDirection.getOppsiteDirection(atk.activeDirection);
			
			var speed:int=fightSkillBasicVo.speed; ///技能运行速度
			var waitTime:Number;///到达受击对象的时间
			var uAtkTimesArr:Array;//受击时间数组
			
			var startX:int=atk.roleDyVo.mapX;
			var startY:int=atk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
			var endX:int;
			var endY:int;
			var myTime:Number;
			var distance:Number;
			///被攻击者
			var isPlayHit:Boolean=false; ///是否播放受击动画
			uAtk=uAtkInfo.player;
			if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) isPlayHit=true;
			else if(uAtk.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
			{
				if(RoleDyVo(uAtk.roleDyVo).state!=TypeRole.State_Mount) isPlayHit=true;
			}
			///	if(!uAtk.roleDyVo.isMount) ///当不在坐骑上时
			endX=uAtk.roleDyVo.mapX;
			endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
			distance=YFMath.distance(startX,startY,endX,endY);
			waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
			uAtkTimesArr=[];
			if(isPlayHit)
			{
				for each(myTime in effectBasicVo.uAtkTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
				{
					uAtkTimesArr.push(myTime+waitTime);
				}
				uAtk.splay(TypeAction.Injure,oppsiteDirection,uAtkTimesArr,underAtackerComplete,{uAtk:uAtk});
			}
			else uAtk.play(TypeAction.Stand,oppsiteDirection);
			
			//		print(this,"掉落血量"+uAtkInfo.hp);
			var bloodHpPercent:Number=uAtkInfo.hpPercent/10000; ///除以 10000进行还原  服务端 该数值乘以了 10000 所以这里需要乘以 10000
			if(uAtk.isDead)bloodHpPercent=0;
			uAtk.addBloodText(uAtkInfo.hp,bloodHpPercent,uAtkTimesArr[0]+200);
			////处理拉取效果
			handleSlide(atk,uAtk,fightSkillBasicVo); 
			//被攻击者最下层特效
			if(effectBasicVo.uAtkBackId>0)
			{
				url=URLTool.getSkill(effectBasicVo.uAtkBackId);	
				if(SourceCache.Instance.getRes(url))
				{
//					uAtk=uAtkInfo.player;
//					endX=uAtk.roleDyVo.mapX;
//					endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//					distance=YFMath.distance(startX,startY,endX,endY);
//					waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkBackTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					uAtk.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			//被攻击者最上层特效
			if(effectBasicVo.uAtkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.uAtkFrontId);	
				if(SourceCache.Instance.getRes(url))
				{
//					uAtk=uAtkInfo.player;
//					endX=uAtk.roleDyVo.mapX;
//					endY=uAtk.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5;
//					distance=YFMath.distance(startX,startY,endX,endY);
//					waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
					uAtkTimesArr=[];
					for each(myTime in effectBasicVo.uAtkFrontTimeArr)   ////重新时间轴播放数组 加上 技能运动的时间
					{
						uAtkTimesArr.push(myTime+waitTime);
					}
					uAtk.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,uAtkTimesArr,false);
				}
				else SourceCache.Instance.loadRes(url);
			}
			
			//// 处理天空层 或者地面层响应
			//地面层特效
			if(effectBasicVo.floorId>0)
			{
				url=URLTool.getSkill(effectBasicVo.floorId);	
				if(SourceCache.Instance.getRes(url))
				{
			//		waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
					LayerManager.BgSkillLayer.addSuperSpeedEffect(startX,startY,endX,endY,effectBasicVo.skyTimeArr,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			//天空层特效
			if(effectBasicVo.skyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.skyId);	
				if(SourceCache.Instance.getRes(url))
				{
					waitTime=(distance+0.00001)*1000/(speed*UpdateManager.IntervalRate);
				//	LayerManager.BgSkillLayer.addSpeedEffect(startX,startY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,effectBasicVo.floorTotalTimes+waitTime,speed,SourceCache.Instance.getRes(url) as YF2dActionData);
					LayerManager.BgSkillLayer.addSuperSpeedEffect(startX,startY,endX,endY,effectBasicVo.skyTimeArr,speed,SourceCache.Instance.getRes(url) as YF2dActionData);

				}	
				else SourceCache.Instance.loadRes(url);
			}
		}

		/**更新   技能无速度 但有目标点  在    updateFight1  的 基础修改个 天空层的技能  天空层特效定位 是根据鼠标来定位的
		 * @param fightUIVo
		 */		
		private function updateFight5(fightUIPtVo:FightUIPtVo):void
		{
			////获取特效数据
			var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(fightUIPtVo.skillId,fightUIPtVo.skillLevel);
			var effectBasicVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getEffectBasicVo(fightSkillBasicVo.fightEffectId);
			playRoleAndFloorEffect(fightUIPtVo,fightSkillBasicVo,effectBasicVo);
			
			//天空层特效
			var atk:PlayerView=fightUIPtVo.atk;
			var uAtk:PlayerView;
			var uAtkInfo:UAtkInfo;
			var url:String;
			if(effectBasicVo.skyId>0)
			{
				url=URLTool.getSkill(effectBasicVo.skyId);	
				if(SourceCache.Instance.getRes(url))
				{
					LayerManager.BgSkillLayer.playEffect(fightUIPtVo.mapX,fightUIPtVo.mapY,SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.floorTimeArr,false);
				}	
				else SourceCache.Instance.loadRes(url);
			}
			
		}
			
		
		/**  攻击者的特效播放
		 */		
		private function atkFight(fightUIVo:FightUIVo,fightSkillBasicVo:FightSkillBasicVo,effectBasicVo:FightEffectBasicVo):void
		{
			////特效播放 
			var url:String;
			/// 强行终止函数
//			var myBreakFunc:Function=null;
			///当  玩家自己在攻击时  将自己锁住
//			if(fightUIVo.atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)   ////处于战斗状态 将其锁住
//			{
//				myBreakFunc=heroBreakFunc;
//			}
//			else if(fightUIVo.atk is PetPlayerView)
//			{
//				///当为自己的宠物时  进行锁住
//				if(PetPlayerView(fightUIVo.atk).isOwnPet())
//				{
//					myBreakFunc=petBreakFunc;
//				}
//			}
			
			var atk:PlayerView=fightUIVo.atk;
			var atkSKillDirection:int;///技能方向 当技能具有方向时 播放该方向的特效   一般是攻击者的技能具有方向
			if(fightUIVo.uAtkArr.length>0)
			{
				atkSKillDirection=DirectionUtil.getDirection(atk.roleDyVo.mapX,atk.roleDyVo.mapY,fightUIVo.uAtkArr[0].player.roleDyVo.mapX,fightUIVo.uAtkArr[0].player.roleDyVo.mapY);
			}
			else atkSKillDirection=-1;///使用 攻击者的默认方向 
			
			atk.stopMove();
			noticeRemoveMouseEffect();
		//	atk.splay(TypeAction.Attack,atk.activeDirection,effectBasicVo.atkTimeArr,completeFunc,{atk:atk},effectBasicVo.atkTotalTimes,atkTotalComplete,{fightUIVo:fightUIVo,fightSkillBasicVo:fightSkillBasicVo},myBreakFunc,atk);
			atk.splay(TypeAction.Attack,atk.activeDirection,effectBasicVo.atkTimeArr,completeFunc,{atk:atk},effectBasicVo.atkTotalTimes,atkTotalComplete,{fightUIVo:fightUIVo,fightSkillBasicVo:fightSkillBasicVo});
			
			if(fightUIVo.atk.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)   ////处于战斗状态 将其锁住
			{
				DataCenter.Instance.roleSelfVo.heroState.isLock=true;
		//		DataCenter.Instance.roleSelfVo.heroState.isBreak=false;
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
				if(SourceCache.Instance.getRes(url))
				{
					atk.addBackEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.atkBackTimeArr,false,TypeSkill.Skin_NoDirection,atkSKillDirection);
				}
				else SourceCache.Instance.loadRes(url);
			}
			//攻击者最上层
			if(effectBasicVo.atkFrontId>0)
			{
				url=URLTool.getSkill(effectBasicVo.atkFrontId);	
				if(SourceCache.Instance.getRes(url))
				{
					atk.addFrontEffect(SourceCache.Instance.getRes(url) as YF2dActionData,effectBasicVo.atkFrontTimeArr,false,effectBasicVo.atkFrontDirection,atkSKillDirection);
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
		 */		
		public function updateFight(atkType:int,fightUIVo:FightUIVo):void
		{
			switch(atkType)
			{
				case TypeSkill.Atk_Single_Default:
					///单一攻击
					updateFight1(fightUIVo);
					break;
				case TypeSkill.Atk_Single_One:
					///单一攻击
					updateFight1(fightUIVo);
					break;
				case TypeSkill.Atk_Single_MouseTarget:
					updateFight1(fightUIVo);
					break;
				case TypeSkill.Atk_Single_Much:
					updateFight4(fightUIVo);
					break;
				case TypeSkill.Atk_Circle_Pt_NoSpeed:
					updateFight5(FightUIPtVo(fightUIVo))
					break;
				case TypeSkill.Atk_Circle_NoPt_Speed:
					updateFight3(fightUIVo);
					break;
				case TypeSkill.Atk_Circle_NoPt_NoSpeed:
					updateFight1(fightUIVo);
					break;
				case TypeSkill.Atk_ThreeLine_Pt_Speed:
					updateFight3(fightUIVo);
					break;
				case TypeSkill.Atk_LineMore_Pt_Speed:
					updateFight2(FightUIPtVo(fightUIVo));
					break;
				
			}
			
		}
		
	}
}