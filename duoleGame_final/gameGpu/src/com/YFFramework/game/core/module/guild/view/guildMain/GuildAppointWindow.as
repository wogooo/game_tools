package com.YFFramework.game.core.module.guild.view.guildMain
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildAppointVo;
	import com.YFFramework.game.core.module.guild.model.GuildMemberVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***
	 *职位任命窗口
	 *@author ludingchang 时间：2013-7-18 下午2:32:13
	 */
	public class GuildAppointWindow extends Window
	{
		private static const uiName:String="Guild_appoint";
		private static const bgURL:String="guild/guild_appoint_bg.swf";
		private static var _inst:GuildAppointWindow;
		private var _okBtn:Button;
		private var _listBtn:Button;
		private var _name:TextField;
		private var _default:TextField;
		private var _vo:GuildMemberVo;
		private var _menu:Menu;
		/**目标职位*/
		private var _target:int;
		private var _bgBig:Sprite;
		private var _bgSmall:Sprite;
		private var _hasInit:Boolean=false;
		
		public static function get Instence():GuildAppointWindow
		{
			if(!_inst)
				_inst=new GuildAppointWindow;
			return _inst;
		}
		public function GuildAppointWindow()
		{
			
		}
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				var sp:Sprite=initByArgument(730,585,uiName,WindowTittleName.Guild,true);
				_bgBig=new Sprite;
				sp.addChildAt(_bgBig,0);
				_bgSmall=new Sprite;
				sp.addChildAt(_bgSmall,1);
				setContentXY(25,23);
				var item:Sprite;
				var len:int=10,i:int;
				var lv:TextField,vice:TextField,elite:TextField;
				for(i=1;i<=len;i++)
				{
					item=sp.getChildByName("item"+i) as Sprite;
					lv=item.getChildByName("lv_txt") as TextField;
					vice=item.getChildByName("vice_txt") as TextField;
					elite=item.getChildByName("elite_txt") as TextField;
					lv.text=i.toString();
					vice.text=GuildInfoManager.Instence.totalViceMaster(i).toString();
					elite.text=GuildInfoManager.Instence.totalElite(i).toString();
				}
				_menu=new Menu;
				_okBtn=Xdis.getChildAndAddClickEvent(onOKclick,sp,"appoint_button");
				_listBtn=Xdis.getChildAndAddClickEvent(onList,sp,"list_button");
				_default=Xdis.getTextChild(sp,"list_txt");
				_name=Xdis.getChild(sp,"name_txt");
				_name.filters=FilterConfig.text_filter;
				_default.filters=FilterConfig.text_filter;
			}
		}
		private function checkBackground():void
		{
			if(_bgBig.numChildren==0)
				GuildBackgroundManager.Instence.loadBG(DyModuleUIManager.guildMarketWinBg,_bgBig);
			if(_bgSmall.numChildren==0)
				GuildBackgroundManager.Instence.loadBG(URLTool.getDyModuleUI(bgURL),_bgSmall);
		}
		private function onList(e:MouseEvent):void
		{
			setContent(_vo);
			_menu.show(_default,0,_default.height+2);
		}
		public override function open():void
		{
			init();
			checkBackground();
			super.open();
			setContent(GuildInfoManager.Instence.selected_member);
		}
		public function setContent(vo:GuildMemberVo):void
		{
			_name.text=vo.name;
			_vo=vo;
			var me:GuildMemberVo=GuildInfoManager.Instence.me;
			_menu.clearAllItem();
			_menu.setSize(_default.width,0);
			if(me.position==TypeGuild.position_master)
			{
				_menu.addItem("副会长",callbackViceMaster);
				_menu.addItem("精英",callbackElite);
				_menu.addItem("普通成员",callbackNormal);
				if(vo.position==TypeGuild.position_vice_master)
					_menu.addItem("会长",callbackMaster);
				_default.text="副会长";
				_target=TypeGuild.position_vice_master;
			}
			else if(me.position==TypeGuild.position_vice_master)
			{
				_menu.addItem("精英",callbackElite);
				_menu.addItem("普通成员",callbackNormal);
				_default.text="精英";
				_target=TypeGuild.position_elite;
			}
		}
		private function callbackMaster(index:int,label:String):void
		{
			_default.text="会长";
			_target=TypeGuild.position_master;
		}
		private function callbackViceMaster(index:int,label:String):void
		{
			_default.text="副会长";
			_target=TypeGuild.position_vice_master;
		}
		private function callbackElite(index:int,label:String):void
		{
			_default.text="精英";
			_target=TypeGuild.position_elite;
		}
		private function callbackNormal(index:int,label:String):void
		{
			_default.text="普通成员";
			_target=TypeGuild.position_normal;
		}
		private function onOKclick(e:MouseEvent):void
		{
			var vo:GuildAppointVo=new GuildAppointVo;
			vo.dy_id=_vo.id;
			switch(_target)
			{
				case TypeGuild.position_master:
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.ChangeMaster);
					break;
				case TypeGuild.position_vice_master://副会长
					vo.position=TypeGuild.position_vice_master;
					if(GuildInfoManager.Instence.getRestViceMasterNum()<=0)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1314);
						return;
					}
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AppointMember,vo);
					break;
				case TypeGuild.position_elite://精英
					vo.position=TypeGuild.position_elite;
					if(GuildInfoManager.Instence.getRestEliteNum()<=0)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1314);
						return;
					}
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AppointMember,vo);
					break;
				case TypeGuild.position_normal://成员
					vo.position=TypeGuild.position_normal;
					if(GuildInfoManager.Instence.getRestNormalNum()<=0)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1314);
						return;
					}
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.AppointMember,vo);
					break;
			}
		}
		public override function dispose():void
		{
			_okBtn.removeMouseClickEventListener(onOKclick);
			_listBtn.removeMouseClickEventListener(onList);
			
			_okBtn=null;
			_listBtn=null;
			_default=null;
			_name=null;
			_vo=null;
			_menu.dispose();
			_menu=null;
			_bgBig=null;
			_bgSmall=null;
			super.dispose();
		}
	}
}