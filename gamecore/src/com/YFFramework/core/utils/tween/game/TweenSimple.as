package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.AbsPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.debug.print;
	
	/**@author yefeng
	 *2012-4-22下午3:56:07
	 */
	public class TweenSimple extends AbsPool
	{
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
		/** 运动速度
		 */
		private var _speed:Number;
		
		/**角度
		 */
		private var _jiaodu:Number;
		private var _forceUpdate:Boolean;
		public function TweenSimple()
		{
			
		}
		
		
		/** 
		 * updateFunc   更新函数 到达目标点后将不执行  而是执行 完成函数
		 * speed为每帧的像素移动值   不基于帧频 ，基于时间
		 * @param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置  
		 * 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		 *  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true  
		 */
		public function tweenTo(display:Object,propX:String,propY:String,endX:Number,endY:Number,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,updateFunc:Function=null,updateParam:Object=null,forceUpdate:Boolean=false):void
		{
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
			///当为非同一点时
			if(!(_endY==_display[_propY]&&_endX==_display[_propX]))
			{
				_jiaodu=Math.atan2(_endY-_display[_propY],_endX-_display[_propX]);
				updateSpeedXY();
//				print(this,"角度",_jiaodu,"mapX ,,mapY:"+_display[_propX],_display[_propY],"endX,endY:",_endX,_endY,"speedX,speedY:",_speedX,_speedY);
		
				///强制渲染一帧
				if(_forceUpdate)update();
				
				UpdateManager.Instance.framePer.regFunc(update);

			}else 
			{
				if(_completeFunc!=null) _completeFunc(_completeParam);
				UpdateManager.Instance.framePer.delFunc(update);
				dispose();
			}
		}
		private function updateSpeedXY():void
		{
		//	var valueX:Number=
		//	var valueY:Number=
			_speedX=_speed*Math.cos(_jiaodu);
			_speedY=_speed*Math.sin(_jiaodu);
			_speedX=(int(_speedX*100))/100;
			_speedY=(int(_speedY*100))/100;
		}
		
		public function stop():void
		{
			UpdateManager.Instance.framePer.delFunc(update);
		}
		private function update():void
		{
			if(_display)
			{
				_display[_propX] +=_speedX;
				_display[_propY] +=_speedY;
				offSetX=Math.abs(_endX-_display[_propX])-Math.abs(_speedX);
				offsetY=Math.abs(_endY-_display[_propY])-Math.abs(_speedY);
				if(offSetX<0)	_speedX=_endX-_display[_propX];
				if(offsetY<0)	_speedY=_endY-_display[_propY];
				if(_updateFunc!=null) _updateFunc(_updateParam);  
				//		print(this,"mapX ,,mapY:"+_display[_propX],_display[_propY],"endX,endY:",_endX,_endY,"speedX,speedY:",_speedX,_speedY);
				if(_display[_propX]==_endX&&_display[_propY]==_endY)
				{
					if(_completeFunc!=null) _completeFunc(_completeParam);
					UpdateManager.Instance.framePer.delFunc(update);
					dispose();
				}	
			}		 
		}
		public function dispose():void
		{
			stop();
			_completeFunc=null;
			_updateFunc=null;
		}
		
		
		
		/**注册对象池
		 */		
		override protected function regObject():void
		{
			regPool(100);
		}
		/**子类重写
		 * 重置对象至初始状态
		 */		
		override public function reset():void
		{
			stop();
			_updateFunc=null
			_completeFunc=null;
			_display=null
			_propX=null
			_propY=null  
			_updateParam=null
			_completeParam=null
		}
		/**子类重写
		 * 池对象的 构造函数
		 ** @param obj
		 */		
		override public function constructor(obj:Object):IPool
		{
			_isPool=false;
			return this;
		} 
		
		
	}
}