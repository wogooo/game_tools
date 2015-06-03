package com.YFFramework.game.core.module.mapScence.view
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.map.rectMap.findPath.AStar;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.AstarCache;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.Gather_ConfigBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SearchRoadBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.manager.SkipPointBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.FightEffectBasicVo;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.Gather_ConfigBasicVo;
	import com.YFFramework.game.core.global.model.HeroState;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.RaidNPCVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.SkipPointBasicVo;
	import com.YFFramework.game.core.global.model.TaskWillDoVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.BytesUtil;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.progressbar.GloableProgress;
	import com.YFFramework.game.core.global.view.tips.MapLoaderLogoView;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.autoSetting.model.FlushUnitVo;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.demon.manager.DemonManager;
	import com.YFFramework.game.core.module.demon.view.DemonWindow;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.ActionManager;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.manager.MouseFollowManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.manager.SpecialSkillManager;
	import com.YFFramework.game.core.module.mapScence.manager.TransferPointManager;
	import com.YFFramework.game.core.module.mapScence.model.BlinkMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.SeachRoadVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightMoreVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.FightUIPtVo;
	import com.YFFramework.game.core.module.mapScence.model.fight.UAtkInfo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterWalkVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.MonsterMoveVo;
	import com.YFFramework.game.core.module.mapScence.world.model.PlayerMoveResultVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.BgMapEffectView;
	import com.YFFramework.game.core.module.mapScence.world.view.BgMapView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.CameraProxy;
	import com.YFFramework.game.core.module.mapScence.world.view.player.GatherPlayer;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.mapScence.world.view.player.MonsterView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PetPlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.newGuide.manager.GuaJiManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.view.scene.GuaJiView;
	import com.YFFramework.game.core.module.newGuide.view.scene.ZiDongXunLuView;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapWorldVo;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingEffect2DView;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.raid_pro.CExitRaid;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**   处理角色战斗以及交互 
	 *  2012-7-13
	 *	@author yefeng
	 */
	public class MapScenceView
	{
		
		public static const SkillEffectLen:int=20;
		
//		public static const SkillEffectMinLen:int=20;

		
		/**角色坐标拉取 当 角色的坐标和服务器发回来的坐标的距离大于PlayerPullLen 值时 进行坐标拉取， 一般在角色行走时需要判断是否进行坐标拉取
		 */ 
		private static const PlayerPullLen:int=100;
		///通知进行路径行走 的时间间隔 屏蔽快速点击 
		private static const NoticeMovePathInterval:int=120;
		
		/** 背景地图
		 */
		private var _bgMap:BgMapView;
		/**背景特效层
		 */
		private var _bgMapEffectView:BgMapEffectView;
		/** 点击地面产生的鼠标效果 
		 */
		private var _mouseEffect:ThingEffect2DView;
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
		/**当前选中的对象
		 */ 
		private var _selectPlayer:PlayerView;
		/**角色选中光标
		 */ 
		private var _roleSelectView:RoleSelectView;
		/**目标点技能选取目标点特效
		 */		
		private var _skillPointSelectView:SkillPointSelectView;
		/**场景双击计时器
		 */		
		private var _dbClickTime:Number=0;
		/**场景双击时间
		 */		
		private static const DBClickTime:int=800;
		
		private var _revivePopView:RevivePopView;
		
		private var getDropGoodsTimer:Timer;
		
		
		/**上一个行走到点
		 */
		private var _preEndX:int;
		private var _preEndY:int;
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
			_fightView=FightView.Instance;//new FightView();			
			initMouseEffectUI();
			_aStar=AStar.Instance;//new AStar(); 
			_roleSelectView=new RoleSelectView();
			_skillPointSelectView=new SkillPointSelectView();
			
			getDropGoodsTimer=new Timer(2500);
			getDropGoodsTimer.addEventListener(TimerEvent.TIMER,onCollectDropGoods2);
			getDropGoodsTimer.start();
		}
		private function addEvents():void
		{
			///震动屏幕
			//// fightView 推拉角色，移除鼠标效果
			YFEventCenter.Instance.addEventListener(MapScenceEvent.RemoveMouseEffect,stopMouseEffect);
			//地图滚屏层  /// 单击场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.ScenceClick,onWalkMouseDown);
			/// 战斗时 通知角色 走到指定位置
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveTopt,heroMoveToPt);
			///角色移动到某一点   交易时 向玩家靠近
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoveToPlayer,moveToRolePlayer);
			///小地图点击 向 npc靠近
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToNPC,smallMapEvent);
			//向 目标点靠近打开NPC面板或者 走到目标点 攻击怪物
			YFEventCenter.Instance.addEventListener(GlobalEvent.TaskMoveToNPC,onTaskEventHandle);

			YFEventCenter.Instance.addEventListener(MapScenceEvent.CheckPath,onFightCompleteToOtherMapNPC);
			//复活主角  走的 是战斗协议复活主角
			YFEventCenter.Instance.addEventListener(MapScenceEvent.FightForRevive,onFightRiviveHero);
			

			///小地图点击 攻击 怪物  
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToMonsterZone,smallMapEvent);
			/////行走到 世界上的目标点
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapMoveToWorldPt,smallMapEvent);
			
			////小地图点击飞鞋进行跳转
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKipToPlayer,smallMapSkipToEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKipToPoint,smallMapSkipToEvent);
			//完成任务
			YFEventCenter.Instance.addEventListener(GlobalEvent.finishTaskOK,onTaskEvent);
			///成功接受任务
			YFEventCenter.Instance.addEventListener(GlobalEvent.acceptTaskOK,onTaskEvent);
			
			//剧情处理  因为服务端发送协议的先后顺序问题 导致  人物走动了 此处需要将人物停下来 
//			YFEventCenter.Instance.addEventListener(StoryEvent.AcceptTaskStory,onTaskEvent);
//			YFEventCenter.Instance.addEventListener(StoryEvent.FinishTaskStory,onTaskEvent);
			
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
//			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_0,onMountChage);
			///触发技能
			YFEventCenter.Instance.addEventListener(GlobalEvent.SkillTrigger,onTriggerSkill);
				
			///拾取某个范围内的物品
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownSpace,onCollectDropGoods);
			//准备进入副本
			YFEventCenter.Instance.addEventListener(GlobalEvent.GotoEnterRaid,onGotoEnterRaid);
			//主角死亡停止移动
//			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroDeadToStopMove,onHeroDeadStopMove);
			
			var esckeyBoard:KeyBoardItem=new KeyBoardItem(Keyboard.ESCAPE,escFunc);  
			//场景层快速双击
//			DBClickManager.Instance.regDBClick(StageProxy.Instance.stage,bgDBClick);
			//// 
	//		var testKeyBordItem:KeyBoardItem=new KeyBoardItem(Keyboard.F,onH);		
			
			//挂机事件
			YFEventCenter.Instance.addEventListener(GlobalEvent.StartAutoFight,onAutoFight);
			//设置挂机响应函数
			GuaJiManager.Instance.guajiCall=guajiCall;
			//按下z 键 触发自动挂机
			var zKeyboard:KeyBoardItem=new KeyBoardItem(Keyboard.Z,onZkeyDown);
			
			var f1keyboard:KeyBoardItem=new KeyBoardItem(Keyboard.F1,onF1keyDown);
			
			
			
		}
//		private function onHeroDeadStopMove(e:YFEvent):void
//		{
//			_senceRolesView.heroView.stopMove();
//		}
		
		/**战斗复活技能复活主角
		 */
		private function onFightRiviveHero(e:YFEvent):void
		{
			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
			if(_revivePopView)
			{
				_revivePopView.updateClose();
				_revivePopView=null;
			}
			StageProxy.Instance.setNoneFocus();
		}
		/**按下F1 取消选中
		 */		
		private function onF1keyDown(e:KeyboardEvent):void
		{
			selectPlayer=null;
		}
		
//		private function onH(e:KeyboardEvent):void
//		{
//			var pt:Point=LayerManager.BgMapLayer.mousePt;
//			_senceRolesView.heroView.updateBlinkMove(pt.x,pt.y,30);
//		}
		
		private function escFunc(e:KeyboardEvent):void
		{
			removePreTiggerSkillPt();
		}
		/**  任务事件
		 */		
		private function onTaskEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				///完成任务
				case GlobalEvent.finishTaskOK:
					NoticeUtil.playFinishTask();
					break;
				// 接收任务
				case GlobalEvent.acceptTaskOK:
					NoticeUtil.playAcceptTask();
					break;
//				case StoryEvent.AcceptTaskStory:  //接受任务 播放后续剧情
//				case StoryEvent.FinishTaskStory:		//完成任务 播放后续剧情
//					_senceRolesView.heroView.stopMove();
//					break;
			}
		}
		
		/**场景层快速双击   双击取消自动寻路
		 */ 
//		private function bgDBClick():void
//		{
//			ZiDongXunLuView.Instance.hide();
//			onWalkMouseDown();
//		}
		/**选中角色
		 */		
		private function set selectPlayer(player:PlayerView):void
		{
			_roleSelectView.showDefault();
			if(player)
			{
				if(player.roleDyVo.bigCatergory!=TypeRole.BigCategory_GropGoods)
				{
					if(_roleSelectView.parent!=player)  ///当不在当前对象上时
					{
						_roleSelectView.removeFromParent();
						///显示选中 
						player.addRoleSelect(_roleSelectView);
					}
					///单击其他角色  通知主界面模块 进行ui 更新 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MouseClickOtherRole,player.roleDyVo);
				}
			}
			else 
			{
				_roleSelectView.removeFromParent();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HideOtherRoleInfo);
			}
			_selectPlayer=player;
		}
		/**选中角色 
		 */		
		private function get selectPlayer():PlayerView
		{	
			if(!_senceRolesView.isUsablePlayer(_selectPlayer)) _selectPlayer=null;
//			if(!_senceRolesView.isCanUsePlayer(_selectPlayer))
//			{
//				 _selectPlayer=null;
//			}
//			else if(_selectPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster&&_selectPlayer.isDead==true) //怪物死亡不能选中
//			{
//				_selectPlayer=null;
//			}
			return _selectPlayer;
		}
		
		private function onHeroRequest(e:YFEvent):void
		{
			switch(e.type)
			{
				case MapScenceEvent.RequestSit:
//					print(this,"请求打坐");
					noticeRequestSit();
					break;
				case MapScenceEvent.RequestMount:
//					print(this,"请求上坐骑");
//					noticeMounting();
					if(MountDyManager.fightMountId>0&&DataCenter.Instance.roleSelfVo.isFight==false) //玩家有坐骑 并且玩家不处在战斗状态时
					{
//						GloableProgress.Instance.showMountProgress(noticeMounting);
						if(DataCenter.Instance.roleSelfVo.roleDyVo.state!=TypeRole.State_Mount) 
						{
							//上坐骑
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RideMountReq);
						}

					}
					break;
			}
		}
		/**请求上坐骑
		 */		
		private function noticeMounting(obj:Object=null):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.state!=TypeRole.State_Mount) 
			{
				//上坐骑
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RideMountReq);
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
//		private function onMountChage(e:YFEvent):void
//		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.state!=TypeRole.State_Mount)
//			{
//				///上坐骑
//				noticeMounting();
//			}
//			else 
//			{
//				//下坐骑
//				noticeMountOut();
//			}
//		}
		
		/**		改变人物坐骑状态  在技能 SkillKeyBoardView里面也有改变坐骑状态的 函数   下坐骑
		 *  下坐骑
		 */
//		private function noticeMountOut():void
//		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount) 
//			{
//				print(this,"坐骑待添加");
//				//下坐骑
//			}
//		}

		private function getPlayer(pt:Point):PlayerView
		{
			
			var testPlayer:PlayerView=LayerManager.PlayerLayer.hitTestPoint(pt,true) as PlayerView;
			if(_senceRolesView.heroView!=testPlayer)
			{
				if(_senceRolesView.isUsablePlayer(testPlayer))
				{
					var canGet:Boolean=true;
					var petView:PetPlayerView=testPlayer as PetPlayerView;
					if(petView)  ///当获取的是宠物 判断是否为自己的宠物
					{
						if(petView.isOwnPet())canGet=false;
					}
					if(canGet)
					{
						
						return testPlayer ;
					}
				}	
			}
			return null;
		}
		/** 切换 地图场景
		 * @param mapX
		 * @param mapY
		 */
		public function updateMapSenceView(mapX:int,mapY:int):void
		{
			StageProxy.Instance.setNoneFocus();
			_mapConfigLoadComplete=false;
			GuaJiManager.Instance.stop();  //如果在挂机中，停止挂机
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			////释放前一个场景的资源
			SourceCache.Instance.disposeAllResExcept(mapSceneBasicVo.mapId);
			print(this,"此处不进行前一个场景资源的释放");
			//更新场景 
			updateMapChange(mapSceneBasicVo,mapX,mapY);
		
			_glowPlayer=null;
			//地图配置文件没有加载完成
			//加载 xx文件
			var xxMapUrl:String=URLTool.getMapConfig(mapSceneBasicVo.resId);
			if(!SourceCache.Instance.getRes2(xxMapUrl))
			{
				SourceCache.Instance.addEventListener(xxMapUrl,xxFileComplete);
				SourceCache.Instance.forceLoadRes(xxMapUrl,mapSceneBasicVo);
			}
			else 
			{
				_mapConfigLoadComplete=true;
				initMapConfig(xxMapUrl);
			}
		}
		/**主角 进行场景切换 或者 随机传送时候 需要先 停止移动
		 */		
		public function updateHeroStopMove():void
		{
			_senceRolesView.heroView.stopMove();
			stopMouseEffect();
		}
		
		/** 初始化A星  url 是.xx文件的地址
		 * 背景特效场景 npc 
		 */
		private function initMapConfig(url:String):void
		{
			var data:Object=SourceCache.Instance.getRes2(url);
			///初始化 A星
			GridData.Instance.initData(data);
			_aStar.initData(GridData.Instance);
			///添加npc
			_senceRolesView.handleNPCConfig();
			//初始化背景特效场景   包括建筑 以及 传送点
			_bgMapEffectView.initData(data); 
			
			_senceRolesView.checkNeededPlayerAlphaPoint();
			_senceRolesView.heroView.checkAlphaPoint(true); //主角 跳出 场景也需要检测透明度
			resizeItForBugResolve();
			///发送给小地图模块进行处理 配置 文件加载完成
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MapConfigLoadComplete,data);
			
			///槛车是否处于寻路状态
//			checkFindpath(); 
			var checkPathTimeOut:TimeOut=new TimeOut(100,checkFindpath);  ///延迟 1秒 检测寻路 ,防止卡屏
			checkPathTimeOut.start();
			
			
			//如果为第一次登陆 则调用 新手引导
//			if(DataCenter.Instance.nowLogin)
//			{
//				var timeOut:TimeOut=new TimeOut(3000,handleLoginGuide); //如果 任务 没有出来的时候进行补救
//				timeOut.start();
//			}
		}
		/**消除bug  解除 跳转时候的马赛克的bug
		 */
		private function resizeItForBugResolve():void
		{
	//		ResizeManager.Instance.resize();
//			CameraProxy.Instance.resize();
		//	YF2d.Instance.resizeScence(StageProxy.Instance.getWidth(),StageProxy.Instance.getHeight());
			_bgMap.updateResizeForBug();
		}
		/**检测是否处于寻路状态 
		 */
		private function checkFindpath(obj:Object=null):void
		{
			if(DataCenter.Instance.roleSelfVo.heroState.willDo is SeachRoadVo)
			{
				var roadVo:SeachRoadVo=DataCenter.Instance.roleSelfVo.heroState.willDo as SeachRoadVo;
				roadVo.roadArr.shift();
				handleSeachRoad(roadVo);
			}
		}

		
		/**登陆  处理刚登录时候的逻辑 
		 */
