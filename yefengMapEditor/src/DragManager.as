package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**  2012-7-11
	 *	@author yefeng
	 */
	public class DragManager
	{
		
		private static var _instance:DragManager;
		private static var _dragMc:DisplayObject;
		private static var _dragLayer:DisplayObjectContainer;
		public function DragManager()
		{
		}
		
		public static  function get Instance():DragManager
		{
			if(!_instance) _instance=new DragManager();
			return _instance;
		}
		/**开始拖动
		 * mc  拖动的对象
		 *  mc所在的层
		 */
		public function  startDrag(mc:DisplayObject,layer:DisplayObjectContainer):void
		{
			_dragMc=mc;
			_dragLayer=layer;
			UpdateManager.Instance.framePer.regFunc(update);
		}
		
		/**停止拖动
		 */
		public function stopDrag():void
		{
			UpdateManager.Instance.framePer.delFunc(update);
			_dragLayer=null;
			_dragMc=null;
		}
		
		private static function update():void
		{
			_dragMc.x=_dragLayer.mouseX;
			_dragMc.y=_dragLayer.mouseY;
		}
		
		public function getDragMC():DisplayObject
		{
			return _dragMc;
		}
	}
}