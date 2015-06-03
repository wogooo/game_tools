package com.dolo.ui.tools
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/***
	 *闪烁特效类
	 *@author ludingchang 时间：2013-11-22 下午1:17:24
	 */
	public class FlashEff extends AbsView
	{
		/**用url来区分加载状态*/
		private static var _dic:Dictionary=new Dictionary;
		/**加载完需要回调的*/
		private static var _load:Dictionary=new Dictionary;
		/**已经载入完毕*/
		private static const Loaded:int=1;
		/**载入中*/
		private static const Loading:int=2;
		
		private static const STOP:int=0;
		private static const PLAY:int=1;

		
		private var _url:String;
		private var _currentState:int;
		private var _asLink:String;
		private var _farmeRate:int;
		private var _mc:MovieClipPlayer;
		
		public function FlashEff(url:String,asLink:String,frameRate:int)//frameRate参数有问题，需要大一点的值才有效
		{
			_url=url;
			_currentState=STOP;
			_asLink=asLink;
			_farmeRate=frameRate;
			if(_dic[url]!=null)//已经有过加载了
			{
				if(_dic[url]==Loaded)//已经载入了
				{
					_mc=new MovieClipPlayer(null,_farmeRate);
					_mc.initMC(ClassInstance.getInstance(_asLink));
					addChild(_mc);
				}
				else if(_dic[url]==Loading)//载入中
				{
					(_load[url] as Array).push(this);
				}
			}
			else//从未加载过
			{
				var loader:UILoader=new UILoader;
				loader.loadCompleteCallback=callback;
				loader.initData(url);
				_dic[url]=Loading;
				_load[url]=[this];
			}
		}
		private function callback(content:DisplayObject,url:*):void
		{
			_dic[_url]=Loaded;
			var effs:Array=_load[_url];
			var i:int,len:int=effs.length;
			for(i=0;i<len;i++)
			{
				var mc:MovieClipPlayer=new MovieClipPlayer(null,_farmeRate);
				mc.initMC(ClassInstance.getInstance(_asLink));
				(effs[i] as FlashEff)._mc=mc;
				(effs[i] as FlashEff).addChild(mc);
				(effs[i] as FlashEff).update();
			}
			delete _load[_url]; 
			effs.length=0;
		}
		private function update():void
		{
			if(_currentState==PLAY)
				_mc.start();
			else if(_currentState==STOP)
				_mc.stop();
		}
		public function play():void
		{
			_currentState=PLAY;
			if(_mc)
				_mc.start();
		}
		public function stop():void
		{
			_currentState=STOP;
			if(_mc)
				_mc.stop();
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_mc=null;
		}
	}
}