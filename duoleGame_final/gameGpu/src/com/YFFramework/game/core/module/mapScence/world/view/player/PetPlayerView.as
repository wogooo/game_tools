package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**宠物UI类 场景中行走的对象
	 * @author yefeng
	 *2012-9-16下午9:28:12
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.model.proto.PetMoveVo;
	import com.YFFramework.game.core.module.mapScence.model.proto.PullPetVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.ui.imageText.ImageUtil;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	public class PetPlayerView extends MonsterView
	{	
		
		/**移动时走到 距离人物50像素远的地方   也是 拉取宠物后距离人的位置
		 */ 
		public static const MinDistance:int=70;
		/**宠物和人之间的距离
		 */ 
		public static const Distance:int=80;
		
		/**拉取宠物的距离 当宠物离自己太远时拉取宠物
		 */ 
		public static const MaxDistance:int=400;

		
		
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
		protected var _moveSpeed:Number;

		
		
		/**宠物对象是否锁住了  宠物战斗时处于锁住状态 不能进行移动  
		 */ 
		public var isLock:Boolean;
		/**宠物移动结束后的方向
		 */ 
		private var _moveCompleteDirection:int;
		
//		private var _movingIndex:int=0;
//		private static const MovingLen:int=10;
		
		private var _prMovingTime:Number=0;
		
		private static const MovingTime:int=500;
		/**是否发送了宠物拉取  ， 发送了宠物拉取协议 后   该值变为true  在成功拉取后 该值才变为false  等待下一次拉取
		 */		
		private var _isNoticePullPet:Boolean;
		public function PetPlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		//	_hasTarget=true;///目标对象为当前玩家   也就是主人 这样 就可以通过主人来进行通信
			_hasTarget=false;
			isLock=false;
			_isNoticePullPet=false;
		}
		/**宠物需要进行alpha检测  只有怪物才不进行alpha检测
		 */		
		override protected function initCheckAlpha():void
		{
			DisplayObject2D(_cloth.mainClip).checkAlpha=true; //
		}

		override public function sMoveTo(path:Array, speed:Number=5, completeFunc:Function=null, completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_moveSpeed=speed;
			super.sMoveTo(path, speed, completeFunc, completeParam,forceUpdate);
		}

		
		/**更新目标状态 具有目标 或者失去目标 
		 * _hasTarget 为 true表示是自己的宠物
		 */ 
		public function updateTarget(hasTarget:Boolean):void
		{
			_hasTarget=hasTarget;
			mouseEnabled=false;
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
//				++_movingIndex;
//				if(_movingIndex>=MovingLen)
				if(getTimer()-_prMovingTime>=MovingTime)
				{
//					_movingIndex=0;
					_prMovingTime=getTimer();
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
		
		/**简单的受击效果
		 * 
		 */		
		override protected function initInjureEffect(action:int,direction:int,isHitMove:Boolean=false):int
		{
			return doSimpleInjure(action,direction);
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
		public function noticePullPet(mapX:int,mapY:int):PullPetVo
		{
			var pullPetVo:PullPetVo=new PullPetVo();
			pullPetVo.dyId=roleDyVo.dyId;
			pullPetVo.mapX=mapX;
			pullPetVo.mapY=mapY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_PullPet,pullPetVo);
//			_isNoticePullPet=true;
			return pullPetVo;
		}
		
//		/** 如果 宠物被拉取掉了采取补救措施
//		 */
//		public static function noticePullPet2(dyId:int,mapX:int,mapY:int):PullPetVo
//		{
//			var pullPetVo:PullPetVo=new PullPetVo();
//			pullPetVo.dyId=dyId;
//			pullPetVo.mapX=mapX;
//			pullPetVo.mapY=mapY;
//			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_PullPet,pullPetVo);
//			return pullPetVo;
//		}
		
		/** 是否具有目标对象
		 */		
		public function isHasTarget():Boolean
		{
			return _hasTarget;
		}
		
		/**  移动 行走
		 */
		override public function moveTo(mapX:int, mapY:int, speed:Number=4, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false):void
		{
			// TODO Auto Generated method stub
			_moveSpeed=speed;
			super.moveTo(mapX, mapY, speed, completeFunc, completeParam, forceUpdate);
		}

		
		public function setMoving(direction:int):void
		{
//			_movingIndex=MovingLen;
			_prMovingTime=-1000;
			_moveCompleteDirection=direction;
		}
		
		/** 怪物发生移动  通知socket 
		 */		 
		private function noticePetMove(position:Point,path:Array,speed:Number):void
		{
			var playerMoveVo:PetMoveVo=new PetMoveVo();//PoolCenter.Instance.getFromPool(PetMoveVo) as PetMoveVo;
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
			reLocateNamePosition();
		}
		/**显示手势光标
		 */		
		override protected function initMouseCursor(select:Boolean):void
		{
			
		}
		override public function showBufHpfChange(hpChange:int):void
		{
			var my:Number=-50;
			if(_cloth.actionDataStandWalk)my=_cloth.actionDataStandWalk.getBlood().y*0.5;
			if(hpChange<0) ///扣血
			{
				ImageUtil.Instance.showBuffHpMinus(Math.abs(hpChange),flashContainer,my,TypeImageText.Role);
			}
			else //加血 
			{
				ImageUtil.Instance.showBuffHpAdd(hpChange,flashContainer,my,TypeImageText.Role);
			}
		}
		
		override public function addBloodText(num:int,curentHp:int,timeArr:Array,completeFunc:Function=null,param:Object=null,damageType:int=0,showNum:Boolean=true):void
		{
			var myY:Number=0;
			if(roleDyVo)
			{
				roleDyVo.hp=curentHp;
			}
			if(showNum)
			{
				ImageUtil.Instance.showBloodEx(timeArr,num,flashContainer,myY,TypeImageText.Role,onBloodComplete,{param:param,func:completeFunc},damageType);
			}
			else 
			{
				onBloodComplete({param:param,func:completeFunc});
			}
		}
		
		/**更新统设置
		 */		
		override public function updateSystemConfig():void
		{
			_bloodMC.visible=!SystemConfigManager.shieldHp;  //隐藏血条
			if(_tittleClip)			//隐藏玩家称号
			{
				_tittleClip.visible=SystemConfigManager.showTitle;   
			}
			//不选中宠物
			if(SystemConfigManager.notSelectPet)
			{
				mouseEnabled=false;
			}
			else 
			{
				if(_hasTarget)mouseEnabled=false; //主角宠物不能点击
				else mouseEnabled=true;   //其他玩家宠物可以点击
			}
			//隐藏其他玩家宠物
			if(SystemConfigManager.shieldOtherPet)
			{
				if(!_hasTarget) //不是自己的宠物 
				{
					_cloth.visible=false;			//隐藏其他玩家宠物
				}
			}
			else //显示宠物
			{
				_cloth.visible=true;	
			}
		}

		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose();
			_movingPath=null;
		}
	}
}