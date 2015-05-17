package com.YFFramework.game.core.module.mapScence.manager
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.layer.LayerManager;
	
	import flash.display.DisplayObject;

	/**鼠标跟随效果创建
	 * @author yefeng
	 * 2013 2013-3-26 下午5:43:36 
	 */
	public class MouseFollowManager
	{
		public var data:Object;
		private var _view:DisplayObject;
		private var _isStart:Boolean;
		private static var _instance:MouseFollowManager;
		
		public function MouseFollowManager()
		{
		}
		public static function get Instance():MouseFollowManager
		{
			if(_instance==null) _instance=new MouseFollowManager();
			return _instance;
		}
		
		/**拖动 物品
		 * @param view
		 * @param vo 
		 */		
		public function startDrag(view:DisplayObject,data:Object=null):void
		{
			_view=view;
			_isStart=true;
			this.data=data;
			addLayer(_view);
			UpdateManager.Instance.framePer.regFunc(update);
			update();

		}	
		/**停止跟随
		 */		
		public function stopDrag():void
		{
			if(_isStart)	
			{
				UpdateManager.Instance.framePer.delFunc(update);
				removeLayer(_view);
				_view=null;
				_isStart=false;
			}
		}
		/**更新
		 */		
		private function update():void
		{
			if(_isStart)
			{
				_view.x=LayerManager.DisableLayer.mouseX;
				_view.y=LayerManager.DisableLayer.mouseY;
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
		
		
	}
}