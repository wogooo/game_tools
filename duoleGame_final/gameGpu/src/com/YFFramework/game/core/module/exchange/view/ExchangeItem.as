package com.YFFramework.game.core.module.exchange.view
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.exchange.model.Exchange_GetBasicVo;
	import com.YFFramework.game.core.module.exchange.model.Exchange_NeedBasicVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.enumdef.PropsType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/***
	 *兑换单个道具显示类
	 *@author ludingchang 时间：2013-8-19 上午10:50:37
	 */
	public class ExchangeItem extends AbsView
	{
		private static const uiName:String="Exchange_daoju";
		private var _daoju:Sprite;
		private var _name_txt:TextField;
		private var _num_txt:TextField;
		private var _icon:IconImage;
		public function ExchangeItem()
		{
			super(true);
			_daoju=ClassInstance.getInstance(uiName);
			AutoBuild.replaceAll(_daoju);
			_name_txt=Xdis.getChild(_daoju,"name_txt");
			_num_txt=Xdis.getChild(_daoju,"num_txt");
			_num_txt.mouseEnabled=false;
			_num_txt.filters=FilterConfig.text_filter;
			_icon=Xdis.getChild(_daoju,"icon_iconImage");
			addChild(_daoju);
		}
		public function initByGetVo(vo:Exchange_GetBasicVo):void
		{
			if(vo.item_type==TypeProps.ITEM_TYPE_PROPS)
			{
				var proVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
				_name_txt.text=proVo.name;
				_icon.url=PropsBasicManager.Instance.getURL(proVo.template_id);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,vo.item_id);
			}
			else if(vo.item_type==TypeProps.ITEM_TYPE_EQUIP)
			{
				var equipVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
				_name_txt.text=equipVo.name;
				_icon.url=EquipBasicManager.Instance.getURL(equipVo.template_id);
				Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,0,vo.item_id);
			}
			_num_txt.text="x"+vo.item_num.toString();
		}
		public function initByNeedVo(vo:Exchange_NeedBasicVo):void
		{
			var proVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
			_name_txt.text=proVo.name;
			_num_txt.text="x"+vo.item_num.toString();
			_icon.url=PropsBasicManager.Instance.getURL(proVo.template_id);
			Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,vo.item_id);
		}
		override public function dispose(e:Event=null):void
		{
			_daoju=null;
			_name_txt=null;
			_name_txt=null;
			_icon=null;
			super.dispose();
		}
	}
}