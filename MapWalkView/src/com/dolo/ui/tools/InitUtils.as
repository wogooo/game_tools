package com.dolo.ui.tools
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.dolo.ui.controls.Window;
	
	import flash.display.Sprite;

	public class InitUtils
	{
		public static function initWindow(window:Window,width:Number,height:Number,linkName:String,isAutoBuildLinkContenttitle:Boolean=true,title:String=""):Sprite
		{
			window.setSize(width,height);
			window.title = title;
			var ui:Sprite = ClassInstance.getInstance(linkName);
			window.content = ui;
			return ui;
		}
		
	}
}