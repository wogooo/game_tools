package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**  滚动条  人物血槽 等等
	 * 2012-10-10 下午2:01:59
	 *@author yefeng
	 */
	public class GameProgressBar extends AbsView
	{
		/**遮罩层
		 */ 
		private var _maskBg:Shape;
		/**  具体的内容 也就是要遮罩的内容
		 */ 
		private var _mc:MovieClip;
		public function GameProgressBar()
		{
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_mc=ClassInstance.getInstance("progressBarSkin1") as MovieClip;
			addChild(_mc);
			initMask(_mc.bar.width,_mc.bar.height);
			_mc.addChild(_maskBg);
			_mc.bar.mask=_maskBg;

		}
		private function initMask(width:int,height:int):void
		{
			_maskBg=new Shape();
			Draw.DrawRect(_maskBg.graphics,width,height);
		}
		/** 设置 进度条的百分比
		 */		
		public function setPercent(value:Number):void
		{
			if(value<0)value=0;
			if(value>1)value=1;
			_maskBg.scaleX=value;
		}
		override public function dispose(e:Event=null):void
		{
			if(_maskBg)_maskBg.graphics.clear();
			super.dispose(e);
			_maskBg=null;
			_mc=null;
		}

		
	}
}