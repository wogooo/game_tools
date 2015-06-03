package com.YFFramework.game.core.module.guild.view.guildMain.building
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.YFFramework.game.core.module.guild.model.GuildBuildingUpgradeVo;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.YFFramework.game.core.module.guild.model.TypeGuild;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***
	 *
	 *@author ludingchang 时间：2014-1-15 上午9:34:48
	 */
	public class GuildBuildItemList extends PageItemListBase
	{

		private var _type:int;
		private var _name_txt:TextField;
		private var _lv_txt:TextField;
		private var _info_txt:TextField;
		private var _need_txt:TextField;
		private var _bg:MovieClip;
		private var _upBtn:Button;
		private var _img:IconImage;
		public function GuildBuildItemList()
		{
			super();
		}
		
		override protected function initItem(data:Object, view:Sprite, index:int):void
		{
			_type=data as int;
			_name_txt=Xdis.getTextChild(view,"name_txt");
			_lv_txt=Xdis.getTextChild(view,"lv_txt");
			_info_txt=Xdis.getTextChild(view,"info_txt");
			_need_txt=Xdis.getTextChild(view,"need_txt");
			
			_bg=Xdis.getMovieClipChild(view,"bg");
			_bg.gotoAndStop(2);
			
			_upBtn=Xdis.getChildAndAddClickEvent(onUpClick,view,"upgrade_button");
			_img=Xdis.getChild(view,"img_iconImage");
			
			updateInfo();
		}
		
		private function updateInfo():void
		{
			var lv:int=GuildInfoManager.Instence.getBuildingLv(_type);
			_name_txt.text=TypeBuilding.getBuildingNameByType(_type);
			var url:String=TypeBuilding.getBuildingImgByType(_type);
			if(url!="")
				_img.url=URLTool.getDyModuleUI(url);
			if(lv<1)
				lv=1;
			_lv_txt.text="LV."+lv;
			if(lv<10)
				_need_txt.htmlText=getInfoTipHtml(_type,lv);
			else
				_need_txt.text="满级";
			_info_txt.text=Guild_BuildingBasicManager.Instance.getBuildingInfoByType(_type,lv);
			
			checkBtnEnable(lv);
		}
		
		private function getInfoTipHtml(type:int,lv:int):String
		{
			var needMoney:int=Guild_BuildingBasicManager.Instance.getUpgradeMoney(type,lv);
			var needLv:int=Guild_BuildingBasicManager.Instance.getUpgradeHallLv(type,lv);
			var guild:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			var corMoney:String,corLv:String;
			var html:String="";
			
			if(type!=TypeBuilding.HALL)
			{
				if(guild.item.lv<needLv)
					corLv='"#ff0000"';
				else
					corLv='"#ffffff"';
				html+="<font>大厅等级：</font>"+"<font color="+corLv+">"+needLv+"</font><br>";
			}
			if(guild.money<needMoney)
				corMoney='"#ff0000"';
			else
				corMoney='"#ffffff"';
			return html+"<font>公会资金:</font>"+"<font color="+corMoney+">"+needMoney+"</font>";
		}
		
		/**
		 *设置按钮是否可点 
		 */		
		public function checkBtnEnable(lv:int):void
		{
			if(_type==-1)
			{//未开放
				_upBtn.visible=false;
				_upBtn.enabled=false;
				_bg.gotoAndStop(1);
				return;
			}
			_bg.gotoAndStop(2);
			if(TypeGuild.canUpgradeBuilding(GuildInfoManager.Instence.me.position))//有升级建筑的权限
			{
				_upBtn.visible=true;
				var needMoney:Number=Guild_BuildingBasicManager.Instance.getUpgradeMoney(_type,lv);
				var needLv:int=Guild_BuildingBasicManager.Instance.getUpgradeHallLv(_type,lv);
				var b:Boolean=lv<GuildConfig.GuildBuildingMaxLevel
					&& GuildInfoManager.Instence.myGuildInfo.money>=needMoney;
				if(_type==TypeBuilding.HALL)
					_upBtn.enabled=b;
				else
					_upBtn.enabled=b&&GuildInfoManager.Instence.myGuildInfo.item.lv>=needLv;
			}
			else
				_upBtn.visible=false;
		}
		
		private function onUpClick(e:MouseEvent):void
		{
			var vo:GuildBuildingUpgradeVo=new GuildBuildingUpgradeVo;
			vo.type=_type;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.BuildingUpgrade,vo);
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			_name_txt=null;
			_lv_txt=null;
			_info_txt=null;
			_need_txt=null;
			_bg=null;
			if(_upBtn)
				_upBtn.removeMouseClickEventListener(onUpClick);
			_upBtn=null;
			if(_img)
				_img.clear();
			_img=null;
		}
	}
}