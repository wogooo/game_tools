package com.YFFramework.core.ui.yf2d.view
{
	/**
	 *  container
	 * @author yefeng
	 *2012-11-20下午10:29:39
	 */
	import yf2d.display.DisplayObjectContainer2D;
	
	public class Abs2dView extends DisplayObjectContainer2D
	{
		protected var _visualWidth:Number;
		protected var _visualHeight:Number;
		public function Abs2dView()
		{
			super();
			initUI();
			addEvents();
		}
		
		protected function initUI():void
		{
		}
		
		protected function addEvents():void
		{
			
		}
		
		protected function removeEvents():void
		{
			
		}
		
		
		
		
		/**可视宽度 可重写  用来精确弹出定位   窗口弹出定位的属性 是依据可视化宽高属性的
		 */
		public function get visualWidth():Number
		{
			_visualWidth=width;
			return _visualWidth
		} 
		/**可视高度
		 */		
		public function get visualHeight():Number
		{
			_visualHeight=height;
			return _visualHeight;
		}
		
		/**是否包含 点 px,py  
		 */		
		public function containsPt(px:int,py:int):Boolean
		{
			if(px>0&&px<visualWidth&&py>0&&py<visualHeight)
			{
				return true;	
			}
			return false;
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			removeEvents();
			super.dispose(childrenDispose);
			_isDispose=true;
		}
	}
}