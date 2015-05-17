package com.YFFramework.core.ui.container
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	
	import flash.display.DisplayObject;

	/**容器中始终只存在一个对象  
	 * 2012-6-20
	 *	@author yefeng
	 */
	public class OneChildContainer extends AbsUIView
	{
		public function OneChildContainer()
		{
			super(false);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
//			var obj:DisplayObject;
//			while(numChildren)
//			{
//				obj=getChildAt(0);
//				if(obj!=child) removeChildAt(0);
//			}
//			if(numChildren==0)super.addChild(child);
//			return child;
			while(numChildren)
			{
				removeChildAt(0);
			}
			return super.addChild(child);
		}
		
		
	}
}