//		private function handleLoginGuide(obj:Object=null):void
//		{
//			//如果为第一次登陆 则调用 新手引导
//			if(DataCenter.Instance.nowLogin)
//			{
//				if(LayerManager.PopLayer.numChildren==0)
//				{
//					if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
//					{
//						NewGuideManager.DoGuide();
//					}
//				}
//				DataCenter.Instance.nowLogin=false;
//			}
//		}
		
		
		/** 战斗完 跨场景寻找npc 
		 */		
		private function onFightCompleteToOtherMapNPC(e:YFEvent=null):void
		{
			var seachRoad:SeachRoadVo=DataCenter.Instance.roleSelfVo.heroState.willDo as SeachRoadVo;
			var mapId:int=DataCenter.Instance.getMapId();
			if(seachRoad)
			{
				handleSeachRoad(seachRoad);
			}
		}
		
		
		/**处理跨场景寻路逻辑
		 */		
		private function handleSeachRoad(seachRoad:SeachRoadVo):void
		{
			ZiDongXunLuView.Instance.show();
			if(seachRoad.roadArr.length>0)	
			{
				var skipPointBasicVo:SkipPointBasicVo=SkipPointBasicManager.Instance.getSkipPointVo(DataCenter.Instance.getMapId(),seachRoad.roadArr[0]);
				if(skipPointBasicVo)
				{
					var centerPt:Point=skipPointBasicVo.getCentPt();
					heroMoveToPostion(centerPt.x,centerPt.y);
				}
			}
			else //走到目标npc场景了 
			{
				///向目标npc 或者 传送点靠近
				if(seachRoad.npcBasicId>0)   
				{
					closeToNpcInSameMap(seachRoad.npcDyId);
				}
				else  //向目标点  或者传送点靠近
				{
					var taskWillDo:TaskWillDoVo=DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo; //任务将要做的事情
					// 如果类型为 攻击怪物的类型  则进行怪物攻击  
					if(taskWillDo.seach_type==TypeProps.TaskTargetType_Monster)
						closeToPointInSameMap(seachRoad.npc_posX,seachRoad.npc_posY,taskWillDo);
					else //走到 目标点 或者走向NPC 
					{
						closeToPointInSameMap(seachRoad.npc_posX,seachRoad.npc_posY,taskWillDo,0);
					}
				}
			}
		}
		/** .xx地图文件加载完成
		 */		
		private function xxFileComplete(e:YFEvent):void
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
//			_senceRolesView.heroView.updateBgMapSize(bgVo.width,bgVo.height);
			CameraProxy.Instance.updateBgMapSize(bgVo.width,bgVo.height);
			///主角刷新坐标  
			_senceRolesView.heroView.stopMove();
			_senceRolesView.heroView.setMapXY(mapX,mapY);
			_senceRolesView.heroView.checkAlphaPoint(true);
		}
		/**  创建鼠标交换
		 */
		private function initMouseEffectUI():void
		{
			_mouseEffect=new ThingEffect2DView();
			LayerManager.BgSkillLayer.addChild(_mouseEffect);
			
			SourceCache.Instance.addEventListener(CommonEffectURLManager.MouseEffectURL,mouseEffectComplete);
			SourceCache.Instance.loadRes(CommonEffectURLManager.MouseEffectURL);
		}
		private function mouseEffectComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,mouseEffectComplete);
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			_mouseEffect.initData(actionData);
		}
		
		/** 鼠标点击场景产生交互 
		 */		
		private function onWalkMouseDown(e:YFEvent=null):void
		{
			if(getTimer()-_dbClickTime<=DBClickTime)
			{
				if(ZiDongXunLuView.Instance.getShow())ZiDongXunLuView.Instance.hide();
			}
			_dbClickTime=getTimer();
			if(!ZiDongXunLuView.Instance.getShow()) //不再自动寻路中
			{
				var pt:Point=LayerManager.PlayerLayer.mousePt;
				var target:PlayerView=getPlayer(pt);//myTaret as PlayerView;//
				if(_mapConfigLoadComplete) /// 当地图配置文件加载完成后
				{
					if(!_senceRolesView.heroView.isDead)  ///当主角没有死亡
					{
						var bgMapMousePt:Point=LayerManager.BgMapLayer.mousePt;
						var endX:int=bgMapMousePt.x;
						var endY:int=bgMapMousePt.y;
						if(!DataCenter.Instance.roleSelfVo.heroState.isLock)///当处于非战斗状态时
						{
							//						DataCenter.Instance.roleSelfVo.heroState.willDo=1; 
							DataCenter.Instance.roleSelfVo.heroState.setDefaultWillDo(); ///不要为null 防止 fightView  主角攻击完后 判断为 null后重新发起工具
							TransferPointManager.Instance.autoMove=false;
							if(target)  ///当有吗吗 
							{
								selectPlayer=target;
								if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
								{
									
									if(RoleDyManager.Instance.canFight(RoleDyVo(target.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))	moveCloseToPlayerForFight(target);
								}
								else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  ///为玩家
								{
									///如果能够攻击 则直接进行攻击
									if(RoleDyManager.Instance.canFight(RoleDyVo(target.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))	moveCloseToPlayerForFight(target);
									else if(DataCenter.Instance.roleSelfVo.heroState.state!=HeroState.StateNone) ///if(DataCenter.Instance.roleSelfVo.heroState.state==HeroState.Compete)
									{
										closeToPlayer(target);
									}
								}
								else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)  ///为宠物
								{
									if(RoleDyManager.Instance.canFight(RoleDyVo(target.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))	moveCloseToPlayerForFight(target);
								}
								else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC||target.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods||target.roleDyVo.bigCatergory==TypeRole.BigCategory_Gather)	
								{
									closeToPlayer(target);
								}
								return ;
							}
							else 
							{
								///进行寻路处理  
								if(getTimer()-_noticeMovePathTime>=NoticeMovePathInterval)
								{
									heroMoveToPostion(endX,endY);
									_noticeMovePathTime=getTimer();
									GuaJiManager.Instance.stop(); //取消自动挂机
									ZiDongXunLuView.Instance.hide();
								}
							}
							//		noticepetMoving();
						}
						else  ///处于战斗状态 
						{
							
							if(target) 
							{
								selectPlayer=target;
								DataCenter.Instance.roleSelfVo.heroState.willDo=target;
							}
							else DataCenter.Instance.roleSelfVo.heroState.willDo=new Point(endX,endY);
						}
					}
					else 
					{
						print(this,"主角已经死亡 ,人物不能行走");
						NoticeUtil.setOperatorNotice("主角已经死亡");
					}
				}
			}
			else   //双击取消自动寻路
			{
				NoticeUtil.setClickNotice("双击取消自动寻路",StageProxy.Instance.stage.mouseX,StageProxy.Instance.stage.mouseY);
			}
				
		}

		private function onMoveToplayerForFight(e:YFEvent):void
		{
			if(!_senceRolesView.heroView.isDead)
			{
				var playerView:PlayerView=e.param as PlayerView;
				if(!playerView.isDispose)
				{
					var skillId:int=ActionManager.Instance.lastSkillId;
					if(!GuaJiManager.Instance.getStart())
					{
						if(skillId==-1)skillId=SkillDyManager.Instance.getDefaultSkill();
						moveCloseToPlayerForFight(playerView,skillId);
						
					}
					else  //挂机
					{
						if(skillId==-1)skillId=AutoManager.Instance.getAvailableSkill();
						moveCloseToPlayerForFight(playerView,skillId);
					}
					ActionManager.Instance.lastSkillId=-1;//将记录去掉
				}
			}
		}
		
		/**靠近目标准备攻击
		 *  有可能是人 也有可能是 目标点
		 */ 
		private function moveCloseToPlayerForFight(target:PlayerView,skillId:int=-1):void
		{
//			var startTilePt:Point;
//			var endTilePt:Point;
//			var path:Array;
			///获取默认技能id 
			var defalutSKillId:int;
			if(skillId==-1)defalutSKillId=SkillDyManager.Instance.getDefaultSkill();
			else defalutSKillId=skillId;
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(defalutSKillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
			if(!skillBasicVo)
			{
				skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(SkillDyManager.Instance.getDefaultSkill(),1);
				print(this,"出错了，转职后技能拿不到，防止出错，采用默认技能补救，避免报错...");
			}
			var distance:Number=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY);
			
//			var minDis:int=5;
//			var minDistance:int=skillBasicVo.use_distance>=minDis?skillBasicVo.use_distance:minDis;
//			if(distance<=minDistance+SkillEffectMinLen)
			if(distance<=skillBasicVo.use_distance+SkillEffectLen)  
			{
				//进行攻击
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
				triggerSkillFightMoreRole(skillDyVo.skillId,target);
			}
			else 
			{ 	
//				var lenToEnd:int= skillBasicVo.use_distance-15;
//				if(lenToEnd<0)lenToEnd=0;
//				////向人物靠近  走到 pt 位置 
//				var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,lenToEnd);//,skillBasicVo.use_distance-15
//				var endX:Number=pt.x
//				var endY:Number=pt.y; 
//				var canGetEnd:Boolean=false;
//				if(GridData.Instance.isBlock2(endX,endY))
//				{
//					endX=target.roleDyVo.mapX;
//					endY=target.roleDyVo.mapY;
//					if(GridData.Instance.isBlock2(endX,endY))  //如果还不可走
//					{
//						pt=GridData.Instance.getWalkAbleMapPoint(endX,endY);
//						if(pt)
//						{
//							endX=pt.x;
//							endY=pt.y;
//							canGetEnd=true;
//						}
//					}
//					else 
//					{
//						canGetEnd=true;
//					}
//				}
//				if(!canGetEnd)
//				{
//					endX=target.roleDyVo.mapX;
//					endY=target.roleDyVo.mapY;
//				}
				var endX:Number=0;
				var endY:Number=0;
				var lenToEnd:int= skillBasicVo.use_distance-15;
				if(lenToEnd<0)lenToEnd=0;
				var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,lenToEnd);//,skillBasicVo.use_distance-15
				while(GridData.Instance.isBlock2(pt.x,pt.y)&&lenToEnd>0)
				{
					lenToEnd -=5;
					if(lenToEnd<0)lenToEnd=0;
					pt=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,lenToEnd);//,skillBasicVo.use_distance-15
				}
				endX=pt.x;
				endY=pt.y;
				
				///将要触发的
				DataCenter.Instance.roleSelfVo.heroState.skillId=defalutSKillId;
				DataCenter.Instance.roleSelfVo.heroState.willDo=target;
				
				var startTilePt:Point=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
				var endTilePt:Point=RectMapUtil.getTilePosition(endX,endY);
				if(startTilePt.x==endTilePt.x&&startTilePt.y==endTilePt.y)
				{
					endX=target.roleDyVo.mapX;
					endY=target.roleDyVo.mapY;
				}
				heroMoveToPostion(endX,endY);
//				path=
//				if(!path)  //如果路径不存在则清空
//				{
//					DataCenter.Instance.roleSelfVo.heroState.willDo=null;
//				}
			}
		}
		/** 向px,py 点靠近，并且在可以 攻击的范围内触发技能
		 * @param ptX
		 * @param ptY
		 * @param defaultSkill
		 */		
		private function moveCloseToPointForFight(targetPt:Point,defaultSkill:int=-1):void
		{
//			var path:Array;

			///获取默认技能id 
			var defalutSKillId:int;
			if(defaultSkill==-1)defalutSKillId=SkillDyManager.Instance.getDefaultSkill();
			else defalutSKillId=defaultSkill;
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(defalutSKillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
			var distance:Number=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,targetPt.x,targetPt.y);
			//	if(distance<=150+15)
			var minDis:int=31;///最小格子
			var minDistance:int=skillBasicVo.use_distance>=minDis?skillBasicVo.use_distance:minDis;
			if(distance<=minDistance+SkillEffectLen)
			{
				//进行攻击 
//				triggerSKill(skillDyVo.skillId);
				triggerSkillFightMorePt(skillDyVo.skillId,targetPt);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
			}
			else 
			{ 				
				////向人物靠近  走到 pt 位置 
				var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,targetPt.x,targetPt.y,skillBasicVo.use_distance-15);
			
//				print(this,"target,pt",targetPt,pt);
				DataCenter.Instance.roleSelfVo.heroState.skillId=defaultSkill;
				
				DataCenter.Instance.roleSelfVo.heroState.willDo=targetPt;
				DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=true;
				
				var startTilePt:Point=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
				var endTilePt:Point=RectMapUtil.getTilePosition(pt.x,pt.y);
				if(startTilePt.x==endTilePt.x&&startTilePt.y==endTilePt.y)
				{
					pt.x=targetPt.x;
					pt.y=targetPt.y;
				}
				heroMoveToPostion(pt.x,pt.y);
//				if(path) 
//				{
//					DataCenter.Instance.roleSelfVo.heroState.willDo=targetPt;
//					DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=true;
//				}
			}
		}
		

		
		/** 向活动对象靠近  向  npc靠近 或者向 掉落物品靠近
		 * 向玩家靠近
		 * len   距离目标玩家的距离
		 */		
		private function closeToPlayer(target:PlayerView,len:int=90):Boolean
		{
			var startTilePt:Point;
			var endTilePt:Point;
//			var path:Array;
			var distance:Number=YFMath.distance(HeroPositionProxy.mapX,HeroPositionProxy.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY);
//			if(distance<=len+15)
			if(distance<=len)
			{
				if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)noticePlayerHandle(target.roleDyVo.dyId);
				else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)	noticeNPCHandle(target.roleDyVo.dyId);
				else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) noticeGetGropGoods(target.roleDyVo.dyId);
				else if(target.roleDyVo.bigCatergory==TypeRole.BigCategory_Gather) noticeGetGather(target.roleDyVo.dyId,target.roleDyVo.basicId);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
				return false;
			}
			else 
			{
				////向人物靠近  走到 pt 位置 
				var pt:Point=YFMath.getLinePoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,target.roleDyVo.mapX,target.roleDyVo.mapY,len-10);
				if(GridData.Instance.isBlock2(pt.x,pt.y))
				{
					pt.x=target.roleDyVo.mapX;
					pt.y=target.roleDyVo.mapY;
				}
				var endX:Number=pt.x
				var endY:Number=pt.y;

				DataCenter.Instance.roleSelfVo.heroState.willDo=target;
				DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=false;
				heroMoveToPostion(endX,endY);
				return true;
//				if(path) 
//				{
//					DataCenter.Instance.roleSelfVo.heroState.willDo=target;
//					DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=false;
//					return true;
//				}
			}
			return false;
		}
		/** 与玩家进行 互动  比如  切磋
		 */		
		private function noticePlayerHandle(dyId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
			if(DataCenter.Instance.roleSelfVo.heroState.state==HeroState.ToCompete)  ///进行切磋
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestCompete,{dyId:dyId,name:player.roleDyVo.roleName});
			}
			else if(DataCenter.Instance.roleSelfVo.heroState.state==HeroState.ToTrade)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ToTrade,dyId);
			}
			DataCenter.Instance.roleSelfVo.heroState.state=HeroState.StateNone;
		}
		/** 通知其他模块对npc进行处理
		 */		
		private function noticeNPCHandle(npcDyId:int):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.NPCClicker,npcDyId);
			DataCenter.Instance.roleSelfVo.heroState.setDefaultWillDo();
			TransferPointManager.Instance.autoMove=false;
		}
		/**通知服务端采集物品
		 */		
		private function noticeGetGather(dyId:uint,basicId:int):void
		{
			var gatherBasicVo:Gather_ConfigBasicVo=Gather_ConfigBasicManager.Instance.getGather_ConfigBasicVo(basicId);
			if(TaskDyManager.getInstance().hasGatherTask(gatherBasicVo.item_id1)||TaskDyManager.getInstance().hasGatherTask(gatherBasicVo.item_id2)||TaskDyManager.getInstance().hasGatherTask(gatherBasicVo.item_id3))
			{
				GloableProgress.Instance.showGatherProgress(handleGather,{dyId:dyId,basicId:basicId});
			}
			else 
			{
				NoticeUtil.setOperatorNotice("没有采集任务，无法采集");
			}
		}
		/**处理采集
		 */		
		private function handleGather(data:Object):void
		{
			var dyId:int=data.dyId;
			var basicId:int=data.basicId;
			var gather:GatherPlayer=_senceRolesView.totalViewDict[dyId];
			if(!gather) // 采集物不存在   随便搜一个 
			{
				gather=_senceRolesView.findGatherPlayer(basicId) as GatherPlayer;
			}
			if(gather) // 采集物存在
			{
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RequestGather,dyId);
			}
			else 
			{
				NoticeUtil.setOperatorNotice("采集失败");
			}
		}
		/***通知服务端拾取掉落物品
		 */ 
		private function noticeGetGropGoods(dyId:uint,isCheck:Boolean=true):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
			if(_senceRolesView.isUsablePlayer(player))
			{
				if(isCheck)
				{
					///判断背包是否已经满了
					var isFull:Boolean=BagStoreManager.instantce.checkCanPlaceInBag();//BagStoreManager.instantce.checkCanPlaceInBag(RoleDyVo(player.roleDyVo).itemType,player.roleDyVo.basicId);
					if(isFull)	YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_GetDropGoods,{id:dyId});
					else NoticeManager.setNotice(NoticeType.Notice_id_302);
				}
				else YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_GetDropGoods,{id:dyId});
			}
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
			if(_mouseEffect.actionData)
			{
				_mouseEffect.start();
				_mouseEffect.playDefault();
				_mouseEffect.setMapXY(mapX,mapY);
			}
		}
		
