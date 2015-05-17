package com.YFFramework.core.ui.yfComponent.controls
{
	/**@author yefeng
	 *2012-8-10下午10:37:00
	 */
	public class YFTabMenu extends YFAbsList
	{
		/**
		 * @param cellWidth
		 * @param space
		 * @param skinId   为  13    1 4    15 都可以
		 * @param backgroundColor
		 * @param align
		 * @param autoRemove
		 * 
		 */		
		public function YFTabMenu( cellWidth:Number=100, space:int=0, skinId:int=13, backgroundColor:int=-1, align:String="center", autoRemove:Boolean=false)
		{
			super(skinId, cellWidth, space, YFAbsList.Horizontal, backgroundColor, align, autoRemove);
		}
	}
}