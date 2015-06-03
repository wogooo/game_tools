package com.YFFramework.game.core.global.view.tips
{
	/**
	 * 加载大的Window所有背景图   具有游戏logo显示
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-7-30 上午9:46:13
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.view.progressbar.LogoView;
	import com.dolo.ui.managers.UIManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	public class ModuleLoader 
	{
//		private var _completeDict:Dictionary;
//		private var _loadingDict:Dictionary;
		/**方法回调 */		
		private var _callDict:Dictionary;
		
		
		private static var _instance:ModuleLoader;
		
		private var _logo:LogoView;
		
		public function ModuleLoader()
		{
//			_completeDict=new Dictionary();
//			_loadingDict=new Dictionary();	
			_callDict=new Dictionary();
		}
		public static function get instance():ModuleLoader
		{
			if(_instance == null) _instance=new ModuleLoader();
			return _instance;
		}
		
		public function initLoader(url:String,logoHolder:Sprite=null,bgHolder:Sprite=null,completeCall:Function=null):void
		{
//			if((!_completeDict[url]) && (!_loadingDict[url]))
//			{
				_logo=new LogoView();
				logoHolder.addChild(_logo);
				PopUpManager.centerPopUp(_logo);
				
				var loader:UILoader=new UILoader();
				loader.loadCompleteCallback=loaderComplete;
				if(_logo)
					loader.progressCallBack=progressCallBack;
				loader.initData(url,bgHolder,{url:url,logo:_logo});
//				_loadingDict[url]=url;
				if(completeCall != null)
					_callDict[url]=completeCall;
//			}
//			else if(_completeDict[url])  //如果已经加载完成
//			{
//				completeCall();
//			}
		}
		private function progressCallBack(e:ProgressEvent):void
		{
			if(_logo)
			{
				var loadedPecent:int=100*e.bytesLoaded/e.bytesTotal;
				_logo.updatePercent(loadedPecent);
			}
		}
		
		private function loaderComplete(content:DisplayObject,data:Object):void
		{
			var url:String=data.url;
			var logo:LogoView=data.logo as LogoView;
			if(logo && logo.parent)
			{
				logo.parent.removeChild(logo);
				logo.dispose();
				logo=null;
			}
			if(_callDict[url]!=null)_callDict[url]();
//			_loadingDict[url]=null;
//			delete _loadingDict[url];
			_callDict[url]=null;
			delete _callDict[url];
//			_completeDict[url]=url;
		}
		
		
	}
} 