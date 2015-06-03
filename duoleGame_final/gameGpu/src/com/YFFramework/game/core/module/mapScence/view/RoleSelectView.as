package com.YFFramework.game.core.module.mapScence.view
{
	/**@author yefeng
	 * 2013 2013-3-21 上午10:06:43 
	 */
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	
	import flash.geom.ColorTransform;

	/**角色被选中后时显示的光标
	 */	
	public class RoleSelectView extends SimpleEffectView
	{
		private static const DefaultColorTransform:ColorTransform=new ColorTransform();
		public function RoleSelectView()
		{
			super();
		}
		
		override protected function initUI():void
		{
			super.initUI();
			var url:String=CommonEffectURLManager.SelectRole;
			loadData(url);
		}
		
		public function showDefault():void
		{
			localColorTransform=DefaultColorTransform;
		}
	}
}