package net 
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	
	/**  加载字节
	 *  @author yefeng
	 *   @time:2012-3-16上午10:06:03
	 */
	public class BytesLoaders2 extends EventDispatcher
	{
		
		/** 带BytesLoader类型参数的回调函数
		 */		
		public var loadCompleteCalback:Function;
		public var contentArr:Vector.<Object>;
		private var _loader:Loader;
		
		private var _loadIndex:int;
		private var bytesArr:Vector.<Object>;
		private var dataIndex:int;
		private var totalLen:int;
		public function BytesLoaders2()
		{
			contentArr=new Vector.<Object>();
			_loadIndex=0;
			_loader=new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
			
		}
		/**
		 * imageObject {dataArr:Vector.<Object>[{x:x,y:y,delay:delay,frameIndex:frameIndex,action:action,direction:direction,data:Vector.<ByteArray>([])}}],headerData:Object}
		 */ 
		public function load(bytesArr:Vector.<Object>):void
		{
			dataIndex=0;
			this.bytesArr=bytesArr;
			totalLen=bytesArr.length;
			handleLoad();
		}
		private function handleLoad():void
		{
			_loader.loadBytes(bytesArr[_loadIndex].data[dataIndex]);
			
		}
		private function onEventComplete(e:Event):void
		{
			var obj:Object={};
			obj.bitmapData=Bitmap(LoaderInfo(e.target).content).bitmapData;
			if(dataIndex==0)
			{
				obj.x=bytesArr[_loadIndex].x;
				obj.y=bytesArr[_loadIndex].y;
				obj.frameIndex=bytesArr[_loadIndex].frameIndex;
				obj.delay=bytesArr[_loadIndex].delay;
				obj.action=bytesArr[_loadIndex].action;
				obj.direction=bytesArr[_loadIndex].direction;
			}
			contentArr.push(obj);
			
			dataIndex++;
			if(dataIndex==2)
			{
				++_loadIndex;
				dataIndex=0;
			}
			
			_loader.unloadAndStop();
			if(_loadIndex<totalLen) handleLoad();
			else 
			{
				if(loadCompleteCalback!=null) loadCompleteCalback(this);
				dispose();
			}
			
		}
		private function onError(e:IOErrorEvent):void
		{
			trace("BytesLoader2::字节加载发生错误...,错误索引为:"+_loadIndex);
	//		ErrorCollection.Instance.collect("BytesLoader::字节加载发生错误...,错误索引为:"+_loadIndex);
		}
		
		protected function dispose():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onEventComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
			loadCompleteCalback=null;
			_loader=null;
		}
		
	}
}