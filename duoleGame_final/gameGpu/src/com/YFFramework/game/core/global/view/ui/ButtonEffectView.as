package com.YFFramework.game.core.global.view.ui
{
	/**@author yefeng
	 * 2013 2013-12-5 下午6:12:47 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.core.utils.net.SWFData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	
	/**按钮环绕光效
	 */
	public class ButtonEffectView extends AbsView
	{
		/**宽
		 */
		private static const Width:int=105;
		/**高 
		 */
		private static const Height:int=46;
		
		public static const OffsetX:int=12;

		public static const OffsetY:int=14;
		
		public function ButtonEffectView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			var swfData:SWFData=SourceCache.Instance.getRes2(CommonEffectURLManager.ButtonEffectURL) as SWFData;
			if(swfData)
			{
				initSWFData(swfData);
			}
			else 
			{
//				SourceCache.Instance.addEventListener(CommonEffectURLManager.ButtonEffectURL,onButtonEffectUrl);
				this.addEventListener(CommonEffectURLManager.ButtonEffectURL,onButtonEffectUrl);
				SourceCache.Instance.loadRes(CommonEffectURLManager.ButtonEffectURL,null,SourceCache.ExistAllScene,null,{dispatcher:this},false,true);
			}
		}
//		private function onButtonEffectUrl(e:YFEvent):void
		private function onButtonEffectUrl(e:ParamEvent):void
		{
//			SourceCache.Instance.removeEventListener(CommonEffectURLManager.ButtonEffectURL,onButtonEffectUrl);
			this.removeEventListener(CommonEffectURLManager.ButtonEffectURL,onButtonEffectUrl);
			var swfData:SWFData=SourceCache.Instance.getRes2(CommonEffectURLManager.ButtonEffectURL) as SWFData;
			initSWFData(swfData);
		}
		
		private function initSWFData(swfData:SWFData):void
		{
			if(!_isDispose&&swfData)
			{
				var mc:MovieClip=swfData.getMovieClip();
				var movieClipPlayer:MovieClipPlayer=new MovieClipPlayer(mc,30);
				movieClipPlayer.playDefault();
				addChild(movieClipPlayer);
				blendMode=BlendMode.ADD;
			}
		}
		public function setShowSize(showWidth:Number,showHeight:Number):void
		{
			scaleX=showWidth/Width;
			scaleY=showHeight/Height;
		}
		
	}
}