//		private  function drawPath(vect:Vector.<Point>,layer:Sprite):void
//		{
//			layer.graphics.clear();
//			 for each  (var pt:Point in vect)
//			 {
//				 Draw.DrawCircle(layer.graphics,10,pt.x,pt.y,0xFF0000,1,NaN,false);
//			 }
//		}
		/** 同场景 向目标点靠近去打开窗口
		 *  true 表示走路 flase 表示 不进行移动
		 */		
		private function closeToNpcInSameMap(npcDyId:int):Boolean
		{
//			var npcPositionBasicVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcDyId);
//			var distance:Number;
			var playerView:PlayerView=_senceRolesView.totalViewDict[npcDyId];
//			selectPlayer=playerView;
//			distance=RoleDyManager.Instance.distanceToPlayer(playerView.roleDyVo);
//			DataCenter.Instance.roleSelfVo.heroState.state=HeroState.ToOpenNPCWindow;
//			if(distance>160)
//			{
//				var path:Array=heroMoveToPostion(npcPositionBasicVo.pos_x,npcPositionBasicVo.pos_y);
//				if(path)  ///向 NPC靠近
//				{
//					DataCenter.Instance.roleSelfVo.heroState.willDo=playerView;
//					DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=false;
//					return true;
//				}
//			}
//			else 
//			{
//				noticeNPCHandle(playerView.roleDyVo.dyId);
//			}
//			return false;
			
			if(playerView)	return closeToPlayer(playerView,160);
			return false;
		}
		/** 同场景 向目标点靠近   靠近后开始战斗 或者采集
		 * posX
		 * posY
		 * checkDistance  比较的距离  打怪时  需要设置比较距离 ， 如果 只是单纯的走到目标点 就将该值填为0
		 */		
		private function closeToPointInSameMap(posX:int,posY:int,taskwillDoVo:TaskWillDoVo,checkDistance:int=1000):Boolean
		{
			var distance:Number;
			distance=YFMath.distance(HeroPositionProxy.mapX,HeroPositionProxy.mapY,posX,posY);
			//向目标点 靠近 进行怪物
			DataCenter.Instance.roleSelfVo.heroState.state=HeroState.ToFightMonster;
			DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskwillDoVo;
			
			if(distance<=checkDistance)
			{
				noticeToFightMonster();  //可以进行逻辑处理
				return false;
			}
			else //处理 走到目标点事件 
			{
				selectPlayer=null;
				//开始打怪或者 采集
				heroMoveToPostion(posX,posY);
				return true;
			}
			return false;
		}
			
		/**  向  目标点靠近打开npc面板或者攻击怪物
		 * ///小于等于 160像素 直接触发任务对话 否则向npc靠近触发任务对话
		 */		
		private function onTaskEventHandle(e:YFEvent):void
		{
			if(_mapConfigLoadComplete)
			{
				var taskWillDoVo:TaskWillDoVo=e.param as TaskWillDoVo;
				var npcDyId:int=taskWillDoVo.npcDyId;
				var npcPositionBasicVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcDyId);
				var distance:Number;
				var isMove:Boolean;
				if(npcPositionBasicVo.scene_id==DataCenter.Instance.mapSceneBasicVo.mapId) ///同场景
				{
					if(npcPositionBasicVo.basic_id>0) ///为npc玩家
					{
						isMove=closeToNpcInSameMap(npcDyId);
						if(isMove)ZiDongXunLuView.Instance.show();
						var npcConfigVo:Npc_ConfigBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(npcPositionBasicVo.basic_id);
						var url:String=URLTool.getNPCHalfIcon(npcConfigVo.icon_id);
				//		if(!SourceCache.Instance.getRes2(url))	SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,null,false);
					} 
					else     //为 坐标点
					{
						isMove=closeToPointInSameMap(npcPositionBasicVo.pos_x,npcPositionBasicVo.pos_y,taskWillDoVo);
						if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel) //在新手引导的等级范围内
						{
							if(!GuaJiManager.Instance.getStart())  //没有开启挂机
							{
								if(isMove)ZiDongXunLuView.Instance.show();
							}
						}
						else //不再新手阶段
						{
							if(isMove)ZiDongXunLuView.Instance.show();
						}
						
					}
				}
				else   //不是同场景
				{
//					NoticeUtil.setOperatorNotice("跨场景任务待做");
					var seachRoad:SeachRoadVo=new SeachRoadVo();
					seachRoad.npcDyId=npcPositionBasicVo.npc_id;
					seachRoad.npcBasicId=npcPositionBasicVo.basic_id;
					seachRoad.npc_posX=npcPositionBasicVo.pos_x;
					seachRoad.npc_posY=npcPositionBasicVo.pos_y;
					
					var mapId:int=DataCenter.Instance.getMapId();
					seachRoad.roadArr=SearchRoadBasicManager.Instance.getRoadArray(mapId,npcPositionBasicVo.scene_id);
					if(seachRoad.roadArr)
					{
						seachRoad.roadArr.shift();
						DataCenter.Instance.roleSelfVo.heroState.willDo=seachRoad;
						DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskWillDoVo;
						var skipPointBasicVo:SkipPointBasicVo=SkipPointBasicManager.Instance.getSkipPointVo(mapId,seachRoad.roadArr[0]);
						if(skipPointBasicVo)
						{
							var centerPt:Point=skipPointBasicVo.getCentPt();
							heroMoveToPostion(centerPt.x,centerPt.y);
							ZiDongXunLuView.Instance.show();
						}
					}
					else 
					{
						NoticeUtil.setOperatorNotice("本场景不支持寻路");
					}
				}
			}
		}
		
		
		private function smallMapEvent(e:YFEvent):void
		{
			ZiDongXunLuView.Instance.show();
		 	var dyId:int;
			var npcPositionBasicVo:Npc_PositionBasicVo;
			var mapId:int=DataCenter.Instance.getMapId();
			var taskWillDoVo:TaskWillDoVo;
			var seachRoad:SeachRoadVo;
			var skipPointBasicVo:SkipPointBasicVo;
			var centerPt:Point;
			switch(e.type)
			{
				case GlobalEvent.SmallMapMoveToNPC: ///向NPC 靠近
					dyId=int(e.param); 
					npcPositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(dyId);
					if(npcPositionBasicVo.scene_id==mapId)
					{
						var view:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
						if(_senceRolesView.isUsablePlayer(view))
						{
							closeToPlayer(view);
						}
					}
					else /// 不同场景的行走到npc 
					{
						taskWillDoVo=new TaskWillDoVo();
						taskWillDoVo.npcDyId=dyId;
						taskWillDoVo.seach_type=TypeProps.TaskTargetType_NPCDialog;
						seachRoad=new SeachRoadVo();
						seachRoad.npcDyId=npcPositionBasicVo.npc_id;
						seachRoad.npcBasicId=npcPositionBasicVo.basic_id;
						seachRoad.npc_posX=npcPositionBasicVo.pos_x;
						seachRoad.npc_posY=npcPositionBasicVo.pos_y;
						if(seachRoad.roadArr)
						{
							seachRoad.roadArr=SearchRoadBasicManager.Instance.getRoadArray(mapId,npcPositionBasicVo.scene_id);
							seachRoad.roadArr.shift();
							DataCenter.Instance.roleSelfVo.heroState.willDo=seachRoad;
							DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskWillDoVo;
							//					print(this,"跨场景任务待做");
							skipPointBasicVo=SkipPointBasicManager.Instance.getSkipPointVo(mapId,seachRoad.roadArr[0]);
							centerPt=skipPointBasicVo.getCentPt();
							heroMoveToPostion(centerPt.x,centerPt.y);
						}
					}
					break;
					
				case GlobalEvent.SmallMapMoveToMonsterZone: //小地图点击攻击怪物
					dyId=int(e.param); 
					npcPositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(dyId);
					if(npcPositionBasicVo.scene_id==mapId)
					{
						taskWillDoVo=new TaskWillDoVo();
						taskWillDoVo.npcDyId=dyId;
						taskWillDoVo.seach_type=TypeProps.TaskTargetType_MonsterZone;
						closeToPointInSameMap(npcPositionBasicVo.pos_x,npcPositionBasicVo.pos_y,taskWillDoVo,600);
					}
					else /// 不用场景的行走到 目标点进行攻击
					{
						taskWillDoVo=new TaskWillDoVo();
						taskWillDoVo.npcDyId=dyId;
						taskWillDoVo.seach_type=TypeProps.TaskTargetType_MonsterZone;//表示攻击怪物
						seachRoad=new SeachRoadVo();
						seachRoad.npcDyId=npcPositionBasicVo.npc_id;
						seachRoad.npcBasicId=npcPositionBasicVo.basic_id;
						seachRoad.npc_posX=npcPositionBasicVo.pos_x;
						seachRoad.npc_posY=npcPositionBasicVo.pos_y;
						seachRoad.roadArr=SearchRoadBasicManager.Instance.getRoadArray(mapId,npcPositionBasicVo.scene_id);
						if(seachRoad.roadArr)
						{
							seachRoad.roadArr.shift();
							DataCenter.Instance.roleSelfVo.heroState.willDo=seachRoad;
							DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskWillDoVo;
							//					print(this,"跨场景任务待做");
							skipPointBasicVo=SkipPointBasicManager.Instance.getSkipPointVo(mapId,seachRoad.roadArr[0]);
							centerPt=skipPointBasicVo.getCentPt();
							heroMoveToPostion(centerPt.x,centerPt.y);
						}
					}
					break;
				case GlobalEvent.SmallMapMoveToWorldPt:		//世界地图  坐标点
					DataCenter.Instance.roleSelfVo.heroState.setDefaultWillDo();
					TransferPointManager.Instance.autoMove=false;
					var smallMapWorldVo:SmallMapWorldVo=e.param as SmallMapWorldVo;
					if(smallMapWorldVo.sceneId==mapId)
					{
						taskWillDoVo=new TaskWillDoVo();
						taskWillDoVo.npcDyId=-1;
						taskWillDoVo.seach_type=TypeProps.TaskTargetType_WorldMapPt; ///行走到目标点
						closeToPointInSameMap(smallMapWorldVo.pos_x,smallMapWorldVo.pos_y,taskWillDoVo,0);
					}
					else /// 不用场景的行走到 目标点进行攻击
					{
						taskWillDoVo=new TaskWillDoVo();
						taskWillDoVo.npcDyId=-1;
						taskWillDoVo.seach_type=TypeProps.TaskTargetType_WorldMapPt;//行走到目标点
						seachRoad=new SeachRoadVo();
						seachRoad.npcDyId=-1;
						seachRoad.npcBasicId=0;
						seachRoad.npc_posX=smallMapWorldVo.pos_x;
						seachRoad.npc_posY=smallMapWorldVo.pos_y;
						seachRoad.roadArr=SearchRoadBasicManager.Instance.getRoadArray(mapId,smallMapWorldVo.sceneId);
						if(seachRoad.roadArr)
						{
							seachRoad.roadArr.shift();
							DataCenter.Instance.roleSelfVo.heroState.willDo=seachRoad;
							DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskWillDoVo;
							//					print(this,"跨场景任务待做");
							skipPointBasicVo=SkipPointBasicManager.Instance.getSkipPointVo(mapId,seachRoad.roadArr[0]);
							centerPt=skipPointBasicVo.getCentPt();
							heroMoveToPostion(centerPt.x,centerPt.y);
						}
					}
					break;
			}
		}
		/**
		 * @param e 地图跳转
		 */		
		private function smallMapSkipToEvent(e:YFEvent):void
		{
//			var pt:Point;
//			var dyId:String;
			var flyBootVo:FlyBootVo=e.param as FlyBootVo;
			var isTriiger:Boolean=true;
			if(flyBootVo.mapId==DataCenter.Instance.getMapId())
			{
				if(GridData.Instance.isBlock2(flyBootVo.mapX,flyBootVo.mapY))
				{
					isTriiger=false
				}
			}
			if(isTriiger)
			{
//				_senceRolesView.heroView.stopMove();
				if(DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel>0)//如果为vip   vip可以使用小飞鞋
				{
					flyBootVo.flyItemPos=0;
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_SKipToPoint,flyBootVo);
					_senceRolesView.heroView.stopMove();
					DataCenter.Instance.roleSelfVo.heroState.willDo=flyBootVo;
					DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=false;
				}
				else   //非vip
				{
					var flyPorpsPos:int=PropsDyManager.instance.getFirstPropsPostionFromBagByPropType(TypeProps.PROPS_TYPE_FLY);
					if(flyPorpsPos>0)
					{
						flyBootVo.flyItemPos=flyPorpsPos;
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_SKipToPoint,flyBootVo);
						_senceRolesView.heroView.stopMove();
						DataCenter.Instance.roleSelfVo.heroState.willDo=flyBootVo;
						DataCenter.Instance.roleSelfVo.heroState.isAtkSkill=false;
					}
					else 
					{
						NoticeUtil.setOperatorNotice("背包没有传送道具");
					}
				}
			}
			else NoticeUtil.setOperatorNotice("该点不可到达");
		}
		
		/**向角色 玩家靠近 
		 * 
		 */		
		private function moveToRolePlayer(e:YFEvent):void
		{
			var data:Object=e.param;
			var player:PlayerView=_senceRolesView.totalViewDict[data.dyId] as PlayerView;
			DataCenter.Instance.roleSelfVo.heroState.state=data.state;
			DataCenter.Instance.roleSelfVo.heroState.willDo=player;
			var pt:Point=data.pt;
			heroMoveToPostion(pt.x,pt.y);
		}
		
		
		/**人物角色走到目标点
		 */
		private function heroMoveToPt(e:YFEvent):void
		{
			if(!_senceRolesView.heroView.isDead)
			{
				var pt:Point=e.param as Point;
				heroMoveToPostion(pt.x,pt.y);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
			}
		}
		/**通知小地图进行路径行走
		 */		
		private function noticeSmallMapMovePath(path:Array):void
		{
			///将数据传给 smallMapView
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapGetMovePath,path);   

		}
		
		/**处理 移动buff 
		 * handleSpecialBuff2 移动 buff 
		 * handleSpecialBuff 战斗buff
		 */
		private function handleSpecialBuff2():Boolean
		{
			if(SpecialSkillManager.YunXuan)
			{
				NoticeUtil.setOperatorNotice("晕眩中...");
				if(!_senceRolesView.heroView.isDead)
				{
					_senceRolesView.heroView.play(TypeAction.Stand,_senceRolesView.heroView.activeDirection);
				}
				ZiDongXunLuView.Instance.hide();
				return true;
			}
			if(SpecialSkillManager.Dingshen)
			{
				NoticeUtil.setOperatorNotice("定身中...");
				if(!_senceRolesView.heroView.isDead)
				{
					_senceRolesView.heroView.play(TypeAction.Stand,_senceRolesView.heroView.activeDirection);
				}
				ZiDongXunLuView.Instance.hide();
				return true;
			}
			return false; 
		}
		
		private function heroMoveToPostion(endX:int,endY:int):void
		{
			if(!_senceRolesView.heroView.isDead)
			{
				if(handleSpecialBuff2())return ;//处理移动buff
				_preEndX=endX;
				_preEndY=endY;
				//			print(this,"moveIt...",endX,endY);
				noticeOutSit();//如果为打坐取消打坐
				var path:Array;
				var startTilePt:Point=RectMapUtil.getTilePosition(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY);
				var endTilePt:Point=RectMapUtil.getTilePosition(endX,endY);
				path=AstarCache.Instance.getAstarRoad(DataCenter.Instance.getMapId(),startTilePt,endTilePt);
				if(path==null)
				{
					if(_aStar.seachPath(startTilePt,endTilePt))
					{
						path=_aStar.getPath();
//						AstarCache.Instance.put(DataCenter.Instance.getMapId(),startTilePt,endTilePt,path);
//						print(this,"次数寻路点去掉了");
					}
					else 
					{
						print(this,"搜索失败...");
						heroMovingComplete();
					} 
				}
				
				if(path)
				{
					noticeMovePath(path);
					noticeSmallMapMovePath(path);
					
				}
			}
			else 
			{
				NoticeUtil.setOperatorNotice("玩家已经死亡");
			}

		}
		
		
		
		/**通讯告知开始pk   攻击者     群攻 无点 群攻
		 */
		private function noticeFightMore(fightVo:FightMoreVo):void
		{
//			print(this,"通讯目标id--",fightVo.pt);
//			noticeMountOut();///如果在马上 就进行下马攻击
//			noticeOutSit();//如果为打坐取消打坐
//			
//			if(DataCenter.Instance.roleSelfVo.pkMode==TypeRole.PKMode_Peace)
//			{
//				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)   //// 新手 引导阶段才启用 挂机
//				{
//					if(fightVo.uAtkArr.length>0)GuaJiManager.Instance.start();//战斗的时候调用挂机
//				}
//			}
//			GloableProgress.Instance.stopGatherProgress(); //不显示采集进度条
			noticeFightIt(fightVo);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore,fightVo);
			
			if(fightVo.skillId==SkillDyManager.Instance.getDefaultSkill())
			{
				print(this,"普通攻击:"+fightVo.skillId);
			}
		}
		/** 通讯告知开始pk   有点 群攻
		 */		
		private function noticeFightMorePt(fightVo:FightMoreVo):void
		{ 
//			noticeMountOut();///如果在马上 就进行下马攻击
//			noticeOutSit();//如果为打坐取消打坐
//			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore_Pt,fightVo);
//			
//			if(DataCenter.Instance.roleSelfVo.pkMode==TypeRole.PKMode_Peace)
//			{
//				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)   //// 新手 引导阶段才启用 挂机
//				{
//					if(fightVo.uAtkArr.length>0)GuaJiManager.Instance.start();//战斗的时候调用挂机
//				}
//			}
//			GloableProgress.Instance.stopGatherProgress(); //不显示采集进度条
			trace(fightVo.pt,fightVo.skillId);
			noticeFightIt(fightVo);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore_Pt,fightVo);
		}
		
		/**击退   不包含技能目标点
		 */
		private function noticeFightMoreBeatBack(fightVo:FightMoreVo):void
		{
			noticeFightIt(fightVo);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMoreBeatBack,fightVo);
		}
		
		/**击退 包含技能目标点
		 */
		private function noticeFightMorePtBeatBack(fightVo:FightMoreVo):void
		{
			noticeFightIt(fightVo);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_FightMore_PtBeatBack,fightVo);
		}
		

//		private var _preTime:Number=0;
		
		/**战斗逻辑处理
		 */
		private function noticeFightIt(fightVo:FightMoreVo):void
		{
			///预先播放CD 
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKillSelfPlayCD,fightVo.skillId);
//			trace("战斗:"+fightVo.skillId+",时间:"+(getTimer()-_preTime));
//			_preTime=getTimer(); 
			 
