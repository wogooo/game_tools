package com.YFFramework.game.core.module.newGuide.view.scene
{
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.module.newGuide.manager.GuaJiManager;
	import com.YFFramework.game.ui.layer.LayerManager;

	/**自动寻路特效UI
	 * @author yefeng
	 * 2013 2013-7-22 下午2:33:30 
	 */
	public class ZiDongXunLuView extends CommonViewBase
	{
		private static var _instance:ZiDongXunLuView;

		public function ZiDongXunLuView()
		{
			super(CommonEffectURLManager.ZiDongXunLu);
		}
		public static function get Instance():ZiDongXunLuView
		{
			if(_instance==null)_instance=new ZiDongXunLuView();
			return _instance;
		}
		
		
		override public function show():void
		{
			GuaJiManager.Instance.stop();
			if(!LayerManager.NoticeLayer.contains(this))LayerManager.NoticeLayer.addChild(this);
			if(LayerManager.NoticeLayer.contains(GuaJiView.Instance))LayerManager.NoticeLayer.removeChild(GuaJiView.Instance);
			resize();
			_isShow=true;
		}

		
		

	}
}