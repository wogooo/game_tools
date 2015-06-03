package com.YFFramework.game.core.global.view.ui
{
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;

	/**@author yefeng
	 * 2013 2013-11-7 下午5:37:11 
	 */
	public class IconEffectView extends UIEffectView
	{
		/**特效的宽高
		 */		
		public static const Width:int=80;
		public static const Height:int=79;
			
		public function IconEffectView()
		{
			super(CommonEffectURLManager.LightEffectURL,Width,Height);
		}
	}
}