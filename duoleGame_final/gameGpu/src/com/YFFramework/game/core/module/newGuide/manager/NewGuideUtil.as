package com.YFFramework.game.core.module.newGuide.manager
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**@author yefeng
	 * 2013 2013-7-1 下午7:20:19 
	 */
	public class NewGuideUtil
	{
		public function NewGuideUtil()
		{
		}
		/**获取引导文本的 区域范围  范围是在  textFiled内部的范围
		 */		
		public static function getGuideTextRect(textField:TextField,guideTxt:String):Rectangle
		{
			var startIndex:int=textField.text.indexOf(guideTxt);
			var endIndex:int=startIndex+guideTxt.length-1
			var rectStart:Rectangle=textField.getCharBoundaries(startIndex);
			var rectEnd:Rectangle=textField.getCharBoundaries(endIndex);
			var heightSpace:int=2
			var rect:Rectangle=new Rectangle(rectStart.x,rectStart.y-heightSpace,rectEnd.width+rectEnd.x-rectStart.x,rectEnd.height+heightSpace+1);
			return rect;
		}
		
		
	}
}