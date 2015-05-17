package com.YFFramework.game.core.module.pet.view
{
	/**装备打造 窗口
	 * @author yefeng
	 *2012-8-21下午10:28:31
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class PetWindow 
	{
		/**宠物列表面板
		 */		
		public var petListWindow:PetListWindow;
		/**宠物详细信息面板
		 */		
		public var petInfoWindow:PetInfoWindow;
		public function PetWindow()
		{
			initUI();
			addEvents();
		}

		protected function initUI():void
		{
			petListWindow=new PetListWindow();
			petInfoWindow=new PetInfoWindow(); 
		}
		
		protected function addEvents():void
		{
			///侦听petListWindow 的详细按钮
			petListWindow.xiangXiBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			///丢弃按钮侦听
			petListWindow.diuQiBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			///宠物选择发生改变的事件
			petListWindow.addEventListener(PetEvent.PetListCellViewSelect,onPetSelect);
		}
		
		private function onPetSelect(e:ParamEvent):void
		{
			var cell:PetListCellView=petListWindow.getSelect(); 
			if(cell) petInfoWindow.initData(cell.petDyVo);  ///填充数据
			else  ////关闭面板
			{
				petInfoWindow.popBack();
			}

		}
		
		
		/**详细按钮事件
		 */ 
		protected function onMouseClick(e:MouseEvent):void
		{
			var cell:PetListCellView;
			switch(e.currentTarget)
			{
				case petListWindow.xiangXiBtn:
					cell=petListWindow.getSelect(); 
					///单击宠物列表面板的详细按钮 弹出相应的详细信息界面
					if(cell)
					{
						if(!petInfoWindow.isPop())
						{
							petInfoWindow.popUp();
							petInfoWindow.locate2(petListWindow.x-petListWindow.visualWidth,petListWindow.y);
						}
						else petInfoWindow.popBack();
					}
					break;
				case petListWindow.diuQiBtn:
					////丢弃按钮
					
					break;
			}
				
		}
		
	}
}