package com.YFFramework.core.utils.net
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.SingltonDispatch;
	import com.YFFramework.core.net.loader.atf.ATFLoader;
	import com.YFFramework.core.net.loader.hswf.HswfLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.loader.map.MapLoaderQueen;
	import com.YFFramework.core.net.loader.mapFile.XXFileLoader;
	import com.YFFramework.core.net.loader.yf2d.YF2dLoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.image.Cast;
	import com.YFFramework.core.yf2d.core.YF2d;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *   管理所有的动作资源的加载
	 *   2012-7-3
	 *	@author yefeng
	 */
	public class SourceCache extends SingltonDispatch
	{
		
		/**同场景  纹理个数达到40释放一次材质
		 */
		public static const MaxTextureLen:int=40; 
		public static var MaxLoader:int=3;
	
		/**队列长度
		 */
		private var _loadQueen:Vector.<SourceCacheQueenData>;
		private var _queenSize:int;
		
		
		 ////   so 缓存处理   加载的方法上面加上一个字段  场景   用来 标志  该资源属于哪个场景       必须常驻内存的资源 用另一个标志  ExistAllScene, 其他的用 场景id 来进行标志
		/** 所有的场景都存在
		 */
		public static const ExistAllScene:String="ExistAllScene";
		
		private var _dict:Dictionary;
		/** 已经处于加载状态的对象 防止重复加载
		 */
		private var _loadedDict:Dictionary;
		
		/**正在加载的个数
		 */
		private var _loadingLen:int;
		/**前一个加载完成的后的时间 
		 */		
//		private var _preLoadCompleteTime:Number=0;
		/**间隔
		 */
//		private static const IntevalTime:int=100;
		/**发送者字典
		 */		
		private var _dispatherDict:Dictionary;
		private static var _instance:SourceCache;
		
		
		
		public function SourceCache()
		{
			_dict=new Dictionary();
			_loadedDict=new Dictionary();
			_dispatherDict=new Dictionary();
			_loadQueen=new Vector.<SourceCacheQueenData>();
			_queenSize=0;
			_loadingLen=0;
			UpdateManager.Instance.SourceCacheLoadCheck.regFunc(checkLoad);
		}
		
		public static function get Instance():SourceCache
		{
			if(!_instance) _instance=new SourceCache();
			return _instance;
		}
		/** queen  为 true  表示队列加载   false 表示 不进行队列加载 
		 */ 
		private function checkLoad(queen:Boolean=true):void
		{
			if(queen)
			{
				
				if(!MapLoaderQueen.Instance.load()) //如果没有地图队列才考虑加载 人物 队列
				{
					if(_queenSize>0)
					{
						if(_loadingLen<MaxLoader)
						{
//							if(getTimer()-_preLoadCompleteTime>=IntevalTime)
//							{
								var sourceCacheData:SourceCacheQueenData=_loadQueen.shift();
								_queenSize--;
								if(_queenSize<0)_queenSize=0;
								initLoader(sourceCacheData.url,sourceCacheData.exsitFlag,sourceCacheData.pivot,sourceCacheData.swfConvert,sourceCacheData.swfLink);
								_loadingLen++;
								SourceCacheQueenData.toPool(sourceCacheData);
//							}
						}
					}
				}
			}
			else 
			{
				var sourceCacheData2:SourceCacheQueenData=_loadQueen.shift();
				_queenSize--;
				if(_queenSize<0)_queenSize=0;
				initLoader(sourceCacheData2.url,sourceCacheData2.exsitFlag,sourceCacheData2.pivot,sourceCacheData2.swfConvert);
				_loadingLen++;
				SourceCacheQueenData.toPool(sourceCacheData2);
			}
		}
		
		
		/**依托 UpdateManager 必须保证 updatemanager已经执行 
		 *  在加载时 先使用 getRes(url)判断该对象是否已经存在了防止重加载
		 * exsitFlag   表示的是exsitFlag 存在标志  , 他的作用是用来释放内存的  每切换一个场景  都会有一次内存的释放，当exsitFlag 值为非ExistAllScene 时，也就是填写 mapId 时 ，上一个场景的资源将会全部被释放掉
		 *  加载资源   目前只注册 .chitu 文件 和 swf文件 用来创建 ActionData   data是要传递的变量   pivot  加载swf时  是对mc定位的轴点
		 * dispather={dispatcher,data},,常规cpu加载需要
		 * 如果加载的为swf  swfConvert  是表示swf能否进行转化为 ActionData
		 */
//		public function  loadRes(url:String,data:Object=null,exsitFlag:Object="ExistAllScene",pivot:Point=null,dispather:Object=null,swfConvert:Boolean=true):void
//		{
//			var sourceCacheData:SourceCacheQueenData=SourceCacheQueenData.getSourceCacheQueenData();
//			sourceCacheData.url=url;
//			sourceCacheData.data=data;
//			sourceCacheData.exsitFlag=exsitFlag;
//			sourceCacheData.pivot=pivot;
//			sourceCacheData.dispather=dispather;
//			sourceCacheData.swfConvert=swfConvert;
//			_loadQueen.push(sourceCacheData);
//			++_queenSize;
//		}

		
		/**  加载 初始化xx2d时候调用 其他情况不要调用 
		 * 强制启动加载
		 * @param url
		 * @param data
		 * @param exsitFlag
		 * @param pivot
		 * @param dispather
		 * @param swfConvert
		 * swfLink是 否作为  场景建筑特效链接名存储
		 * 
		 */
		public function  forceLoadRes(url:String,data:Object=null,exsitFlag:Object="ExistAllScene",pivot:Point=null,dispather:Object=null,swfConvert:Boolean=true,swfLink:Boolean=false):void
		{
			loadRes(url,data,exsitFlag,pivot,dispather,swfConvert,swfLink);
			checkLoad(false);
		}

		
		
		
		/** 
		 *  在加载时 先使用 getRes(url)判断该对象是否已经存在了防止重加载
		 * exsitFlag   表示的是exsitFlag 存在标志  , 他的作用是用来释放内存的  每切换一个场景  都会有一次内存的释放，当exsitFlag 值为非ExistAllScene 时，也就是填写 mapId 时 ，上一个场景的资源将会全部被释放掉
		 *  加载资源   目前只注册 .chitu 文件 和 swf文件 用来创建 ActionData   data是要传递的变量   pivot  加载swf时  是对mc定位的轴点
		 * dispather={dispatcher,data},,常规cpu加载需要
		 * 如果加载的为swf  swfConvert  是表示swf能否进行转化为 ActionData
		 */
		public function  loadRes(url:String,data:Object=null,exsitFlag:Object="ExistAllScene",pivot:Point=null,dispather:Object=null,swfConvert:Boolean=true,swfLink:Boolean=false):void
		{
			///当正处于加载阶段
			if(_loadedDict[url])   /// 当处于正在加载阶段
			{
				if(data)_loadedDict[url].push(data);
				if(dispather)
				{
					if(!_dispatherDict[url])_dispatherDict[url]=new Vector.<Object>();
					_dispatherDict[url].push(dispather);
				}
				return ;
			}
		
			if(!_loadedDict[url]) _loadedDict[url]=new Vector.<Object>();  	//第一个加载
			if(data)_loadedDict[url].push(data);
			if(dispather)
			{
				if(!_dispatherDict[url])_dispatherDict[url]=new Vector.<Object>();
				_dispatherDict[url].push(dispather);
			}

			var dataObj:Object=getRes(url);
			if(dataObj)			///如果资源存在
			{
			//	当已经加载完成后  直接返回
				if(exsitFlag==ExistAllScene)existAllSceneRes(url,dataObj);
				dispathIt(url);
				return ;
			}
			
			//将加载的资源放到队列里面
			var sourceCacheData:SourceCacheQueenData=SourceCacheQueenData.getSourceCacheQueenData();
			sourceCacheData.url=url;
//			sourceCacheData.data=data;
			sourceCacheData.exsitFlag=exsitFlag;
			sourceCacheData.pivot=pivot;
//			sourceCacheData.dispather=dispather;
			sourceCacheData.swfConvert=swfConvert;
			sourceCacheData.swfLink=swfLink;
			_loadQueen.push(sourceCacheData);
			++_queenSize;
			
	
			/**
			
			///开始资源加载  判断类型
			var str:String=url;
			 ///先取  问号
			 var index:int=str.indexOf("?");
			 if(index!=-1)str=str.substring(0,index);
			 index=	 str.lastIndexOf(".");
			 ///根据 url 判断资源类型
			 var suffix:String=str.substring(index+1);//后缀
			 
			 ////首先从缓存中取出来
//			 var bytes:ByteArray=ShareObjectManager.Instance.getObjByteArray(url) as ByteArray;
			 switch(suffix)
			 {
				 case  "chitu":
					 var hswfLoader:HswfLoader=new HswfLoader();
//					 if(bytes)  ///如果缓存存在
//					 {
//						 hswfLoader.loadCompleteCallback=chituCallback;
//						 hswfLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
//					//	 print(this,"缓存取数据............url="+url);
//
//					 }else 
//					 {
						 hswfLoader.loadCompleteCallback=chituCallback;
						 hswfLoader.load(url,{url:url,exsitFlag:exsitFlag});
//					 }
					 break;
				 case "yf2d":
					 var yf2dLoader:YF2dLoader=new YF2dLoader();
//					 if(bytes)  ///如果缓存存在
//					 {
//						 yf2dLoader.loadCompleteCallback=yf2dCallBack;
//						 yf2dLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
//						 //	 print(this,"缓存取数据............url="+url);
//						 
//					 }else 
//					 {
						 yf2dLoader.loadCompleteCallback=yf2dCallBack;
						 yf2dLoader.load(url,{url:url,exsitFlag:exsitFlag});
//					 }
					 break;
				 case "atfMovie":
					 var atfMovieLoader:ATFLoader=new ATFLoader();
					 atfMovieLoader.loadCompleteCallback=atfCallback;
					 atfMovieLoader.load(url,{url:url,exsitFlag:exsitFlag});
					 break;
				 case "swf":
					 var loader:UILoader=new UILoader();
//					 if(bytes)  ///如果缓存存在
//					 {
//						 loader.loadCompleteCallback=loadedCall;
//						 loader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:loader,pivot:pivot,swfConvert:swfConvert});
//					 }
//					 else 
//					 {
						 loader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:loader,pivot:pivot,swfConvert:swfConvert});
						 loader.loadCompleteCallback=loadedCall;
//					 }
					 break;
				 case "xx2d": //地图文件
					 var xxLoader:XXFileLoader=new XXFileLoader();
					 xxLoader.loadCompleteCallback=xxFileLoad;
					 xxLoader.initData(url,{url:url,exsitFlag:exsitFlag});
					 break;
				 case "jpg":
				 case "png":  ///图片文件
					 var picLoader:UILoader=new UILoader();
//					 if(bytes)  ///如果缓存存在
//					 {
//						 picLoader.loadCompleteCallback=picLoaded;
//						 picLoader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:picLoader});
//					 }
//					 else 
//					 {
						 picLoader.loadCompleteCallback=picLoaded;
						 picLoader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:picLoader});
//					 }
					 break;
			 }
			 
			 */
		}
		/**实际 进行加载
		 * @param url
		 * @param exsitFlag
		 * @param pivot
		 * @param swfConvert
		 * 
		 */		
		private function initLoader(url:String,exsitFlag:Object="ExistAllScene",pivot:Point=null,swfConvert:Boolean=true,swfLink:Boolean=false):void
		{
			///开始资源加载  判断类型
			var str:String=url;
			///先取  问号
			var index:int=str.indexOf("?");
			if(index!=-1)str=str.substring(0,index);
			index=	 str.lastIndexOf(".");
			///根据 url 判断资源类型
			var suffix:String=str.substring(index+1);//后缀
			//	 print(this,"suffix::"+suffix);
			
			////首先从缓存中取出来
			//			 var bytes:ByteArray=ShareObjectManager.Instance.getObjByteArray(url) as ByteArray;
			switch(suffix)
			{
				case  "chitu":
					var hswfLoader:HswfLoader=new HswfLoader();
					//					 if(bytes)  ///如果缓存存在
					//					 {
					//						 hswfLoader.loadCompleteCallback=chituCallback;
					//						 hswfLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
					//					//	 print(this,"缓存取数据............url="+url);
					//
					//					 }else 
					//					 {
					hswfLoader.loadCompleteCallback=chituCallback;
					hswfLoader.errorCallback=hswfErrorCall;
					hswfLoader.load(url,{url:url,exsitFlag:exsitFlag});

					//					 }
					break;
				case "yf2d":
					var yf2dLoader:YF2dLoader=new YF2dLoader();
					//					 if(bytes)  ///如果缓存存在
					//					 {
					//						 yf2dLoader.loadCompleteCallback=yf2dCallBack;
					//						 yf2dLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
					//						 //	 print(this,"缓存取数据............url="+url);
					//						 
					//					 }else 
					//					 {
					yf2dLoader.loadCompleteCallback=yf2dCallBack;
					yf2dLoader.errorCallback=hswfErrorCall;
					yf2dLoader.load(url,{url:url,exsitFlag:exsitFlag});

					//					 }
					break;
				case "atfMovie":
					var atfMovieLoader:ATFLoader=new ATFLoader();
					atfMovieLoader.loadCompleteCallback=atfCallback;
					atfMovieLoader.errorCallback=hswfErrorCall;
					atfMovieLoader.load(url,{url:url,exsitFlag:exsitFlag});
					break;
				case "swf":
					var loader:UILoader=new UILoader();
					//					 if(bytes)  ///如果缓存存在
					//					 {
					//						 loader.loadCompleteCallback=loadedCall;
					//						 loader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:loader,pivot:pivot,swfConvert:swfConvert});
					//					 }
					//					 else 
					//					 {
					var doMain:ApplicationDomain=null;
					if(swfLink)doMain=new ApplicationDomain();
					loader.loadCompleteCallback=loadedCall;
					loader.ioErrorCallBack=hswfErrorCall;
					loader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:loader,pivot:pivot,swfConvert:swfConvert,swfLink:swfLink,doMain:doMain},doMain);

					//					 }
					break;
				case "xx2d": //地图文件
					var xxLoader:XXFileLoader=new XXFileLoader();
					xxLoader.loadCompleteCallback=xxFileLoad;
					xxLoader.errorCallback=hswfErrorCall;
					xxLoader.initData(url,{url:url,exsitFlag:exsitFlag});
					break;
				case "jpg":
				case "png":  ///图片文件
					var picLoader:UILoader=new UILoader();
					//					 if(bytes)  ///如果缓存存在
					//					 {
					//						 picLoader.loadCompleteCallback=picLoaded;
					//						 picLoader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:picLoader});
					//					 }
					//					 else 
					//					 {
					picLoader.loadCompleteCallback=picLoaded;
					picLoader.ioErrorCallBack=hswfErrorCall;
					picLoader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:picLoader});
					//					 }
					break;
			}
		}
		/**错误地址 从队列中移除 
		 */		
		private function hswfErrorCall(url:String):void
		{
			_loadingLen--;
		}
		
		
		/**发送 事件
		 * @param url
		 */
		private function dispathIt(url:String):void
		{
			dispatchEventWith(url,_loadedDict[url]);
			_loadedDict[url]=null;
			delete _loadedDict[url];
			if(_dispatherDict[url]) //便利发送者
			{
				var dispatch:EventDispatcher;
				var data:Object;
				for each(var eventDispath:Object in _dispatherDict[url])
				{
					if(eventDispath)
					{	
						dispatch=eventDispath.dispatcher;
						data=eventDispath.data;
						dispatch.dispatchEvent(new ParamEvent(url,data));
					}
				}
			}
			_dispatherDict[url]=null;
			delete _dispatherDict[url];
			
			_loadingLen--; //延时 处理
//			_preLoadCompleteTime=getTimer();
		}
		
		
		
		
		/**  获取资源
		 */
