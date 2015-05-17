package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.map.rectMap.findPath.AStar;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.BodyView;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yfComponent.controls.YFAlert;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.utils.tween.game.TweenSkill;
	import com.YFFramework.core.world.mapScence.bgMapEffect.BgMapEffectView;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.mapScence.map.BgMapView;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.MonsterMoveVo;
	import com.YFFramework.core.world.model.PlayerMoveResultVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	import com.YFFramework.core.world.movie.player.MonsterView;
	import com.YFFramework.core.world.movie.player.PetPlayerView;
	import com.YFFramework.core.world.movie.player.PlayerView;
	import com.YFFramework.core.world.movie.player.RolePlayerView;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.world.movie.thing.ThingEffectView;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.FightSkillBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.MountBasicManager;
	import com.YFFramework.game.core.global.manager.MountDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightSkillBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.MountBasicVo;
	import com.YFFramework.game.core.global.model.MountDyVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.FlyVo;
	import com.YFFramework.game.core.module.mapScence.model.MonsterDeadVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMorePtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightSingleResultVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightSingleVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.UAtkInfo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterWalkVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MountChangeResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MountChangeVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PlayerBeginMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.pet.manager.PetBasicManager;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetBasicVo;
	import com.YFFramework.game.core.module.pet.model.PetPlayResultVo;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**   处理角色战斗以及交互 
	 *  2012-7-13
	 *	@author yefeng
	 */
	public class MapScenceView
	{
		
		/**角色坐标拉取 当 角色的坐标和服务器发回来的坐标的距离大于PlayerPullLen 值时 进行坐标拉取， 一般在角色行走时需要判断是否进行坐标拉取
		 */ 
		private static const PlayerPullLen:int=80;
		///通知进行路径行走 的时间间隔 屏蔽快速点击 
		private static const NoticeMovePathInterval:int=250;
		
		/** 背景地图
		 */
		private var _bgMap:BgMapView;
		/**背景特效层
		 */
		private var _bgMapEffectView:BgMapEffectView;
		/** 点击地面产生的鼠标效果 
		 */
		private var _mouseEffect:ThingEffectView;
		/**  角色管理视图
		 */
		public var _senceRolesView:ScenceRolesView;
		/**战斗视图 
		 */
		private var _fightView:FightView;
		/**  地图配置是否已经加载完成 
		 */
		public static var _mapConfigLoadComplete:Boolean;
		/** a 星寻路
		 */
		private var _aStar:AStar;
		
		/** 鼠标悬停的对象
		 */
		private var _glowPlayer:PlayerView;
		
		/**控制点击 不要太频繁
		 */ 
		private var _noticeMovePathTime:Number=0;
		/**当前被攻击的对象  普通攻击
		 */ 
		private var _uAtkPlayer:PlayerView;
		public function MapScenceView()
		{
			initUI();
			addEvents();
		}
		private function initUI():void
		{
			_bgMap=new BgMapView();
			_bgMapEffectView=new BgMapEffectView();
			_senceRolesView=new ScenceRolesView();
			_fightView=new FightView();			
			initMouseEffectUI();
			_aStar=new AStar();
		}
		private function addEvents():void
		{
			///震动屏幕
			YFEventCenter.Instance.addEventListener(GlobalEvent.ScenceShake,onGlobleEvent);
			//// fightView 推拉角色，移除鼠标效果
			YFEventCenter.Instance.addEventListener(MapScenceEvent.RemoveMouseEffect,stopMouseEffect);
			//地图滚屏层  /// 单击场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.ScenceClick,onWalkMouseDown);
	//		LayerManager.PlayerLayer.addEventListener(MouseEvent.MOUSE_MOVE,onPlayerOver);
			/// 战斗时 通知角色 走到指定位置
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveTopt,heroMoveToPt);
			////小地图单击 点击 行走
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToPt,heroMoveToPt);
			///小地图点击 向 npc靠近
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToNPC,smallMapEvent);
			///小地图点击 攻击 怪物
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToMonster,smallMapEvent);
			////小地图点击飞鞋进行跳转
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKipToPlayer,smallMapSkipToEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKipToPoint,smallMapSkipToEvent);

			

			//向目标靠近 准备战斗
			YFEventCenter.Instance.addEventListener(MapScenceEvent.MoveToPlayerForFight,onMoveToplayerForFight);
			
			///主角请求打坐 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.RequestSit,onHeroRequest);
			///主角请求上坐骑
			YFEventCenter.Instance.addEventListener(MapScenceEvent.RequestMount,onHeroRequest);
			/////宠物 
			///人物进行移动带动宠物进行移动
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetMoving,onPetMovingEvent);
			////人物上下坐骑
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_0,onMountChage);
			/////键盘 技能事件
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_1,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_2,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_3,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_4,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_5,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_6,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_7,onKeyDownEvent);
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_8,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillTrigger,onTriggerSkill);
				
			///拾取某个范围内的物品
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownSpace,onKeyDownEvent);
			
			


		}
		
		private function onHeroRequest(e:YFEvent):void
		{
			switch(e.type)
			{
				case MapScenceEvent.RequestSit:
					print(this,"请求打坐");
					noticeRequestSit();
					break;
				case MapScenceEvent.RequestMount:
					print(this,"请求上坐骑");
					noticeMounting();
					break;
			}
		}
		
		/**请求打坐
		 */ 
		private function noticeRequestSit():void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_Sit)
		}
		/**离开打坐
		 */
		private function noticeOutSit():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Sit)
			{
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_OutSit);	
			}
		}
		
		/** 坐骑改变
		 */		
		private function onMountChage(e:YFEvent):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.state!=TypeRole.State_Mount)
			{
				///上坐骑
				noticeMounting();
			}
			else 
			{
				//下坐骑
				noticeMountOut();
			}
		}
		
		/**		改变人物坐骑状态  在技能 SkillKeyBoardView里面也有改变坐骑状态的 函数   下坐骑
		 *  下坐骑
		 */
		private function noticeMountOut():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount) 
			{
				//下坐骑
				var mountDyVo:MountDyVo=MountDyManager.Instance.getMounting();
				var mountChangeVo:MountChangeVo=new MountChangeVo();
				mountChangeVo.dyId=mountDyVo.dyId;
			//	mountChangeVo.state=TypeRole.State_Normal;
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_DisMounting,mountChangeVo);
			}
		}
		/**请求上坐骑
		 */		
		private function noticeMounting():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.state!=TypeRole.State_Mount) 
			{
				//上坐骑
				var mountDyVo:MountDyVo=MountDyManager.Instance.getAvailableMount();
				if(mountDyVo)
				{
					var mountChangeVo:MountChangeVo=new MountChangeVo();
					mountChangeVo.dyId=mountDyVo.dyId;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_Mounting,mountChangeVo);
				}
			}
		}

		/** 获取该点最上层的角色 不是主角    或者主角的宠物
		 */
		private function getPlayer(pt:Point):PlayerView
		{
			var  playerArr:Array
			var testPlayer:Object;
			playerArr=LayerManager.PlayerLayer.getObjectsUnderPoint(pt);///数组是从该点的最下层往最上层取的
			var len:int=playerArr.length;
		
			var petView:PetPlayerView;
			var canGet:Boolean; ///能否进行检测    不为当前玩家  或者 不为 玩家自己的宠物
			for (var i:int=len-1;i>=0;i--) //从最上层往最下层选择角色
			{
				testPlayer=playerArr[i];
				if(testPlayer is PlayerView|| testPlayer is BodyView)
				{
					if(testPlayer is BodyView)		   testPlayer=testPlayer.parent;
					if(testPlayer is PetPlayerView) petView=PetPlayerView(testPlayer);
					if(testPlayer!=_senceRolesView.heroView)
					{
						if(!testPlayer.isDead)
						{
							canGet=true;
							if(petView)  ///当获取的是宠物 判断是否为自己的宠物
							{
								if(petView.isOwnPet())canGet=false;
							}
							if(canGet)
							{
								if(testPlayer.getIntersect(pt,LayerManager.PlayerLayer)) 
								{
								//	testPlayer.glow=true;
									_glowPlayer=testPlayer as PlayerView;
									return testPlayer as PlayerView ;
								}
							//	else testPlayer.glow=false
							}
						//	else testPlayer.glow=false
						}
					//	else testPlayer.glow=false;
					}
				}
			}
		//	if(_senceRolesView.isUsablePlayer(_glowPlayer)) 	_glowPlayer.glow=false
			return null;
		}
		
		/** 切换 地图场景
		 * @param mapX
		 * @param mapY
		 */
		public function updateMapSenceView(mapX:int,mapY:int):void
		{
			_mapConfigLoadComplete=false;
			
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			////释放前一个场景的资源
			SourceCache.Instance.disposeAllResExcept(mapSceneBasicVo.mapId);
			//更新场景
			updateMapChange(mapSceneBasicVo,mapX,mapY);
		
			_glowPlayer=null;
			//地图配置文件没有加载完成
			//加载 xx文件
			var xxMapUrl:String=URLTool.getMapConfig(mapSceneBasicVo.resId);
			if(!SourceCache.Instance.getRes(xxMapUrl))
			{
				SourceCache.Instance.addEventListener(xxMapUrl,xxFileComplete);
				SourceCache.Instance.loadRes(xxMapUrl,mapSceneBasicVo);
			}
			else 
			{
				_mapConfigLoadComplete=true;
				initMapConfig(xxMapUrl);
			}
		}
		
		/** 初始化A星  url 是.xx文件的地址
		 * 背景特效场景 npc 
		 */
		private function initMapConfig(url:String):void
		{
			var data:Object=SourceCache.Instance.getRes(url);
		//	DataCenter.Instance.xxObj=data;
			var _time:Number=getTimer();
			///初始化 A星
			GridData.Instance.initData(data);
			_aStar.initData(GridData.Instance);
			print(this,"A星初始化耗时:"+(getTimer()-_time))
			//初始化背景特效场景   包括建筑 以及 传送点
			_bgMapEffectView.initData(data);
			///添加npc
			if(data.npc)_senceRolesView.handleNPCConfig(data.npc);
			
			_senceRolesView.checkNeededPlayerAlphaPoint();
			///发送给小地图模块进行处理 配置 文件加载完成
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MapConfigLoadComplete,data);
		}
		/** .xx地图文件加载完成
		 */		
		private function xxFileComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,xxFileComplete);
			_mapConfigLoadComplete=true;
			initMapConfig(url);

		}
		/**切换场景  mapX mapY 为主角切换场景后的 新坐标
		 */		
		private function updateMapChange(bgVo:MapSceneBasicVo,mapX:int,mapY:int):void
		{
			_bgMap.updateMapChange(bgVo); ///背景地图切换场景
			_bgMapEffectView.disposePreRes();///移除上一个场景的建筑特效
			_senceRolesView.updateMapChange();//角色管理 切换场景  移除场景人物
			///主角更新背景地图宽高 
			_senceRolesView.heroView.updateBgMapSize(bgVo.width,bgVo.height);
			///主角刷新坐标  
			_senceRolesView.heroView.setMapXY(mapX,mapY);
		}
		/**  创建鼠标交换
		 */
		private function initMouseEffectUI():void
		{
			_mouseEffect=new ThingEffectView();
			LayerManager.BgSkillLayer.addChild(_mouseEffect);
			_mouseEffect.initData(CommonFla.ClickEffectActionData);
		}
		/** 鼠标点击场景产生交互
		 */		
		private function onWalkMouseDown(e:YFEvent):void
		{
			var pt:Point=new Point(LayerManager.PlayerLayer.mouseX,LayerManager.PlayerLayer.mouseY);
			var target:PlayerView=getPlayer(pt);//myTaret as PlayerView;//
			DataCenter.Instance.roleSelfVo.heroState.willDo=null;
	//		DataCenter.Instance.roleSelfVo.heroState.isBreak=true;///技能中断
			if(!_senceRolesView.heroView.isDead)  ///当主角没有死亡
			{
				if(_mapConfigLoadComplete) /// 当地图配置文件加载完成后
				{
					var endX:int=LayerManager.BgMapLayer.mouseX;
					var endY:int=LayerManager.BgMapLayer.mouseY;
					if(!DataCenter.Instance.roleSelfVo.heroState.isLock)///当处于非战斗状态时
					{
						if(target)  ///当有吗吗 
						{
						//	if(target.roleDyVo.bigCatergory!=TypeRole.BigCategory_NPC)
							//党委
							if(TypeRole.CanFightAll(target.roleDyVo))	moveCloseToPlayerForFight(target);
							else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)	closeToPlayer(target);
							else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) closeToPlayer(target);
							return ;
						}
						else 
						{
							///进行寻路处理  
							heroMoveToPostion(endX,endY);
						}
				//		noticepetMoving();
					}
					else  ///处于战斗状态 
					{
						if(target) DataCenter.Instance.roleSelfVo.heroState.willDo=target;
						else DataCenter.Instance.roleSelfVo.heroState.willDo=new Point(endX,endY);
					}
				}
			}
			else print(this,"主角已经死亡 ,人物不能行走");
			
		}
		
		/**通知宠物进行移动
		 */
		private function noticepetMoving():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetMoving);
		}
			
		private function onMoveToplayerForFight(e:YFEvent):void
		{
			var playerView:PlayerView=e.param as PlayerView;
			if(!playerView.isPool)moveCloseToPlayerForFight(playerView);
		}
		
		/**靠近目标准备攻击
		 */ 
		private function moveCloseToPlayerForFight(target:PlayerView):void
		{
			var startTilePt:Point;
			var endTilePt:Point;
			var path:Array;
			///获取默认技能id 
			var defalutSKillId:int=SkillDyManager.Instance.getDefaultSkill();
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(defalutSKillId);
			var fightSKillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
			
			var distance:Number=YFMath.distance(HeroProxy.mapX,HeroProxy.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY);
			//	if(distance<=150+15)
			if(distance<=fightSKillBasicVo.range+15)
			{
				//进行攻击
				triggerSKill(skillDyVo.skillId,skillDyVo.skillLevel,target);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
			}
			else 
			{ 	
				////向人物靠近  走到 pt 位置 
				var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,fightSKillBasicVo.range-15);
				var endX:Number=pt.x
				var endY:Number=pt.y;
				//进行攻击处理
//				startTilePt=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
//				endTilePt=RectMapUtil.getTilePosition(endX,endY);
//				if(_aStar.seachPath(startTilePt,endTilePt))
//				{
//					path=_aStar.getPath();
//					//	drawPath(path,LayerManager.DrawPathLayer);
//					DataCenter.Instance.roleSelfVo.heroState.willDo=target;
//					noticeMovePath(path);
//				}	
				path=heroMoveToPostion(endX,endY);
				if(path) DataCenter.Instance.roleSelfVo.heroState.willDo=target;
			}
			
		}

		
		/** 向活动对象靠近  向  npc靠近 或者向 掉落物品靠近
		 * 向玩家靠近
		 * len   距离目标玩家的距离
		 */		
		private function closeToPlayer(target:PlayerView,len:int=90):void
		{
			var startTilePt:Point;
			var endTilePt:Point;
			var path:Array;
			////向人物靠近  走到 pt 位置 
			var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,len-15);
			var endX:Number=pt.x
			var endY:Number=pt.y;
			var distance:Number=YFMath.distance(HeroProxy.mapX,HeroProxy.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY);
			if(distance<=len+15)
			{
				if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)	noticeNPCHandle(target.roleDyVo.basicId);
				else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) noticeGetGropGoods(target.roleDyVo.dyId);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
			}
			else 
			{
				//进行寻路处理
//				startTilePt=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
//				endTilePt=RectMapUtil.getTilePosition(endX,endY);
//				if(_aStar.seachPath(startTilePt,endTilePt))
//				{
//					path=_aStar.getPath();
//					//	drawPath(path,LayerManager.DrawPathLayer);
//					DataCenter.Instance.roleSelfVo.heroState.willDo=target;
//					noticeMovePath(path);
//				}		
				path=heroMoveToPostion(endX,endY);
				if(path) DataCenter.Instance.roleSelfVo.heroState.willDo=target;

			}
		}
		
		/** 通知其他模块对npc进行处理
		 */		
		private function noticeNPCHandle(NPCBasicId:int):void
		{
			print(this,"处理npc窗口");
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.NPCClicker,NPCBasicId);

		}
		/***通知服务端拾取掉落物品
		 */ 
		private function noticeGetGropGoods(dyId:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_GetDropGoods,{id:dyId});
		}
				
		
		
		/**停止鼠标特效
		 */		
		private function stopMouseEffect(e:YFEvent=null):void
		{
			if(LayerManager.BgSkillLayer.contains(_mouseEffect))	LayerManager.BgSkillLayer.removeChild(_mouseEffect);
			_mouseEffect.stop();

		}
		
		/**鼠标点击目标点提示
		 */
		private function startMouseEffect(mapX:int,mapY:int):void
		{
			if(!LayerManager.BgSkillLayer.contains(_mouseEffect))LayerManager.BgSkillLayer.addChild(_mouseEffect);
			_mouseEffect.start();
			_mouseEffect.playDefault();
			_mouseEffect.setMapXY(mapX,mapY);
		}
		
