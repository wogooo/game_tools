package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.utils.math.MathConvertion;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.IconImage;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;

	/***
	 *图标移动类
	 *@author ludingchang 时间：2013-12-12 下午5:33:08
	 */
	public class IconMoveUtil
	{
		/**缓动从集中位置到包裹图标的时间*/
		private static const MoveTime2:Number=.3;
		/**停顿时间*/
		private static const DelayTime:Number=0.3;
		/**缓动从屏幕上各个位置移动到集中点的移动速度*/
		private static const MoveSpeed:Number=300;
		/**
		 *把图标移动到包裹那里（用于领取奖励） 
		 * @param icons 里面存的是<code>iconImage</code>
		 * 
		 */		
		public static function MoveIconToBag(icons:Array):void
		{
			var i:int,len:int=icons.length;
			var tar:Point=GameViewPositonProxy.getMovePivot();
			for(i=0;i<len;i++)
			{
				var _icon:IconImage=icons[i];
				var icon:IconImage=new IconImage;
				icon.url=_icon.url;
				var pos:Point=UIPositionUtil.getPosition(_icon,LayerManager.UIViewRoot);
				icon.x=pos.x;
				icon.y=pos.y;
				var distence:Number=MathConvertion.distance(tar,pos);
				var move_time:Number=distence/MoveSpeed;
				LayerManager.DisableLayer.addChild(icon);
				TweenLite.to(icon,move_time,{x:tar.x,y:tar.y,onComplete:onMoveTogether,onCompleteParams:[icon]});
			}
			
			function onMoveTogether(icon:IconImage):void
			{
				var bagX:int=GameViewPositonProxy.BagX;
				var bagY:int=GameViewPositonProxy.BagY;
				TweenLite.to(icon,MoveTime2,{delay:DelayTime,x:bagX,y:bagY,onComplete:onComp,onCompleteParams:[icon]});
			}
			
			function onComp(icon:IconImage):void
			{
				TweenLite.killTweensOf(icon);
				icon.parent.removeChild(icon);
				icon.dispose();
			}
		}
	}
}