//			noticeMountOut();///如果在马上 就进行下马攻击
//			noticeOutSit();//如果为打坐取消打坐
			
			if(DataCenter.Instance.roleSelfVo.pkMode==TypeRole.PKMode_Peace)
			{
			 	if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)   //// 新手 引导阶段才启用 挂机
				{
					if(fightVo.uAtkArr)
					{
						if(fightVo.uAtkArr.length>0)GuaJiManager.Instance.start();//战斗的时候调用挂机
					}
				}
			}
			GloableProgress.Instance.stopGatherProgress(); //不显示采集进度条
			_senceRolesView.heroView.stopMove(); //发送技能停止攻击
			stopMouseEffect();
		}
			
		
		private function blinkMoveComplete(data:Object):void
		{
			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
			//		if(DataCenter.Instance.roleSelfVo.willGoPt)	senceRolesView.heroView.moveTo(DataCenter.Instance.roleSelfVo.willGoPt.x,DataCenter.Instance.roleSelfVo.willGoPt.y,6,complete);
		}
		/** 主角移动结束
		 */		
		private function heroMovingComplete(param:Object=null):void
		{
			_senceRolesView.heroView.noticeHeroMoveComplete();
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoveComplete);
			stopMouseEffect();
			_senceRolesView.heroView.play(TypeAction.Stand); 
			ZiDongXunLuView.Instance.hide();
			var willDo:PlayerView=DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView;
			///进行攻击
			if(_senceRolesView.isUsablePlayer(willDo)) 
			{
				///对人物进行攻击 
				if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
				{
					
					if(RoleDyManager.Instance.canFight(RoleDyVo(willDo.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))
						moveCloseToPlayerForFight(DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView,DataCenter.Instance.roleSelfVo.heroState.skillId);
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet) //为宠物
				{
					if(RoleDyManager.Instance.canFight(RoleDyVo(willDo.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))   ///进行pk攻击
						moveCloseToPlayerForFight(DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView,DataCenter.Instance.roleSelfVo.heroState.skillId);
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  ///为其他玩家 
				{
					if(DataCenter.Instance.roleSelfVo.heroState.state!=HeroState.StateNone)  ////处理 交易   切磋
					{
						noticePlayerHandle(willDo.roleDyVo.dyId);
					}
					else 
					{
						if(RoleDyManager.Instance.canFight(RoleDyVo(willDo.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode))   ///进行pk攻击
							moveCloseToPlayerForFight(DataCenter.Instance.roleSelfVo.heroState.willDo as PlayerView,DataCenter.Instance.roleSelfVo.heroState.skillId);
					}
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC) ///处理npc 任务 
				{
					//	处理 npc  
					noticeNPCHandle(willDo.roleDyVo.dyId);
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) ///处理物品掉落 任务
				{
					noticeGetGropGoods(willDo.roleDyVo.dyId);
				}
				else if(willDo.roleDyVo.bigCatergory==TypeRole.BigCategory_Gather) //为采集物
				{
					noticeGetGather(willDo.roleDyVo.dyId,willDo.roleDyVo.basicId);
				}
			}
			else if(DataCenter.Instance.roleSelfVo.heroState.willDo is Point)     ///走到目标点
			{
				if(DataCenter.Instance.roleSelfVo.heroState.isAtkSkill) ///移动到目标点触发技能
				{
					triggerSkillFightMorePt(DataCenter.Instance.roleSelfVo.heroState.skillId,Point(DataCenter.Instance.roleSelfVo.heroState.willDo));
				}
			}
			else if(DataCenter.Instance.roleSelfVo.heroState.state==HeroState.ToFightMonster)  //走到目标点 进行打怪
			{
				//进行做任务  比如杀怪 或者  或者 物品摘取
				var canCheck:Boolean=noticeToFightMonster(); //进行打怪
				if(canCheck)
				{
					checkChangeMap();//检测地图跳转
				}
			}
			else   ///切换 地图场景判断
			{
				checkChangeMap();//检测地图跳转
			}
		}
		
		/** 检测是否可以进行地图跳转
		 */
		private function checkChangeMap():void
		{
			if(_bgMapEffectView.transferVisible) //传送点可见的时候
			{
				var mapX:int=_senceRolesView.heroView.roleDyVo.mapX;
				var mapY:int=_senceRolesView.heroView.roleDyVo.mapY;
				///如果该点为地图跳转点则进行消息发送并且进行地图跳转
				if(GridData.Instance.isSkipNode(mapX,mapY))
				{
					noticeChangeMap();
				}
			}
		}
		
		/**进行打怪   或者采集
		 *  如果返回值 为true 则表示其为 单纯的行走到目标点 这个时候需要检测下目标点是否可以进行地图跳转
		 */		
		private function noticeToFightMonster(param:Object=null):Boolean
		{
			var taskWillDo:TaskWillDoVo=DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo;
			var player:PlayerView;
			switch(taskWillDo.seach_type)
			{
				case TypeProps.TaskTargetType_Monster:
					player=selectPlayer;
					if(_senceRolesView.isUsablePlayer(player))
					{
						if(player.roleDyVo.basicId!=taskWillDo.seach_id)
						{
							player=_senceRolesView.findCanFightPlayer2(taskWillDo.seach_id);
						}
					}
					else player=_senceRolesView.findCanFightPlayer2(taskWillDo.seach_id);
					if(player)
					{
						DataCenter.Instance.roleSelfVo.heroState.willDo=null;
						selectPlayer=player;
						triggerSkillFightMoreRole(SkillDyManager.Instance.getDefaultSkill(),selectPlayer);
					}
					else NoticeUtil.setOperatorNotice("找不到目标对象");
					startNewGuideGuaji();
					break;
				case TypeProps.TaskTargetType_MonsterZone:  ///行走到怪物区域 
					player=selectPlayer;
					player=_senceRolesView.findCanFightPlayer();
					if(player)
					{
						DataCenter.Instance.roleSelfVo.heroState.willDo=null;
						selectPlayer=player;
						triggerSkillFightMoreRole(SkillDyManager.Instance.getDefaultSkill(),selectPlayer);
					}
					break;
				case TypeProps.TaskTargetType_WorldMapPt:  ///行走到目标点 该点是玩家随机点击小地图产生的
					DataCenter.Instance.roleSelfVo.heroState.willDo=null;
					ZiDongXunLuView.Instance.hide();
					return true;
					break;
				case TypeProps.TaskTargetType_Gather:   ///自动采集
					player=selectPlayer;
					if(_senceRolesView.isUsablePlayer(player))
					{
						if(player.roleDyVo.basicId!=taskWillDo.seach_id)
						{
							player=_senceRolesView.findGatherPlayer(taskWillDo.seach_id);
						}
					}
					else player=_senceRolesView.findGatherPlayer(taskWillDo.seach_id);
					if(player)
					{
						DataCenter.Instance.roleSelfVo.heroState.willDo=null;
						selectPlayer=player;
						closeToPlayer(selectPlayer);
					}
					else NoticeUtil.setOperatorNotice("找不到目标对象");
//					startNewGuideGuaji();
					break;
			}
			return false;
		}
		/**开启新手挂机
		 */		
		private function startNewGuideGuaji():void
		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel) // 小于这个等级
//			{
				GuaJiManager.Instance.start();
//			}
		}
		/**准备进入副本
		 */
		private function onGotoEnterRaid(e:YFEvent):void
		{
			var raidNPCVo:RaidNPCVo=e.param as RaidNPCVo;
			//副本 id  
			var myRaidId:int= RaidManager.Instance.getRaidIdByGroupId(raidNPCVo.raidId);			
			
			var raidBasicVo:RaidVo=RaidManager.Instance.getRaidVo(myRaidId); //获取副本场景信息 
			//下一场景数据
			var nextMapBasicVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(raidBasicVo.enter_map_id);
			//加载 xx文件
			var xxMapUrl:String=URLTool.getMapConfig(nextMapBasicVo.resId);
			if(!SourceCache.Instance.getRes2(xxMapUrl))  //加载xx2d  加载完成后才进行地图跳转     
			{
									
				MapLoaderLogoView.Instance.showLogo();
				SourceCache.Instance.addEventListener(xxMapUrl,onXX2dEnterRaidComplete);
				SourceCache.Instance.forceLoadRes(xxMapUrl,raidNPCVo);  //进行加载
			}
			else  //地图文件已经加载完成 切换场景
			{
				noticeEnterRaidMap(raidNPCVo);
			}
		}
		/**通知进入副本
		 */		
		private function noticeEnterRaidMap(raidNPCVo:RaidNPCVo):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterRaid,raidNPCVo);/////进入副本 

		}
		
		
		/**通知服务端进行场景 切换 
		 */
		private function noticeChangeMap():void
		{
			var xxMapUrl:String;
			var nextMapBasicVo:MapSceneBasicVo; //下一场景数据

			//当为安全地图 或者野外地图
			if(DataCenter.Instance.mapSceneBasicVo.type==TypeRole.MapScene_SafeArea||DataCenter.Instance.mapSceneBasicVo.type==TypeRole.MapScene_Field)  
			{
				//优化处理预载 场景
				var mapId:int=SkipPointBasicManager.Instance.getOtherMapId(DataCenter.Instance.getMapId(),HeroPositionProxy.mapX,HeroPositionProxy.mapY);
				if(mapId>0)
				{
					nextMapBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(mapId);
					//加载 xx文件
					xxMapUrl=URLTool.getMapConfig(nextMapBasicVo.resId);
					if(!SourceCache.Instance.getRes2(xxMapUrl))  //加载xx2d  加载完成后才进行地图跳转     
					{
//						print(this,"此处显示场景切换tips待做???");
						MapLoaderLogoView.Instance.showLogo();
						SourceCache.Instance.addEventListener(xxMapUrl,onXX2dComplete);
						SourceCache.Instance.loadRes(xxMapUrl);  //进行加载
					}
					else  //地图文件已经加载完成 切换场景
					{
						noticeChangeMainMap();
					}
				}
			}
			else if(DataCenter.Instance.mapSceneBasicVo.type==TypeRole.MapScene_Raid)  //当为副本地图
			{
				
				var raidBasicVo:RaidVo=RaidManager.Instance.getRaidVo(RaidManager.raidId); //获取副本场景信息 
				//判断下一场景
				if(raidBasicVo.nextRaidId>0) //有后续副本
				{
					var nextRaidVo:RaidVo=RaidManager.Instance.getRaidVo(raidBasicVo.nextRaidId);
					nextMapBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(nextRaidVo.enter_map_id);
				}
				else
				{
					nextMapBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(raidBasicVo.exit_map_id);
				}
				 
				//加载 xx文件
				xxMapUrl=URLTool.getMapConfig(nextMapBasicVo.resId);
				if(!SourceCache.Instance.getRes2(xxMapUrl))  //加载xx2d  加载完成后才进行地图跳转     
				{
					MapLoaderLogoView.Instance.showLogo();
					SourceCache.Instance.addEventListener(xxMapUrl,onXX2dRaidComplete);
					SourceCache.Instance.loadRes(xxMapUrl);  //进行加载
				}
				else  //地图文件已经加载完成 切换场景
				{
					noticeChangeRaidMap();
				}
			}
		}
		
		
		/**进行 主场景地图跳转 
		 */
		private function noticeChangeMainMap():void 
		{
			//进行socket 通讯 进行地图跳转
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_ChangeMapScence);
		}
		
		/**进行 副本场景地图跳转 
		 */
		private function noticeChangeRaidMap():void 
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RequestChangeMap);
		}

		
		/**主场景数据加载完成
		 */
		private function onXX2dComplete(e:YFEvent):void
		{
			MapLoaderLogoView.Instance.hideLogo();
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onXX2dComplete);
			noticeChangeMainMap();
		}
		
		/**副本场景数据加载完成
		 */
		private function onXX2dRaidComplete(e:YFEvent):void
		{
			MapLoaderLogoView.Instance.hideLogo();
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onXX2dRaidComplete);
			noticeChangeRaidMap();
		}
		
		/**副本场景数据加载完成
		 */
		private function onXX2dEnterRaidComplete(e:YFEvent):void
		{
			MapLoaderLogoView.Instance.hideLogo();
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onXX2dEnterRaidComplete);
			
			var data:Vector.<Object>=Vector.<Object>(e.param);
			var raidNPCVo:RaidNPCVo=data[0] as RaidNPCVo;
			noticeEnterRaidMap(raidNPCVo);
		}
		
		
		/**通知服务端 主角色发生移动 通知客户端进行广播 
		 */
		private function noticeMovePath(path:Array):void
		{
				GloableProgress.Instance.stopGatherProgress(); //不显示采集进度条
//			print(this,"path::",path);
				//主角直接走路
				var heroId:uint=DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
				var mapX:int=DataCenter.Instance.roleSelfVo.roleDyVo.mapX;
				var mapY:int=DataCenter.Instance.roleSelfVo.roleDyVo.mapY;
				//通知所有玩家走路
				///优化路径发送  只发3个点  
				var pathLen:int=path.length;
				if(pathLen>3)pathLen=3;
				var msgPath:Array=path.slice(0,pathLen);
//				var  playerMoveVo:PlayerBeginMoveVo=new PlayerBeginMoveVo();
//				playerMoveVo.path=msgPath;
//				playerMoveVo.curentPostion=new Point(mapX,mapY);
				var speed:Number;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount)
				{
					speed=MountDyManager.Instance.getRidingMountSpeed();
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
					else DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=speed;
				}
				else
				{
					speed=CharacterDyManager.Instance.speed;          
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
					else DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=speed;
				}            