//		private function getRes(url:String,exsitFlag:Object="ExistAllScene"):Object
//		{
//			if(_dict[exsitFlag])
//			{
//				return _dict[exsitFlag][url] 
//			}
//			return null;			
//		}
		/**  全局搜索资源    
		 * @param url
		 */		
		public function getRes(url:String):Object
		{
			var myObj:Object=null;
			for each(var myDict:Dictionary in _dict)
			{
				myObj=myDict[url];
				if(myObj)
				{
					return myObj;
				}
			}
			return myObj;			
		}
		
		public function getRes2(url:String,flag:Object="ExistAllScene"):Object
		{
			var myObj:Object=null;
			var myDict:Dictionary=_dict[flag];
			if(myDict)
			{
				myObj=myDict[url];
				return myObj;
			}
			return myObj;			
		}
		
		/**优化资源处理
		 *   将资源整合到常驻内存ExistAllScene中去
		 * url  是键值url
		 * obj是数据对象
		 */		
		private function existAllSceneRes(url:String,obj:Object):void
		{
			var myObj:Object=null;
			for each(var myDict:Dictionary in _dict)
			{
				//遍历所有key值 将key值删掉 
				if(myDict[url])	delete myDict[url];
			}
			//重新将key值设置为ExistAllScene
			_dict[ExistAllScene][url]=obj;
		}
		
		
		/** 根据资源获取相应的资源地址
		 */
		public function getResUrl(data:Object,exsitFlag:Object="ExistAllScene"):String
		{
			for(var url:String in _dict[exsitFlag])
			{
				if(_dict[exsitFlag][url]==data)return url;
			}
			return null;
		}
		
		private function xxFileLoad(xxObj:Object,data:Object):void
		{
			var url:String=String(data.url);
			var exsitFlag:Object=data.exsitFlag;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=xxObj;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,xxObj);
