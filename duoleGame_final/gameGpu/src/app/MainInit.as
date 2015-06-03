package app
{
	import com.YFFramework.core.debug.LoadErrorLog;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.mapScence.world.yf2dCore.Interaction;
	import com.YFFramework.game.core.scence.ScenceInitManager;

	/**@author yefeng
	 * 2013 2013-4-1 下午4:06:51 
	 */
	public class MainInit
	{
		public function MainInit()
		{
			LoadErrorLog.Instance;
			///初始化硬件加速鼠标事件
			var interaction:Interaction=new Interaction();
			//初始化场景
			ScenceInitManager.initScence();
			//初始化各个模块
			ModuleManager.initModule();
			//////鼠标手势 统一管理
			MouseManager.init();
		}
	}
}