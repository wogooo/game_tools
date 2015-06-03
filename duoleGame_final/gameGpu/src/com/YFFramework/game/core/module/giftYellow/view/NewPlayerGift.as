package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/***
	 *黄钻新手礼包，单个奖励
	 *@author ludingchang 时间：2013-12-6 下午4:35:20
	 */
	public class NewPlayerGift
	{
		private var _icon:IconImage;
		private var _num_txt:TextField;
		private var _name_txt:TextField;
		public function NewPlayerGift(ui:Sprite)
		{
			_icon=Xdis.getChild(ui,"icon_iconImage");
			_num_txt=Xdis.getTextChild(ui,"num_txt");
			_name_txt=Xdis.getTextChild(ui,"name_txt");
		}
		public function init(data:ActiveRewardBasicVo):void
		{
			if(data)
				ActiveRewardIconTips.registerTip(data,_icon,_name_txt,_num_txt);
			else
				ActiveRewardIconTips.clearAllTips(_icon);
		}
		public function dispose():void
		{
			Xtip.clearLinkTip(_icon);
			Xtip.clearTip(_icon);
			_icon=null;
			_name_txt=null;
			_num_txt=null;
		}
		public function set visible(b:Boolean):void
		{
			_icon.visible=b;
			_name_txt.visible=b;
			_num_txt.visible=b;
		}
		public function get visible():Boolean
		{
			return _icon.visible;
		}
		public function getIcon():IconImage
		{
			return _icon;
		}
	}
}