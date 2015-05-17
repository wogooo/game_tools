package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 * 2013 下午4:37:38 
	 */
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	public class YFCustomScroller extends YFComponent
	{
		private var _targetSp:DisplayObject;
		private var _maskShape:Shape;
		private var _heigth:Number;
		private var _upArrow:DisplayObject;
		private var _downArrow:DisplayObject;
		private var _vTrack:DisplayObject;
		private var _vBar:DisplayObject;
		private var _trackSize:Number;
		private var uiContainer:DisplayObjectContainer;
		/** 滚动条的最大高度
		 */
		private var barMaxHeight:Number;
		/** 滚动条滚动区域
		 */
		private var _vScrollRect:Rectangle;
		/**是否按下了鼠标
		 **/
		private var isPress:Boolean;
		/** vBar最后的y坐标 
		 */			
		private var _lastBarY:Number;

		public function YFCustomScroller(sp:DisplayObject,height:Number)
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
		}

	}
}