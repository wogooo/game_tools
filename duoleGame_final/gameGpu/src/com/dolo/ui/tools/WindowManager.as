package com.dolo.ui.tools
{
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.layer.WindowsLayer;
	import com.YFFramework.game.core.module.team.view.TeamWindow;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-10 下午4:42:25
	 * 
	 */
	public class WindowManager{
		
		public function WindowManager(){
		}
		
		/**获取最顶层的想要对比的Window类
		 * @param args	想要对比的Window类
		 * @return * 最顶层的想要对比的Window实例；如果没有，返回null
		 */
		public static function getTopWindow(... args):*{
			var len:int = args.length;
			for(var i:int=LayerManager.WindowLayer.numChildren-1;i>=0;i--){
				for(var j:int=0;j<len;j++){
					if(LayerManager.WindowLayer.getChildAt(i) is args[j])	return LayerManager.WindowLayer.getChildAt(i);
				}
			}
			return null;
		}
		
		/**查看指定的类是否在窗口的最上层
		 * @param window	指定的类
		 * @return Class    返回这个类
		 */		
		public static function isWindowOnTop(window:Class):*
		{
			if(LayerManager.WindowLayer.getChildAt(LayerManager.WindowLayer.numChildren-1) is window)	
				return LayerManager.WindowLayer.getChildAt(LayerManager.WindowLayer.numChildren-1);
			return null;
		}
	}
} 