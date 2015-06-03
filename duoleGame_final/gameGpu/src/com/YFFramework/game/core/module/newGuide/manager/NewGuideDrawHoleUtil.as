package com.YFFramework.game.core.module.newGuide.manager
{
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**新手 引导 
	 *  具有模态的  扣洞工具
	 * @author yefeng
	 * 2013 2013-7-3 上午11:21:26 
	 */
	public class NewGuideDrawHoleUtil
	{
		private static const MaxW:int=2000;
		private static const MaxH:int=1500;
		public function NewGuideDrawHoleUtil()
		{
		}
		 
		
		/**挖洞 
		 * 返回movie
		 */		
		public static function drawHole(x:Number,y:Number,w:Number,h:Number,relativeSp:Sprite):NewGuideMovieClip
		{
			var newGuideClip:NewGuideMovieClip=new NewGuideMovieClip();
			newGuideClip.start();
//			newGuideClip.hideButtonEffectView();
			PopUpManager.addPopUp(newGuideClip,LayerManager.NewGuideLayer,x,y,0xFFFFFF,0.1,clickFunc,{x:x,y:y,w:w,h:h},new Rectangle(x,y,w,h));
			newGuideClip.initTweenRect(x,y,w,h,MaxW,MaxH,null,null,relativeSp);
			newGuideClip.resizeCall=resizeIt
			return newGuideClip;
		}
		private static function resizeIt(newGuideClip:NewGuideMovieClip,x:Number,y:Number,w:Number,h:Number):void
		{
			PopUpManager.addPopUp(newGuideClip,LayerManager.NewGuideLayer,x,y,0xFFFFFF,0.1,clickFunc,{x:x,y:y,w:w,h:h},new Rectangle(x,y,w,h));
		}
		
		
		/**使用  NewGuideMovieClipWidthArrow单例 进行挖洞引导
		 */
		public static function drawHoleByNewGuideMovieClipWidthArrow(x:Number,y:Number,w:Number,h:Number,direction:int,relativeSp:DisplayObject):void
		{
			PopUpManager.addPopUp(NewGuideMovieClipWidthArrow.Instance,LayerManager.NewGuideLayer,0,0,0xFFFFFF,0.1,clickFunc,{x:x,y:y,w:w,h:h},new Rectangle(x,y,w,h));
			NewGuideMovieClipWidthArrow.Instance.initRect(x,y,w,h,direction,relativeSp); //
			NewGuideMovieClipWidthArrow.Instance.resizeCall=newGuideResizeCall;
		} 
		/**resizeCall 
		 */
		private static function newGuideResizeCall(x:Number,y:Number,w:Number,h:Number,direction:int,relativeSp:DisplayObject):void
		{
			drawHoleByNewGuideMovieClipWidthArrow(x,y,w,h,direction,relativeSp);
		}


		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
		/**单击事件
		 */
		private static function clickFunc(obj:Object):void
		{
			var x:Number=obj.x;
			var y:Number=obj.y;
			var w:Number=obj.w;
			var h:Number=obj.h;
			var newGuideClip:NewGuideMovieClip=new NewGuideMovieClip();
			PopUpManager.addPopUp(newGuideClip,LayerManager.NewGuideLayer,x,y);
			newGuideClip.start();
			newGuideClip.initTweenRect(x,y,w,h,MaxW,MaxH,completeIt,[newGuideClip]);
		}
		private static function completeIt(newGuideClip:NewGuideMovieClip):void
		{
			PopUpManager.removePopUp(newGuideClip);
		}
		
		

	}
}