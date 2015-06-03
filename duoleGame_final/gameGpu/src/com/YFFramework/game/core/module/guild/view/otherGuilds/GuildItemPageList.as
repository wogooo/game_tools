package com.YFFramework.game.core.module.guild.view.otherGuilds
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/***
	 *加入公会面板分页控制
	 *@author ludingchang 时间：2013-7-15 下午2:43:39
	 */
	public class GuildItemPageList extends PageItemListBase
	{
		private var _dic:Dictionary;
		
		public function GuildItemPageList()
		{
			super();
			_dic=new Dictionary;
		}
		override protected function initItem(data:Object, view:Sprite, index:int):void
		{
			var _txt:Vector.<TextField>=new Vector.<TextField>(5);
			var _apply:Button;
			var _lookup:Button;
			var _data:GuildItemVo;
			_data=data as GuildItemVo;
			_dic[view]=_data;
			var i:int,len:int=4;
			for(i=0;i<len;i++)
			{
				_txt[i+1]=Xdis.getChild(view,"txt"+(i+1));
			}
			_apply=Xdis.getChildAndAddClickEvent(onApply,view,"apply_button");
			_lookup=Xdis.getChildAndAddClickEvent(onLookup,view,"lookup_button");
			_txt[1].text=_data.name;
			_txt[1].filters=FilterConfig.text_filter;
			_txt[2].text=_data.lv.toString();
			_txt[3].text=_data.master;
			_txt[4].text=_data.member+"/"+_data.total;
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=25
				&& _data.member!=_data.total && !GuildInfoManager.Instence.hasGuild)
				_apply.enabled=true;
			else
				_apply.enabled=false;
		}
		private function onLookup(e:MouseEvent):void
		{
			var data:GuildItemVo=_dic[(e.currentTarget as Button).parent];
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupGuildInfo,data);
		}
		
		private function onApply(e:MouseEvent):void
		{
			var data:GuildItemVo=_dic[(e.currentTarget as Button).parent];
			if(data.member==data.total)
				NoticeManager.setNotice(NoticeType.Notice_id_1313);
			else
			{
				var applys:Array=GuildInfoManager.Instence.applys;
				if(applys.length==GuildConfig.GuildMaxApply)
				{
//					NoticeUtil.setOperatorNotice("您已申请太多公会，请休息一下！");
					NoticeManager.setNotice(NoticeType.Notice_id_1322);
				}
				else if(applys.indexOf(data.id)!=-1)
				{
//					NoticeUtil.setOperatorNotice("您已申请过该公会");
					NoticeManager.setNotice(NoticeType.Notice_id_1323);
				}
				else
				{
					if(applys.push(data.id)==GuildConfig.GuildMaxApply)
					var id:uint=setTimeout(function():void{
						applys.length=0;
						clearTimeout(id);
					},GuildConfig.MaxApplyTime);
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.ApplyGuild,data);
				}
			}
		}
		override protected function disposeItem(view:Sprite):void
		{
			var _apply:Button=Xdis.getChildAndAddClickEvent(onApply,view,"apply_button");
			var _lookup:Button=Xdis.getChildAndAddClickEvent(onLookup,view,"lookup_button");
			_apply.removeMouseClickEventListener(onApply);
			_lookup.removeMouseClickEventListener(onLookup);
			_dic[view]=null;
			delete _dic[view];
		}
	}
}