//		private  function drawPath(vect:Vector.<Point>,layer:Sprite):void
//		{
//			layer.graphics.clear();
//			 for each  (var pt:Point in vect)
//			 {
//				 Draw.DrawCircle(layer.graphics,10,pt.x,pt.y,0xFF0000,1,NaN,false);
//			 }
//		}
		private function smallMapEvent(e:YFEvent):void
		{
		 	var dyId:String=String(e.param); 
			var view:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
			if(_senceRolesView.isUsablePlayer(view))
			{
				switch(e.type)
				{
					case GlobalEvent.SmallMapMoveToNPC: ///向NPC 靠近
						closeToPlayer(view);
						break;
					case GlobalEvent.SmallMapMoveToMonster: //小地图点击攻击怪物
						moveCloseToPlayerForFight(view);
						break;
				}
			}
		}
		/**
		 * @param e 地图跳转
		 */		
		private function smallMapSkipToEvent(e:YFEvent):void
		{
			var pt:Point;
			var dyId:String;
			switch(e.type)
			{
				case GlobalEvent.SKipToPoint: ///跳到目标点
					pt=e.param as Point;
					noticeSkipToPoint(pt);
					break;
				case GlobalEvent.SKipToPlayer:   ///跳转到目标玩家
					dyId=String(e.param);
					var view:PlayerView=_senceRolesView.totalViewDict[dyId];
					var roleDyVo:MonsterDyVo=view.roleDyVo;
					pt=new Point(roleDyVo.mapX,roleDyVo.mapY);
					noticeSkipToPoint(pt);
					DataCenter.Instance.roleSelfVo.heroState.willDo=view;
					break;
			}
		}

		
		
		/** 跳转 进行跳转时  主角需要先停止移动
		 */
		private function noticeSkipToPoint(pt:Point):void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_SKipToPoint,pt);
		}
		/**主角停止移动
		 */		
