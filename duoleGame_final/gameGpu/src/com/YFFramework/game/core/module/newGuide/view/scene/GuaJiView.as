package com.YFFramework.game.core.module.newGuide.view.scene
{
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.ui.layer.LayerManager;

	/**挂机特效UI 在场景上显示的图片
	 * @author yefeng
	 * 2013 2013-7-22 下午2:32:44 
	 */
	public class GuaJiView extends CommonViewBase
	{
		/**宽度
		 */		
		public static const Width:int=240;
		private static var _instance:GuaJiView;
		public function GuaJiView()
		{
			super(CommonEffectURLManager.GuaJi);
		}
		
		public static function get Instance():GuaJiView
		{
			if(!_instance)_instance=new GuaJiView();
			return _instance;
		}
		override public function show():void
		{
			if(!LayerManager.NoticeLayer.contains(this))LayerManager.NoticeLayer.addChild(this);
			if(LayerManager.NoticeLayer.contains(ZiDongXunLuView.Instance))LayerManager.NoticeLayer.removeChild(ZiDongXunLuView.Instance);
			resize();
		}

	}
}