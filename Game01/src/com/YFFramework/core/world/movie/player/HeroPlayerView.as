package com.YFFramework.core.world.movie.player
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.PlayerMoveVo;
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

		
		/**   预先计算的量
		 */		
		private var _centerX:int;
		private var _centerY:int;
		private var _left:int;
		private var _right:int;
		private var _top:int;
		private var _bottom:int;
		/** stageWidth-MapWidth的值
		 */		
		private var _stageWidth__MapWidth:int;
		
		/**stageHeight-MapHeight的值
		 */
		private var _stageHeight__MapHeight:int;
		
		
		
		
		private var _bgMapX:int;
		private var _bgMapY:int;
		
		/**  前一个的地图 x  y坐标 用于优化
		 */		
		private var _preBgmapX:int;
		private var _preBgMapY:int;
		/** 角色 前一个 map x y坐标
		 */		
		private var _preMapX:int;
		
		
		private var _preMapY:int;


		/** 背景地图宽
		 */
		private var _bgMapWidth:int;
		/**背景地图高
		 */
		private var _bgMapHeight:int;
		/**临时变量 
		 */		
		private var _difX:int;
		private var _difY:int;
		
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
		
		/**人物瞬移 或者  被击打时 需要告知宠物  使宠物和人保持在一定的距离内
		 */ 
