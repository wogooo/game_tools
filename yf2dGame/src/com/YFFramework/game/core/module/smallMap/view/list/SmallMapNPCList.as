package com.YFFramework.game.core.module.smallMap.view.list
{
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.game.core.global.lang.Lang;
	
	import flash.utils.Dictionary;

	/**npcList 
	 * 2012-11-14 下午5:53:13
	 *@author yefeng
	 */
	public class SmallMapNPCList extends SmallMapListView
	{
		public function SmallMapNPCList()
		{
			super();
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_treeCell.text=Lang.SmallMap_NPC;
		}
		
		
		/**
		 * @param npcDict   npcList内部是 MonsterDyVo 数据
		 */		
		public function updateContent(npcDict:Dictionary):void
		{
			_vContainer.removeAllContent(true);
			var cell:SmallMapListCell;
			for each(var roleDyVo:MonsterDyVo in npcDict)
			{
				cell=new SmallMapListCell();
				cell.text=roleDyVo.roleName;
				_vContainer.addChild(cell);
				cell.data={dyId:roleDyVo.dyId};
			}
			updateView();
		}

		
	}
}