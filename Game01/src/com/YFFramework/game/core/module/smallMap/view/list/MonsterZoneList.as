package com.YFFramework.game.core.module.smallMap.view.list
{
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.geom.Point;

	/**2012-11-14 下午5:53:52
	 *@author yefeng
	 */
	public class MonsterZoneList extends SmallMapListView
	{
		public function MonsterZoneList()
		{
			super();
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_treeCell.text=Lang.SmallMap_GuaiWu;
		}

		/** xxobj   var monsterZoneArr:Array=xxObj.monsterZone;//[{name,x,y},{...},{...}]
		 */		
		public function updateContent(xxobj:Object):void
		{
			var arr:Array=xxobj.monsterZone;
			_vContainer.removeAllContent(true);
			var cell:SmallMapListCell;
			for each(var obj:Object in arr )
			{
				cell=new SmallMapListCell();
				cell.text=obj.name;
				_vContainer.addChild(cell);
				cell.data=new Point(obj.x,obj.y);
			}
			updateView();
		}

	}
}