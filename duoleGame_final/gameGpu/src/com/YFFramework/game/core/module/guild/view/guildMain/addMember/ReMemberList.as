package com.YFFramework.game.core.module.guild.view.guildMain.addMember
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/***
	 *请求加入公会的人的列表数据
	 *@author ludingchang 时间：2013-7-19 下午3:15:47
	 */
	public class ReMemberList extends PageItemListBase
	{
		private var _dic:Dictionary;
		public function ReMemberList()
		{
			super();
			_dic=new Dictionary;
		}
		override protected function initItem(data:Object, view:Sprite, index:int):void
		{
			var _data:GuildMemberVo=data as GuildMemberVo;
			_dic[view]=_data;
			var _txt:Vector.<TextField>=new Vector.<TextField>(6);
			for(var i:int=1;i<=5;i++)
			{
				_txt[i]=Xdis.getTextChild(view,"txt"+i);
			}
			_txt[1].text=_data.name;
			_txt[2].text=TypeRole.getCareerName(_data.career);
			_txt[3].text=TypeRole.getSexName(_data.sex);
			_txt[4].text=_data.lv.toString();
			_txt[5].text=TimeManager.getTimeDes(_data.last_time);
			
			var okBtn:Button=Xdis.getChildAndAddClickEvent(onOkClick,view,"ok_button");
			var noBtn:Button=Xdis.getChildAndAddClickEvent(onNoClick,view,"no_button");
			var pos:int=GuildInfoManager.Instence.me.position;
			var right:Boolean=TypeGuild.canAddMember(pos);
			okBtn.enabled=right;
			noBtn.enabled=right;
		}
		
		private function onNoClick(e:MouseEvent):void
		{
			var vo:GuildMemberVo=_dic[(e.currentTarget as DisplayObject).parent];
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AddMemberNo,vo);
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			var guildinfo:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			if(guildinfo.item.member==guildinfo.item.total)
				NoticeManager.setNotice(NoticeType.Notice_id_1307);
			else
			{
				var vo:GuildMemberVo=_dic[(e.currentTarget as DisplayObject).parent];
				YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AddMemberOK,vo);
			}
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			var okBtn:Button=Xdis.getChild(view,"ok_button");
			var noBtn:Button=Xdis.getChild(view,"no_button");
			okBtn.removeMouseClickEventListener(onOkClick);
			noBtn.removeMouseClickEventListener(onNoClick);
		}
	}
}