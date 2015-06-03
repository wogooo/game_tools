package com.YFFramework.core.ui.container
{
	/**  垂直容器    里面的对象是 AbsUIView 
	 *  2012-6-21
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.abs.AbsUIView;
	
	import flash.display.DisplayObject;
	
	public class VContainer extends AbsUIView
	{
		
		/** 每两个之间的垂直距离
		 */
		private var vSpace:int=0;
		
		private var __height:Number;
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
			var child:DisplayObject;
			var lastY:int=0;
			for(var i:int=0;i!=len;++i)
			{
				child=getChildAt(i) ;
				child.y=lastY;
				lastY=child.y+child.height+vSpace;
			}
			__height=lastY;
		}
		public function get contentHeight():Number
		{
			return __height;
		}
	}
}