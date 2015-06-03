package com.YFFramework.core.ui.yfComponent
{
	/**@author yefeng
	 * 2013 2013-11-18 下午5:51:13 
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PopUpSprite extends Sprite
	{
		
		/**添加进来的对象
		 */
		public var display:DisplayObject;
		protected var _clickAlphaIndex:uint = 0;
		public static const clickAlphas:Array = [0.75,0.75,0.75,1,1,1,0.75,0.75,0.75,1,1,1,0.75,0.75,0.75,1];


		private var _mask:Sprite;
		
		private var _lightBg:Boolean;
		/**单击时，背景是否闪烁
		 */
		public function PopUpSprite(lightBg:Boolean=true)
		{
			super();
			_lightBg=lightBg;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			_clickAlphaIndex = 0;
			if(_lightBg)
			{
				UpdateManager.Instance.framePer.regFunc(onMaskClickEnterFrame);
			}
		}
		
		protected function onMaskClickEnterFrame(event:Event=null):void
		{
			if( _clickAlphaIndex >= clickAlphas.length ){
				UpdateManager.Instance.framePer.delFunc(onMaskClickEnterFrame);
				return;
			}
			this.alpha = clickAlphas[ _clickAlphaIndex ];
			_clickAlphaIndex ++;
		}

		public function getMask():Sprite
		{
			if(_mask==null)
			{
				_mask=new Sprite();
				addChild(_mask);
				_mask.addEventListener(MouseEvent.CLICK,onClick);

			}
			return _mask;
		}
//		public function topMask():void
//		{
//			addChild(_mask);
//		}
		public function bottomMask():void
		{
			addChildAt(_mask,0);
		}

		public function getContent():DisplayObject
		{
//			var len:int=numChildren; 
//			var child:DisplayObject;
//			for(var i:int=0;i!=len;++i)
//			{
//				child=getChildAt(i);
//				if(child!=_mask)
//				{
//					return child;
//				}
//			}
//			return null;
			return display;
		}
		
		/**
		 */
		public function dispose():void
		{
			
			if(_mask)
			{
				_mask.removeEventListener(MouseEvent.CLICK,onClick);
				_mask.graphics.clear();
				removeChild(_mask);
			}
			
			_mask=null;
		}
	}
}