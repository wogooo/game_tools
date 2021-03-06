package com.YFFramework.core.ui.abs
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFWindow;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**面板
	 * 2012-8-2 下午12:54:20
	 *@author yefeng
	 */
	public class GameWindow extends YFWindow
	{

		protected  var _isPop:Boolean;
		protected var _mWidth:Number;
		protected var _mHeight:Number;
		/** 游戏窗口基类 
		 * @param width
		 * @param height
		 */		
		public function GameWindow(width:int=400,height:int=300)
		{
			_mWidth=width;
			_mHeight=height;
			super(width,height,false);
		}
		
		/**切换弹出状态
		 */		
		public function toggle():void
		{
			if(!_isPop)
			{
				popUp();
				centerWindow()
			}
			else popBack();
		}
		
		/**是否已经弹出
		 */		
		public function isPop():Boolean
		{
			return _isPop;
		}
		/**弹出窗口
		 */		
		public function popUp():void
		{
			if(!LayerManager.WindowLayer.contains(this))LayerManager.WindowLayer.addChild(this);
			_isPop=true;
		}
		
		/** 窗口居中
		 */
		public function centerWindow():void
		{
			x=(StageProxy.Instance.stage.stageWidth-visualWidth)*0.5;
			y=(StageProxy.Instance.stage.stageHeight-visualHeight)*0.5;
		}
		
		/**定位窗口
		 */ 
		public function locate(offsetX:int,offsetY:int):void
		{
			this.x=(StageProxy.Instance.stage.stageWidth-visualWidth)*0.5+offsetX;
			this.y=(StageProxy.Instance.stage.stageHeight-visualHeight)*0.5+offsetY;
		}
		/**定位窗口
		 */ 
		public function locate2(x:int,y:int):void
		{
			this.x=x;
			this.y=y;
		}

		
		
		/**关闭窗口
		 */		
		public function popBack():void
		{
			if(LayerManager.WindowLayer.contains(this))LayerManager.WindowLayer.removeChild(this);
			_isPop=false;
		}
		/**
		 * 在窗口层最上层
		 */		
		public function topIt():void
		{
			if(_isPop)
			{
				LayerManager.WindowLayer.setChildIndex(this,LayerManager.WindowLayer.numChildren-1);	
			}
			else popUp();
		}
		override protected function onCloseBtn(e:MouseEvent):void
		{
			popBack();
	//		if(closeCallback!=null)closeCallback();
		}
		
		
		override public function get visualHeight():Number
		{
			return _mHeight;
		}
		override public function get visualWidth():Number
		{
			return _mWidth;	
		}
		
		
	}
}