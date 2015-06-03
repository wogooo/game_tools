package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-19 上午11:31:33
	 */
	public class EffectHandle{
		
		private var _bitmap:Bitmap=new Bitmap();
		
		public function EffectHandle(){
		}
		
		public function playFightState(isFighting:Boolean):void{
			_bitmap.alpha=0;
			if(isFighting)	_bitmap.bitmapData = ClassInstance.getInstance("enter_fight");
			else	_bitmap.bitmapData = ClassInstance.getInstance("leave_fight");
			
			LayerManager.NoticeLayer.addChild(_bitmap);
			_bitmap.x = StageProxy.Instance.stage.stageWidth;
			_bitmap.y = StageProxy.Instance.stage.stageHeight-300;
			TweenLite.to(_bitmap,0.5,{alpha:1,x:_bitmap.x-200,ease:Cubic.easeOut,onComplete:onComplete});
		}
		
		private function onComplete():void{
			setTimeout(onLeave,500);
		}
		
		private function onLeave():void{
			if(LayerManager.NoticeLayer.contains(_bitmap)){
				LayerManager.NoticeLayer.removeChild(_bitmap);
			}
		}
		
	}
} 