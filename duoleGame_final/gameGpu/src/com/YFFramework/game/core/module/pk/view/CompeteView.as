package com.YFFramework.game.core.module.pk.view
{
	import com.YFFramework.game.core.module.pk.manager.CompeteDyManager;

	/**  PK视图 view 
	 * @author yefeng
	 * 2013 2013-5-6 下午4:01:30 
	 */
	public class CompeteView
	{
		
		public var _pkWindow:CompeteWindow;
		public var _pkSimpleWindow:CompeteSimpleWindow;
		public function CompeteView()
		{
			initUI();
		}
		
		private function initUI():void
		{
			_pkWindow=new CompeteWindow();
			_pkSimpleWindow=new CompeteSimpleWindow();
		}
		public function updateView():void
		{
			if(CompeteDyManager.Instance.getSize()==1)
			{
				_pkSimpleWindow.updateView();
				_pkSimpleWindow.open();
				_pkWindow.popBack();
			}
			else if(CompeteDyManager.Instance.getSize()>=2)
			{
				_pkWindow.updateView();
				_pkWindow.open();
				_pkSimpleWindow.popBack();
			}
		}
		
	}
}