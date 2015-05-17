package com.YFFramework.game.core.module.backpack.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.ui.display.GoodsUsableIconView;
	
	import flash.events.MouseEvent;
	
	/**背包 物品图标类  不具备CD功能
	 * 2012-8-20 下午4:54:03
	 *@author yefeng
	 */
	public class BackpackGoodsIconView extends GoodsUsableIconView
	{
		public function BackpackGoodsIconView()
		{
			super();
		}
		
		override protected function addEvents():void
		{
			super.addEvents();	
			addEventListener(MouseEvent.CLICK,onGoodsClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();	
			removeEventListener(MouseEvent.CLICK,onGoodsClick);
		}
		protected function onGoodsClick(e:MouseEvent):void
		{
			BackpackMenuListView.Instance.show(this);
		}

		/**双击事件  使用物品  隐藏 menuListView
		 */		
		override protected function dbClickFunc():void
		{
			BackpackMenuListView.Instance.hide();
			print(this,"不能使用物品....");
		}
	}
}