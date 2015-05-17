package com.YFFramework.game.core.module.mapScence.view
{
	/**@author yefeng
	 *2012-4-22上午11:34:55
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.ResSimpleTexture;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.YFUtil;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.ResTexureChache;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.EquipCategory;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.AbsAnimatorView;
	import com.YFFramework.core.world.movie.player.DropGoodsPlayer;
	import com.YFFramework.core.world.movie.player.HeroPlayerView;
	import com.YFFramework.core.world.movie.player.HeroPositionProxy;
	import com.YFFramework.core.world.movie.player.MonsterView;
	import com.YFFramework.core.world.movie.player.NPCPlayer;
	import com.YFFramework.core.world.movie.player.PetPlayerView;
	import com.YFFramework.core.world.movie.player.PlayerView;
	import com.YFFramework.core.world.movie.player.RolePlayerView;
	import com.YFFramework.core.world.movie.player.optimize.SceneZoneManager;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.MountBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.YFFramework.game.core.global.model.MountBasicVo;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.model.RoleReviveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.MonsterStopMoveResultVo;
	import com.YFFramework.game.core.module.npc.manager.NPCBasicManager;
	import com.YFFramework.game.core.module.npc.model.NPCBasicVo;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
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
		private var _npcDict:Dictionary;
		
		private var _heroView:HeroPlayerView;
		/** 当第一次加载地图时 需要进行每个角色的alpha值检测 是否处于消隐点上
		 */		
		private var _checkAlphaPointArr:Array; 
		
		
		/**角色的显示范围
		 */
		private var _roleShowPort:Rectangle;
		public function ScenceRolesView()
		{
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
			_checkAlphaPointArr=[];
			_roleShowPort=new Rectangle();
			initRoleShowPort();
			ResizeManager.Instance.regFunc(initRoleShowPort);
			
			_roleViewDict=new Dictionary();
			_roleViewArr=new Vector.<PlayerView>();
			_totalViewDict=new Dictionary();
			_monsterViewDict=new Dictionary();
			_npcDict=new Dictionary();
			_dropGoodsDict=new Dictionary();
		}

		
		protected function addEvents():void
		{
			///进行深度排序 和  舞台对象的配置 
			UpdateManager.Instance.frame9.regFunc(arrangeDeepth);
			///管理角色的显示与删除 
			UpdateManager.Instance.frame21.regFunc(arrangeRoleListView);
			////管理怪物说话 
			UpdateManager.Instance.frame301.regFunc(arrangeMonsterSayWords);
			///管理npc 说话
			UpdateManager.Instance.frame301.regFunc(arrangeNPCSayWords);
			
			//震动屏幕
			
			///主角血量少 屏幕显示 
			//	LayerManager.HpTipsLayer.hide();
			YFEventCenter.Instance.addEventListener(HeroPlayerView.HpTisHide,onHeroEvent);
			YFEventCenter.Instance.addEventListener(HeroPlayerView.HpTisShow,onHeroEvent);
			/////怪物死亡 删除角色
			YFEventCenter.Instance.addEventListener(MapScenceEvent.DeleteDeadMonster,onDeletePlayer);

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
			_roleViewDict=new Dictionary();
			_roleViewArr=new Vector.<PlayerView>();
		//	_totalViewDict=new Dictionary();
			_monsterViewDict=new Dictionary();
			_npcDict=new Dictionary();
			_dropGoodsDict=new Dictionary();
			SceneZoneManager.Instance.clear();
			
//			if(DataCenter.Instance.roleSelfVo.roleDyVo)
//			{
//				_totalViewDict[DataCenter.Instance.roleSelfVo.roleDyVo.dyId]=_heroView;
//			}
		}
		
		/**释放当前场景  主角不释放 其他角色都释放
		 */
		private function disposeCurrentMapScence():void
		{
			for each (var player:PlayerView in _totalViewDict)
			{
				if(isUsablePlayer(player))
				{
					if(player.roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)  ///当不是当前角色时
					{
						if(LayerManager.PlayerLayer.contains(player))	LayerManager.PlayerLayer.removeChild(player);
						player.disposeToPool();
					}
				}

//				if(player.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)
//				{
//					delete _totalViewDict[player.roleDyVo.dyId];
//					delete _npcDict[player.roleDyVo.dyId];
//					if(LayerManager.PlayerLayer.contains(player))	LayerManager.PlayerLayer.removeChild(player);
//					player.disposeToPool();
//				}
			}
		}

		/**添加角色
		 * isBirth表示是否为怪物出生 ，为怪物出生时需要加上出生怪物的特效
		 */		
		public function addRole(roleDyVo:MonsterDyVo,isBirth:Boolean=false):void
		{
//			if(roleDyVo.dyId==null) throw new Error("id为空..");
//			if(!_totalViewDict[roleDyVo.dyId]) 
//			{
//				print(this,"添加monster...:"+roleDyVo.dyId);
				var playerView:PlayerView=createRoleView(roleDyVo,isBirth);
				_totalViewDict[roleDyVo.dyId]=playerView;
				if(roleDyVo.bigCatergory!=TypeRole.BigCategory_GropGoods)	playerView.play(TypeAction.Stand,TypeDirection.Right);
				else playerView.playDefault();//掉落物品
				checkAlphaPoint(playerView); ///消隐点设置
				addPlayer(playerView);
//			}
//			else 
//			{
//				print(this,"重复添加?"+roleDyVo.dyId);
////				throw new Error("重复添加?"+roleDyVo.dyId);
//			}
		}
		
		/** 添加 npc 
		 */		
		private function addNPC(npcData:Object):void
		{
			var roleDyVo:MonsterDyVo=new MonsterDyVo();
			var url:String=URLTool.getMapNPC(npcData.url);
			roleDyVo.dyId=npcData.id;
			roleDyVo.basicId=npcData.id;
			roleDyVo.mapX=npcData.x;
			roleDyVo.mapY=npcData.y;
			roleDyVo.bigCatergory=TypeRole.BigCategory_NPC;
			var npcBasicVo:NPCBasicVo=NPCBasicManager.Instance.getNPCBasicVo(roleDyVo.basicId);
			roleDyVo.roleName=npcBasicVo.name;
			var playerView:NPCPlayer=createRoleView(roleDyVo,false) as NPCPlayer;
			var mapId:int=DataCenter.Instance.getMapId();
			_totalViewDict[roleDyVo.dyId]=playerView;
			///将npc 添加进 RoleDyManager里面
			RoleDyManager.Instance.addRole(roleDyVo);

		//	playerView.playDefault();
			checkAlphaPoint(playerView); ///消隐点设置
			addPlayer(playerView);
			///更新皮肤 
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
		//	if(SourceCache.Instance.getRes(url,mapId)) playerView.updateCloth(SourceCache.Instance.getRes(url,mapId) as ActionData);
			if(actionData) playerView.updateCloth(actionData);
			else 
			{
			//	SourceCache.Instance.addEventListener(url,onMonsterSkinLoaded);
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
			//	SourceCache.Instance.loadRes(url,{player:playerView,type:EquipCategory.Cloth,mapId:mapId},mapId);  ///加载武器
				SourceCache.Instance.loadRes(url,{player:playerView,type:EquipCategory.Cloth},mapId);  ///加载武器
			}
		}
		
		/**处理npc 配置文件
		 * npcObj npc 配置文件 object
		 */		
		public function handleNPCConfig(npcObj:Object):void
		{
			//导入 npc 
			var npcData:Object;
			var id:String;
			var url:String;	
			for ( id in npcObj)
			{
				npcData=npcObj[id];
				npcData.id=int(id);
				addNPC(npcData);
			}
		}

		
		/**原地复活角色
		 *  复活血量 exp 等
		 */		
		public function updateReviveRole(roleRevive:RoleReviveVo):void
		{
			var player:PlayerView=_totalViewDict[roleRevive.dyId] as PlayerView;
			player.roleDyVo.hp=roleRevive.hp;
			player.play(TypeAction.Stand);
			player.updateHp();
			player.isDead=false;
			if(roleRevive.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)	DataCenter.Instance.roleSelfVo.heroState.isLock=false;
		}
		
		/**  更新玩家的血量  当值为0 时  玩家 播放死亡的最后一帧 也就是倒在地上的动作
		 * 
		 */ 
		public function updateHp(dyId:uint):void
		{
			var player:PlayerView=totalViewDict[dyId] as PlayerView;
			player.updateHp();
			if(player.roleDyVo.hp<=0)
			{
				player.stayDead();
			}
		}
		/**添加角色列表
		 */		
		public function addRoleList(list:Array):void
		{
			///重新创建所有的角色对象
			var playerView:PlayerView;
			for each (var roleDyVo:RoleDyVo in list)
			{
//				if(roleDyVo.dyId==null) throw new Error("id为空..");
				if(_totalViewDict[roleDyVo.dyId]) 
				{
					print(this,"重复添加????"+roleDyVo.dyId);
//					throw new Error("重复添加?"+roleDyVo.dyId);
					continue;
				}
	///			print(this,"添2加::"+roleDyVo.dyId);
				
				playerView=createRoleView(roleDyVo,false);
				_totalViewDict[roleDyVo.dyId]=playerView;
				playerView.play(TypeAction.Stand,TypeDirection.Right);
				checkAlphaPoint(playerView); ///消隐点设置
				addPlayer(playerView);
			}
		}
		
		/**玩家消隐点检测
		 */		
		private function checkAlphaPoint(player:PlayerView):void
		{
			if(MapScenceView._mapConfigLoadComplete)player.checkAlphaPoint();
			else _checkAlphaPointArr.push(player);
		}
		/**检测需要进行透明设置的玩家
		 */		
		public function checkNeededPlayerAlphaPoint():void
		{
			for each(var player:PlayerView in _checkAlphaPointArr)
			{
				if(!player.isPool) player.checkAlphaPoint();
			}
			_checkAlphaPointArr=[];
		}
			
		/**删除角色
		 */		
		public function delRole(roleId:uint):void
		{
			//如果存在于 场景中 则进行处理
		//	var dyId:int=roleDyvo.dyId;
//			if(!_totalViewDict[roleId]) 
//			{
//				throw new Error("删除的角色不存在:"+roleId);
//			}
//			if(roleId==null) throw new Error("id为空..");
			deleteRoleView(roleId);
//			print(this,"删除角色:"+roleId);
		}
		/**创建主角色
		 */		
		public function createHero():void
		{
			var vo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			_heroView=PoolCenter.Instance.getFromPool(HeroPlayerView,vo) as HeroPlayerView;//new HeroPlayerView(vo);
			_totalViewDict[vo.dyId]=_heroView;
			_heroView.play(TypeAction.Stand,TypeDirection.Down);
			checkAlphaPoint(_heroView); ///消隐点设置检测其是否站在消隐点上
			addPlayer(_heroView);
		}

		/**  人物显示的范围 只有在这个范围内才能显示     用于管理当前角色 在场景中的显示   用于 arrangeRoleListView；
		 */
		private function initRoleShowPort():void
		{
			_roleShowPort.width=StageProxy.Instance.viewRect.width+100;
			_roleShowPort.height=StageProxy.Instance.viewRect.height+100;//+BgMapScrollport.HeroHeight;
			_roleShowPort.y=(BgMapScrollport.HeroHeight>>1)-50;
			_roleShowPort.x=-50;
		}
		/**  整理角色列表视图    当不在场景大小范围内的角色会被移除舞台     每秒执行 1次来维护这个 角色列表   30帧帧执行一次
		 */
		private function arrangeRoleListView():void
		{
			///对 所有的角色玩家    服务端返回的角色列表进行处理  
			for each (var roleView:PlayerView in _totalViewDict)
			{
				if(isUsablePlayer(roleView))
				{
					if(_roleShowPort.contains(roleView.x,roleView.y)) //在可视范围内
					{  //当不在显示列表中时 将其显示出来
						if(!_roleViewDict[roleView.roleDyVo.dyId])
						{
							addPlayer(roleView);
						}
					}
					else  //不在可视范围内    
					{ //当前假如在显示列表中 则将其 移除去
						if(_roleViewDict[roleView.roleDyVo.dyId])
						{	//不为自己 
							if(roleView!=_heroView)	removePlayer(roleView.roleDyVo.dyId);
						}
					}
				}
			}
		}
		
		
		
		
		/** 添加角色进场景
		 */
		private function addPlayer(roleView:PlayerView):void
		{
			LayerManager.PlayerLayer.addChild(roleView);
			_roleViewDict[roleView.roleDyVo.dyId]=roleView;
			_roleViewArr.push(roleView);
		}
		
		
		/**  深度排序  依赖 roleViewArr数组      每 7 帧执行一次
		 */
		private function arrangeDeepth():void
		{
			//按照 y坐标进行深度排序
			_roleViewArr=_roleViewArr.sort(sortFunc);
			//开始开始设置深度
			var index:int=0;
			for each (var playerView:PlayerView in _roleViewArr)
			{
				if(LayerManager.PlayerLayer.getChildIndex(playerView)!=index) 		
					LayerManager.PlayerLayer.setChildIndex(playerView,index);
				++index;
			}
			
		}
		
		private function sortFunc(x:PlayerView,y:PlayerView):int
		{
//			var xPt:Point=x.mousePt;
//			var yPt:Point=y.mousePt;
//			if(xPt.y>=yPt.y+1) return -1;   ///  +1  是为了防止深度排序随机化
//			return 1;
			var xPt:Number=x.y;
			var yPt:Number=y.y;
			if(xPt<=yPt) return -1;   ///  +1  是为了防止深度排序随机化
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
			var npcView:NPCPlayer;
			var npcPlayer:NPCPlayer;
			var npcBasicVo:NPCBasicVo;
			for each (npcPlayer in _npcDict)
			{
				npcBasicVo=NPCBasicManager.Instance.getNPCBasicVo(npcPlayer.roleDyVo.basicId);
				if(npcBasicVo.canSay())  /// npc能进行说话
				{
					npcPlayer.say(npcBasicVo.getWord());
				}
			}
		}

		
		 
		
		/**  创建角色 显示对象
		 * isBirth  是否为怪物出生 怪物出生时需要加上怪物出生特效
		 */		
		private function createRoleView(roleVo:MonsterDyVo,isBirth:Boolean):PlayerView
		{
			var view:PlayerView;
			switch(roleVo.bigCatergory)
			{
				//玩家
				case TypeRole.BigCategory_Player:
					//其他玩家
					///对象池创建
					view=PoolCenter.Instance.getFromPool(RolePlayerView,roleVo) as PlayerView;
					break;
				//怪物
				case TypeRole.BigCategory_Monster:
					///对象池创建
					view=PoolCenter.Instance.getFromPool(MonsterView,roleVo)  as MonsterView;
					if(isBirth)  ///为怪物出生加上怪物特效
					{
						var monsterBirthUrl:String=CommonEffectURLManager.MonsterBirthURL;
						var effectData:YF2dActionData=SourceCache.Instance.getRes(monsterBirthUrl) as YF2dActionData;
				//		print(this,"怪物出生");
						if(effectData)view.addFrontEffect(effectData,[0]);
						else SourceCache.Instance.loadRes(monsterBirthUrl,null);
					}
					////  怪物说话处理
					if(!_monsterViewDict[roleVo.basicId]) _monsterViewDict[roleVo.basicId]=new Dictionary();
					_monsterViewDict[roleVo.basicId][roleVo.dyId]=view;
					break;
				case TypeRole.BigCategory_Pet: ///宠物
					view=PoolCenter.Instance.getFromPool(PetPlayerView,roleVo)  as PetPlayerView;
					break;
				//// npc 
				case TypeRole.BigCategory_NPC:
					view=PoolCenter.Instance.getFromPool(NPCPlayer,roleVo) as NPCPlayer;
					////npc说话
					_npcDict[roleVo.basicId]=view;
					break;
				case TypeRole.BigCategory_GropGoods:
					///掉落物品
					view=PoolCenter.Instance.getFromPool(DropGoodsPlayer,roleVo) as DropGoodsPlayer;
					//保持掉落物品  用于 人物按空格键快速拾取
					_dropGoodsDict[view.roleDyVo.dyId]=view;
					break;
			}
			view.updateHp();
			view.updateWorldPosition()
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
//				if(isUsablePlayer(playerView))
//				{		
					///如果为怪物  从怪物列表中那移除
					////删除该怪物
					if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
						if(_monsterViewDict[playerView.roleDyVo.basicId])
							delete _monsterViewDict[playerView.roleDyVo.basicId][playerView.roleDyVo.dyId];
//						if(MonsterView(playerView).isHasTarget()==true) ///当怪物没有死  并且具有目标对象时 则需要停止该怪物的移动
//						{ ///通知该怪物需要停止移动
//							noticeMonsterStopMove(playerView.roleDyVo.dyId);
//						}
					}
					//如果为掉落物品
					else if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_GropGoods)
					{
						_dropGoodsDict[playerView.roleDyVo.dyId]=null;
						delete _dropGoodsDict[playerView.roleDyVo.dyId];
					}
					_totalViewDict[dyId].disposeToPool();
				}
				///释放内存
