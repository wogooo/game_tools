package com.YFFramework.game.core.module.newGuide.view
{
	/** 任务面板的提示  点击 [...]自动寻路 
	 * @author yefeng
	 * 2013 2013-7-2 下午4:37:15 
	 */
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**任务面板的提示  点击 [...]自动寻路
	 */	
	public class NewGuideTaskPanelTip extends AbsView
	{
		private var _textField:TextField;
		private var _mc:Sprite;
		public function NewGuideTaskPanelTip()
		{
			super(false);
			mouseChildren=mouseEnabled=false
		}
		override protected function initUI():void
		{
			_mc=ClassInstance.getInstance("skin_TaskPanelGuide");
			addChild(_mc);
			_textField=new TextField();
			addChild(_textField);
			_textField.autoSize="left";
			_textField.textColor=0xFFFFFF;
			_textField.x=7;
			_textField.y=21;
		}
		public function setTips(targetName:String):void
		{
			_textField.width=200;
			var str:String="点击"+HTMLUtil.setFont(targetName,"#00FF00")+"自动寻路";
			_textField.htmlText=str;
			_textField.width=_textField.textWidth+15;
			_mc.width=_textField.width+12;
		}
	}
}