//		private  var _pureMoveIndex:int=0;
//		private static const PureMoveLen:int=2;

		/**宠物行动索引
		 */ 
		private var _petMovingIndex:int=0;
		
		/** 人物瞬移  宠物的的行动索引
		 */		
		private var _petBlinkMovingIndex:int=0;
		/**每瞬移步数 3 刷一次
		 */		
		private static const PetBlinkMoveLen:int=3;
		
		/** 人物走10步  刷新一次 宠物更新
		 */ 
		private static const  PetMovingLen:int=10;
		
		/**状态监测  用于记录某个动作的时间 功能是 实现 客户端自动上坐骑  以及 自动 打坐  
		 */		
		private var _stateCheckTime:Number;
		private var SitCheckTime:int=20*1000;//打坐需要的时间 为20秒
		private var MountCheckTime:int=5*1000;///上坐骑需要的时间检测
		public function HeroPlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			ResizeManager.Instance.regFunc(resize);
			initData();
			mouseEnabled=mouseChildren=false;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			///检测玩家是否能够上马
		//	UpdateManager.Instance.frame153.regFunc(checkMount);
			///检测玩家是否能够打坐
			UpdateManager.Instance.frame601.regFunc(checkSit);
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
			HeroProxy.direction=_activeDirection;///设置主角方向 
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
		
		

		private function initData():void
		{
			_centerX=StageProxy.Instance.stage.stageWidth*0.5;
			_centerY=StageProxy.Instance.stage.stageHeight*0.5;
			_left=BgMapScrollport.scrollPort.left;
			_right=BgMapScrollport.scrollPort.right;
			_top=BgMapScrollport.scrollPort.top;;
			_bottom=BgMapScrollport.scrollPort.bottom;
		}
		 private function resize():void
		 {
			 initData();
			 updateBgMapSize(_bgMapWidth,_bgMapHeight);
			// setMapXY(_roleDyVo.mapX,_roleDyVo.mapY);
			 setMapXY(_mapX,_mapY);
		 }
		 
		 
		 
		 /**  更新背景地图宽高
		  */
		 public function updateBgMapSize(bgMapSizeWidth:int,bgMapSizeHeight:int):void
		 {
			 _bgMapWidth=bgMapSizeWidth;
			 _bgMapHeight=bgMapSizeHeight;
			 _stageWidth__MapWidth=StageProxy.Instance.stage.stageWidth-_bgMapWidth;
			 _stageHeight__MapHeight= StageProxy.Instance.stage.stageHeight-_bgMapHeight;
		 }
		 
		 override protected function adjustToHero():void
		 {  ///什么都不做即可
		 }
		 
		 override protected function removeAdjustToHero():void
		 {
		 }

		 
		 /** 设置血量 value  为百分比  value的值为 0-1
		 *   更新血量
		  */		
		 override public function updateHp(value:Number):void
		 {
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
			 roleDyVo.mapX=mapX;
			 roleDyVo.mapY=mapY;
			 _mapX=mapX;
			 _mapY=mapY;
			 
			if(mapX<=_centerX)
			{
				x=mapX;
				_bgMapX=0;
			}
			else if(mapX>_centerX&&mapX<_bgMapWidth-_centerX)
			{
				x=_centerX;
				_bgMapX=_centerX-mapX;
			}
			else
			{
				x=_stageWidth__MapWidth+mapX
				_bgMapX=_stageWidth__MapWidth;
			}
			
			if(mapY<=_centerY)
			{
				y=mapY;
				_bgMapY=0;
			}
			else if(mapY>_centerY&&mapY<_bgMapHeight-_centerY)
			{
				y=_centerY;
				_bgMapY=_centerY-mapY;
			}
			else
			{
				y= _stageHeight__MapHeight+mapY
				_bgMapY= _stageHeight__MapHeight;
			}
			updateHeroProxy();
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMove,{bgMapX:_bgMapX,bgMapY:_bgMapY});
			///非主角玩家以及关怪物的坐标更新
		//	EventCenter.Instance.dispatchEvent(new ParamEvent(MapScenceEvent.HeroMoveToPostion,{mapX:roleDyVo.mapX,mapY:roleDyVo.mapY,x:x,y:y}));
			_preMapX=mapX;
			_preMapY=mapY;
			_preBgmapX=_bgMapX;
			_preBgMapY=_bgMapY;
		 }
		 
		 
		 
		 /** 人物发生移动时更新坐标调用  setMapXY只是第一次居中人物调用
		  */
		 protected function updateMapXY(mapX:int,mapY:int):void
		 {
			//在可以滚图的区域 
			 //向右滚屏
			_difX=mapX-_preMapX;///地图要运动大小 
			if(_difX>=0)
			{
				//当不在右边上
				if(x<_right)
				{
					//将要向右 移动的大小  地图向左移动的大小
					if(_difX>_right-x)
					{
						_difX -=_right-x;
						x=_right;
						_bgMapX +=-_difX;
						
						if(_bgMapX<_stageWidth__MapWidth)
						{
							_difX=_stageWidth__MapWidth-_bgMapX;
							_bgMapX=_stageWidth__MapWidth;
							x +=_difX;
						}
					}
					else 
					{
						x=x+_difX;
					}
				}
				else   //右边上
				{
					_bgMapX +=-_difX;
					if(_bgMapX<_stageWidth__MapWidth)
					{
						_difX=_stageWidth__MapWidth-_bgMapX;
						_bgMapX=_stageWidth__MapWidth;
						x +=_difX;
					}
				}
				
			}
			//向左移动
			else 
			{
				_difX= -_difX;
				//当不在左边上
				if(x>_left)
				{
					if(_difX>x-_left)
					{
						_difX -=x-_left;
						_bgMapX +=_difX;
						x=_left;
						if(_bgMapX>0)
						{
							_difX=_bgMapX;
							_bgMapX=0;
							x -=_difX;
						}
						
					}
					else 
					{
						x=x-_difX;
					}
				}
				else 
				{
					//人物向左滚动
					_bgMapX += _difX;
					if(_bgMapX>0)
					{
						_difX=_bgMapX;
						_bgMapX=0;
						x -=_difX;
					}
				}
			}

			//在可以滚图的区域
			//向下滚屏
			_difY=mapY-_preMapY;///地图要运动大小 
			if(_difY>=0)
			{
				//当不在下边上
				if(y<_bottom)
				{
					if(_difY>_bottom-y)
					{
						
						_difY -=_bottom-y;
						y=_bottom;
						_bgMapY +=-_difY;
						if(_bgMapY< _stageHeight__MapHeight)
						{
							_difY= _stageHeight__MapHeight-_bgMapY;
							_bgMapY= _stageHeight__MapHeight;
							y +=_difY;
						}
					}
					else 
					{
						y +=_difY;
					}
				}
				else   //下边上
				{
					_bgMapY +=-_difY;
					if(_bgMapY< _stageHeight__MapHeight)
					{
						_difY= _stageHeight__MapHeight-_bgMapY;
						_bgMapY= _stageHeight__MapHeight;
						y +=_difY;
					}
				}
				
			}
				//向上滚屏
			else 
			{
				_difY= -_difY;
				//当不在上边上
				if(y>_top)
				{
					if(_difY>y-_top)
					{
						_difY -=y-_top;
						_bgMapY +=_difY;
						y=_top;
						
						if(_bgMapY>0)
						{
							_difY=_bgMapY;
							_bgMapY=0;
							y -=_difY;
						}
					}
					else 
					{
						y=y-_difY;
					}
				}
				//在上边上
				else 
				{
					//图片向右滚动
					//	difX =-difX;
					_bgMapY += _difY;
					if(_bgMapY>0)
					{
						_difY=_bgMapY;
						_bgMapY=0;
						y -=_difY;
					}
				}
			}
			_preMapX=mapX;
			_preMapY=mapY;
			updateHeroProxy();
			if(_preBgmapX!=_bgMapX||_preBgMapY!=_bgMapY)  //优化 只有当地图值发生变化时才发送事件
			{
		//		print(this,mapX,mapY,_preMapX,_preMapY,_difX,_difY,_bgMapX,_bgMapY);
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMove,{bgMapX:_bgMapX,bgMapY:_bgMapY});
				_preBgmapX=_bgMapX;
				_preBgMapY=_bgMapY;
			}
		}
		 
		 /**更新角色代理
		  */
		 private function updateHeroProxy():void
		 {
			 HeroProxy.x=x;
			 HeroProxy.y=y;
			 HeroProxy.mapX=roleDyVo.mapX;
			 HeroProxy.mapY=roleDyVo.mapY;
			 YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoveForSmallMap);
		 }
		 
		 /**  包含通讯
		 */
		 override public function moveTo(mapX:int, mapY:int, speed:int=4, completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
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
		 override public function backSlideMoveTo(mapX:int, mapY:int,direction:int, speed:int=4, completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
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
		 
		 

		 /** 纯粹移动更新   不含有通讯 
		  */		
		 override protected function updatePureMove(obj:Object):void
		 {
			 updateHeroPosition();
			 checkAlphaPoint();
			 
			 //告知宠物进行拉取
//			 _pureMoveIndex++;
//			 if(_pureMoveIndex>=PureMoveLen)
//			 {
//				 _pureMoveIndex=0;
		//O	 YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetMoving);  ///宠物发生移动
//			 }
		 }
		 
		 
		 override protected function updateMoveTo(obj:Object):void
		 {
			 var pt:Point=Point(obj);
			 updateHeroPosition();
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
			 updateHeroPosition();
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
		 
		 
		 /**拉取宠物
		  */		 
		 private function pullPet():void
		 {
			 ++_petMovingIndex;
			 if(_petMovingIndex>=PetMovingLen)
			 {
				 _petMovingIndex=0;
				 YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetMoving);  ///宠物发生移动
			//	 print(this,".....拉取宠物");
			 }
		 }
		 
		 
		 
		 /** 主角发生移动  通知socket 
		 * path [Pt(x,y),Pt(x,y)]
		  */		 
		 private function noticeHeroMove(position:Point,path:Array,speed:int):void
		 {
			 var playerMoveVo:PlayerMoveVo=PoolCenter.Instance.getFromPool(PlayerMoveVo) as PlayerMoveVo;
			 playerMoveVo.path=path;
		//	 playerMoveVo.id=roleDyVo.dyId;
			 playerMoveVo.curentPostion=position;
			 playerMoveVo.speed=speed;
			 YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroMoving,playerMoveVo);
		 }

		 private function updateHeroPosition(data:Object=null):void
		 {
			 _roleDyVo.mapX=int(_mapX);
			 _roleDyVo.mapY=int(_mapY);
			 updateMapXY(_roleDyVo.mapX,_roleDyVo.mapY);
		//	 setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		 }
		
		 
		 
		 
		 /**震动屏幕 
		  */
		 public function shake():void
		 {
//			 var spaceY:int=10;
//			 var spaceX:int=10;
//			 var mapX:int=roleDyVo.mapX;
//			 var mapY:int=roleDyVo.mapY;
//			 var  right:int=roleDyVo.mapX+spaceX;
//			 var bottom:int=roleDyVo.mapY+spaceY;
//			 var left:int=roleDyVo.mapX-spaceX;
//			 var top:int=roleDyVo.mapY-spaceY;
//			 var line:TimelineLite=new TimelineLite();
//			 var tween1:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:right,mapY:bottom,onUpdate:update});
//			 var tween2:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:left,mapY:top,onUpdate:update});
//			 var tween3:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:mapX,mapY:mapY,onUpdate:update});
//			 line.append(tween1);
//			 line.append(tween2);
//		 	line.append(tween3);

		 }
		 
		 private function update():void
		 {
			 setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		 }
		 
		 
	
		 override protected function setPoolNum():void
		 {
			 regPool(1);
		 }
//		 override public function toPool():void
//		 {
//			 super.toPool();
//		 }
	}
}