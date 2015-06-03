package com.YFFramework.game.core.module.guild.view.otherGuilds
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildItemVo;
	import com.YFFramework.game.core.module.guild.model.GuildJoinLookupVo;
	import com.YFFramework.game.core.module.guild.model.OtherGuildPageVo;
	import com.YFFramework.game.core.module.guild.view.GuildNormalPage;
	import com.YFFramework.game.core.module.guild.view.InputText;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***
	 *其他公会页 组件
	 *@author ludingchang 时间：2013-7-15 上午11:29:58
	 */
	public class GuildOtherPageCtrl extends GuildNormalPage
	{
		public static const uiName:String="Guild_info_page";
		
		private var _sort_lv_btn:MovieClip;
		private var _sort_member_btn:MovieClip;
		private var _reset_btn:Button;
		private var _lookup_btn:Button;
		private var _lookup_txt:InputText;
		public function GuildOtherPageCtrl(view:Sprite)
		{
			super(view);
		}
		//=========================================
		//override
		//========================================
		override protected function initPageList():void
		{
			_pageList=new GuildItemPageList();
		}
		override protected function initCustermUI():void
		{
			_sort_lv_btn=Xdis.getChildAndAddClickEvent(onSortBtn,_mc,"sort_lv_btn");
			_sort_member_btn=Xdis.getChildAndAddClickEvent(onSortBtn,_mc,"sort_member_btn");
			_lookup_btn=Xdis.getChildAndAddClickEvent(onLookup,_mc,"lookup_button");
			_reset_btn=Xdis.getChildAndAddClickEvent(onReset,_mc,"reset_button");
			var txt:TextField=Xdis.getChild(_mc,"lookup_txt");
			_lookup_txt=new InputText(txt,"请输入公会名");
//			TextInputUtil.initDefautText(_lookup_txt,"请输入公会名");
			_lookup_txt.setMaxChars(16);//最多16个字
			
			_sort_lv_btn.gotoAndStop(1);
			_sort_member_btn.gotoAndStop(1);
			_sort_lv_btn.buttonMode=true;
			_sort_member_btn.buttonMode=true;
		}
		override public function dispose():void
		{
			_sort_lv_btn.removeEventListener(MouseEvent.CLICK,onSortBtn);
			_sort_member_btn.removeEventListener(MouseEvent.CLICK,onSortBtn);
			_sort_lv_btn=null;
			_sort_member_btn=null;
			_lookup_btn.removeMouseClickEventListener(onLookup);
			_reset_btn.removeMouseClickEventListener(onReset);
			_lookup_txt=null;
			_reset_btn=null;
			_lookup_btn=null;
			super.dispose();
		}
		private function onReset(e:MouseEvent):void
		{
			firstPage(null);
			_lookup_txt.reset();
		}
		
		public function resetTxt():void
		{
			_lookup_txt.reset();
		}
		
		private function onLookup(e:MouseEvent):void
		{
			if(!_lookup_txt.isSelected||_lookup_txt.text=="")
			{
				NoticeUtil.setOperatorNotice("请输入公会名");
				return;
			}
			var vo:GuildJoinLookupVo=new GuildJoinLookupVo;
			vo.name=_lookup_txt.text;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupGuild,vo);
		}
		
		/**
		 *排序 
		 * @param e点击的按钮
		 * 
		 */		
		private function onSortBtn(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _sort_lv_btn:
					sort(_sort_lv_btn,"lv");
					break;
				case _sort_member_btn:
					sort(_sort_member_btn,"member");
					break;
			}
		}
		override public function nextPage(event:MouseEvent=null):void
		{
			var vo:OtherGuildPageVo=new OtherGuildPageVo;
			vo.page=_nowPage+1;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AskOtherGuildList,vo);
		}
		override public function prevPage(event:MouseEvent=null):void
		{
			var vo:OtherGuildPageVo=new OtherGuildPageVo;
			vo.page=_nowPage-1;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AskOtherGuildList,vo);
		}
		override public function lastPage(event:MouseEvent=null):void
		{
			var vo:OtherGuildPageVo=new OtherGuildPageVo;
			vo.page=_maxPage;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AskOtherGuildList,vo);
		}
		override public function firstPage(event:MouseEvent=null):void
		{
			var vo:OtherGuildPageVo=new OtherGuildPageVo;
			vo.page=1;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AskOtherGuildList,vo);
		}
	}
}