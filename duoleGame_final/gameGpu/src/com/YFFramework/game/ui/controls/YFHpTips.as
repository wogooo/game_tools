package com.YFFramework.game.ui.controls
{
	/**人物血量提示  当人物血量过少时    游戏界面四周 会泛红  提示玩家 血量 过少 
	 * @author yefeng
	 *2012-10-21下午9:56:07
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.YFStyle;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class YFHpTips extends Bitmap
	{
		public function YFHpTips()
		{
			super(null, "auto", false);
			initUI();
			ResizeManager.Instance.regFunc(resize);
			resize();
			cacheAsBitmap=true;
		}
		/**初始化ui 
		 */		
		protected function initUI():void
		{
			smoothing=true;
			var style:YFStyle=YFSkin.Instance.getStyle(YFSkin.HpTips);
			var data:BitmapData=style.link as BitmapData;
			bitmapData=data;
		}
		private function resize():void
		{
			width=StageProxy.Instance.stage.stageWidth;
			height=StageProxy.Instance.stage.stageHeight;
		}
		
		public function show():void
		{
			reset();
			tweenIt();
			if(!LayerManager.RootView.contains(this)) LayerManager.RootView.addChild(this);
		}
		
		private function tweenIt():void
		{
			var myAlpha:Number;
			if(alpha<=0.2) myAlpha=0.5;
			else myAlpha=0.2;
			TweenLite.to(this,2,{alpha:myAlpha,onComplete:complete});
		}
		public function reset():void
		{
			alpha=0.5;
		}
		private function complete ():void
		{
			tweenIt();
		}
		public function hide():void
		{
			TweenLite.killTweensOf(this);
			if(LayerManager.RootView.contains(this)) LayerManager.RootView.removeChild(this);
		}
		
		
	}
}