//			dispatchEventWith(url,_loadedDict[url]);
			dispathIt(url);
//			_loadedDict[url]=null;
//			delete _loadedDict[url];
//			_dispatherDict[url]=null;
//			delete _dispatherDict[url];
		}
		/**图片加载完成
		 */
		private function picLoaded(content:DisplayObject,data:Object):void
		{
			var bmp:Bitmap=content as Bitmap;
			var bitmapData:BitmapData=bmp.bitmapData;
			var url:String=String(data.url);
			var exsitFlag:Object=data.exsitFlag;
			var loader:UILoader=data.loader;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=bitmapData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,bitmapData);
//			dispatchEventWith(url,_loadedDict[url]); ///发送事件    类型是 url    返回的是一个加载队列
			dispathIt(url);
//			_loadedDict[url]=null;
//			delete _loadedDict[url];
			
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var swfBytes:ByteArray=loader.getContentBytes()
				ShareObjectManager.Instance.put(url,swfBytes);	
//				print(this,"图片jpg/png格式,存储数据:url="+url,"length="+swfBytes.length);
			}
		}
		/**content必须为 MovieClip类型 否则 资源有问题 资源重做 
		 */
		protected function loadedCall(content:DisplayObject,data:Object):void
		{
			var url:String=String(data.url);
			var exsitFlag:Object=data.exsitFlag;
			var loader:UILoader=data.loader;
			var pivot:Point=data.pivot;
			var swfConvert:Boolean=data.swfConvert;
			var swfLink:Boolean=data.swfLink;
			var doMain:ApplicationDomain=data.doMain;
			
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			if(swfConvert)
			{
				var mc:MovieClip=content as MovieClip;
				var actionData:ActionData=Cast.MCToActionData(mc,30,pivot);///加载 swf需要注意中心点的位置
				_dict[exsitFlag][url]=actionData;
				if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
			}
			else 
			{
				if(!swfLink) //加到主域中去
				{
					_dict[exsitFlag][url]=content; //表示该资源已经加载过  ，目的是为了获取内部的链接名
					if(exsitFlag==ExistAllScene) existAllSceneRes(url,content);
				}
				else //作为链接名
				{
					var swfData:SWFData=new SWFData();
					swfData.doMain=doMain;
					_dict[exsitFlag][url]=swfData; //表示该资源已经加载过  ，目的是为了获取内部的链接名
					if(exsitFlag==ExistAllScene) existAllSceneRes(url,swfData);
				}
			}
			///处理so缓存 
//			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
//			if(!isExist) //不存在
//			{
//				var swfBytes:ByteArray=loader.getContentBytes()
//				ShareObjectManager.Instance.put(url,swfBytes);	
//			}
			
			var t:TimeOut=new TimeOut(30,dispathIt,url);//延迟处理
			t.start();
		//	dispathIt(url);
		}
		
		/** chitu资源文件
		 */
		private function chituCallback(loader:HswfLoader,data:Object):void
		{
			var exsitFlag:Object=data.exsitFlag;
			var actionData:ActionData=loader.actionData;
			var url:String=data.url;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=actionData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
//			dispatchEventWith(url,_loadedDict[url]);
			dispathIt(url);
//			_loadedDict[url]=null;
//			delete _loadedDict[url];
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var hswfBytes:ByteArray=loader.getHSwfByteArray();
				loader.dispose();
				ShareObjectManager.Instance.put(url,hswfBytes);	
//				print(this,"chitu格式,存储数据:url="+url,"length="+hswfBytes.length);
			}
		}
		
		
		
		/** atfMovie文件打开
		 */		
		private function atfCallback(actionData:ATFActionData,data:Object):void
		{
			var exsitFlag:Object=data.exsitFlag;
//			var actionData:ATFActionData=loader.actionData;
			var url:String=data.url;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=actionData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
			dispathIt(url);
			///处理so缓存 
//			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
//			if(!isExist) //不存在
//			{
//				var yf2dBytes:ByteArray=loader.getHSwfByteArray();
//				loader.dispose();
//				ShareObjectManager.Instance.put(url,yf2dBytes);	
//			}
		}
		
		
		
		/** yf2d文件打开
		 */		
		private function yf2dCallBack(loader:YF2dLoader,data:Object):void
		{
			var exsitFlag:Object=data.exsitFlag;
			var actionData:ATFActionData=loader.actionData;
			var url:String=data.url;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=actionData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
//			dispatchEventWith(url,_loadedDict[url]);
			dispathIt(url);
//			_loadedDict[url]=null;
//			delete _loadedDict[url];
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var yf2dBytes:ByteArray=loader.getHSwfByteArray();
				loader.dispose();
				ShareObjectManager.Instance.put(url,yf2dBytes);	
//				print(this,"yf2d格式,存储数据:url="+url,"length="+yf2dBytes.length);
			}
		}

		
		
		/**是否全部加载完成 当前没有加载的对象
		 */
		public function isAllComplete():Boolean
		{
			var len:int=0;
			for each (var item:Object in _loadedDict)
			{
				len++;
			}
			if(len==0)return true;
			return false
		}
		
		
		/**释放所有texture 
		 */
		private function disposeExsitAllSceneTexture():void
		{
			var myDict:Dictionary;
			var data:Object;///具体的数据对象
			for (var flag:Object in _dict)
			{
				if(flag==ExistAllScene)
				{
					myDict=_dict[flag];
					for each(data in myDict)
					{
						if(data is ATFActionData)ATFActionData(data).deleteAllTexture();
					}
				}
			}
		}
		
		/**  释放所有资源 除了 exsitFlag 的资源 以及常驻资源ExistAllScene 以外
		 */		
		public function disposeAllResExcept(exsitFlag:Object):void
		{
			var myDict:Dictionary;
			var data:Object;///具体的数据对象
			for (var flag:Object in _dict)
			{
				if(flag!=ExistAllScene&&flag!=exsitFlag)
				{
					myDict=_dict[flag];
					for each(data in myDict)
					{
						if(data is ActionData)ActionData(data).dispose();
						else if(data is ATFActionData)ATFActionData(data).dispose();
						else if(data is BitmapData) //当数据为bitmapData时
						{
							BitmapData(data).dispose();
						}
						else if(data is SWFData)
						{
							data=null;
						}
						else if(data is Object) // xx文件
						{
							data.tileW=null
							data.tileH=null
							data.gridW=null
							data.gridH=null
							data.rows=null
							data.columns=null
							disposeObj(data.building);
							data.building=null;
							delete data.building;
							disposeObj(data.npc);
							data.npc=null;
							delete data.npc;
						}
					}
					_dict[flag]=null;
					delete _dict[flag];
				}
			}
			YF2d.Instance.disposeContext3D();  ///重 置换 材质数量
		}
		
		/**释放资源
		 * exsitFlag 为资源大类  一般是某个场景 id 
		 * url  是具体的资源地址key 
		 */
		private function disposeRes(url:String,exsitFlag:Object):void
		{
			if(_dict[exsitFlag])
			{
				if(_dict[exsitFlag][url])
				{
					if(_dict[exsitFlag][url] is ActionData) ActionData(_dict[exsitFlag][url]).dispose();
					else if(_dict[exsitFlag][url] is Object) // xx文件
					{
						_dict[exsitFlag][url].tileW=null
						_dict[exsitFlag][url].tileH=null
						_dict[exsitFlag][url].gridW=null
						_dict[exsitFlag][url].gridH=null
						_dict[exsitFlag][url].rows=null
						_dict[exsitFlag][url].columns=null
						disposeObj(_dict[exsitFlag][url].building);
						_dict[exsitFlag][url].building=null;
						delete _dict[exsitFlag][url].building;
						disposeObj(_dict[exsitFlag][url].npc);
						_dict[exsitFlag][url].npc=null;
						delete _dict[exsitFlag][url].npc;
					}
					_dict[exsitFlag][url]=null;
					delete _dict[url];
				}
			}
		}
		/** 释放某个场景的非常驻内存资源
		 */		
		private function disposeScene(exsitFlag:Object):void
		{
			if(_dict[exsitFlag])
			{
				for (var url:String in _dict[exsitFlag])
				{
					disposeRes(url,exsitFlag);
				}
				_dict[exsitFlag]=null;
				delete _dict[exsitFlag];
			}
		}
		
		private function disposeObj(obj:Object):void
		{
			for (var name:String in obj)
			{
				obj[name]=null;
				delete obj[name];
			}
		}
		
	}
}