package com.YFFramework.game.core.module.mapScence.view
{
	/**@author yefeng
	 *2012-4-22上午11:34:55
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.YFUtil;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.ResTexureChache;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.movie.player.optimize.SceneZoneManager;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.textures.sprite2D.ResSimpleTexture;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.manager.EnhanceEffectBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.Gather_ConfigBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.Gather_ConfigBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.character.model.TitleBasicVo;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.EquipCategory;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.AbsAnimatorView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.DropGoodsPlayer;
	import com.YFFramework.game.core.module.mapScence.world.view.player.DropGoodsPlayerToBag;
	import com.YFFramework.game.core.module.mapScence.world.view.player.GatherPlayer;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.mapScence.world.view.player.MonsterView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.NPCPlayer;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PetPlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.RolePlayerView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.TrapPlayer;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskStateVO;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/** 处理所有的角色  管理角色   处理深度排序   角色显示与移除 
	 */	
	public class ScenceRolesView 
	{
		/** 点击地面产生的鼠标效果 
		 */
		/** 保存角色的可视化列表
		 */
		private var _roleViewDict:Dictionary;
		/** 也是用来保存角色对象   作用是用来进行深度排序   默认将 主角对象也添加进去 
		 */
		private var  _roleViewArr:Vector.<PlayerView>;
		
		/** 保存所有的角色ui  不管是存在于舞台上的 还是不存在于舞台上的 
		 */
		private var _totalViewDict:Dictionary;
		/**  怪物的存储对象   主要是用来 进行怪物说话
		 */		
		private var _monsterViewDict:Dictionary;
		/** 管理物品掉落对象
		 */
		private var _dropGoodsDict:Dictionary;
		/**npc存储对象， 用来 NPC进行说话
		 */		
//		private var _npcDict:Dictionary;
		
		private var _npcDict:Vector.<NPCPlayer>;

		private var _heroView:HeroPlayerView;
		/** 当第一次加载地图时 需要进行每个角色的alpha值检测 是否处于消隐点上
		 */		
		private var _checkAlphaPointArr:Array; 
		/**角色的显示范围
		 */
		private var _roleShowPort:Rectangle;
		
		protected static const RoleViewHeight:int=110;
		protected static const RoleViewWidth:int=100;
		
//		private static const NPCHalfLen:int=400;
//		/** npc的距离在距离屏幕多大的范围内开始加载
//		 */
//		private static const NPCDataLoadRect:Rectangle=new Rectangle(-NPCHalfLen,-NPCHalfLen,1900+NPCHalfLen*2,1100+NPCHalfLen*2);  //1900  1100 屏幕大小      准备区域的宽高需要 
		
//		private static const NPCDataLoadRect:Rectangle=BgMapScrollport.scrollPort//new Rectangle(-NPCDistanceLen,-NPCDistanceLen,1900+NPCDistanceLen*2,1100+NPCDistanceLen*2);  //1900  1100 屏幕大小      准备区域的宽高需要 

//		private static var  NPCDataLoadRect:Rectangle;//new Rectangle(-NPCDistanceLen,-NPCDistanceLen,1900+NPCDistanceLen*2,1100+NPCDistanceLen*2);  //1900  1100 屏幕大小      准备区域的宽高需要 

		/**加载队列  防止异步加载队列错误 ， 永远 只调用最后一个
		 */		
		private var _loadDict:Dictionary;
		
		
		/**深度排序timer
		 */		
		private var _arrangeDeepthTimer:Timer;
		/** 怪物说话  npc说话 Timer
		 */		
		private var _arrangeSayWordsTimer:Timer;
		
		public function ScenceRolesView()
		{
			initUI();
			initTimers();
			addEvents();
		}
//		private function NPCLoadPort():void
//		{
//			var tx:int=StageProxy.Instance.getWidth()- NPCHalfLen;
//			var ty:int=StageProxy.Instance.getHeight()- NPCHalfLen;
//			NPCDataLoadRect=new Rectangle(tx,ty,HalfWidth*2,HalfHeight*2);
//
//		}
		protected function initUI():void
		{
			_loadDict=new Dictionary();
			_checkAlphaPointArr=[];
			_roleShowPort=new Rectangle();
			initRoleShowPort();
			ResizeManager.Instance.regFunc(initRoleShowPort);
			
			_roleViewDict=new Dictionary();
			_roleViewArr=new Vector.<PlayerView>();
			_totalViewDict=new Dictionary();
			_monsterViewDict=new Dictionary();
//			_npcDict=new Dictionary();
			_npcDict=new Vector.<NPCPlayer>();
			_dropGoodsDict=new Dictionary();
		}
		protected function initTimers():void
		{
			_arrangeDeepthTimer=new Timer(243);
			_arrangeDeepthTimer.addEventListener(TimerEvent.TIMER,arrangeDeepth);
			_arrangeDeepthTimer.start();
			_arrangeSayWordsTimer=new Timer(5333);
			_arrangeSayWordsTimer.addEventListener(TimerEvent.TIMER,onSayWordTimer);
			_arrangeSayWordsTimer.start();
		}
		private function onSayWordTimer(e:TimerEvent):void
		{
//			var t:Number=getTimer();
			arrangeMonsterSayWords();
			arrangeNPCSayWords();
//			UpdateTT.currentTime -=getTimer()-t;
		}
		protected function addEvents():void
		{
			///进行深度排序 和  舞台对象的配置 
//			UpdateManager.Instance.frame11.regFunc(arrangeDeepth);
			///管理角色的显示与删除    由服务端处理
//			UpdateManager.Instance.frame57.regFunc(arrangeRoleListView); ///暂时不需要了
			/// npc的显示和隐藏
//			////管理怪物说话 
//			UpdateManager.Instance.frame301.regFunc(arrangeMonsterSayWords);
//			///管理npc 说话
//			UpdateManager.Instance.frame301.regFunc(arrangeNPCSayWords);
			//震动屏幕
			
			///主角血量少 屏幕显示 
			//	LayerManager.HpTipsLayer.hide();
			YFEventCenter.Instance.addEventListener(HeroPlayerView.HpTisHide,onHeroEvent);
			YFEventCenter.Instance.addEventListener(HeroPlayerView.HpTisShow,onHeroEvent);
			/////怪物死亡 删除角色
			YFEventCenter.Instance.addEventListener(MapScenceEvent.DeleteDeadMonster,onDeletePlayer);
			
			///更新npc图标状态
			YFEventCenter.Instance.addEventListener(GlobalEvent.taskGetNowList,onNPCFlushState);
			///可接任务列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.taskGetAbleList,onNPCFlushState);
			YFEventCenter.Instance.addEventListener(GlobalEvent.finishTaskOK,onNPCFlushState);
			YFEventCenter.Instance.addEventListener(GlobalEvent.giveUpTaskOK,onNPCFlushState);
			YFEventCenter.Instance.addEventListener(GlobalEvent.acceptTaskOK,onNPCFlushState);
		}
		
		//////////处理npc的任务状态
		/** 处理npc的状态
		 */		
		private function onNPCFlushState(e:YFEvent=null):void
		{
			var taskStateVo:TaskStateVO;
			var npcTalkType:int=0;  // 是否为NPC对话
			for each (var npcPlayer:NPCPlayer in _npcDict)
			{
				taskStateVo=TaskDyManager.getInstance().getNPCState(npcPlayer.roleDyVo.basicId);
				if(taskStateVo.vo)
				{
					if(taskStateVo.tagList.length==1)
					{
						npcTalkType=taskStateVo.tagList[0].tagType;
					}
					npcPlayer.setState(taskStateVo.state,taskStateVo.vo.quality,npcTalkType);
				}
				else npcPlayer.setState(taskStateVo.state,1);  //不存在
			}
		}
		
		
		
		
		///怪物死亡 删除角色
		private function onDeletePlayer(e:YFEvent):void
		{
			var deleteId:uint=uint(e.param);
			deleteRoleView(deleteId);
		}
		private function onHeroEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case HeroPlayerView.HpTisHide:
					LayerManager.HpTipsLayer.hide();
					break;
				case HeroPlayerView.HpTisShow:
					LayerManager.HpTipsLayer.show();
					break;
			}
		}


		/**切换场景   假如主角存在则主角不进行内存释放
		 */
		public function updateMapChange():void
		{
			if(_totalViewDict)disposeCurrentMapScence();
			_totalViewDict=new Dictionary();
			_roleViewDict=new Dictionary();
			_roleViewArr=new Vector.<PlayerView>();
			_totalViewDict=new Dictionary();
			_monsterViewDict=new Dictionary();
//			_npcDict=new Dictionary();
			_npcDict=new Vector.<NPCPlayer>();
			_dropGoodsDict=new Dictionary();
			SceneZoneManager.Instance.clear();
			_totalViewDict[_heroView.roleDyVo.dyId]=_heroView;
			addPlayer(_heroView);
		}
		
		/**释放当前场景  除去 npc    场景地图也不释放
		 */		
		public function disposeMapExceptNPC():void
		{
			for each (var player:PlayerView in _totalViewDict)
			{
				if(player!=_heroView)
				{
					if(player.roleDyVo.bigCatergory!=TypeRole.BigCategory_NPC)
					{
						deleteRoleView(player.roleDyVo.dyId);
					}
				}
			}
		}
		
		
		
		/**释放当前场景  主角不释放 其他角色都释放
		 */
		private function disposeCurrentMapScence():void
		{
			for each (var player:PlayerView in _totalViewDict)
			{
				if(isCanUsePlayer(player))
				{
					if(player.roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  ///当不是当前角色时
					{
						if(LayerManager.PlayerLayer.contains(player))	LayerManager.PlayerLayer.removeChild(player);
						player.dispose();
					}
				}
			}
		}

	

		
		/**导入 npc 
		 * @param arr  保存  当前场景的 Npc_PositionBasicVo 信息数组 
		 */		
		public function handleNPCConfig():void
		{
			var mapId:int=DataCenter.Instance.getMapId();
			var arr:Array=Npc_PositionBasicManager.Instance.getMapMPCList(mapId);  ///该场景的  npc 列表
			var roleDyVo:RoleDyVo;
//			var url:String;
			var npcBasicVo:Npc_ConfigBasicVo;
			var playerView:NPCPlayer;
			
			var timeOut:TimeOut;
			
//			var myT:Number=200;
			for each(var npcPositonVo:Npc_PositionBasicVo in arr)
			{
//				switch(npcPositonVo.type)
//				{
//					case TypeRole.SmallMapShowType_FuncNPC: //功能NPC
//					case TypeRole.SmallMapShowType_OtherNPC://其他NPC 
						if(npcPositonVo.basic_id>0)
						{
							roleDyVo=new RoleDyVo();
							npcBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(npcPositonVo.basic_id);
//							url=URLTool.getNPC(npcBasicVo.model_id);
							roleDyVo.dyId=npcPositonVo.npc_id;
							roleDyVo.basicId=npcPositonVo.basic_id;
							roleDyVo.mapX=npcPositonVo.pos_x;
							roleDyVo.mapY=npcPositonVo.pos_y;
							roleDyVo.bigCatergory=TypeRole.BigCategory_NPC;
							roleDyVo.roleName=npcBasicVo.name;
							roleDyVo.hp=100;
							
							playerView=createRoleView(roleDyVo,false) as NPCPlayer;
							_totalViewDict[roleDyVo.dyId]=playerView;
							///将npc 添加进 RoleDyManager里面
							RoleDyManager.Instance.addRole(roleDyVo);
							checkAlphaPoint(playerView); ///消隐点设置
							
							if(npcPositonVo.type==TypeRole.SmallMapShowType_MoveNPC)
							{
								playerView.setPath(npcPositonVo.path);
								playerView.mouseChildren=playerView.mouseEnabled=false;
							}
							
							//进入场景 加载 NPC资源 
//							loadNPCData(NPCPlayer(playerView));
//							NPCPlayer(playerView).dataInit=true;
							//延迟 1s钟 加载 NPC 
						}
//						break;
//				}
			}
			//切换场景 刷新npc的状态
			onNPCFlushState();
		}
		/**延迟加载NPC资源
		 */		
//		private function loadingNPCData(npcPlayer:NPCPlayer):void
//		{
//			if(!npcPlayer.isDispose)
//			{
//				loadNPCData(npcPlayer);
//				npcPlayer.dataInit=true;
//			}
//		}
		
		/**  更新玩家的血量  当值为0 时  玩家 播放死亡的最后一帧 也就是倒在地上的动作
		 * 
		 */ 
		public function updateHp(dyId:uint):void
		{
			var player:PlayerView=totalViewDict[dyId] as PlayerView;
			player.updateHp();
			if(player.roleDyVo.hp<=0)
			{
				FightView.Instance.handlePlayerInjureDeadLoading(player);
				player.stayDead();
			}
		}
		
		
		
		
		/**添加角色列表
//		 */		
//		public function addRoleList(list:Array):void
//		{
//			///重新创建所有的角色对象
//			var playerView:PlayerView;
//			for each (var roleDyVo:RoleDyVo in list)
//			{
//				playerView=createRoleView(roleDyVo,false);
//				_totalViewDict[roleDyVo.dyId]=playerView;
//				playerView.play(TypeAction.Stand,TypeDirection.Right);
//				checkAlphaPoint(playerView); ///消隐点设置
//				addPlayer(playerView);
//			}
//		}
		
		/**玩家消隐点检测
		 */		
		private function checkAlphaPoint(player:PlayerView):void
		{
			if(MapScenceView._mapConfigLoadComplete)player.checkAlphaPoint(true); //第一次登录 检测 消影点
			else _checkAlphaPointArr.push(player);
		}
		/**检测需要进行透明设置的玩家
		 */		
		public function checkNeededPlayerAlphaPoint():void
		{
			for each(var player:PlayerView in _checkAlphaPointArr)
			{
				if(!player.isDispose) player.checkAlphaPoint(true);//第一次登录 检测 消影点
			}
			_checkAlphaPointArr=[];
		}
			
		/**删除角色
		 */		
		public function delRole(roleId:uint):void
		{
			deleteRoleView(roleId);
		}
		
		/**添加角色
		 * isBirth表示是否为怪物出生 ，为怪物出生时需要加上出生怪物的特效
		 */		
		public function addRole(roleDyVo:RoleDyVo,isBirth:Boolean=false):void
		{
			var playerView:PlayerView=createRoleView(roleDyVo,isBirth);
			_totalViewDict[roleDyVo.dyId]=playerView;
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Pet||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
			{
				var random:int=Math.random()*7+1;
//				playerView.play(TypeAction.Stand,TypeDirection.Down);
				playerView.play(TypeAction.Stand,random);
			}
			else if(roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods) 
			{
				DropGoodsPlayer(playerView).drop();
				playerView.playDefault();//掉落物品
			}
			else if(roleDyVo.bigCatergory==TypeRole.BigCategory_Gather)  // 采集物
			{
				playerView.playDefault();
			}
			checkAlphaPoint(playerView); ///消隐点设置
			addPlayer(playerView);
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**创建主角色
		 */		
		public function createHero():void
		{
			var vo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			_heroView=new HeroPlayerView(vo);//PoolCenter.Instance.getFromPool(HeroPlayerView,vo) as HeroPlayerView;//new HeroPlayerView(vo);
			_totalViewDict[vo.dyId]=_heroView;
			_heroView.play(TypeAction.Stand,TypeDirection.Down);
			checkAlphaPoint(_heroView); ///消隐点设置检测其是否站在消隐点上
			addPlayer(_heroView);
		}

		/**  人物显示的范围 只有在这个范围内才能显示     用于管理当前角色 在场景中的显示   用于 arrangeRoleListView；
		 */
		private function initRoleShowPort():void
		{
			_roleShowPort.width=StageProxy.Instance.viewRect.width+RoleViewWidth*2//+100;
			_roleShowPort.height=StageProxy.Instance.viewRect.height+RoleViewHeight*2//+100;//+BgMapScrollport.HeroHeight;
			_roleShowPort.y=-RoleViewHeight//(BgMapScrollport.HeroHeight>>1)-50;
			_roleShowPort.x=-RoleViewWidth//-50;
		}
		/**  整理角色列表视图    当不在场景大小范围内的角色会被移除舞台     每秒执行 1次来维护这个 角色列表   30帧帧执行一次
		 */
//		private function arrangeRoleListView():void
//		{
//			///对 所有的角色玩家    服务端返回的角色列表进行处理  
//			for each (var roleView:PlayerView in _totalViewDict)
//			{
//				if(isUsablePlayer(roleView))
//				{
//					if(_roleShowPort.contains(roleView.x,roleView.y)) //在可视范围内
//					{  //当不在显示列表中时 将其显示出来
//						if(!_roleViewDict[roleView.roleDyVo.dyId])
//						{
//							addPlayer(roleView);
//						}
//					}
//					else  //不在可视范围内    
//					{ //当前假如在显示列表中 则将其 移除去
//						if(_roleViewDict[roleView.roleDyVo.dyId])
//						{	//不为自己 
//							if(roleView!=_heroView)	removePlayer(roleView.roleDyVo.dyId);
//						}
//					}
//				}
//			}
//		}
		
		
		private function loadNPCData(view:NPCPlayer):void
		{
//			var flag:int=DataCenter.Instance.getMapId();
			var flag:String=SourceCache.ExistAllScene;////NPC资源永远 存在  因为 NPC初始化的时候会卡顿一下
			var npcBasicVo:Npc_ConfigBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(view.roleDyVo.basicId);
			var url:String=URLTool.getNPC(npcBasicVo.model_id);
			var onlyName:String=view.roleDyVo.dyId+"Cloth";
			_loadDict[onlyName]=url;
			///更新皮肤 
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url,flag) as ATFActionData;
			if(actionData) view.updateClothStandWalk(actionData);
			else 
			{
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:view,type:EquipCategory.Cloth,name:onlyName},flag);  ///加载武器
			}

		}
		
		/**处理npc的显示 和隐藏
		 */		
		private function updatPlayerPosView(view:PlayerView):void
		{
			if(_roleShowPort.contains(view.x,view.y)) //在可视范围内
			{  //当不在显示列表中时 将其显示出来
				if(!_roleViewDict[view.roleDyVo.dyId])
				{
					addPlayer(view);
					if(view.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)  //如果 为npc 
					{
						if(!NPCPlayer(view).dataInit)  //进行 数据初始化
						{
							loadNPCData(NPCPlayer(view));
							NPCPlayer(view).dataInit=true;
						}
						else 
						{
							NPCPlayer(view).startCloth();
							NPCPlayer(view).playDefault();
						}
					}
				}
			}
			else  //不在可视范围内    
			{ //当前假如在显示列表中 则将其 移除去
				if(_roleViewDict[view.roleDyVo.dyId])
				{	//不为自己 
					removePlayer(view.roleDyVo.dyId);
					if(view.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC) 
					{
						view.stopCloth();
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.NPCExitView,view.roleDyVo.dyId); // npc离开视野
					}
				}
			}
		}
		/** 添加角色进场景
		 */
		private function addPlayer(roleView:PlayerView):void
		{
			LayerManager.PlayerLayer.addChild(roleView);
			LayerManager.ShadowLayer.addChild(roleView.shadowContainer);
			LayerManager.flashSceneLayer.addChild(roleView.flashContainer);
			_roleViewDict[roleView.roleDyVo.dyId]=roleView;
			_roleViewArr.push(roleView);
		}
		
		
		/**  深度排序  依赖 roleViewArr数组      每 7 帧执行一次
		 */
		private function arrangeDeepth(e:TimerEvent=null):void
		{
			//按照 y坐标进行深度排序
//			_roleViewArr=_roleViewArr.sort(sortFunc);
//			//开始开始设置深度
//			var index:int=0;
//			var childIndex:int;
//			for each (var playerView:PlayerView in _roleViewArr)
//			{
//				childIndex=LayerManager.PlayerLayer.getChildIndex(playerView);
//				if(childIndex!=-1)
//				{
//					if(childIndex!=index)
//					{
//						LayerManager.PlayerLayer.setChildIndex(playerView,index);
//					}
//					++index;
//				}
//			}
			
//			var t:Number=getTimer();
			
			var arr:Vector.<DisplayObject2D>=LayerManager.PlayerLayer.children;
			arr=arr.sort(sortFunc);
			var index:int=0;
			var childIndex:int;
			for each (var playerView:DisplayObject2D in arr)
			{
				childIndex=LayerManager.PlayerLayer.getChildIndex(playerView);
				if(childIndex!=-1)
				{
					if(childIndex!=index)
					{
						LayerManager.PlayerLayer.setChildIndex(playerView,index);
//						if(playerView is PlayerView) ///优化 可以不必处理
//						{
//							LayerManager.ShadowLayer.setChildIndex(PlayerView(playerView).shadowContainer,index);
//							LayerManager.flashSceneLayer.setChildIndex(PlayerView(playerView).flashContainer,index);
//						}
					}
					++index;
				}
			}
			
//			UpdateTT.currentTime -=getTimer()-t;
		}
		
		private function sortFunc(x:DisplayObject2D,y:DisplayObject2D):int
		{
			var xPt:Number=x.y;
			var yPt:Number=y.y;
			if(xPt<yPt) return -1;   ///  +1  是为了防止深度排序随机化
			else if(xPt==yPt)
			{
				if(x.getYF2dID()>y.getYF2dID())return -1;
			}
			return 1;
		}
		/** 处理怪物说话
		 */		
		private function arrangeMonsterSayWords():void
		{
			//开始  怪物说话
			var monsterView:MonsterView;
			var sayWordMonster:MonsterView;
			var monsterBasicVo:MonsterBasicVo;
			var dict:Dictionary;
			var basicId:int;
			for (var basicStr:String in _monsterViewDict)
			{
				basicId=int(basicStr);
				dict=_monsterViewDict[basicId];
				monsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(basicId);
				if(monsterBasicVo.canSay())
				{
					for each(monsterView in dict )
					{
						if(isUsablePlayer(monsterView))
						{
							if(LayerManager.PlayerLayer.contains(monsterView)) ///在可视范围内
							{
								if(isUsablePlayer(sayWordMonster))sayWordMonster=sayWordMonster.sayWordTimes>monsterView.sayWordTimes?monsterView:sayWordMonster;
								else sayWordMonster=monsterView;	
							}
						}
					}
					if(sayWordMonster!=null)
					{
						sayWordMonster.say(monsterBasicVo.getWord());
						sayWordMonster.sayWordTimes++;        
					}
					sayWordMonster=null;
				}
			}
		}

		
		/** 处理NPC说话
		 */		
		private function arrangeNPCSayWords():void
		{
			//开始  怪物说话
			var npcPlayer:NPCPlayer;
			var npcBasicVo:Npc_ConfigBasicVo;
			for each (npcPlayer in _npcDict)
			{
//				npcBasicVo=NPCBasicManager.Instance.getNPCBasicVo(npcPlayer.roleDyVo.basicId);
				npcBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(npcPlayer.roleDyVo.basicId);
				if(npcBasicVo.canSay())  /// npc能进行说话
				{
					if(LayerManager.PlayerLayer.contains(npcPlayer))npcPlayer.say(npcBasicVo.getWord());
				}
			}
		}

		
		 
		
		/**  创建角色 显示对象
		 * isBirth  是否为怪物出生 怪物出生时需要加上怪物出生特效
		 */		
		private function createRoleView(roleVo:RoleDyVo,isBirth:Boolean):PlayerView
		{
//			var myT:Number=getTimer();

			var view:PlayerView;
			switch(roleVo.bigCatergory)
			{
				//玩家
				case TypeRole.BigCategory_Player:
					//其他玩家
					///对象池创建
					view=new RolePlayerView(RoleDyVo(roleVo));
					view.updateSystemConfig();
					break;
				//怪物
				case TypeRole.BigCategory_Monster:
					///对象池创建
					view=new MonsterView(roleVo);
					
					//判断是否为精英 怪 如果 为精英 怪 加 精英怪特效    如果为boss怪 加boss 怪特效
					var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(roleVo.basicId);
					if(monsterBasicVo.monster_type==TypeRole.MonsterType_Elite) //精英怪
					{
						view.addDownBuffEffect(CommonEffectURLManager.MonsterEliteUpEffect);
						view.addDownBuffEffect(CommonEffectURLManager.MonsterEliteDownEffect);
					}
					else if(monsterBasicVo.monster_type==TypeRole.MonsterType_Boss)	//boss怪
					{
						view.addUpBuffEffect(CommonEffectURLManager.MonsterBossUpEffect);
						view.addDownBuffEffect(CommonEffectURLManager.MonsterBossDownEffect);
					}
					
					if(isBirth)  ///为怪物出生加上怪物特效
					{
						var monsterBirthUrl:String=CommonEffectURLManager.MonsterBirthURL;
						var effectData:ATFActionData=SourceCache.Instance.getRes2(monsterBirthUrl) as ATFActionData;
						if(effectData)
						{
							view.addFrontEffect(effectData,[20+60-60*Math.random()]);
						}
						else SourceCache.Instance.loadRes(monsterBirthUrl,null);
					}
					////  怪物说话处理
					if(!_monsterViewDict[roleVo.basicId]) _monsterViewDict[roleVo.basicId]=new Dictionary();
					_monsterViewDict[roleVo.basicId][roleVo.dyId]=view;
					break;
				case TypeRole.BigCategory_Pet: ///宠物
					view=new PetPlayerView(RoleDyVo(roleVo));
					view.updateSystemConfig();
					break;
				//// npc 
				case TypeRole.BigCategory_NPC:
					view=new NPCPlayer(roleVo);
					////npc说话
//					_npcDict[roleVo.dyId]=view;
					_npcDict.push(view);
					break;
				case TypeRole.BigCategory_GropGoods:
					///掉落物品
					view=new DropGoodsPlayer(roleVo);//PoolCenter.Instance.getFromPool(DropGoodsPlayer,roleVo) as DropGoodsPlayer;
					//保持掉落物品  用于 人物按空格键快速拾取
					_dropGoodsDict[view.roleDyVo.dyId]=view;
					view.updateSystemConfig();
					break;
				case TypeRole.BigCategory_Trap:
					view=new TrapPlayer(roleVo);
					if(roleVo.ownId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  //陷阱只有自己能够看到
					{
						view.visible=false;
					}
					break;
				case TypeRole.BigCategory_Gather: //采集物类型
					view=new GatherPlayer(roleVo);
					break;
			}
			
			view.callBack=updatPlayerPosView;//更新坐标    处理player 的显示和隐藏
			view.updateHp();
			view.updateWorldPosition();
			///更新坐标
			return view;
		}
		
		/**  删除显示对象  并且释放内存
		 */		
		private function deleteRoleView(dyId:uint):void
		{
			removePlayer(dyId);////从舞台上移除
			///总对象里移除
			if(_totalViewDict[dyId])
			{
				var playerView:PlayerView=_totalViewDict[dyId] as PlayerView;
					///如果为怪物  从怪物列表中那移除
					////删除该怪物
					if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
						if(_monsterViewDict[playerView.roleDyVo.basicId])
						{
							_monsterViewDict[playerView.roleDyVo.basicId][playerView.roleDyVo.dyId]=null;
							delete _monsterViewDict[playerView.roleDyVo.basicId][playerView.roleDyVo.dyId];
						}
					}
					//如果为掉落物品
					else if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods)
					{
						_dropGoodsDict[playerView.roleDyVo.dyId]=null;
						delete _dropGoodsDict[playerView.roleDyVo.dyId];
					}
					_totalViewDict[dyId].dispose();   
				}
				///释放内存
			_totalViewDict[dyId]=null;
			delete _totalViewDict[dyId];
		}
		/**拾取掉落物品
		 */		
		public function updateGetDropGoods(dyId:int):void
		{
			var dropGoods:DropGoodsPlayer=_totalViewDict[dyId] as DropGoodsPlayer;
			if(dropGoods)
			{
				var dropGoodsToBag:DropGoodsPlayerToBag=new DropGoodsPlayerToBag();
				LayerManager.DisableLayer.addChild(dropGoodsToBag);
				dropGoodsToBag.initData(dropGoods.getBitmapData(),dropGoods.x,dropGoods.y);
			}
		}
		
		/**@param dyId 怪物  id  
		 * 告诉 服务端  该怪物离开人物视野  该需要需要停止移动   服务端广播 怪物九宫格其他玩家
		 */		
