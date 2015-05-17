package com.YFFramework.core.world.movie.thing
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.math.YFMath;
	
	import mx.utils.NameUtil;

	/** 该类具有旋转方向     该类的技能默认是水平相左的   为X轴负向的  技能类
	 * @author yefeng
	 *2012-9-12下午8:11:01
	 */
	public class ThingRotateEffectView extends ThingEffectView
	{
		public function ThingRotateEffectView()
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
			rotation=myRotate;
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePostion,null,forceUpdate,breakFunc,breakParam);
			_tweenSimple.start();
		}
		
		override public function reset():void
		{
			super.reset();
			rotation=0;
		}
		
	}
}