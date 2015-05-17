package com.YFFramework.core.utils.net
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.net.loader.hswf.HswfLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.loader.map.MapLoader;
	import com.YFFramework.core.net.loader.mapFile.XXFileLoader;
	import com.YFFramework.core.net.loader.yf2d.YF2dLoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *   管理所有的动作资源的加载
	 *   2012-7-3
	 *	@author yefeng
	 */
	public class SourceCache extends EventDispatcher
	{
		
		 ////   so 缓存处理   加载的方法上面加上一个字段  场景   用来 标志  该资源属于哪个场景       必须常驻内存的资源 用另一个标志  ExistAllScene, 其他的用 场景id 来进行标志
		/** 所有的场景都存在
		 */
		public static const ExistAllScene:String="ExistAllScene";
		
		private var _dict:Dictionary;
		/** 已经处于加载状态的对象 防止重复加载
		 */
		private var _loadedDict:Dictionary;
		private static var _instance:SourceCache;
		private var _pivot:Point;
		public function SourceCache()
		{
			_dict=new Dictionary();
			_loadedDict=new Dictionary();
		}
		
		public static function get Instance():SourceCache
		{
			if(!_instance) _instance=new SourceCache();
			return _instance;
		}
		
		/**  在加载时 先使用 getRes(url)判断该对象是否已经存在了防止重加载
		 * exsitFlag   表示的是exsitFlag 存在标志  , 他的作用是用来释放内存的  每切换一个场景  都会有一次内存的释放，当exsitFlag 值为非ExistAllScene 时，也就是填写 mapId 时 ，上一个场景的资源将会全部被释放掉
		 *  加载资源   目前只注册 .chitu 文件 和 swf文件 用来创建 ActionData   data是要传递的变量   pivot  加载swf时  是对mc定位的轴点
		 */
		public function  loadRes(url:String,data:Object=null,exsitFlag:Object="ExistAllScene",pivot:Point=null):void
		{
			_pivot=pivot;
			///当正处于加载阶段
			if(_loadedDict[url])   /// 当处于正在加载阶段
			{
				_loadedDict[url].push(data);
				return ;
			}
		
			if(!_loadedDict[url]) _loadedDict[url]=new Vector.<Object>();  	//第一个加载
			_loadedDict[url].push(data);

			var dataObj:Object=getRes(url);
			if(dataObj)			///如果资源存在
			{
			//	当已经加载完成后  直接返回
				if(exsitFlag==ExistAllScene)existAllSceneRes(url,dataObj);
				dispatchEvent(new ParamEvent(url,_loadedDict[url]));
				if(_loadedDict[url])
				{
					_loadedDict[url]=null;
					delete _loadedDict[url];
				}
				return ;
			}
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
			 var bytes:ByteArray=ShareObjectManager.Instance.getObjByteArray(url) as ByteArray;
			 switch(suffix)
			 {
				 case  "chitu":
					 var hswfLoader:HswfLoader=new HswfLoader();
					 if(bytes)  ///如果缓存存在
					 {
						 bytes.uncompress();
						 hswfLoader.loadCompleteCallback=chituCallback;
						 hswfLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
					//	 print(this,"缓存取数据............url="+url);

					 }else 
					 {
						 hswfLoader.loadCompleteCallback=chituCallback;
						 hswfLoader.load(url,{url:url,exsitFlag:exsitFlag});
					 }
					 break;
				 case "yf2d":
					 var yf2dLoader:YF2dLoader=new YF2dLoader();
					 if(bytes)  ///如果缓存存在
					 {
						 bytes.uncompress();
						 yf2dLoader.loadCompleteCallback=yf2dCallBack;
						 yf2dLoader.analyseData(bytes,{url:url,exsitFlag:exsitFlag});
						 //	 print(this,"缓存取数据............url="+url);
						 
					 }else 
					 {
						 yf2dLoader.loadCompleteCallback=yf2dCallBack;
						 yf2dLoader.load(url,{url:url,exsitFlag:exsitFlag});
					 }
					 break;
				 case "swf":
					 var loader:UILoader=new UILoader();
					 if(bytes)  ///如果缓存存在
					 {
						 bytes.uncompress();
						 loader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:loader});
						 loader.loadCompleteCallback=loadedCall;
					 }
					 else 
					 {
						 loader.loadCompleteCallback=loadedCall;
						 loader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:loader});
					 }
					 break;
				 case "xx2d": //地图文件
					 var xxLoader:XXFileLoader=new XXFileLoader();
					 xxLoader.loadCompleteCallback=xxFileLoad;
					 xxLoader.initData(url,{url:url,exsitFlag:exsitFlag});
					 break;
				 case "jpg":
				 case "png":  ///图片文件
					 var picLoader:UILoader=new UILoader();
					 if(bytes)  ///如果缓存存在
					 {
						 bytes.uncompress();
						 picLoader.loadBytes(bytes,{url:url,exsitFlag:exsitFlag,loader:picLoader});
						 picLoader.loadCompleteCallback=picLoaded;

					 }
					 else 
					 {
						 picLoader.loadCompleteCallback=picLoaded;
						 picLoader.initData(url,null,{url:url,exsitFlag:exsitFlag,loader:picLoader});
					 }
					 break;
				 case "map":///  atfbytes  file
					 var mapLoader:MapLoader=new MapLoader();
					 if(bytes)  ///如果缓存存在
					 {
						 bytes.uncompress();
						 mapLoaderComplete(bytes,{url:url,exsitFlag:exsitFlag,loader:picLoader});
					 }
					 else 
					 {
						 mapLoader.loadCompleteCallBack=mapLoaderComplete;
						 mapLoader.load(url,{url:url,exsitFlag:exsitFlag,loader:picLoader});
					 }
					 break;
			 }
			 
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
				if(myObj)return myObj;
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
			dispatchEvent(new ParamEvent(url,_loadedDict[url]));
			_loadedDict[url]=null;
			delete _loadedDict[url];
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
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url    返回的是一个加载队列
			_loadedDict[url]=null;
			delete _loadedDict[url];
			
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var swfBytes:ByteArray=loader.getContentBytes()
				swfBytes.compress();
				ShareObjectManager.Instance.put(url,swfBytes);	
				print(this,"图片jpg/png格式,存储数据:url="+url,"length="+swfBytes.length);
			}
		}
		
		///  finished load
		private  function mapLoaderComplete(bytes:ByteArray,data:Object):void
		{
			var url:String=String(data.url);
			var exsitFlag:Object=data.exsitFlag;
			var loader:UILoader=data.loader;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=bytes;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,bytes);
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url    返回的是一个加载队列
			_loadedDict[url]=null;
			delete _loadedDict[url];
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var swfBytes:ByteArray=new ByteArray();
				swfBytes.writeBytes(bytes);
				swfBytes.compress();
				ShareObjectManager.Instance.put(url,swfBytes);	
				print(this,"图片map格式,存储数据:url="+url,"length="+swfBytes.length);
			}
		}
		/**content必须为 MovieClip类型 否则 资源有问题 资源重做 
		 */
		protected function loadedCall(content:DisplayObject,data:Object):void
		{
			var mc:MovieClip=content as MovieClip;
			var actionData:ActionData=Cast.MCToActionData(mc,30,_pivot);///加载 swf需要注意中心点的位置
			var url:String=String(data.url);
			var exsitFlag:Object=data.exsitFlag;
			var loader:UILoader=data.loader;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=actionData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url    返回的是一个加载队列
			_loadedDict[url]=null;
			delete _loadedDict[url];
			
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var swfBytes:ByteArray=loader.getContentBytes()
				swfBytes.compress();
				ShareObjectManager.Instance.put(url,swfBytes);	
				print(this,"swf格式,存储数据:url="+url,"length="+swfBytes.length);
			}
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
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url 
			_loadedDict[url]=null;
			delete _loadedDict[url];
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var hswfBytes:ByteArray=loader.getHSwfByteArray();
				hswfBytes.compress();
				loader.dispose();
				ShareObjectManager.Instance.put(url,hswfBytes);	
				print(this,"chitu格式,存储数据:url="+url,"length="+hswfBytes.length);
			}
		}
		/** yf2d文件打开
		 */		
		private function yf2dCallBack(loader:YF2dLoader,data:Object):void
		{
			var exsitFlag:Object=data.exsitFlag;
			var actionData:YF2dActionData=loader.actionData;
			var url:String=data.url;
			if(_dict[exsitFlag]==null)_dict[exsitFlag]=new Dictionary();
			_dict[exsitFlag][url]=actionData;
			if(exsitFlag==ExistAllScene) existAllSceneRes(url,actionData);
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url 
			_loadedDict[url]=null;
			delete _loadedDict[url];
			///处理so缓存 
			var isExist:Boolean=ShareObjectManager.Instance.isExsit(url);
			if(!isExist) //不存在
			{
				var yf2dBytes:ByteArray=loader.getHSwfByteArray();
				yf2dBytes.compress();
				loader.dispose();
				ShareObjectManager.Instance.put(url,yf2dBytes);	
				print(this,"yf2d格式,存储数据:url="+url,"length="+yf2dBytes.length);
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
						else if(data is YF2dActionData)YF2dActionData(data).dispose();
						else if(data is BitmapData) //当数据为bitmapData时
						{
							BitmapData(data).dispose();
						}
						else if(data is ByteArray)
						{
							ByteArray(data).clear();
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
						else   /// map  
						{
							data=null;	
						}
					}
					_dict[flag]=null;
					delete _dict[flag];
				}
			}
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