//		private function noticeMonsterStopMove(dyId:uint):void
//		{
//			var monsterStopMoveVo:MonsterStopMoveVo=new MonsterStopMoveVo();
//			monsterStopMoveVo.dyId=dyId;
//			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_MonsterStopMove,monsterStopMoveVo);
//		}
		/** 只是将角色对象移除显示列表  也就是移除舞台 但是保存其 ui
		 */
		private function removePlayer(dyId:uint):void
		{
			var playerView:PlayerView=PlayerView(_totalViewDict[dyId]);
			if(playerView)
			{
				if(LayerManager.PlayerLayer.contains(playerView))
				{
					LayerManager.PlayerLayer.removeChild(playerView);
					LayerManager.ShadowLayer.removeChild(playerView.shadowContainer);
					LayerManager.flashSceneLayer.removeChild(playerView.flashContainer);
				}
				var index:int=_roleViewArr.indexOf(playerView);
				if(index!=-1)_roleViewArr.splice(index,1);
				delete _roleViewDict[dyId];
			}
		}
		
		/**获取当前场景所有玩家
		 */		
		public function get totalViewDict():Dictionary
		{
			return _totalViewDict;
		}
		
		/**  获取主角
		 */
		public function get heroView():HeroPlayerView
		{
			return _heroView;
		}
	
		/**更新采集物 外貌
		 * playerId  采集物id   
		 * basicId  采集物的静态 id 
		 */		
		public function updateGatherPlayerCloth(playerId:int,basicId:int):void
		{
			var player:GatherPlayer=_totalViewDict[playerId] as GatherPlayer;
			if(player)
			{
				var gatherBasicVo:Gather_ConfigBasicVo=Gather_ConfigBasicManager.Instance.getGather_ConfigBasicVo(basicId);
				var url:String=URLTool.getGatherCloth(gatherBasicVo.model_id);
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储

				var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
				
				if(actionData) player.updateClothStandWalk(actionData);
				else 
				{
					SourceCache.Instance.addEventListener(url,onGatherLoaded);
					SourceCache.Instance.loadRes(url,player,exsitFlag);  ///加载衣服
				}
			}
		}
		private function onGatherLoaded(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onGatherLoaded);
			var actionData:ATFActionData=SourceCache.Instance.getRes(url) as ATFActionData;
			var data:Object=e.param ;
			for each(var player:PlayerView in data)
			{
				if(isCanUsePlayer(player))
				{
					player.updateClothStandWalk(actionData);
				}
			}
		}
		/**更新掉落物品的皮肤
		 *  playerId  掉落物品动态id      basicId 掉落物品静态id  type 物品类型  是 道具还是装备
		 */	
		public function updateDropGoodsCloth(playerId:uint,basicId:int,type:int):void
		{
			var url:String="";
			var player:DropGoodsPlayer=_totalViewDict[playerId] as DropGoodsPlayer;
			if(type==TypeProps.ITEM_TYPE_EQUIP)  ///为装备
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(basicId);
//				url=URLTool.getDropGoodsIcon(equipBasicVo.icon_id);
				url=URLTool.getGoodsIcon(equipBasicVo.icon_id);
			}   
			else if(type==TypeProps.ITEM_TYPE_PROPS)  ///为道具 
			{
				var propBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(basicId);
//				url=URLTool.getDropGoodsIcon(propBasicVo.icon_id);
				url=URLTool.getGoodsIcon(propBasicVo.icon_id);
			}
			ResTexureChache.Instance.addEventListener(url,onResComplete);
			ResTexureChache.Instance.loadRes(url,player);
		}
		private function onResComplete(e:YFEvent):void
		{
			var url:String=e.type;
			var data:Object=e.param;
			ResTexureChache.Instance.removeEventListener(url,onResComplete);
			var simpleTexture:ResSimpleTexture=ResTexureChache.Instance.getRes(url) as ResSimpleTexture;
			for each(var player:DropGoodsPlayer in data)
			{
				if(!player.isDispose)
				{
					player.initGoodsSkin(simpleTexture);
				}
			}
		}
		/**更新  活动对象名称
		 */		
		public function updateRoleName(dyId:int,name:String):void
		{
			var player:PlayerView=_totalViewDict[dyId];
			player.roleDyVo.roleName=name;
			player.updateName();
		}
		/**更新人物称号
		 * tiltleBasicId  静态id  tiltleBasicId >0 表示设置称号  tittle<=0 表示取消称号 该值一般设置成-1
		 */		
		public function updateTittle(playerId:int,tiltleBasicId:int):void
		{
			var player:PlayerView=_totalViewDict[playerId];
			if(isCanUsePlayer(player))
			{
				player.updateTittle(null);  ///清空tittle
				if(tiltleBasicId>0)
				{
					var tittleBasicVo:TitleBasicVo=TitleBasicManager.Instance.getTitleBasicVo(tiltleBasicId);
					if(tittleBasicVo.effect_id>0)
					{
						var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
						if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

						var url:String=URLTool.getTittle(tittleBasicVo.effect_id);
						var actionData:ActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ActionData;
						if(actionData) player.updateTittle(actionData);
						else 
						{
							SourceCache.Instance.addEventListener(url,onTittleLoaded);
							SourceCache.Instance.loadRes(url,player,exsitFlag);  ///加载衣服
						}
					}
				}
			}
		}
		
		private function onTittleLoaded(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onTittleLoaded);
			var arr:Vector.<Object>=e.param as Vector.<Object>;
			var actionData:ActionData=SourceCache.Instance.getRes(url) as ActionData
			for each(var player:PlayerView in arr)
			{
				if(isCanUsePlayer(player))
				{
					player.updateTittle(actionData);
				}
			}
		}
		
		/**  更新正常状态下的 衣服  playerId  角色动态id      equipBasicId 装备静态id 
		 * 为-1  的话 则是 默认皮肤
		 */		
		public function updateCloth(playerId:uint,equipBasicId:int=-1):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			player.updateMountHead(null);
			player.updateClothFight(null);
			player.updateClothInjureDead(null);
			player.updateClothFightStand(null);
			player.updateClothAtk_1(null);
			var url:String;
			if(equipBasicId>0)
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
				var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
				url=URLTool.getClothStandWalk(modelId);
			}
			else   ///默认皮肤
			{
				url=URLTool.getClothStandWalk(TypeRole.getDefaultSkin(RoleDyVo(player.roleDyVo).sex,RoleDyVo(player.roleDyVo).career));
			}
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
			var onlyName:String=player.roleDyVo.dyId+"Cloth"; ///依托于 type
			_loadDict[onlyName]=url;
			var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
			if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;

			if(player.roleDyVo.hp==0)
			{
				FightView.Instance.handlePlayerInjureDeadLoading(player);
				player.stayDead();
			}
			if(actionData) 
			{
				player.updateClothStandWalk(actionData);
				if(player.roleDyVo.hp>0)
				{
					player.play(TypeAction.Stand);
				}
				else player.stayDead();
			}
			else 
			{
				player.resetSkin();
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,name:onlyName},exsitFlag);  ///加载衣服
			}
			//更新光效
			updateClothEffect(playerId,player.roleDyVo.clothEnhanceLevel);
		}
		
		/** 更新正常状态下的武器     playerId  角色动态id      equipBasicId 装备静态id 
		 * equipBasicId 为  -1时  为拖去装备
		 */		
		public function updateWeapon(playerId:uint,equipBasicId:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateWeaponFight(null);
				player.updateWeaponInjureDead(null);
				player.updateWeaponFightStand(null);
				player.updateWeaponAtk_1(null);
				
				var mountHeadName:String=player.roleDyVo.dyId+"MountHead";
				_loadDict[mountHeadName]=null; //去掉 坐骑
				
				var onlyName:String=player.roleDyVo.dyId+"Weapon"; //依托于type
				if(equipBasicId>0)
				{
					var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
					var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
					var url:String=URLTool.getWeaponStandWalk(modelId);
					RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
					_loadDict[onlyName]=url;
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;

					if(actionData) 
					{
						player.updateWeaponStandWalk(actionData);
						if(player.roleDyVo.hp>0)
						{
							player.play(TypeAction.Stand);
						}
						else player.stayDead();
					}
					else 
					{
						player.updateWeaponStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Weapon,name:onlyName},exsitFlag);  ///加载武器
					}
					//更新光效
					updateWeaponEffect(playerId,player.roleDyVo.weaponEnhanceLevel);
				}
				else 
				{
					_loadDict[onlyName]=null;
					player.updateWeaponStandWalk(null);
				}
			}
		}
		
		/**更新  武器特效
		 * weaponEnhanceLevel  ==-1 表示特效不存在
		 */
		private function updateWeaponEffect(playerId:int,weaponEnhanceLevel:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateWeaponEffectFight(null);
				player.updateWeaponEffectInjureDead(null);
				player.updateWeaponEffectFightStand(null);
				player.updateWeaponEffectAtk_1(null);
				
				var onlyName:String=player.roleDyVo.dyId+"WeaponEffect"; //依托于type 

				var weaponEffectId:int=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Weapon,player.roleDyVo.sex,weaponEnhanceLevel,player.roleDyVo.career);
				
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

				if(weaponEffectId>0) //如果特效存在
				{
					var url:String=URLTool.getWeaponEffectStandWalk(weaponEffectId);
					_loadDict[onlyName]=url;
					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
					if(actionData) player.updateWeaponEffectStandWalk(actionData);
					else 
					{
						player.updateWeaponEffectStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.WeaponEffect,name:onlyName},exsitFlag);  ///加载武器
					}

				}
				else //特效不存在 
				{
					player.updateWeaponEffectStandWalk(null);
					_loadDict[onlyName]=null;
				}
			}
		}
		/**更新   衣服特效
		 */		
		private function updateClothEffect(playerId:int,clothEnhanceLevel:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateClothEffectFight(null);
				player.updateClothEffectInjureDead(null);
				player.updateClothEffectAtk_1(null);
				player.updateClothEffectFightStand(null);
				
				var onlyName:String=player.roleDyVo.dyId+"ClothEffect"; //依托于type 
				var clothEffectId:int=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Cloth,player.roleDyVo.sex,clothEnhanceLevel,player.roleDyVo.career);
				if(clothEffectId>0) //如果特效存在
				{
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

					var url:String=URLTool.getClothEffectStandWalk(clothEffectId);
					_loadDict[onlyName]=url;
					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
					if(actionData) player.updateClothEffectStandWalk(actionData);
					else 
					{
						player.updateClothEffectStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.ClothEffect,name:onlyName},exsitFlag);  ///加载武器
					}
				}
				else //特效不存在 
				{
					player.updateClothEffectStandWalk(null);
					_loadDict[onlyName]=null;
				}
			}
		}
		
		private function updateMountClothEffect(playerId:int,clothEnhanceLevel:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateClothEffectFight(null);
				player.updateClothEffectInjureDead(null);
				player.updateClothEffectAtk_1(null);
				player.updateClothEffectFightStand(null);

				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

				var onlyName:String=player.roleDyVo.dyId+"ClothEffect"; //依托于type 
				var clothEffectId:int=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Cloth,player.roleDyVo.sex,clothEnhanceLevel,player.roleDyVo.career);
				if(clothEffectId>0) //如果特效存在
				{
					var url:String=URLTool.getMountClothEffect(clothEffectId);
					_loadDict[onlyName]=url;
					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
					if(actionData) player.updateClothEffectStandWalk(actionData);
					else 
					{
						player.updateClothEffectStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.ClothEffect,name:onlyName},exsitFlag);  ///加载武器
					}
				}
				else //特效不存在 
				{
					player.updateClothEffectStandWalk(null);
					_loadDict[onlyName]=null;
				}
			}
		}
		
		/** 更新 头部
		 * @param playerId
		 * @param equipBasicId
		 * @param sex
		 */		
		public function updateWing(playerId:uint,equipBasicId:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateWingFight(null);
				player.updateWingInjureDead(null);
				player.updateWingFightStand(null);
				player.updateWingAtk_1(null);
				
				var onlyName:String=player.roleDyVo.dyId+"Wing";
				if(equipBasicId>0)
				{
					var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
					var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
					var url:String=URLTool.getWingStandWalk(modelId);
					RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
					
					_loadDict[onlyName]=url;
					if(actionData) 
					{
						player.updateWingStandWalk(actionData);
						if(player.roleDyVo.hp>0)
						{
							player.play(TypeAction.Stand);
						}
						else player.stayDead();
					}
					else 
					{
						player.updateWingStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Wing,name:onlyName},exsitFlag);  ///加载武器
					}
				}
				else 
				{
					player.updateWingStandWalk(null);
					_loadDict[onlyName]=null;
				}
			}
		}
		/**更新翅膀
		 * @param playerId
		 * @param equipBasicId
		 */		
		public function updateMountWing(playerId:uint,equipBasicId:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(player)
			{
				player.updateWingFight(null);
				player.updateWingInjureDead(null);
				player.updateWingFightStand(null);
				player.updateWingAtk_1(null);

				var onlyName:String=player.roleDyVo.dyId+"Wing";
				if(equipBasicId>0)
				{
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

					var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
					var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
					var url:String=URLTool.getMountWing(modelId);
					RoleDyVo(player.roleDyVo).state=TypeRole.State_Mount;
					var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
					_loadDict[onlyName]=url;
					if(actionData) player.updateWingStandWalk(actionData);
					else 
					{
						player.updateWingStandWalk(null);
						SourceCache.Instance.addEventListener(url,onActionDataLoaded);
						SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Wing,name:onlyName},exsitFlag);  ///加载武器
					}
				}
				else 
				{
					player.updateWingStandWalk(null);
					_loadDict[onlyName]=null;
				}
			}
		}
		
		/**   更新人物打坐的 衣服
		 * equipBasicId:int  衣服的静态id 
		 */		
		public function updateSitCloth(playerId:uint,equipBasicId:int):void
		{
			
			print(this,"更新，待加....？？？？");

//			var equipBasicVo:EquipBasicVo=GoodsBasicManager.Instance.getEquipBasicVo(equipBasicId);
//			var skinVo:SkinVo=SkinManager.Instance.getSkinVo(equipBasicVo.resId);
			var url:String="";//URLTool.getSitCloth(skinVo.sitSkinId);
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			player.updateMountHead(null);
//			player.swapIndex(true);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Sit;
			var onlyName:String=player.roleDyVo.dyId+"Cloth";
			_loadDict[onlyName]=url;
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			if(actionData) player.updateClothStandWalk(actionData);
			else 
			{
				player.resetSkin();
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,name:onlyName},exsitFlag);  ///加载武器
			}
			///播放打坐特效
			var effectAction:ATFActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.SitEffectURL) as ATFActionData;
			if(effectAction) player.addFrontEffect(effectAction,[0],true);
			else 
			{
				SourceCache.Instance.addEventListener(CommonEffectURLManager.SitEffectURL,onEffectLoaded);
				SourceCache.Instance.loadRes(CommonEffectURLManager.SitEffectURL,player);
			}
		}
		/**移除玩家 前端特效
		 */		
		public function removePlayerFrontEffect(playerId:uint):void
		{
			var player:PlayerView=_totalViewDict[playerId] as PlayerView;
			player.removeFrontEffect();
		}
		private function onEffectLoaded(e:YFEvent):void
		{
			var url:String=e.type;
			var vect:Vector.<Object>=e.param as Vector.<Object>;
			var player:PlayerView=vect[0] as PlayerView;
			var effectAction:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			player.addFrontEffect(effectAction,[0],true);
		}
			
		
		/**更新人物打坐的
		 *   equipBasicId武器  的静态id 
		 */		
		public function updateSitWeapon(playerId:uint,equipBasicId:int,sex:int):void
		{
			print(this,"更新武器..........待做");
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
//			player.swapIndex(true);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Sit;
			
			var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
			var modelId:int=equipBasicVo.getModelId(sex);
			if(modelId>0)
			{
				var url:String=URLTool.getSitWeapon(modelId);
				var onlyName:String=player.roleDyVo.dyId+"Weapon";
				_loadDict[onlyName]=url;
				var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData) player.updateWeaponStandWalk(actionData);
				else 
				{
					player.updateWeaponStandWalk(null);
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
					SourceCache.Instance.addEventListener(url,onActionDataLoaded);
					SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Weapon,name:onlyName},exsitFlag);  ///加载武器
				}
			}
		}
		
		/**  更新坐骑衣服   playerId  角色动态id      equipBasicId 装备静态id 
		 */		
		public function updateMountCloth(playerId:uint,equipBasicId:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(isUsablePlayer(player)) 
			{
				player.updateClothFight(null);
				player.updateClothInjureDead(null);
				player.updateClothFightStand(null);
				player.updateClothAtk_1(null);

				var url:String;
				if(equipBasicId>0)
				{
					var sex:int=RoleDyVo(player.roleDyVo).sex;
					var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
					url=URLTool.getMountCloth(equipBasicVo.getModelId(sex));
				}
				else  //获取默认的皮肤
				{
					url=URLTool.getMountCloth(TypeRole.getDefaultSkin(RoleDyVo(player.roleDyVo).sex,RoleDyVo(player.roleDyVo).career));
				}
				RoleDyVo(player.roleDyVo).state=TypeRole.State_Mount;
				
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;

				//			player.swapIndex(true);
				
				var onlyName:String=player.roleDyVo.dyId+"Cloth";
				_loadDict[onlyName]=url;
				var actionData:ATFActionData=SourceCache.Instance.getRes2(url,exsitFlag) as ATFActionData;
				if(actionData) player.updateClothStandWalk(actionData);
				else 
				{
					player.resetSkin();
					SourceCache.Instance.addEventListener(url,onActionDataLoaded);
					SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,name:onlyName},exsitFlag);  ///加载武器
				}
				updateMountClothEffect(playerId,player.roleDyVo.clothEnhanceLevel);
				updateWeaponEffect(playerId,-1);
			}
		}
		
		
		
		/** 更新坐骑 ,将坐骑放到武器上    playerId  角色动态id      mountBasicId 坐骑静态id 
		 */		
		public function updateMount(playerId:uint,mountBasicId:int):void
		{
			var modelId:int=MountBasicManager.Instance.getMountModelId(mountBasicId); 
			var mountBasicVo:MountBasicVo=MountBasicManager.Instance.getMountBasicVo(mountBasicId);
			var mountHeadUrl:String=URLTool.getMountHead(modelId); //头部模型
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Mount;
			var exsitFlag:Object=DataCenter.Instance.getMapId(); 
			if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
			var mountHeadActionData:ATFActionData=SourceCache.Instance.getRes2(mountHeadUrl,exsitFlag) as ATFActionData;
		

			var onlyName:String=player.roleDyVo.dyId+"MountHead";
			_loadDict[onlyName]=mountHeadUrl;
			if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
			if(mountHeadActionData)  player.updateMountHead(mountHeadActionData);
			else 
			{
				player.updateMountHead(null);
				SourceCache.Instance.addEventListener(mountHeadUrl,onActionDataLoaded);
				SourceCache.Instance.loadRes(mountHeadUrl,{player:player,type:EquipCategory.MountHead,name:onlyName},exsitFlag);  ///加载坐骑
			}
			///躯干部分
			player.updateWeaponStandWalk(null);
			var mountBodyName:String=player.roleDyVo.dyId+"Weapon";
			if(mountBasicVo.parts==TypeProps.MOUNT_PARTS_2)
			{
				var mountBodyUrl:String=URLTool.getMountBody(modelId); // 躯干模型
				var mountBodyActionData:ATFActionData=SourceCache.Instance.getRes2(mountBodyUrl,exsitFlag) as ATFActionData;
				_loadDict[mountBodyName]=mountBodyUrl;
				if(mountBodyActionData) player.updateWeaponStandWalk(mountBodyActionData); 
				else 
				{
					player.updateWeaponStandWalk(null);
					///存储的位置  是永久存储 还是只是单场景存储
					SourceCache.Instance.addEventListener(mountBodyUrl,onActionDataLoaded);
					SourceCache.Instance.loadRes(mountBodyUrl,{player:player,type:EquipCategory.Weapon,name:mountBodyName},exsitFlag);  ///加载坐骑
				}
			}
			else 
			{
				_loadDict[mountBodyName]=null;  
			}
		}
		
		/**更新 怪物点皮肤
		 */ 
		public function updateMonsterClothSKin(playerId:uint,monsterBasicId:int):void
		{
			var mapId:int=DataCenter.Instance.getMapId();
			var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(monsterBasicId);
			var url:String=URLTool.getMonsterStandWalk(monsterBasicVo.model_id);
			var player:PlayerView=_totalViewDict[playerId] as PlayerView;
			var onlyName:String=player.roleDyVo.dyId+"Cloth";
			_loadDict[onlyName]=url;
			var actionData:ATFActionData=SourceCache.Instance.getRes(url) as ATFActionData;
		//	if(SourceCache.Instance.getRes(url,mapId)) player.updateCloth(SourceCache.Instance.getRes(url,mapId) as ActionData);
			if(actionData)player.updateClothStandWalk(actionData);
			else 
			{
				player.resetSkin();
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,name:onlyName},mapId);  ///加载武器
			}
		}
		
		/**更新宠物皮肤
		 */ 
		public function updatePetClothSKin(playerId:uint,petbaiscId:int):void
		{
			var petConfigVo:PetBasicVo=PetBasicManager.Instance.getPetConfigVo(petbaiscId);
			var url:String=URLTool.getMonsterStandWalk(petConfigVo.model_id);
			var player:PlayerView=_totalViewDict[playerId] as PlayerView;
			var onlyName:String=player.roleDyVo.dyId+"Cloth";
			_loadDict[onlyName]=url;
			var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
			///当为自己的宠物
			if(PetDyManager.Instance.getPetDyVo(playerId)!=null)exsitFlag=SourceCache.ExistAllScene;
			var actionData:ATFActionData=SourceCache.Instance.getRes(url) as ATFActionData;
			if(actionData) player.updateClothStandWalk(actionData);
			else 
			{
				player.resetSkin();
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,name:onlyName},exsitFlag);  ///加载武器
			}
		}
	
		
		/**当动画文件加载完成 
		 */
		private function onActionDataLoaded(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onActionDataLoaded);
			var data:Vector.<Object>= Vector.<Object>(e.param) ;
			var player:PlayerView;
			var actionData:ATFActionData;//=SourceCache.Instance.getRes(url) as YF2dActionData;
			var checkUrl:String;
			for each (var obj:Object in data )
			{
				if(obj)
				{
					checkUrl=_loadDict[obj.name];
					if(checkUrl)  ///当前   需要使用的模型
					{
						actionData=SourceCache.Instance.getRes(checkUrl) as ATFActionData;
						if(actionData)
						{
							player=obj.player as PlayerView;// as PlayerView;
							if(isCanUsePlayer(player))
							{
								switch(obj.type)
								{
									case EquipCategory.Weapon:
										Object(player).updateWeaponStandWalk(actionData);
										break;
									case EquipCategory.Cloth:
										player.updateClothStandWalk(actionData);
										break;
									case EquipCategory.Wing:  //翅膀模型
										Object(player).updateWingStandWalk(actionData);
										break;
									case EquipCategory.MountHead: // 坐骑头部模型
										Object(player).updateMountHead(actionData);
										break;
									case EquipCategory.WeaponEffect:  //武器光效
										RolePlayerView(player).updateWeaponEffectStandWalk(actionData);
										break;
									case EquipCategory.ClothEffect: //衣服光效
										RolePlayerView(player).updateClothEffectStandWalk(actionData);
										break;
								}
								player.checkAlphaPoint(true);//检测是否可以显示影子
								FightView.Instance.checkStayDead(player);
								
							}
						}
					}
				}
			}
		}
	
		
		/** 
		 * @param affectgroup  搜索的类型   技能类型 值在TypeSKill里面 为 技能静态表字段
		 * @param len 
		 */
		public function findCanFightPlayerForSkill(affectgroup:int,len:int=1000):PlayerView
		{
			var _checkArr:Array;
			var player:PlayerView;
			
			var playerArr:Array;
			var distance:Number;
			var obj:Object;
			
			var myLen:int=100;
			
			while(myLen<=len)
			{
				playerArr=[];
				//				_rangeEndpt=YFMath.getLinePoint4(_heroView.x,_heroView.y,myLen,HeroPositionProxy.direction);
				//				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x,_heroView.y,_rangeEndpt.x,_rangeEndpt.y);	
				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x+myLen,_heroView.y+myLen,_heroView.x-myLen,_heroView.y-myLen);	
				
				for each (player in _checkArr)
				{
					if(isCanFightPlayer(player,affectgroup))
					{
						if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(player.roleDyVo,affectgroup))
						{
							if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false)  
							{
								distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
								playerArr.push({player:player,distance:distance});
							}
						}
					}
				}
				if(playerArr.length>0)
				{
					playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
					obj=playerArr.pop()
					return obj.player as PlayerView;
				}
				
				myLen+=100;
			}
			
			///如果找不到.....		////全局寻找
			playerArr=[];
			for each (player in _totalViewDict)
			{
				if(isCanFightPlayer(player,affectgroup))
				{
					if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(player.roleDyVo,affectgroup))
					{
						if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false)   ///
						{
							distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
							playerArr.push({player:player,distance:distance});
						}
					}
				}
			}
			if(playerArr.length>0)
			{
				playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				obj=playerArr.pop()
				return obj.player as PlayerView;
			}
			if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(heroView.roleDyVo,affectgroup))
			{
				return heroView;
			}
			return null;
		}

		/**寻找可以战斗的对象 自动挂机需要 
		 * len 为搜索的范围
		 */		
		public function findCanFightPlayer(len:int=1000):PlayerView
		{
//			var _rangeEndpt:Point;
			var _checkArr:Array;
			var player:PlayerView;
			
			var playerArr:Array;
			var distance:Number;
			var obj:Object;

			var myLen:int=100;
			
			while(myLen<=len)
			{
				playerArr=[];
//				_rangeEndpt=YFMath.getLinePoint4(_heroView.x,_heroView.y,myLen,HeroPositionProxy.direction);
//				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x,_heroView.y,_rangeEndpt.x,_rangeEndpt.y);	
				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x+myLen,_heroView.y+myLen,_heroView.x-myLen,_heroView.y-myLen);	

				for each (player in _checkArr)
				{
					if(isCanFightPlayer(player))
					{
						if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false)  
						{
							distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
							playerArr.push({player:player,distance:distance});
						}
					}
				}
				if(playerArr.length>0)
				{
					playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
					obj=playerArr.pop()
					return obj.player as PlayerView;
				}

				myLen+=100;
			}

				///如果找不到.....		////全局寻找
			playerArr=[];
			for each (player in _totalViewDict)
			{
				if(isCanFightPlayer(player))
				{
					if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false)   ///
					{
						distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
						playerArr.push({player:player,distance:distance});
					}
				}
			}
			if(playerArr.length>0)
			{
				playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				obj=playerArr.pop()
				return obj.player as PlayerView;
			}
			return null;
		}
		/** 寻找 到basicId   类型的怪物
		 * @param basicId
		 * len 为搜索的范围
		 */				
		public function findCanFightPlayer2(basicId:int,len:int=1000):PlayerView
		{
//			var _rangeEndpt:Point;
			var _checkArr:Array;
			var player:PlayerView;
			var playerArr:Array;
			var distance:Number;
			var obj:Object;

			var myLen:int=100;
			while(myLen<=len)
			{
				playerArr=[];
//				_rangeEndpt=YFMath.getLinePoint4(_heroView.x,_heroView.y,myLen,HeroPositionProxy.direction);
//				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x,_heroView.y,_rangeEndpt.x,_rangeEndpt.y);
				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x+myLen,_heroView.y+myLen,_heroView.x-myLen,_heroView.y-myLen);	

				for each (player in _checkArr)
				{
					if(isCanFightPlayer(player))
					{
						if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false&&player.roleDyVo.basicId==basicId)  
						{
							distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
							playerArr.push({player:player,distance:distance});
						}
					}
				}
				if(playerArr.length>0)
				{
					playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
					obj=playerArr.pop()
					return obj.player as PlayerView;
				}

				myLen+=100;
			}

			///如果找不到.....		////全局寻找
			playerArr=[];
			for each (player in _totalViewDict)
			{
				if(isCanFightPlayer(player))
				{
					if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false&&player.roleDyVo.basicId==basicId)  
					{
						distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
						playerArr.push({player:player,distance:distance});
					}
				}
			}
			if(playerArr.length>0)
			{
				playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				obj=playerArr.pop()
				return obj.player as PlayerView;
			}
			return null;
		}
		
		
		
		/** 寻找 basicIdArr中 的任意一个类型的怪物    ---  挂机使用
		 * @param basicIdArr      怪物静态变量hash表
		 * @param len
		 */		
		public function findCanFightPlayer3(basicIdDict:Dictionary,affect_group:int,len:int=1000):PlayerView
		{
//			var _rangeEndpt:Point;
			var _checkArr:Array;
			var player:PlayerView;
			var myLen:int=100;
			var playerArr:Array;
			var distance:Number;
			var obj:Object;
			while(myLen<=len)
			{
				playerArr=[];
//				_rangeEndpt=YFMath.getLinePoint4(_heroView.x,_heroView.y,myLen,HeroPositionProxy.direction);
//				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x,_heroView.y,_rangeEndpt.x,_rangeEndpt.y);	
				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x+myLen,_heroView.y+myLen,_heroView.x-myLen,_heroView.y-myLen);	
				for each (player in _checkArr)
				{
					if(isCanFightPlayer(player,affect_group))
					{
						if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(player.roleDyVo,affect_group))
						{
//							if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false&&basicIdDict[player.roleDyVo.basicId])  //return player;
//							{
								distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
								playerArr.push({player:player,distance:distance});
//							}
						}
					}
				}
				if(playerArr.length>0)
				{
					playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
					obj=playerArr.pop()
					return obj.player as PlayerView;
				}
				myLen+=100;
			}
			//实际范围检测
			///如果找不到.....		////全局寻找
			playerArr=[];
			for each (player in _totalViewDict)
			{
				if(isCanFightPlayer(player,affect_group))
				{
					if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(player.roleDyVo,affect_group))
					{
//						if(player!=_heroView&&PetDyManager.Instance.hasPet(player.roleDyVo.dyId)==false&&basicIdDict[player.roleDyVo.basicId])  
//						{
							
							distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
							playerArr.push({player:player,distance:distance});
//						}
					}

				}
			}
			if(playerArr.length>0)
			{
				playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				obj=playerArr.pop()
				return obj.player as PlayerView;
			}
			return null;
		}
		
		
		

		/** 寻找 到basicId   类型的采集物
		 * @param basicId
		 * len 为搜索的范围
		 */				
		public function findGatherPlayer(basicId:int,len:int=1000):PlayerView
		{
//			var _rangeEndpt:Point;
			var _checkArr:Array;
			var player:PlayerView;
			var playerArr:Array;
			var distance:Number;
			var obj:Object;
			var myLen:int=100;
			while(myLen<=len)
			{
				playerArr=[];
//				_rangeEndpt=YFMath.getLinePoint4(_heroView.x,_heroView.y,myLen,HeroPositionProxy.direction);
//				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x,_heroView.y,_rangeEndpt.x,_rangeEndpt.y);	
				_checkArr=SceneZoneManager.Instance.getZoneArr(_heroView.x+myLen,_heroView.y+myLen,_heroView.x-myLen,_heroView.y-myLen);	

				for each (player in _checkArr)
				{
					if(isCanFightPlayer(player))
					{
						if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Gather)
						{
							if(player.roleDyVo.basicId==basicId)  
							{
//								return player;
								distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
								playerArr.push({player:player,distance:distance});
							}
						}
					}
				}
				if(playerArr.length>0)
				{
					playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
					obj=playerArr.pop()
					return obj.player as PlayerView;
				}
				myLen+=100;
			}
			///如果找不到.....		////全局寻找
			playerArr=[];
			for each (player in _totalViewDict)
			{
				if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Gather)
				{
					if(player.roleDyVo.basicId==basicId)  
					{
						distance=YFMath.distance(player.roleDyVo.mapX,player.roleDyVo.mapY,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY);
						playerArr.push({player:player,distance:distance});
					}
				}
			}
			if(playerArr.length>0)
			{
				playerArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				obj=playerArr.pop()
				return obj.player as PlayerView;
			}
			return null;
		}
		
		
		/**获取某个范围内 的掉落物品
		 *   圆形检测 
		 */ 
		public function getDropGoodsID(circle:int):DropGoodsPlayer
		{
			var dropGoodsArr:Array=[];
			var distance:Number;
			var obj:Object;
			for each(var dropGoodsView:DropGoodsPlayer in _dropGoodsDict)
			{
				if(isUsablePlayer(dropGoodsView))
				{
					distance=YFMath.distance(dropGoodsView.roleDyVo.mapX,dropGoodsView.roleDyVo.mapY,heroView.roleDyVo.mapX,heroView.roleDyVo.mapY);
					if(distance<=circle) //可以拾取物品
					{
						obj={player:dropGoodsView,distance:distance};
						dropGoodsArr.push(obj);
					}
				}
			}
			
			if(dropGoodsArr.length>0)
			{
				dropGoodsArr.sortOn("distance",Array.NUMERIC|Array.DESCENDING);
				var player:DropGoodsPlayer=dropGoodsArr.pop().player as DropGoodsPlayer ;
				return player;
			}
			return null;
		}
		
		
		/**获取掉落数组
		 */
		public function getDropGoodsIdArr(circle:int):Array 
		{
			var dropGoodsArr:Array=[];
			var distance:Number;
//			var obj:Object;
			for each(var dropGoodsView:DropGoodsPlayer in _dropGoodsDict)
			{
				if(isUsablePlayer(dropGoodsView))
				{
					distance=YFMath.distance(dropGoodsView.roleDyVo.mapX,dropGoodsView.roleDyVo.mapY,heroView.roleDyVo.mapX,heroView.roleDyVo.mapY);
					if(distance<=circle) //可以拾取物品
					{
//						obj={player:dropGoodsView,distance:distance};
//						dropGoodsArr.push(obj);
						dropGoodsArr.push(dropGoodsView.roleDyVo.dyId);
					}
				}
			}
			
			return dropGoodsArr;
		}
		
		/**数学方法得到某个园内区域的角色id    相对于 主角的圆形区域内的角色
		 * radius 是半径
		 * maxNum  是获取的最大数量
		 * selectPlayer 当前鼠标选中的  角色  如何 不为空  则 这个角色一定会出现在数组列表里 否则不一定出现在数组列表里
		 * affectGroup 值 在TyeSkill.affectGroup_
		 */ 
		public function getCircleRoles(roleDyVo:RoleDyVo,radius:Number,maxNum:int,selectPlayer:PlayerView,affectGroup:int):Array
		{
			return getCircleRoles2(radius,roleDyVo.mapX,roleDyVo.mapY,maxNum,selectPlayer,affectGroup);
		}
		/**获取主角站立方向的扇形内的玩家
		 * maxNum 玩家数目
		 * affectGroup  值在TypeSkill.AffectGroup
		 */		
		public function getSectorRoles(radius:int,jiaodu:int,maxNum:int,affectGroup:int):Array
		{
			///获取 要检测的格子 
			var rangeLeft:int=_heroView.roleDyVo.mapX-radius;
			var rangleTop:int=_heroView.roleDyVo.mapY-radius;
			var rangeRight:int=_heroView.roleDyVo.mapX+radius;
			var rangeBottom:int=_heroView.roleDyVo.mapY+radius;
			var _rangeStartPt:Point=AbsAnimatorView.getFlashPt(rangeLeft,rangleTop);
			var _rangeEndPt:Point=AbsAnimatorView.getFlashPt(rangeRight,rangeBottom);
			var _checkArr:Array=SceneZoneManager.Instance.getZoneArr(_rangeStartPt.x,_rangeStartPt.y,_rangeEndPt.x,_rangeEndPt.y);	
			var arr:Array=[];
			var distance:Number;
			var currentNum:int=0;
			for each(var role:PlayerView in _checkArr)
			{
				if(currentNum<maxNum)
				{
					if(isCanFightPlayer(role,affectGroup))  ///只有 人物  怪物  宠物    能进行攻击   npc 是不能进行攻击的
					{
						if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(role.roleDyVo,affectGroup))
						{
//							var isInSector:Boolean=DirectionUtil.isInSector(_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5,HeroPositionProxy.direction,radius,jiaodu,role.roleDyVo.mapX,role.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5);
							var isInSector:Boolean=DirectionUtil.isInSector(_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY,HeroPositionProxy.direction,radius,jiaodu,role.roleDyVo.mapX,role.roleDyVo.mapY);
							if(isInSector)
							{
								if(role.roleDyVo.bigCatergory!=TypeRole.BigCategory_Pet)
								{
									arr.push(role.roleDyVo.dyId);
									currentNum++;
									arr.push(role);
								}
								else ///为宠物
								{
									if(!PetDyManager.Instance.hasPet(role.roleDyVo.dyId))  ///不是自己的宠物
									{
										arr.push(role.roleDyVo.dyId);
										currentNum++;
										arr.push(role);
									}
								}
							}
						}
					}
				} 
				else break;
			}
			//如果  打不到条件  并且为队友 就开始搜索自己
			if(currentNum<maxNum&&affectGroup==TypeSkill.AffectGroup_Self||affectGroup==TypeSkill.AffectGroup_Freind||affectGroup==TypeSkill.AffectGroup_FreindRole)
			{
				arr.push(_heroView.roleDyVo.dyId);
			}
			return arr;
		}
		/**  得到园内的角色   非死亡角色
		 * @param radius   圆的半径
		 * @param mapX    圆心坐标
		 * @param mapY   圆心坐标
		 * @param maxNum 最大个数
		 * selectPlayer 当前鼠标选中的  角色  如何 不为空  则 这个角色一定会出现在数组列表里 否则不一定出现在数组列表里
		 * @return 
		 */		
		public function getCircleRoles2(radius:Number,mapX:int,mapY:int,maxNum:int,selectPlayer:PlayerView,affectGroup:int):Array
		{
			return getCircleRoles3(radius,mapX,mapY,maxNum,isCanFightPlayer,selectPlayer,affectGroup);
		}
		
		 
		/**得到圆内 死亡的角色
		 *  用于复活技能
		 */ 
		public function getCircleDeadRoles(radius:Number,mapX:int,mapY:int,maxNum:int,affectGroup:int):Array
		{
			return getCircleRoles3(radius,mapX,mapY,maxNum,isDeadRolePlayer,null,TypeSkill.AffectGroup_All);
		}
		private function isDeadRolePlayer(player:PlayerView,affect_group:int=-1):Boolean
		{
			if(!player.isDispose&&player!=_heroView)
			{
				if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Player||player.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
				{
					if(player.isDead) return true;
				}
			}
			return false;
		}
		
		/**  得到园内的角色
		 * @param radius   圆的半径
		 * @param mapX    圆心坐标
		 * @param mapY   圆心坐标
		 * @param maxNum 最大个数
		 * selectFunc 选择函数
		 * selectPlayer 当前鼠标选中的  角色  如何 不为空  则 这个角色一定会出现在数组列表里 否则不一定出现在数组列表里
		 * affectGroup 其值在TypeRole.AffectGroup_
		 * @return 
		 */		
		private function getCircleRoles3(radius:Number,mapX:int,mapY:int,maxNum:int,selectFunc:Function,selectPlayer:PlayerView,affectGroup:int):Array
		{
			var rangeLeft:int=mapX-radius;
			var rangleTop:int=mapY-radius;
			var rangeRight:int=mapX+radius;
			var rangeBottom:int=mapY+radius;
			var _rangeStartPt:Point=AbsAnimatorView.getFlashPt(rangeLeft,rangleTop);
			var _rangeEndPt:Point=AbsAnimatorView.getFlashPt(rangeRight,rangeBottom);
			var _checkArr:Array=SceneZoneManager.Instance.getZoneArr(_rangeStartPt.x,_rangeStartPt.y,_rangeEndPt.x,_rangeEndPt.y);
			var arr:Array=[];
			var distance:Number;
			var dyId:uint;
			var currentLen:int=0;
			
			if(isCanFightPlayer(selectPlayer,affectGroup))
			{
				if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(selectPlayer.roleDyVo,affectGroup))
				{
					if(currentLen<maxNum)
					{
						if(selectFunc(selectPlayer,affectGroup))
						{
							distance=Math.sqrt(Math.pow((mapX-selectPlayer.roleDyVo.mapX),2)+Math.pow((mapY-selectPlayer.roleDyVo.mapY),2));
							if(distance<=radius)  
							{
								dyId=selectPlayer.roleDyVo.dyId;
								if(selectPlayer.roleDyVo.bigCatergory!=TypeRole.BigCategory_Pet)
								{
									arr.push(dyId);
									currentLen++;
								}
								else ///为宠物
								{
									if(!PetDyManager.Instance.hasPet(dyId))
									{
										arr.push(dyId);
										currentLen++;
									}
								}
							}
						}
					}
				}
			}

			for each(var role:PlayerView in _checkArr)
			{
				if(isCanFightPlayer(role,affectGroup))
				{
					if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(role.roleDyVo,affectGroup))
					{
						if(currentLen<maxNum)
						{
							if(selectFunc(role,affectGroup))
							{
								if(selectPlayer==null||selectPlayer!=role)  
								{
									distance=Math.sqrt(Math.pow((mapX-role.roleDyVo.mapX),2)+Math.pow((mapY-role.roleDyVo.mapY),2));
									if(distance<=radius)  
									{
										dyId=role.roleDyVo.dyId;
										if(role.roleDyVo.bigCatergory!=TypeRole.BigCategory_Pet)
										{
											arr.push(dyId);
											currentLen++;
										}
										else ///为宠物
										{
											if(!PetDyManager.Instance.hasPet(dyId))
											{
												arr.push(dyId);
												currentLen++;
											}
										}
									}
								}
							}
						}
						else break;
					}
				}
			}
			
			//如果  打不到条件  并且为队友 就开始搜索自己
			if(currentLen<maxNum&&affectGroup==TypeSkill.AffectGroup_Self||affectGroup==TypeSkill.AffectGroup_Freind||affectGroup==TypeSkill.AffectGroup_FreindRole)
			{
				arr.push(_heroView.roleDyVo.dyId);
			}
			
			return arr;
		}
		
		
		/**得到三条直线上的角色
		 * 
		 * pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *   上面那条直线 再加上左右各偏移30度角度 组成的另外两条直线
		 */ 
