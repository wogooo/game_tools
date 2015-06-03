package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.util.MovieClipCtrl;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/***
	 *翅膀进化、装备升级、坐骑进阶 特效管理类
	 *@author ludingchang 时间：2014-1-7 下午3:37:04
	 */
	public class WingLvUpEffMgr
	{
		private static var _inst:WingLvUpEffMgr;
		public static function get Instence():WingLvUpEffMgr
		{
			return _inst||=new WingLvUpEffMgr;
		}
		
		private var _mc:MovieClip;
		private var _ctrl:MovieClipCtrl;
		private var _isLoaded:Boolean;
		public function WingLvUpEffMgr()
		{
		}
		/**
		 *打开窗口时调用此方法，预加载 
		 */		
		public function loadEff():void
		{
			if(!_isLoaded)
			{
				_isLoaded=true;
				var loader:UILoader=new UILoader;
				loader.loadCompleteCallback=loadCallback;
				loader.initData(URLTool.getCommonEffect_swf("EpLvUp"));
			}
		}
		private function loadCallback(content:MovieClip,data:Object):void
		{
			_mc=content;
			_ctrl=new MovieClipCtrl(_mc,15);
		}
		/**
		 * 播放特效
		 * @param parent 父容器
		 * @param $x X坐标
		 * @param $y Y坐标
		 * 
		 */		
		public function setTo(parent:DisplayObjectContainer,$x:Number=0,$y:Number=0):void
		{
			if(_mc)
			{
				parent.addChild(_mc);
				_mc.x=$x;
				_mc.y=$y;
				_ctrl.playWithTime(1200);
			}
		}
		
		/**
		 *添加特效结束时的回调方法 
		 * @param callback 回调方法
		 * @param params 执行此回调方法时的参数列表
		 */
		public function addCallback(callback:Function,params:Array=null):void
		{
			_ctrl.addCallback(callback,params);
		}
	}
}