package com.YFFramework.game.core.global.util
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;

	/**滤镜工具
	 * @author yefeng
	 * 2013 2013-7-17 下午3:18:41 
	 */
	public class GlowFilterUtil
	{
		public function GlowFilterUtil()
		{
		}
		
		/** 给显示对象添加滤镜 显示发光效果
		 */		
		public static function GlowDisplay(mc:DisplayObject,color:int=0xFFFF00,complete:Function=null,completeparams:Array=null):void
		{
			mc.filters=[new GlowFilter(color,1,18,18,2)];
			TweenMax.to(mc, 0.3, {glowFilter:{color:color, alpha:1, blurX:30, blurY:30, strength:2},onComplete:completeGlow,onCompleteParams:[mc,color,complete,completeparams]});
		}
		private static function completeGlow(mc:DisplayObject,color:int,complete:Function=null,completeparams:Array=null):void
		{
			TweenMax.to(mc, 1, {glowFilter:{color:color, alpha:1, blurX:5, blurY:5, strength:1},onComplete:complete,onCompleteParams:completeparams});
		}
		
		
		/**放大对象至消失
		 * @param mc
		 * @param color
		 * @param complete
		 * @param completeparams
		 * 
		 */		
		public static function GlowDisplayToScaleBigDisappear(mc:DisplayObject,color:int=0xFFFF00,complete:Function=null,completeparams:Array=null):void
		{
			var mY:int=mc.y-500;
			var myScale:Number=5;
			TweenMax.to(mc, 0.2, {glowFilter:{color:color, alpha:1, blurX:50, blurY:50, strength:2,alpha:0,y:mY},scaleX:myScale,scaleY:myScale,onComplete:complete,onCompleteParams:completeparams});
		}
		
	}
}