//			}
			_totalViewDict[dyId]=null;
			delete _totalViewDict[dyId];
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
//			if(playerView)
//			{
			if(LayerManager.PlayerLayer.contains(playerView))LayerManager.PlayerLayer.removeChild(playerView);
			var index:int=_roleViewArr.indexOf(playerView);
			if(index!=-1)_roleViewArr.splice(index,1);
			delete _roleViewDict[dyId];
//			}
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
				url=URLTool.getDropGoodsIcon(equipBasicVo.icon_id);
			}   
			else if(type==TypeProps.ITEM_TYPE_PROPS)  ///为道具 
			{
				var propBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(basicId);
				url=URLTool.getDropGoodsIcon(propBasicVo.icon_id);
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
				player.initGoodsSkin(simpleTexture);
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
		
		/**  更新正常状态下的 衣服  playerId  角色动态id      equipBasicId 装备静态id 
		 * 为-1  的话 则是 默认皮肤
		 */		
		public function updateCloth(playerId:uint,equipBasicId:int=-1):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			var url:String;
			if(equipBasicId!=-1)
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
				var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
				url=URLTool.getCloth(modelId);
			}
			else   ///默认皮肤
			{
				url=URLTool.getCloth(TypeRole.getDefaultSkin(RoleDyVo(player.roleDyVo).sex,RoleDyVo(player.roleDyVo).career));
			}
			player.swapIndex(false);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateCloth(actionData);
			else 
			{
				player.resetSkin();
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth},exsitFlag);  ///加载衣服
			}
		}
		
		/** 更新正常状态下的武器     playerId  角色动态id      equipBasicId 装备静态id 
		 * equipBasicId 为  -1时  为拖去装备
		 */		
		public function updateWeapon(playerId:uint,equipBasicId:int):void
		{
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			if(equipBasicId!=-1)
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
				var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
				var url:String=URLTool.getWeapon(modelId);
				RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
				var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData) player.updateWeapon(actionData);
				else 
				{
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
					SourceCache.Instance.addEventListener(url,onActionDataLoaded);
					SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Weapon},exsitFlag);  ///加载武器
				}
			}
			else player.updateWeapon(null);
		}
		
		/** 更新 头部
		 * @param playerId
		 * @param equipBasicId
		 * @param sex
		 */		
		public function updateWing(playerId:uint,equipBasicId:int):void
		{
			print(this,"更新翅膀没做......");	
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
			var modelId:int=equipBasicVo.getModelId(RoleDyVo(player.roleDyVo).sex);
			var url:String=URLTool.getWing(modelId);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Normal;
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateWing(actionData);
			else 
			{
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Wing},exsitFlag);  ///加载武器
			}
		}
		/**更新翅膀
		 * @param playerId
		 * @param equipBasicId
		 * 
		 */		
