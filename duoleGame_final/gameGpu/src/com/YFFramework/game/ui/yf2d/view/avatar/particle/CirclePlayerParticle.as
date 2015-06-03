package com.YFFramework.game.ui.yf2d.view.avatar.particle
{
	import com.YFFramework.core.center.update.TweenMovingManager;
	import com.YFFramework.core.utils.math.YFMath;

	/** 圆形引导器
	 * @author yefeng
	 * 2013 2013-12-21 下午4:23:46 
	 */
	public class CirclePlayerParticle
	{
		
		
		
		/** degree步长
		 */
		private static const DegreeStep:int=1;
		/**圆形半径
		 */
		private var _cicle:int;
		
		/**运动速度
		 */
//		private var _speed:Number;
		
		private var _start:Boolean;
		private var _mapX:Number;
		private var _mapY:Number;
		private var _circleX:Number;
		private var _circleY:Number;
		
		private var _degree:Number;
		private var _rad:Number;
		
		/**带有 x ,y ，角度 degree  三个参数
		 */
		public var updateCallBack:Function;
		/**播放完成时候的回调
		 */
		public var completeCallBack:Function;
		public function CirclePlayerParticle()
		{
		}
		/**
		 * @param mapX  是原点x 
		 * @param mapY	是原点Y
		 * @param speed 运动速度
		 * @param cicle  环绕半径
		 */
		public function initData(mapX:Number,mapY:Number,cicle:int):void
		{
			_circleX=mapX;
			_circleY=mapY
			_cicle=cicle;
			_start=false;
			_degree=0;
		}
		public function start():void
		{
			if(!_start)
			{
				_start=true;	
				TweenMovingManager.Instance.addFunc(update);
			}
		}
		public function stop():void
		{
			if(_start)
			{
				_start=false;
				TweenMovingManager.Instance.removeFunc(update);
			}
		}
		//  x =mapX+ circle*cosDegree
		private function update():void
		{
			if(_start)
			{
				if(_degree<=360)
				{
					_degree++;
					_rad=YFMath.degreeToRad(_degree);
					_mapX=_circleX+_cicle*Math.cos(_rad);
					_mapY=_circleY+_cicle*Math.sin(_rad);
					updateCallBack(this,_mapX,_mapY,_degree);
				}
				else 
				{
					completeCallBack(this);
					dispose();
				}
			}
		}
		public function dispose():void
		{
			stop();
			updateCallBack=null;
		}
			
	}
}