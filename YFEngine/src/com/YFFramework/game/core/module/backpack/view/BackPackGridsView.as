package com.YFFramework.game.core.module.backpack.view
{
	/**背包 UI内容 不含窗口 
	 * @author yefeng
	 *2012-8-11下午8:19:38
	 */
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridLock;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridOpen;
	import com.YFFramework.game.core.module.backpack.model.BackPackUtil;
	
	public class BackPackGridsView extends AbsUIView
	{
		
		public static const IconWidth:int=34;
		public function BackPackGridsView(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		override protected function initUI():void
		{
			super.initUI();
			
		}
		/**初始化格子  已经开启的格子数
		 * openGrids   表示的是已经开启的总格子数 
		 * page是页数  索引 从 1  开始 
		 */		
		public  function updateGrids(openGrids:int=56,page:int=1):void
		{
			///移除前一个的 
			removeAllContent(true);
			var currentOpenGrids:int=page*BackPackUtil.PageGridsNum;
			var i:int;
			var len:int=BackPackUtil.PageGridsNum;
			var openGrid:YFGridOpen;
			var lockGrid:YFGridLock;
			var currentColumn:int;//当前所在列
			var currentRow:int;//当前所在行数		
			var tx:int;
			var ty:int;
			if(openGrids>=currentOpenGrids)
			{	///全部开启
				for(i=0;i!=len;++i)
				{
					currentColumn=i%BackPackUtil.HorizontalNum;
					currentRow=i/BackPackUtil.HorizontalNum;
					tx=currentColumn*(BackPackUtil.GridWidth+BackPackUtil.GridSpace);
					ty=currentRow*(BackPackUtil.GridHeight+BackPackUtil.GridSpace);
					//全部开启
					openGrid=new YFGridOpen();
					openGrid.width=BackPackUtil.GridWidth;
					openGrid.height=BackPackUtil.GridHeight;
					openGrid.x=tx;
					openGrid.y=ty;
					addChild(openGrid);
				}
			}
			else  //部分开启 部分未有开启 格子开启是一行一行的开的
			{
				var nowPageOpenNum:int=(currentOpenGrids-openGrids)%BackPackUtil.PageGridsNum;
				for (i=0;i!=len;++i)
				{
					currentColumn=i%BackPackUtil.HorizontalNum;
					currentRow=i/BackPackUtil.HorizontalNum;
					tx=currentColumn*(BackPackUtil.GridWidth+BackPackUtil.GridSpace);
					ty=currentRow*(BackPackUtil.GridHeight+BackPackUtil.GridSpace);
					if(i<nowPageOpenNum)
					{
						//开启
						openGrid=new YFGridOpen();
						openGrid.width=BackPackUtil.GridWidth;
						openGrid.height=BackPackUtil.GridHeight;
						openGrid.x=tx;
						openGrid.y=ty;
						addChild(openGrid);
					}
					else 
					{
						//未开启
						lockGrid=new YFGridLock();
						lockGrid.width=BackPackUtil.GridWidth;
						lockGrid.height=BackPackUtil.GridHeight;
						lockGrid.x=tx;
						lockGrid.y=ty;
						addChild(lockGrid);
					}
				}
			}
			
		}
		
		
		
		
	}
}