//		public function getThreeLineRoles(mouseX:int,mouseY:int,len:int):Array
//		{
//			///主角位置
//			var centerPt:Point=_heroView.getCenter();
//			var offsetDegree:int=30;//和主要直线的 （heroview，mouseX，mouseY） 之间的偏移角度    左右各一条直线进行检查
//			////根据 mouseX mouseY   以及 主角的坐标 算出他们直线上向左 向右 偏移30度角的终点
//			var lineDegree:Number=YFMath.getDegree(centerPt.x,centerPt.y,mouseX,mouseY);
//			///得到左右两条直线上的角度
//			var leftLineDegree:Number=lineDegree-offsetDegree;
//			var leftLineEndPt:Point=YFMath.getLinePoint4(centerPt.x,centerPt.y,len,leftLineDegree);
//			var rightLineDegree:Number=lineDegree+offsetDegree;
//			var rightLineEndPt:Point=YFMath.getLinePoint4(centerPt.x,centerPt.y,len,rightLineDegree);
//			var dict:Dictionary=new Dictionary(); 
//			///获取数据
//			getLineRoles2(centerPt.x,centerPt.y,mouseX,mouseY,len,dict)
//			getLineRoles2(centerPt.x,centerPt.y,leftLineEndPt.x,leftLineEndPt.y,len,dict)
//			getLineRoles2(centerPt.x,centerPt.y,rightLineEndPt.x,rightLineEndPt.y,len,dict)
//			return YFUtil.DictToArr(dict);
//		}
		/**得到某条线上的角色  mouseX  是目标点 
		 *  pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *  实际检测的位置 是从 pivotX,pivotY点 到 直线上len长度点的位置 该段区域内的角色全部被检测到  
		 * endPt 是可选参数  表示实际上最终会到达的位置
		 *  maxNum  最大数量  获取的最大玩家数量
		 * affectGroup 的值  在 TypeSkill
		 * lineHalfWidth线条半宽
		 */ 
		public function getLineRoles(mouseX:int,mouseY:int,len:int,lineHalfWidth:int,endPt:Point,maxNum:int,affectGroup:int):Array
		{
			var centerPt:Point=_heroView.getCenter();
			return getLineRoles2(centerPt.x,centerPt.y,mouseX,mouseY,len,lineHalfWidth,null,endPt,maxNum,affectGroup);
		}	
		
		
		
		
		/**得到某条线上的角色
		 *  pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 * halfWidth 是线的半宽度
		 *  实际检测的位置 是从 pivotX,pivotY点 到 直线上len长度点的位置 该段区域内的角色全部被检测到  
		 * dict  是可选参数,当dict不为null 最终得到的数据会保存在 dict里面  一份
		 * endPt 是可选参数 当endPt不为null   最终得到的数据endX,endY 会保留一份在endPt里面
		 * maxNum  最大数量  获取的最大玩家数量
		 * affectGroup 的值  在 TypeSkill
		 */ 
