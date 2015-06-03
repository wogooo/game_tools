package com.YFFramework.core.net.loader.image_swf
{
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	
	/**  加载多个资源
	 * 2012-6-26
	 *	@author yefeng
	 */
	public class SWFSLoader
	{
		
		
		/**
		 */
		public  var loadCompleteCallBack:Function=null;
		/** 小单元加载完成 
		 */		
		public var cellCompleteCallBack:Function=null;
		/**该函数带有一个ProgressEvent类型的参数
		 */	
		public var progressCallBack:Function=null;
		
		public var ioErrorCallBack:Function;
		
//		private var domain:ApplicationDomain;
		/** 加载进来的数据对象
		 */		
		private var dataArr:Vector.<Object>; 
		private var urlObjArr:Vector.<Object>;
		
//		private var uiLoader:UILoader;
		private var _len:int;
		private var _loadCompleteIndex:int;
		public function SWFSLoader()
		{
		}
		/**
		 * @param _urlArr  {url:,tips:}
		 */		
		public function load(_urlArr:Vector.<Object>,tempData:Object,domain:ApplicationDomain=null):void
		{
			_len=_urlArr.length;
			var uiLoader:UILoader;
			_loadCompleteIndex=0;
			for each(var obj:Object in _urlArr)
			{
				uiLoader=new UILoader();	
				uiLoader.loadCompleteCallback=completeLoad;
				uiLoader.progressCallBack=progress;
				uiLoader.ioErrorCallBack=ioErrorCallBack;
				uiLoader.initData(obj.url,null,{tips:String(obj.tips),data:tempData},domain);
			}
		}
		private function progress(e:ProgressEvent,data:Object=null):void
		{
			if(progressCallBack!=null)progressCallBack(e,data);
			
		}
		private function completeLoad(content:DisplayObject,data:Object=null):void
		{
			_loadCompleteIndex++;
			if(cellCompleteCallBack!=null)cellCompleteCallBack(_loadCompleteIndex);
			if(_loadCompleteIndex>=_len)  //加载完成
			{
				if(loadCompleteCallBack!=null)loadCompleteCallBack(data.data);
			}
		}
		protected function dispose():void
		{
			loadCompleteCallBack=null;
			progressCallBack=null;
			dataArr=null; 
			urlObjArr=null;
		}
	}
}