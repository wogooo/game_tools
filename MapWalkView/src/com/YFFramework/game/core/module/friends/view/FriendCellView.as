package com.YFFramework.game.core.module.friends.view
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.net.ResLoader;
	
	/**2012-9-29 下午12:47:49
	 *@author yefeng
	 */
	public class FriendCellView extends AbsUIView
	{
		
		private var icon:ResLoader;
		private var _nameLabel:YFLabel;
		public function FriendCellView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
		}
		override protected function addEvents():void
		{
			
		}
		override protected function removeEvents():void
		{
			
		}
	}
}