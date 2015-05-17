package com.dolo.ui.managers
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * @author flashk 组件初始化
	 */
	public class UIInit
	{
		
		public static function initUISkin(stage:Stage,topLayer:Sprite):void
		{
			com.dolo.ui.managers.UI.init(stage,topLayer);
			com.dolo.ui.controls.Window.titleTextformat.letterSpacing = 5;
		}
		
	}
}