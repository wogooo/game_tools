package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/** 场景 移形换影的显示类  用来显示重影
	 * @author yefeng
	 * 2013 2013-4-7 下午3:44:44 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.ui.res.CommonFla;
	
	import flash.geom.Point;
	
	/**只用来处理移形换影
	 */ 
	public class BlinkPlayer extends Abs2dView
	{
		private var _cloth:ATFMovieClip;
		private var _weapon:ATFMovieClip;
		private var _wing:ATFMovieClip;
		/**坐骑头部
		 */		
		private var _mountHead:ATFMovieClip;
		protected var _tweenSimple:TweenSimple;
		
		protected var _teenBezier:TweenBezier;
		
		public var _mapX:Number;
		public var _mapY:Number;
		
		private var _activeDirection:int;
		
		private var _activeAction:int;
		public function BlinkPlayer()
		{
			super();
		}
		/**设置坐标
		 * @param mapX
		 * @param mapY
		 */		
		public function setMapXY(mapX:int,mapY:int):void
		{
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}
		override protected function initUI():void
		{
			super.initUI();
			_tweenSimple=new TweenSimple();
			_teenBezier=new TweenBezier();
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

		public function initData(clothData:ATFActionData,weaponData:ATFActionData=null,wingData:ATFActionData=null,mountHeadData:ATFActionData=null):void
		{
			_cloth=BlinkPlayerMovieClipPool.getYF2dMovieClip();//new YF2dMovieClip();
			addChild(_cloth);
			_cloth.start();
			if(clothData)_cloth.actionDataStandWalk=clothData;
			else _cloth.setBitmapFrame(CommonFla.RoleFakeSkin,CommonFla.RoleFakeSkin.flashTexture,CommonFla.RoleFakeSkin.atlasData);////设置  默认皮肤
			if(weaponData)
			{
				_weapon=BlinkPlayerMovieClipPool.getYF2dMovieClip();//new YF2dMovieClip();
				_weapon.initActionDataStandWalk(weaponData);
				_weapon.start();
				addChild(_weapon);
			}
			if(wingData)
			{
				_wing=BlinkPlayerMovieClipPool.getYF2dMovieClip();//new YF2dMovieClip();
				_wing.initActionDataStandWalk(wingData);
				_wing.start();
				addChildAt(_wing,0);
			}
			if(mountHeadData)
			{
				_mountHead=BlinkPlayerMovieClipPool.getYF2dMovieClip();//new YF2dMovieClip();
				_mountHead.initActionDataStandWalk(wingData);
				_mountHead.start();
				addChildAt(_mountHead,1);
			}
		}
		public function gotoAndStop(action:int, direction:int, frameIndex:int):void
		{
			_activeAction=action;
			_activeDirection=direction;
			if(_cloth.actionDataStandWalk)_cloth.gotoAndStop(frameIndex,action,direction);
			if(_weapon)
			{
				if(_weapon.actionDataStandWalk)_weapon.gotoAndStop(frameIndex,action,direction);
			}
			if(_wing)
			{
				if(_wing.actionDataStandWalk)_wing.gotoAndStop(frameIndex,action,direction);
			}
			if(_mountHead)
			{
				if(_mountHead.actionDataStandWalk)_mountHead.gotoAndStop(frameIndex,action,direction);
			}
		}
		
		/**默认鸡蛋 皮肤
		 */		
		private function initDefault():void
		{
			_cloth=new ATFMovieClip();
			addChild(_cloth);
		}
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false,isHitMove:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(_cloth.actionDataStandWalk)
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}

		/**  不包含动作的播放
		 * oppsite  是否为移动方向的反方向
		 */		
		public function moveTo(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var direction:int=DirectionUtil.getDirection(this._mapX,this._mapY,mapX,mapY);
//			if(oppsite)direction=TypeDirection.getOppsiteDirection(direction);
//			play(TypeAction.Walk,direction);
//			blinkWalk(direction);
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updateMoveTo,new Point(mapX,mapY),forceUpdate);
			_tweenSimple.start();
		}
		
		public function sMoveTo(path:Array,speed:Number=5,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			_teenBezier.to(this,"_mapX","_mapY",path,speed,updateDatePath,completeFunc,completeParam,forceUpdate);
		}
		
		/** 路径行走更新
		 */
		protected function updateDatePath(data:Object):void
		{
			var obj:Point=Point(data);
			updatePathDirection(obj);
			updatePostion();
		}
		protected function updateMoveTo(obj:Object):void
		{
			var pt:Point=Point(obj);
			updatePostion();
			updatePathDirection(pt);
		}
		protected function updatePostion(e:YFEvent=null):void
		{
//			x =CameraProxy.Instance.x+int(_mapX)-CameraProxy.Instance.mapX;
//			y=CameraProxy.Instance.y+int(_mapY)-CameraProxy.Instance.mapY;
			setXY(CameraProxy.Instance.x+int(_mapX)-CameraProxy.Instance.mapX,CameraProxy.Instance.y+int(_mapY)-CameraProxy.Instance.mapY);
		}
		
		/**  人物在路径上行走时方向 的变化
		 */		
		protected function updatePathDirection(obj:Point):void
		{
			if(_mapX!=obj.x||_mapY!=obj.y)  ///当不为最后一个  排除走到位置的触发s
			{
				var direction:int=DirectionUtil.getDirection(_mapX,_mapY,obj.x,obj.y);
				if(_activeDirection!=direction) 
				{
//					play(TypeAction.Walk,direction);
					if(!isDispose)	blinkWalk(direction);
				}
			}
		}
		/**瞬移
		 */		
		public function blinkWalk(direction:int):void
		{
			gotoAndStop(TypeAction.Walk,direction,2);
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(_cloth)
			{
				if(_cloth.parent)_cloth.parent.removeChild(_cloth);
				BlinkPlayerMovieClipPool.toYF2dMovieClipPool(_cloth);
			}
			if(_weapon)
			{
				if(_weapon.parent)_weapon.parent.removeChild(_weapon);
				BlinkPlayerMovieClipPool.toYF2dMovieClipPool(_weapon);
			}
			if(_wing)
			{
				if(_wing.parent)_wing.parent.removeChild(_wing);
				BlinkPlayerMovieClipPool.toYF2dMovieClipPool(_wing);
			}
			if(_mountHead)
			{
				if(_mountHead.parent)_mountHead.parent.removeChild(_mountHead);
				BlinkPlayerMovieClipPool.toYF2dMovieClipPool(_mountHead);
			}
			super.dispose(childrenDispose);
			_tweenSimple.dispose();
			_teenBezier.dispose();
			_cloth=null;
			_weapon=null;
			_wing=null;
			_mountHead=null;
			_tweenSimple=null;
			_teenBezier=null;
		}
		
	} 
}