//		private function getLineRoles3(pivotX:int,pivotY:int,mouseX:int,mouseY:int,len:int,halfWidth:int,dict:Dictionary=null,endPt:Point=null,maxNum:int=10000,affectGroup:int=10):Array
//		{
//			
//		}

		
		/**得到某条线上的角色
		 *  pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *  实际检测的位置 是从 pivotX,pivotY点 到 直线上len长度点的位置 该段区域内的角色全部被检测到  
		 * dict  是可选参数,当dict不为null 最终得到的数据会保存在 dict里面  一份
		 * endPt 是可选参数 当endPt不为null   最终得到的数据endX,endY 会保留一份在endPt里面
		 * maxNum  最大数量  获取的最大玩家数量
		 * affectGroup 的值  在 TypeSkill
		 * lineHalfWidth 线条的半宽
		 */ 
		private function getLineRoles2(pivotX:int,pivotY:int,mouseX:int,mouseY:int,len:int,lineHalfWidth:int,dict:Dictionary=null,endPt:Point=null,maxNum:int=10000,affectGroup:int=10):Array
		{
			var k:Number = (pivotY - mouseY+0.001) / (pivotX - mouseX+0.001);
			var rad:Number = Math.atan(k);
			if (mouseX<=pivotX)
			{
				rad +=  Math.PI;
			}
			var endX:Number = pivotX + len * Math.cos(rad);
			var endY:Number = pivotY + len * Math.sin(rad);
			if(endPt)  ///进行赋值  供函数外部使用 
			{
				endPt.x=endX;
				endPt.y=endY;
			}
				
			var boundRect:Rectangle=new Rectangle();
			boundRect.topLeft = new Point(pivotX,pivotY);
			boundRect.bottomRight = new Point(endX,endY);
			var left:Number = boundRect.left;
			var right:Number = boundRect.right;
			var top:Number = boundRect.top;
			var bottom:Number = boundRect.bottom;
			if (boundRect.width < 0)
			{
				if (boundRect.height > 0)
				{
					boundRect.topLeft = new Point(right,top);
					boundRect.bottomRight = new Point(left,bottom);
				}
				else
				{
					boundRect.topLeft = new Point(right,bottom);
					boundRect.bottomRight = new Point(left,top);
				}
			}
			else
			{
				if (boundRect.height < 0)
				{
					boundRect.topLeft = new Point(left,bottom);
					boundRect.bottomRight = new Point(right,top);
				}
			}
			
			///获取检测区域  四叉树优化::
			var myStartPt:Point=AbsAnimatorView.getFlashPt(boundRect.left,boundRect.top);
			var myEndPt:Point=AbsAnimatorView.getFlashPt(boundRect.right,boundRect.bottom);
			
			var _checkArr:Array=SceneZoneManager.Instance.getZoneArr(myStartPt.x,myStartPt.y,myEndPt.x,myEndPt.y);
			
			//被检测到的对象动态id 数组
			var rolesArr:Array=[];
			var L1:Number;
			var L2:Number;
			var L3:Number;
			var L4:Number;
			//  检测角色的矩形
			var rect:Rectangle; 
		//	var dyId:String;
			var currentNum:int=0;
			for each (var checkTarget:PlayerView in _checkArr)  //检测所有的角色
			{
				if(currentNum<maxNum)
				{
					if(checkTarget!=_heroView&&!checkTarget.isDispose)
					{
						if(isCanFightPlayer(checkTarget,affectGroup))
						{
							if(RoleDyManager.Instance.checkSkillAffectGroupCanFire(checkTarget.roleDyVo,affectGroup))
							{
//								rect= checkTarget.getClothBound(); ////边界 检测
								rect= checkTarget.getClothBound2(lineHalfWidth); ////边界 检测
								if (boundRect.intersects(rect))
								{
									L1=rect.top-pivotY-k*(rect.left-pivotX);
									L2=rect.bottom-pivotY-k*(rect.right-pivotX);
									L3=rect.top-pivotY-k*(rect.right-pivotX);
									L4=rect.bottom-pivotY-k*(rect.left-pivotX);
									if (L1*L2<=0||L3*L4<=0)
									{
										if(checkTarget.roleDyVo.bigCatergory!=TypeRole.BigCategory_Pet)
										{
											if(checkTarget.roleDyVo.dyId)	
											{
												rolesArr.push(checkTarget.roleDyVo.dyId);
												if(dict)dict[checkTarget.roleDyVo.dyId]=checkTarget.roleDyVo.dyId;
												++currentNum;
											}
										}
										else ///宠物
										{
											if(!PetDyManager.Instance.hasPet(checkTarget.roleDyVo.dyId))  //不为自己的宠物时
											{
												if(checkTarget.roleDyVo.dyId)	
												{
													rolesArr.push(checkTarget.roleDyVo.dyId);
													if(dict)dict[checkTarget.roleDyVo.dyId]=checkTarget.roleDyVo.dyId;
													++currentNum;
												}
											}
										}
									}
								}
								
							}
						}
					}
				}
				else  break;
			}
			//如果  打不到条件  并且为队友 就开始搜索自己
			if(currentNum<maxNum&&affectGroup==TypeSkill.AffectGroup_Self||affectGroup==TypeSkill.AffectGroup_Freind||affectGroup==TypeSkill.AffectGroup_FreindRole)
			{
				rolesArr.push(_heroView.roleDyVo.dyId);
			}
			return rolesArr;
		}
		
		
		/**角色是否可用
		 */ 
		public function isUsablePlayer(player:PlayerView):Boolean
		{
			if(player)
			{
			//	if(player.isDispose==false&&player.isDead==false) return true;
				if(player.isDispose==false)
				{
					if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)  //怪物死亡不可用
					{
						if(player.isDead==true) return false;
					}
					return true;
				}
				
			}
			return false;
		}
		/**没有释放内存的 玩家
		 */		
		public function isCanUsePlayer(player:PlayerView):Boolean
		{
			if(player)
			{
				if(player.isDispose==false) return true;
			}
			return false;
		}

		/**能否攻击的对象
		 */		
		public function isCanFightPlayer(playerView:PlayerView,affect_group:int=1):Boolean
		{
			if(playerView)
			{
				if(playerView.isDispose==false&&playerView.isDead==false&&playerView !=_heroView)
				{
					
					if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId!=-1) ///处于切磋状态
					{
						if(RoleDyVo(playerView.roleDyVo).competeId==DataCenter.Instance.roleSelfVo.roleDyVo.competeId) return true;
					}
					if( RoleDyManager.Instance.canFight(RoleDyVo(playerView.roleDyVo),DataCenter.Instance.roleSelfVo.pkMode,affect_group)) // TypeRole.CanFightAll(playerView.roleDyVo,pkMode);
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**更新系统设置
		 */		
		public function updateSystemConfig():void
		{
			for each(var player:PlayerView in _totalViewDict)
			{
				if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_Player||player.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet||player.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods)
				{
					player.updateSystemConfig();
				}
			}
		}
	}
}