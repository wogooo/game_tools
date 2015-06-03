package com.YFFramework.game.core.module.mapScence.world.view.player
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	/**摄像机
	 * 2012-7-4
	 *	@author yefeng
	 */
	public class CameraProxy
	{
		/**flash 舞台上的坐标
		 */		
		public  var x:int;
		/**flash 舞台上的坐标
		 */		
		public  var y:int;
		/**世界坐标
		 */		
		public  var mapX:int;
		/**世界坐标
		 */		
		public  var mapY:int;
		
		/**角色的当前方向
		 */ 
//		public  var direction:int;
		
		
		/**跟随主角
		 */		
		public var followHero:Boolean;
		
		
		
		private static var _instance:CameraProxy;
		
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
		private var _stageW:int;
		private var _stageH:int;
		
		
		
		public function CameraProxy()
		{
			followHero=true;
			ResizeManager.Instance.regFunc(resize);
			initData();
//			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onDown);
		}
//		private function onDown(e:KeyboardEvent):void
//		{
//			if(e.keyCode==Keyboard.A)
//			{
//				updateMapXY(mapX+2,mapY);
//			}
//		}
		public static function get Instance():CameraProxy
		{
			if(_instance==null) _instance=new CameraProxy();
			return _instance;
			
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
		public function resize():void
		{
			initData();
			updateBgMapSize(_bgMapWidth,_bgMapHeight);
			setMapXY(mapX,mapY);
		}
		
		/**  更新背景地图宽高
		 */
		public function updateBgMapSize(bgMapSizeWidth:int,bgMapSizeHeight:int):void
		{
			_bgMapWidth=bgMapSizeWidth;
			_bgMapHeight=bgMapSizeHeight;
			_stageWidth__MapWidth=StageProxy.Instance.stage.stageWidth-_bgMapWidth;
			_stageHeight__MapHeight= StageProxy.Instance.stage.stageHeight-_bgMapHeight;
			_stageW=StageProxy.Instance.stage.stageWidth;
			_stageH=StageProxy.Instance.stage.stageHeight;
		}
		
		
		/** 第一次设置 坐标 居中人物 人物处于屏幕中央
		 */
		public function setMapXY(mapX:int,mapY:int):void
		{
			this.mapX=mapX;
			this.mapY=mapY;
			if(_bgMapWidth>_stageW)
			{
				LayerManager.sceneMoveX(0);

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

			}
			else 
			{
				x=mapX;
				_bgMapX=0;
//				LayerManager.YF2dContainer.x=(_stageW-_bgMapWidth)*0.5;
				LayerManager.sceneMoveX((_stageW-_bgMapWidth)*0.5);
			}

			
			if(_bgMapHeight>_stageH)
			{
//				LayerManager.YF2dContainer.y=0;
				LayerManager.sceneMoveY(0);
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
			}
			else 
			{
				y=mapY;
				_bgMapY=0;
//				LayerManager.YF2dContainer.y=(_stageH-_bgMapHeight)*0.5;
				LayerManager.sceneMoveY((_stageH-_bgMapHeight)*0.5);
			}
			
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoving);
			
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMove,{bgMapX:_bgMapX,bgMapY:_bgMapY});
			///非主角玩家以及关怪物的坐标更新
			_preMapX=mapX;
			_preMapY=mapY;
			_preBgmapX=_bgMapX;
			_preBgMapY=_bgMapY;
		}
		
		/** 人物发生移动时更新坐标调用  setMapXY只是第一次居中人物调用
		 */
		public function updateMapXY(mapX:int,mapY:int):void
		{
			this.mapX=mapX;
			this.mapY=mapY;
			//在可以滚图的区域 
			//向右滚屏
			if(_bgMapWidth>_stageW)
			{
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
			}
			else 
			{
				x=mapX;
			}
				
			
			//在可以滚图的区域
			//向下滚屏
			if(_bgMapHeight>_stageH)
			{
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
			}
			else 
			{
				y=mapY;
			}

			_preMapX=mapX;
			_preMapY=mapY;
//			updateHeroProxy();
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMoving);
			if(_preBgmapX!=_bgMapX||_preBgMapY!=_bgMapY)  //优化 只有当地图值发生变化时才发送事件
			{
				//		print(this,mapX,mapY,_preMapX,_preMapY,_difX,_difY,_bgMapX,_bgMapY);
				YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.HeroMove,{bgMapX:_bgMapX,bgMapY:_bgMapY});
				_preBgmapX=_bgMapX;
				_preBgMapY=_bgMapY;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}