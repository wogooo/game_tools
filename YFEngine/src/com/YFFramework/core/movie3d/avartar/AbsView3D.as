package com.YFFramework.core.movie3d.avartar
{
	/**@author yefeng
	 *2013-3-18下午9:56:10
	 */
	import away3d.containers.ObjectContainer3D;
	
	import com.YFFramework.core.movie3d.core.YFEngine;
	
	public class AbsView3D extends ObjectContainer3D
	{
		private var _flashX:Number;
		private var _flashY:Number;

		public function AbsView3D()
		{
			super();
			initUI();
			addEvents();
		}
		
		protected function initUI():void
		{
			
		}
		protected function addEvents():void
		{
			
		}
		
		protected function removeEvents():void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose()
			removeEvents();
		}
		
		
		public function setFlashPosition(px:Number,py:Number):void
		{
			_flashX=px;
			_flashY=py;
			position=YFEngine.Instance.flashToModel3d(px,py);
		}
		
		public function setFlashX(px:Number):void
		{
			_flashX=px;
			position=YFEngine.Instance.flashToModel3d(px,_flashY);
		}
		
		public function setFlashY(py:Number):void
		{
			_flashY=py;
			position=YFEngine.Instance.flashToModel3d(_flashX,py);
		}
		
		public function get flashX():Number
		{
			return _flashX;
		}
		public function get flashY():Number
		{
			return _flashY;
		}

		
		
		
	}
}