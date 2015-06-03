package com.YFFramework.game.core.global.view.ui
{
	/**光效UI 
	 * @author yefeng
	 * 2013 2013-11-7 下午5:16:04 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.display.Sprite;
	
	public class UIEffectView extends BitmapMovieClip
	{
		
		/**显示 宽
		 */
		public var showWidth:Number=0;
		/**显示 高
		 */	
		public var showHeight:Number=0;
		private static var _loaded:Boolean=false;
		
		public var myWidth:int;
		public var myHeight:int;
		public function UIEffectView(url:String,mWidth:int,mHeiht:int)
		{
			super();
			myWidth=mWidth;
			myHeight=mHeiht;
			mouseChildren=mouseEnabled=false;
			if(!_loaded)
			{
				loadMovie(url);
			}
			else 
			{
				initPlay(url);
			}
		}
		
		private function loadMovie(url:String):void
		{
			addEventListener(url,onEffectComplete);
			SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this},false);
		}
		private function onEffectComplete(e:ParamEvent):void
		{
			_loaded=true;
			var url:String=e.type;
			removeEventListener(url,onEffectComplete);
			initPlay(url);
		}
		private function initPlay(url:String):void
		{
			if(!_isDispose)
			{
				start();
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				initData(actionData);
				playDefault();
				if(showWidth>0)
				{
					scaleX=showWidth/myWidth;
				}
				if(showHeight>0)
				{
					scaleY=showHeight/myHeight;
				}
			}
		}
		
		
	}
}