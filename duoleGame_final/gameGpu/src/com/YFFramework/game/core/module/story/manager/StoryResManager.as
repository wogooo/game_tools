package com.YFFramework.game.core.module.story.manager
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/***
	 *剧情资源管理类
	 *@author ludingchang 时间：2013-8-20 下午4:11:10
	 */
	public class StoryResManager
	{
		private static var _inst:StoryResManager;
		
		private var _dic:Dictionary;
		private var _callback:Dictionary;
		
		public static function get Instence():StoryResManager
		{
			return _inst||=new StoryResManager;
		}
		public function StoryResManager()
		{
			_dic=new Dictionary(true);
			_callback=new Dictionary;
		}
		/**
		 *取NPC图标 
		 * @param npcURL 
		 * @param callback 回调函数，其中需要一个参数（dis:displayobject）
		 * 
		 */		
		public function getNPCicon(npcURL:String,callback:Function):void
		{
			if(_dic[npcURL])
				callback(_dic[npcURL]);
			else
			{
				if(!_callback[npcURL])
				{
					var loader:UILoader=new UILoader;
					loader.loadCompleteCallback=myCallback;
					loader.initData(npcURL,null,npcURL);
				}
				_callback[npcURL]=callback;
			}
		}
		private function myCallback(content:DisplayObject,url:String):void
		{
			_callback[url](content);
			delete _callback[url];
			_dic[url]=content;
		}
	}
}