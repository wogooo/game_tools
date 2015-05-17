package com.YFFramework.core.ui.yf2d.view.avatar
{
	import com.YFFramework.core.utils.math.YFMath;

	/**2012-11-21 上午10:53:40
	 *@author yefeng
	 */
	public class ThingRotateEffect2DView extends ThingEffect2DView
	{
		public function ThingRotateEffect2DView()
		{
			super();
		}
		/**
		 * @param mapX  地图坐标
		 * @param mapY   地图坐标
		 * @param speed
		 * @param completeFunc
		 * @param completeParam
		 * 
		 */		
		override public function moveTo(mapX:int,mapY:int,speed:int=4,completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false, breakFunc:Function=null, breakParam:Object=null):void
		{
			var myRotate:Number=YFMath.getDegree(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY)+180;///  该动画的 起始方向是向左 的 所以要加上180
			rotationZ=myRotate;
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePostion,null,forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		}
		
		override public function reset():void
		{
			super.reset();
			rotationZ=0;
		}
	}
}