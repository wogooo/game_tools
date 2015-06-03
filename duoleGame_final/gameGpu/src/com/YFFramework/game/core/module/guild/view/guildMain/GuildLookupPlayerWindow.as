package com.YFFramework.game.core.module.guild.view.guildMain
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildInvitePlayerVo;
	import com.YFFramework.game.core.module.guild.model.GuildPlayerLookupInfoVo;
	import com.YFFramework.game.core.module.guild.model.GuildPlayerLookupVo;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.core.module.guild.view.GuildTabWindow;
	import com.YFFramework.game.core.module.guild.view.InputText;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/***
	 *查询玩家信息窗口
	 *@author ludingchang 时间：2013-7-22 下午3:37:42
	 */
	public class GuildLookupPlayerWindow extends PopMiniWindow
	{
		private static const uiName:String="Guild_lookup_player";
		
		private static var _inst:GuildLookupPlayerWindow;
		
		private var _sp:Sprite;
		private var _name:InputText;
		private var _lookupBtn:Button;
		private var _sndMsgBtn:Button;
		private var _invateBtn:Button;
		private var _infoName:TextField;
		private var _infoCareer:TextField;
		private var _infoSex:TextField;
		private var _infoLv:TextField;
		private var _infoGuild:TextField;
		private var _icon:IconImage;
		private var _data:GuildPlayerLookupInfoVo;
		private var _hasInit:Boolean;
		
		public static function get Instence():GuildLookupPlayerWindow
		{
			if(!_inst)
				_inst=new GuildLookupPlayerWindow;
			return _inst;
		}
		public function GuildLookupPlayerWindow()
		{
			isOpenUseTween=false;//自己重写
		}
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				_sp=initByArgument(400,350,uiName,WindowTittleName.LookUp);
				
				var name:TextField=Xdis.getTextChild(_sp,"name_txt");
				_name=new InputText(name,"请输入玩家名");
				_infoName=Xdis.getTextChild(_sp,"name_info");
				_infoCareer=Xdis.getTextChild(_sp,"career_info");
				_infoSex=Xdis.getTextChild(_sp,"sex_info");
				_infoLv=Xdis.getTextChild(_sp,"lv_info");
				_infoGuild=Xdis.getTextChild(_sp,"guild_info");
				_icon=Xdis.getChild(_sp,"icon_iconImage");
				
				_lookupBtn=Xdis.getChildAndAddClickEvent(onLookup,_sp,"lookup_button");
				_sndMsgBtn=Xdis.getChildAndAddClickEvent(onSendMsg,_sp,"sendMsg_button");
				_invateBtn=Xdis.getChildAndAddClickEvent(onInvate,_sp,"invate_button");
				
				_name.setMaxChars(8);
				
				setData(null);
			}
		}
		
		private function onInvate(e:MouseEvent):void
		{
			// 邀请
			var playerVo:GuildInvitePlayerVo=new GuildInvitePlayerVo;
			playerVo.dyId=_data.id;
			playerVo.lv=_data.lv;
			playerVo.guildName=_data.guildName;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.InvatePlayer,playerVo);
		}
		
		private function onSendMsg(e:MouseEvent):void
		{
			// 私聊
			var privateTalkPlayerVo:PrivateTalkPlayerVo=new PrivateTalkPlayerVo();
			privateTalkPlayerVo.dyId=_data.id;
			privateTalkPlayerVo.name=_data.name;
			privateTalkPlayerVo.sex=_data.sex;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,privateTalkPlayerVo);
		}
		
		private function onLookup(e:MouseEvent):void
		{
			if(!_name.isSelected||_name.text=="")
			{
//				NoticeUtil.setOperatorNotice("请输入玩家名");
				NoticeManager.setNotice(NoticeType.Notice_id_1324);
				return;
			}
			// 查询
			var vo:GuildPlayerLookupVo=new GuildPlayerLookupVo;
			vo.name=_name.text;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupPlayer,vo);
		}
		public function setData(vo:GuildPlayerLookupInfoVo):void
		{
			_data=vo;
			if(!vo)
			{
				_infoCareer.text="";
				_infoGuild.text="";
				_infoLv.text="";
				_infoName.text="";
				_infoSex.text="";
				_sndMsgBtn.enabled=false;
				_invateBtn.enabled=false;
				_icon.url="";
			}
			else
			{
				_infoCareer.text=TypeRole.getCareerName(vo.career);
				_infoGuild.text=vo.guildName;
				_infoLv.text=vo.lv.toString();
				_infoName.text=vo.name;
				_infoSex.text=TypeRole.getSexName(vo.sex);
				_sndMsgBtn.enabled=true;
				_invateBtn.enabled=TypeGuild.canAskInvater(GuildInfoManager.Instence.me.position);
				_icon.url=CharacterPointBasicManager.Instance.getFriendBigIconURL(vo.career,vo.sex);
			}
		}
		public override function open():void
		{
			init();
			super.open();
			resetPos();
		}
		private function resetPos():void
		{
			var rec:Rectangle;
			var posX:int,posY:int;
			if(GuildTabWindow.Instence.isOpen)
			{
				rec=GuildTabWindow.Instence.getBounds(GuildTabWindow.Instence.parent);
				posX=rec.x+rec.width;
				posY=rec.y+rec.height/2-this.height/2;
				TweenLite.to(this,.5,{x:posX,y:posY,alpha:1});
			}
		}
	}
}