//				playerMoveVo.speed=speed
		//		YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroBeginMovePath,playerMoveVo);  // 玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug
				//	print(this,"玩家刚开始移动注释掉了,该方法导致人物挑战到其他点出现bug");
				////主角先移动  
				_senceRolesView.heroView.setMovingIndex(path);
				var playerMoveResultVo:PlayerMoveResultVo=new PlayerMoveResultVo();//PoolCenter.Instance.getFromPool(PlayerMoveResultVo) as PlayerMoveResultVo;
				playerMoveResultVo.id=_senceRolesView.heroView.roleDyVo.dyId;
				playerMoveResultVo.mapX=mapX;
				playerMoveResultVo.mapY=mapY;
				playerMoveResultVo.speed=speed;
				playerMoveResultVo.path=path;
				updatePlayerMovePath(playerMoveResultVo,false,false);
				
				///更新主角当前的状态   当为坐骑状态时切换坐骑状态
				if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Sit)DataCenter.Instance.roleSelfVo.roleDyVo.state=TypeRole.State_Normal;
				if(TradeDyManager.isTrading) /// 处于交易状态
				{
					var tradeRole:PlayerView=_senceRolesView.totalViewDict[TradeDyManager.otherDyId];
					if(_senceRolesView.isCanUsePlayer(tradeRole))
					{
						var tradeDistance:Number=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,tradeRole.roleDyVo.mapX,tradeRole.roleDyVo.mapY);
						if(tradeDistance>=320)  ///距离大于320 取消交易状态
						{
							noticeCancelTrade();
						}
					}
					else   ///直接取消交易状态
					{
						noticeCancelTrade();
					}
				}
		}
		/**取消交易
		 */ 
		private function noticeCancelTrade():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CancelTrade);	
		}
		/**主角发生移动  判断 主角和其宠物之间的距离 是否超过他们之间的距离    宠物 移动 逻辑 
		 */ 
		private function onPetMovingEvent(e:YFEvent):void
		{
			var destPoint:Point=new Point(Point(e.param).x,Point(e.param).y);
			var fightPlayerArr:Array=[];
			var fightpetId:int=PetDyManager.fightPetId;
			if(fightpetId>0)fightPlayerArr.push(fightpetId);
			var dyId:uint;
			var petPlayView:PetPlayerView;///出战宠物
			var distance:Number;
			var endPoint:Point;//=new Point(_senceRolesView.heroView._mapX,_senceRolesView.heroView._mapY);
			var startPoint:Point;
			var path:Array;
			var speed:Number;
			var degree:int;
			var len:int =fightPlayerArr.length;
			var petIndex:int=0;///宠物索引   第几个宠物 
			var degreeArr:Array=DirectionUtil.getDegreeArr(HeroPositionProxy.direction,len); ///人物站立的方向 所对应的宠物方向角度数组
			
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
						if(petPlayView.activeDirection!=HeroPositionProxy.direction&&distance<=PetPlayerView.Distance)
						{
							distance=PetPlayerView.Distance;
						}
						if(distance>=PetPlayerView.Distance&&distance<=PetPlayerView.MaxDistance)
						{
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
							
//							endPoint=YFMath.getLinePoint3(HeroPositionProxy.mapX,HeroPositionProxy.mapY,PetPlayerView.MinDistance,degree);
//							endpt.x=_senceRolesView.heroView._mapX;
//							endpt.y=_senceRolesView.heroView._mapY;
//							endPoint=YFMath.getLinePoint3(endpt.x,endpt.y,PetPlayerView.MinDistance,degree);
//							endPoint=RectMapUtil.getTilePosition(endPoint.x,endPoint.y);///获取 节点 
//							endPoint=GridData.Instance.getUsablePt(endPoint);
								
//							destPoint=YFMath.getLinePoint3(destPoint.x,destPoint.y,PetPlayerView.MinDistance,degree);
							destPoint=YFMath.getLinePoint3(HeroPositionProxy.mapX,HeroPositionProxy.mapY,PetPlayerView.MinDistance,degree);
							destPoint=RectMapUtil.getTilePosition(destPoint.x,destPoint.y);///获取 节点 
							destPoint=GridData.Instance.getUsablePt(destPoint);
							destPoint=RectMapUtil.getFlashCenterPosition(destPoint.x,destPoint.y);
//							//宠物寻路
//       					startPoint=RectMapUtil.getTilePosition(petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
//							_aStar.seachPath(startPoint,endPoint);
//							path=_aStar.getPath();
							//宠物无需寻路
//							endPoint=RectMapUtil.getFlashCenterPosition(endPoint.x,endPoint.y);
							path=[destPoint];
							///PetDyManager.Instance.getPetDyVo(petPlayView.roleDyVo.dyId).speed;
							if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount)
							{
								speed=MountDyManager.Instance.getRidingMountSpeed();
								if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
							}
							else
							{
								speed=CharacterDyManager.Instance.speed;          
								if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
							}  	
							petPlayView.setMoving(HeroPositionProxy.direction);////设置通讯通讯索引
							petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroPositionProxy.direction},true);
						//	print(this,"宠物进行正常移动 ！");
						}
					}
					if(distance>=PetPlayerView.MaxDistance)
					{
//						print(this,"拉取宠物");
						degree=DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
						endPoint=YFMath.getLinePoint4(HeroPositionProxy.mapX,HeroPositionProxy.mapY,10,degree);
						//	endPoint为 地图坐标
//						var pullpetVo:PullPetVo=petPlayView.noticePullPet(endPoint.x,endPoint.y);
						
						petPlayView.noticePullPet(endPoint.x,endPoint.y);
//						updatePullPet(pullpetVo); ///更新宠物状态 不需要进行通讯了
//						petPlayView.skipTo(pullpetVo.mapX,pullpetVo.mapY);///主角 先自己移动
//						path=[endPoint];
//						speed=20;
//						petPlayView.setMoving(HeroPositionProxy.direction);////设置通讯通讯索
//						petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroPositionProxy.direction},false);  //  快速移动 
//						heroPullPet(petPlayView,path);
					}
				}
				petIndex++;
			}
		}		
		
		
		/**主角拉取宠物， 服务端只是返回给除去主角以外的其他玩家
		 */
		private function heroPullPet(petPlayView:PetPlayerView,path:Array):void
		{
			var speed:Number=20;
			petPlayView.setMoving(HeroPositionProxy.direction);////设置通讯通讯索
//			petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroPositionProxy.direction},false);  //  快速移动 
			var len:int=path.length;
			petPlayView.setMapXY(path[len-1].x,path[len-1].y);
			petPlayView.updatePullPet();
		}
		private function completePetMove(petPlayView:PetPlayerView):void
		{
			if(_senceRolesView.isUsablePlayer(petPlayView))	petPlayView.play(TypeAction.Stand);
		}
		
		/**宠物向目标玩家靠近 准备发起攻击 
		 */ 
		public function updatePetMoveToTarget(petId:uint,targetId:uint):void
		{
			var targetPlayer:PlayerView=_senceRolesView.totalViewDict[targetId] as PlayerView;
			if(targetPlayer)
			{
				var petPlayView:PetPlayerView=_senceRolesView.totalViewDict[petId] as PetPlayerView;
				var petBasicVo:PetBasicVo=PetBasicManager.Instance.getPetConfigVo(petPlayView.roleDyVo.basicId);
				//			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(petBasicVo.defaultSkill);
				//			var fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(1)); //获取技能属性
				
				var degree:Number=YFMath.getDegree(targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY,petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
				var endPoint:Point=YFMath.getLinePoint4(targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY,80,degree); ///走到80位置处
				endPoint=RectMapUtil.getTilePosition(endPoint.x,endPoint.y);///获取 节点 
				endPoint=GridData.Instance.getUsablePt(endPoint);
				var startPoint:Point=RectMapUtil.getTilePosition(petPlayView.roleDyVo.mapX,petPlayView.roleDyVo.mapY);
				_aStar.seachPath(startPoint,endPoint);
				var path:Array=_aStar.getPath(); 
//				var petDyVo:PetDyVo=PetDyManager.Instance.getPetDyVo(petId);
//				var speed:int=petDyVo.speed;
				var speed:int;//CharacterDyManager.Instance.speed;  
				if(DataCenter.Instance.roleSelfVo.roleDyVo.state==TypeRole.State_Mount)
				{
					speed=MountDyManager.Instance.getRidingMountSpeed();
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
				}
				else
				{
					speed=CharacterDyManager.Instance.speed;          
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
				}  	
				petPlayView.setMoving(HeroPositionProxy.direction);////设置通讯通讯索引
				petPlayView.sMoveTo(path,speed,petMoveComplete,{player:petPlayView,direction:HeroPositionProxy.direction});
			}
		}
		 
		/**更新拉取宠物
		 */		
		public function updatePullPet(pullPetVo:PullPetVo):void
		{
			var petView:PetPlayerView=_senceRolesView.totalViewDict[pullPetVo.dyId] as PetPlayerView;
//			petView.skipTo(pullPetVo.mapX,pullPetVo.mapY);
//			if(!PetDyManager.Instance.hasPet(pullPetVo.dyId))  //只对非自己的宠物进行拉取 
//			{
				if(_senceRolesView.isUsablePlayer(petView))	
				{
					
//					var path:Array=[new Point(pullPetVo.mapX,pullPetVo.mapY)];
//					var speed:Number=20;
					var direction:int=DirectionUtil.getDirection(petView.roleDyVo.mapX,petView.roleDyVo.mapY,pullPetVo.mapX,pullPetVo.mapY);
					petView.setMoving(direction);////设置通讯通讯索
//					petView.sMoveTo(path,speed,petMoveComplete,{player:petView,direction:direction},true);
					petView.setMapXY(pullPetVo.mapX,pullPetVo.mapY);
					petView.updatePullPet();
				}
//			}
			
		}
		/**更新宠物出战
		 */ 
		public function updatePetFight(fightPetId:uint):void
		{
			var petPlayView:PetPlayerView=_senceRolesView.totalViewDict[fightPetId] as PetPlayerView;
			petPlayView.updateTarget(true);
		}
		
		
		/**短距离移动位置改变 这个消息 不会产生 玩家九宫格的改变
		 */
		public function updateShortMove(dyId:int,mapX:int,mapY:int):void
		{
			var petPlayView:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView;
			petPlayView.setMapXY(mapX,mapY);
		}
		

		/**  跳到目标点 判断是否能进行对话
		 */		
		public function updateSkipToPointForWillDo():void
		{
			_senceRolesView.heroView.checkAlphaPoint(true);
			resizeItForBugResolve();
			ZiDongXunLuView.Instance.hide();
			GuaJiManager.Instance.stop();
			var flyBootVo:FlyBootVo=DataCenter.Instance.roleSelfVo.heroState.willDo as FlyBootVo;
			if(flyBootVo)
			{
				if(flyBootVo.seach_type==TypeProps.TaskTargetType_Monster)//怪物类型 
				{
					if(flyBootVo.seach_id>0)  //开始 自动挂机
					{
						GuaJiManager.Instance.start();
					}
				}
				else if(flyBootVo.seach_type==TypeProps.TaskTargetType_Gather) // 采集类型
				{
					if(flyBootVo.seach_id>0)  //开始 自动挂机
					{
						var taskWillDo:TaskWillDoVo=new TaskWillDoVo();
						taskWillDo.seach_type=TypeProps.TaskTargetType_Gather;
						taskWillDo.seach_id=flyBootVo.seach_id;
						DataCenter.Instance.roleSelfVo.heroState.taskWinDoVo=taskWillDo;
						var time:TimeOut=new TimeOut(500,noticeToFightMonster);
						time.start();//此处需要延迟 因为跳转后 视野是没有玩家的  是先 跳转到目标点 然后在添加玩家
//						GuaJiManager.Instance.start();
					}
				}
				else 
				{
					if(flyBootVo.seach_id>0)//  为 npc类型
					{
						//	处理 npc 
						noticeNPCHandle(flyBootVo.seach_id); //打开 npc窗口
					}
				}
			}
		}
		
		/**客户端非法移动  拉取客户端到正确的坐标位置
		 */		
		public function pullHero(x:int,y:int):void
		{
			_senceRolesView.heroView.skipTo(x,y);
			
			if(YFMath.distance(x,y,_preEndX,_preEndY)>=30)
			{
				heroMoveToPostion(_preEndX,_preEndY);
			}
		}
		
		/**同一张场景地图的	切换 
		 */		
		public function updateSameMapChange(pt:Point):void
		{
			_senceRolesView.disposeMapExceptNPC();
			stopMouseEffect();
			_senceRolesView.heroView.skipTo(pt.x,pt.y);
			ZiDongXunLuView.Instance.hide();
			GuaJiManager.Instance.stop();
			_senceRolesView.heroView.checkAlphaPoint(true);
		}
		/**
		 *  更新  buff 伤害
		 * @param dyId 作用玩家
		 * @param buffId  buff id
		 * @param hp	 血量hp
		 * @param hpChange   hp 改变量
		 * @param mp	 魔法值
		 * @param mpChange	 魔法值改变量
		 * 
		 */		
		public function updateBuffDamage(dyId:int,buffId:int,hp:int,hpChange:int,mp:int,mpChange:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(_senceRolesView.isUsablePlayer(player))
			{
				if(hpChange!=0)
				{
					player.roleDyVo.hp=hp;
					player.showBufHpfChange(hpChange);
					if(hpChange>0)
					{
						var url:String=URLTool.getSkill(30021);
						var effectData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(effectData)
						{
							player.addFrontEffect(effectData,[0]);
						}
						else 
						{
							SourceCache.Instance.loadRes(url);
						}
					}
				}
				if(mpChange!=0)
				{
					player.roleDyVo.mp=mp;
//					print(this,"buff 魔法伤害特效等待播放......");
					player.showBuffMpChange(mpChange);
				}
				if(buffId!=0)
				{
					updateBuff(dyId,buffId);
				}
				player.updateHp();
			}
		}
		/** 更新 buff特效
		 * @param playerId
		 * @param buffId
		 */		
		public function updateBuff(playerId:int,buffId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[playerId];
			if(_senceRolesView.isCanUsePlayer(player))
			{
				var buffBasicVo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(buffId);
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==playerId) //如果为自己
				{
					switch(buffBasicVo.buff_state)  //处理 buff 效果
					{
						case TypeSkill.Buff_DingShen:
							SpecialSkillManager.Dingshen=true;
							break;
						case TypeSkill.Buff_YunXuan:
							SpecialSkillManager.YunXuan=true;
							break;
						case TypeSkill.Buff_ChenMo:
							SpecialSkillManager.ChenMo=true;
							break;
					}
				}
				switch(buffBasicVo.buff_state)  //处理 buff 效果
				{
					case TypeSkill.Buff_DingShen:
						player.stopMove();
						player.play(TypeAction.Stand);
						break;
					case TypeSkill.Buff_YunXuan:
						player.stopMove();
						player.play(TypeAction.Stand);
						break;
				}
				if(buffBasicVo.effectmodeid>0) //有buff效果
				{
					var effectURL:String=URLTool.getSkill(buffBasicVo.effectmodeid);
					
					if(buffBasicVo.buff_layer==TypeSkill.BuffLayer_Up)
					{
						player.addUpBuffEffect(effectURL);
					}
					else 
					{
						player.addDownBuffEffect(effectURL);
					}
				}
				if(player.roleDyVo.hp==0)
				{
					///删除怪物
					if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
						_fightView.tweenToDeletePlayer(player);
					}
						///人物死亡
					else if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						_fightView.updatePlayerDead(player);
					}
				}	
			}
		}
		
		
		/**删除buff  dyId 为玩家id   
		 */		
		public function updateDeleteBuff(dyId:int,buffId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(player)
			{
				var buffBasicVo:BuffBasicVo=BuffBasicManager.Instance.getBuffBasicVo(buffId);
				var effectURL:String=URLTool.getSkill(buffBasicVo.effectmodeid);
				
				
				if(buffBasicVo.buff_layer==TypeSkill.BuffLayer_Up)
				{
					player.deleteUpBuffEffect(effectURL);
				}
				else 
				{
					player.deleteDownBuffEffect(effectURL);
				}
				if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==dyId) //如果为自己
				{
					switch(buffBasicVo.buff_state)  //处理 buff 效果
					{
						case TypeSkill.Buff_DingShen:
							SpecialSkillManager.Dingshen=false;
							break;
						case TypeSkill.Buff_YunXuan:
							SpecialSkillManager.YunXuan=false;
							break;
						case TypeSkill.Buff_ChenMo:
							SpecialSkillManager.ChenMo=false;
							break;
					}
				}
			}
		}
		/**播放单一特效 比如骑上坐骑 升级     加血  加魔法 
		 * 使用道具 
		 * addHp 添加的血量  hp 血量
		 * addMp 添加的魔法
		 */
		public function updateShowEffect(dyId:int,skillId:int,addHp:int,hp:int,addMp:int,mp:int,buffId:int):void
		{
			var playerView:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(_senceRolesView.isUsablePlayer(playerView))
			{
				_fightView.showEffect(playerView,skillId,1);
				updateBuffDamage(dyId,buffId,hp,addHp,mp,addMp);
			}
		}
		
		/**显示切磋动画特效
		 */		
		public function updateCompeteEffect(dyId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(player)
			{
				var effectURL:String=CommonEffectURLManager.CompetingEffect;
				player.addDownBuffEffect(effectURL);
			}
			print(this,"切磋id",dyId,player);
		}
		/**删除切磋动画特效
		 */		
		public function updateDeleteCompeteEffect(dyId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(player)
			{
				var effectURL:String=CommonEffectURLManager.CompetingEffect;
				player.deleteDownBuffEffect(effectURL);
			}
		}
		
		/**其他玩家的血量魔法值发生改变 
		 * hp hpMax mp mpMax  为 -1 表示不发生改变
		 */		
		public function updateOtherRoleHpMp(dyId:int,hp:int=0,hpMax:int=0,mp:int=0,mpMax:int=0):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(_senceRolesView.isUsablePlayer(player))
			{
				if(hp !=0)
				{
					player.roleDyVo.hp=hp;
				}
				if(hpMax !=0)
				{
					player.roleDyVo.maxHp=hpMax;
				}
				if(mp!=0)
				{
					player.roleDyVo.mp=mpMax;
				}
				if(mpMax !=0)
				{
					player.roleDyVo.maxMp=mpMax;
				}
				player.updateHp();
			}
		}
		
		/**更新移形换影 
		 */ 
