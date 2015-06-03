package com.YFFramework.game.core.module.systemReward.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.systemReward.data.RewardVo;
	import com.YFFramework.game.core.module.systemReward.event.SystemRewardEvent;
	import com.YFFramework.game.core.module.systemReward.manager.SystemRewardManager;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/***
	 *系统奖励左边列表的单项
	 *@author ludingchang 时间：2013-9-4 上午11:44:52
	 */
	public class SystemRewardListRender extends ListRenderBase
	{

//		private var _icon2:IconImage;
		private var _name_txt:TextField;
		private var _days_txt:TextField;
		private var _item_vo:RewardVo;
		private var _type_txt:TextField;
		private var _bg_line:Sprite;
		private var _eff:Sprite;
		public function SystemRewardListRender()
		{
			_renderHeight=55;
		}
		
		override protected function resetLinkage():void
		{
			_linkage="uiSkin.system_reward_item";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
//			_icon2=Xdis.getChild(_ui,"icon_iconImage");// 如果图标是不变的，这个ICON不需要，直接在flash里添加背景就可以了
			_name_txt=Xdis.getTextChild(_ui,"name_txt");
			_days_txt=Xdis.getTextChild(_ui,"days_txt");
			_type_txt=Xdis.getTextChild(_ui,"type_txt");
			_bg_line=Xdis.getSpriteChild(_ui,"bgLine");
			_type_txt.text="";
			_eff=Xdis.getSpriteChild(_ui,"eff");
		}
		
		override protected function updateView(item:Object):void
		{
			_item_vo=item as RewardVo;
			var date:Date=new Date;
			var time:Number=_item_vo.expiration_time-date.time/1000;
			var day:int=time/24/3600;
			_name_txt.text=_item_vo.name;
			_days_txt.text=day+"天";
//			_type_txt.text=TypeRewardSource.getRewardTypeName(_item_vo.type);
			_bg_line.visible=true;
		}
		/**隐藏背景线*/
		public function hideBGLine():void
		{
			_bg_line.visible=false;
		}
		
		override protected function showSelectOn():void
		{
			//将数据替换，发送UI跟新消息
			_eff.visible=true;
			SystemRewardManager.Instence.current=_item_vo;
			YFEventCenter.Instance.dispatchEventWith(SystemRewardEvent.UpdateInfo);
		}
		
		override protected function showDefault():void
		{
			_eff.visible=false;
		}
		
		override protected function showDown():void
		{
			_eff.visible=true;
		}
		
		override protected function showOver():void
		{
			_eff.visible=true;
		}
	}
}