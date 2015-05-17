package com.YFFramework.core.world.movie.player
{
	/**  2012-6-27
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.map.rectMap.findPath.Node;
	import com.YFFramework.core.map.rectMap.findPath.TypeRoad;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dMovieClip;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.movie.face.IMoving;
	import com.YFFramework.core.world.movie.player.optimize.SceneZoneManager;
	import com.YFFramework.core.world.movie.player.optimize.ZonePlayer;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.display.DisplayObjectContainer2D;
	
	/** 
	 * 该类不能直接初始化 
	 * 容器动画播放器 内部可以嵌套 其他BitmapMovieClip     非容器播放器是 BuildingEffectView    他 是直接继承BitmapMovieClip
	 */ 
	public class AbsAnimatorView extends ZonePlayer implements IMoving
	{
		/**身体部位的宽高
		 */		
		public static const ClothWidth:int=50;
		
		public static const ClothHeight:int=100;
		//角色动态数据类型
		protected var _roleDyVo:MonsterDyVo;
		
		/** 坐标  真实坐标 注意  roleDyVO里面的坐标 是 该坐标的取整  在进行移动时 用_mapX _mapY 进行计算然后进行取整
		 * _mapX _mapY  只是用作移动计算  最后的呈现是 取整 通过roleDyVo呈现整形坐标
		 */		
		public var _mapX:Number;
		/**地图坐标 x y 
		 */		
		public var _mapY:Number;
		
		/** 武器套装
		 */
		protected var _cloth:YF2dMovieClip;
		
		protected var _tweenSimple:TweenSimple;
		
		protected var _teenBezier:TweenBezier;
		/**正在播放的动作  因为  数据没有加载完成 所以需要在加载完成时自动播放
		 */		
		protected var _activeAction:int;
		/**正在播放的方向
		 */
		protected var _activeDirection:int;
		
		/**检测该点是否为消隐点  人物行走路径时 需要
		 */
		protected var _checkAlphaTilePt:Point;
		/**检测该点是否为消隐点  人物行走路径时 需要
		 */
		protected var _checkNode:Node;

		
		public function AbsAnimatorView(roleDyVo:MonsterDyVo=null)
		{
			_roleDyVo=roleDyVo;
			if(!_roleDyVo) initRoleDyVo();
			_mapX=_roleDyVo.mapX;
			_mapY=_roleDyVo.mapY;
			_activeDirection=-1;
			_activeAction=-1;
			super();
		}
		
		protected function initRoleDyVo():void
		{
			_roleDyVo=new MonsterDyVo();	
		}
		override protected function initUI():void
		{
			super.initUI();
			initEquipment();
			_tweenSimple=new TweenSimple();//PoolCenter.Instance.getFromPool(TweenSimple) as TweenSimple;//new TweenSimple();
			_teenBezier=new TweenBezier();
		}
		
		/**初始化各个装备部分  body     weapon    wing  等
		 */
		protected function initEquipment():void
		{
			_cloth=new YF2dMovieClip();
			_cloth.start();
			resetSkin();
			addChild(_cloth);
		}
		/**重置皮肤为默认状态
		 */		
		public function resetSkin():void
		{
			_cloth.setBitmapFrame(CommonFla.RoleFakeSkin,CommonFla.RoleFakeSkin.flashTexture,CommonFla.RoleFakeSkin.atlasData);////设置  默认皮肤
			_cloth.initData(null);
			_cloth.playTweenStop();
		}
		override protected function addEvents():void
		{
			// TODO Auto Generated method stub
			super.addEvents();
			adjustToHero();
		}
		
		override protected function removeEvents():void
		{
			// TODO Auto Generated method stub
			super.removeEvents();
			removeAdjustToHero();
		}
		/**调整坐标 相对主角
		 */		
		protected function adjustToHero():void
		{
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMove,updatePostion);
		}
		protected function removeAdjustToHero():void
		{
			YFEventCenter.Instance.removeEventListener(MapScenceEvent.HeroMove,updatePostion);	
			
		}
		
		
		/** 给body赋值
		 */
		public function updateCloth(actionData:YF2dActionData):void
		{
			_cloth.initData(actionData);
		}
		
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;

			if(_cloth.actionData)
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		
		public function stopPlay():void
		{
			_cloth.stop();
		}
		public function startPlay():void
		{
			_cloth.start();
		}
		/**  移动 行走 前进
		 */		
		public function moveTo(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false,breakFunc:Function=null,breakParam:Object=null):void
		{
		//	var _time:Number=getTimer();
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var direction:int=DirectionUtil.getDirection(_roleDyVo.mapX,_roleDyVo.mapY,mapX,mapY);
			play(TypeAction.Walk,direction);
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updateMoveTo,new Point(mapX,mapY),forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		//	print(this,"monsterMove耗时::",getTimer()-_time);
		}
		
		/** 推拉  对人物进行推拉滑动 反方向的滑动  和blinkMoveTo类似 只是 人物站立的方向是反方向
		 *调用该方法后  当完成后强行终止后    需要调用 startPlay 来开启动画播放功能 
		 *  他 的通讯 和blinkMove的通讯类似  只有  目标怪物   宠物 主角才会产生通讯  该通讯并不会有返回 仅是告诉服务端 该 活动对象的最新位置
		 * direction  是人物站立 滑动的方向
		 */ 
		public function backSlideMoveTo(mapX:int,mapY:int,direction:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false,breakFunc:Function=null,breakParam:Object=null):void
		{
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var copyDirectionObj:Object=TypeDirection.getCopyDirection(direction); ////镜像方向
			gotoAndStop(TypeAction.Stand,copyDirectionObj.direction,1);///停留第二帧
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePureMove,new Point(mapX,mapY),forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		}
		
		public  function gotoAndStop(action:int,direction:int,frameIndex:int):void
		{
			_activeAction=action;
			_activeDirection=direction;
			if(_cloth.actionData)_cloth.gotoAndStop(frameIndex,action,direction);
		//	_cloth.scaleX=scaleX;
		}

		
		/**单纯的进行移动  不包含动作的播放
		 */ 	
		public function pureMoveTo(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false,breakFunc:Function=null,breakParam:Object=null):void
		{
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePureMove,new Point(mapX,mapY),forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		}
		
		/** 纯粹移动更新 不包含动作的播放
		 */		
		protected function updatePureMove(obj:Object):void
		{
			updatePostion();
			checkAlphaPoint();
		}
		protected function updateMoveTo(obj:Object):void
		{
			var pt:Point=Point(obj);
			updatePostion();
			updatePathDirection(pt);
		}
		
		
//		protected function updateBackMoveTo(obj:Object):void
//		{
//			var pt:Point=Point(obj);
//			updatePostion();
//		}
		
		/**
		 * @param path路径 
		 * @param speed
		 * @param completeFunc
		 * @param completeParam
		 * @param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置  
		 * 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		 *  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true
		 */		
		public function sMoveTo(path:Array,speed:Number=5,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			_teenBezier.to(this,"_mapX","_mapY",path,speed,updateDatePath,completeFunc,completeParam,forceUpdate);
		}
		/**跳转到该位置
		 */ 
		public function skipTo(mapX:int,mapY:int):void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			setMapXY(mapX,mapY);
			play(TypeAction.Stand,_activeDirection);
		}
		
		/** 更新路径移动速度
		 */
		public function updateMovePathSpeed(speed:Number):void
		{
			_teenBezier.updateSpeed(speed);
		}
		
		/**停止移动 
		 */
		public function stopMove():void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			play(TypeAction.Stand);
		}
		/**停止  移动
		 */ 
		public function pureStop():void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
		}

		
		/** 路径行走更新
		 */
		protected function updateDatePath(data:Object):void
		{
			var obj:Point=Point(data);
			updatePathDirection(obj);
			updatePostion();
		}
		/**  人物在路径上行走时方向 的变化
		 */		
		protected function updatePathDirection(obj:Point):void
		{
			if(_mapX!=obj.x||_mapY!=obj.y)  ///当不为最后一个  排除走到位置的触发s
			{
				var direction:int=DirectionUtil.getDirection(_mapX,_mapY,obj.x,obj.y);
				if(_activeDirection!=direction||_activeAction!=TypeAction.Walk) 
				{
					play(TypeAction.Walk,direction);	
				}
			}
			checkAlphaPoint();
		}
		
	
		/**检测当前点是否为消隐点  改变角色透明度
		 */		
		public function checkAlphaPoint():void
		{
			_checkAlphaTilePt=RectMapUtil.getTilePosition(_roleDyVo.mapX,_roleDyVo.mapY);
			_checkNode=GridData.Instance.getNode(_checkAlphaTilePt.x,_checkAlphaTilePt.y);
			if(_checkNode)
			{
				if(_checkNode.id==TypeRoad.AlphaWalk)	this.alpha=TypeRoad.AlphaColor;    /////判断消隐点
				else alpha=TypeRoad.AlphaNormal;
			}
		}
		protected function updatePostion(e:YFEvent=null):void
		{
			_roleDyVo.mapX=int(_mapX);
			_roleDyVo.mapY=int(_mapY);
			x =CameraProxy.Instance.x+_roleDyVo.mapX-CameraProxy.Instance.mapX;
			y=CameraProxy.Instance.y+_roleDyVo.mapY-CameraProxy.Instance.mapY;
		}
		
		public function setMapXY(mapX:int,mapY:int):void
		{
//			_roleDyVo.mapX=mapX;
//			_roleDyVo.mapY=mapY;
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}
		
		
		/**默认播放
		 */
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			if(YF2dActionData.isUsableActionData(_cloth.actionData))
			{
				var action:int=_cloth.actionData.getActionArr()[0];
				var direction:int=_cloth.actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		/**得到身体部位区域  在flash坐标下
		 */ 
		public  function getClothBound2():Rectangle
		{
		//	return new Rectangle(x-25,y-100,50,100);
		//	return _cloth.getBounds(parent);
			
			var offesetY:int=-10;
		//	print(this,"_cloth.scaleX",_cloth.scaleX);
		//	Draw.DrawRectLine(graphics,-ClothWidth*0.5,-ClothHeight+offesetY,ClothWidth,ClothHeight,0xFF0000)
			return new  Rectangle(x-ClothWidth*0.5,y-ClothHeight+offesetY,ClothWidth,ClothHeight);
		}
		
		/**在世界地图下的身体部位区域
		 */ 
		public  function getClothBound():Rectangle
		{
			//	return new Rectangle(x-25,y-100,50,100);
			//	return _cloth.getBounds(parent);
			
			var offesetY:int=-10;
			//	print(this,"_cloth.scaleX",_cloth.scaleX);
			//	Draw.DrawRectLine(graphics,-ClothWidth*0.5,-ClothHeight+offesetY,ClothWidth,ClothHeight,0xFF0000)
			var pt:Point=getMapPt(x-ClothWidth*0.5,y-ClothHeight+offesetY);
		//	return new  Rectangle(x-ClothWidth*0.5,y-ClothHeight+offesetY,ClothWidth,ClothHeight);
			return new  Rectangle(pt.x,pt.y,ClothWidth,ClothHeight);
		}
		
		/**获取中心位置点  flash坐下系下
		 */		
		public function getCenter2():Point
		{
			return new Point(x+_cloth.x*_cloth.scaleX+ClothWidth*0.5,y+_cloth.y+ClothHeight*0.5);
		}
		/**获取中心位置点  地图坐标系下
		 */		
		public function getCenter():Point
		{
			var tx:int=x+_cloth.x*_cloth.scaleX;
			var ty:int=y+_cloth.y-ClothHeight*0.5;
			return getMapPt(tx,ty);
		}
		/** flash坐标转化为 地图坐标
		 */		
		public static function getMapPt(tx:int,ty:int):Point
		{
			tx=tx-CameraProxy.Instance.x+CameraProxy.Instance.mapX;
			ty=ty-CameraProxy.Instance.y+CameraProxy.Instance.mapY
			return new Point(tx,ty);
		}
		/**地图坐标转化为flash坐标
		 * @param mapX
		 * @param mapY
		 * @return
		 */	
		public static function getFlashPt(mapX:int,mapY:int):Point
		{
			var px:int=mapX+CameraProxy.Instance.x-CameraProxy.Instance.mapX;
			var py:int=mapY+CameraProxy.Instance.y-CameraProxy.Instance.mapY;
			return new Point(px,py);
		}
		
		
		
		
		/**启动body的播放
		 */
//		public function startBody():void
//		{
//			_cloth.start();
//		}
//		
//		/**停止body播放
//		 */
//		public function stopBody():void
//		{
//			_cloth.stop();
//		}
		
		
		/**得到当前方向
		 */
		public function get activeDirection():int
		{
			return _activeDirection;
		}
		
		public function set roleDyVo(roleDyVo:MonsterDyVo):void
		{
			_roleDyVo=roleDyVo;
			_mapX=roleDyVo.mapX;
			_mapY=roleDyVo.mapY;
		}
		
		public function get roleDyVo():MonsterDyVo
		{
			return _roleDyVo;
		}
		/**人物死亡时  人物慢慢变小
		 */		
		public function tweenSmall(complete:Function,params:Array,time:Number=0.5):void
		{
			TweenLite.to(_cloth,time,{scaleX:0.001,scaleY:0.001,onComplete:complete,onCompleteParams:params});
		}
		/**  更新世界坐标  该方法的触发必须在世界 地图BgMapVo  存在 且主角HeroPlayerView设置调用了updateWorldPositon才能触发  有效
		 */
		public function updateWorldPosition():void
		{
			setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		}
		
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return _cloth.getIntersect(parentPt,parentContainer);
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_cloth=null;
		//	if(_tweenSimple)_tweenSimple.disposeToPool();
			if(_tweenSimple)_tweenSimple.dispose();
			_tweenSimple=null;
			if(_teenBezier)	_teenBezier.dispose();
			_teenBezier=null;
			_roleDyVo=null;
			_checkAlphaTilePt=null;
			_checkNode=null;
		}

		
		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			SceneZoneManager.Instance.delPlayer(this);
			_checkAlphaTilePt=null;
			_checkNode=null;
			_roleDyVo=null;
			_activeDirection=-1;
			_activeAction=-1;
			_mapX=0;
			_mapY=0;
			scaleX=1;
			scaleY=1;
			_cloth.scaleX=1;
			_cloth.scaleY=1;
			_tweenSimple.stop();
			_teenBezier.destroy();
			_cloth.stop();
			_cloth.initData(null);
			removeEvents();
		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
