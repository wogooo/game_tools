package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildGonggaoVo;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/***
	 *公会信息控制类
	 *@author ludingchang 时间：2013-8-3 下午1:43:36
	 */
	public class GuildInfoCtrl
	{
		private var _view:Sprite;
		private var _impeach_button:TextField;
		private var _guild_name:TextField;
		private var _guild_master:TextField;
		private var _guild_lv:TextField;
		private var _guild_member:TextField;
		private var _guild_money:TextField;
		private var _guild_gonggao:TextField;
		private var _exitBtn:Button;
		private var _contributionBtn:Button;
		private var _publishBtn:Button;
		public function GuildInfoCtrl(view:Sprite)
		{
			_view=view;
			_impeach_button=Xdis.getChildAndAddClickEvent(onBtnClick,_view,"impeach_txt");
			_exitBtn=Xdis.getChildAndAddClickEvent(onBtnClick,_view,"exit_button");
			_contributionBtn=Xdis.getChildAndAddClickEvent(onBtnClick,_view,"contribution_button");
			_publishBtn=Xdis.getChildAndAddClickEvent(onBtnClick,_view,"publish_button");
			
			_guild_name=Xdis.getTextChild(_view,"name_txt");
			_guild_master=Xdis.getTextChild(_view,"master_txt");
			_guild_lv=Xdis.getTextChild(_view,"lv_txt");
			_guild_member=Xdis.getTextChild(_view,"members_txt");
			_guild_money=Xdis.getTextChild(_view,"money_txt");
			_guild_gonggao=Xdis.getTextChild(_view,"gonggao_txt");
			_guild_gonggao.maxChars=GuildConfig.GonggaoMaxChars;
			_guild_gonggao.doubleClickEnabled=true;
			_guild_gonggao.selectable=false;
			_guild_gonggao.addEventListener(MouseEvent.DOUBLE_CLICK,editGonggao);
			
			var filter:Array=FilterConfig.text_filter;
			_guild_gonggao.filters=filter;
			_guild_lv.filters=filter;
			_guild_master.filters=filter;
			_guild_member.filters=filter;
			_guild_money.filters=filter;
			_guild_name.filters=filter;
			_impeach_button.filters=filter;
			btnTxt(_impeach_button);
		}
		
		private function btnTxt(txt:TextField):void
		{
			var t:String=txt.text;
			txt.htmlText="<u><font>"+t+"</font></u>";
			txt.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			txt.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
		}
		
		protected function mouseOut(event:MouseEvent):void
		{
			Mouse.cursor=MouseCursor.AUTO;
		}
		
		protected function mouseOver(event:MouseEvent):void
		{
			Mouse.cursor=MouseCursor.BUTTON;
		}
		protected function editGonggao(event:MouseEvent):void
		{
			var pos:int=GuildInfoManager.Instence.me.position;
			if(TypeGuild.canPostGonggao(pos))
			{
				_guild_gonggao.selectable=true;
				_guild_gonggao.type=TextFieldType.INPUT;
				_guild_gonggao.setSelection(_guild_gonggao.length,_guild_gonggao.length);
				_guild_gonggao.addEventListener(FocusEvent.FOCUS_OUT,editOver);
				_guild_gonggao.removeEventListener(MouseEvent.DOUBLE_CLICK,editGonggao);
			}
		}
		
		protected function editOver(event:FocusEvent):void
		{
			_guild_gonggao.type=TextFieldType.DYNAMIC;
			_guild_gonggao.selectable=false;
			_guild_gonggao.addEventListener(MouseEvent.DOUBLE_CLICK,editGonggao);
			_guild_gonggao.removeEventListener(FocusEvent.FOCUS_OUT,editOver);
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var eType:String;
			var vo:Object;
			switch(e.currentTarget)
			{
				case _impeach_button://弹劾
					eType=GuildInfoEvent.Impeach;
					break;
				case _publishBtn://发布公告
					if(GuildInfoManager.Instence.myGuildInfo.gonggao==_guild_gonggao.text)
					{
//						NoticeUtil.setOperatorNotice("公告未修改不能发布");
						NoticeManager.setNotice(NoticeType.Notice_id_1327);
						return;
					}
					var ggv:GuildGonggaoVo=new GuildGonggaoVo;
					ggv.gonggao=ChatFilterManager.filter(_guild_gonggao.text);
					eType=GuildInfoEvent.PostGonggao;
					vo=ggv;
					break;
				case _contributionBtn://公会捐献
					eType=GuildInfoEvent.Contribution;
					break;
				case _exitBtn://退出公会
					if(GuildInfoManager.Instence.me.position==TypeGuild.position_master
						&&GuildInfoManager.Instence.myGuildInfo.item.member!=1)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1315);
						return;
					}
					eType=GuildInfoEvent.ExitGuild;
					break;
			}
			YFEventCenter.Instance.dispatchEventWith(eType,vo);
		}
		public function update(vo:GuildInfoVo):void
		{
			_guild_gonggao.text=vo.gonggao;
			_guild_lv.text=vo.item.lv.toString();
			_guild_master.text=vo.item.master;
			_guild_member.text=vo.item.member+"/"+vo.item.total;
			_guild_money.text=vo.money.toString()/*+"/"+vo.max_money*/;
			_guild_name.text=vo.item.name;
			var pos:int=GuildInfoManager.Instence.me.position;
			_publishBtn.enabled=TypeGuild.canPostGonggao(pos);
			_exitBtn.enabled=!((pos==TypeGuild.position_master)&&GuildInfoManager.Instence.myGuildInfo.item.member!=1);
			_impeach_button.visible=(pos!=TypeGuild.position_master);
			var lastT:Number=GuildInfoManager.Instence.findMemberByPostion(TypeGuild.position_master)[0].last_time;
			UI.setEnable(_impeach_button,(lastT!=0 && (new Date).time/1000-lastT>=GuildConfig.ImpeachConditionTime));
		}
		public function dispose():void
		{
			_impeach_button.removeEventListener(MouseEvent.CLICK,onBtnClick);
			_impeach_button.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			_impeach_button.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			_exitBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			_contributionBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			_publishBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			
			 _view=null;
			 _impeach_button=null;
			 _guild_name=null;
			 _guild_master=null;
			 _guild_lv=null;
			 _guild_member=null;
			 _guild_money=null;
			 _guild_gonggao=null;
			 _exitBtn=null;
			 _contributionBtn=null;
			 _publishBtn=null;
		}
	}
}