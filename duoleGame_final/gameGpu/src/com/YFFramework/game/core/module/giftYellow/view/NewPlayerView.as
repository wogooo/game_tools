package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.util.IconMoveUtil;
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.giftYellow.manager.Vip_rewardBasicManager;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.core.module.giftYellow.model.Vip_rewardBasicVo;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *黄钻新手礼包
	 *@author ludingchang 时间：2013-12-6 下午4:21:43
	 */
	public class NewPlayerView
	{
		private static const BGURL:String="giftYellow/gift.png";
		private static const Icon_Num:int=5;
		/**在vip_reward表中配置的vipid*/
		private static const VIP_RewardID:int=21;
		private var _icons:Array;
		private var _get_gift:SimpleButton;
		private var _open_yellow:SimpleButton;
		private var _renewal_yellow:SimpleButton;
		private var _bg:Sprite;
		private var _loadBG:Boolean;
		private var _has_get_img:Sprite;
		public function NewPlayerView(ui:Sprite)
		{
			_icons=new Array;
			for(var i:int=1;i<=Icon_Num;i++)
			{
				var gift:NewPlayerGift=new NewPlayerGift(Xdis.getChild(ui,"gift"+i));
				_icons.push(gift);
			}
			_get_gift=Xdis.getChildAndAddClickEvent(onClick,ui,"get_gift");
			_open_yellow=Xdis.getChildAndAddClickEvent(onClick,ui,"open_yellow");
			_renewal_yellow=Xdis.getChildAndAddClickEvent(onClick,ui,"renewal_yellow");
			_has_get_img=Xdis.getSpriteChild(ui,"hasGetImg");
			_has_get_img.mouseEnabled=false;
			_has_get_img.mouseChildren=false;
			_bg=new Sprite;
			ui.addChildAt(_bg,0);
			_bg.x=86;
			_bg.y=120;
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _get_gift:
					var vipVo:Vip_rewardBasicVo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(VIP_RewardID);
					var vos:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(vipVo.reward_id);
					if(GiftManager.checkBagSpace(vos))
						YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.AskNewPlayerGift);
					else
					{
						NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
						NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
					}
					break;
				case _open_yellow:
				case _renewal_yellow:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.CallOpenAPI);
					break;
			}
		}
		
		public function doIconMoveEff():void
		{
			var icon_arr:Array=new Array;
			for(var i:int=0;i<Icon_Num;i++)
			{
				var gift:NewPlayerGift=_icons[i];
				if(gift.visible)
					icon_arr.push(gift.getIcon());
			}
			IconMoveUtil.MoveIconToBag(icon_arr);
		}
		
		public function update():void
		{
			if(_bg.numChildren==0&&_loadBG==false)
			{
				_loadBG=true;
				var url:String=URLTool.getDyModuleUI(BGURL);
				UILoader.initLoader(url,_bg);
			}
			var vipVo:Vip_rewardBasicVo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(VIP_RewardID);
			 var vos:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(vipVo.reward_id);
			 var len:int=vos.length;
			 for(var i:int=0;i<Icon_Num;i++)
			 {
				 if(i<len)
					 (_icons[i] as NewPlayerGift).init(vos[i]);
				 _icons[i].visible=(i<len);
			 }
			 var isVip:Boolean=YellowAPIManager.Instence.yellow_vip_lv>0;
			 var hasGet:Boolean=YellowAPIManager.Instence.has_get_new_gift;
			 var canGet:Boolean=isVip&&!hasGet;
			 UI.setEnable(_get_gift,canGet);
			 _has_get_img.visible=hasGet;
			 _open_yellow.visible=!isVip;
			 _renewal_yellow.visible=isVip;
		}
		
		public function dispose():void
		{
			if(_bg&&_bg.parent)
				_bg.parent.removeChild(_bg);
			_bg=null;
			_has_get_img=null;
			
			for(var i:int=0;i<Icon_Num;i++)
			{
				(_icons[i] as NewPlayerGift).dispose();
			}
			_icons.length=0;
			
			_get_gift.removeEventListener(MouseEvent.CLICK,onClick);
			_open_yellow.removeEventListener(MouseEvent.CLICK,onClick);
			_renewal_yellow.removeEventListener(MouseEvent.CLICK,onClick);
		
			_get_gift=null;
			_open_yellow=null;
			_renewal_yellow=null;
		}
	}
}