package com.YFFramework.game.core.module.smallMap.view
{
	/**@author yefeng
	 * 2013 2013-5-31 下午4:14:07 
	 */
	import com.YFFramework.core.center.manager.update.QueenTimeOut;
	import com.YFFramework.core.center.manager.update.UpdateCore;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.controls.YFSmallMapMoveArrow;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapRoleVo;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapWorldVo;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskStateVO;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class SmallMapView extends AbsView
	{
		/**小地图的实际缩放
		 */		
		private var _mapScale:Number;
		/**小地图缩小系数为  10倍
		 */		
		public static var radio:Number=0.1;
		
		protected var _map:Bitmap;
		private var _mapContainer:AbsView;
		/**路径容器 存放人物行走的路径
		 */		
		protected var _pathContainer:AbsView;
		
		protected var _bgContainer:AbsView;
		
		/**角色列表容器
		 */		
		protected var _playerContainer:AbsView;
		/**保存角色ui列表  不包含 主角
		 */		
		protected var _playerDict:Dictionary;
		/**功能npc列表
		 */		
		protected var _funcNPCList:Dictionary;
		/**功能npc列表  其他 npc列表
		 */		
		protected var _otherNPCList:Dictionary;
		/**怪物区域list 
		 */		
		protected var _monsterZoneList:Dictionary;
		/**主角 对象 
		 */		
		protected var _heroMoveArrow:YFSmallMapMoveArrow;
		
		protected var _flyBoot:YFSmallMapIcon;
		/**4秒定时器
		 */		
		protected var _flyBootUpdateCore:UpdateCore;
		
		private static const  FlyBootWaitTime:int=3000;//4s
		
		/**窗口是否打开弹起  只有弹起时才进行响应
		 */		
		protected var _isPop:Boolean;
		
		private var _timer:Timer;
		
		/**地图id 
		 */		
		private var _mapId:int;
		/**是否为当前小地图
		 */		
		private var _isCurrentSmallMap:Boolean;
		 
		protected var _moveTime:Number=0;
		protected static  const MoveIntervalTime:int=200;
		
		
		/**坐标 tips 
		 */
		protected var _tips:SmallMapBgTip;
		
		/**是否为当前 小地图   true 表示为 当前玩家的场景的 小地图     false 表示世界地图
		 */		
		public function SmallMapView(currentSmallMap:Boolean=true)
		{
			_isCurrentSmallMap=currentSmallMap;
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_playerDict=new Dictionary();
			_funcNPCList=new Dictionary();
			_otherNPCList=new Dictionary();
			_monsterZoneList=new Dictionary();
			_bgContainer=new AbsView();
			addChild(_bgContainer);
			_map=new Bitmap();
			_mapContainer=new AbsView();
			_bgContainer.addChild(_mapContainer);
			_mapContainer.addChild(_map);
			_playerContainer=new AbsView();
			_bgContainer.addChild(_playerContainer);
			_pathContainer=new AbsView();
			_bgContainer.addChild(_pathContainer);
			_heroMoveArrow=new YFSmallMapMoveArrow();
			_bgContainer.addChild(_heroMoveArrow);
			_isPop=false;
			initTips();
			initFlyBoot();
			onHeroMove();
		}
		protected function initTips():void
		{
			_tips=new SmallMapBgTip();
			_tips.setTips(_mapContainer);
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_bgContainer.addEventListener(MouseEvent.CLICK,onMouseClick);
			_mapContainer.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			addFlyBootEvent();
			initTimer();
			if(_isCurrentSmallMap) //为当前地图时 需要更新坐标 
			{
				///更新怪物坐標
				YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapGetMovePath,onGloableEvent);   
				YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveForSmallMap,onHeroMove);//主角进行移动
				YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveComplete,onHeroMoveComplete); //主角已经移动完成
				
				///更新npc图标状态
				YFEventCenter.Instance.addEventListener(GlobalEvent.taskGetNowList,onNPCFlushState);
				///可接任务列表
				YFEventCenter.Instance.addEventListener(GlobalEvent.taskGetAbleList,onNPCFlushState);
				YFEventCenter.Instance.addEventListener(GlobalEvent.finishTaskOK,onNPCFlushState);
				YFEventCenter.Instance.addEventListener(GlobalEvent.giveUpTaskOK,onNPCFlushState);
				YFEventCenter.Instance.addEventListener(GlobalEvent.acceptTaskOK,onNPCFlushState);
				
			}
			else 
			{
				_bgContainer.removeChild(_heroMoveArrow);
			}
		}
		/** 处理npc的状态
		 */		
		private function onNPCFlushState(e:YFEvent=null):void
		{
			var taskStateVo:TaskStateVO;
			var npcPlayer:SmallMapPlayer;
			var npcTalkType:int;
			for each (npcPlayer in _funcNPCList)  /// 功能npc 
			{
				taskStateVo=TaskDyManager.getInstance().getNPCState(npcPlayer.smallMapRoleVo.basicId);
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
			
			for each (npcPlayer in _otherNPCList)   //其他npc 
			{
				taskStateVo=TaskDyManager.getInstance().getNPCState(npcPlayer.smallMapRoleVo.basicId);
				if(taskStateVo.vo)
				{
					npcPlayer.setState(taskStateVo.state,taskStateVo.vo.quality);
				}
				else npcPlayer.setState(taskStateVo.state,1);  //不存在
			}

		}
		
		private function initTimer():void
		{
			_timer=new Timer(3011);
			_timer.addEventListener(TimerEvent.TIMER,updatePosition);
			_timer.start();
		}
		
		private function removeTimer():void
		{
			_timer.removeEventListener(TimerEvent.TIMER,updatePosition);
			_timer.stop();
			_timer=null;
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			var smallmapPlayer:SmallMapPlayer=e.target as SmallMapPlayer;
			var pt:Point;
			if(smallmapPlayer)
			{
				switch(smallmapPlayer.smallMapRoleVo.bigCatergory)
				{
					case TypeRole.BigCategory_NPC:	//向NPC靠近
						closeToNPC(smallmapPlayer.smallMapRoleVo.dyId);
						break;
					case TypeRole.BigCategory_Transfer:  //传送点 
						pt=new Point(smallmapPlayer.smallMapRoleVo.mapX,smallmapPlayer.smallMapRoleVo.mapY);
						updateMoveToPt(pt,_mapId);
						break;
					case TypeRole.BigCategory_MonsterZone: //怪物区域
						updateMoveToMonsterZone(smallmapPlayer.smallMapRoleVo.dyId);
						break;
					default:   
						break;
				}
			}
			else  ///随机任何一点
			{
				onWalkPoint(_mapId);
			}
		}
		/**鼠标滑动      滚动地图不作任何处理
		 */		
		protected function onMouseMove(e:MouseEvent):void
		{
			var myPt:Point=getBigMapPoint();
			myPt=RectMapUtil.getTilePosition(myPt.x,myPt.y);
			var des:String=myPt.x+","+myPt.y;
			_tips.setText(des);
		}
		
		/**获得大地图的坐标  
		 */		
		private function getBigMapPoint():Point
		{
			return new Point(_map.mouseX*_map.scaleX/radio,_map.mouseY*_map.scaleY/radio);
		}
		/**走到目标点 
		 */		
		private function onWalkPoint(mapId:int):void
		{
			var pt:Point=getBigMapPoint();
			updateMoveToPt(pt,mapId);
			addFlyBoot();
		}
		/**添加
		 */		
		protected function addFlyBoot():void
		{
			if(!contains(_flyBoot)) addChild(_flyBoot);
			_flyBoot.x=_map.mouseX*_map.scaleX;
			_flyBoot.y=_map.mouseY*_map.scaleY;
			////FlyBootWaitTime 秒后小飞鞋消失
			_flyBootUpdateCore.start();
		}
		
		/**创建小飞鞋
		 */	
		protected function initFlyBoot():void
		{
			_flyBoot=new YFSmallMapIcon(6);	
			_flyBoot.buttonMode=true;
			_flyBoot.tooltip=Lang.SmallMap_ChuanSongZhiCi;
			_flyBootUpdateCore=new UpdateCore(FlyBootWaitTime,flyBootComplete);
		}
		/**给小飞鞋添加事件
		 */		
		protected function addFlyBootEvent():void
		{
			_flyBoot.addEventListener(MouseEvent.CLICK,onFlyFootEvent);
		}
		
		private function flyBootComplete(obj:Object=null):void
		{
			if(contains(_flyBoot)) removeChild(_flyBoot);
			_flyBootUpdateCore.stop();
		}
		
		
		private function onFlyFootEvent(e:MouseEvent):void
		{	
			var point:Point=new Point(int(_flyBoot.x/radio),int(_flyBoot.y/radio));
			//进行 飞鞋传送
			var flyBoot:FlyBootVo=new FlyBootVo();
			flyBoot.mapId=_mapId;
			flyBoot.mapX=point.x;
			flyBoot.mapY=point.y;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,flyBoot);
			flyBootComplete();
		}
		
		/**向npc靠近
		 * @param dyId  npc id
		 */		
		public function closeToNPC(dyId:uint):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToNPC,dyId);   /// 向npc靠近 场景模块 MapSceneView进行侦听处理
			
		}
		
		/**主角移动到某点
		 */		
		public function updateMoveToPt(pt:Point,sceneId:int):void
		{
			var smallMapWorldVo:SmallMapWorldVo=new SmallMapWorldVo();
			smallMapWorldVo.sceneId=sceneId;
			smallMapWorldVo.pos_x=pt.x;
			smallMapWorldVo.pos_y=pt.y;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToWorldPt,smallMapWorldVo);	
		}
		/** 主角移动到怪物区域
		 */		
		private function updateMoveToMonsterZone(npcPositionId:int):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToMonsterZone,npcPositionId);	
		}
		
		private function onGloableEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.SmallMapGetMovePath:
					if(_isPop) ///只有窗口弹起时才进行响应
					{
						var path:Array=e.param  as Array;
						drawPath(path);
					}
					break;
			}
		}
		/**主角移动完成 
		 */
		private function onHeroMoveComplete(e:YFEvent):void
		{
			removeAllPath();
		}
		/**主角进行移动
		 * 在smallmapScrollView中 对该方法 进行了重写
		 */		
		protected function onHeroMove(e:YFEvent=null):void
		{
			if(getTimer()-_moveTime>=MoveIntervalTime)
			{
				updateHeroMove();
				_moveTime=getTimer();
			}
		}
		
		protected function updateHeroMove():void
		{
			var mX:Number=HeroPositionProxy.mapX*radio;
			var mY:Number=HeroPositionProxy.mapY*radio;
			_heroMoveArrow.setPivotXY(mX,mY);
			_heroMoveArrow.direction=HeroPositionProxy.direction;
		}

	
		/** 画出路径
		 * path  人物行走路径  需要将其缩小 10倍再进行画出
		 */		
		protected function drawPath(path:Array):void
		{
			removeAllPath();
			var mX:int;
			var mY:int;
			var firstX:int=-10000;
			var firstY:int;
			var mypath:Array=path.concat();
			mypath.unshift(new Point(HeroPositionProxy.mapX,HeroPositionProxy.mapY));
			for each(var pt:Point in mypath)
			{
				mX=pt.x*radio;
				mY=pt.y*radio;
				drawCircle(mX,mY);
				if(firstX<-1000)
				{
					firstX=mX;
					firstY=mY;
					_pathContainer.graphics.moveTo(firstX,firstY);
				}
				else 
				{
					_pathContainer.graphics.lineStyle(1,0xFF0000);
					_pathContainer.graphics.lineTo(mX,mY);
				}
			}
			_pathContainer.graphics.endFill();
		}
		
		protected function drawCircle(px:int,py:int,radius:Number=0.5):void
		{
			var shape:Shape=new Shape();
			Draw.DrawCircle(shape.graphics,radius,px,py,0xFF0000);
			_pathContainer.addChild(shape);
		}
		/**删除路径点
		 */		
		protected function removeAllPath():void
		{
			_pathContainer.graphics.clear();
			var len:int=_pathContainer.numChildren;
			var shape:Shape;
			for(var i:int=0;i!=len;++i)
			{
				shape=_pathContainer.removeChildAt(0) as Shape;
				shape.graphics.clear();
			}
		}
		
		
		
		/**更新队友的位置  每隔三秒更新一次
		 */		
		protected function updatePosition(e:TimerEvent=null):void
		{
			if(_isPop)
			{
				for each(var view:SmallMapPlayer in _playerDict )
				{
//					if(view.smallMapRoleVo.bigCatergory==TypeRole.BigCategory_Player)  
//					{
//						if(TeamDyManager.Instance.containsMember(view.smallMapRoleVo.dyId)&&(view.smallMapRoleVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId))  //如果为队友 则进行更新
//						{
							view.updateMapPosition(radio);
//						}
//					}
				}
			}
		}
		/**更新 小地图
		 */		
		public function updateMapChangeConfig(mapId:int):void
		{
			_moveTime=0;
			_mapId=mapId;
			var mapSceneBasicVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(mapId);
			resetMap();
			var myScale:Number=DataCenter.getSmallMapMinHeight(mapId)/mapSceneBasicVo.height;;
			_mapScale=myScale*10; //地铁股原来就缩放了10倍
			_map.scaleX=_map.scaleY=_mapScale;
			radio=myScale;
			updateSmallMapNPCConfig(mapId);
			loadSmallPic(mapId);
			updateHeroMove();
		}
		/**通过NPC_position表创建npc   地图区域点  传送点
		 */		
		private function updateSmallMapNPCConfig(mapId:int):void
		{
			var arr:Array=Npc_PositionBasicManager.Instance.getMapMPCList(mapId);
			var view:SmallMapPlayer;
			var roleDyVo:SmallMapRoleVo;
			for each(var npc_positionBasicVo:Npc_PositionBasicVo in arr)
			{
				switch(npc_positionBasicVo.type)
				{
					case TypeRole.SmallMapShowType_FuncNPC:  ///当为  npc时 
					case TypeRole.SmallMapShowType_OtherNPC:
						if(npc_positionBasicVo.basic_id>0)///当为  npc时 
						{
							roleDyVo=new SmallMapRoleVo();
							roleDyVo.dyId=npc_positionBasicVo.npc_id;
							roleDyVo.basicId=npc_positionBasicVo.basic_id;
							roleDyVo.bigCatergory=TypeRole.BigCategory_NPC;
							roleDyVo.mapX=npc_positionBasicVo.pos_x;
							roleDyVo.mapY=npc_positionBasicVo.pos_y;
							roleDyVo.roleName=npc_positionBasicVo.small_map_des;
							
							view=new SmallMapPlayer(roleDyVo);
							_playerContainer.addChild(view);
							_playerDict[roleDyVo.dyId]=view;
							view.updateMapPosition(radio);
							///存入npc列表
							if(npc_positionBasicVo.type==TypeRole.SmallMapShowType_OtherNPC)	//其他npc 
							{
								_otherNPCList[roleDyVo.dyId]=view;
							}
							else if(npc_positionBasicVo.type==TypeRole.SmallMapShowType_FuncNPC)  //功能npc 
							{
								_funcNPCList[roleDyVo.dyId]=view;
							}
						}
						break;
					case TypeRole.SmallMapShowType_MonsterZone: //怪物区域
						roleDyVo=new SmallMapRoleVo();
						roleDyVo.dyId=npc_positionBasicVo.npc_id;
						roleDyVo.basicId=npc_positionBasicVo.basic_id;
						roleDyVo.bigCatergory=TypeRole.BigCategory_MonsterZone;
						roleDyVo.mapX=npc_positionBasicVo.pos_x;
						roleDyVo.mapY=npc_positionBasicVo.pos_y;
						roleDyVo.roleName=npc_positionBasicVo.small_map_des;
						view=new SmallMapPlayer(roleDyVo);
						_playerContainer.addChild(view);
						_playerDict[roleDyVo.dyId]=view;
						view.updateMapPosition(radio);
						_monsterZoneList[roleDyVo.dyId]=view;
						break;
					case TypeRole.SmallMapShowType_TransferPt: //传送点
						roleDyVo=new SmallMapRoleVo();
						roleDyVo.bigCatergory=TypeRole.BigCategory_Transfer;
						roleDyVo.roleName=npc_positionBasicVo.small_map_des;
						roleDyVo.mapX=npc_positionBasicVo.pos_x;
						roleDyVo.mapY=npc_positionBasicVo.pos_y;
						view=new SmallMapPlayer(roleDyVo);
						view.buttonMode=true;
						_playerContainer.addChild(view);
						view.updateMapPosition(radio);
						break;
				}
			}
			
		}
		/**添加主角   npc 
		 */ 
		public function addRole(roleDyVo:SmallMapRoleVo):void
		{
			var view:SmallMapPlayer;
			if(roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				if(!_playerDict[roleDyVo.dyId])
				{
					if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player||roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
//						if(TeamDyManager.Instance.containsMember(roleDyVo.dyId))
//						{
							view=new SmallMapPlayer(roleDyVo);
							_playerContainer.addChild(view);
							_playerDict[roleDyVo.dyId]=view;
							view.updateMapPosition(radio);
//						}
					} 
				}
			}
		}
		/**添加新的队友
		 */		
		public function addNewTeamPlayer(roleDyVo:SmallMapRoleVo):void
		{
			var view:SmallMapPlayer;
			if(roleDyVo.dyId!=DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				if(!_playerDict[roleDyVo.dyId])
				{
					view=new SmallMapPlayer(roleDyVo);
					_playerContainer.addChild(view);
					_playerDict[roleDyVo.dyId]=view;
					view.updateMapPosition(radio);
				}
			}
		}
		
		/**   删除角色
		 * @param dyId
		 */		
		public function delRole(dyId:int):void
		{
			var view:SmallMapPlayer=_playerDict[dyId];
			if(view)
			{
				delete _playerDict[dyId];
				///从npc列表删除
				if(view.smallMapRoleVo.bigCatergory==TypeRole.BigCategory_NPC)
				{
					delete _funcNPCList[dyId];
					delete _otherNPCList[dyId];
				}
				
				_playerContainer.removeChild(view);
				view.dispose();
			}
		}
	
		/**该窗口ui是否弹起来 
		 */		
		public function updatePop(value:Boolean):void
		{
			_isPop=value;	
		}
		
		/**重置地图场景
		 */		
		private function resetMap():void
		{
			_map.bitmapData=null;
			_map.scaleX=_map.scaleY=1;
			_playerContainer.removeAllContent(true);
			_playerDict=new Dictionary();
			_funcNPCList=new Dictionary();
			_otherNPCList=new Dictionary();
			_monsterZoneList=new Dictionary();
			removeAllPath();
		}
		private function loadSmallPic(mapId:int):void
		{
			var mapSceneBasicVo:MapSceneBasicVo=MapSceneBasicManager.Instance.getMapSceneBasicVo(mapId);
			var url:String=URLTool.getSmallMapImage(mapSceneBasicVo.resId);
//			var mapId:int=mapSceneBasicVo.mapId;
			var loader:IconLoader=new IconLoader();
			loader.loadCompleteCallback=thumbLoadComplete;
			loader.initData(url,null,mapId);
			
//			SourceCache.Instance.addEventListener(url,thumbLoadComplete);
//			var mapId:int=DataCenter.Instance.mapSceneBasicVo.mapId;
			
//			addEventListener(url,thumbLoadComplete);
//			SourceCache.Instance.loadRes(url,null,mapId,null,{dispatcher:this,data:mapId},false);
		}
