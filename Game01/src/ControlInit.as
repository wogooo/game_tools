package
{
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.game.core.handle.HandlerInitManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.scence.ScenceInitManager;

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
			/// 该去指定人物移动 图片不移动
			BgMapScrollport.initPort();
			
			//初始化各个模块
			ModuleManager.initModule();
			//初始化场景
			ScenceInitManager.initScence();
			
			///初始化socket handler处理 
			HandlerInitManager.inithandler();
			
			///进入场景   进入游戏  
//			ScenceManager.Instance.enterScence(ScenceInitManager.GameOn);
			
		}
		
	}
}