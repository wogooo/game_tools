package com.YFFramework.game.core.module.smallMap.view.list
{
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.geom.Point;

	/**2012-11-14 下午5:53:29
	 *@author yefeng
	 */
	public class TransferList extends SmallMapListView
	{
		public function TransferList()
		{
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			_treeCell.text=Lang.SmallMap_DiTuChuKou;
		}

		
		/** xxobj  var skipArr:Array=xxObj.skip; //[{selfX,selfY,x,y,mapId,mapName}]  //selfX selfY 是传送点自己的坐标  x y mapId 是另一个地图的信息 mapName另一个地图的名称
		 */		
		public function updateContent(xxObj:Object):void
		{
			var arr:Array=xxObj.skip;
			_vContainer.removeAllContent(true);
			var cell:SmallMapListCell;
			for each(var obj:Object in arr )
			{
				cell=new SmallMapListCell();
				cell.text=obj.mapName;
				_vContainer.addChild(cell);
				cell.data=new Point(obj.selfX,obj.selfY);
			}
			updateView();
		}
		
		

	}
}