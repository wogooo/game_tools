package com.YFFramework.core.ui.yfComponent.controls
{
	
	
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	

	/**
	 *  @author yefeng
	 *   @time:2012-3-22下午04:39:28
	 */
	public class YFIconLabel extends YFLabel
	{
		protected var _icon:AbsView; 
		protected var _iconW:int;
		protected var _iconH:int;  
		/**文本和图标之间的距离 
		 */
		protected var _icon_text_space:int;
		public function YFIconLabel(txt:String="",iconWidth:int=18,iconHeight:int=18,autoRemove:Boolean=false,icon_text_space:int=0)
		{
			this._iconW=iconWidth;
			this._iconH=iconHeight;
			this._icon_text_space=icon_text_space;	
			super(txt,1,12,0xFFFFFF,0xFFFFFF,false,"left",false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_icon=new AbsView(false);
			_icon.mouseChildren=_icon.mouseEnabled=false;
			addChild(_icon);
			_textFiled.x=_iconW+_icon_text_space;
		}
		public function setIcon(source:Object):void
		{
			if(source is BitmapData)
			{
				var bmp:Bitmap=new Bitmap(source as BitmapData);
				_icon.addChild(bmp);
			}
			else if(source is DisplayObject)
			{
				_icon.addChild(DisplayObject(source));
			}
			else if(source is String)
			{
				var loader:UILoader=new UILoader();
				loader.initData(String(source),_icon);
		//		loader.loadCompleteCallback=loadCallBack;
			}
		}
//		private function loadCallBack(content:DisplayObject):void
//		{
//			var data:Bitmap=Bitmap(content);
//			_icon.addChild(data);
//		}
		/**得到实际的可视化长度
		 */
		public function get textIconWidth():Number
		{
			return _iconW+_icon_text_space+textWidth;
		}
		
		 
	}
}