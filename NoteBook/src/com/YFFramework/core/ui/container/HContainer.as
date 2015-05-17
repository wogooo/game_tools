package com.YFFramework.core.ui.container
{
	/**  2012-6-25
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.abs.AbsUIView;
	
	public class HContainer extends AbsUIView
	{
		private var hSpace:int;
		public function HContainer(hSpace:int=5,autoRemove:Boolean=false)
		{
			this.hSpace=hSpace;
			super(autoRemove);
		}
		
		
		/**更新ui 
		 */
		public function updateView():void
		{
			var len:int=numChildren;
			var child:AbsUIView;
			var lastX:int=0;
			for(var i:int=0;i!=len;++i)
			{
				child=getChildAt(i) as AbsUIView;
				child.x=lastX;
				lastX=child.x+child.visualWidth+hSpace;
			}
		}
		
	}
}