//		public function updateBlinkMove(blinkResultVo:BlinkMoveResultVo,speed:Number=50):void
//		{
//			var player:RolePlayerView=_senceRolesView.totalViewDict[blinkResultVo.dyId] as RolePlayerView;
//			if(player)
//			{
//				checkPullPlayer(blinkResultVo.mapX,blinkResultVo.mapY,player);
//				player.updateBlinkMove(blinkResultVo.endX,blinkResultVo.endY,speed,null,null,true);
//			}
//		}
		
		/**更新战斗  指的是 玩家发起的战斗
		 * isTriggeAll  是否始终触发   false 表示 有玩家才触发   ,true表示始终触发
		 * 
		 */
		public function updateFightMore(fightUIVo:FightUIPtVo,isTriggeAll:Boolean=false):void
		{
			var attacker:PlayerView=fightUIVo.atk;//_senceRolesView.totalViewDict[fightResultVo.atkId] as PlayerView;
//			var uAtkArr:Vector.<UAtkInfo>=getUAtkInfoArr(fightResultVo.uAtkArr);
			var len:int=fightUIVo.uAtkArr.length;
			var canTrigger:Boolean=isTriggeAll;
			if(!canTrigger)
			{
				if(len>0)canTrigger=true;
			}
			if(canTrigger)
			{
				///改变攻击者方向
				if(_senceRolesView.isUsablePlayer(attacker))
				{
					if(len>0)
					{
						var targetPlayer:PlayerView=fightUIVo.uAtkArr[0].player;
						if(_senceRolesView.isUsablePlayer(targetPlayer)&&targetPlayer!=attacker)  //攻击者 和受击者不为为同一个人
						{
							var direction:int=DirectionUtil.getDirection(attacker.roleDyVo.mapX,attacker.roleDyVo.mapY,targetPlayer.roleDyVo.mapX,targetPlayer.roleDyVo.mapY);
							attacker.play(TypeAction.Stand,direction,true,null,null,true);
						}
						else attacker.play(TypeAction.Stand);
					}
					else attacker.play(TypeAction.Stand);
				}
				///开始播放特效
				////进行vo转化
//				var fightUIVo:FightUIPtVo=new FightUIPtVo();
//				fightUIVo.atk=attacker;
//				fightUIVo.uAtkArr=uAtkArr;
//				fightUIVo.skillId=fightResultVo.skillId;
//				fightUIVo.skillLevel=fightResultVo.skillLevel;
//				fightUIVo.mapX=fightResultVo.mapX;
//				fightUIVo.mapY=fightResultVo.mapY;
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
				var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
				_fightView.updateFight(fightEffectVo.effect_type,fightUIVo);
			}
		}
		public function updateFightMorePt(fightUIVo:FightUIPtVo):void
		{
		//	var attacker:PlayerView=_senceRolesView.totalViewDict[fightResultVo.atkId] as PlayerView;
			var attacker:PlayerView=fightUIVo.atk;
//			var uAtkArr:Vector.<UAtkInfo>=getUAtkInfoArr(fightResultVo.uAtkArr);
			
			if(_senceRolesView.isUsablePlayer(attacker))
			{
				///避免多次技能触发
				if(attacker.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
				{
					if(SkillDyManager.Instance.getDefaultSkill()!=fightUIVo.skillId) removePreTiggerSkillPt();
//					if(uAtkArr.length>0)
//					{
//						if(DataCenter.Instance.roleSelfVo.pkMode==TypeRole.PKMode_Peace)
//						{
//							GuaJiManager.Instance.start();//战斗的时候调用挂机
//						}
//					}
//					GloableProgress.Instance.stopGatherProgress(); //不显示采集进度条
				}
				///改变攻击者方向
				var direction:int=DirectionUtil.getDirection(attacker.roleDyVo.mapX,attacker.roleDyVo.mapY,fightUIVo.mapX,fightUIVo.mapY);
				attacker.play(TypeAction.Stand,direction,true,null,null,true);

			}
			///开始播放特效
//			var fightUIPtVo:FightUIPtVo=new FightUIPtVo();
//			fightUIPtVo.atk=attacker;
//			fightUIPtVo.uAtkArr=uAtkArr;
//			fightUIPtVo.skillId=fightResultVo.skillId;
//			fightUIPtVo.skillLevel=fightResultVo.skillLevel;
//			fightUIPtVo.mapX=fightResultVo.mapX;
//			fightUIPtVo.mapY=fightResultVo.mapY;
			
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
			var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
			_fightView.updateFight(fightEffectVo.effect_type,fightUIVo);
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
//			print(this,"触发移动...",playerMoveResultVo.path);
			if(_mapConfigLoadComplete)
			{
				var complete:Function=null
				var player:PlayerView=_senceRolesView.totalViewDict[playerMoveResultVo.id] as PlayerView;
				var pathLen:int=playerMoveResultVo.path.length;
				if(player&&player.isDead==false)
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
		/**  更新玩家   PK胜利特效
		 */		
		public function updateCompeteWin(id:int):void
		{
			var playerView:PlayerView=_senceRolesView.totalViewDict[id] as PlayerView;
			if(_senceRolesView.isCanUsePlayer(playerView))
			{
				var actionData:ATFActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.CompeteWinEffect) as ATFActionData;
				if(actionData)playerView.addFrontEffect(actionData,[0]);
				else SourceCache.Instance.loadRes(CommonEffectURLManager.CompeteWinEffect);
			}
		}
		/**更新玩家红名 
		 */		
		public function updateRoleNameColor(dyId:int):void
		{
			var playerView:PlayerView=_senceRolesView.totalViewDict[dyId] as PlayerView; 
			if(_senceRolesView.isCanUsePlayer(playerView))
			{
				playerView.updateName();
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
//				player.setMapXY(checkMapX,checkMapY);
				player.moveTo(checkMapX,checkMapY,50);
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
		public function updateMountChange(playerId:int,mountBasicId:int,state:int):void
		{
			stopMouseEffect();
			var playerView:PlayerView=_senceRolesView.totalViewDict[playerId] as PlayerView;
			RoleDyVo(playerView.roleDyVo).state=state//mountChangeVo.state;
			//切换坐骑 人物需要停止移动
//			playerView.stopMove();
			///更新衣服的静态 id
		//	if(mountChangeVo.state==TypeRole.State_Mount)  ///如果在坐骑上
			var clothBasicId:int;
			var weaponBasicId:int;
			var wingBasicId:int;
//			if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  //为玩家自己
//			{
//				clothBasicId=CharacterDyManager.Instance.getClothBasicId();
//				weaponBasicId=CharacterDyManager.Instance.getWeaponBasicId();
//				wingBasicId=CharacterDyManager.Instance.getWingBasicId();
//			}
//			else//其他玩家 
//			{
			clothBasicId=playerView.roleDyVo.clothBasicId;
			weaponBasicId=playerView.roleDyVo.weaponBasicId;
			wingBasicId=playerView.roleDyVo.wingBasicId;
//			}
			///更新速度
			var speed:Number;
			if(state==TypeRole.State_Mount)
			{
				_senceRolesView.updateMountCloth(playerId,clothBasicId);
				_senceRolesView.updateMount(playerId,mountBasicId);
				_senceRolesView.updateMountWing(playerId,wingBasicId);
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  //为玩家自己
				{
					HeroPlayerView(playerView).setMovingIndex();
					speed=MountDyManager.Instance.getRidingMountSpeed();
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
					else DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=speed;
					playerView.updateMovePathSpeed(speed);
				}
				///播放上坐骑特效??
				print(this,"此处播放了上坐骑的特效");
			//	var skillId:int=10002;
				///   播放上坐骑特效
		//		_fightView.showEffect(playerView,skillId,1);  ////上坐骑特效
			}
			else   ///不再坐骑上 
			{
				_senceRolesView.updateCloth(playerId,clothBasicId);
				_senceRolesView.updateWeapon(playerId,weaponBasicId);
				_senceRolesView.updateWing(playerId,wingBasicId);
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  //为玩家自己
				{
					HeroPlayerView(playerView).setMovingIndex();
					speed=CharacterDyManager.Instance.speed;          
					if(speed==-1)speed=DataCenter.Instance.roleSelfVo.speedManager.walkSpeed;
					else DataCenter.Instance.roleSelfVo.speedManager.walkSpeed=speed;
					playerView.updateMovePathSpeed(speed);
				}
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
					if(!monsterView.isDispose)
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
		private function noticeMonsterWalk(monsterDyId:uint,path:Array):void
		{
			var monsterMoveVo:MonsterMoveVo=new MonsterMoveVo();//PoolCenter.Instance.getFromPool(MonsterMoveVo,null) as MonsterMoveVo;
			var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(monsterDyId);
			var monsterBasicId:int=roleDyVo.basicId;
			var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roleDyVo.basicId);
			monsterMoveVo.dyId=monsterDyId;
			monsterMoveVo.path=path;
			monsterMoveVo.speed=monsterBasicVo.move_speed;
			monsterMoveVo.curentPostion=new Point(roleDyVo.mapX,roleDyVo.mapY);
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_MonsterBeginMove,monsterMoveVo);
		}
		
		/**魔神大炮使场景全部人物死亡
		 */		
		public function updateDaPaoDead(arr:Array,fightEffectId:int):void
		{
			var fightUIVo:FightUIPtVo=new FightUIPtVo();
			var player:PlayerView;
			var uAtkInfo:UAtkInfo;
			fightUIVo.uAtkArr=new Vector.<UAtkInfo>();
			for each(var dyId:int in arr)
			{
				player=_senceRolesView.totalViewDict[dyId];
				if(_senceRolesView.isUsablePlayer(player))
				{
					uAtkInfo=new UAtkInfo();
					uAtkInfo.player=player;
					uAtkInfo.changeHp=player.roleDyVo.hp;
					uAtkInfo.hp=0;
					uAtkInfo.damageType=4;
					fightUIVo.uAtkArr.push(uAtkInfo);
				}
			}
			_fightView.updateRaidSkill(fightEffectId,fightUIVo);
		}
		
		/** 月井技能 
		 */		
		public function updateYueJing(yuejingId:int,fightEffectId:int):void
		{
			var fightUIVo:FightUIPtVo=new FightUIPtVo();
			var player:PlayerView;
			var uAtkInfo:UAtkInfo;
			fightUIVo.atk=_senceRolesView.heroView;
			fightUIVo.uAtkArr=new Vector.<UAtkInfo>();
			player=_senceRolesView.totalViewDict[yuejingId];
			if(_senceRolesView.isUsablePlayer(player))
			{
				uAtkInfo=new UAtkInfo();
				uAtkInfo.player=player;
				fightUIVo.uAtkArr.push(uAtkInfo);
			}
			_fightView.updateRaidSkillYueJing(fightEffectId,fightUIVo);
		}
		
		
		
		/**是否已经请求复活
		 */
//		private var _isNoticeRevive:Boolean=false
		/**人物死亡
		 * atkId  攻击者id  
		 */
		public function updateHeroRoleDead(killerId:int):void
		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==dyId)
//			{
//				_isNoticeRevive=false;
				stopMouseEffect();
				ZiDongXunLuView.Instance.hide();
				GuaJiManager.Instance.stop();
//				Alert.show("复活","提示",noticeRevive,["原地复活","回程复活"]);
				var roleDyVo:RoleDyVo=RoleDyManager.Instance.getRole(killerId); //攻击者id 
				
//				_revivePopView=RevivePopView.show("你已经被【"+roleDyVo.roleName+"】(等级："+roleDyVo.level+")击杀","提示",noticeRaidRevive);		

//				trace("id:",DemonWindow.activityId,RaidManager.Instance.getRaidVo(RaidManager.raidId).activityId);	
				if(RaidManager.raidId!=-1 && RaidManager.Instance.getRaidVo(RaidManager.raidId).activityId == DemonWindow.activityId){
//					RaidManager.demonFirstDead = false;
					return;
				}else if(RaidManager.raidId!=-1){
					_revivePopView=RevivePopView.show("你已经被【"+roleDyVo.roleName+"】(等级："+roleDyVo.level+")击杀","提示",noticeRaidRevive);		
				}else
				{
					_revivePopView=RevivePopView.show("你已经被【"+roleDyVo.roleName+"】(等级："+roleDyVo.level+")击杀","提示",noticeWieldRevive);		//野外复活
				}
				
				selectPlayer=null;
				StageProxy.Instance.setNoneFocus();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroDead);
//			}
		}
		/**副本死亡界面
		 * @param index
		 */		
		private function noticeRaidRevive(index:int):void{
			if(index==RevivePopView.YuanDi)
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RoleRevive,true);
			else
				YFEventCenter.Instance.dispatchEventWith(RaidEvent.ExitRaidReq,new CExitRaid());
			if(_revivePopView){
				_revivePopView.updateClose();
				_revivePopView=null
			}
		}
		
		/**请求角色复活
		 */		 
		private function noticeWieldRevive(index:int):void
		{
//			if(_revivePopView)
//			{
//				_revivePopView.updateClose();
//				_revivePopView=null
//			}
				var isFree:Boolean=true;
				if(index==RevivePopView.YuanDi)
				{
					if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)  //原地 复活 
					{
						if(_revivePopView)
						{
							_revivePopView.updateClose();
							_revivePopView=null
						}
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RoleRevive,isFree);
					}
					else 
					{
						isFree=false;
						if(DataCenter.Instance.roleSelfVo.diamond>=DataCenter.Instance.roleSelfVo.YuanDiReviveCost)
						{
							if(_revivePopView)
							{
								_revivePopView.updateClose();
								_revivePopView=null
							}
							YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RoleRevive,isFree);
						}
						else NoticeUtil.setOperatorNotice("魔钻 不够...");
					}
				}
				else
				{
					if(_revivePopView)
					{
						_revivePopView.updateClose();
						_revivePopView=null
					}
					YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_RoleRevive,isFree);
				}
				StageProxy.Instance.setNoneFocus();
		}
		
		/**原地复活角色
		 *  复活血量 exp 等
		 */		
		public function updateReviveRole(roleRevive:RoleReviveVo):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[roleRevive.dyId] as PlayerView;
			player.roleDyVo.hp=roleRevive.hp;
			player.roleDyVo.mp=roleRevive.mp;
			player.startCloth();
			player.updateHp();
			player.play(TypeAction.Stand,player.activeDirection,true,null,null,true);
//			player.isDead=false;
			if(roleRevive.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)	
			{
				DataCenter.Instance.roleSelfVo.heroState.isLock=false;
				if(_revivePopView)
				{
					_revivePopView.updateClose();
					_revivePopView=null
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroRevive);
				StageProxy.Instance.setNoneFocus();
				DataCenter.Instance.roleSelfVo.heroState.setDefaultWillDo();
				TransferPointManager.Instance.autoMove=false;
			}
		}
		

		
		/**玩家升级
		 */		
		public function updateRoleLevelUp(playerId:int):void
		{
			var player:PlayerView=_senceRolesView.totalViewDict[playerId];
			if(player)
			{
				var url:String=CommonEffectURLManager.LevelUp;
				var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				player.updateHp();
				if(actionData)
				{
					player.addFrontEffect(actionData,[0]);
				}
				else 
				{
					SourceCache.Instance.loadRes(url);
				}
			}
		}
		/**进行场景说话
		 */		
		public function updateSceneSayWord(dyId:int,msg:String):void
		{
			var role:PlayerView=_senceRolesView.totalViewDict[dyId];
			if(role)  //如果玩家存在
			{
				role.say(msg);
			}
		}
		
		
		
		/** 更新飞行状态 
		 */
//		public function updateFly(flyVo:FlyVo):void
//		{
//			
//		}
//		
//		/** 跳跃状态 
//		 */
//		public function updateJump():void
//		{
//			
//		}
		/**觸發技能  快捷键
		 */		
		private function onTriggerSkill(e:YFEvent):void
		{
			if(_senceRolesView.heroView.isDead==false)
			{
				var skillId:int=int(e.param);
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
				var skillLevel:int=skillDyVo.skillLevel;
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
				var fightType:int=TypeSkill.getFightType(skillBasicVo.use_type);
				DataCenter.Instance.roleSelfVo.heroState.willDo=null;
				var  canFight:Boolean=false;//能否发起攻击
				switch(fightType)
				{
					case TypeSkill.FightType_MoreRole:
						if(!selectPlayer)canFight=false;   //如果不存在  selectPlayer
						else    //存在选中的角色对象
						{
//							canFight=RoleDyManager.Instance.checkSkillAffectGroupCanFire(selectPlayer.roleDyVo,skillBasicVo.affect_group);
//							if(canFight)
//							{
							canFight=RoleDyManager.Instance.canFight(selectPlayer.roleDyVo,DataCenter.Instance.roleSelfVo.pkMode,skillBasicVo.affect_group);
//							}
						}
						if(canFight)	 
						{
								triggerSkillFightMoreRole(skillId,selectPlayer);
						}
						else 
						{
							///随机寻找目标
							var player:PlayerView=_senceRolesView.findCanFightPlayerForSkill(skillBasicVo.affect_group);
							if(player)
							{
								selectPlayer=player;
								triggerSkillFightMoreRole(skillId,selectPlayer);
							}
							else 
							{
//								NoticeUtil.setOperatorNotice("无目标对象");
								NoticeManager.setNotice(NoticeType.Notice_id_907);// 目标错误，不能释放技能！
							}
						}
						break;
					case TypeSkill.FightType_MorePt:
						if(selectPlayer&&(selectPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet||selectPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||selectPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Player))  //有目标 ,并且目标不为npc 直接释放技能
						{
							triggerSkillFightMorePt(skillId,new Point(selectPlayer.roleDyVo.mapX,selectPlayer.roleDyVo.mapY));
						}
						else  //没有目标点显示指示器
						{
							showSkillPoint(skillId);
						}
						break;
					case TypeSkill.FightType_MoreAll:
						triggerSkillFightAll(skillId);
						break;
					case TypeSkill.FightType_BlinkMove: // 瞬移
						triggerSkillBlink(skillId); 
						break;
					case TypeSkill.FightType_Switch:  //开关技能后
						if(skillBasicVo.skillCanfire())
						{
							skillBasicVo.updateCD();
							var fightUIVo:FightMoreVo=new FightMoreVo();
							fightUIVo.skillId=skillId;
							noticeFightMore(fightUIVo);
						}
						else 
						{
							//技能 CD 中
							NoticeManager.setNotice(NoticeType.Notice_id_905);
						}
						break;

				}
			}
		}
		
		/** 自动挂机
		 */		
		private function onZkeyDown(e:KeyboardEvent):void
		{
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			if(mapSceneBasicVo.type==TypeRole.MapScene_Field||mapSceneBasicVo.type==TypeRole.MapScene_Raid)  //副本 野外才能挂机
			{
				GuaJiManager.Instance.toggle();
			}
			else 
			{
				GuaJiManager.Instance.stop();
			}
		} 

		/**自动挂机
		 */
		private function onAutoFight(e:YFEvent=null):void
		{  
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			if(mapSceneBasicVo.type==TypeRole.MapScene_Field||mapSceneBasicVo.type==TypeRole.MapScene_Raid)  //副本 野外才能挂机
			{
				GuaJiManager.Instance.start();
			}
			else 
			{
				NoticeUtil.setOperatorNotice("安全区域无法挂机");
			}
		}
		
 		/**挂机回调   处理挂机逻辑
		 */		
		private function guajiCall(mySkillId:int=-1):void
		{
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			if(mapSceneBasicVo.type==TypeRole.MapScene_Field||mapSceneBasicVo.type==TypeRole.MapScene_Raid)  //副本 野外才能挂机
			{
				
				var skillId:int=mySkillId;
				if(skillId<=0)
				{
					skillId=AutoManager.Instance.getAvailableSkill();
				}
				if(skillId<=0)
				{
					skillId=SkillDyManager.Instance.getDefaultSkill();
//					print(this,"挂机获取默认技能",skillId);
				}
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId); 
				if(!skillDyVo) return  ;     
				var skillLevel:int=skillDyVo.skillLevel;
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillLevel);
				var trigger:Boolean=false;
				if(skillBasicVo.skillCanfire())  ////挂机 时候 
				{
					var fightType:int=TypeSkill.getFightType(skillBasicVo.use_type);
					var canFight:Boolean=false;
					var seachMonsterDict:Dictionary=AutoManager.Instance.getMonsterIdDict();//搜素 怪物的 静态 id
					var canFightPlayer:PlayerView;
					switch(fightType)  									///距离目标大于600时候 放弃 目标 重新找怪 
					{
						case TypeSkill.FightType_MoreRole:
							canFightPlayer=selectPlayer;
							if(_senceRolesView.isUsablePlayer(canFightPlayer))
							{
								if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(canFightPlayer.roleDyVo,skillBasicVo.affect_group))
								{
									if(RoleDyManager.Instance.distanceToPlayer(canFightPlayer.roleDyVo)<=600)  //距离目标小于600 ，
									{
										for each(var flushUnitVo:FlushUnitVo in seachMonsterDict)
										{
											if(flushUnitVo.unitId1==canFightPlayer.roleDyVo.basicId)
											{
												canFight=true;
												break;
											}
										}
									}

								}
							}
							if(canFight)	 
							{
								trigger=triggerSkillFightMoreRole(skillId,canFightPlayer);
//								if(!trigger)  //如果 技能没有打出去 则 进行挂机
//								{
//									return guajiCall();
//								}
//								return true;
							}
							else 
							{
								///随机寻找目标
								canFightPlayer=_senceRolesView.findCanFightPlayer3(seachMonsterDict,skillBasicVo.affect_group); //搜索挂机指定的怪物
								if(canFightPlayer)
								{
									selectPlayer=canFightPlayer;
									trigger=triggerSkillFightMoreRole(skillId,canFightPlayer);
//									if(!trigger)  //如果 技能没有打出去 则 进行挂机
//									{
//										return guajiCall();
//									}
//									return true;
								}
//								else 
//								{
//									return guajiCall(SkillDyManager.Instance.getDefaultSkill());
//								}
							}
							break;
						case TypeSkill.FightType_MorePt: //对点技能
								canFightPlayer=selectPlayer;
							if(_senceRolesView.isUsablePlayer(canFightPlayer))
							{
								if(RoleDyManager.Instance.canFight(canFightPlayer.roleDyVo,DataCenter.Instance.roleSelfVo.pkMode))
								{
									if(RoleDyManager.Instance.distanceToPlayer(canFightPlayer.roleDyVo)>600)
									{
										canFightPlayer=_senceRolesView.findCanFightPlayer3(seachMonsterDict,skillBasicVo.affect_group);
									}
									else 
									{
										canFightPlayer=_senceRolesView.findCanFightPlayer3(seachMonsterDict,skillBasicVo.affect_group);
									}
									if(!canFightPlayer)canFightPlayer=selectPlayer;
								}
							}
							if(_senceRolesView.isUsablePlayer(canFightPlayer))
							{
								if(RoleDyManager.Instance.canFight(canFightPlayer.roleDyVo,DataCenter.Instance.roleSelfVo.pkMode))
								{
									var pt:Point=new Point();
									selectPlayer=canFightPlayer;
									pt.x=canFightPlayer.roleDyVo.mapX;
									pt.y=canFightPlayer.roleDyVo.mapY;
									triggerSkillFightMorePt(skillId,pt);
								}
								else 
								{
									selectPlayer=null;
									return guajiCall(SkillDyManager.Instance.getDefaultSkill());
								}
							}
							else 
							{
								selectPlayer=null;
								return guajiCall(SkillDyManager.Instance.getDefaultSkill());
								//						NoticeUtil.setOperatorNotice("无目标对象");
						//		NoticeManager.setNotice(NoticeType.Notice_id_907);// 目标错误，不能释放技能！
							}
//							return true;
							break;
						case TypeSkill.FightType_MoreAll:
							canFightPlayer=selectPlayer;
							if(!canFightPlayer)canFightPlayer=_senceRolesView.findCanFightPlayer3(seachMonsterDict,skillBasicVo.affect_group);
							if(_senceRolesView.isUsablePlayer(canFightPlayer))
							{
								if(RoleDyManager.Instance.distanceToPlayer(canFightPlayer.roleDyVo)<=200)  //小于等于 200 
								{
									triggerSkillFightAll(skillId);
								}
								else 
								{
									guajiCall(SkillDyManager.Instance.getDefaultSkill());
								} 
							}
//							else 
//							{
//								guajiCall();
//							}
//							return true;
							break;
						case TypeSkill.FightType_Switch:
							guajiCall();
							break;
					}
				}
				//如果为副本类型
				if(mapSceneBasicVo.type==TypeRole.MapScene_Raid)
				{
					// 如果 没有玩家
					if(!TransferPointManager.Instance.autoMove)
					{
						if(!_senceRolesView.isUsablePlayer(canFightPlayer))
						{
							canFightPlayer=_senceRolesView.findCanFightPlayer(100000); //判断是否有玩家 如果 没有玩家
							if(!_senceRolesView.isUsablePlayer(canFightPlayer))  //如果 没有怪物 
							{
								var nextId:int = RaidManager.Instance.getRaidVo(RaidManager.raidId).nextRaidId;
								if(nextId>0)
								{
									var myPt:Point=TransferPointManager.Instance.getPoint();
									if(myPt)
									{
										//拾取所有的 道具
										
										TransferPointManager.Instance.autoMove=true;
										collectionMoreDropGoods(100000);
//										heroMoveToPostion(myPt.x,myPt.y);
										var waitTime:TimeOut=new TimeOut(10*1000,waitoToMove,myPt);
										waitTime.start();
									}
								}
							}
						}

					}
				}
			}
			else NoticeUtil.setOperatorNotice("安全区域无法挂机"); 
