package com.YFFramework.game.core.module.guild.view.guildMain.addMember
{
	import com.YFFramework.game.core.module.guild.view.GuildNormalPage;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *请求加入公会成员分页
	 *@author ludingchang 时间：2013-7-19 下午3:15:26
	 */
	public class ReMemberPage extends GuildNormalPage
	{
		public static const uiName:String="Guild_add_member_page";;
		
		private var _sort_career:MovieClip;
		private var _sort_sex:MovieClip;
		private var _sort_lv:MovieClip;
		private var _sort_time:MovieClip;
		
		public function ReMemberPage(view:Sprite)
		{
			super(view);
		}
		private function onSort(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _sort_career:
					sort(_sort_career,"career");
					break;
				case _sort_lv:
					sort(_sort_lv,"lv");
					break;
				case _sort_sex:
					sort(_sort_sex,"sex");
					break;
				case _sort_time:
					sort(_sort_time,"last_time");
					break;
			}
			
		}
		//===================================================
		//override
		//===================================================
		override protected function initPageList():void
		{
			_pageList=new ReMemberList;
		}
		override protected function initCustermUI():void
		{
			_sort_career=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_career");
			_sort_lv=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_lv");
			_sort_sex=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_sex");
			_sort_time=Xdis.getChildAndAddClickEvent(onSort,_mc,"sort_time");
			
			_sort_career.gotoAndStop(1);
			_sort_lv.gotoAndStop(1);
			_sort_sex.gotoAndStop(1);
			_sort_time.gotoAndStop(1);
			
			_sort_career.buttonMode=true;
			_sort_lv.buttonMode=true;
			_sort_sex.buttonMode=true;
			_sort_time.buttonMode=true;
		}
		override public function dispose():void
		{
			_sort_career.removeEventListener(MouseEvent.CLICK,onSort);
			_sort_lv.removeEventListener(MouseEvent.CLICK,onSort);
			_sort_sex.removeEventListener(MouseEvent.CLICK,onSort);
			_sort_time.removeEventListener(MouseEvent.CLICK,onSort);
			
			_sort_career=null;
			_sort_lv=null;
			_sort_sex=null;
			_sort_time=null;
			
			super.dispose();
		}
		
	}
}