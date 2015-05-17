package com.YFFramework.core.world.movie.player
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.PlayerMoveVo;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;

	/**
	 *  主角  当前玩家类  
	 * @author yefeng
	 *2012-4-23下午10:57:05
	 */
	public class HeroPlayerView extends RolePlayerView
	{
		
		/**   预先计算的量
		 */		
		private var _centerX:Number;
		private var _centerY:Number;
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		/** stageWidth-MapWidth的值
		 */		
		private var _stageWidth__MapWidth:Number;
		
		/**stageHeight-MapHeight的值
		 */
		private var _stageHeight__MapHeight:Number;
		
		
		
		
		private var _bgMapX:Number;
		private var _bgMapY:Number;
		
		/**  前一个的地图 x  y坐标 用于优化
		 */		
		private var _preBgmapX:Number;
		private var preBgMapY:Number;
		/** 角色 前一个 map x y坐标
		 */		
		private var _preMapX:Number;
		
		
		private var _preMapY:Number;


		/** 背景地图宽
		 */
		private var _bgMapWidth:Number;
		/**背景地图高
		 */
		private var _bgMapHeight:Number;
		/**临时变量 
		 */		
		private var _difX:Number;
		private var _difY:Number;
		
		
		
		
		
		///主角行走发送消息的 变量  
		
		/** 行走路径   一般发三个点   距离必须大于等于30
		 */		 
		private var _movingPath:Array;
		/**路径播放的索引位置
		 */
		//		 private var _pathPlayIndex:int;
		
		private static const Length:int=90;
		
		/// 9帧通讯一次
		private var _movingIndex:int=0;
		/** 路径行走更新  sMove
		 */
		
		public function HeroPlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			ResizeManager.Instance.regFunc(resize);
			initData();
			mouseEnabled=mouseChildren=false;
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
			 setMapXY(_roleDyVo.mapX,_roleDyVo.mapY);
		 }
		 
		 
		 
		 /**  更新背景地图宽高
		  */
		 public function updateBgMapSize(bgMapSizeWidth:Number,bgMapSizeHeight:Number):void
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
		 
		 
		 /** 第一次设置 坐标 居中人物 人物处于屏幕中央
		  */
		 override public function setMapXY(mapX:Number,mapY:Number):void
		 {
			 roleDyVo.mapX=mapX;
			 roleDyVo.mapY=mapY;
			 
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
			preBgMapY=_bgMapY;
		 }
		 
		 
		 
		 /** 人物发生移动时更新坐标调用  setMapXY只是第一次居中人物调用
		  */
		 protected function updateMapXY(mapX:Number,mapY:Number):void
		 {
			//在可以滚图的区域 
			 //向右滚屏
			_difX=roleDyVo.mapX-_preMapX;///地图要运动大小 
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
			_difY=roleDyVo.mapY-_preMapY;///地图要运动大小 
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
			if(_preBgmapX!=_bgMapX||preBgMapY!=_bgMapY)  //优化 只有当地图值发生变化时才发送事件
			{
				updateHeroProxy();
		//		print(this,mapX,mapY,_preMapX,_preMapY,_difX,_difY,_bgMapX,_bgMapY);
					
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMove,{bgMapX:_bgMapX,bgMapY:_bgMapY});
				
				_preBgmapX=_bgMapX;
				preBgMapY=_bgMapY;
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
		 }
		 override public function moveTo(mapX:Number, mapY:Number, speed:Number=4, completeFunc:Function=null,completeParam:Object=null):void
		 {
	///		 sendIndex=0;
			 var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY);
			 play(TypeAction.Walk,direction);
			 _tweenSimple.tweenTo(roleDyVo,"mapX","mapY",mapX,mapY,speed,completeFunc,completeParam,updateHeroPosition);
			 _tweenSimple.start();
		 }
		 
		 override public function sMoveTo(path:Array, speed:Number=5, completeFunc:Function=null, completeParam:Object=null,forceUpdate:Boolean=false):void
		 {
			 _movingIndex=0;
			 super.sMoveTo(path, speed, completeFunc, completeParam,forceUpdate);
		 }
		 /**
		  * @param data  下一个目标点 
		  */		 
		 override protected function updateDatePath(data:Object):void
		 {
			 
			 ++_movingIndex;
			 if(_movingIndex==15)
			 {
				 _movingIndex=0;
				 _movingPath=_teenBezier.getPlayPath();
				 var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
				 noticeHeroMove(postion,_movingPath,6);
			 }
			 			 
			 updatePathDirection(Point(data));
			 updateHeroPosition();
			 /// 判断改点是否是消隐点
		 }
		 /** 主角发生移动  通知socket 
		  */		 
		 private function noticeHeroMove(position:Point,path:Array,speed:int):void
		 {
			 var playerMoveVo:PlayerMoveVo=PoolCenter.Instance.getFromPool(PlayerMoveVo) as PlayerMoveVo;
			 playerMoveVo.path=path;
			 playerMoveVo.id=roleDyVo.dyId;
			 playerMoveVo.curentPostion=position;
			 playerMoveVo.speed=speed;
			 YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_HeroMoving,playerMoveVo);
		 }

		 private function updateHeroPosition(data:Object=null):void
		 {
			 updateMapXY(roleDyVo.mapX,roleDyVo.mapY);
		//	 setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		 }
		
		
		 
		 /**震动屏幕 
		  */
		 public function shake():void
		 {
			 var spaceY:int=10;
			 var spaceX:int=10;
			 var mapX:int=roleDyVo.mapX;
			 var mapY:int=roleDyVo.mapY;
			 var  right:int=roleDyVo.mapX+spaceX;
			 var bottom:int=roleDyVo.mapY+spaceY;
			 var left:int=roleDyVo.mapX-spaceX;
			 var top:int=roleDyVo.mapY-spaceY;
			 var line:TimelineLite=new TimelineLite();
			 var tween1:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:right,mapY:bottom,onUpdate:update});
			 var tween2:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:left,mapY:top,onUpdate:update});
			 var tween3:TweenLite=TweenLite.to(roleDyVo,0.1,{mapX:mapX,mapY:mapY,onUpdate:update});
			 line.append(tween1);
			 line.append(tween2);
		 	line.append(tween3);

		 }
		 
		 private function update():void
		 {
			 setMapXY(roleDyVo.mapX,roleDyVo.mapY);
		 }
	
		 override protected function setPoolNum():void
		 {
			 regPool(1);
		 }
	}
}