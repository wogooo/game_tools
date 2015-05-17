package com.YFFramework.core.utils.net
{
	/**加载图片的容器 直接存放图片 
	 * @author yefeng
	 *2012-9-22下午10:57:17
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yfComponent.controls.YFHolder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class ResLoader extends YFHolder
	{
		
		/**数据播放对象
		 */ 
		protected var bitmapMovieClip:BitmapMovieClip;
		
		// 当为图片时  保存 bitmapData
		protected var  picBitmapData:BitmapData;
		public function ResLoader(width:Number, height:Number)
		{
			super(width, height, 1, false);
		}
		override protected function initUI():void
		{
			super.initUI();
			bitmapMovieClip=new BitmapMovieClip();
			addChild(bitmapMovieClip);
		}
		
		/**加载外部动画资源  支持   图片   .swf  以及  .chitu 
		 */ 
		public function load(url:String):void
		{
			///开始资源加载  判断类型
			var str:String=url;
			///先取  问号
			var index:int=str.indexOf("?");
			if(index!=-1)str=str.substring(0,index);
			index=	 str.lastIndexOf(".");
			///根据 url 判断资源类型
			var suffix:String=str.substring(index+1);//后缀
			if(suffix=="swf"||suffix=="chitu")  ///动画资源加载
			{
				SourceCache.Instance.addEventListener(url,onComplete);
				SourceCache.Instance.loadRes(url,null);
			}
			else  ///非动画资源加载   也就是加载图片 
			{
				var uiLoader:UILoader=new UILoader();
				uiLoader.initData(url);
				uiLoader.loadCompleteCallback=callback;
			}
		}
		private function callback(content:DisplayObject,data:Object):void
		{
			var bitmapData:BitmapData=Bitmap(content).bitmapData;
			bitmapMovieClip.bitmapData=bitmapData;
			picBitmapData=bitmapData;
		}
		
		protected function onComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			var actionData:ActionData=SourceCache.Instance.getRes(url) as ActionData;
			bitmapMovieClip.initData(actionData);
			bitmapMovieClip.start();
			bitmapMovieClip.playDefault();
			
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			bitmapMovieClip=null;
			if(picBitmapData) picBitmapData.dispose(); ///当加载的对象为图片时  释放图片内存 
			picBitmapData=null;
		}
		
		
	}
}