package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.graphic.ShapeMovieClip;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;

	/**@author yefeng
	 * 2013 2013-3-21 上午9:46:17 
	 * 所有的文字提示 调用累
	 */
	public class NoticeUtil{
		
		public function NoticeUtil(){
		}
		
		/**操作 成功 或者失败的文字提示 
		 */
		public static function setOperatorNotice(str:String):void{
			LayerManager.NoticeLayer.setOperatorNotice(str);
		}
		
		/**双击地面提示 取消自动寻路 
		 */
		public static function setClickNotice(str:String,x:Number,y:Number):void{
			LayerManager.NoticeLayer.setClickNotice(str,x,y);
			
		}
		
		/** 播放特效
		 */		
		public static function playEffect(actionData:ActionData,loop:Boolean=false):void
		{
			LayerManager.NoticeLayer.playCommonEffect(actionData,loop);
		}
		
		/**接受任务特效
		 */		
		public static  function playAcceptTask():void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.AcceptTaskEffect) as ActionData;
			if(actionData)
			{
				playEffect(actionData);
			} 
			else SourceCache.Instance.loadRes(CommonEffectURLManager.AcceptTaskEffect);
		}
		/**完成任务特效
		 */		
		public static  function playFinishTask():void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.FinishTaskEffect) as ActionData;
			if(actionData)
			{
				playEffect(actionData);
			}
			else SourceCache.Instance.loadRes(CommonEffectURLManager.FinishTaskEffect);	
		}
		/**开启新功能测试
		 */
		public static function playNewFuncOpenEffect(x:Number,y:Number):void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(CommonEffectURLManager.NewFuncOpenFuncEffectUrl) as ActionData;
			if(actionData)
			{
				LayerManager.NoticeLayer.playEffect(actionData,false,x,y);
			}
			else SourceCache.Instance.loadRes(CommonEffectURLManager.NewFuncOpenFuncEffectUrl);	

		}
		
	}
}