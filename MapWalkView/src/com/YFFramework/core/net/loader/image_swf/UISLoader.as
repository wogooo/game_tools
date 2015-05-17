package com.YFFramework.core.net.loader.image_swf
{
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;

	/**  加载多个资源
	 * 2012-6-26
	 *	@author yefeng
	 */
	public class UISLoader
	{
		/**
		 */
		public  var loadCompleteCallBack:Function=null;
		/**该函数带有一个ProgressEvent类型的参数
		 */	
		public var progressCallBack:Function=null;
		
		public var ioErrorCallBack:Function;
		
		private var domain:ApplicationDomain;
		/** 加载进来的数据对象
		 */		
		private var dataArr:Vector.<Object>; 
		private var  currentIndex:int=0;
		private var urlObjArr:Vector.<Object>;
		
		private var uiLoader:UILoader;
		public function UISLoader()
		{
		}
		/**
		 * @param _urlArr  {url:,tips:}
		 */		
		public function load(_urlArr:Vector.<Object>,domain:ApplicationDomain=null):void
		{
			currentIndex=0;
			this.domain=domain;
			dataArr=new Vector.<Object>();
			urlObjArr=_urlArr;
			process();
		}
		protected function process():void
		{
			uiLoader=new UILoader();	
			uiLoader.loadCompleteCallback=completeLoad;
			uiLoader.progressCallBack=progress;
			uiLoader.ioErrorCallBack=ioErrorCallBack;
			var url:String=urlObjArr[currentIndex].url;
			uiLoader.initData(url,null,null,domain);
		}
		private function progress(e:ProgressEvent,data:Object=null):void
		{
			if(progressCallBack!=null)	progressCallBack(e,currentIndex);
		}
		private function completeLoad(content:DisplayObject,data:Object=null):void
		{
			delete urlObjArr[currentIndex].url;
			urlObjArr[currentIndex].display=content;
			dataArr.push(urlObjArr[currentIndex]);
			++currentIndex;
			if(currentIndex<urlObjArr.length) process();
			else 
			{
				if(loadCompleteCallBack!=null)loadCompleteCallBack(dataArr);
				dispose();
			}
		}
		
		protected function dispose():void
		{
			loadCompleteCallBack=null;
			progressCallBack=null;
			uiLoader=null;		
			domain=null;
			dataArr=null; 
			urlObjArr=null;
		}
	}
}