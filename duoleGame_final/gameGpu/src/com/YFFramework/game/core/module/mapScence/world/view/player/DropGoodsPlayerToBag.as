package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**@author yefeng
	 * 2013 2013-8-29 下午3:57:22 
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**  物品掉落 进入背包
	 */
	public class DropGoodsPlayerToBag extends AbsView
	{
		
		private static const Speed1:int=700; 
		
		private static const Speed2:int=800;
 
		
		private var  _bitmap:Bitmap; 
		public function DropGoodsPlayerToBag()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_bitmap=new Bitmap();
			addChild(_bitmap);
		}
		/**
		 * @param bitmapData
		 * @param flashX    flash坐标系下的 绝对坐标
		 * @param flashY	flash坐标系下的 绝对坐标 
		 * 
		 */
		public function initData(bitmapData:BitmapData,flashX:Number,flashY:Number):void
		{
			this.x=flashX;
			this.y=flashY;
			_bitmap.bitmapData=bitmapData;
			
//			var pivotX:Number=GameViewPositonProxy.BagX;
//			var pivotY:Number=flashY; 
//			print(this,GameViewPositonProxy.BagX,GameViewPositonProxy.BagY,flashX,flashY)
//			var centerX:Number=(flashX+GameViewPositonProxy.BagX)*0.5;
//			var centerY:Number=(flashY+GameViewPositonProxy.BagY)*0.5;
//			var len:int=100;
//			var pivot:Point;
//			var degree:Number=YFMath.getDegree(GameViewPositonProxy.BagX,GameViewPositonProxy.BagY,flashX,flashY);
//			var rotation:Number;
//			if(flashX>=GameViewPositonProxy.BagX) //向右 滑动
//			{
//				degree=degree-90;
//				pivot=YFMath.getLinePoint4(centerX,centerY,len,degree);
//				rotation=-90;
//			}
//			else    
//			{
//				degree=degree+90;
//				pivot=YFMath.getLinePoint4(centerX,centerY,len,degree);
//				rotation=+90;
//			}
//			
//			TweenMax.to(this, 1, {bezierThrough:[{x:pivot.x, y:pivot.y}, {x:GameViewPositonProxy.BagX, y:GameViewPositonProxy.BagY}], orientToBezier:true,rotation:rotation, ease:Linear.easeNone,onComplete:completeIt});
			
			
			
			var pivot:Point=GameViewPositonProxy.getMovePivot();
			var dif1:Number=YFMath.distance(flashX,flashY,pivot.x,pivot.y);
			var time1:Number=dif1/Speed1;
			TweenLite.to(this,time1,{x:pivot.x,y:pivot.y,onComplete:omComplete});
		} 
		 
		/**完成
		 */
		private function omComplete():void
		{
			var pivot:Point=GameViewPositonProxy.getMovePivot();
			var dif1:Number=YFMath.distance(GameViewPositonProxy.BagX,GameViewPositonProxy.BagY,pivot.x,pivot.y);
			var time1:Number=dif1/Speed2;
			TweenLite.to(this,time1,{x:GameViewPositonProxy.BagX,y:GameViewPositonProxy.BagY,onComplete:completeIt,delay:0.1}); 
		}
		
		private function completeIt():void
		{
			if(parent)parent.removeChild(this);
			dispose();
			_bitmap=null;
		}
	}
}