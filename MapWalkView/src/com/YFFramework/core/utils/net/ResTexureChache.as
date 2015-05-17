package com.YFFramework.core.utils.net
{
	import com.YFFramework.core.event.SingltonDispatch;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import yf2d.utils.SimpleTextureUtil;

	/** 资源 缓存
	 * 物品掉落到地上的对象的缓存 需要将背包物品 转化为 2的的幂  在进行贴图处理 的 缓存  最终缓存的是  ResSimpleTexture
	 * 2013 2013-4-3 下午4:54:04 
	 */
	public class ResTexureChache extends SingltonDispatch
	{
		private static var  _instance:ResTexureChache;
		private var _dict:Dictionary;
		private var _loadedDict:Dictionary;
		
		public function ResTexureChache()
		{
			_dict=new Dictionary();
			_loadedDict=new Dictionary();
		}
		public static function get Instance():ResTexureChache
		{
			if(_instance==null) _instance=new ResTexureChache();
			return _instance;
		}
		
		public function loadRes(url:String,data:Object=null):void
		{
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
				dispatchEventWith(url,_loadedDict[url]);
				if(_loadedDict[url])
				{
					_loadedDict[url]=null;
					delete _loadedDict[url];
				}
				return ;
			}
			///加载  场景掉落图标
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=completeCall
			loader.initData(url,null,url);
		}
		private function completeCall(bitmap:Bitmap,url:String):void
		{
			var bitmapData:BitmapData=bitmap.bitmapData;
			var obj:Object=SimpleTextureUtil.getTexureData2(bitmapData);  
			_dict[url]=obj;
			dispatchEventWith(url,_loadedDict[url]);
			_loadedDict[url]=null;///发送事件    类型是 url    返回的是一个加载队列
			delete _loadedDict[url];
		}
		/**  全局搜索资源
		 * @param url
		 */		
		public function getRes(url:String):Object
		{
			return _dict[url];
		}
		
		
	}
}