//		public function updateWing(playerId:uint,equipBasicId:int):void
//		{
//			print(this,"更新翅膀没做......");	
//		}
//
//		/** 更新盾牌
//		 * @param playerId   玩家id 
//		 * @param equipBasicId
//		 */		
//		public function updateShield(playerId:uint,equipBasicId:int):void
//		{
//			print(this,"更新盾牌没做");	
//		}
		
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
			player.swapIndex(true);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Sit;
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateCloth(actionData);
			else 
			{
				player.resetSkin();
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth},exsitFlag);  ///加载武器
			}
			///播放打坐特效
			var effectAction:YF2dActionData=SourceCache.Instance.getRes(CommonEffectURLManager.SitEffectURL) as YF2dActionData;
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
			var effectAction:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			player.addFrontEffect(effectAction,[0],true);
		}
			
		
		/**更新人物打坐的
		 *   equipBasicId武器  的静态id 
		 */		
		public function updateSitWeapon(playerId:uint,equipBasicId:int,sex:int):void
		{
			print(this,"更新武器..........待做");
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			player.swapIndex(true);
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Sit;
			
			var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipBasicId);
			var modelId:int=equipBasicVo.getModelId(sex);
			if(modelId>0)
			{
				var url:String=URLTool.getSitWeapon(modelId);
				var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
				if(actionData) player.updateWeapon(actionData);
				else 
				{
					var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
					if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
					SourceCache.Instance.addEventListener(url,onActionDataLoaded);
					SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Weapon},exsitFlag);  ///加载武器
				}
			}
		}
		
		/**  更新坐骑衣服   playerId  角色动态id      equipBasicId 装备静态id 
		 */		
		public function updateMountCloth(playerId:uint,equipBasicId:int):void
		{
			print(this,"更新，待加....？？？？");

//			var equipBasicVo:EquipBasicVo=GoodsBasicManager.Instance.getEquipBasicVo(equipBasicId);
//			var skinVo:SkinVo=SkinManager.Instance.getSkinVo(equipBasicVo.resId);
			var url:String="";//URLTool.getMountCloth(skinVo.mountSkinId);
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Mount;
			player.swapIndex(true);
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateCloth(actionData);
			else 
			{
				player.resetSkin();
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth},exsitFlag);  ///加载武器
			}

		}
		/** 更新坐骑 ,将坐骑放到武器上    playerId  角色动态id      equipBasicId 装备静态id 
		 */		
		public function updateMount(playerId:uint,equipBasicId:int):void
		{
			var mountBasicVo:MountBasicVo=MountBasicManager.Instance.getMountBasicVo(equipBasicId);
			var url:String=URLTool.getMount(mountBasicVo.skinId);
			var player:RolePlayerView=_totalViewDict[playerId] as RolePlayerView;
			RoleDyVo(player.roleDyVo).state=TypeRole.State_Mount;
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateWeapon(actionData);
			else 
			{
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				if(playerId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId) exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Weapon},exsitFlag);  ///加载武器
			}
		}
		
		/**更新 怪物点皮肤
		 */ 
		public function updateMonsterClothSKin(playerId:uint,monsterBasicId:int):void
		{
			var monsterBasicVo:MonsterBasicVo=MonsterBasicManager.Instance.getMonsterBasicVo(monsterBasicId);
			var url:String=URLTool.getMonster(monsterBasicVo.model_id);
			var player:PlayerView=_totalViewDict[playerId] as PlayerView;
			var mapId:int=DataCenter.Instance.getMapId();
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
		//	if(SourceCache.Instance.getRes(url,mapId)) player.updateCloth(SourceCache.Instance.getRes(url,mapId) as ActionData);
			if(actionData)player.updateCloth(actionData);
			else 
			{
				player.resetSkin();
			//	SourceCache.Instance.addEventListener(url,onMonsterSkinLoaded);
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
			//	SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth,mapId:mapId},mapId);  ///加载武器
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth},mapId);  ///加载武器
			}
		}
		
		/**更新宠物皮肤
		 */ 
		public function updatePetClothSKin(playerId:uint,petbaiscId:int):void
		{
			var petConfigVo:PetBasicVo=PetBasicManager.Instance.getPetConfigVo(petbaiscId);
			var url:String=URLTool.getMonster(petConfigVo.model_id);
			var player:PlayerView=_totalViewDict[playerId] as PlayerView;
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			if(actionData) player.updateCloth(actionData);
			else 
			{
				player.resetSkin();
				var exsitFlag:Object=DataCenter.Instance.getMapId();  ///存储的位置  是永久存储 还是只是单场景存储
				///当为自己的宠物
				if(PetDyManager.Instance.getPetDyVo(playerId)!=null)exsitFlag=SourceCache.ExistAllScene;
				SourceCache.Instance.addEventListener(url,onActionDataLoaded);
				SourceCache.Instance.loadRes(url,{player:player,type:EquipCategory.Cloth},exsitFlag);  ///加载武器
			}

		}
		
		/**更新怪物的目标状态  设置怪物目标 
		 * dyId 怪物动态id 
		 * hastarget  目标状态 是否具有目标
		 */ 
