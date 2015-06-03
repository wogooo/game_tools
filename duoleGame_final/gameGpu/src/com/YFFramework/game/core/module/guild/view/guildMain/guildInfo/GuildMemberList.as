package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/***
	 *公会信息页成员表分页控制
	 *@author ludingchang 时间：2013-7-16 下午3:52:32
	 */
	public class GuildMemberList extends PageItemListBase
	{
		private var _menu:Menu=new Menu;
		public function GuildMemberList()
		{
			super();
			_menu=new Menu;
		}
		private function update(selectedPos:int):void
		{
			_menu.clearAllItem();
			var position:int=GuildInfoManager.Instence.me.position;
			if(selectedPos<=position)
				return;
			if(TypeGuild.canSetPosition(position))
				_menu.addItem("任命",callbackSetPosition);
			if(TypeGuild.canFireMember(position))
				_menu.addItem("开除",callbackFireMember);
		}
		
		private function callbackSetPosition(index:int,label:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.Appoint);
		}
		
		private function callbackFireMember(index:int,label:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.Discharge);
		}
		override protected function initItem(data:Object, view:Sprite, index:int):void
		{
			var _data:GuildMemberVo=data as GuildMemberVo;
			var _txt:Vector.<TextField>=new Vector.<TextField>(8);
			for(var i:int=1;i<=7;i++)
			{
				_txt[i]=Xdis.getChild(view,"txt"+i);
			}
			view.getChildByName("eff").visible=false;
			_txt[1].filters=FilterConfig.text_filter;
			setTxt(_txt,_data);
		}
		
		private function setTxt(_txt:Vector.<TextField>,_data:GuildMemberVo):void
		{
			_txt[1].text=_data.name;
			_txt[2].text=TypeGuild.getPositionName(_data.position);
			_txt[3].text=TypeRole.getCareerName(_data.career);
			_txt[4].text=TypeRole.getSexName(_data.sex);
			_txt[5].text=_data.lv.toString();
			_txt[6].text=_data.contribution+"/"+_data.max_contribution;
			_txt[7].text=TimeManager.getTimeDes(_data.last_time);
		}
		override protected function onItemClick(view:Sprite, vo:Object, index:int):void
		{
			GuildInfoManager.Instence.selected_member=vo as GuildMemberVo;
			update((vo as GuildMemberVo).position);
			_menu.show();
		}
		override protected function onItemOver(view:Sprite):void
		{
			view.getChildByName("eff").visible=true;
		}
		override protected function onItemOut(view:Sprite):void
		{
			view.getChildByName("eff").visible=false;
		}
		override protected function onItemSelect(view:Sprite):void
		{
			//将view设置选中状态
			view.getChildByName("eff").visible=true;
			_selectIndex=getViewIndex(view);
//			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.SelectedMember);
		}
		public function resetSelectedView():void
		{
			if(_selectIndex==-1)
				return;
			var view:Sprite=getItemViewAt(_selectIndex);
			_lastSelectView=view;
			onItemSelect(view);
		}
	}
}