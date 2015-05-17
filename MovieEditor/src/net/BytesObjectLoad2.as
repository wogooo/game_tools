package net 
{
	
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
	
	
	/**  采用 该BytesObjectLoad2代替  BytesObjectLoad
	 *  @author yefeng
	 *   @time:2012-3-16上午10:06:03
	 */
	public class BytesObjectLoad2 extends EventDispatcher
	{
	//	public var dict:Dictionary;
		/** 带BytesLoader类型参数的回调函数
		 */		
		public var loadCompleteCalback:Function;
		public var actionData:ActionData;
		private var _time:int;
		private var completeIndex:int=0;
		private var batchNum:int;
		private var loadLen:int;//总共要加载的次数
		public function BytesObjectLoad2()
		{
			actionData=new ActionData();
		}
		/** imageObject {dataArr:Vector.<Object>[{x:x,y:y,delay:delay,frameIndex:frameIndex,action:action,direction:direction,data:Vector.<ByteArray>([])}}],headerData:Object}
		 * batchNum值越大 越不卡 但是耗时较多 控制在 1秒内 是 小于等于 20
		 */		
		public function load(imageObject:Object,batchNum:int=20):void
		{
			completeIndex=0;
			_time=getTimer();
			var bytesArr:Vector.<Object>=imageObject.dataArr;
			var len:int=bytesArr.length;
			if(len<=batchNum)  batchNum=1;
			this.batchNum=batchNum;
			loadLen=Math.ceil(len/batchNum);
			actionData.headerData=imageObject.headerData;
			var obj:Object;
			var _bytesLoaders:BytesLoaders2;
			var  batchArr:Vector.<Object>;
			var j:int=0;
			for(var i:int=0;i<len;i=i+batchNum)
			{
				batchArr=new Vector.<Object>();
				for(j=0;j!=batchNum;++j)
				{
					if(i+j<len)
					{
						obj=bytesArr[i+j];
						batchArr.push(obj);
					}
				}
				_bytesLoaders=new BytesLoaders2(); 
				_bytesLoaders.load(batchArr);
				_bytesLoaders.loadCompleteCalback=loadComplete;
			}
		}
		private function loadComplete(_bytesLoaders:BytesLoaders2):void
		{
	//		trace("完成..................................................");
			var arr:Vector.<Object>=_bytesLoaders.contentArr;
			var arrLen:int=arr.length;
			
			var rbg:BitmapData;
			var ra:BitmapData;
			var myBitmapData:BitmapData;
			var bitmapDataEx:BitmapDataEx;
			
			var action:int;
			var direction:int;
			var obj:Object;
			
			for(var i:int=0;i!=arrLen;i=i+2)
			{
				
					obj=_bytesLoaders.contentArr[i];
					rbg=obj.bitmapData;
					ra=_bytesLoaders.contentArr[i+1].bitmapData;
					

					action=obj.action;
					direction=obj.direction;
					myBitmapData=ImageAlphaUtil.MergeAlphaData(rbg,ra);
					rbg.dispose();
					ra.dispose();
				//	myBitmapData=rbg;
					bitmapDataEx=new BitmapDataEx();
					bitmapDataEx.bitmapData=myBitmapData;
					bitmapDataEx.x=obj.x;
					bitmapDataEx.y=obj.y;
					bitmapDataEx.delay=obj.delay;
					bitmapDataEx.frameIndex=obj.frameIndex;
					
					if(!actionData.dataDict[action]) actionData.dataDict[action]=new Dictionary()
					if(!actionData.dataDict[action][direction]) 
					{
						actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>();
						actionData.dataDict[action][direction].length=actionData.headerData[action][direction]["len"];
					}
					actionData.dataDict[action][direction][bitmapDataEx.frameIndex]=bitmapDataEx;
			}
			
			completeIndex++;
			if(completeIndex>=loadLen)
			{
				var dif:int=getTimer()-_time;
				trace("加载bytesArray使用时间::",dif);
				if(loadCompleteCalback!=null) loadCompleteCalback(this);
			}
		}
		
		
	}
}