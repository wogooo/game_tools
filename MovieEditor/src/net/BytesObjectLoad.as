package net
{
	
	
	import com.YFFramework.core.net.loader.image_swf.BytesLoaders;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import manager.ActionData;
	import manager.BitmapDataEx;
	
	import utils.ImageAlphaUtil;
	
	
	/**  使用 BytesObjectLoad2类更好 性能更高  具备分线程功能
	 *  @author yefeng
	 *   @time:2012-3-16上午10:06:03
	 */
	public class BytesObjectLoad extends EventDispatcher
	{
	//	public var dict:Dictionary;
		/** 带BytesLoader类型参数的回调函数
		 */		
		public var loadCompleteCalback:Function;
		public var actionData:ActionData;
		private var _time:int;
		private var completeIndex:int=0;
		private var len:int;

		public function BytesObjectLoad()
		{
			actionData=new ActionData();
		}
		
		
		/**  imageObject {dataArr:Vector.<Object>[{x:x,y:y,delay:delay,frameIndex:frameIndex,action:action,direction:direction,data:Vector.<ByteArray>([])}}],headerData:Object}
		 */		
		public function load(imageObject:Object):void
		{
			_time=getTimer();
			actionData.headerData=imageObject.headerData;
			var bytesArr:Vector.<Object>=imageObject.dataArr;
			len=bytesArr.length;
			var obj:Object;
			var _bytesLoaders:BytesLoaders;
			for(var i:int=0;i<len;++i)
			{
				 obj=bytesArr[i];
				_bytesLoaders=new BytesLoaders(); 
				_bytesLoaders.load(obj.data)
				_bytesLoaders.data={x:obj.x,y:obj.y,delay:obj.delay,frameIndex:obj.frameIndex,action:obj.action,direction:obj.direction}
				_bytesLoaders.loadCompleteCalback=loadComplete;
			}
		}
		private function loadComplete(_bytesLoaders:BytesLoaders):void
		{
			var rbg:BitmapData=Bitmap(_bytesLoaders.contentArr[0]).bitmapData;
			var ra:BitmapData=Bitmap(_bytesLoaders.contentArr[1]).bitmapData;
			var myBitmapData:BitmapData=ImageAlphaUtil.MergeAlphaData(rbg,ra);
			rbg.dispose();
			ra.dispose();
			var bitmapDataEx:BitmapDataEx=new BitmapDataEx();
			bitmapDataEx.bitmapData=myBitmapData;
			bitmapDataEx.x=_bytesLoaders.data.x;
			bitmapDataEx.y=_bytesLoaders.data.y;
			bitmapDataEx.delay=_bytesLoaders.data.delay;
			bitmapDataEx.frameIndex=_bytesLoaders.data.frameIndex;
			var action:int=_bytesLoaders.data.action;
			var direction:int=_bytesLoaders.data.direction;
			if(!actionData.dataDict[action]) actionData.dataDict[action]=new Dictionary()
			if(!actionData.dataDict[action][direction]) 
			{
				actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>();
				actionData.dataDict[action][direction].length=actionData.headerData[action][direction]["len"];
			}
			actionData.dataDict[action][direction][bitmapDataEx.frameIndex]=bitmapDataEx;
			
			completeIndex++;
			if(completeIndex>=len)
			{
				var dif:int=getTimer()-_time;
				trace("加载bytesArray使用时间::",dif);
				if(loadCompleteCalback!=null) loadCompleteCalback(this);
			}
		}		
	}
}