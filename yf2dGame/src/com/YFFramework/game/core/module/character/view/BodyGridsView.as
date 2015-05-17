package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridOpen;
	import com.YFFramework.core.world.model.type.EquipCategory;
	
	/**人物 角色面板 的格子窗口 
	 * 2012-8-22 上午10:31:11
	 *@author yefeng
	 */
	public class BodyGridsView extends AbsUIView
	{
		
		public function BodyGridsView()
		{
			super(false);
			var len:int=EquipCategory.ModelLen;
			var gridsicon:BodyGrid;
			var lastX:int=0;
			var lastY:int=0;
			var hspace:int=20;
			var vspace:int=40;
			for (var i:int=0;i!=len;++i)
			{
				gridsicon=new BodyGrid(i);
				addChild(gridsicon);
				if(i<4)
				{
					gridsicon.x=lastX;
					gridsicon.y=lastY;
					if(i<3)lastY =gridsicon.y+gridsicon.height+vspace;  ////最后一个不做加法运算
				}
				else if(i<6)
				{
					gridsicon.x=(gridsicon.width+hspace)*(i-3);
					gridsicon.y=lastY;
				}
				else 
				{
					if(i==6)lastY=0
					gridsicon.x=(gridsicon.width+hspace)*3
					gridsicon.y=lastY;
					lastY =gridsicon.y+gridsicon.height+vspace;
				}
			}
			
		}
		
		override protected function initUI():void
		{
			super.initUI();
		}

		override protected function addEvents():void
		{
			super.addEvents();
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
		}
		
		
		
		
		
	}
}