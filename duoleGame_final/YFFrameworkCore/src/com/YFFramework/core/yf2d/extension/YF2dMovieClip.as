package com.YFFramework.core.yf2d.extension
{
	/**@author yefeng
	 *2012-11-17下午11:41:48
	 */
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.tween.TweenYF2dPlay;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.display.sprite2D.YF2dClip;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Point;
	
	public class YF2dMovieClip extends YF2dClip
	{
		
		
		public var actionDataStandWalk:YF2dActionData;
		
		public var actionDataInjureDead:YF2dActionData;

		public var actionDataFight:YF2dActionData;
		
		
		/** 特殊 攻击动作 数据1
		 */		
		public var actionDataAtk_1:YF2dActionData;
		
		/**战斗待机数据
		 */		
		public var actionDataFightStand:YF2dActionData;

		
		protected var _playTween:TweenYF2dPlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		
//		private var _timer:Timer;
		private var _isStart:Boolean;
		
		/**重新 创建材质时  的缓存
		 */ 
		protected var _preMovieData:MovieData;
		private var _preScaleX:Number;
		private var _preLoop:Boolean;
		
		
		
		protected var _activeAction:int=-1;
		protected var _activeDirection:int=-1;
		
		public var isDisposeToPool:Boolean=false;


		public function YF2dMovieClip()
		{
			super();
			mouseChildren=false;
			addEvents();
		}
		
		
		public function initActionDataStandWalk(data:YF2dActionData):void
		{
			if(actionDataStandWalk!=data)
			{ 
				actionDataStandWalk=data;
				if(actionDataStandWalk)
				{
					blendMode=actionDataStandWalk.getBlendMode();
				}
			}
		}
		
		
		/**初始化
		 */		
		public  function initActionDataFight(actionData:YF2dActionData):void
		{
			if(actionDataFight!=actionData)
			{
				actionDataFight=actionData;
				if(actionDataFight)	blendMode=actionDataFight.getBlendMode();
			}
		}

		/**初始化
		 */		
		public  function initActionDataInjureDead(actionData:YF2dActionData):void
		{
			if(actionDataInjureDead!=actionData)
			{
				actionDataInjureDead=actionData;
				if(actionDataInjureDead)blendMode=actionDataInjureDead.getBlendMode();
			}
		}
		
		/**初始化特殊攻击动作 1
		 */		
		public  function initActionDataAtk_1(actionData:YF2dActionData):void
		{
			if(actionDataAtk_1!=actionData)
			{
				actionDataAtk_1=actionData;
				if(actionDataAtk_1)blendMode=actionDataAtk_1.getBlendMode();
			}
		}
		/**初始化战斗待机
		 */		
		public  function initActionDataFightStand(actionData:YF2dActionData):void
		{
			if(actionDataFightStand!=actionData)
			{
				actionDataFightStand=actionData;
				if(actionDataFightStand)blendMode=actionDataFightStand.getBlendMode();
			}
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_playTween=new TweenYF2dPlay();
			_playTween.setPlayFunc(updateTextureData);
//			initTimer();
		}
		protected function addEvents():void
		{
			_playTween.addEventListener(YFEvent.Complete,onPlayComplete);
//			var t:Number=getTimer();
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onRecreate);  /// context3d dispose后 重新初始化
//			print(this,"注册scene消耗时间"+(getTimer()-t));
		}
		protected function removeEvents():void
		{
			_playTween.removeEventListener(YFEvent.Complete,onPlayComplete);
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onRecreate);
		}
		private function onRecreate(e:YF2dEvent):void
		{
			if(_preMovieData)  //如果播了数据 则重新设置数据
			{
				///重新播放
				playInit(_preMovieData,_preScaleX,_preLoop);
			}
		}
		
		///一个动作做完之后触发
		protected function onPlayComplete(e:YFEvent):void
		{
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}
		/**
		 * @param reUseIndex    使用index 
		 */		
		protected function playInit(movieData:MovieData,scaleX:Number,loop:Boolean=true,useDefault:Boolean=false):void
		{
			/// 重新创建材质需要
			_preMovieData=movieData;
			_preScaleX=scaleX;
			_preLoop=loop;
			var texture:TextureBase=movieData.getTexture();
//			if(texture)
//			{
				///设置贴图
				///设置像素源
				_movie.setAtlas(movieData.bitmapData);
				_movie.setFlashTexture(texture);
				_playTween.initData(movieData,scaleX,loop);
				_playTween.start();

//			}
//			else 
//			{
//				if(_preMovieData)
//				{
//					movieData.createTextureAsync(completeIt,movieData);
////					_movie.setFlashTexture(TextureProxy.Instance.flashTexture);
//					_movie.setAtlas(_preMovieData.bitmapData);
//					_movie.setFlashTexture(_preMovieData.getTexture());
//					_playTween.initData(_preMovieData,scaleX,loop);
//					_playTween.stop();
//					updateTextureData(_preMovieData.dataArr[0],_preScaleX);
//				}
//				else 
//				{
//					_movie.setAtlas(movieData.bitmapData);
//
//					movieData.createTextureRightNow();
//
//					_movie.setFlashTexture(texture);
//					_playTween.initData(movieData,scaleX,loop);
//					_playTween.start();
//				}
//			}
		} 
		
		private function completeIt(texture:Texture,movieData:MovieData):void
		{
			if(_preMovieData==movieData)
			{
				playInit(_preMovieData,_preScaleX,_preLoop);
			}
		} 
		
		/**停止播放
		 */		
		public function playTweenStop():void
		{
			_playTween.stop();
		}
		/**  播放方向
		 * resetPlay 重新冲第一帧开始播放
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			var realDirection:int;
			var realAction:int;
			if(direction==-1) direction=_activeDirection;
			realDirection=direction;
			realAction=action;

			if(actionDataAtk_1==null&&action==TypeAction.SpecialAtk_1)  //当为特殊攻击动作时  但是  特殊攻击数据不存在时  用普通攻击动作代替
			{
				action=TypeAction.Attack;
			}
			else if(actionDataFightStand==null&&action==TypeAction.FightStand)//当为战斗待机动作时  但是  战斗待机数据不存在时  用待机动作代替
			{
				action=TypeAction.Stand;
			}
			else if(actionDataFight==null&&action==TypeAction.Attack) //如果为攻击
			{
				action=TypeAction.Stand;
			}
			else if(actionDataInjureDead==null&&(action==TypeAction.Injure))   //如果 为 受击 或者死亡
			{
				action=TypeAction.Stand;
			}
				
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			var scaleX:Number=1;
			if(direction>5)
			{
				scaleX=-1;
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
				scaleX=1;
			}
			var movieData:MovieData;
			if(action<=2&&actionDataStandWalk)  //普通  动作   包含普通攻击动作
			{
				if(actionDataStandWalk.dataDict[action]) //用于 特殊怪物   //   比较大的怪物 是 只有一个动作的
				{
					movieData=actionDataStandWalk.dataDict[action][direction];
					if(!movieData)  // movieData不存在 
					{
						if(actionDataStandWalk.getDirectionArr(action).length==1)  //只有一个方向
						{
							direction=actionDataStandWalk.getDirectionArr(action)[0];
							if(direction<=5)
							{
								scaleX=1;
							}
							else 
							{
								var copyObj:Object=TypeDirection.getCopyDirection(direction);
								scaleX=copyObj.scaleX;
								direction=copyObj.direction;
							}
							movieData=actionDataStandWalk.dataDict[action][direction];
						}
					}
					if(movieData)
					{
						playInit(movieData,scaleX,loop);
					}
				}
			}
			else if(action==TypeAction.Attack&&actionDataFight)  //普通攻击
			{
				if(actionDataFight.dataDict[action])
				{
					movieData=actionDataFight.dataDict[action][direction];
					if(movieData)
					{
						playInit(movieData,scaleX,loop);
					}
				}
			}
			else if((action==TypeAction.Injure||action==TypeAction.Dead)&&actionDataInjureDead)  //受击死亡
			{
				if(actionDataInjureDead)        //死亡的时候可能没有数据
				{
					if(actionDataInjureDead.dataDict[action])
					{
						movieData=actionDataInjureDead.dataDict[action][direction];
						if(movieData)
						{
							playInit(movieData,scaleX,loop);
						}
					}
					else if(actionDataInjureDead.dataDict[TypeAction.Injure])  //如果没有死亡动作 用   受击动作代替
					{
						movieData=actionDataInjureDead.dataDict[TypeAction.Injure][direction];
						if(movieData)
						{
							playInit(movieData,scaleX,loop);
						}
					}
				}
			}
			else if(action==TypeAction.FightStand) //  战斗待机
			{
				if(actionDataFightStand.dataDict[action])
				{
					movieData=actionDataFightStand.dataDict[action][direction];
					if(movieData)
					{
						playInit(movieData,scaleX,loop);
					}
				}
			}
			else if(action==TypeAction.SpecialAtk_1)  //特殊 攻击动作 1
			{
				if(actionDataAtk_1.dataDict[action])
				{
					movieData=actionDataAtk_1.dataDict[action][direction];
					if(movieData)
					{
						playInit(movieData,scaleX,loop);
					}
				}
			}
			_activeAction=realAction;
			_activeDirection=realDirection;
		}
//		private function initTimer():void
//		{
//			_timer=new Timer(22);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
////			_movieUpdateFunc=new MovieUpdateFunc();
////			_movieUpdateFunc.func=_playTween.update;
//			
//		}
		private function removeTimer():void
		{
//			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
//			_timer.stop();
//			_timer=null;
			MovieUpdateManager.Instance.removeFunc(_playTween.update);
			_isStart=false;
		}
//		private function onTimer(e:TimerEvent):void
//		{
//			_playTween.update();
//		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
			if(!_isStart)
			{
//				_timer.start();
				MovieUpdateManager.Instance.addFunc(_playTween.update);
				_isStart=true;
			}
			
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
			
			if(_isStart)
			{
				_playTween.stop();
//				_timer.stop();
				MovieUpdateManager.Instance.removeFunc(_playTween.update);
				_isStart=false;
			}
			
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=actionDataStandWalk.getActionArr()[0];
			var direction:int=actionDataStandWalk.getDirectionArr(action)[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		/** 播放默认动作
		 */		
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var action:int=actionDataStandWalk.getActionArr()[0];
			play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		/**单纯的停止播放
		 */		
		public function pureStop():void
		{
			_playTween.stop();
		}

		/**
		 * @param index  在 action  direction 的数组中停留在 index 帧上
		 * @param action
		 * @param direction
		 * 
		 */
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			play(action,direction,false,null,null,true);
			_playTween.gotoAndStop(index);
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			removeEvents();
			stop();
			_playTween.dispose();
			removeTimer();
			_playTween=null;
			_completeFunc=null;
			_completeParam=null;
			_movie=null;
			
			actionDataStandWalk=null;
			actionDataAtk_1=null;
			actionDataFightStand=null;
			actionDataInjureDead=null;
			actionDataFight=null;
			
			_preMovieData=null;
			isDisposeToPool=true;
		}
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			actionDataStandWalk=null;
			actionDataAtk_1=null;
			actionDataFightStand=null;
			actionDataInjureDead=null;
			actionDataFight=null;
			_completeFunc=null;
			_completeParam=null;
			_preMovieData=null;
			resetData();
			removeEvents();
			stop();
			isDisposeToPool=true;
		}
		/**对象池中获取数据重新初始化
		 */		
		public function initFromPool():void
		{
			addEvents();
			visible=true;

//			scaleX=1;
//			scaleY=1;
//			x=0;
//			y=0;
			setXYScaleXY(0,0,1,1);
			isDisposeToPool=false;
		}
		
		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台 
		 *   判断该点是否在 Sprite2D对象身上   假如该点透明也就不在身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return _movie.getIntersect(parentPt,parentContainer);
		}

	}
}