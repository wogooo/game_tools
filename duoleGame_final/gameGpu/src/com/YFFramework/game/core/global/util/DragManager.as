package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
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
		private var time:TimeOut;
		private var _view:DisplayObject;
		
		private var _tempVo:Object;
		/**停止拖动后的回调
		 */		
		private var _stopDragCallBack:Function;
		/**回调的参数
		 */		
		private var _callBackParam:Object;
		public function DragManager()
		{
			_pivotPt=new Point();
//			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,oonMove);
			
		}
		private function oonMove(e:MouseEvent):void
		{
			if(dragVo)	print(this,e.target,e.target.name);
			else print(this,"tt::",e.target,e.target.name);
		}
		public static function get Instance():DragManager
		{
			if(!_instance) _instance=new DragManager();
			return _instance;
		}
	
		/**拖动 物品
		 * @param view
		 * @param vo 
		 */		
		public function startDrag(view:DisplayObject,vo:Object=null,stopDragCallBack:Function=null,callBackParam:Object=null):void
		{
			if(view.width>=1&&view.height>=1)
			{
				_view=view;
				_tempVo=vo;
				_pivotPt.x=view.mouseX;
				_pivotPt.y=view.mouseY;
				_stopDragCallBack=stopDragCallBack;
				_callBackParam=callBackParam;
				StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				addEvents();
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			removeMouseMove();
			if(_tempVo)
			{
				if(_view.width>=1&&_view.height>=1)
				{
					doDrag(_view,_tempVo);	
					e.updateAfterEvent();
					_tempVo=null;
				}
			}
			else 
			{
				_stopDragCallBack=null;
				_callBackParam=null;
			}
		}
		
		private function removeMouseMove():void
		{
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		/**
		 */		
		private function addEvents():void
		{
			StageProxy.Instance.mouseUp.regFunc(onMouseUp);
			StageProxy.Instance.mouseLeave.regFunc(onMouseUp);
		}
		private function removeEvents():void
		{
			StageProxy.Instance.mouseUp.delFunc(onMouseUp);
			StageProxy.Instance.mouseLeave.delFunc(onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent=null):void
		{
			removeMouseMove();
			removeEvents();
			UpdateManager.Instance.framePer.delFunc(update);
			Mouse.show();
			if(dragVo)
			{
				stopDrag();
			}
			if(_stopDragCallBack!=null)
				_stopDragCallBack(_callBackParam);
			if(time)time.dispose();
			time=new TimeOut(50,removeIt);
			time.start();
			LayerManager.DisableLayer.removeChildren(0);
		}
		
		private function removeIt(obj:Object=null):void
		{
			dragVo=null;
			_stopDragCallBack=null;
			_callBackParam=null;
		}
		
		/**停止拖动
		 */		
		private function stopDrag():void
		{
			
			if(_dragBmp)	
			{
				removeLayer(_dragBmp);
				_dragBmp.bitmapData.dispose();
			}
			_dragBmp=null;
			_view=null;
			
			
		}
		
		public function deleteDrag():void{
			if(_dragBmp == null) return;
			stopDrag();
			removeIt();
		}

		
		/**  处理物品拖动
		 */
		private function doDrag(iconView:DisplayObject,vo:Object):void
		{
			dragVo=vo;
			UpdateManager.Instance.framePer.regFunc(update);
			_dragBmp=getBitmap(iconView);
			addLayer(_dragBmp);
			Mouse.hide();
			update();
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
		private  function getBitmap(display:DisplayObject):Bitmap
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