//			return false;
		}
		/**等待10 分钟自动进入下一层
		 */		
		private function waitoToMove(myPt:Point):void
		{
			if(TransferPointManager.Instance.autoMove)
			{
				heroMoveToPostion(myPt.x,myPt.y);
			}
		}
		
		/**显示技能目标点
		 */		
		private function showSkillPoint(skillId:int):void
		{
			_skillPointSelectView.start();
			_skillPointSelectView.playDefault();
			MouseFollowManager.Instance.startDrag(_skillPointSelectView,skillId);
			StageProxy.Instance.stage.addEventListener(Event.MOUSE_LEAVE,onShowSkill);
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_DOWN,onShowSkill);
//			print(this,"此处待加上鼠标手势切换");
		}
		/**取消前一次的技能触发
		 */		
		private function removePreTiggerSkillPt():void
		{
			StageProxy.Instance.stage.removeEventListener(Event.MOUSE_LEAVE,onShowSkill);
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onShowSkill);
			MouseFollowManager.Instance.stopDrag();
			_skillPointSelectView.stop()
		}
		/**响应技能
		 */		
		private function onShowSkill(e:Event):void
		{
			removePreTiggerSkillPt();
			var pt:Point=LayerManager.BgMapLayer.mousePt;
			triggerSkillFightMorePt(int(MouseFollowManager.Instance.data),pt);
			MouseFollowManager.Instance.data=null;
		}
		
		
		/**拾取掉落物品
		 */		
		private function onCollectDropGoods(e:YFEvent=null):void
		{
			if(_senceRolesView.heroView)
			{
				if(_senceRolesView.heroView.isDead==false) 
				{
					//空格键
//					var arr:Array=_senceRolesView.getDropGoodsArr(600);
//					var len:int=arr.length;
//					if(len>0)
//					{
//						var dropGoodsPlayer:PlayerView;//=_senceRolesView.getDropGoodsID(180);
//						for(var i:int=0;i!=len;++i)
//						{
//							dropGoodsPlayer=arr[i].player;
//							if(dropGoodsPlayer!=null)noticeGetGropGoods(dropGoodsPlayer.roleDyVo.dyId); ///获取掉落物凭 
//						}
//					}
					collectionMoreDropGoods(10000);
				}
				else print(this,"主角已经死亡 ,不能拾取道具");
			}
		}
		
		/**收集道具   
		 * @param len  搜索范围
		 */
		private function collectionMoreDropGoods(len:int):void
		{
			if(_senceRolesView.heroView) 
			{
				if(_senceRolesView.heroView.isDead==false) 
				{
					var isNotFull:Boolean=BagStoreManager.instantce.checkCanPlaceInBag();
					if(isNotFull)
					{
						//空格键
						var arr:Array=_senceRolesView.getDropGoodsIdArr(len);
						var len:int=arr.length;
						if(len>0)
						{
							YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_GetMoreDropGoods,arr);
						}
					}
					else 
					{
						NoticeUtil.setOperatorNotice("背包已满");
					}
				}
				else print(this,"主角已经死亡 ,不能拾取道具");
			}
		}
		
		private function onCollectDropGoods2(e:TimerEvent):void
		{
			if(_senceRolesView.heroView&&_senceRolesView.heroView.isDead==false)
			{
				//空格键 
				var len:int=600;
				if(DataCenter.Instance.mapSceneBasicVo.type!=TypeRole.MapScene_Raid)
				{
					var dropGoodsPlayer:PlayerView=_senceRolesView.getDropGoodsID(len);
					if(dropGoodsPlayer!=null)
					{
						var isNotFull:Boolean=BagStoreManager.instantce.checkCanPlaceInBag();//BagStoreManager.instantce.checkCanPlaceInBag(dropGoodsPlayer.roleDyVo.itemType,dropGoodsPlayer.roleDyVo.basicId);
						if(isNotFull) 
						{
							noticeGetGropGoods(dropGoodsPlayer.roleDyVo.dyId,false); ///获取掉落物凭 
						}
					}
				}
				else   //副本拾取 。批量拾取
				{
					len=100000;
					collectionMoreDropGoods(len);
				}
			}
			else print(this,"主角已经死亡 ,不能拾取道具");
		}

		
		/**觸發移形換影
		 * range 移动的距离
		 */		
//		private function triggerBlinkMove(range:int=30,speed:Number=50):void
//		{
//			var testPoint:Point;
//			var mousePt:Point=LayerManager.BgMapLayer.mousePt;
//			if(YFMath.distance(HeroPositionProxy.mapX,HeroPositionProxy.mapY,mousePt.x,mousePt.y)>range)	testPoint=YFMath.getLinePoint2(HeroPositionProxy.mapX,HeroPositionProxy.mapY,mousePt.x,mousePt.y,range);
//			else testPoint=mousePt;
//			var endPoint:Point=GridData.Instance.getMoveToEndPoint(HeroPositionProxy.mapX,HeroPositionProxy.mapY,testPoint.x,testPoint.y);
//			if(endPoint)
//			{
//				noticeBlinkMove(endPoint.x,endPoint.y);
//				///直接进行移动 同时广播其他角色移动
//				DataCenter.Instance.roleSelfVo.heroState.isLock=true;
//				noticeOutSit();//如果为打坐取消打坐
//				_senceRolesView.heroView.updateBlinkMove(endPoint.x,endPoint.y,speed,unLockHero);
//
//				///宠物拉取 对出战的宠物进行拉取
//				var fightPetArr:Array=[];//PetDyManager.Instance.getFightPlayer();
//				var fightpetId:int=PetDyManager.fightPetId;
//				if(fightpetId>0)
//				{
//					fightPetArr.push(fightpetId);
//				}
//				var degree:Number=DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
//				var petPt:Point=YFMath.getLinePoint3(endPoint.x,endPoint.y,PetPlayerView.MinDistance,degree);
//				var petPlayer:PetPlayerView;
//				for each(var petId:int in fightPetArr)
//				{
//					petPlayer=_senceRolesView.totalViewDict[petId] as PetPlayerView;
//					petPlayer.noticePullPet(petPt.x+50-Math.random()*100,petPt.y+60-Math.random()*120);	
//				}
//				stopMouseEffect();
//			}
//		}
		
		
		/** 对主角进行解锁
		 */		
		private function unLockHero(obj:Object):void
		{
			DataCenter.Instance.roleSelfVo.heroState.isLock=false;
		}
		
		
		/**处理特殊buff 
		 * handleSpecialBuff2 移动 buff 
		 * handleSpecialBuff 战斗buff
		 */
		private function handleSpecialBuff(skillBasicVo:SkillBasicVo):Boolean
		{
			if(SpecialSkillManager.ChenMo) 
			{
				if(skillBasicVo.consume_type==SkillModuleType.Consume_MP) //消耗魔法不能打出来
				{
					NoticeUtil.setOperatorNotice("沉默中...");
					return true;
				}
			}
			if(SpecialSkillManager.YunXuan)
			{
				NoticeUtil.setOperatorNotice("晕眩中...");
				if(!_senceRolesView.heroView.isDead)
				{
					_senceRolesView.heroView.play(TypeAction.Stand,_senceRolesView.heroView.activeDirection);
				}
				return true;
			}
			return false;
		}
		/**处理瞬移
		 */		
		private function triggerSkillBlink(skillId:int):void
		{
			if(handleSpecialBuff2()) return ;
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel);
			if(skillBasicVo.skillCanfire())
			{
				var endPt:Point=LayerManager.BgMapLayer.mousePt;
				endPt=YFMath.getLinePoint2(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,endPt.x,endPt.y,skillBasicVo.use_distance);
				if(GridData.Instance.isBlock2(endPt.x,endPt.y))
				{
					endPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,endPt.x,endPt.y);
				}
				/// 如果没有移动  则表示不能进行移动
				if(endPt.x==_senceRolesView.heroView.roleDyVo.mapX&&endPt.y==_senceRolesView.heroView.roleDyVo.mapY)
				{
					NoticeUtil.setOperatorNotice("不能瞬移...");
				}
				else 
				{
					skillBasicVo.updateCD();
					_senceRolesView.heroView.stopMove();
					var fightMoreVo:FightMoreVo=new FightMoreVo();
					fightMoreVo.uAtkArr=[];
					fightMoreVo.skillId=skillId;
					fightMoreVo.pt=endPt
					noticeFightMorePt(fightMoreVo);
				}
			}
			else 
			{
				//技能cd 中...
				NoticeManager.setNotice(NoticeType.Notice_id_905);
			}

		}
		
		/** 瞬移  
		 * @param dyId  玩家id 
		 * @param endX	瞬移到的目标点
		 * @param endY 
		 */
		public function updateBlinkMove(fightUIVo:FightUIPtVo):void
		{
			var player:PlayerView=fightUIVo.atk;
			if(_senceRolesView.isUsablePlayer(player))
			{
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(fightUIVo.skillId);
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
				var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
				var func:Function=null;
				if(player.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) //如果 为自己则 解锁
				{
					DataCenter.Instance.roleSelfVo.heroState.isLock=true;
					stopMouseEffect();
				}
				player.updateBlinkMove(fightUIVo.mapX,fightUIVo.mapY,40,onBlinkComplete,player);
				_fightView.updateFight(fightEffectVo.effect_type,fightUIVo);
			}
		}
