package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.utils.image.Cast;
	import com.YFFramework.game.core.module.skill.view.SKillCDView;
	import com.YFFramework.game.ui.display.GoodsIconView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.ui.Mouse;

	/**物品拖动管理类
	 * @author yefeng
	 *2012-8-18上午8:17:06
	 */
	public class DragManager
	{
		
		private static var _instance:DragManager;
		/**拖动的对象
		 */
		private var _dragBmp:Bitmap;
		/**拖动物品的动态vo   对  物品拖动
		 */
		public var dragVo:Object;
		/**拖动的点
		 */		
		private var _pivotPt:Point;
		public function DragManager()
		{
			_pivotPt=new Point();
		}
		
		public static function get Instance():DragManager
		{
			if(!_instance) _instance=new DragManager();
			return _instance;
		}
		
		/**开始拖动  拖到物品
		 */
		public function startDragGoods(iconView:GoodsIconView):void
		{
			doDrag(iconView);
			dragVo=iconView.goodsDyVo;
		}
		/**拖到 技能图标
		 */		
		public function startDragSkill(iconView:SKillCDView):void
		{
			doDrag(iconView);		
			dragVo=iconView.getSkillDyVo();
		}
		/**  处理物品拖动
		 */
		private function doDrag(iconView:DisplayObject):void
		{
			UpdateManager.Instance.framePer.regFunc(update);
			_dragBmp=getBitmap(iconView);
			addLayer(_dragBmp);
			Mouse.hide();
			_pivotPt.x=iconView.mouseX;
			_pivotPt.y=iconView.mouseY;
		}
		
		/**停止拖动
		 */		
		public function stopDrag():void
		{
			if(dragVo)
			{
				UpdateManager.Instance.framePer.delFunc(update);
				Mouse.show();
				removeLayer(_dragBmp);
				_dragBmp.bitmapData.dispose();
				_dragBmp=null;
				dragVo=null;
			}

		}
		/**更新
		 */		
		private function update():void
		{
			if(_dragBmp)
			{
				_dragBmp.x=LayerManager.DisableLayer.mouseX-_pivotPt.x;
				_dragBmp.y=LayerManager.DisableLayer.mouseY-_pivotPt.y;
			}
		}
		
		
		private function addLayer(display:DisplayObject):void
		{
			if(!LayerManager.DisableLayer.contains(display))LayerManager.DisableLayer.addChild(display);
		}
		private function removeLayer(display:DisplayObject):void
		{
			if(LayerManager.DisableLayer.contains(display))LayerManager.DisableLayer.removeChild(display);
		}
		private function getBitmap(display:DisplayObject):Bitmap
		{
			var bitmapData:BitmapData=Cast.Draw(display);
			return new Bitmap(bitmapData);
		}
		/**得到鼠标在物品图标中的位置
		 * 
		 */		
		public function get pivotPt():Point
		{
			return _pivotPt;
		}
	}
}