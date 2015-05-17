package com.YFFramework.core.world.movie.player
{
	import com.YFFramework.core.center.pool.AbsUIPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.MonsterMoveVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.mapScence.model.BackSlideMoveVo;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 怪物 动画UI 具备  坐标反馈给服务端的功能
	 * 2012-8-28 上午9:55:24
	 *@author yefeng
	 */
	public class MonsterView extends PlayerView
	{
		
		/// 10帧通讯一次
		protected var _movingIndex:int=0;
		/**每走 10帧 通讯一次 更新下坐标
		 */ 
		private static const MovingLen:int=6;
		
		/**进行moveTo函数移动时的 行走索引
		 */ 
		protected var _moveToIndex:int=0;
		/**moveto内更新函数函数调用的 次数，当调用该次数后进行人物行走通讯
		 */		
		protected static const MoveToLen:int=2;

		
		
		/** 行走路径   一般发三个点   距离必须大于等于30
		 */		 
		protected var _movingPath:Array;


		/**是否具有目标
		 */		
		protected var _hasTarget:Boolean;
		/**怪物移动速度
		 */ 
		protected var _moveSpeed:int;
		/**  说话的总次数  用来比较怪物 该谁说话了
		 */		
		public var sayWordTimes:int;
		
		public function MonsterView(roleDyVo:MonsterDyVo=null)
		{
			super(roleDyVo);
			_hasTarget=false;
		}
		
		override public function sMoveTo(path:Array, speed:int=5, completeFunc:Function=null, completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_moveSpeed=speed;
			super.sMoveTo(path, speed, completeFunc, completeParam,forceUpdate);
		}
		
		/***推拉人物  通讯  
		 * direction  是人物站立 滑动的方向
		 */ 
		override public function backSlideMoveTo(mapX:int, mapY:int,direction:int, speed:int=4, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
		{
			if(_hasTarget) noticeBackSlideMove(mapX,mapY);
			super.backSlideMoveTo(mapX, mapY, direction,speed, completeFunc, completeParam, forceUpdate, breakFunc, breakParam);
		}
		
		
		/**通讯 角色的拉取或者退离
		 */ 
		private function noticeBackSlideMove(endMapX:int,endMapY:int):void
		{
			var backSlideMoveVo:BackSlideMoveVo=new BackSlideMoveVo();
			backSlideMoveVo.dyId=roleDyVo.dyId;
			backSlideMoveVo.mapX=roleDyVo.mapX;
			backSlideMoveVo.mapX=roleDyVo.mapY;
			backSlideMoveVo.endX=endMapX;
			backSlideMoveVo.endY=endMapY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_BackSlideMove,backSlideMoveVo);
		}
		
		/**
		 * @param data  下一个目标点 
		 */		 
		override protected function updateDatePath(data:Object):void
		{
			updatePostion();			
			updatePathDirection(Point(data));
			if(_hasTarget)
			{
				++_movingIndex;
				if(_movingIndex>=MovingLen)
				{
					_movingIndex=0;
					_movingPath=_teenBezier.getPlayPath();
					var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
					noticeMonsterMove(postion,_movingPath,_moveSpeed);
				}
			}
		}
		
		/**更新目标状态 具有目标 或者失去目标
		 */ 
		public function updateTarget(hasTarget:Boolean):void
		{
			_hasTarget=hasTarget;
		}
		/** 是否具有目标对象
		 */		
		public function isHasTarget():Boolean
		{
			return _hasTarget;
		}
		
		/**  移动 行走
		 */
		override public function moveTo(mapX:int, mapY:int, speed:int=4, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
		{
			// TODO Auto Generated method stub
			_moveSpeed=speed;
			super.moveTo(mapX, mapY, speed, completeFunc, completeParam, forceUpdate, breakFunc, breakParam);
		}
		/**  移动 行走  更新
		 */		
		override protected function updateMoveTo(obj:Object):void
		{
			super.updateMoveTo(obj);
			///移动进行通讯 
			if(_hasTarget)
			{
				++_moveToIndex;
				if(_moveToIndex>=MoveToLen)
				{
					_moveToIndex=0;
					_movingPath=[obj];
					var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
					noticeMonsterMove(postion,_movingPath,_moveSpeed);
				}
			}
		}
		

		/** 怪物发生移动  通知socket 
		 */		 
		private function noticeMonsterMove(position:Point,path:Array,speed:int):void
		{
			var playerMoveVo:MonsterMoveVo=PoolCenter.Instance.getFromPool(MonsterMoveVo) as MonsterMoveVo;
			playerMoveVo.path=path;
			playerMoveVo.dyId=roleDyVo.dyId;
			playerMoveVo.curentPostion=position;
			playerMoveVo.speed=speed;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_MonsterMoving,playerMoveVo);
		}
		
		////掉血效果
		override protected function addBloodTextFunc(obj:Object):void
		{
			var num:int=obj.num;
			var hpPercent:Number=obj.hpPercent;

			var numSkinId:int=TypeImageText.Num_Red;
			var ui:AbsUIPool=ImageTextManager.Instance.createNumWidthPre(num.toString(),numSkinId);
			LayerManager.FightTextLayer.addChild(ui);
			ui.x=x-ui.width*0.5;
			ui.y=y-100;
			TweenLite.to(ui,0.5,{y:ui.y-70,x:ui.x,ease:Back.easeOut,onComplete:completeFightText,onCompleteParams:[ui]});
			///扣血
			updateHp(hpPercent);
		}

		
		
		override public function reset():void
		{
			super.reset();
			_movingPath=null;
			_hasTarget=false;
			_movingIndex=0;
			sayWordTimes=0;
		}
		
		override public function constructor(roleDyVo:Object):IPool
		{
			super.constructor(roleDyVo);
			_hasTarget=false;
			return this;
		}
	}
}