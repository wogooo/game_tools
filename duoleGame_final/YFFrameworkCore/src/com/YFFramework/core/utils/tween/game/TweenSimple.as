package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.update.TweenMovingManager;
	import com.YFFramework.core.utils.math.YFMath;
	
	import flash.utils.getTimer;
	
	/**@author yefeng
	 *2012-4-22下午3:56:07
	 */
	public class TweenSimple // extends AbsPool
	{
		
		private static var _pool:Vector.<TweenSimple>=new Vector.<TweenSimple>();
		private static var _poolSize:int=0;
		private static const MaxSize:int=80;
		
		
		
		
		
		
		
		
		
		
		private var _endX:Number;
		private var _endY:Number;
		private var _updateFunc:Function;
		internal var _completeFunc:Function;
		private var _speedX:Number;
		private var _speedY:Number;
		private var _display:Object;
		private var _propX:String;//属性名 可能为  x   或者mapX
		private var _propY:String;//属性名 可能为  y   或者mapY  
		///临时变量
		private var offSetX:Number;
		private var offsetY:Number;
		private var _updateParam:Object;
		private var _completeParam:Object;
		
		
		/**强行终止后调用的函数  _completeFunc没有调用被强行终止dispose后调用
		 */ 
//		private var _breakFunc:Function;
//		/**参数
//		 */		
//		private var _breakParam:Object;
//		/**完成函数_completeFunc 是否是否调用
//		 */		
//		private var _isCompleteTrigger:Boolean;
		
		
		/** 运动速度
		 */
		private var _speed:Number;
		
		/**角度
		 */
		private var _jiaodu:Number;
		private var _forceUpdate:Boolean;
		
		private var _isStart:Boolean;
		
//		private var _timer:Timer;
		
		private var _isDispose:Boolean;
		
		private var _lastTime:Number;
		private var _difTime:Number;
		/**实际上消耗的时间
		 */		
		
		private var _realCostTime:Number;
		
		/// a  b c  三点       b 为目标点    a  为起始点     c 为实际走到的点
		
		//向量   ba
//		private var _baX:Number;
//		private var _baY:Number;
//		//向量 bc 
//		private var _bcX:Number;
//		private var _bcY:Number;
		/**最大使用时间
		 */		
		private var _maxusingTime:Number;
		private var _firstTime:Number;
		public function TweenSimple()
		{
			super();
//			initTimer();
			_isDispose=false;
		}
		
		
		/** 
		 * updateFunc   更新函数 到达目标点后将不执行  而是执行 完成函数
		 * speed为每帧的像素移动值   不基于帧频 ，基于时间
		 * @param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置  
		 * 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		 *  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true  
		 * breakFunc  强行终止函数  当强行终止后 completeFunc 没有调用时调用
		 */
		public function tweenTo(display:Object,propX:String,propY:String,endX:Number,endY:Number,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,updateFunc:Function=null,updateParam:Object=null,forceUpdate:Boolean=false):void
		{
			_isStart=false;
			_display=display;
			_propX=propX;
			_propY=propY;
			_endX=endX;
			_endY=endY;
			_speed=speed;
			_updateFunc=updateFunc;
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			_updateParam=updateParam;
			_forceUpdate=forceUpdate;
//			_baX=_endX-display[propX]+0.0001;
//			_baY=_endY-display[propY]+0.0001;
			
			_maxusingTime=YFMath.distance(_display[_propX],_display[_propY],_endX,_endY)*UpdateManager.IntervalRate/speed;
		}
			
		
		/** 更新速度 
		 */
		public function updateSpeed(speed:Number):void
		{
			_speed=speed;
			updateSpeedXY();
		}
		public function start():void
		{
				_isStart=true;
				_lastTime=getTimer();
				_firstTime=getTimer();
				///当为非同一点时
				if(!(_endY==_display[_propY]&&_endX==_display[_propX]))
				{
					_jiaodu=Math.atan2(_endY-_display[_propY]+0.0001,_endX-_display[_propX]+0.00001); ///加上0.0001是为了防止 分母为 0 
					updateSpeedXY();
					///强制渲染一帧
				//	if(_forceUpdate)update();  //去掉 强制移动一次
					if(!_isDispose)
					{
						_lastTime=getTimer();
//						_timer.start();
						TweenMovingManager.Instance.addFunc(update);
					}
					else finishIt();
				}
				else  
				{
					finishIt();
				}
		}
		private function updateSpeedXY():void
		{
			_speedX=_speed*Math.cos(_jiaodu);
			_speedY=_speed*Math.sin(_jiaodu);
			_speedX=(int(_speedX*100))/100;
			_speedY=(int(_speedY*100))/100;
			_lastTime=getTimer();
			_firstTime=getTimer();
			
			_maxusingTime=YFMath.distance(_display[_propX],_display[_propY],_endX,_endY)*UpdateManager.IntervalRate/_speed;
		}
		
		
		
//		private function initTimer():void
//		{
//			_timer=new Timer(UpdateManager.IntervalRate);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
//		}
//		private function removeTimer():void
//		{
//			_timer.removeEventListener(TimerEvent.TIMER,onTimer);
//			_timer.stop()
//			_timer=null;
			
//			TweenMovingManager.Instance.removeFunc(update);
//		}
//		private function onTimer(e:TimerEvent):void
//		{
//			update();
//		}
		
		public function stop():void
		{
			_isStart=false;
//			_timer.stop();
			TweenMovingManager.Instance.removeFunc(update);
			_lastTime=getTimer();
		}
		
		private function update():void
		{
			if(_isStart) 
			{
					_difTime=getTimer()-_lastTime;
					_lastTime=getTimer();
					_realCostTime=_difTime*UpdateManager.UpdateRatePer;//_difTime/UpdateManager.IntervalRate;
					if(_lastTime-_firstTime<_maxusingTime)
					{
						_display[_propX] +=_speedX*_realCostTime;
						_display[_propY] +=_speedY*_realCostTime;
						if(_updateFunc!=null) _updateFunc(_updateParam);  
					}
					else 
					{
						_display[_propX]=_endX;
						_display[_propY]=_endY;
						if(_updateFunc!=null) _updateFunc(_updateParam);  
						finishIt();
					}
			}
		}
		
		private function finishIt():void
		{
			if(_completeFunc!=null) _completeFunc(_completeParam);
			if(!_isDispose)
			{
				stop();
				_completeFunc=null;
				_updateFunc=null;
				_completeParam=null;
				_updateParam=null;
			}
		}
		
		public function dispose():void
		{
//			if(!_isDispose)
//			{
//				_isDispose=true;
//				TweenMovingManager.Instance.removeFunc(update);
//				_isStart=false;
//				removeTimer();
//				_completeFunc=null;
//				_updateFunc=null;
//				_completeParam=null;
//				_updateParam=null;
//			}
			if(!_isDispose)
			{
				_isDispose=true;
				disposeToPool();
			}
		}
		
		private function disposeToPool():void
		{
			_isStart=false;
			TweenMovingManager.Instance.removeFunc(update);
//			removeTimer();
			_completeFunc=null;
			_updateFunc=null;
			_completeParam=null;
			_updateParam=null;

		}

		
		public static function toPool(tweenSimple:TweenSimple):void
		{
			if(_poolSize<MaxSize)
			{
				tweenSimple.disposeToPool();
				_pool.push(tweenSimple);
				_poolSize++;
			}
			else 
			{
				tweenSimple.dispose();
			}
		}
		
		public static function getTweenSimple():TweenSimple
		{
			if(_poolSize>0)
			{
				_poolSize--;
				return _pool.pop();
			}
			return new TweenSimple();
		}
		
	}
}