package app
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.debug.SWFProfiler;
	import com.YFFramework.core.debug.Stats;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.game.core.module.gameView.view.KeyboardInit;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UIInit;

	/**@author yefeng
	 *2012-4-21下午7:19:14
	 */
	public class ControlInit
	{
		public function ControlInit()
		{
			init();
		}
		
		private function init():void
		{
			/// 初始化UI组件 
			LayerManager.initLayer(StageProxy.Instance.stage);
			PopUpManager.initPopUpManager(LayerManager.PopLayer);
			UIInit.initUISkin(StageProxy.Instance.stage,LayerManager.PopLayer);

			/// 该去指定人物移动 图片不移动
			BgMapScrollport.initPort();
			var keyboardInit:KeyboardInit=new KeyboardInit();
			debug();
			
		}
		private function debug():void
		{
			SWFProfiler.init(StageProxy.Instance.stage,LayerManager.UIViewRoot);
	//		LayerManager.DebugLayer.addChild(Stats.Instance);
			resizeIt();
			ResizeManager.Instance.regFunc(resizeIt);
//			initInfo();
		}
		private function resizeIt():void
		{
			Stats.Instance.x=0;//StageProxy.Instance.getWidth()-Stats.Instance.width
			//Stats.Instance.y=StageProxy.Instance.getHeight()-Stats.Instance.height-200;//250
			Stats.Instance.y=0;
		}
//		private function initInfo():void
//		{
//			var label:YFLabel=new YFLabel();
//			label.text=YF2d.Instance.getDriverInfo();
//			label.width=200;
//			LayerManager.DebugLayer.addChild(label);
//			label.x=5;
//			label.y=250
//		}

	}
}