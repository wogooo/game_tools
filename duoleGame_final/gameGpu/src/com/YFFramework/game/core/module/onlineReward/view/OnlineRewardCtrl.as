package com.YFFramework.game.core.module.onlineReward.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.tips.OnlineRewardTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.ui.IconEffectView;
	import com.YFFramework.game.core.global.view.ui.UIEffectManager;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.onlineReward.event.OnlineRewardEvent;
	import com.YFFramework.game.core.module.onlineReward.manager.OnlineRewardBasicManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/***
	 *在线奖励UI的控制 类
	 *@author ludingchang 时间：2013-9-11 上午10:34:27
	 */
	public class OnlineRewardCtrl
	{
		private var _ui:MovieClip;
		private var _btn:SimpleButton;
		private var _num:MovieClip;
		private var _txt:TextField;
		private var _parent:DisplayObjectContainer;
		private var _eff:IconEffectView;
		public function OnlineRewardCtrl(ui:MovieClip)
		{
			_ui=ui;
			_btn=ui.btn;
			_num=ui.num;
			_txt=_num.txt;
			_num.mouseChildren=false;
			_num.mouseEnabled=false;
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			Xtip.registerLinkTip(_btn,OnlineRewardTip,TipUtil.onlineRewardTipInitFunc);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO 更具状态处理
			var time:int=OnlineRewardBasicManager.Instance.remainTime;
			if(time<=0)
			{
				var rewards:Vector.<ActiveRewardBasicVo>=OnlineRewardBasicManager.Instance.getCurrentRewards();
				if(GiftManager.checkBagSpace(rewards))
				{
					//发送领取奖励的消息
					YFEventCenter.Instance.dispatchEventWith(OnlineRewardEvent.GetOnlineReward);
				}
				else
				{
					NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
					NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
				}
			}
			else
			{
				//文字提示：请等待XX分YY秒后领取奖励！
				var msg:String=TimeManager.getTimeFormat3(time);
				NoticeManager.setNotice(NoticeType.Notice_id_2000,-1,msg);
			}
		}
		
		public function update():void
		{
			var time:int=OnlineRewardBasicManager.Instance.remainTime;
			_num.visible=true;
			_txt.text=TimeManager.getTimeStrFromSec(time,false);
		}
		
		public function hide():void
		{
			_parent=_ui.parent;
			_parent.removeChild(_ui);
		}
		
		public function showEff():void
		{
			_num.visible=false;
			if(!_eff)
				_eff=UIEffectManager.Instance.addIconLightTo(_ui,28,35);
		}
		public function show():void
		{
			if(_parent&&!_ui.parent)
				_parent.addChild(_ui);
			if(_eff)
			{
				_eff.dispose();
				_eff=null;
			}
		}
		public function getPostion():Point
		{
			return UIPositionUtil.getPosition(_ui,LayerManager.UIViewRoot);
		}
	}
}