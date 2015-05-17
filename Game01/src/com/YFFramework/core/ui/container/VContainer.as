package com.YFFramework.core.ui.container
{
	/**  垂直容器    里面的对象是 AbsUIView 
	 *  2012-6-21
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.abs.AbsUIView;
	
	public class VContainer extends AbsUIView
	{
		
		/** 每两个之间的垂直距离
		 */
		private var vSpace:int=0;
		public function VContainer(vSpace:int=0,autoRemove:Boolean=false)
		{
			this.vSpace=vSpace
			super(autoRemove);
		}
		
		
		/** 更新视图
		 */
		public function updateView():void
		{
			var len:int=numChildren;
			var child:AbsUIView;
			var lastY:int=0;
			for(var i:int=0;i!=len;++i)
			{
				child=getChildAt(i) as AbsUIView;
				child.y=lastY;
				lastY=child.y+child.visualHeight+vSpace;
			}
		}
	}
}