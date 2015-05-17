package com.YFFramework.core.world.movie.player
{
	/**宠物UI类 场景中行走的对象
	 * @author yefeng
	 *2012-9-16下午9:28:12
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	
	import flash.geom.Point;
	
	
	public class PetPlayerView extends MonsterView
	{	
		
		
		/**移动时走到 距离人物50像素远的地方   也是 拉取宠物后距离人的位置
		 */ 
		public static const MinDistance:int=100;
		/**宠物和人之间的距离
		 */ 
		public static const Distance:int=150;
		
		/**拉取宠物的距离 当宠物离自己太远时拉取宠物
		 */ 
		public static const MaxDistance:int=500;

		
		
		
		/**宠物对象是否锁住了  宠物战斗时处于锁住状态 不能进行移动 
		 */ 
		public var isLock:Boolean;
		/**宠物移动结束后的方向
		 */ 
		private var _moveCompleteDirection:int;
		private static const MovingLen:int=10;
		/**是否发送了宠物拉取  ， 发送了宠物拉取协议 后   该值变为true  在成功拉取后 该值才变为false  等待下一次拉取
		 */		
		private var _isNoticePullPet:Boolean;
		public function PetPlayerView(roleDyVo:PetDyVo=null)
		{
			super(roleDyVo);
		//	_hasTarget=true;///目标对象为当前玩家   也就是主人 这样 就可以通过主人来进行通信
			isLock=false;
			_isNoticePullPet=false;
		}
		
		/**更新目标状态 具有目标 或者失去目标 
		 * _hasTarget 为 true表示是自己的宠物
		 */ 
		override public function updateTarget(hasTarget:Boolean):void
		{
			_hasTarget=hasTarget;
			mouseChildren=mouseEnabled=false;
		}
		
		/** 是否为当前玩家的宠物
		 */ 
		public function isOwnPet():Boolean
		{
			return _hasTarget;
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
				if(_movingIndex==MovingLen)
				{
					_movingIndex=0;
					_movingPath=_teenBezier.getPlayPath();
					var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
					noticePetMove(postion,_movingPath,_moveSpeed);
				}
				checkPullPet();
			}
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
					noticePetMove(postion,_movingPath,_moveSpeed);
				}
				
				///判断 宠物和主人之间的距离 大于一定的距离后则需要进行宠物拉取
				checkPullPet();
			}
		}
		
		/**检测拉取宠物
		 */ 		
		private function checkPullPet():void
		{
			///判断 宠物和主人之间的距离 大于一定的距离后则需要进行宠物拉取
			var distance:Number=YFMath.distance(HeroPositionProxy.mapX,HeroPositionProxy.mapY,roleDyVo.mapX,roleDyVo.mapY);
			if(distance>=MaxDistance&&_isNoticePullPet==false)
			{
//				print(this,"拉取宠物");
				var degree:Number=DirectionUtil.getDirectionDegree(HeroPositionProxy.direction);
				var endPoint:Point=YFMath.getLinePoint3(HeroPositionProxy.mapX,HeroPositionProxy.mapY,MinDistance,degree);
				//	endPoint为 地图坐标
				_isNoticePullPet=true;
				noticePullPet(endPoint.x,endPoint.y);
			}

		}
		/**更新拉取宠物 ，成功拉取宠物后 需要调用该方法 重置拉取状态
		 */		
		public function updatePullPet():void
		{
			_isNoticePullPet=false;
		}
		
		
		/**拉取宠物
		 * petDyId 宠物id 
		 * mapX  宠物拉取后的位置 
		 * mapY 宠物拉取后的位置
		 */ 
		public function noticePullPet(mapX:int,mapY:int):void
		{
			var pullPetVo:PullPetVo=new PullPetVo();
			pullPetVo.dyId=roleDyVo.dyId;
			pullPetVo.mapX=mapX;
			pullPetVo.mapY=mapY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_PullPet,pullPetVo);
		}
		
		public function setMoving(direction:int):void
		{
			_movingIndex=MovingLen-1;
			_moveCompleteDirection=direction;
		}
		
		/** 怪物发生移动  通知socket 
		 */		 
		private function noticePetMove(position:Point,path:Array,speed:Number):void
		{
			var playerMoveVo:PetMoveVo=PoolCenter.Instance.getFromPool(PetMoveVo) as PetMoveVo;
			playerMoveVo.path=path;
			playerMoveVo.direction=_moveCompleteDirection;
			playerMoveVo.dyId=roleDyVo.dyId;
			playerMoveVo.curentPostion=position;
			playerMoveVo.speed=speed;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_PetMoving,playerMoveVo);
		}
		
		/**设置怪物的颜色
		 */
		override public function updateName():void
		{
			_nameItem1.setText(roleDyVo.roleName,0x99FFcc);
		}
		override public function reset():void
		{
			super.reset();
			_movingPath=null;
			_hasTarget=false;
			_movingIndex=0;
			mouseChildren=mouseEnabled=true;
		}

		override public function constructor(roleDyVo:Object):IPool
		{
			super.constructor(roleDyVo);
			isLock=false;
			mouseChildren=mouseEnabled=true;
			return this;
		}
	}
}