//		private function thumbLoadComplete(e:ParamEvent):void
		private function thumbLoadComplete(bitmap:Bitmap,mapId:int):void
		{
//			var url:String=e.type;
//			var mapId:int=int(e.param);
//			removeEventListener(url,thumbLoadComplete);
//			var bitmapData:BitmapData=SourceCache.Instance.getRes2(url,mapId) as BitmapData;
//			_map.bitmapData=bitmapData;
			if(mapId==DataCenter.Instance.getMapId())
			{
				_map.bitmapData=bitmap.bitmapData;
			}
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			removeTimer();
			_map=null;
			_playerContainer=null;
			_playerDict=null;
			_funcNPCList=null;
			_otherNPCList=null;
			_pathContainer=null;
			_heroMoveArrow=null;
			_monsterZoneList=null;
			_flyBoot=null;
			if(_flyBootUpdateCore)_flyBootUpdateCore.dispose();
			_flyBootUpdateCore=null;
		}
		
		/**设置怪物区域	是否显示
		 */		
		public function setMonsterZoneVisible(mVisible:Boolean):void
		{
			for each(var view:SmallMapPlayer in _monsterZoneList)  //怪物区域列表
			{
				view.visible=mVisible;
			}
		}
		/**设置功能NPC是否可见 
		 */		
		public function setFuncNPCVisible(mVisible:Boolean):void
		{
			for each(var view:SmallMapPlayer in _funcNPCList)	///功能 npc列表
			{
				view.visible=mVisible;
			}

		}
		/**设置其他npc是否可见
		 */		
		public function setOtherNPCVisible(mVisible:Boolean):void
		{
			for each(var view:SmallMapPlayer in _otherNPCList)		//其他npc列表
			{
				view.visible=mVisible;
			}
		}
	}
}