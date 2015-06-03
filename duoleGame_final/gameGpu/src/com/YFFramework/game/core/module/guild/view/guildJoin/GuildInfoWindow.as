package com.YFFramework.game.core.module.guild.view.guildJoin
{
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.model.GuildInfoVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/***
	 *公会信息窗口
	 *@author ludingchang 时间：2013-7-16 下午2:24:04
	 */
	public class GuildInfoWindow extends PopMiniWindow
	{
		private static var _inst:GuildInfoWindow;
		
		private var _master_txt:TextField;
		private var _lv_txt:TextField;
		private var _member_txt:TextField;
		private var _money_txt:TextField;
		private var _gonggao_txt:TextField;
		private var _name_txt:TextField;
		private var _ok_btn:Button;
		private var _mc:Sprite;
		private var _hasInit:Boolean=false;
		
		public static function get Instence():GuildInfoWindow
		{
			if(!_inst)
				_inst=new GuildInfoWindow;
			return _inst;
		}
		
		public function GuildInfoWindow()
		{
			super();
		}
		
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				this.isOpenUseTween=false;//默认的不用，自己重写
				_mc=initByArgument(330,410,"Guild_info_item",WindowTittleName.GuildInfo);
				_master_txt=Xdis.getChild(_mc,"master_txt");
				_lv_txt=Xdis.getTextChild(_mc,"lv_txt");
				_member_txt=Xdis.getTextChild(_mc,"member_txt");
				_money_txt=Xdis.getTextChild(_mc,"money_txt");
				_gonggao_txt=Xdis.getChild(_mc,"gonggao");
				_name_txt=Xdis.getChild(_mc,"name_txt");
				_ok_btn=Xdis.getChildAndAddClickEvent(close,_mc,"ok_button");
				
				_name_txt.filters=FilterConfig.text_filter;
				_master_txt.filters=FilterConfig.text_filter;
				_lv_txt.filters=FilterConfig.text_filter;
				_member_txt.filters=FilterConfig.text_filter;
				_money_txt.filters=FilterConfig.text_filter;
				_gonggao_txt.filters=FilterConfig.text_filter;
			}
		}
		
		public function setInfoAndGonggao(vo:GuildInfoVo):void
		{
			_name_txt.text=vo.item.name;
			_master_txt.text=vo.item.master
			_lv_txt.text=vo.item.lv.toString();
			_member_txt.text=vo.item.member+"/"+vo.item.total;
			_money_txt.text=vo.money.toString()/*+"/"+vo.max_money*/;
			_gonggao_txt.text=vo.gonggao;
		}
		override public function dispose():void
		{
			_master_txt=null;
			_lv_txt=null;
			_member_txt=null;
			_money_txt=null;
			_gonggao_txt=null;
			_name_txt=null;
			_mc=null;
			
			super.dispose();
		}
		override public function open():void
		{
			init();
			super.open();
			if(GuildJoinWindow.Instence.isOpen)
			{
				var rec:Rectangle=GuildJoinWindow.Instence.getBounds(GuildJoinWindow.Instence.parent);
				var xx:int=rec.x+rec.width;
				var yy:int=rec.y+rec.height/2-this.height/2;
				var tl:TweenLite=TweenLite.to(this,1,{x:xx,alpha:1,y:yy,onComplete:onCom});
				function onCom():void
				{//使用缓动会造成第一次点击的时候文字动一下
					this.x=xx;
					this.y=yy;
					tl.kill();
				}
			}
		}
		
	}
}