package com.YFFramework.core.world.movie.player
{
	/**  2012-6-27
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.pool.AbsUIPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.movie.face.IMoving;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/** 
	 * 该类不能直接初始化 
	 * 容器动画播放器 内部可以嵌套 其他BitmapMovieClip     非容器播放器是 BuildingEffectView    他 是直接继承BitmapMovieClip
	 */ 
	public class AbsAnimatorView extends AbsUIPool implements IMoving
	{
		//角色动态数据类型
		protected var _roleDyVo:RoleDyVo; 
		
		/** 武器套装
		 */
		protected var _cloth:BitmapMovieClip;
		
		protected var _tweenSimple:TweenSimple;
		
		protected var _teenBezier:TweenBezier;
		/**正在播放的动作  因为  数据没有加载完成 所以需要在加载完成时自动播放
		 */		
		protected var _activeAction:int;
		/**正在播放的方向
		 */
		protected var _activeDirection:int;
		
		public function AbsAnimatorView(roleDyVo:RoleDyVo=null)
		{
			_roleDyVo=roleDyVo;
			if(!_roleDyVo) _roleDyVo=new RoleDyVo();
			_activeDirection=-1;
			_activeAction=-1;
			super(false);
			mouseChildren=false;
		
		}
		override protected function initUI():void
		{
			super.initUI();
			initEquipment();
			_tweenSimple=PoolCenter.Instance.getFromPool(TweenSimple) as TweenSimple;//new TweenSimple();
			_teenBezier=new TweenBezier();
		}
		
		/**初始化各个装备部分  body     weapon    wing  等
		 */
		protected function initEquipment():void
		{
			_cloth=new BitmapMovieClip();
			_cloth.start();
			addChild(_cloth);
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
		public function updateCloth(actionData:ActionData):void
		{
			_cloth.initData(actionData);
		}
		
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(direction>5)
			{
				_cloth.scaleX=-1;
//				_body.updateScale(-1,1);
				switch(direction)
				{
					case TypeDirection.LeftDown:
						direction=TypeDirection.RightDown
						break;
					case TypeDirection.Left:
						direction=TypeDirection.Right;
						break;
					case TypeDirection.LeftUp:
						direction=TypeDirection.RightUp;
						break;
				}
			}
			else if(direction>0)
			{
				_cloth.scaleX=1;
			//	_body.updateScale(1,1);
			}
			if(_cloth.actionData)
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		public function moveTo(mapX:Number,mapY:Number,speed:Number=4,completeFunc:Function=null,completeParam:Object=null):void
		{
			var direction:int=DirectionUtil.getDirection(_roleDyVo.mapX,_roleDyVo.mapY,mapX,mapX);
			play(TypeAction.Walk,direction);
			_tweenSimple.tweenTo(_roleDyVo,"mapX","mapY",mapX,mapY,speed,completeFunc,completeParam,updatePostion);
			_tweenSimple.start();

		}
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
			_teenBezier.to(_roleDyVo,"mapX","mapY",path,speed,updateDatePath,completeFunc,completeParam,forceUpdate);
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
			if(_roleDyVo.mapX!=obj.x||_roleDyVo.mapY!=obj.y)  ///当不为最后一个  排除走到位置的触发s
			{
				var direction:int=DirectionUtil.getDirection(_roleDyVo.mapX,_roleDyVo.mapY,obj.x,obj.y);
				if(_activeDirection!=direction||_activeAction!=TypeAction.Walk) play(TypeAction.Walk,direction);	
			}
		}
		protected function updatePostion(e:YFEvent=null):void
		{
			x =HeroProxy.x+_roleDyVo.mapX-HeroProxy.mapX;
			y=HeroProxy.y+_roleDyVo.mapY-HeroProxy.mapY;
			
		}
		
		public function setMapXY(mapX:Number,mapY:Number):void
		{
			_roleDyVo.mapX=mapX;
			_roleDyVo.mapY=mapY;
			updatePostion();
		}
		
		
		/**默认播放
		 */
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=_cloth.actionData.getActionArr()[0];
			var direction:int=_cloth.actionData.getDirectionArr(action)[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
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
		
		public function set roleDyVo(roleDyVo:RoleDyVo):void
		{
			_roleDyVo=roleDyVo;
		}
		
		public function get roleDyVo():RoleDyVo
		{
			return _roleDyVo;
		}
		
		/**  更新世界坐标  该方法的触发必须在世界 地图BgMapVo  存在 且主角HeroPlayerView设置调用了updateWorldPositon才能触发  有效
		 */
		public function updateWorldPosition():void
		{
			setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		}
		
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer=null):Boolean
		{
			return _cloth.getIntersect(parentPt,parentContainer);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_cloth=null;
		//	_tweenSimple=null;
			PoolCenter.Instance.toPool(_tweenSimple);
			_roleDyVo=null;
			_teenBezier.dispose();
			_teenBezier=null;
		}

		
		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			_roleDyVo=null;
			_activeDirection=-1;
			_activeAction=-1;
			_tweenSimple.stop();
			_teenBezier.stop();
			_cloth.stop();
			_cloth.initData(null);
			removeEvents();
		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			_isPool=false;
			_roleDyVo=RoleDyVo(roleDyVo);
			if(!_roleDyVo) _roleDyVo=new RoleDyVo();
			addEvents();
			_cloth.start();
			return this;
		}
	}
}