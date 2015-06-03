package com.dolo.ui.controls
{
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;

	/**
	 * 图标图像显示控件 
	 * @author flashk
	 * 
	 */
	public class IconImage extends UIComponent
	{
		protected var _isClearUnVisible:Boolean = false;
		
		protected var _smoothing:Boolean = false;
		protected var _iconLoader:IconLoader
		protected var _url:String;
		protected var _dis:Bitmap=new Bitmap();
		protected var _linkage:String;
		protected var _disObj:DisplayObject;
		protected var _loader:Loader;
		protected var _bitmapData:BitmapData;
		protected var _defaultQuestionMark:Boolean=true;
		private var _hasAddedQM:Boolean=false;
		private var _questionMarkMC:MovieClip;
		
		override public function dispose():void
		{
			super.dispose();
			clear ();
			_iconLoader = null;
			_url = null;
			_dis = null;
			_linkage = null;
			_disObj = null;
			_loader = null;
			_bitmapData = null;
		}
		
		public function IconImage(defaultQuestionMark:Boolean=true)
		{
			super();
			_defaultQuestionMark = defaultQuestionMark;
		}
		
		/**
		 * 在调用clear()的时候是否将图标（包括底）隐藏，重新设置后将会显示 
		 */
		public function get isClearUnVisible():Boolean
		{
			return _isClearUnVisible;
		}

		/**
		 * @private
		 */
		public function set isClearUnVisible(value:Boolean):void
		{
			_isClearUnVisible = value;
			if( _dis == null && value == true ){
				this.visible = false;
			}
			if( value == false ){
				this.visible = true;
			}
		}

		public function get bitmapData():BitmapData
		{
			if( _dis == null ) return null;
			return _dis.bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			clear ();
			_dis = new Bitmap();
			_dis.bitmapData = value;
			this.addChild( _dis );
			_bitmapData = value;
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
			this.visible = true;
			if( _disObj && _disObj.parent ){
				_disObj.parent.removeChild( _disObj );
			}
			_linkage = value;
			if( value == null ) return;
			if( value == "" ) return;
			var obj:Object = LibraryCreat.getObject( value );
			var bd:BitmapData = obj as BitmapData;
			if( bd ){
				_disObj = new Bitmap( bd );
			}else{
				_disObj = obj as DisplayObject;
			}
			this.addChild( _disObj );
		}
		
		public function clear():void
		{
			_url = "";
			if(_questionMarkMC && this.contains(_questionMarkMC))	this.removeChild(_questionMarkMC);
			_hasAddedQM=false;
			if( _disObj && _disObj.parent ){
				_disObj.parent.removeChild( _disObj );
			}
			if( _dis && _dis.parent ){
				_dis.parent.removeChild( _dis );
			}
			if( _dis && _dis is Bitmap ){
				Bitmap( _dis ).bitmapData = null;
			}
			if( isClearUnVisible == true ){
				this.visible = false;
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
			this.visible = true;
			if(_dis && _dis.parent){
				_dis.parent.removeChild(_dis);
			}
			if(urlPath==null)	clear();
			else{
				_url = urlPath;
//				if(_defaultQuestionMark && _hasAddedQM==false){
//					_questionMarkMC = ClassInstance.getInstance("questionMC") as MovieClip;
//					this.addChild(_questionMarkMC);
//					_hasAddedQM = true;
//				}
				initDefaultSkin();
				_iconLoader = new IconLoader();
				_iconLoader.loadCompleteCallback = loadCompleteCallback;
				_iconLoader.initData( _url, this,_url);
			}
		}
		private function initDefaultSkin():void
		{
			if(_defaultQuestionMark && _hasAddedQM==false){
				_questionMarkMC = ClassInstance.getInstance("questionMC") as MovieClip;
				this.addChild(_questionMarkMC);
				_hasAddedQM = true;
				//以下代码把天书里的奖励图标缩小了，不知道谁写的，暂时注释，注释日期：2013-12-4.
//				width=_questionMarkMC.width;
//				height=_questionMarkMC.height;
			}
		}
		
		public function get url():String
		{
			return _url;
		}
		
		protected function loadCompleteCallback(dis:Bitmap,data:Object):void
		{
			
			if(_hasAddedQM){
				if(_questionMarkMC && this.contains(_questionMarkMC))	this.removeChild(_questionMarkMC);
				_hasAddedQM=false;
			}
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			if(_url==data){
				this.addChild(dis);
			}
			
			_dis = dis;
			_dis.smoothing = smoothing;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			this.addChildAt( skin, 0 );
			this.x = int( skin.x );
			this.y = int( skin.y );
			skin.x = 0;
			skin.y = 0;
			if( skin is Sprite ){
				if( Sprite( skin ).numChildren > 0 ){
					Sprite( skin ).removeChildAt( 0 );
				}
			}
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize( newWidht, newHeight );
		}
		override public function get width():Number
		{
			if( _dis ) return _dis.width;
			return 1;
		}
		
		override public function get height():Number
		{
			if( _dis ) return _dis.height;
			return 1;
		}
		
	}
}