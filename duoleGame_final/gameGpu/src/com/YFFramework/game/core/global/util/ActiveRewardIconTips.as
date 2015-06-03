package com.YFFramework.game.core.global.util
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	
	import flash.text.TextField;

	/***
	 *统一奖励的Tips注册
	 *@author ludingchang 时间：2013-12-12 下午2:04:23
	 */
	public class ActiveRewardIconTips
	{
		/**
		 *注册奖励图标Tips,更新名字和数量 
		 * @param data 奖励数据
		 * @param icon iconImage
		 * @param name_txt 名字TXT，可以为空
		 * @param num_txt 数量TXT，可以为空
		 * 
		 */		
		public static function registerTip(data:ActiveRewardBasicVo,icon:IconImage,name_txt:TextField=null,num_txt:TextField=null):void
		{
			clearAllTips(icon);
			switch(data.reward_type)
			{
				case RewardTypes.PROPS:
					var propsBasicVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(data.reward_id);
					if(!propsBasicVo)
						return;
					icon.url = URLTool.getGoodsIcon(propsBasicVo.icon_id);
					Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,data.reward_id);
					if(name_txt)
						name_txt.text=propsBasicVo.name;
					break;
				case RewardTypes.EQUIP:
					var equipBasicVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(data.reward_id);
					if(!equipBasicVo)
						return;
					icon.url = URLTool.getGoodsIcon(equipBasicVo.icon_id);
					Xtip.registerLinkTip(icon,EquipTipMix,TipUtil.equipTipInitFunc,0,data.reward_id);
					if(name_txt)
						name_txt.text=equipBasicVo.name;
					break;
				default:
					icon.url = URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(data.reward_type));
					Xtip.registerTip(icon,RewardTypes.getTypeStr(data.reward_type));
					if(name_txt)
						name_txt.text=RewardTypes.getTypeStr(data.reward_type);
					break;
			}
			if(num_txt)
				num_txt.text="X"+data.reward_num;
		}
		public static function clearAllTips(icon:IconImage):void
		{
			Xtip.clearLinkTip(icon);
			Xtip.clearTip(icon);
		}
	}
}