//			SceneZoneManager.Instance.regPlayer(this);
			_isPool=false;
			_roleDyVo=MonsterDyVo(roleDyVo);
			if(!_roleDyVo) initRoleDyVo();
			_mapX=_roleDyVo.mapX;
			_mapY=_roleDyVo.mapY;
			addEvents();
			_cloth.start();
			return this;
		}
		/**得到皮肤的宽   高
		 */		
		public function getSkinSize():Point
		{
			var pt:Point=new Point();
			if(_cloth.actionData)
			{
				var actionArr:Array=_cloth.actionData.getActionArr();
				var dirArr:Array=_cloth.actionData.getDirectionArr(actionArr[0]);
				var movieData:MovieData=_cloth.actionData.getDirectionData(actionArr[0],dirArr[0]);
				var bitmapFrameData:BitmapFrameData=movieData.dataArr[0];
				pt.x=bitmapFrameData.rect.width;
				pt.y=bitmapFrameData.rect.height;	
				
			}
			else 
			{
				pt.x=55;
				pt.y=110;
			}
			return pt;
		}
		
		
		override public function set x(value:Number):void
		{
			super.x=value;
			if(!isPool)SceneZoneManager.Instance.updatePlayerZone(this);
		}
		override public function set y(value:Number):void
		{
			super.y=value;
			if(!isPool)SceneZoneManager.Instance.updatePlayerZone(this);
		}
		
	}
}