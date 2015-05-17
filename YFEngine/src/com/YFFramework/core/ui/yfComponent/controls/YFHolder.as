package com.YFFramework.core.ui.yfComponent.controls
{
	/**具有大小的 容器  默认皮肤样式是无色的
	 * @author yefeng
	 *2012-9-22下午10:39:19
	 */
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	public class YFHolder extends YFComponent
	{
		/**背景
		 */ 
		protected var _bg:DisplayObject;
		/**
		 * @param skinId 皮肤id 为 1 是是透明无色的
		 * @param autoRemove
		 */		
		public function YFHolder(width:Number,height:Number,skinId:int=1,autoRemove:Boolean=false)
		{
			_skinId=skinId;
			super(autoRemove);
		}
		override protected function initUI():void
		{
			initSkin();
		}
		/**初始化皮肤
		 */ 
		protected function initSkin():void
		{
			switch(_skinId)
			{
				case 1:  //// id 为 1  为无色透明的背景
					_bg=new Shape();
					addChild(_bg);
					drawBg();
					break;
				case 2:
					///为技能框皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.SkillFrame);
					_bg=new Bitmap(_style.link as BitmapData);
					addChild(_bg);
					break;
			}
		}
		
		
		/**画背景
		 */ 
		protected function drawBg():void
		{
			Draw.DrawRect(Object(_bg).graphics,width,height);
			_bg.alpha=0;
		}
		
		override public function set width(value:Number):void
		{
			width=value;
			if(_skinId==1) drawBg(); 
			else if(_skinId==2)_bg.width=value;
			
		}
		override public function set height(value:Number):void
		{
			height=value;
			if(_skinId==1) drawBg();
			else if(_skinId==2)_bg.height=value;
		}
		
	}
}