package com.YFFramework.game.core.global.view.tips
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.onlineReward.manager.OnlineRewardBasicManager;
	import com.dolo.common.GlobalPools;
	import com.dolo.ui.managers.UI;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.geom.Rectangle;

	/***
	 *在线奖励提示
	 *@author ludingchang 时间：2013-9-11 下午1:52:05
	 */
	public class OnlineRewardTip extends AbsView
	{

		private var _txt:TextField;

		private var _bg:MovieClip;
		public function OnlineRewardTip()
		{
			_bg=TipUtil.tipBackgrounPool.getObject();
			addChildAt(_bg,0);
			_txt=GlobalPools.textFieldPool.getObject();
			addChild(_txt);
			_txt.x=10;
			_txt.y=5;
			_txt.selectable=false;
			_txt.mouseEnabled=false;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.textColor=0xffffff;
			super(true);
		}
		
		public override function dispose(e:Event=null):void
		{
			if(_isDispose)
				return;
			_isDispose = true;
			
			UI.removeAllChilds(this);
			GlobalPools.textFieldPool.returnObject(_txt);
			_txt=null;
			TipUtil.tipBackgrounPool.returnObject(_bg);
			_bg=null;
		}
		
		public function setTip():void
		{
			var time:int=OnlineRewardBasicManager.Instance.remainTime;
			_txt.text="";
			if(time<=0)
				_txt.text=NoticeUtils.getStr(NoticeType.Notice_id_100062);
			else
				_txt.text=NoticeUtils.getStr(NoticeType.Notice_id_100063)
					+TimeManager.getTimeFormat3(time)
					+NoticeUtils.getStr(NoticeType.Notice_id_100064);
			_bg.width=_txt.textWidth+20+4;
			_bg.height=_txt.textHeight+10+4;
		}
	}
}