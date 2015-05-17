package app
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.layer.PopUpManager;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.gameView.view.KeyboardInit;
	import com.YFFramework.game.core.scence.ScenceInitManager;
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
			LayerManager.initLayer(StageProxy.Instance.stage);
			PopUpManager.initPopUpManager();
			/// 初始化UI组件 
			UIInit.initUISkin(StageProxy.Instance.stage,LayerManager.PopLayer);

			
			/// 该去指定人物移动 图片不移动
			BgMapScrollport.initPort();
			var keyboardInit:KeyboardInit=new KeyboardInit();
		}
		
	}
}