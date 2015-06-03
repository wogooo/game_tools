package com.YFFramework.game.core.scence
{
	/** 游戏登陆
	 * @author yefeng
	 *2012-4-20下午11:24:43
	 */
	import com.YFFramework.core.center.abs.scence.AbsScence;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.module.ModuleManager;
	
	public class ScenceLogin extends AbsScence
	{
		public function ScenceLogin()
		{
			super(TypeScence.ScenceLogin);
		}
		override public function enterScence():void
		{
//			print(this,"login:"+ModuleManager.moduleLogin);
			ModuleManager.moduleLogin.init();
		}
		
		override protected function removeScenceUI():void
		{
			ModuleManager.moduleLogin=null;
		}

	}
}