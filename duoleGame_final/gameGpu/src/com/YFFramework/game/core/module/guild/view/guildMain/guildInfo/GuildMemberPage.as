package com.YFFramework.game.core.module.guild.view.guildMain.guildInfo
{
	import com.YFFramework.game.core.module.guild.view.GuildNormalPage;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *公会信息成员分页
	 *@author ludingchang 时间：2013-7-16 下午3:52:00
	 */
	public class GuildMemberPage extends GuildNormalPage
	{
		public static const uiName:String="Guild_member_page";
		
		private var _sort_position:MovieClip;
		private var _sort_career:MovieClip;
		private var _sort_sex:MovieClip;
		private var _sort_lv:MovieClip;
		private var _sort_gx:MovieClip;
		private var _sort_lt:MovieClip;
		
		public function GuildMemberPage(view:Sprite)
		{
			super(view);
		}
		
		private function onSort(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _sort_position:
					sort(_sort_position,"position");
					break;
				case _sort_career:
					sort(_sort_career,"career");
					break;
				case _sort_gx:
					sort(_sort_gx,"contribution");
					break;
				case _sort_lt:
					sort(_sort_lt,"last_time");
					break;
				case _sort_lv:
					sort(_sort_lv,"lv");
					break;
				case _sort_sex:
					sort(_sort_sex,"sex");
					break;
			}
		}
		
		//==================================
		//override
		//====================================
		override public function dispose():void
		{
			_sort_position.removeEventListener(MouseEvent.CLICK,onSort);
			_sort_career.removeEventListener(MouseEvent.CLICK,onSort);;
			_sort_sex.removeEventListener(MouseEvent.CLICK,onSort);;
			_sort_lv.removeEventListener(MouseEvent.CLICK,onSort);;
			_sort_gx.removeEventListener(MouseEvent.CLICK,onSort);;
			_sort_lt.removeEventListener(MouseEvent.CLICK,onSort);;
			
			_sort_position=null;
			_sort_career=null;
			_sort_sex=null;
			_sort_lv=null;
			_sort_gx=null;
			_sort_lt=null;
			
			super.dispose()
		}
		override protected function getMaxCount():int
		{
			return 10;
		}
		override protected function initPageList():void
		{
			_pageList=new GuildMemberList;
		}
		override protected function initCustermUI():void
		{
			_sort_position=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_position");
			_sort_career=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_career");
			_sort_sex=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_sex");
			_sort_lv=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_lv");
			_sort_gx=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_gx");
			_sort_lt=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_lt");
			
			_sort_position.gotoAndStop(1);
			_sort_career.gotoAndStop(1);
			_sort_sex.gotoAndStop(1);
			_sort_lv.gotoAndStop(1);
			_sort_gx.gotoAndStop(1);
			_sort_lt.gotoAndStop(1);
			_sort_position.buttonMode=true;
			_sort_career.buttonMode=true;
			_sort_sex.buttonMode=true;
			_sort_lv.buttonMode=true;
			_sort_gx.buttonMode=true;
			_sort_lt.buttonMode=true;
		}
		/**
		 *重置选中 
		 * 
		 */		
		public function resetSelectedItem():void
		{
			(_pageList as GuildMemberList).resetSelectedView();
		}
	}
}