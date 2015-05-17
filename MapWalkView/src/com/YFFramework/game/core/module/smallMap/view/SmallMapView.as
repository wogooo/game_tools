package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.center.manager.update.UpdateCore;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.YFSmallMapIcon;
	import com.YFFramework.core.ui.yfComponent.controls.YFSmallMapMoveArrow;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MapSceneBasicVo;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.HeroPositionProxy;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**小地图显示
	 * 缩小变为大地图的 十分之一?/
	 * 
	 * 2012-11-5 下午5:40:13
	 *@author yefeng
	 */
	public class SmallMapView extends AbsView
	{ 
		/**小地图缩小系数为  10倍
		 */		
		public static const radio:Number=0.1;
		
		protected var _map:Bitmap;
		/**路径容器 存放人物行走的路径
		 */		
		protected var _pathContainer:AbsView;
		
		protected var _bgContainer:AbsView;

		/**角色列表容器
		 */		
		protected var _playerContainer:AbsView;
		/**保存角色ui列表
		 */		
		protected var _playerDict:Dictionary;
		/**npc列表
		 */		
		protected var _npcList:Dictionary;
		
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
		public function SmallMapView()
		{
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_playerDict=new Dictionary();
			_npcList=new Dictionary();
			_bgContainer=new AbsView();
			addChild(_bgContainer);
			_map=new Bitmap();
			_bgContainer.addChild(_map);
			_playerContainer=new AbsView();
			_bgContainer.addChild(_playerContainer);
			_pathContainer=new AbsView();
			_bgContainer.addChild(_pathContainer);
			_heroMoveArrow=new YFSmallMapMoveArrow();
			_bgContainer.addChild(_heroMoveArrow);
			_isPop=false;
			
			initFlyBoot();
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_bgContainer.addEventListener(MouseEvent.CLICK,onMouseEvent);
			///更新怪物坐標
			UpdateManager.Instance.frame101.regFunc(updateMonsterPosition);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SmallMapGetMovePath,onGloableEvent);   
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveForSmallMap,onHeroMove);//主角进行移动
			
			addFlyBootEvent();
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			print(this,e.target);
			var smallmapPlayer:SmallMapPlayer=e.target as SmallMapPlayer;
			var pt:Point;
			if(smallmapPlayer)
			{
				if(smallmapPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)  ///向 npc靠近 
				{
				//	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToNPC,smallmapPlayer.roleDyVo.dyId);   /// 向npc靠近 场景模块 MapSceneView进行侦听处理
					closeToNPC(smallmapPlayer.roleDyVo.dyId);
				}
				else if(smallmapPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster) ///攻击怪物
				{
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToMonster,smallmapPlayer.roleDyVo.dyId);/// 向怪物靠近进行攻击 场景模块 MapSceneView进行侦听处理
				}
				///当为跳转点或者 怪物区域时
				else if(smallmapPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_SkipWay||smallmapPlayer.roleDyVo.bigCatergory==TypeRole.BigCategory_MonsterZone)
				{
					pt=new Point(smallmapPlayer.roleDyVo.mapX,smallmapPlayer.roleDyVo.mapY);
					updateMoveToPt(pt);
				}
				else 
				{
					pt=getBigMapPoint();
					updateMoveToPt(pt);
				}
			}
			else 
			{
				onWalkPoint();
			}
		}
		
		/**获得大地图的坐标 
		 */		
		private function getBigMapPoint():Point
		{
			return new Point(_map.mouseX/radio,_map.mouseY/radio);
		}
			
	
		
		/**走到目标点 
		 */		
		private function onWalkPoint():void
		{
			var pt:Point=getBigMapPoint();
			updateMoveToPt(pt);
			addFlyBoot();
		}
		/**添加
		 */		
		protected function addFlyBoot():void
		{
			if(!contains(_flyBoot)) addChild(_flyBoot);
			_flyBoot.x=_map.mouseX;
			_flyBoot.y=_map.mouseY;
			////FlyBootWaitTime 秒后小飞鞋消失
			_flyBootUpdateCore.start();
		}
		
		/**创建小飞鞋
		 */	
		protected function initFlyBoot():void
		{
			_flyBoot=new YFSmallMapIcon(6);	
			_flyBoot.buttonMode=true;
			_flyBoot.toolTip=Lang.SmallMap_ChuanSongZhiCi;
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
			noticeSkipToPoint(point);
			flyBootComplete();
		}
		
		/**瞬间跳到 pt 同场景的跳转
		 */		
		private function noticeSkipToPoint(pt:Point):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,pt);
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
		public function updateMoveToPt(pt:Point):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToPt,pt);	
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
		/**主角进行移动
		 */		
		protected function onHeroMove(e:YFEvent):void
		{
			if(_isPop) ///只有窗口弹起时才进行响应
			{
				updateHeroMove();
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
			for each(var pt:Point in path)
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
		
		
		
		/**更新怪物的位置  每隔三秒更新一次
		 */		
		protected function updateMonsterPosition():void
		{
			if(_isPop) ///只有窗口弹起时才进行响应
			{
				var canUpDate:Boolean=false;
				for each(var view:SmallMapPlayer in _playerDict )
				{
					if(view.roleDyVo.bigCatergory==TypeRole.BigCategory_Monster)
					{
						canUpDate=true;
					}
					else if(view.roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
					{
						canUpDate=DataCenter.Instance.roleSelfVo.teamPlayers.hasKey(view.roleDyVo.dyId);
					}
					if(canUpDate)
					{
						view.updateMapPosition(radio);
					}
				}
			}
		}
		
		
		/**更新地图 
		 */		
		public function updateMapChange():void
		{
			resetMap();
			loadSmallPic();
		}
		/**地图配置文件加载完成后进行更新
		 */		
		public function  updateMapConfig(xxObj:Object):void
		{
			///传送点 
			addTransferPt(xxObj);
			///怪物区域
			addMonsterZone(xxObj);			
			
		}
		/**添加主角   npc 以及怪物
		 */ 
		public function addRole(roleDyVo:MonsterDyVo):void
		{

			var view:SmallMapPlayer=new SmallMapPlayer(roleDyVo);
			_playerContainer.addChild(view);
			_playerDict[roleDyVo.dyId]=view;
			view.updateMapPosition(radio);
			
			///存入npc列表
			if(roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)
			{
				_npcList[roleDyVo.dyId]=view.roleDyVo;
			}
		}
		/**   删除角色
		 * @param dyId
		 */		
		public function delRole(dyId:String):void
		{
			var view:SmallMapPlayer=_playerDict[dyId];
			delete _playerDict[dyId];
			
			///从npc列表删除
			if(view.roleDyVo.bigCatergory==TypeRole.BigCategory_NPC)
			{
				delete _npcList[dyId];
			}

			_playerContainer.removeChild(view);
			view.dispose();
		}
		
		/**增加 传送点 
		 * xxObj  是地图配置文件信息 var skipArr:Array=xxObj.skip; //[{selfX,selfY,x,y,mapId,mapName}]  //selfX selfY 是传送点自己的坐标  x y mapId 是另一个地图的信息 mapName另一个地图的名称
		 */		
		public function  addTransferPt(xxObj:Object):void
		{
			var  skipArr:Array=xxObj.skip;
			var roleDyVo:MonsterDyVo;
			var view:SmallMapPlayer;
			for each(var obj:Object in skipArr)
			{
				roleDyVo=new MonsterDyVo();
				roleDyVo.bigCatergory=TypeRole.BigCategory_SkipWay;
				roleDyVo.roleName=obj.mapName;
				roleDyVo.mapX=obj.selfX;
				roleDyVo.mapY=obj.selfY;
				view=new SmallMapPlayer(roleDyVo);
				view.buttonMode=true;
				_playerContainer.addChild(view);
				view.updateMapPosition(radio);
			}
		}
		/** 添加怪物点区域 var monsterZoneArr:Array=xxObj.monsterZone;//[{name,x,y},{...},{...}]
		 */		
		public function addMonsterZone(xxObj:Object):void
		{
			var arr:Array=xxObj.monsterZone;
			var roleDyVo:MonsterDyVo;
			var view:SmallMapPlayer;
			for each(var obj:Object in arr)
			{
				roleDyVo=new MonsterDyVo();
				roleDyVo.bigCatergory=TypeRole.BigCategory_MonsterZone;
				roleDyVo.roleName=obj.name;
				roleDyVo.mapX=obj.x;
				roleDyVo.mapY=obj.y;
				view=new SmallMapPlayer(roleDyVo);
				_playerContainer.addChild(view);
				view.updateMapPosition(radio);
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
			_playerContainer.removeAllContent(true);
			_playerDict=new Dictionary();
			_npcList=new Dictionary();
			removeAllPath();
		}
		private function loadSmallPic():void
		{
			var mapSceneBasicVo:MapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
			var url:String=URLTool.getMapSmallImage(mapSceneBasicVo.resId);
			var mapId:int=mapSceneBasicVo.mapId;
//			SourceCache.Instance.addEventListener(url,picLoaded);
//			SourceCache.Instance.loadRes(url,mapId,mapId);
			var loader:IconLoader=new IconLoader();
			loader.loadCompleteCallback=picLoaded;
			loader.initData(url);
		}
//		private function picLoaded(e:ParamEvent):void
		private function picLoaded(bitmap:Bitmap,data:Object):void
		{
//			var url:String=e.type;
//			var mapId:int=int(Vector.<Object>(e.param)[0]);
//			SourceCache.Instance.removeEventListener(url,picLoaded);
//			var bitmapData:BitmapData=SourceCache.Instance.getRes2(url,mapId) as BitmapData;
//			_map.bitmapData=bitmapData;
			_map.bitmapData=bitmap.bitmapData;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_map=null;
			_playerContainer=null;
			_playerDict=null;
			_npcList=null;
			_pathContainer=null;
			_heroMoveArrow=null;
			_flyBoot=null;
			if(_flyBootUpdateCore)_flyBootUpdateCore.dispose();
			_flyBootUpdateCore=null;
				
		}
		/** 获取npc 列表
		 */		
		public function  get npcList():Dictionary
		{
			return _npcList;
		}

		
	}
}