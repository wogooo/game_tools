package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
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
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *黄钻每日礼包
	 *@author ludingchang 时间：2013-12-9 上午10:11:17
	 */
	public class DayGiftView
	{
		private static const BGURL:String="giftYellow/day.png";
		/**年费黄钻每日礼包ID*/
		private static const YEAR_DAY_GIFT_ID:int=20;
		/**黄钻等级数*/
		private static const VIP_LEVELS:int=8;
		private var _ui:Sprite;
		/**行，DayGiftRow*/
		private var _rows:Array;
		/**普通黄钻领取*/
		private var _vip_get_btn:SimpleButton;
		/**年费黄钻额外可领取的按钮*/
		private var _year_vip_get_btn:SimpleButton;
		/**开通黄钻*/
		private var _op_yellow_btn:SimpleButton;
		/**续费黄钻*/
		private var _renewal_yellow_btn:SimpleButton;
		/**开通年费黄钻*/
		private var _op_year_yellow_btn:SimpleButton;
		/**续费年费黄钻*/
		private var _renewal_year_yellow_btn:SimpleButton;
		/**年黄钻额外可领取的*/
		private var _year_vip_gift_icon:IconImage;
		private var _bg:Sprite;
		private var _loadBG:Boolean;
		private var _day_has_get:Sprite;
		private var _year_has_get:Sprite;
		public function DayGiftView(ui:Sprite)
		{
			_ui=ui;
			var i:int;
			var row:Sprite;
			_rows=new Array
			for(i=1;i<=VIP_LEVELS;i++)
			{
				row=Xdis.getChild(ui,"row"+i);
				_rows.push(new DayGiftRow(row));
			}
			_vip_get_btn=Xdis.getSimpleButtonChild(ui,"vip_get_btn");
			_year_vip_get_btn=Xdis.getSimpleButtonChild(ui,"year_vip_get_btn");
			_op_yellow_btn=Xdis.getSimpleButtonChild(ui,"open_yellow_btn");
			_renewal_yellow_btn=Xdis.getSimpleButtonChild(ui,"renewal_yellow_btn");
			_op_year_yellow_btn=Xdis.getSimpleButtonChild(ui,"open_year_yellow_btn");
			_renewal_year_yellow_btn=Xdis.getSimpleButtonChild(ui,"renewal_year_yellow_btn");
			_year_vip_gift_icon=Xdis.getChild(ui,"year_vip_gift_icon_iconImage");
			_day_has_get=Xdis.getSpriteChild(ui,"dayHasGetImg");
			_year_has_get=Xdis.getSpriteChild(ui,"yearHasGetImg");
			_day_has_get.mouseChildren=false;
			_day_has_get.mouseEnabled=false;
			_year_has_get.mouseEnabled=false;
			_year_has_get.mouseChildren=false;
			
			_vip_get_btn.addEventListener(MouseEvent.CLICK,onClick);
			_year_vip_get_btn.addEventListener(MouseEvent.CLICK,onClick);
			_op_yellow_btn.addEventListener(MouseEvent.CLICK,onClick);
			_renewal_yellow_btn.addEventListener(MouseEvent.CLICK,onClick);
			_op_year_yellow_btn.addEventListener(MouseEvent.CLICK,onClick);
			_renewal_year_yellow_btn.addEventListener(MouseEvent.CLICK,onClick);
			
			_bg=new Sprite;
			ui.addChildAt(_bg,0);
			_bg.x=86;
			_bg.y=120;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case _vip_get_btn:
					var vipLV:int=YellowAPIManager.Instence.yellow_vip_lv;
					var vo:Vip_rewardBasicVo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(vipLV);
					var vos:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(vo.reward_id);
					if(GiftManager.checkBagSpace(vos))
						YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.AskDayGift);
					else
					{
						NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
						NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
					}
					break;
				case _year_vip_get_btn:
					var year_vo:Vip_rewardBasicVo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(YEAR_DAY_GIFT_ID);
					var year_vos:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(year_vo.reward_id);
					if(GiftManager.checkBagSpace(year_vos))
						YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.AskYearDayGift);
					else
					{
						NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
						NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
					}
					break;
				case _op_yellow_btn:
				case _renewal_yellow_btn:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.CallOpenAPI);
					break;
				case _op_year_yellow_btn:
				case _renewal_year_yellow_btn:
					YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.CallOpenYearAPI);
					break;
			}
		}
		
		/**普通黄钻领取特效**/
		public function doRowMoveEff():void
		{
			var vipLv:int=YellowAPIManager.Instence.yellow_vip_lv;
			if(vipLv>0)
			{
				var row:DayGiftRow=_rows[vipLv-1];
				IconMoveUtil.MoveIconToBag(row.getIcons());
			}
		}
		/**年费黄钻领取特效*/
		public function doYearIconMoveEff():void
		{
			IconMoveUtil.MoveIconToBag([_year_vip_gift_icon]);
		}
		
		public function update():void
		{
			var vo:Vip_rewardBasicVo;
			for(var i:int=1;i<=VIP_LEVELS;i++)
			{
				vo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(i);//每日礼包
				(_rows[i-1] as DayGiftRow).update(vo);
			}
			vo=Vip_rewardBasicManager.Instance.getVip_rewardBasicVo(YEAR_DAY_GIFT_ID);
			var temp:ActiveRewardBasicVo=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(vo.reward_id)[0];
			ActiveRewardIconTips.registerTip(temp,_year_vip_gift_icon);
			
			var vipLv:Boolean=(YellowAPIManager.Instence.yellow_vip_lv>0);
			var hasGet:Boolean=YellowAPIManager.Instence.has_get_day_gift;
			_day_has_get.visible=hasGet;
			if(vipLv&&!hasGet)
				UI.setEnable(_vip_get_btn,true,true);
			else
				UI.setEnable(_vip_get_btn,false,true);
			_op_yellow_btn.visible=!vipLv;
			_renewal_yellow_btn.visible=vipLv;
			
			var isYearVip:Boolean=YellowAPIManager.Instence.is_year_yellow;
			_op_year_yellow_btn.visible=!isYearVip;
			_renewal_year_yellow_btn.visible=isYearVip;
			var hasGetYear:Boolean=YellowAPIManager.Instence.has_get_year_day_gift;
			_year_has_get.visible=hasGetYear;
			if(isYearVip&&!hasGetYear)
				UI.setEnable(_year_vip_get_btn,true,true);
			else
				UI.setEnable(_year_vip_get_btn,false);
			
			if(_bg.numChildren==0&&_loadBG==false)
			{
				_loadBG=true;
				var url:String=URLTool.getDyModuleUI(BGURL);
				UILoader.initLoader(url,_bg);
			}
		}
		
		public function dispose():void
		{
			if(_bg&&_bg.parent)
				_bg.parent.removeChild(_bg);
			_bg=null;
			_ui=null;
			_day_has_get=null;
			_year_has_get=null;
			_vip_get_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_year_vip_get_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_op_yellow_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_renewal_yellow_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_op_year_yellow_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_renewal_year_yellow_btn.removeEventListener(MouseEvent.CLICK,onClick);

			_vip_get_btn=null;
			_year_vip_get_btn=null;
			_op_yellow_btn=null;
			_renewal_yellow_btn=null;
			_op_year_yellow_btn=null;
			_renewal_year_yellow_btn=null;
			
			Xtip.clearLinkTip(_year_vip_gift_icon);
			Xtip.clearTip(_year_vip_gift_icon);
			_year_vip_gift_icon=null;
			
			for(var i:int=0;i<VIP_LEVELS;i++)
			{
				(_rows[i] as DayGiftRow).dispose();
				_rows[i]=null;
			}
		}
	}
}