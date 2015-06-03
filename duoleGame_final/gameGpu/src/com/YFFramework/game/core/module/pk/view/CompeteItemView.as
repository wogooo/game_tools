package com.YFFramework.game.core.module.pk.view
{
	/**@author yefeng
	 * 2013 2013-5-6 下午4:07:55 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.pk.model.CompeteDyVo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CompeteItemView extends AbsView
	{
		/**点击按钮后的回调
		 */		
		public var callBack:Function;
		private var _mc:MovieClip;
		/**玩家vo 
		 */		
		public var competeDyVo:CompeteDyVo;
		public function CompeteItemView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_mc=ClassInstance.getInstance("uiSkin.Invite") as MovieClip;  ///All.fla下 Team文件夹 mc 文件夹中
			addChild(_mc);
			_mc.view_button.buttonMode=true;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_mc.yes_button.addEventListener(MouseEvent.CLICK,onClick);
			_mc.no_button.addEventListener(MouseEvent.CLICK,onClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_mc.yes_button.removeEventListener(MouseEvent.CLICK,onClick);
			_mc.no_button.removeEventListener(MouseEvent.CLICK,onClick);
		}

		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _mc.yes_button:
					YFEventCenter.Instance.dispatchEventWith(PKEvent.C_AcceptCompete,competeDyVo.dyId);
					callBack(this);
					break;
				case _mc.no_button:
					callBack(this);
 					break;
			}
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_mc=null;
			competeDyVo=null;
		}
		/**玩家id 
		 */		
		public function updateView(competeDyVo:CompeteDyVo):void
		{
			this.competeDyVo=competeDyVo;
			var levelStr:String=HTMLUtil.setFont("("+competeDyVo.level+"级)");
			var nameStr:String=competeDyVo.name+levelStr;
			_mc.nameTxt.htmlText=nameStr;
			_mc.dataTxt.text="邀请你切磋，是否同意?";
			_mc.view_button.label_txt.text="查看信息";
		}
		

		
	}
}