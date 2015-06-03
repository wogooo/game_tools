package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.view.progressbar.LogoView;

	/**预加载地图配置显示的 logo 
	 * @author yefeng
	 * 2013 2013-10-16 下午3:31:37 
	 */
	public class MapLoaderLogoView
	{
		/** logo 视图
		 */
		private var _logoView:LogoView;
		
		private static var _instance:MapLoaderLogoView;
		public function MapLoaderLogoView()
		{
			_logoView=new LogoView();
			_logoView.updatePercent(98);
		}
		public static function get Instance():MapLoaderLogoView
		{
			if(!_instance)
			{
				_instance=new MapLoaderLogoView();
			}
			return _instance;
		}	
		/**显示加载logo 
		 */		
		public function showLogo():void
		{
			PopUpManager.addPopUp(_logoView,null,0,0,0xFFFFFF,0.05);
			PopUpManager.centerPopUp(_logoView);
		}
		
		/**隐藏
		 */
		public function hideLogo():void
		{
			if(PopUpManager.contains(_logoView))PopUpManager.removePopUp(_logoView);
		}	
		
	}
}