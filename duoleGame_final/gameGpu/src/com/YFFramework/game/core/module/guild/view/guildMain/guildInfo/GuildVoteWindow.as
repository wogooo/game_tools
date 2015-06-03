package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildWarningWindowHtml;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/***
	 *公会投票窗口
	 *@author ludingchang 时间：2013-9-4 下午6:04:20
	 */
	public class GuildVoteWindow extends PopMiniWindow
	{
		private static const UIName:String="Guild_vote";
		private static var _inst:GuildVoteWindow;
		
		public static function get Instence():GuildVoteWindow
		{
			return _inst||=new GuildVoteWindow;
		}
		
		private var _ui:Sprite;
		private var _info_txt:TextField;
		private var _okBtn:Button;
		private var _cancleBtn:Button;
		public function GuildVoteWindow()
		{
			super();
			_ui=initByArgument(300,200,UIName);
		    _info_txt=Xdis.getTextChild(_ui,"info_txt");
			_okBtn=Xdis.getChildAndAddClickEvent(onClick,_ui,"ok_button");
			_cancleBtn=Xdis.getChildAndAddClickEvent(onClick,_ui,"cancle_button");
		}
		
		private function onClick(e:Event):void
		{
			switch(e.currentTarget)
			{
				case _okBtn:
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.VoteYes);
					break;
				case _cancleBtn:
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.VoteNo);
					break;
			}
			close();
		}
		
		/**
		 * @param name 发起弹劾的人的名字
		 * @param time 投票截止时间（自1970年1月1日起的秒数）
		 * 
		 */		
		public function setContent(name:String,time:Number):void
		{
			_info_txt.htmlText=GuildWarningWindowHtml.getVoteHtml(name,time);
		}
		
		public override function dispose():void
		{
			_okBtn.removeMouseClickEventListener(onClick);
			_cancleBtn.removeMouseClickEventListener(onClick);
			
			_info_txt=null;
			_okBtn=null;
			_cancleBtn=null;
			_ui=null;
			
			super.dispose();
		}
	}
}