//		public function setMonsterTarget(dyId:String):void
//		{
//			
//			var monsterView:MonsterView=_totalViewDict[dyId] as MonsterView;
//			if(monsterView)	monsterView.updateTarget(true);
//		}
		
		/**解除怪物目标
		 */ 
		public function  freeMonsterTarget(dyId:String):void
		{
			var monsterView:MonsterView=_totalViewDict[dyId] as MonsterView;
			if(monsterView)		monsterView.updateTarget(false);
			///叫怪物广播  怪物九宫格其他玩家停止移动
		}
		
		/**怪物停止移动   解除目标后 服务端告诉怪物停止移动
		 */ 
		public function updateMonsterStopMove(monsterStopMoveResultVo:MonsterStopMoveResultVo):void
		{
		//	var _time:Number=getTimer();
			var monsterView:MonsterView=_totalViewDict[monsterStopMoveResultVo.dyId] as MonsterView;
			////怪物的移动速度设置为6   理论值越大越好 因为越大 矫正的需要时间越小 最终所有玩家 的怪物都走到同一点  完成同步
			if(monsterView)monsterView.moveTo(monsterStopMoveResultVo.mapX,monsterStopMoveResultVo.mapY,6,monsterMoveComplete,monsterView);
			
		//	print(this,"怪物停止移动::,",getTimer()-_time);
		}
		/**玩家停止移动
		 */		
