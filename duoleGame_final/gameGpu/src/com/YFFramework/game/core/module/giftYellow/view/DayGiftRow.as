package com.YFFramework.game.core.module.giftYellow.view
{
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.giftYellow.model.Vip_rewardBasicVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;

	/***
	 *黄钻每日礼包一行
	 *@author ludingchang 时间：2013-12-9 上午11:18:37
	 */
	public class DayGiftRow
	{
		/**icon个数*/
		private static const Icon_Num:int=7;
		private var _icons:Vector.<IconImage>;
		public function DayGiftRow(ui:Sprite)
		{
			_icons=new Vector.<IconImage>(Icon_Num);
			var sc:Number=20/36;
			for(var i:int=0;i<Icon_Num;i++)
			{
				_icons[i]=Xdis.getChild(ui,"icon"+(i+1)+"_iconImage");
				_icons[i].scaleX=sc;
				_icons[i].scaleY=sc;
			}
		}
		public function update(data:Vip_rewardBasicVo):void
		{
			 var arr:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(data.reward_id);
			 var len:int=arr.length;
			 for(var i:int=0;i<Icon_Num;i++)
			 {
				if(i<len)
				{
					_icons[i].visible=true;
					ActiveRewardIconTips.registerTip(arr[i],_icons[i]);
				}
				else
					_icons[i].visible=false;
			 }
		}
		public function dispose():void
		{
			for(var i:int=0;i<Icon_Num;i++)
			{
				Xtip.clearLinkTip(_icons[i]);
				Xtip.clearTip(_icons[i]);
				_icons[i]=null;
			}
		}
		/**取出图标，用于领取时的特效*/
		public function getIcons():Array
		{
			var res:Array=new Array;
			for(var i:int=0;i<Icon_Num;i++)
			{
				if(_icons[i].visible)
					res.push(_icons[i]);
			}
			return res;
		}
	}
}