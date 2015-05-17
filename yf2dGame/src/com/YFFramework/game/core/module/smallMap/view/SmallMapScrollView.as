package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.DataCenter;
	
	/**小地图 能进行滚动
	 * 2012-11-5 下午5:15:36
	 *@author yefeng
	 */
	public class SmallMapScrollView extends SmallMapView
	{
		/**缩小后的地图宽高
		 */		
		private var _mapWidth:int;
		/**缩小后的地图宽高
		 */		
		private var _mapHeight:int;
		/**圆的大小 /  也就是遮罩圓的半徑
		 */		
		private static const Circle:int=126*0.5;
		public function SmallMapScrollView()
		{
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			updatePop(true);///始终更新			
		}
		override protected function onHeroMove(e:YFEvent):void
		{
			updateHeroMove();
			updateMapMove();
		}
		/**更新地圖移動
		 */		
		private function updateMapMove():void
		{
			var difX:int;
			if(_heroMoveArrow.pivotX<=Circle)
			{
				_bgContainer.x=0;		
			}
			else if(_heroMoveArrow.pivotX>Circle&&_heroMoveArrow.pivotX<_mapWidth-Circle)
			{
				_bgContainer.x=Circle-_heroMoveArrow.pivotX;
			}
			else 
			{
				difX=_heroMoveArrow.pivotX-(_mapWidth-Circle);
				_bgContainer.x=Circle*2-_mapWidth;
			}
			var difY:int;
			
			if(_heroMoveArrow.pivotY<=Circle)
			{
				_bgContainer.y=0;		
			}
			else if(_heroMoveArrow.pivotY>Circle&&_heroMoveArrow.pivotY<_mapHeight-Circle)
			{
				_bgContainer.y=Circle-_heroMoveArrow.pivotY;
			}
			else 
			{
				difY=_heroMoveArrow.pivotY-(_mapHeight-Circle);
				_bgContainer.y=Circle*2-_mapHeight;
			}
		}
		
		

		
		override public function updateMapChange():void
		{
			super.updateMapChange();
			_mapWidth=DataCenter.Instance.mapSceneBasicVo.width*SmallMapView.radio;
			_mapHeight=DataCenter.Instance.mapSceneBasicVo.height*SmallMapView.radio;	
		}
		
		override protected function addFlyBoot():void
		{
		}
		
		override protected function addFlyBootEvent():void
		{
			// TODO Auto Generated method stub
		}
		
		override protected function initFlyBoot():void
		{
		}
	
	}
}