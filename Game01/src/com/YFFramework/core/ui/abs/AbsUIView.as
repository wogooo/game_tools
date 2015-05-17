package com.YFFramework.core.ui.abs
{
	/**具有可视化宽高的 基类    当需要定位时  必须是以他为基类 
	 * 所有的ui对象都必须由它进行封装
	 *   
	 * @author yefeng
	 *2012-5-18上午12:19:36
	 */
	public class AbsUIView extends AbsView
	{
		protected var _visualWidth:Number;
		protected var _visualHeight:Number;
		public function AbsUIView(autoRemove:Boolean=false)
		{
			super(autoRemove);
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
	}
}