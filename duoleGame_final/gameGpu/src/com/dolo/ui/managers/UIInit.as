package com.dolo.ui.managers
{
	import com.YFFramework.game.debug.Debug;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.sound.GlobalSoundControl;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.GlowFilter;
	
	/**
	 * @author flashk 组件初始化
	 */
	public class UIInit
	{
		
		
		public static function initUISkin(stage:Stage,topLayer:Sprite):void
		{
			com.dolo.ui.managers.UI.init(stage,topLayer);
			com.dolo.ui.controls.Window.titleTextformat.letterSpacing = 5;
			stage.showDefaultContextMenu = false;
//			GlobalSoundControl.getInstance().startDeactivateSwitchListener(stage);
			Debug.isRecordUserOperate = false;
			Debug.isLogTraceInFlashBuilderIDE = false;
			Debug.isWarnTraceInFlashBuilderIDE = false;
			Debug.init(LayerManager.PopLayer,true);
			Debug.maxLine = 10*10000;
			Debug.isOn = true;
			Debug.changeTopTextState("style",0xFF0000);
			Debug.changeTopTextState("show");
			Debug.topTxt.filters = [new GlowFilter(0x0,1,3,3,5,1)];
			Xtip.isMouseMoveUpdateAfterEvent = true;
		}
		
	}
}