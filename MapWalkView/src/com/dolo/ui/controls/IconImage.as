package com.dolo.ui.controls
{
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.BitmapData;

	/**
	 * 图标图像显示控件 
	 * @author flashk
	 * 
	 */
	public class IconImage extends UIComponent
	{
		protected var _smoothing:Boolean = false;
		protected var _iconLoader:IconLoader
		protected var _url:String;
		protected var _dis:Bitmap;
		protected var _linkage:String;
		protected var _disObj:DisplayObject;
		protected var _loader:Loader;
		
		public function IconImage()
		{
			super();
			_iconLoader = new IconLoader();
		}
		
		public function get displayObject():DisplayObject
		{
			return _disObj;
		}

		public function get linkage():String
		{
			return _linkage;
		}
		
		public function get bitmap():Bitmap
		{
			return _dis;
		}

		public function set linkage(value:String):void
		{
			if(_disObj && _disObj.parent){
				_disObj.parent.removeChild(_disObj);
			}
			_linkage = value;
			if(value == null) return;
			if(value == "") return;
			var obj:Object = LibraryCreat.getObject(value);
			var bd:BitmapData = obj as BitmapData;
			if(bd){
				_disObj = new Bitmap(bd);
			}else{
				_disObj = obj as DisplayObject;
			}
			this.addChild(_disObj);
		}
		
		public function clear():void
		{
			_url = "";
			if(_disObj && _disObj.parent){
				_disObj.parent.removeChild(_disObj);
			}
			if(_dis && _dis.parent){
				_dis.parent.removeChild(_dis);
			}
		}

		public function get smoothing():Boolean
		{
			return _smoothing;
		}

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		/**
		 * 
		 * @param urlPath 图标的文件地址
		 * 
		 */
		public function set url(urlPath:String):void
		{
//			if(urlPath == _url) return;
			if(_dis && _dis.parent){
				_dis.parent.removeChild(_dis);
			}
			_url = urlPath;
			_iconLoader.loadCompleteCallback = loadCompleteCallback;
			_iconLoader.initData(_url,this);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		protected function loadCompleteCallback(dis:Bitmap,data:Object):void
		{
			dis.smoothing = smoothing;
			_dis = dis;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
		}
		
	}
}