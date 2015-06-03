package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**超级窗口  能够跟随一个mc 
	 * @author yefeng
	 * 2013 2013-6-24 上午11:23:56 
	 */
	public class WindowEx extends Window
	{
		/**最小化窗口按钮 
		 */		
		protected var _minButton:SimpleButton;
		/**跟随的鼠标窗口
		 */		
		private var _followMC:Sprite;
		public function WindowEx()
		{
			super();
			_minButton=ClassInstance.getInstance("skin__minButton");
			Xtip.registerTip(_minButton,"最小化窗口");
			followMC=new Sprite();
			ResizeManager.Instance.regFunc(onResize);
		}
		/**隐藏最小化按钮
		 */		
		protected function showMinButton():void
		{
			if(!contains(_minButton))addChild(_minButton);
		}
		/**显示最小化按钮
		 */		
		public function hideMinButton():void
		{
			if(contains(_minButton))removeChild(_minButton);
		}
		
		public function set followMC(mc:Sprite):void
		{
			_followMC=mc;
			_followMC.x=compoWidth;
			_followMC.y=0;
			
			if(!contains(mc))addChild(mc);
			
			followMC.mouseChildren=false;
			followMC.mouseEnabled=false;
			
		}
		
		private function onResize():void
		{
			_followMC.x=compoWidth;
			followMC.y=0;
		}
		
		public function get followMC():Sprite
		{
			return _followMC;
		}
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
			if(_minButton)
			{
				_minButton.x = _closeButton.x - _closeButton.width-5;
				_minButton.y = closeY;
			}
			if(_followMC)
			{
				_followMC.x=_compoWidth;
				_followMC.y=0;
			}
		}

			
	}
}