//		private function noticeHeroStopMove():void
//		{
//			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroStopMove);
//		}
		
		
		
		
		
		/**人物角色走到目标点
		 */
		private function heroMoveToPt(e:YFEvent):void
		{
			var pt:Point=e.param as Point;
			heroMoveToPostion(pt.x,pt.y);
			DataCenter.Instance.roleSelfVo.heroState.willDo=null;
		}
		/**通知小地图进行路径行走
		 */		
		private function noticeSmallMapMovePath(path:Array):void
		{
			///将数据传给 smallMapView
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapGetMovePath,path);   

		}
		
		private function heroMoveToPostion(endX:int,endY:int):Array
		{
			noticeOutSit();//如果为打坐取消打坐
			
			var path:Array;
			var startTilePt:Point=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
			var endTilePt:Point=RectMapUtil.getTilePosition(endX,endY);
			if(_aStar.seachPath(startTilePt,endTilePt))
			{
				path=_aStar.getPath();
				noticeMovePath(path);
				noticeSmallMapMovePath(path);
			}
			return path;
		}
		/**通讯告知开始pk   攻击者     群攻 无点 群攻
		 */
		private function noticeFightMore(fightVo:FightMoreVo):void
		{
			noticeMountOut();///如果在马上 就进行下马攻击
			noticeOutSit();//如果为打坐取消打坐
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore,fightVo);
		}
		/** 通讯告知开始pk   有点 群攻
		 */		
		private function noticeFightMorePt(fightVo:FightMorePtVo):void
		{
			noticeMountOut();///如果在马上 就进行下马攻击
			noticeOutSit();//如果为打坐取消打坐
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore_Pt,fightVo);
		}
		/** 通讯告知开始pk  单人pk   只有一个受击对象
		 */
		private function noticeFightSingle(fightVo:FightSingleVo):void
		{
			noticeMountOut();///如果在马上 就进行下马攻击
			noticeOutSit();//如果为打坐取消打坐
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightSingle,fightVo);
		}
		
		/** 多模块交互通讯
		 */		
		private function onGlobleEvent(e:YFEvent=null):void
		{
			switch(e.type)
			{
				case GlobalEvent.ScenceShake:
					_senceRolesView.heroView.shake();
					break;
			}
		} 
		
		private function blinkMoveComplete(data:Object):void
		{
			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
			//		if(DataCenter.Instance.roleSelfVo.willGoPt)	senceRolesView.heroView.moveTo(DataCenter.Instance.roleSelfVo.willGoPt.x,DataCenter.Instance.roleSelfVo.willGoPt.y,6,complete);
		}
		/** 主角移动结束
		 */		
		private function heroMovingComplete(param:Object):void
		{
			stopMouseEffect();
			_senceRolesView.heroView.play(TypeAction.Stand);
			
			var willDo:PlayerView=DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView;
			///进行攻击
			if(_senceRolesView.isUsablePlayer(willDo)) 
			{
				///对人物进行攻击 
			//	if(willDo.roleDyVo.bigCatergory!=TypeRole.BigCategory_NPC)
				///对人物进行攻击 
				if(TypeRole.CanFightAll(willDo.roleDyVo))
					moveCloseToPlayerForFight(DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView);
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC) ///处理npc 任务 
				{
					//	处理 npc 
					noticeNPCHandle(willDo.roleDyVo.basicId);
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) ///处理物品掉落 任务
				{
					noticeGetGropGoods(willDo.roleDyVo.dyId);
				}
			}
			else   ///切换 地图场景判断
			{
				var mapX:int=_senceRolesView.heroView.roleDyVo.mapX;
				var mapY:int=_senceRolesView.heroView.roleDyVo.mapY;
				///如果该点为地图跳转点则进行消息发送并且进行地图跳转
				if(GridData.Instance.isSkipNode(mapX,mapY))
				{
				//	noticeChangeMap(DataCenter.Instance.bgMapVo.mapId,mapX,mapY);
					noticeChangeMap();
				}
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
			}
		}
		/**通知服务端进行场景 切换 
		 */
		private function noticeChangeMap():void
		{
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_ChangeMapScence);
		}
		/**通知服务端 主角色发生移动 通知客户端进行广播 
		 */
		private function noticeMovePath(path:Array):void
		{
			if(getTimer()-_noticeMovePathTime>=NoticeMovePathInterval)
			{
				//主角直接走路
				var heroId:String=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
				var mapX:int=DataCenter.Instance.roleSelfVo.roleDyVo.mapX;
				var mapY:int=DataCenter.Instance.roleSelfVo.roleDyVo.mapY;
				//通知所有玩家走路
				///优化路径发送  只发3个点  
				var pathLen:int=path.length;
				if(pathLen>3)pathLen=3;
				var msgPath:Array=path.slice(0,pathLen);
				var  playerMoveVo:PlayerBeginMoveVo=PoolCenter.Instance.getFromPool(PlayerBeginMoveVo) as PlayerBeginMoveVo;
				playerMoveVo.path=msgPath;
				playerMoveVo.curentPostion=new Point(mapX,mapY);
				var speed:int;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount)
				{
					var mountDyVo:MountDyVo=MountDyManager.Instance.getMounting();
					var mountBasicVo:MountBasicVo=MountBasicManager.Instance.getMountBasicVo(mountDyVo.basicId);
				//	speed=DataCenter.Instance.roleSelfVo.speedManager.mountSpeed;
					speed=mountBasicVo.speed;
				}
				else 
				{
					speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
				}
				playerMoveVo.speed=speed
		//		YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroBeginMovePath,playerMoveVo);  // 玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
				//	print(this,"玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug");
				_noticeMovePathTime=getTimer();
				////主角先移动  
				_senceRolesView.heroView.setMovingIndex();
				var playerMoveResultVo:PlayerMoveResultVo=PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
				playerMoveResultVo.id=_senceRolesView.heroView.roleDyVo.dyId;
				playerMoveResultVo.mapX=mapX;
				playerMoveResultVo.mapY=mapY;
				playerMoveResultVo.speed=speed;
				playerMoveResultVo.path=path;
				updatePlayerMovePath(playerMoveResultVo,false,false);
				playerMoveResultVo.disposeToPool();
				///更新主角当前的状态   当为坐骑状态时切换坐骑状态
				if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Sit)DataCenter.Instance.roleSelfVo.roleDyVo.state=TypeRole.State_Normal;
			}
		}
		
		/**主角发生移动  判断 主角和其宠物之间的距离 是否超过他们之间的距离    宠物 移动 逻辑 
		 */ 
		private function onPetMovingEvent(e:YFEvent):void
		{
			var fightPlayerArr:Array=PetDyManager.Instance.getFightPlayer();
			var dyId:String;
			var petPlayView:PetPlayerView;///出战宠物
			var distance:Number;
			var endPoint:Point;
			var startPoint:Point;
			var path:Array;
			var speed:int;
			var degree:int;
			var len:int =fightPlayerArr.length;
			var petIndex:int=0;///宠物索引   第几个宠物 
			var degreeArr:Array=DirectionUtil.getDegreeArr(HeroProxy.direction,len); ///人物站立的方向 所对应的宠物方向角度数组
			for each (dyId in fightPlayerArr)
			{
				petPlayView=_senceRolesView.totalViewDict[dyId] as PetPlayerView;
				if(petPlayView)
				{
					//宠物跟随
					distance=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
					if(!petPlayView.isLock) ///当宠物没有锁住时
					{
						///比较距离
						if(petPlayView.activeDirection!=HeroProxy.direction&&distance<=PetPlayerView.Distance)
						{
							distance=PetPlayerView.Distance+50;
						}
						if(distance>=PetPlayerView.Distance&&distance<=PetPlayerView.MaxDistance)
						{
							//	endPoint=YFMath.getLinePoint(petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY,HeroProxy.mapX,HeroProxy.mapY,PetBasicManager.MinDistance);
							
							///当只出战了一个宠物
							if(len==1) 
							{
								degree=degreeArr[0];
							}
							else if(len==2)  /// 当出战2个宠物
							{
								if(petIndex==0) 
								{
									degree=degreeArr[0];
								}
								else  degree=degreeArr[1];
							}
							else if(len==3)  /// 当出战3个宠物
							{
								if(petIndex==0) degree=degreeArr[0];
								else if(petIndex==1)  degree=degreeArr[1];
								else degree =degreeArr[2];
							}
							endPoint=YFMath.getLinePoint3(HeroProxy.mapX,HeroProxy.mapY,PetPlayerView.MinDistance,degree);
							endPoint=RectMapUtil.getTilePosition(endPoint.x,endPoint.y);///获取 节点 
							endPoint=GridData.Instance.getUsablePt(endPoint);
							startPoint=RectMapUtil.getTilePosition(petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
							_aStar.seachPath(startPoint,endPoint);
							path=_aStar.getPath();
							speed=PetBasicManager.Instance.getPetBasicVo(petPlayView.roleDyVo.basicId).speed;
							petPlayView.setMoving(HeroProxy.direction);////设置通讯通讯索引
							petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroProxy.direction});
						//	print(this,"宠物进行正常移动 ！");
						}
					}
					if(distance>PetPlayerView.MaxDistance)
					{
						print(this,"拉取宠物");
						degree=DirectionUtil.getDirectionDegree(HeroProxy.direction);
						endPoint=YFMath.getLinePoint3(HeroProxy.mapX,HeroProxy.mapY,PetPlayerView.MinDistance,degree);
					//	endPoint为 地图坐标
						petPlayView.noticePullPet(endPoint.x,endPoint.y);
					}
				}
				petIndex++;
			}
		}		

		/**宠物向目标玩家靠近 准备发起攻击 
		 */ 
		public function updatePetMoveToTarget(petId:String,targetId:String):void
		{
			var targetPlayer:PlayerView=_senceRolesView.totalViewDict[targetId] as PlayerView;
			if(targetPlayer)
			{
				var petPlayView:PetPlayerView=_senceRolesView.totalViewDict[petId] as PetPlayerView;
				var petBasicVo:PetBasicVo=PetBasicManager.Instance.getPetBasicVo(petPlayView.roleDyVo.basicId);
				//			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(petBasicVo.defaultSkill);
				//			var fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(1)); //获取技能属性
				
				var degree:Number=YFMath.getDegree(targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY,petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
				var endPoint:Point=YFMath.getLinePoint4(targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY,80,degree); ///走到80位置处
				endPoint=RectMapUtil.getTilePosition(endPoint.x,endPoint.y);///获取 节点 
				endPoint=GridData.Instance.getUsablePt(endPoint);
				var startPoint:Point=RectMapUtil.getTilePosition(petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
				_aStar.seachPath(startPoint,endPoint);
				var path:Array=_aStar.getPath();
				var speed:int=petBasicVo.speed;
				petPlayView.setMoving(HeroProxy.direction);////设置通讯通讯索引
				petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroProxy.direction});
			}
		}
		

		/**更新拉取宠物
		 */		
		public function updatePullPet(pullPetVo:PullPetVo):void
		{
			print(this,"服务端返回拉取宠物");
			var petView:PetPlayerView=_senceRolesView.totalViewDict[pullPetVo.dyId] as PetPlayerView;
			petView.skipTo(pullPetVo.mapX,pullPetVo.mapY);
		}
		/**更新宠物出战
		 */ 
		public function updatePetPlay(perResultVo :PetPlayResultVo):void
		{
			var petPlayView:PetPlayerView=_senceRolesView.totalViewDict[perResultVo.dyId] as PetPlayerView
			petPlayView.updateTarget(true);
		}
		/**更新怪物的战斗  怪物发起的战斗
		 */ 
		public function updateMonsterFight(fightResultVo:FightMoreResultVo):void
		{
			///停止怪物 的移动 
			var monster:MonsterView=_senceRolesView.totalViewDict[fightResultVo.atkId] as MonsterView;
			if(monster)	monster.stopMove();
			////开始战斗
			updateFightMore(fightResultVo);	
		}

		
		private function getUAtkInfoArr(arr:Array):Vector.<UAtkInfo>
		{
			var playerView:PlayerView;
			var uAtkInfo:UAtkInfo;
			var uAtkArr:Vector.<UAtkInfo>=new Vector.<UAtkInfo>();
			for each (var fightHurtVo:Object in arr)
			{
				playerView=_senceRolesView.totalViewDict[fightHurtVo.dyId] as PlayerView;
				if(playerView)
				{
					if(!playerView.isPool) 
					{
						///当为主角玩家时  对他进行解锁
						uAtkInfo=new UAtkInfo();
						uAtkInfo.player=playerView;
						uAtkInfo.hp=fightHurtVo.hp;
						uAtkInfo.hpPercent=fightHurtVo.hpPercent;
						uAtkArr.push(uAtkInfo);
					}
				}
			}
			return uAtkArr;
		}
		
		/**  跳到目标点
		 */		
		public function updateSkipToPoint(pt:Point):void
		{
			stopMouseEffect();
			_senceRolesView.heroView.skipTo(pt.x,pt.y);
			var willDo:PlayerView=DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView;
			if(_senceRolesView.isUsablePlayer(willDo))
			{
				if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC) ///处理npc 任务 
				{
					//	处理 npc 
					noticeNPCHandle(willDo.roleDyVo.basicId);
				}
			}
		}
		
		
		/**更新移形换影 
		 */ 
		public function updateBlinkMove(blinkResultVo:BlinkMoveResultVo):void
		{
			var player:RolePlayerView=_senceRolesView.totalViewDict[blinkResultVo.dyId] as RolePlayerView;
			if(player)
			{
				checkPullPlayer(blinkResultVo.mapX,blinkResultVo.mapY,player);
				player.updateBlinkMove(blinkResultVo.endX,blinkResultVo.endY,null,null,true);
			}
		}
		
		/**更新战斗  指的是 玩家发起的战斗
		 */
		public function updateFightMore(fightResultVo:FightMoreResultVo):void
		{
			var attacker:PlayerView=_senceRolesView.totalViewDict[fightResultVo.atkId] as PlayerView;
			var uAtkArr:Vector.<UAtkInfo>=getUAtkInfoArr(fightResultVo.uAtkArr);
			if(attacker)
			{
				if(uAtkArr.length>0&&attacker.isPool==false)
			//	if(attacker.isPool==false)
				{
					///改变攻击者方向
					var targetPlayer:PlayerView=uAtkArr[0].player;
					var direction:int=DirectionUtil.getDirection(attacker.roleDyVo.mapX,attacker.roleDyVo.mapY,targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY);
					attacker.play(TypeAction.Stand,direction,true,null,null,true);
					///开始播放特效
					////进行vo转化
					var fightUIVo:FightUIVo=PoolCenter.Instance.getFromPool(FightUIVo,null) as FightUIVo;
					fightUIVo.atk=attacker;
					fightUIVo.uAtkArr=uAtkArr;
					fightUIVo.skillId=fightResultVo.skillId;
					fightUIVo.skillLevel=fightResultVo.skillLevel;
					
					var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightResultVo.skillId);
					var fightSKillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(fightResultVo.skillLevel));
					_fightView.updateFight(fightSKillBasicVo.atkType,fightUIVo);
				}
			}
			fightResultVo.disposeToPool();	
		}
		public function updateFightMorePt(fightResultVo:FightMorePtResultVo):void
		{
			var attacker:PlayerView=_senceRolesView.totalViewDict[fightResultVo.atkId] as PlayerView;
			var uAtkArr:Vector.<UAtkInfo>=getUAtkInfoArr(fightResultVo.uAtkArr);
			if(attacker)
			{
				if(attacker.isPool==false)
				{
					///改变攻击者方向
					var direction:int=DirectionUtil.getDirection(attacker.roleDyVo.mapX,attacker.roleDyVo.mapY,fightResultVo.mapX,fightResultVo.mapY);
					attacker.play(TypeAction.Stand,direction,true,null,null,true);
					///开始播放特效
					var fightUIPtVo:FightUIPtVo=PoolCenter.Instance.getFromPool(FightUIPtVo,null) as FightUIPtVo;
					fightUIPtVo.atk=attacker;
					fightUIPtVo.uAtkArr=uAtkArr;
					fightUIPtVo.skillId=fightResultVo.skillId;
					fightUIPtVo.skillLevel=fightResultVo.skillLevel;
					fightUIPtVo.mapX=fightResultVo.mapX;
					fightUIPtVo.mapY=fightResultVo.mapY;
					
					var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightResultVo.skillId);
					var fightSKillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(fightResultVo.skillLevel));
					_fightView.updateFight(fightSKillBasicVo.atkType,fightUIPtVo);
				}
			}
			fightResultVo.disposeToPool();		
		}
		
		
		public function updateFightSingle(fightResultVo:FightSingleResultVo):void
		{
			var attacker:PlayerView=_senceRolesView.totalViewDict[fightResultVo.atkId] as PlayerView;
			var hurtVoArr:Array=[fightResultVo.fightHurtVo];
			var uAtkArr:Vector.<UAtkInfo>=getUAtkInfoArr(hurtVoArr);
			if(attacker)
			{
				if(uAtkArr.length>0&&attacker.isPool==false)
				{
					///改变攻击者方向
					///改变攻击者方向
					var targetPlayer:PlayerView=uAtkArr[0].player;
					_uAtkPlayer=targetPlayer;///当前可以攻击的对象
					var direction:int=DirectionUtil.getDirection(attacker.roleDyVo.mapX,attacker.roleDyVo.mapY,targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY);
					attacker.play(TypeAction.Stand,direction,true,null,null,true);
					///开始播放特效
					var fightUIVo:FightUIVo=PoolCenter.Instance.getFromPool(FightUIVo,null) as FightUIVo;
					fightUIVo.atk=attacker;
					fightUIVo.uAtkArr=uAtkArr;
					fightUIVo.skillId=fightResultVo.skillId;
					fightUIVo.skillLevel=fightResultVo.skillLevel;
					var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightResultVo.skillId);
					var fightSKillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(fightResultVo.skillLevel));
					_fightView.updateFight(fightSKillBasicVo.atkType,fightUIVo);
					
				}
			}
			fightResultVo.disposeToPool();		
		}
		
		
		/**角色发生移动
		 * playerId 移动的角色id 
		 * path 移动的路径
		 * speed移动速度
		 * currentPosition   角色当前坐标
		 * complete 移动结束后触发的函数  默认触发函数是 playerMoveComplete;   complete的参数 是 player
		 * forceUpdate  表示 是否 一调用 就立刻开始 渲染 改变位置  在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧 以达到尽量与其他玩家同步
		 * isPullPlayer 是否进行人人物拉取 
		 */
		
		public function updatePlayerMovePath(playerMoveResultVo:PlayerMoveResultVo,isPullPlayer:Boolean,forceUpdate:Boolean=false):void
		{
			if(_mapConfigLoadComplete)
			{
				var complete:Function=null
				var player:PlayerView=_senceRolesView.totalViewDict[playerMoveResultVo.id] as PlayerView;
				var pathLen:int=playerMoveResultVo.path.length;
				if(player)
				{
					if(playerMoveResultVo.id==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) 
					{
						complete=heroMovingComplete;
						startMouseEffect(playerMoveResultVo.path[pathLen-1].x,playerMoveResultVo.path[pathLen-1].y);
					}
					else   
					{
						complete=playerMoveComplete;
						///判断是否进行坐标拉取
						if(isPullPlayer)	checkPullPlayer(playerMoveResultVo.mapX,playerMoveResultVo.mapY,player);
					}
					player.sMoveTo(playerMoveResultVo.path,playerMoveResultVo.speed,complete,player,forceUpdate);
				}
				
			}
		}
		
		/**角色同步拉取
		 * checkMapX  checkMapY  服务端返回的 坐标  与本地客户端坐标进行比较 当大于  PlayerPullLen  拉取的距离时进行拉取
		 */		
		private function checkPullPlayer(checkMapX:int,checkMapY:int,player:PlayerView):void
		{
			var len:Number=YFMath.distance(checkMapX,checkMapY,player.roleDyVo.mapX,player.roleDyVo.mapY)
			if(len>=PlayerPullLen)
			{  ///同步拉取人物处理 
				player.setMapXY(checkMapX,checkMapY);
			}
		}
		
		/**更新宠物移动
		 */ 
		public function updatePetMovePath(petMoveVo:PetMoveResultVo):void
		{
			if(_mapConfigLoadComplete)
			{
				var player:PlayerView=_senceRolesView.totalViewDict[petMoveVo.id] as PlayerView;
			//	var pathLen:int=petMoveVo.path.length;
				if(player)
				{
					checkPullPlayer(petMoveVo.mapX,petMoveVo.mapY,player);
					player.sMoveTo(petMoveVo.path,petMoveVo.speed,petMoveComplete,{player:player,direction:petMoveVo.direction},true);
				}
				
			}
		}
		
		/**宠物移动结束
		 */ 
		private function petMoveComplete(data:Object):void
		{
			var player:PlayerView=data.player as PlayerView;
			var direction:int=data.direction;
			player.play(TypeAction.Stand,direction);
		}
		
		private function playerMoveComplete(data:Object):void
		{
	//		print(this,"其为角色行走完成!!");
			var player:PlayerView=data as PlayerView;
			//待机
			player.play(TypeAction.Stand);
	//		_laquIndex=0;
		}
		
		
		/** 玩家坐骑状态发生改变
		 * state 状态
		 */
		public function updateMountChange(mountChangeVo:MountChangeResultVo,state:int):void
		{
			stopMouseEffect();
			var playerId:String=mountChangeVo.dyId;
			var playerView:PlayerView=_senceRolesView.totalViewDict[playerId] as PlayerView;
			RoleDyVo(playerView.roleDyVo).state=state//mountChangeVo.state;
			//切换坐骑 人物需要停止移动
			playerView.stopMove();
			///更新衣服的静态 id
		//	if(mountChangeVo.state==TypeRole.State_Mount)  ///如果在坐骑上
			if(state==TypeRole.State_Mount)
			{
				_senceRolesView.updateMountCloth(playerId,mountChangeVo.clothBasicId);
				_senceRolesView.updateMount(playerId,mountChangeVo.weaponBasicId);
				
				///播放上坐骑特效??
				print(this,"此处播放了上坐骑的特效");
			//	var skillId:int=10002;
				///   播放上坐骑特效
		//		_fightView.showEffect(playerView,skillId,1);  ////上坐骑特效
			}
			else   ///不再坐骑上 
			{
				_senceRolesView.updateCloth(playerId,mountChangeVo.clothBasicId);
				_senceRolesView.updateWeapon(playerId,mountChangeVo.weaponBasicId);
			}
		}
		
		/**  服务端告知该怪物dyId 移动到目标点 x , y ,  该怪物进行广播
		 */ 
		public function updateMonsterMoveToPoint(monsterWalkVo:MonsterWalkVo):void
		{
			if(_mapConfigLoadComplete)   ////  配置文集加载完成之后才能进行寻路
			{
				///进行寻路    怪物寻路 的路径一般很短
				var monsterView:MonsterView=_senceRolesView.totalViewDict[monsterWalkVo.monsterDyId] as MonsterView;
				if(monsterView)
				{
					if(!monsterView.isPool)
					{
					///	var _time:Number=getTimer();
						
						var endTilePt:Point=RectMapUtil.getTilePosition(monsterWalkVo.x,monsterWalkVo.y);
						var startTilePt:Point=RectMapUtil.getTilePosition(monsterView.roleDyVo.mapX,monsterView.roleDyVo.mapY);
						_aStar.seachPath(startTilePt,endTilePt);
						//	_aStar.doFlody();
						var path:Array=_aStar.getPath();
						/////通知服务端   怪物进行走路 .................
				//		print(this,"monsterbeginMove:",monsterView.roleDyVo.dyId,monsterWalkVo.monsterDyId);
//						///优化路径 只发三个点
//						var pathLen:int=path.length;
//						if(pathLen>3) pathLen=3;
//						path=path.slice(0,pathLen);
						noticeMonsterWalk(monsterView.roleDyVo.dyId,path);	
						
				//		print(this,"帮怪物寻路,时间::",getTimer()-_time,"fps:",Stats.Instance.getFps());
					}
				}
			}
		}
		
		/**通知服务端怪物开始走路 服务端进行广播 
		 *   怪物 进行路径行走  告诉服务端去进行广播
		 */ 
		private function noticeMonsterWalk(monsterDyId:String,path:Array):void
		{
			var monsterMoveVo:MonsterMoveVo=PoolCenter.Instance.getFromPool(MonsterMoveVo,null) as MonsterMoveVo;
			var roleDyVo:MonsterDyVo=RoleDyManager.Instance.getRole(monsterDyId);
			var monsterBasicId:int=roleDyVo.basicId;
			var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roleDyVo.basicId);
			monsterMoveVo.dyId=monsterDyId;
			monsterMoveVo.path=path;
			monsterMoveVo.speed=monsterBasicVo.speed;
			monsterMoveVo.curentPostion=new Point(roleDyVo.mapX,roleDyVo.mapY);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_MonsterBeginMove,monsterMoveVo);
		}
		
		
		/**怪物死亡
		 */ 
		public function updateMonsterDead(monsterDeadVo:MonsterDeadVo):void
		{
			var deadPlayer:PlayerView=_senceRolesView.totalViewDict[monsterDeadVo.deadId] as PlayerView;
			var atkPlayer:PlayerView=_senceRolesView.totalViewDict[monsterDeadVo.atkId] as PlayerView;
			if(deadPlayer&&atkPlayer)
			{
				///人物死亡面朝角色方向
				var deadDirection:int=DirectionUtil.getDirection(atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY,deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY);
				deadPlayer.playDead(deadDirection);
				if(DataCenter.Instance.roleSelfVo.heroState.willDo==deadPlayer)DataCenter.Instance.roleSelfVo.heroState.willDo=null;
				
				///做後退動作  具有速度的技能不能做後退動作 
				var fightSkillBasicVo:FightSkillBasicVo=SkillDyManager.Instance.getFightSkillBasicVo(monsterDeadVo.skillId,1);
				if(!TypeSkill.isSpeedSkill(fightSkillBasicVo.atkType)) ///當不是運動技能時
				{
					////做打击感
					var direction:int=TypeDirection.getOppsiteDirection(deadDirection)//DirectionUtil.getDirection(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY);
					var degree:Number=YFMath.getDegree(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,atkPlayer.roleDyVo.mapX,atkPlayer.roleDyVo.mapY);
					////人物后退  ，进行震屏
					var distance:int=50+Math.random()*100;///人物后退距离
					var endPt:Point=YFMath.getLinePoint3(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,distance,degree);
					endPt=GridData.Instance.getMoveToEndPoint(deadPlayer.roleDyVo.mapX,deadPlayer.roleDyVo.mapY,endPt.x,endPt.y);
					if(endPt)deadPlayer.pureMoveTo(endPt.x,endPt.y,10);
				}
				TweenSkill.WaitToExcute(1500,_senceRolesView.delRole,monsterDeadVo.deadId);
		//		print(this,"死亡怪物：：：:",monsterDeadVo.deadId);
			}
			
			if(deadPlayer==_uAtkPlayer)_uAtkPlayer=null;
		}
		/**人物死亡
		 */
		public function updateRoleDead(dyId:String):void
		{
		//	var _time:Number=getTimer();
			var player:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
			player.playDead();
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==dyId)
			{
				stopMouseEffect();
				YFAlert.show(Lang.FuHuo,Lang.TiShi,1,noticeRevive,null,null,null,Lang.FuHuo);
			//	noticeRevive();
			}
			
			if(player==_uAtkPlayer)_uAtkPlayer=null;
		//	print(this,"角色死亡耗时：时间time===========::",getTimer()-_time,"fps:",Stats.Instance.getFps());

		}
		/**请求角色复活
		 */		
		private function noticeRevive(obj:Object=null):void
		{

			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RoleRevive);
		}
		
		
		/** 更新飞行状态 
		 */
		public function updateFly(flyVo:FlyVo):void
		{
			
		}
		
		/** 跳跃状态 
		 */
		public function updateJump():void
		{
			
		}
		/**觸發技能
		 */		
		private function onTriggerSkill(e:YFEvent):void
		{
			var obj:Object=e.param; ///技能模塊SkillWindow類中發出的事件
			var skillId:int=obj.id;
			var skillLevel:int=obj.level;
			triggerSKill(skillId,skillLevel);
		}
		
		/**键盘事件 
		 */		
		private function onKeyDownEvent(e:YFEvent):void
		{
			if(_senceRolesView.heroView.isDead==false&&DataCenter.Instance.roleSelfVo.heroState.isLock==false)
			{
			//	var skillId:int;
				///技能等级
				var skillLevel:int=1;
			//	var skillBasicVo:SkillBasicVo;
			//	var fightMoreVo:FightMoreVo=PoolCenter.Instance.getFromPool(FightMoreVo,null) as FightMoreVo;
				switch(e.type)
				{
//					case GlobalEvent.KeyDownNum_1:
//						skillId=1006;
//						triggerSKill(skillId, skillLevel);
//						break;
//					case GlobalEvent.KeyDownNum_2:  ////闪电术
//						skillId=1007;
//						triggerSKill(skillId, skillLevel);
//						break;
//					case GlobalEvent.KeyDownNum_3:
//						///trace(技能3)
//						skillId=1008;
//						triggerSKill(skillId, skillLevel);
//
//						break;
//					case GlobalEvent.KeyDownNum_4: ///瞬移技能
//						triggerBlinkMove();
//						break;
//					case GlobalEvent.KeyDownNum_5: ///瞬移技能
//						skillId=1009;
//						triggerSKill(skillId, skillLevel);
//						break;
//					case GlobalEvent.KeyDownNum_6:
//						skillId=1010;
//						triggerSKill(skillId, skillLevel);
//						break;
//					case GlobalEvent.KeyDownNum_7:
//						skillId=1011;
//						triggerSKill(skillId, skillLevel);
//						break;
//					case GlobalEvent.KeyDownNum_8:
//						skillId=1012;
//						triggerSKill(skillId, skillLevel);
//						break;
					case GlobalEvent.KeyDownSpace:
						//空格键
						var arr:Array=_senceRolesView.getDropGoodsIDArr(180); ///半径为180范围内的物品掉落
						for each(var dyId:String in arr)
						{
							noticeGetGropGoods(dyId); ///获取掉落物凭
						}
						break;
				}
			}
			else print(this,"主角已经死亡 技能不能发出");
		}
		
		/**觸發移形換影
		 * range 移动的距离
		 */		
		private function triggerBlinkMove(range:int=30):void
		{
			var testPoint:Point;
			if(YFMath.distance(HeroProxy.mapX,HeroProxy.mapY,LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY)>range)	testPoint=YFMath.getLinePoint2(HeroProxy.mapX,HeroProxy.mapY,LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY,range);
			else testPoint=new Point(LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY);
			var endPoint:Point=GridData.Instance.getMoveToEndPoint(HeroProxy.mapX,HeroProxy.mapY,testPoint.x,testPoint.y);
			if(endPoint)
			{
				noticeBlinkMove(endPoint.x,endPoint.y);
				///直接进行移动 同时广播其他角色移动
				DataCenter.Instance.roleSelfVo.heroState.isLock=true;
				noticeOutSit();//如果为打坐取消打坐
				_senceRolesView.heroView.updateBlinkMove(endPoint.x,endPoint.y,unLockHero,null,false,unLockHero);
				///宠物拉取 对出战的宠物进行拉取
				var fightPetArr:Array=PetDyManager.Instance.getFightPlayer();
				var degree:Number=DirectionUtil.getDirectionDegree(HeroProxy.direction);
				var petPt:Point=YFMath.getLinePoint3(endPoint.x,endPoint.y,PetPlayerView.MinDistance,degree);
				var petPlayer:PetPlayerView;
				for each(var petId:String in fightPetArr)
				{
					petPlayer=_senceRolesView.totalViewDict[petId] as PetPlayerView;
					petPlayer.noticePullPet(petPt.x+50-Math.random()*100,petPt.y+60-Math.random()*120);	
				}
				stopMouseEffect();
			}
				
		}
		
		
		/** 对主角进行解锁
		 */		
		private function unLockHero(obj:Object):void
		{
			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
		}
		/** 触发技能
		 *  技能id   
		 * skilllevel 技能等级
		 */		
		private function triggerSKill(skillId:int,skillLevel:int,uAtk:PlayerView=null):void
		{
			var rolesArr:Array;
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId);
			var fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(skillLevel));
			if(fightSkillBasicVo.canfire())  ///该技能能够发出   过了CD时间 
			{
				////进行技能类型分析
				var fightSingleVo:FightSingleVo;////单人 pk  vo 
				var fightMoreVo:FightMoreVo;//多人pk  技能无点
				var fightMorePtVo:FightMorePtVo;/// 多人pk 有点
				switch(fightSkillBasicVo.atkType)
				{
					case TypeSkill.Atk_Single_Default:
						////只有当具有目标时才会播放动画  单点
						if(!_senceRolesView.isUsablePlayer(uAtk))uAtk=_uAtkPlayer;
						if(_senceRolesView.isUsablePlayer(uAtk))
						{
							fightSingleVo=PoolCenter.Instance.getFromPool(FightSingleVo) as FightSingleVo;
							fightSingleVo.uAtkId=uAtk.roleDyVo.dyId;
							fightSingleVo.skillId=skillId;
							noticeFightSingle(fightSingleVo);
						}
						break;
					case TypeSkill.Atk_Single_One: //单一攻击
						///检测 当前战斗对象是否存在
						var canTrigger:Boolean=false;
						canTrigger=_senceRolesView.isUsablePlayer(_uAtkPlayer);
						if(!canTrigger)
						{
							_uAtkPlayer=getPlayer(new Point(LayerManager.PlayerLayer.mouseX,LayerManager.PlayerLayer.mouseY));
						}
						canTrigger=_senceRolesView.isUsablePlayer(_uAtkPlayer);
						if(canTrigger) canTrigger=_senceRolesView.isCanFightPlayer(_uAtkPlayer);
						if(canTrigger)
						{
							var __distance:Number=YFMath.distance(HeroProxy.mapX,HeroProxy.mapY,_uAtkPlayer.roleDyVo.mapX,_uAtkPlayer.roleDyVo.mapY);
							if(__distance<=fightSkillBasicVo.range)
							{
								fightSingleVo=PoolCenter.Instance.getFromPool(FightSingleVo) as FightSingleVo;
								fightSingleVo.uAtkId=_uAtkPlayer.roleDyVo.dyId;
								fightSingleVo.skillId=skillId;
								noticeFightSingle(fightSingleVo);
							}
						}
						break;
					case TypeSkill.Atk_Single_Much:
						////只有当具有目标时才会播放动画  单点
						var player:PlayerView=getPlayer(new Point(LayerManager.PlayerLayer.mouseX,LayerManager.PlayerLayer.mouseY));
						if(player)
						{
							if(_senceRolesView.isCanFightPlayer(player))
							{
								var myDistance:Number=YFMath.distance(HeroProxy.mapX,HeroProxy.mapY,player.roleDyVo.mapX,player.roleDyVo.mapY);
								if(myDistance<=fightSkillBasicVo.range)
								{
									fightSingleVo=PoolCenter.Instance.getFromPool(FightSingleVo) as FightSingleVo;
									fightSingleVo.uAtkId=player.roleDyVo.dyId;
									fightSingleVo.skillId=skillId;
									noticeFightSingle(fightSingleVo);
								}
							}
						}
						break;
					///鼠标悬停的对象
					case TypeSkill.Atk_Single_MouseTarget:
						var mouseTarget:PlayerView=getPlayer(new Point(LayerManager.PlayerLayer.mouseX,LayerManager.PlayerLayer.mouseY));
						if(_senceRolesView.isUsablePlayer(mouseTarget))
						{
							if(_senceRolesView.isCanFightPlayer(mouseTarget))
							{
								fightSingleVo=PoolCenter.Instance.getFromPool(FightSingleVo) as FightSingleVo;
								fightSingleVo.uAtkId=mouseTarget.roleDyVo.dyId;
								fightSingleVo.skillId=skillId;
								noticeFightSingle(fightSingleVo);
							}
						}
						break;
					case TypeSkill.Atk_Circle_NoPt_Speed:
						////只有当具有目标时才会播放动画  单点
						rolesArr=_senceRolesView.getCircleRoles(fightSkillBasicVo.range); ////获取  fightSkillBasicVo.range范围内的角色
						if(rolesArr.length>0)
						{
							fightMoreVo=PoolCenter.Instance.getFromPool(FightMoreVo) as FightMoreVo;
							fightMoreVo.skillId=skillId;
							fightMoreVo.uAtkArr=rolesArr;
							noticeFightMore(fightMoreVo);
						}
						break;
					case TypeSkill.Atk_Circle_NoPt_NoSpeed:
						////只有当具有目标时才会播放动画    该通讯需要一个坐标来进行技能定位
						///能够到达的目标点 
						rolesArr=_senceRolesView.getCircleRoles(fightSkillBasicVo.range); ////获取  fightSkillBasicVo.range范围内的角色
						if(rolesArr.length>0)
						{
							fightMoreVo=PoolCenter.Instance.getFromPool(FightMoreVo) as FightMoreVo;
							fightMoreVo.skillId=skillId;
							fightMoreVo.uAtkArr=rolesArr;
							noticeFightMore(fightMoreVo);
						}
						break;
					case TypeSkill.Atk_Circle_Pt_NoSpeed: /////该技能的范围为 400 也就是 点和人物之间的距离必须在400范围内
						//// 有点攻击  技能一定会发出
						var distance:int=400;
						var locatePt:Point;
						////比较距离
						var heroToMouseDistance:int=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY);
						if(heroToMouseDistance<distance) ////在范围内
						{
							rolesArr=_senceRolesView.getCircleRoles2(fightSkillBasicVo.range,LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY);
							fightMorePtVo=PoolCenter.Instance.getFromPool(FightMorePtVo) as FightMorePtVo;
							fightMorePtVo.skillId=skillId;
							fightMorePtVo.uAtkArr=rolesArr;
							fightMorePtVo.mapX=LayerManager.BgMapLayer.mouseX;
							fightMorePtVo.mapY=LayerManager.BgMapLayer.mouseY;
							noticeFightMorePt(fightMorePtVo);
						}
						else print(this,"攻击距离太远 无法进行攻击");
						break;
					case TypeSkill.Atk_ThreeLine_Pt_Speed:
						////只有当具有目标时才会播放动画    该通讯需要一个坐标来进行技能定位
						///能够到达的目标点 
						rolesArr=_senceRolesView.getThreeLineRoles(LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY,fightSkillBasicVo.range);
						//					if(rolesArr.length>0)
						//					{
						fightMorePtVo=PoolCenter.Instance.getFromPool(FightMorePtVo) as FightMorePtVo;
						fightMorePtVo.skillId=skillId;
						fightMorePtVo.uAtkArr=rolesArr;
						fightMorePtVo.mapX=LayerManager.BgMapLayer.mouseX;
						fightMorePtVo.mapX=LayerManager.BgMapLayer.mouseY;
						noticeFightMorePt(fightMorePtVo);
						//					}
						break;
					case TypeSkill.Atk_LineMore_Pt_Speed:
						//// 有点攻击  技能一定会发出
						var lineEndPt:Point=new Point();
						print(this,"LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY",LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY,HeroProxy.mapX,HeroProxy.mapY);
						rolesArr=_senceRolesView.getLineRoles(LayerManager.BgMapLayer.mouseX,LayerManager.BgMapLayer.mouseY,fightSkillBasicVo.range,lineEndPt);
						fightMorePtVo=PoolCenter.Instance.getFromPool(FightMorePtVo) as FightMorePtVo;
						fightMorePtVo.skillId=skillId;
						fightMorePtVo.uAtkArr=rolesArr;
						fightMorePtVo.mapX=lineEndPt.x;
						fightMorePtVo.mapY=lineEndPt.y;
						noticeFightMorePt(fightMorePtVo);
						break;
					case TypeSkill.Atk_BlinkMove:
						///移形換影技能
						triggerBlinkMove(fightSkillBasicVo.range);
						///播放技能cd动画
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillPlayCD,skillId);
						break;
				}
			}
		}
		
		
		
		
		/** 广播瞬移
		 */		
		private function noticeBlinkMove(endX:int,endY:int):void
		{
			var blinkMoveVo:BlinkMoveVo=new BlinkMoveVo();
			blinkMoveVo.mapX=HeroProxy.mapX;
			blinkMoveVo.mapY=HeroProxy.mapY;
			blinkMoveVo.endX=endX;
			blinkMoveVo.endY=endY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_BlinkMove,blinkMoveVo);
		}
		
		
		/**其他屏幕玩家进行坐标校验处理  如果坐标差值大于130 则进行拉取
		 */ 
//		public function checkForSlideMove(backSlideMoveVo:BackSlideMoveVo):void
//		{
//			var playerView:PlayerView=_senceRolesView.totalViewDict[backSlideMoveVo.dyId] as PlayerView;
//			
//		}
		
		
	}
}