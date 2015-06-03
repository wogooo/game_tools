package com.YFFramework.core.net.loader.map
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.utils.ByteArray;

	/**地图加载队列
	 * @author yefeng
	 * 2013 2013-10-26 上午11:53:02 
	 */
	public class MapLoaderQueen
	{
		
		/**最大并发数
		 */
		public static var MaxLoader:int=4;
		private var _arr:Vector.<MapLoader>;  //加载队列
		/**待加载的队列个数
		 */		
		private var _size:int;
		
		/**正在加载的个数
		 */
		private var _loadingLen:int; 
		
//		private var _preLoadTime:Number=0;
		
		/**解码队列
		 */		
//		private var _callBackArr:Vector.<CallBackData>;
//		private var _callBackSize:int;
		
		private static var _instance:MapLoaderQueen;
		public function MapLoaderQueen()
		{
			_arr=new Vector.<MapLoader>(); 
//			_callBackArr=new Vector.<CallBackData>();
//			_callBackSize=0;
			_size=0; 
			_loadingLen=0;
//			UpdateManager.Instance.MapLoadCheck.regFunc(checkLoad);
//			UpdateManager.Instance.MapCallBackCheck.regFunc(callbackCheck);
		}
		public static function get Instance():MapLoaderQueen
		{
			if(!_instance)
			{
				_instance=new MapLoaderQueen();
			}
			return _instance;	
		}
//		private function callbackCheck():void
//		{
//			if(_callBackSize>0)
//			{
//				var callBackData:CallBackData=_callBackArr.shift();
//				callBackData.func(callBackData.bytes,callBackData.data);
//				CallBackData.toCallBackDataPool(callBackData);
//				_callBackSize--;
//				_loadingLen--;
//			}
//		}
		public function addLoader(loader:MapLoader,url:String,data:Object,callBack:Function):void
		{
			_arr.push(loader);
			loader.initData(url,{data:data,callBack:callBack,loader:loader});
			loader.loadCompleteCallBack=callbackHandle;
			loader.ioErrorCallback=ioErrorCall;
			_size++;
		}
//		private function checkLoad():void
//		{
//			load();
//		}
		
		private function ioErrorCall(url:String):void
		{
			_loadingLen--;
		}
			
		
		public  function load():Boolean
		{
			if(_size>0)
			{
				if(_loadingLen<MaxLoader)
				{
//					if(getTimer()-_preLoadTime>=20)  //每帧只会有一个进行加载
//					{
//						_preLoadTime=getTimer();
						
						var loader:MapLoader=_arr.shift();
						loader.doLoad();
						_size--; //队列  -- 
						if(_size<0)_size=0;
						++_loadingLen; //加载队列++
					return true;
//					}
				}
			}
			return false;
		}
		
		public function reset():void
		{
			_arr=new Vector.<MapLoader>();
			_size=0;
			_loadingLen=0;
		}
		
		private function callbackHandle(bytes:ByteArray,data:Object):void
		{
			var callBack:Function=data.callBack;
			var myData:Object=data.data;
			
			//			var loader:MapLoader=data.loader;

//			var myCall:CallBackData=CallBackData.getCallBackData();//new CallBackData();
//			myCall.func=callBack;
//			myCall.data=myData;
//			myCall.bytes=bytes;
//			_callBackArr.push(myCall);
//			_callBackSize++;
			
			callBack(bytes,myData);
			_loadingLen--;
		} 

		
	}
}