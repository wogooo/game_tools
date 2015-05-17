package net
{
	import com.YFFramework.core.debug.Log;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import manager.ActionData;
	import manager.ActionDataManager;
	import manager.BitmapDataEx;
	
	import utils.CommonUtil;
	
	/**  加载多个 swf 或者多个图片 建议 使用它 
	 * author :夜枫
	 */
	public class MoviePicLoader
	{
		/**  该函数参数  CommonLoaders
		 */		
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有一个ProgressEvent类型的参数 和当前加载的索引参数
		 */	
		public var progressCallBack:Function=null;
		
		public  var headerData:Object;
		public  var dataDict:Dictionary;
		
		public var actionData:ActionData;
		
		private var _loader:Loader;
		private var _request:URLRequest;
		private var  currentIndex:int=0;
		private var urlArr:Vector.<String>;
		private var len:int;
		
		/**人物比对的坐标初始坐标 默认是以第一个人物左上角作为原点
		 */
		public var registerPoint:Point;
		
		
		
		public function MoviePicLoader()
		{
			init();
		}
		
		/** 格式  1 -3 - 0001  动作 方向  帧号
		 */
		public function load(_urlArr:Vector.<String>):void
		{
			dataDict= new Dictionary();
	//		dataVect=new Vector.<BitmapDataEx>();
			urlArr=_urlArr;
			len=urlArr.length;
			process();
		}
		
		protected function process():void
		{
			_request.url=urlArr[currentIndex];
			_loader.load(_request);
		} 
		
		protected function init():void
		{
			registerPoint=new Point();
			headerData={};
			actionData=new ActionData();
			_loader=new Loader();
			_request=new URLRequest();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		private function onProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null) progressCallBack(e,currentIndex,len);
		}
		
		private function onError(e:IOErrorEvent):void
		{
			print(this,"发生流错误，错误地址为:"+_request.url);
			Log.Instance.e("CommonLoaders::发生流错误，错误地址为:"+_request.url);
			throw new Error("MoviePicLoader::发生流错误，错误地址为:"+_request.url);
		}
		private var first:Boolean=false;
		private var pt:Point=new Point();
		private function onComplete(e:Event):void
		{
			var data:BitmapData=Bitmap(_loader.content).bitmapData;
			var rect:Rectangle=BitmapDataUtil.getMinRect(data);
			if(!first)
			{  ///设置 初始比对点
				registerPoint.x=rect.x;
				registerPoint.y=rect.y;
				first=true;
			}
			var myData:BitmapDataEx=new BitmapDataEx(rect.width,rect.height,true,0xFFFFFF);
			if(!myData.bitmapData)myData.bitmapData=new BitmapData(1,1,true,0xFFFFFF); ////防止为0 的确情况
			myData.bitmapData.copyPixels(data,rect,pt);
//			myData.x=rect.x-registerPoint.x;
//			myData.y=rect.y-registerPoint.y;
			myData.x=rect.x-data.width*0.5;//rect.x+320 -data.width*0.5;
			myData.y=rect.y-data.height*0.7;//rect.x+336  -data.height*0.7;
			
			var canpush:Boolean = ActionDataManager.fillData(actionData,_request.url,myData);
			if (!canpush)  //相同图片 进行释放
			{
				myData.bitmapData.dispose();
			}
			
			++currentIndex;
			_loader.unloadAndStop();
			if(currentIndex<urlArr.length) process();
			else 
			{
				if(loadCompleteCallBack!=null)loadCompleteCallBack(this);
				dispose();
			}
		}
		
		protected function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.unloadAndStop();
			_request.url="";
			_request=null;
			_loader=null;
			loadCompleteCallBack=null;
			progressCallBack=null;
		}
		public function remove():void
		{
			dataDict=null;
			headerData=null;
		}
		
		
		
	}
}