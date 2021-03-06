package atfMovie
{
	import com.YFFramework.core.center.update.MovieUpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.tween.TweenYF2dSkillPlay;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	
	import data.ATFActionData;
	import data.ATFMovieData;
	
	import flash.geom.Point;
	
	public class ATFSkillEffect extends ATFClip
	{
		public var actionData:ATFActionData;
		
		
		
		protected var _playTween:TweenATFPlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;
		
		//		private var _timer:Timer;
		private var _isStart:Boolean;
		
		/**重新 创建材质时  的缓存
		 */ 
		protected var _preMovieData:ATFMovieData;
		private var _preScaleX:Number;
		private var _preLoop:Boolean;
		private var _preLoopTime:int;
		
		
		
		/**当前播放的 动作
		 */
		public var playAction:int =-1;
		
		/**当前播放的方向
		 */
		public var playDirection:int = -1;

		
		public function ATFSkillEffect()
		{
			mouseChildren=false;
			addEvents();
		}
		public function initData(data:ATFActionData):void
		{
			if(actionData!=data)
			{
				actionData=data;
//				if(actionData)
//				{
//					blendMode=actionData.getBlendMode();
//					if(actionData.getSkillRandomRotate()) ///随机旋转的受击技能   需要抬高技能
//					{
//						rotationZ=Math.round(Math.random()*360);
//						//						y=-BgMapScrollport.HeroHeight*0.5;  ///
//						setY(-BgMapScrollport.HeroHeight*0.5);
//					}
//					else 
//					{
//						rotationZ=0;
//					}
//				}
			}
		}
		
		
		override protected function initUI():void
		{
			super.initUI();
			_playTween=new TweenATFPlay();
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
				_movie.setFlashTexture(_preMovieData.getTexture()); 
				///重新播放
				playInit(_preMovieData,_preScaleX,_preLoop,_preLoopTime);
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
		protected function playInit(movieData:ATFMovieData,scaleX:Number,loop:Boolean=true,loopTime:int=1):void
		{
			_preMovieData=movieData;
			//			_preFrameRate=frameRate;
			_preScaleX=scaleX;
			_preLoop=loop;
			_playTween.initData(movieData,scaleX,loop);
			_playTween.start();
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
			var movieData:ATFMovieData;
			if(actionData)  //普通  动作   包含普通攻击动作
			{
				if(actionData.dataDict[action])
				{
					movieData=actionData.dataDict[action][direction];
					if(movieData)
					{ 
						
						playAction = action;
						playDirection = direction;
						
						///设置像素源
						_movie.setAtlas(movieData.bitmapData);
						///设置贴图
						_movie.setFlashTexture(movieData.getTexture());
						playInit(movieData,scaleX,loop,actionData.getLoopTime());
					}
				}
			}
		}
		//		private function initTimer():void
		//		{
		//			_timer=new Timer(25);
		//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
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
				//		_timer.stop();
				MovieUpdateManager.Instance.removeFunc(_playTween.update);
				_isStart=false;
			}
			
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
			else 
			{
				if(completeFunc!=null)	completeFunc(completeParam);
			}
			
		}
		
		/** 播放默认动作
		 */		
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
			else 
			{
				if(completeFunc!=null)	completeFunc(completeParam);
			}
		}
		
		/**单纯的停止播放
		 */		
		public function pureStop():void
		{
			_playTween.stop();
		}
		
		public function getPlayTween():TweenATFPlay
		{
			return _playTween;
		}

		/**
		 * @param index  在 action  direction 的数组中停留在 index 帧上
		 * @param action
		 * @param direction
		 * 
		 */
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			play(action,direction,false);
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
			actionData=null;
			_completeFunc=null;
			_completeParam=null;
			_movie=null;
			_preMovieData=null;
		}
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			actionData=null;
			_completeFunc=null;
			_completeParam=null;
			_preMovieData=null;
			resetData();
			removeEvents();
			stop();
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
		}
		
		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台 
		 *   判断该点是否在 Sprite2D对象身上   假如该点透明也就不在身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return _movie.getIntersect(parentPt,parentContainer);
		}		}
}