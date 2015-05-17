package com.YFFramework.core.world.movie.player
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.mapScence.model.BackSlideMoveVo;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 *  主角  当前玩家类  
	 * @author yefeng
	 *2012-4-23下午10:57:05
	 */
	public class HeroPlayerView extends RolePlayerView
	{
		/** 血量过少
		 */		
		public static const HpTisShow:String="HpTisShow";
		
		public static const HpTisHide:String="HpTisHide";
		
		
	
		
		///主角行走发送消息的 变量  
		
		/** 行走路径   一般发三个点   距离必须大于等于30
		 */		 
		private var _movingPath:Array;
		/**路径播放的索引位置  A星 行走 的通讯索引
		 */
		/// 15帧通讯一次     人物行走  
		private var _sMovingIndex:int=0;
		/**每走 15帧  人物 通讯一次 更新下坐标   A星行走的 通讯峰值 ， smoveTo内更新函数调用的次数,当调用该次数后进行人物行走通讯
		 */ 
		private static const SMovingLen:int=15;
		
		/**进行moveTo函数移动时的 行走索引
		 */ 
		private var _moveToIndex:int=0;
		/**moveto内更新函数函数调用的 次数，当调用该次数后进行人物行走通讯
		 */		
		private static const MoveToLen:int=2;
		
		/**宠物行动索引
		 */ 
		private var _petMovingIndex:int=0;
		/** 人物走10步  刷新一次 宠物更新
		 */ 
		private static const  PetMovingLen:int=10;
		
		/** 人物瞬移  宠物的的行动索引
		 */		
		private var _petBlinkMovingIndex:int=0;
		/**每瞬移步数 3 刷一次
		 */		
		private static const PetBlinkMoveLen:int=3;
		
		
		/**状态监测  用于记录某个动作的时间 功能是 实现 客户端自动上坐骑  以及 自动 打坐  
		 */		
		private var _stateCheckTime:Number;
		private var SitCheckTime:int=20*1000;//打坐需要的时间 为20秒
		private var MountCheckTime:int=5*1000;///上坐骑需要的时间检测
		public function HeroPlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			mouseEnabled=mouseChildren=false;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			///检测玩家是否能够上马
			//	UpdateManager.Instance.frame153.regFunc(checkMount);
			///检测玩家是否能够打坐
			//		UpdateManager.Instance.frame601.regFunc(checkSit);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			UpdateManager.Instance.frame601.delFunc(checkSit);
		}
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false):void
		{
			///设置  打坐 和上坐骑的时间检测
			if(_activeAction!=action)_stateCheckTime=getTimer();
			super.play(action, direction, loop, completeFunc, completeParam, resetPlay);
			HeroPositionProxy.direction=_activeDirection;///设置主角方向 
		}
		
		override public function gotoAndStop(action:int, direction:int, frameIndex:int):void
		{
			_stateCheckTime=getTimer();
			super.gotoAndStop(action,direction,frameIndex);
		}
		
		/**检测角色状态 是否需要打坐  每  20 s 检测一次
		 */ 
		private function checkSit():void
		{
			///当玩家的状态不是打坐状态
			if(RoleDyVo(roleDyVo).state==TypeRole.State_Normal)
			{
				///当人物站着
				if(_activeAction==TypeAction.Stand)
				{
					if(getTimer()-_stateCheckTime>=SitCheckTime)
					{
						print(this,"请求打坐");
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.RequestSit);
					}
				}
			}
		}
		
		/** 检测角色状态 是否需要 上坐骑  每 5秒 检测一次
		 */		
		private function checkMount():void
		{
			///当玩家的状态不是在坐骑状态上时
			if(RoleDyVo(roleDyVo).state!=TypeRole.State_Mount)
			{
				///当人物在行走
				if(_activeAction==TypeAction.Walk)
				{
					if(getTimer()-_stateCheckTime>=MountCheckTime)
					{
						print(this,"请求上坐骑");
						YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.RequestMount);
					}
				}
			}
			
		}
		override protected function adjustToHero():void
		{  ///什么都不做即可
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoving,updatePostion);

		}
		override protected function removeAdjustToHero():void
		{
			YFEventCenter.Instance.removeEventListener(MapScenceEvent.HeroMoving,updatePostion);
		}
		
		/** 设置血量 value  为百分比  value的值为 0-1
		 *   更新血量
		 */		
		override public function updateHp():void
		{
			var value:Number=int(roleDyVo.hp*10000/roleDyVo.maxHp)/10000;
			if(value<0)value=0;
			_bloodMC.setPercent(value);
			if(value<=0.2&&value>0) YFEventCenter.Instance.dispatchEventWith(HpTisShow);///显示血量提示
			else if(value>0.2) YFEventCenter.Instance.dispatchEventWith(HpTisHide);///隐藏血量提示
			else if(value==0) YFEventCenter.Instance.dispatchEventWith(HpTisHide); ///隐藏血量提示
		}
		/** 第一次设置 坐标 居中人物 人物处于屏幕中央
		 */
		override public function setMapXY(mapX:int,mapY:int):void
		{
			_mapX=mapX;
			_mapY=mapY;
			CameraProxy.Instance.setMapXY(mapX,mapY);
			followCamera();
		}
		
		/**  包含通讯
		 */
		override public function moveTo(mapX:int, mapY:int, speed:Number=4, completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
		{
			_moveToIndex=0;
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY);
			play(TypeAction.Walk,direction);
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updateMoveTo,new Point(mapX,mapY),forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		}
		
		/**  包含通讯
		 * 主角人物的 该方法需要通讯  告知服务端进行坐标更新，但是不需要进行通讯返回
		 * direction  是人物站立 滑动的方向
		 */
		override public function backSlideMoveTo(mapX:int, mapY:int,direction:int, speed:Number=4, completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
		{
			/// 进行通信   瞬移  
			noticeBackSlideMove(mapX,mapY);
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var copyDirectionObj:Object=TypeDirection.getCopyDirection(direction); ////镜像方向
			gotoAndStop(TypeAction.Stand,copyDirectionObj.direction,1);///停留第二帧
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePureMove,new Point(mapX,mapY),forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
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
		
		override protected function updateMoveTo(obj:Object):void
		{
			var pt:Point=Point(obj);
			updateHeroPostion();
			updatePathDirection(pt);
			moveToNotice(pt);
		}
		
		/**人物进行执行行走 瞬移时 的通讯
		 */ 
		private function moveToNotice(pt:Point):void
		{
			//// 人物移动通讯 
			_moveToIndex++;
			if(_moveToIndex>=MoveToLen)
			{
				_moveToIndex=0;
				var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
				_movingPath=[pt];
				noticeHeroMove(postion,_movingPath,DataCenter.Instance.roleSelfVo.speedManager.walkSpeed);
			}
			
			////宠物拉取  通讯
			// pullPet();
			++_petBlinkMovingIndex;
			if(_petBlinkMovingIndex==PetBlinkMoveLen)
			{
				_petBlinkMovingIndex=0;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetMoving);  ///宠物发生移动
			}
		}
		
		/**
		 * @param data  下一个目标点 
		 */		 
		override protected function updateDatePath(data:Object):void
		{
			updatePathDirection(Point(data));
			updateHeroPostion();
			++_sMovingIndex;
			if(_sMovingIndex>=SMovingLen)
			{
				_sMovingIndex=0;
				_movingPath=_teenBezier.getPlayPath();
				var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
				noticeHeroMove(postion,_movingPath,DataCenter.Instance.roleSelfVo.speedManager.walkSpeed);
			}
			////判断和宠物 之间的 距离 大于  指定距离时  宠物向玩家靠近
			/// 宠物行走 
			pullPet();
		}
		/**主角刚开始 移动 设置移动通讯索引
		 */		 
		public function setMovingIndex():void
		{
			_sMovingIndex=SMovingLen-1;
		}
		
		
		/**拖动宠物
		 */		 
		private function pullPet():void
		{
			++_petMovingIndex;
			if(_petMovingIndex>=PetMovingLen)
			{
				_petMovingIndex=0;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetMoving);  ///宠物发生移动
			}
		}
		
		
		
		/** 主角发生移动  通知socket 
		 * path [Pt(x,y),Pt(x,y)]
		 */		 
		private function noticeHeroMove(position:Point,path:Array,speed:Number):void
		{
			//			 var playerMoveVo:PlayerMoveVo=PoolCenter.Instance.getFromPool(PlayerMoveVo) as PlayerMoveVo;
			var playerMoveVo:Object={};
			playerMoveVo.path=path;
			playerMoveVo.curentPostion=position;
			playerMoveVo.speed=speed;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroMoving,playerMoveVo);
		}
		
		override protected function updatePostion(e:YFEvent=null):void
		{
			if(CameraProxy.Instance.followHero)
			{
				followCamera();
			}
			else 
			{
				super.updatePostion(e);
			}
			updateHeroPositionProxy();
		}
		/**更新主角坐标代理
		 */		
		private function updateHeroPositionProxy():void
		{
			HeroPositionProxy.x=x;
			HeroPositionProxy.y=x;
			HeroPositionProxy.mapX=_roleDyVo.mapX;
			HeroPositionProxy.mapY=_roleDyVo.mapY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoveForSmallMap);
		}
		/**跟随摄像机
		 */		
		private function followCamera():void
		{
			x=CameraProxy.Instance.x;
			y=CameraProxy.Instance.y;
			_roleDyVo.mapX=CameraProxy.Instance.mapX;
			_roleDyVo.mapY=CameraProxy.Instance.mapY;
		}
		private function updateHeroPostion():void
		{
			if(CameraProxy.Instance.followHero)CameraProxy.Instance.updateMapXY(_mapX,_mapY);
			else updatePostion();
		}
		
		override protected function setPoolNum():void
		{
			regPool(1);
		}
	}
}