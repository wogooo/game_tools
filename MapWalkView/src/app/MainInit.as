package app
{
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.scence.ScenceInitManager;

	/**@author yefeng
	 * 2013 2013-4-1 下午4:06:51 
	 */
	public class MainInit
	{
		public function MainInit()
		{
			//初始化各个模块
			ModuleManager.initModule();
			//初始化场景
			ScenceInitManager.initScence();
			//////鼠标手势 统一管理
			MouseManager.init();

		}
	}
}