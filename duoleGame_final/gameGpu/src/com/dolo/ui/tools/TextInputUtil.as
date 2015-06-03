package com.dolo.ui.tools
{
	import com.dolo.common.XFind;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 下午5:37:05
	 * 
	 */
	public class TextInputUtil
	{
		
		private static var defaultTexts:Array = [];
		private static var defaultTargets:Array = [];
		private static var colorTips:Array = [];
		private static var colorInputs:Array = [];
		
		public static function initDefautText(target:TextField,text:String,isInitFor:Boolean=true,colorInput:int=0xFFFFFF,colorTip:int=0x888888):void
		{
			if(XFind.checkDataIsInArray(target,defaultTargets) == false){
				defaultTexts.push(text);
				defaultTargets.push(target);
				colorInputs.push(colorInput);
				colorTips.push(colorTip);
			}else{
				var index:int = XFind.findIndexInArray(target,defaultTargets);
				defaultTexts[index] = text;
				colorInputs[index] = colorInput;
				colorTips[index] = colorTip;
			}
			target.addEventListener(FocusEvent.FOCUS_IN,checkTextIn);
			target.addEventListener(FocusEvent.FOCUS_OUT,checkTextOut);
			if(isInitFor == true){
				target.text = text;
				target.textColor = colorTip;
			}
		}
		
		public static function clearDefaultText(target:TextField):void
		{
			var index:int = XFind.findIndexInArray(target,defaultTargets);
			if(index!= -1){
				defaultTargets[index] = null;
				defaultTexts[index] = null;
				colorInputs[index] = null;
				colorTips[index] = null;
			}
			target.removeEventListener(FocusEvent.FOCUS_IN,checkTextIn);
			target.removeEventListener(FocusEvent.FOCUS_OUT,checkTextOut);
		}
		
		private static function checkTextIn(event:FocusEvent):void
		{
			var target:TextField = event.currentTarget as TextField;
			var index:int = XFind.findIndexInArray(target,defaultTargets);
			var text:String = defaultTexts[index];
			if(target.text == text){
				target.text = "";
				target.textColor = colorInputs[index];
			}
		}
		private static function checkTextOut(event:FocusEvent):void
		{
			var target:TextField = event.currentTarget as TextField;
			var index:int = XFind.findIndexInArray(target,defaultTargets);
			var text:String = defaultTexts[index];
			if(target.text == ""){
				target.text = text;
				target.textColor = colorTips[index];
			}
		}
		
	}
} 