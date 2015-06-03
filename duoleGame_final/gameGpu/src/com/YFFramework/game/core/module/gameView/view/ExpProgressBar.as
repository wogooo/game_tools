package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.ui.utils.Draw;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**经验条
	 * @author yefeng
	 * 2013 2013-4-7 下午2:46:09 
	 */
	public class ExpProgressBar
	{
		
		/**遮罩
		 */		
		private var _maskShape:Shape;
		/**  经验条 mc 
		 */		
		private var _mc:Sprite;
		private var _expTF:TextField;
		public function ExpProgressBar(mainUI:MovieClip)
		{
			_mc=mainUI.UI_buttom.progressBar;
			_expTF=mainUI.UI_buttom.expTF;
			_expTF.mouseEnabled=false;
			initUI();
		}
		/**初始化ui
		 */		
		private function initUI():void
		{
			_maskShape=new Shape();
			_mc.parent.addChild(_maskShape);
			_maskShape.x=_mc.x;
			_maskShape.y=_mc.y-10;
			Draw.DrawRect(_maskShape.graphics,_mc.width,_mc.height+50,0xFF0000);
			_mc.mask=_maskShape;
		}
		/**设置百分比
		 */		
		public function setPercent(percent:Number):void
		{
			if(percent<0)percent=0;
			if(_maskShape.scaleX>percent)  ///升级
			{
				TweenLite.to(_maskShape,0.25,{scaleX:1,onComplete:completeScale,onCompleteParams:[percent]});
			}
			else 
			{
				TweenLite.to(_maskShape,0.5,{scaleX:percent});
			}
			_expTF.text=int(percent*100)+"%";
		}
		private function completeScale(percent:Number):void
		{
			_maskShape.scaleX=0;
			TweenLite.to(_maskShape,0.25,{scaleX:percent});
		}
	}
}