//		/**更新开关技能技能特效
//		 **/		
//		public function updateSwitchSkill(fightUIVo:FightUIPtVo):void
//		{
//			var player:PlayerView=fightUIVo.atk;
//			if(_senceRolesView.isUsablePlayer(player))
//			{
//				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(fightUIVo.skillId);
//				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(fightUIVo.skillId,fightUIVo.skillLevel);
//				var fightEffectVo:FightEffectBasicVo=FightEffectBasicManager.Instance.getFightEffectBasicVo(skillBasicVo.man_effect_id);
//				var func:Function=null;
//				if(player.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) //如果 为自己则 解锁
//				{
//					DataCenter.Instance.roleSelfVo.heroState.isLock=true;
//					stopMouseEffect();
//				}
//				player.updateBlinkMove(fightUIVo.mapX,fightUIVo.mapY,40,onBlinkComplete,player);
//				_fightView.updateFight(fightEffectVo.effect_type,fightUIVo);
//			}
//		}
		private function onBlinkComplete(player:PlayerView):void
		{
			if(_senceRolesView.isUsablePlayer(player))
			{
				if(player.roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) //如果 为自己则 解锁
				{
					DataCenter.Instance.roleSelfVo.heroState.isLock=false;
				}
				player.play(TypeAction.Stand,player.activeDirection,true,null,null,true);
			}
		}
		/** 有人物 才会发起攻击
		 * @param skillId  技能id
		 * @param uAtk
		 *  返回 值为true 表示   技能触发生效  有可能技能立马触发 也有可能技能 是先去向人物靠近，不管是哪种情况  都产生一个结果那就是  技能生效了    为false则技能没有生效
		 */		
		private function triggerSkillFightMoreRole(skillId:int,uAtk:PlayerView=null):Boolean
		{
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel);
			if(handleSpecialBuff(skillBasicVo)) return true;//处理buff
			if(skillBasicVo.skillCanfire())  ///该技能能够发出   过了CD时间 
			{
				if(!_senceRolesView.heroView.isDead)
				{
					var distance:Number=0;
					////进行技能类型分析
					var fightMoreVo:FightMoreVo;//多人pk  技能无点
//					var fightMorePtVo:FightMorePtVo;/// 多人pk 有点
					var rolesArr:Array;
					var targetPt:Point;///目标点 
					var heroDegree:int;//角色站立方位的角度 
					
					var endPt:Point;//计算移动到的目标点
					var degree:int;
					var toLen:int=40;
					var petPlayer:PetPlayerView;
					var i:int;
					var len:int;
					var myPlayer:PlayerView; 
					var beatPt:Point; //击退到的位置
					if(uAtk)
					{
						distance=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
					}
					if(skillBasicVo.use_distance+SkillEffectLen>=distance||skillBasicVo.use_distance==0)
					{
						////只有当具有目标时才会播放动画  
						switch(skillBasicVo.range_shape)
						{
							case TypeSkill.RangeShape_None: ///默认技能
								if(!_senceRolesView.isUsablePlayer(uAtk))uAtk=selectPlayer;
								if(_senceRolesView.isUsablePlayer(uAtk))
								{
									fightMoreVo=new FightMoreVo();
									fightMoreVo.uAtkArr=[uAtk.roleDyVo.dyId];
									fightMoreVo.skillId=skillId;
									skillBasicVo.updateCD();
									switch(skillBasicVo.special_effect)
									{
										case TypeSkill.SpecialEffetType_None:
										case TypeSkill.SpecialEffetType_Provok: 
											noticeFightMore(fightMoreVo);
											return true;
											break;
										case TypeSkill.UseLimit_NoFight:
											noticeFightMore(fightMoreVo);
											return true;
											break;
										case TypeSkill.SpecialEffetType_SkipStep: //顺步  // 瞬步到目标身后
											degree=YFMath.getDegree(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
											endPt=YFMath.getLinePoint4(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,toLen,degree);
											if(GridData.Instance.isBlock2(endPt.x,endPt.y))
											{
												endPt.x=uAtk.roleDyVo.mapX;
												endPt.y=uAtk.roleDyVo.mapY;
											}
											fightMoreVo.pt=endPt;
											noticeFightMorePt(fightMoreVo);
											stopMouseEffect();
											//拉取宠物
											if(PetDyManager.fightPetId>0)
											{
												petPlayer=_senceRolesView.totalViewDict[PetDyManager.fightPetId] as PetPlayerView;
												if(petPlayer)
												{
													heroPullPet(petPlayer,[new Point(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY)]);
												}
											}
											return true;
											break;
										case TypeSkill.SpecialEffetType_Assault:  // 冲到目标面前
											degree=YFMath.getDegree(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
											endPt=YFMath.getLinePoint3(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,toLen,degree);
											if(GridData.Instance.isBlock2(endPt.x,endPt.y))
											{
												endPt.x=uAtk.roleDyVo.mapX;
												endPt.y=uAtk.roleDyVo.mapY;
											}
											if(_senceRolesView.heroView.roleDyVo.mapX==endPt.x&&_senceRolesView.heroView.roleDyVo.mapY==endPt.y)
											{
												skillBasicVo.resetCD();
												NoticeUtil.setOperatorNotice("近身不能发起冲锋");
											}
											else 
											{
												fightMoreVo.pt=endPt;
												noticeFightMorePt(fightMoreVo);
												stopMouseEffect();
												//拉取宠物
												if(PetDyManager.fightPetId>0)
												{
													petPlayer=_senceRolesView.totalViewDict[PetDyManager.fightPetId] as PetPlayerView;
													if(petPlayer)
													{
														heroPullPet(petPlayer,[new Point(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY)]); 
													} 
												}
												return true;
											}
											break;
										case TypeSkill.SpecialEffetType_BeatBack: //击退
											beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,skillBasicVo.special_param);
											if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
											{
//												beatPt.x=uAtk.roleDyVo.mapX;
//												beatPt.y=uAtk.roleDyVo.mapY;
												beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
											}
											fightMoreVo.uAtkPosArr=[BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y)];
											noticeFightMoreBeatBack(fightMoreVo); 
											return true;
											break;
										case TypeSkill.SpecialEffetType_Revive: //复活 
											if(uAtk.isDead) //没有死亡
											{
												noticeFightMore(fightMoreVo);  
												return true;
											}
											else 
											{
												skillBasicVo.resetCD();
												NoticeUtil.setOperatorNotice("只能复活死亡对象");
											}
											break;
									} 
									
								}
								break;
							case TypeSkill.RangeShape_Circle: ///圆形检测
								if(!_senceRolesView.isUsablePlayer(uAtk))uAtk=selectPlayer;
								if(_senceRolesView.isUsablePlayer(uAtk))
								{
									rolesArr=_senceRolesView.getCircleRoles(uAtk.roleDyVo,skillBasicVo.effect_range,skillBasicVo.affect_number,selectPlayer,skillBasicVo.affect_group); ////获取  fightSkillBasicVo.range范围内的角色
									len=rolesArr.length;
									if(len>0)
									{
										fightMoreVo=new FightMoreVo();
										fightMoreVo.skillId=skillId;
										fightMoreVo.uAtkArr=rolesArr;
										skillBasicVo.updateCD();
										switch(skillBasicVo.special_effect)
										{
											case TypeSkill.SpecialEffetType_None:
											case TypeSkill.SpecialEffetType_Provok: 
												noticeFightMore(fightMoreVo);
												return true;
												break;
											case TypeSkill.SpecialEffetType_BeatBack: //击退
												fightMoreVo.uAtkPosArr=[];
												for(i=0;i!=len;++i)
												{
													myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
													beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
													if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
													{
//														beatPt.x=myPlayer.roleDyVo.mapX;
//														beatPt.y=myPlayer.roleDyVo.mapY;
														beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
													}
													fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
												}
												noticeFightMoreBeatBack(fightMoreVo);
												return true;
												break; 
											case TypeSkill.SpecialEffetType_Revive: //复活
												rolesArr=_senceRolesView.getCircleDeadRoles(skillBasicVo.effect_range,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,skillBasicVo.affect_number,skillBasicVo.affect_group); ////获取  fightSkillBasicVo.range范围内的角色
												if(rolesArr.length>0) //没有死亡
												{
													fightMoreVo.uAtkArr=rolesArr;
													noticeFightMore(fightMoreVo);
													return true;
												}
												else 
												{
													NoticeUtil.setOperatorNotice("无复活目标");
												}
												break;
										}
										
									}
								}
								break;
							case TypeSkill.RangeShape_Line:   ///直线检测
								if(!_senceRolesView.isUsablePlayer(uAtk))uAtk=selectPlayer;
								if(_senceRolesView.isUsablePlayer(uAtk))
								{
									heroDegree=YFMath.getDegree(HeroPositionProxy.mapX,HeroPositionProxy.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
								}
								else 
								{
									endPt=LayerManager.BgMapLayer.mousePt;
									heroDegree=YFMath.getDegree(HeroPositionProxy.mapX,HeroPositionProxy.mapY,endPt.x,endPt.y);//DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
								}
								targetPt=YFMath.getLinePoint4(HeroPositionProxy.mapX,HeroPositionProxy.mapY,skillBasicVo.effect_range,heroDegree);
								rolesArr=_senceRolesView.getLineRoles(targetPt.x,targetPt.y,skillBasicVo.effect_range,skillBasicVo.range_param,null,skillBasicVo.affect_number,skillBasicVo.affect_group); 
								len=rolesArr.length
								if(len>0)
								{
									fightMoreVo=new FightMoreVo();
									fightMoreVo.skillId=skillId;
									fightMoreVo.uAtkArr=rolesArr;
									skillBasicVo.updateCD();
									switch(skillBasicVo.special_effect)
									{
										case TypeSkill.SpecialEffetType_None:
										case TypeSkill.SpecialEffetType_Provok: 
											noticeFightMore(fightMoreVo);
											return true;
											break;
										case TypeSkill.SpecialEffetType_SkipStep: //顺步  // 瞬步到目标身后
											degree=YFMath.getDegree(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
											endPt=YFMath.getLinePoint4(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,toLen,degree);
											if(GridData.Instance.isBlock2(endPt.x,endPt.y))
											{
												endPt.x=uAtk.roleDyVo.mapX;
												endPt.y=uAtk.roleDyVo.mapY;
											}
											fightMoreVo.pt=endPt;
											noticeFightMorePt(fightMoreVo);
											
											if(PetDyManager.fightPetId>0)
											{
												petPlayer=_senceRolesView.totalViewDict[PetDyManager.fightPetId] as PetPlayerView;
												if(petPlayer)
												{
													heroPullPet(petPlayer,[_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY]);
												}
											}
											return true;
											break;
										case TypeSkill.SpecialEffetType_Assault:  // 冲到目标面前
											degree=YFMath.getDegree(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
											endPt=YFMath.getLinePoint3(uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY,toLen,degree);
											if(GridData.Instance.isBlock2(endPt.x,endPt.y))
											{
												endPt.x=uAtk.roleDyVo.mapX;
												endPt.y=uAtk.roleDyVo.mapY;
											}
											if(_senceRolesView.heroView.roleDyVo.mapX==endPt.x&&_senceRolesView.heroView.roleDyVo.mapY==endPt.y)
											{
												skillBasicVo.resetCD();
												NoticeUtil.setOperatorNotice("近身不能发起冲锋");
											}
											else 
											{
												fightMoreVo.pt=endPt;
												noticeFightMorePt(fightMoreVo);
												//拉取宠物
												if(PetDyManager.fightPetId>0)
												{
													petPlayer=_senceRolesView.totalViewDict[PetDyManager.fightPetId] as PetPlayerView;
													if(petPlayer)
													{
														heroPullPet(petPlayer,[_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY]);
													}
												}
												return true;
											}
											break;
										case TypeSkill.SpecialEffetType_BeatBack: //击退
											fightMoreVo.uAtkPosArr=[];
											for(i=0;i!=len;++i)
											{
												myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
												beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
												if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
												{
//													beatPt.x=myPlayer.roleDyVo.mapX;
//													beatPt.y=myPlayer.roleDyVo.mapY;
													beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
												}
												fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
											}
											noticeFightMoreBeatBack(fightMoreVo);
											return true;
											break;
									} 
									
								}
								break;
							case TypeSkill.RangeShape_Sector:  ///扇形检测
								rolesArr=_senceRolesView.getSectorRoles(skillBasicVo.effect_range,skillBasicVo.range_param,skillBasicVo.affect_number,skillBasicVo.affect_group);
								len=rolesArr.length;
								if(len>0)
								{
									fightMoreVo=new FightMoreVo();
									fightMoreVo.skillId=skillId;
									fightMoreVo.uAtkArr=rolesArr;
									skillBasicVo.updateCD();
									switch(skillBasicVo.special_effect)
									{
										case TypeSkill.SpecialEffetType_None:
										case TypeSkill.SpecialEffetType_Provok: 
											noticeFightMore(fightMoreVo);
											return true;
											break;
										case TypeSkill.SpecialEffetType_BeatBack: //击退
											fightMoreVo.uAtkPosArr=[];
											for(i=0;i!=len;++i)
											{
												myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
												beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
												if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
												{
//													beatPt.x=myPlayer.roleDyVo.mapX;
//													beatPt.y=myPlayer.roleDyVo.mapY;
													beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
												}
												fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
											}
											noticeFightMoreBeatBack(fightMoreVo);
											return true;
											break;
									}
									
								}
								break;
						}
					}
					else  ///不在攻击范围内
					{
						//重置技能CD  
						moveCloseToPlayerForFight(uAtk,skillId);
						return true;
					}
				}
				else 
				{
//					NoticeUtil.setOperatorNotice("您已经死亡");
					print(this,"您已经死亡");
					GuaJiManager.Instance.stop();
				}
			}
			else //重置技能CD  
			{
//				NoticeUtil.setOperatorNotice("技能冷却中");
				if(skillBasicVo.skill_id!=SkillDyManager.Instance.getDefaultSkill())  //不为 默认 技能
				{
					NoticeManager.setNotice(NoticeType.Notice_id_905);
				}
			}
			return false;
		}
		/**不管有没有人都进行攻击
		 */ 
		private function triggerSkillFightAll(skillId:int):void
		{
			var fightMoreVo:FightMoreVo;//多人pk  技能无点
			var rolesArr:Array;
			var targetPt:Point;///目标点 
			var heroDegree:int;//角色站立方位的角度 

			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel);
			if(handleSpecialBuff(skillBasicVo)) return ;//处理buff
			var i:int;
			var len:int;
			var myPlayer:PlayerView;
			var beatPt:Point;
			////只有当具有目标时才会播放动画  单点
			if(skillBasicVo.skillCanfire())  ///该技能能够发出   过了CD时间 
			{
				if(!_senceRolesView.heroView.isDead)
				{
					switch(skillBasicVo.range_shape)
					{
						case TypeSkill.RangeShape_None:
							if(skillBasicVo.special_effect== TypeSkill.SpecialEffetType_Clean) //净化
							{
								fightMoreVo=new FightMoreVo();
								fightMoreVo.skillId=skillId;
								noticeFightMore(fightMoreVo);
								skillBasicVo.updateCD();
							}
							break;
						case TypeSkill.RangeShape_Circle: ///圆形检测
							rolesArr=_senceRolesView.getCircleRoles(_senceRolesView.heroView.roleDyVo,skillBasicVo.effect_range,skillBasicVo.affect_number,selectPlayer,skillBasicVo.affect_group); ////获取  fightSkillBasicVo.range范围内的角色
							fightMoreVo=new FightMoreVo();
							fightMoreVo.skillId=skillId;
							fightMoreVo.uAtkArr=rolesArr;
							skillBasicVo.updateCD();
							switch(skillBasicVo.special_effect)
							{
								case TypeSkill.SpecialEffetType_None:
								case TypeSkill.SpecialEffetType_Provok: 
									noticeFightMore(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_BeatBack: //击退
									len=rolesArr.length;
									fightMoreVo.uAtkPosArr=[];
									for(i=0;i!=len;++i)
									{
										myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
										beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
										if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
										{
//											beatPt.x=myPlayer.roleDyVo.mapX;
//											beatPt.y=myPlayer.roleDyVo.mapY;
											beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
										}
										fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
									}
									noticeFightMoreBeatBack(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_Clean: //净化
									noticeFightMore(fightMoreVo);
									break;
							}
							
							break;
						case TypeSkill.RangeShape_Line:   ///直线检测
//							heroDegree=DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
							var uAtk:PlayerView=selectPlayer;
							var canTrigerIt:Boolean=false;
							if(_senceRolesView.isUsablePlayer(uAtk)) 
							{
								if(RoleDyManager.Instance.canFight(uAtk.roleDyVo,DataCenter.Instance.roleSelfVo.pkMode,skillBasicVo.affect_group))
								{
									canTrigerIt=true;
								}
							}
							if(canTrigerIt)
							{
								heroDegree=YFMath.getDegree(HeroPositionProxy.mapX,HeroPositionProxy.mapY,uAtk.roleDyVo.mapX,uAtk.roleDyVo.mapY);
							}
							else 
							{
								var endPt:Point=LayerManager.BgMapLayer.mousePt;
								heroDegree=YFMath.getDegree(HeroPositionProxy.mapX,HeroPositionProxy.mapY,endPt.x,endPt.y);//DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
							}
							targetPt=YFMath.getLinePoint4(HeroPositionProxy.mapX,HeroPositionProxy.mapY,skillBasicVo.effect_range,heroDegree);
							rolesArr=_senceRolesView.getLineRoles(targetPt.x,targetPt.y,skillBasicVo.effect_range,skillBasicVo.range_param,null,skillBasicVo.affect_number,skillBasicVo.affect_group); 
							fightMoreVo=new FightMoreVo();
							fightMoreVo.skillId=skillId;
							fightMoreVo.uAtkArr=rolesArr;
							fightMoreVo.pt=targetPt;
							skillBasicVo.updateCD();
							switch(skillBasicVo.special_effect)
							{
								case TypeSkill.SpecialEffetType_None:
								case TypeSkill.SpecialEffetType_Provok: 
									noticeFightMore(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_BeatBack: //击退
									len=rolesArr.length;
									fightMoreVo.uAtkPosArr=[];
									for(i=0;i!=len;++i)
									{
										myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
										beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
										if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
										{
//											beatPt.x=myPlayer.roleDyVo.mapX;
//											beatPt.y=myPlayer.roleDyVo.mapY;
											beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
										}
										fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
									}
									noticeFightMoreBeatBack(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_Clean: //净化
									noticeFightMore(fightMoreVo);
									break;
							}
							
							break;
						case TypeSkill.RangeShape_Sector:  ///扇形检测
							rolesArr=_senceRolesView.getSectorRoles(skillBasicVo.effect_range,skillBasicVo.range_param,skillBasicVo.affect_number,skillBasicVo.affect_group);
							fightMoreVo=new FightMoreVo();
							fightMoreVo.skillId=skillId;
							fightMoreVo.uAtkArr=rolesArr;
							skillBasicVo.updateCD();
							switch(skillBasicVo.special_effect)
							{
								case TypeSkill.SpecialEffetType_None:
								case TypeSkill.SpecialEffetType_Provok: 
									noticeFightMore(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_BeatBack: //击退
									len=rolesArr.length;
									fightMoreVo.uAtkPosArr=[];
									for(i=0;i!=len;++i)
									{
										myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
										beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
										if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
										{
//											beatPt.x=myPlayer.roleDyVo.mapX;
//											beatPt.y=myPlayer.roleDyVo.mapY;
											beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
										}
										fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
									}
									noticeFightMoreBeatBack(fightMoreVo);
									break;
								case TypeSkill.SpecialEffetType_Clean: //净化
									noticeFightMore(fightMoreVo);
									break;
							}
							
							break;
					}
				}
				else 
				{
					NoticeUtil.setOperatorNotice("您已经死亡");
				}
			}
			else 
			{
//				NoticeUtil.setOperatorNotice("技能冷却中");
				NoticeManager.setNotice(NoticeType.Notice_id_905);// 技能正在CD中
			}
		}
		/**对目标点进行攻击
		 */ 
		private function triggerSkillFightMorePt(skillId:int,pt:Point=null):void
		{
//			print(this,"skillPt:",pt);
			var distance:Number=0;
			var fightMoreVo:FightMoreVo;//多人pk  技能无点
//			var fightMorePtVo:FightMorePtVo;/// 多人pk 有点
			var rolesArr:Array;
			var targetPt:Point;///目标点 
			var heroDegree:int;//角色站立方位的角度 
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel);
			if(handleSpecialBuff(skillBasicVo)) return ;//处理buff
			var i:int;
			var len:int;
			var myPlayer:PlayerView;
			var beatPt:Point;
			if(skillBasicVo.skillCanfire())  ///该技能能够发出   过了CD时间 
			{
				if(!_senceRolesView.heroView.isDead)
				{
					if(pt)
					{
						distance=YFMath.distance(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,pt.x,pt.y);
					}
					if(skillBasicVo.use_distance+SkillEffectLen>=distance)
					{
						////只有当具有目标时才会播放动画  
						switch(skillBasicVo.range_shape)
						{
							case TypeSkill.RangeShape_Circle: ///圆形检测
								rolesArr=_senceRolesView.getCircleRoles2(skillBasicVo.effect_range,pt.x,pt.y,skillBasicVo.affect_number,selectPlayer,skillBasicVo.affect_group); ////获取  fightSkillBasicVo.range范围内的角色
								fightMoreVo=new FightMoreVo();
								fightMoreVo.skillId=skillId;
								fightMoreVo.uAtkArr=rolesArr;
								fightMoreVo.pt=pt;
								skillBasicVo.updateCD();
								switch(skillBasicVo.special_effect)
								{
									case TypeSkill.SpecialEffetType_None:
									case TypeSkill.SpecialEffetType_Provok: 
										noticeFightMorePt(fightMoreVo);
										break;
									case TypeSkill.SpecialEffetType_BeatBack: //击退
										len=rolesArr.length;
										fightMoreVo.uAtkPosArr=[];
										for(i=0;i!=len;++i)
										{
											myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
											beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
											if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
											{
//												beatPt.x=myPlayer.roleDyVo.mapX;
//												beatPt.y=myPlayer.roleDyVo.mapY;
												beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
											}
											fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
										}
										noticeFightMorePtBeatBack(fightMoreVo);
										break;
								}
								break;
							case TypeSkill.RangeShape_Line:   ///直线检测
								//		heroDegree=DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
								heroDegree=YFMath.getDegree(HeroPositionProxy.mapX,HeroPositionProxy.mapY,pt.x,pt.y);
								targetPt=YFMath.getLinePoint4(HeroPositionProxy.mapX,HeroPositionProxy.mapY,skillBasicVo.effect_range,heroDegree);
								rolesArr=_senceRolesView.getLineRoles(targetPt.x,targetPt.y,skillBasicVo.effect_range,skillBasicVo.range_param,null,skillBasicVo.affect_number,skillBasicVo.affect_group); 
								fightMoreVo=new FightMoreVo();
								fightMoreVo.skillId=skillId;
								fightMoreVo.uAtkArr=rolesArr;
								fightMoreVo.pt=pt;
								skillBasicVo.updateCD();
								switch(skillBasicVo.special_effect)
								{
									case TypeSkill.SpecialEffetType_None:
									case TypeSkill.SpecialEffetType_Provok: 
										noticeFightMorePt(fightMoreVo);
										break;
									case TypeSkill.SpecialEffetType_BeatBack: //击退
										len=rolesArr.length;
										fightMoreVo.uAtkPosArr=[];
										for(i=0;i!=len;++i)
										{
											myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
											beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
											if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
											{
//												beatPt.x=myPlayer.roleDyVo.mapX;
//												beatPt.y=myPlayer.roleDyVo.mapY;
												beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
											}
											fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
										}
										noticeFightMorePtBeatBack(fightMoreVo);
										break;
								}
								
								break;
							case TypeSkill.RangeShape_Sector:  ///扇形检测
								rolesArr=_senceRolesView.getSectorRoles(skillBasicVo.effect_range,skillBasicVo.range_param,skillBasicVo.affect_number,skillBasicVo.affect_group);
								fightMoreVo=new FightMoreVo();
								fightMoreVo.skillId=skillId;
								fightMoreVo.uAtkArr=rolesArr;
								fightMoreVo.pt=pt;
								skillBasicVo.updateCD();
								switch(skillBasicVo.special_effect)
								{
									case TypeSkill.SpecialEffetType_None:
									case TypeSkill.SpecialEffetType_Provok: 
										noticeFightMorePt(fightMoreVo);
										break;
									case TypeSkill.SpecialEffetType_BeatBack: //击退
										len=rolesArr.length;
										fightMoreVo.uAtkPosArr=[];
										for(i=0;i!=len;++i)
										{
											myPlayer=_senceRolesView.totalViewDict[rolesArr[i]];
											beatPt=YFMath.getLinePoint5(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,myPlayer.roleDyVo.mapX,myPlayer.roleDyVo.mapY,skillBasicVo.special_param);
											if(GridData.Instance.isBlock2(beatPt.x,beatPt.y))
											{
//												beatPt.x=myPlayer.roleDyVo.mapX;
//												beatPt.y=myPlayer.roleDyVo.mapY;
												beatPt=GridData.Instance.getMoveToEndPoint(_senceRolesView.heroView.roleDyVo.mapX,_senceRolesView.heroView.roleDyVo.mapY,beatPt.x,beatPt.y);
											}
											fightMoreVo.uAtkPosArr[i]=BytesUtil.ShortPointToInt32(beatPt.x,beatPt.y);
										}
										noticeFightMorePtBeatBack(fightMoreVo);
										break;
								}
								
								break;
						}
					}
					else  ///不在攻击范围内
					{
						moveCloseToPointForFight(pt,skillId);
					}
				}
				else 
				{
					NoticeUtil.setOperatorNotice("您已经死亡");
				}
			}
			else 
			{
//				NoticeUtil.setOperatorNotice("技能冷却中");
				NoticeManager.setNotice(NoticeType.Notice_id_905);
			}
		}
		
		/** 广播瞬移
		 */		
		private function noticeBlinkMove(endX:int,endY:int):void
		{
			var blinkMoveVo:BlinkMoveVo=new BlinkMoveVo();
			blinkMoveVo.mapX=HeroPositionProxy.mapX;
			blinkMoveVo.mapY=HeroPositionProxy.mapY;
			blinkMoveVo.endX=endX;
			blinkMoveVo.endY=endY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_BlinkMove,blinkMoveVo);
		}
		
	}
}