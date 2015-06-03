package com.YFFramework.game.core.module.guild.manager
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/***
	 *公会背景管理类
	 *@author ludingchang 时间：2013-8-7 上午9:41:50
	 */
	public class GuildBackgroundManager
	{
		private static var _inst:GuildBackgroundManager;
		
		private var _publicBG:Dictionary;
		private var _callbackBG:Dictionary;
		
		public static function get Instence():GuildBackgroundManager
		{
			return _inst||=new GuildBackgroundManager;
		}
		
		public function GuildBackgroundManager()
		{
			_publicBG=new Dictionary(true);
			_callbackBG=new Dictionary(true);
		}
		
		private function loadComplete(content:DisplayObject,url:String):void
		{
			if(url==DyModuleUIManager.guildMarketWinBg)//公用的对象
			{
				var rec:Rectangle=content.getBounds(content);
				var bmd:BitmapData=new BitmapData(rec.width,rec.height,true,0);
				bmd.draw(content);
				_publicBG[url]=bmd;
				var bg:Sprite=_callbackBG[url];
				bg.removeChild(content);//因为UIloader会自动把content添加到BG里
				bg.addChild(new Bitmap(bmd));
			}
		}
		/**
		 *读取背景。 
		 * @param url 背景地址
		 * @param bg 得到背景后添加到的容器
		 * 
		 */		
		public function loadBG(url:String,bg:Sprite):void
		{
			if(_publicBG[url])
				bg.addChild(new Bitmap(_publicBG[url]));
			else
			{
				if(!_callbackBG[url])
				{
					var _loader:UILoader=new UILoader;
					_loader.loadCompleteCallback=loadComplete;
					_loader.initData(url,bg,url);
				}
				_callbackBG[url]=bg;
			}
		}
	}
}