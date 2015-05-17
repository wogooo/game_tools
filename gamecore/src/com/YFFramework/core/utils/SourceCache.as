package com.YFFramework.core.utils
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.net.loader.hswf.HswfLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.loader.mapFile.XXFileLoader;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 *   管理所有的动作资源的加载
	 *   2012-7-3
	 *	@author yefeng
	 */
	public class SourceCache extends EventDispatcher
	{
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
		 *  加载资源   目前只注册 .chitu 文件 和 swf文件 用来创建 ActionData   data是要传递的变量   pivot  加载swf时  是对mc定位的轴点
		 */
		public function  loadRes(url:String,data:Object=null,pivot:Point=null):void
		{
			_pivot=pivot;
			///当正处于加载阶段
			if(_loadedDict[url])   /// 当处于政治加载阶段
			{
				_loadedDict[url].push(data);
				return ;
			}
		
			if(!_loadedDict[url]) _loadedDict[url]=new Vector.<Object>();  	//第一个加载
			_loadedDict[url].push(data);
			
			if(_dict[url]) 
			{  //当已经加载完成后  直接返回
				dispatchEvent(new ParamEvent(url,_loadedDict[url]));
				if(_loadedDict[url])
				{
					_loadedDict[url]=null;
					delete _loadedDict[url];
				}
				return ;
			}


			///开始资源加载
			///根据 url 判断资源类型
			 var index:int=url.lastIndexOf(".");
			 var suffix:String=url.substring(index+1);//后缀
			 
			 switch(suffix)
			 {
				 case  "chitu":
					 var hswfLoader:HswfLoader=new HswfLoader();
					 hswfLoader.load(url);
					 hswfLoader.loadCompleteCallback=chituCallback;
					 break;
				 case "swf":
					 var loader:UILoader=new UILoader();
					 loader.initData(url,null,{url:url});
					 loader.loadCompleteCallback=loadedCall;
					 break;
				 case "xx": //地图文件
					 var xxLoader:XXFileLoader=new XXFileLoader();
					 xxLoader.loadCompleteCallback=xxFileLoad;
					 xxLoader.initData(url,url);
					 break;
			 }
			 
		}
		
		private function xxFileLoad(xxObj:Object,data:Object):void
		{
			var url:String=String(data);
			_dict[url]=xxObj;
			dispatchEvent(new ParamEvent(url,_loadedDict[url]));
			_loadedDict[url]=null;
			delete _loadedDict[url];
		}
		/**释放资源
		 */
		public function disposeRes(url:String):void
		{
			if(_dict[url])
			{
				if(_dict[url] is ActionData) ActionData(_dict[url]).dispose();
				else if(_dict[url] is Object) // xx文件
				{
					_dict[url].tileW=null
					_dict[url].tileH=null
					_dict[url].gridW=null
					_dict[url].gridH=null
					_dict[url].rows=null
					_dict[url].columns=null
					disposeObj(_dict[url].building);
					_dict[url].building=null;
					delete _dict[url].building;
					disposeObj(_dict[url].npc);
					_dict[url].npc=null;
					delete _dict[url].npc;
				}
				_dict[url]=null;
				delete _dict[url];
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
		/**  获取资源
		 */
		public function getRes(url:String):Object
		{
			return _dict[url];			
		}
		
		/** 根据资源获取相应的资源地址
		 */
		public function getResUrl(data:Object):String
		{
			for(var url:String in _dict)
			{
				if(_dict[url]==data)return url;
			}
			return null;
		}
		
		
		/**content必须为 MovieClip类型 否则 资源有问题 资源重做 
		 */
		protected function loadedCall(content:DisplayObject,data:Object):void
		{
				var mc:MovieClip=content as MovieClip;
				var actionData:ActionData=Cast.MCToActionData(mc,30,_pivot);///加载 swf需要注意中心点的位置
				var url:String=String(data.url);
				_dict[url]=actionData;
				dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url    返回的是一个加载队列
				_loadedDict[url]=null;
				delete _loadedDict[url];
		}
		
		/** chitu资源文件
		 */
		private function chituCallback(loader:HswfLoader,data:Object):void
		{
			var actionData:ActionData=loader.actionData;
			var url:String=loader.url;
			_dict[url]=actionData;
			dispatchEvent(new ParamEvent(url,_loadedDict[url])); ///发送事件    类型是 url 
			_loadedDict[url]=null;
			delete _loadedDict[url];
		}
		
//		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
//		{
//			if(!hasEventListener(type))	super.addEventListener(type, listener, useCapture, priority, useWeakReference);
//		}
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
	}
}