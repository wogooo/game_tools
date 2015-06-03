package com.YFFramework.game.core.module.sceneUI.view
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.events.EventDispatcher;

	/**后台 偷偷加载控制器
	 * @author yefeng
	 * 2013 2013-6-26 下午4:14:06 
	 */
	public class HideLoadingView
	{
		/**表情face.swf 等待60秒后进行加载
		 */		
		private static const  FaceSWFWaitingTime:int=1000*60;// 表情swf 等待30秒后进行加载
		/**75秒后进行个人技能的 加载
		 */		
		private var SkillWaitingTime:int=1000*75;// 
		public function HideLoadingView()
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
		}
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			//加载 表情 swf 
			var faceSwfWaitTime:TimeOut=new TimeOut(FaceSWFWaitingTime,faceSwfLoad);
			faceSwfWaitTime.start();
		}
		/**  加载 表情swf
		 */		
		private function faceSwfLoad(obj:Object):void
		{
			var dispath:EventDispatcher=new EventDispatcher(); 
			dispath.addEventListener(CommonEffectURLManager.FaceURL,onComplete);
			SourceCache.Instance.loadRes(CommonEffectURLManager.FaceURL,null,SourceCache.ExistAllScene,null,{dispatcher:dispath},false);
		}
		private function onComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			var dispath:EventDispatcher=e.currentTarget as EventDispatcher;
			dispath.removeEventListener(url,onComplete);
			RichText.resLoadComplete=true;
		}
			
		
		
	}
}