package com.YFFramework.game.core.module.pk.view
{
	/**@author yefeng
	 * 2013 2013-5-7 下午2:38:38 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.pk.manager.CompeteDyManager;
	import com.YFFramework.game.core.module.pk.model.CompeteDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CompeteSimpleWindow extends PopMiniWindow
	{
		
		private var _mc:MovieClip;
		private var yes_button:Button;
		private var no_button:Button;
		private var view_button:Button;
		public var competeDyVo:CompeteDyVo;
		public function CompeteSimpleWindow()
		{
			_mc = initByArgument(300,160,"inviteAlert") as MovieClip;
			AutoBuild.replaceAll(_mc);
			yes_button = Xdis.getChildAndAddClickEvent(onClickEvent,_mc,"yes_button");
			no_button = Xdis.getChildAndAddClickEvent(onClickEvent,_mc,"no_button");
			view_button = Xdis.getChildAndAddClickEvent(onClickEvent,_mc,"view_button");
			
			view_button.textField.text = "查看信息";
			var format:TextFormat = new TextFormat();
			format.underline = true;
			view_button.textField.setTextFormat(format);
			view_button.textField.textColor = TypeProps.C1ff1e0;
			
			var statusTxt:TextField=_mc.statusTxt;
			statusTxt.text="邀请你切磋，是否同意？";
			statusTxt.textColor=TypeProps.Cfff0b6;
		}
		private function onClickEvent(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case yes_button://同意切磋
					YFEventCenter.Instance.dispatchEventWith(PKEvent.C_AcceptCompete,competeDyVo.dyId);
					close();
					break;
				case no_button:
					close();
					break;
				case view_button:
					ModuleManager.rankModule.otherPlayerReq(competeDyVo.dyId);
					break;
			}
		}
		
		public function updateView():void
		{
			var arr:Array=CompeteDyManager.Instance.getPkArray();
			competeDyVo=arr[0];
			_mc.nameTxt.htmlText=HTMLFormat.color(competeDyVo.name,TypeProps.C5ec700)+HTMLFormat.color("（"+competeDyVo.level+"级）",TypeProps.Cf0f275);
		}
		
		override public function close(event:Event=null):void{
			super.close(event);
			CompeteDyManager.Instance.clear();
		}
		
		public function popBack():void
		{
			super.close();
		}
	}
}