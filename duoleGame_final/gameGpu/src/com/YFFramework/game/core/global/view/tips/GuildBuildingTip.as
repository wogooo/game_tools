package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.manager.Guild_BuildingBasicManager;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.YFFramework.game.core.module.guild.model.Guild_BuildingBasicVo;
	import com.YFFramework.game.core.module.guild.model.TypeBuilding;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.managers.UI;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/***
	 *公会建筑提示
	 *@author ludingchang 时间：2013-7-25 下午3:19:58
	 */
	public class GuildBuildingTip extends Sprite
	{
		private static const TXT_WIDTH:int=130;
		private static const TXT_X:int=10;
		private static const EACH_HIGHT:int=10;
		private static const TXT_START_Y:int=10;
		private static const BG_W:int=150;

		private var _isDispose:Boolean;
		private var _mc:Sprite;
		private var _name:TextField;
		private var _info:TextField;
		private var _line:Bitmap;
		
		
		public function GuildBuildingTip()
		{
			_mc=TipUtil.tipBackgrounPool.getObject();
			addChild(_mc);
			_mc.width=BG_W;
			
			_line=GlobalPools.bitmapPool.getObject();
			_line.bitmapData=LineBD.bitmapData;
			
			_name=GlobalPools.textFieldPool.getObject();
			_name.width=TXT_WIDTH;
			_name.wordWrap=true;
			_name.multiline=true;
			_name.autoSize=TextFieldAutoSize.LEFT;
			_name.textColor=0x00ffff;
			_name.x=TXT_X;
			_name.y=TXT_START_Y;
			addChild(_name);
			
			_info=GlobalPools.textFieldPool.getObject();
			_info.width=TXT_WIDTH;
			_info.wordWrap=false;
			_info.multiline=true;
			_info.autoSize=TextFieldAutoSize.LEFT;
			_info.textColor=0xffffff;
			addChild(_info);
			
			addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		protected function dispose(event:Event):void
		{
			if(_isDispose)
				return;
			_isDispose=true;
			
			UI.removeAllChilds(this);
			TipUtil.tipBackgrounPool.returnObject(_mc);
			GlobalPools.bitmapPool.returnObject(_line);
			GlobalPools.textFieldPool.returnObject(_name);
			GlobalPools.textFieldPool.returnObject(_info);
			_mc=null;
			_line=null;
			_name=null;
			_info=null;
		}
		private function disposeContent():void
		{
			if(_line.parent)
				_line.parent.removeChild(_line);
			_info.htmlText="";
		}
		public function setTip(type:int):void
		{
			disposeContent();
			if(type==-1)
			{
				_name.text="暂未开放";
				_mc.height=_name.y+_name.height+EACH_HIGHT;
				return;
			}
			var lv:int=GuildInfoManager.Instence.getBuildingLv(type);
			_name.htmlText=getNameHtml(type,lv);
			
			
			if(lv<10)
			{
				addChild(_line);
				_line.x=TXT_X;
				_line.y=_name.y+EACH_HIGHT+_name.height;
				_info.htmlText=getInfoTipHtml(type,lv);
				_info.x=TXT_X;
				_info.y=_line.y+_line.height+EACH_HIGHT;
				_mc.height=_info.y+_info.height+EACH_HIGHT;
			}
			else
				_mc.height=_name.y+_name.height+EACH_HIGHT;
		}
		private function getNameHtml(type:int,lv:int):String
		{
			var buildVo:Guild_BuildingBasicVo=Guild_BuildingBasicManager.Instance.getGuild_BuildingBasicVoByTypeAndLv(type,lv);
			return '<font color="#00ffff">'+buildVo.name+"  Lv"+lv+"</font>"
				+"<br><font>"+buildVo.explain+"</font>";
		}
		private function getInfoTipHtml(type:int,lv:int):String
		{
			var needMoney:int=Guild_BuildingBasicManager.Instance.getUpgradeMoney(type,lv);
			var needLv:int=Guild_BuildingBasicManager.Instance.getUpgradeHallLv(type,lv);
			var guild:GuildInfoVo=GuildInfoManager.Instence.myGuildInfo;
			var corMoney:String,corLv:String;
			var html:String="<font>"+"升级条件"+"</font>"+"<br>";
			
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
		
	}
}