//		public function updatePlayerStopMove(dyId:String):void
//		{
//			var player:PlayerView=_totalViewDict[dyId];
//			player.stopMove();
//		}
		
		/**怪物停止移动   怪物移动结束
		 */ 
		private function monsterMoveComplete(obj:Object):void
		{
			var monsterView:MonsterView=obj as MonsterView;
			if(!monsterView.isPool)
			{
				monsterView.stopMove();
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
			var actionData:YF2dActionData=SourceCache.Instance.getRes(url) as YF2dActionData;
			for each (var obj:Object in data )
			{
				if(obj)
				{
					player=obj.player as PlayerView;
					if(!player.isPool)
					{
						switch(obj.type)
						{
							case EquipCategory.Weapon:
								RolePlayerView(player).updateWeapon(actionData);
								break;
							case EquipCategory.Cloth:
								player.updateCloth(actionData);
								break;
							case EquipCategory.Wing:  //头部模型
								RolePlayerView(player).updateWing(actionData);
								break;
						}
					}
				}
			}
		}
	
		/**寻找可以战斗的对象 自动挂机需要 
		 */		
		public function findCanFightPlayer():PlayerView
		{
			for each (var player:PlayerView in _roleViewDict)
			{
				if(isCanFightPlayer(player))
				{
					   return player;
				}
			}
			return null;
		}
		/**数学方法得到某个园内区域的角色id    相对于 主角的圆形区域内的角色
		 * radius 是半径
		 * maxNum  是获取的最大数量
		 */ 
		public function getCircleRoles(radius:Number,maxNum:int):Array
		{
			return getCircleRoles2(radius,_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY,maxNum);
		}
		/**获取主角站立方向的扇形内的玩家
		 * maxNum 玩家数目
		 */		
		public function getSectorRoles(radius:int,jiaodu:int,maxNum:int):Array
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
					if(isCanFightPlayer(role))  ///只有 人物  怪物  宠物    能进行攻击   npc 是不能进行攻击的
					{
//						if(role!=_heroView)
//						{
							var isInSector:Boolean=DirectionUtil.isInSector(_heroView.roleDyVo.mapX,_heroView.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5,HeroPositionProxy.direction,radius,jiaodu,role.roleDyVo.mapX,role.roleDyVo.mapY-BgMapScrollport.HeroHeight*0.5);
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
//						}
					}
				} 
				else break;
			}
			return arr;
		}
		/**  得到园内的角色
		 * @param radius   圆的半径
		 * @param mapX    圆心坐标
		 * @param mapY   圆心坐标
		 * @param maxNum 最大个数
		 * @return 
		 */		
		public function getCircleRoles2(radius:Number,mapX:int,mapY:int,maxNum:int):Array
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
			for each(var role:PlayerView in _checkArr)
			{
				if(currentLen<maxNum)
				{
					if(isCanFightPlayer(role))
					{
//						if(role!=_heroView)
//						{
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
//						}
					}
				}
				else break;
			}
			return arr;
		}
		
		/**得到三条直线上的角色
		 * 
		 * pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *   上面那条直线 再加上左右各偏移30度角度 组成的另外两条直线
		 */ 
		public function getThreeLineRoles(mouseX:int,mouseY:int,len:int):Array
		{
			///主角位置
			var centerPt:Point=_heroView.getCenter();
			var offsetDegree:int=30;//和主要直线的 （heroview，mouseX，mouseY） 之间的偏移角度    左右各一条直线进行检查
			////根据 mouseX mouseY   以及 主角的坐标 算出他们直线上向左 向右 偏移30度角的终点
			var lineDegree:Number=YFMath.getDegree(centerPt.x,centerPt.y,mouseX,mouseY);
			///得到左右两条直线上的角度
			var leftLineDegree:Number=lineDegree-offsetDegree;
			var leftLineEndPt:Point=YFMath.getLinePoint4(centerPt.x,centerPt.y,len,leftLineDegree);
			var rightLineDegree:Number=lineDegree+offsetDegree;
			var rightLineEndPt:Point=YFMath.getLinePoint4(centerPt.x,centerPt.y,len,rightLineDegree);
			var dict:Dictionary=new Dictionary(); 
			///获取数据
			getLineRoles2(centerPt.x,centerPt.y,mouseX,mouseY,len,dict)
			getLineRoles2(centerPt.x,centerPt.y,leftLineEndPt.x,leftLineEndPt.y,len,dict)
			getLineRoles2(centerPt.x,centerPt.y,rightLineEndPt.x,rightLineEndPt.y,len,dict)
			return YFUtil.DictToArr(dict);
		}
		/**得到某条线上的角色  mouseX  是目标点 
		 *  pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *  实际检测的位置 是从 pivotX,pivotY点 到 直线上len长度点的位置 该段区域内的角色全部被检测到  
		 * endPt 是可选参数  表示实际上最终会到达的位置
		 *  maxNum  最大数量  获取的最大玩家数量
		 */ 
		public function getLineRoles(mouseX:int,mouseY:int,len:int,endPt:Point=null,maxNum:int=10000):Array
		{
			var centerPt:Point=_heroView.getCenter();
			return getLineRoles2(centerPt.x,centerPt.y,mouseX,mouseY,len,null,endPt,maxNum);
		}	
		/**得到某条线上的角色
		 *  pivotX pivotY 是起始点  mouseX mouseY是这条线上的终点  len 是从起始位置开始在这条线上该长度的位置
		 *  实际检测的位置 是从 pivotX,pivotY点 到 直线上len长度点的位置 该段区域内的角色全部被检测到  
		 * dict  是可选参数,当dict不为null 最终得到的数据会保存在 dict里面  一份
		 * endPt 是可选参数 当endPt不为null   最终得到的数据endX,endY 会保留一份在endPt里面
		 * maxNum  最大数量  获取的最大玩家数量
		 */ 
		private function getLineRoles2(pivotX:int,pivotY:int,mouseX:int,mouseY:int,len:int,dict:Dictionary=null,endPt:Point=null,maxNum:int=10000):Array
		{
			var k:Number = (pivotY - mouseY) / (pivotX - mouseX);
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
					if(checkTarget!=_heroView&&!checkTarget.isPool)
					{
						if(isCanFightPlayer(checkTarget))
						{
							rect= checkTarget.getClothBound(); ////边界 检测
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
				else  break;
			}
			return rolesArr;
		}
		
		
		/**角色是否可用
		 */ 
		public function isUsablePlayer(player:PlayerView):Boolean
		{
			if(player)
			{
				if(player.isPool==false&&player.isDead==false) return true;
			}
			return false;
		}
		/**能否攻击的对象
		 */		
		public function isCanFightPlayer(playerView:PlayerView,pkMode:int=1):Boolean
		{
			if(playerView)
			{
				if(playerView.isPool==false&&playerView.isDead==false&&playerView !=_heroView)
				{
					if(playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster||playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Player||playerView.roleDyVo.bigCatergory==TypeRole.BigCategory_Pet)
					{
						if(pkMode==TypeRole.PKMode_1)  ///只能攻击怪物
						{
							if(playerView.roleDyVo.bigCatergory!=TypeRole.BigCategory_Player) return true; 
						}
						     
					}
				}
			}
			return false;
		}
		
		
		/**获取某个范围内 的掉落物品
		 *   圆形检测 
		 */ 
		public function getDropGoodsIDArr(circle:int):Array
		{
			var dropGoodsArr:Array=[];
			var distance:Number;
			for each(var dropGoodsView:DropGoodsPlayer in _dropGoodsDict)
			{
				if(isUsablePlayer(dropGoodsView))
				{
					distance=YFMath.distance(dropGoodsView.roleDyVo.mapX,dropGoodsView.roleDyVo.mapY,heroView.roleDyVo.mapX,heroView.roleDyVo.mapY);
					if(distance<=circle) //可以拾取物品
					{
						dropGoodsArr.push(dropGoodsView.roleDyVo.dyId);
					}
				}
			}
			return dropGoodsArr;
		}
		
		
		
	}
}