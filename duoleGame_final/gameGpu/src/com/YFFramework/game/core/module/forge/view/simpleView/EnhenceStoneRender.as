package com.YFFramework.game.core.module.forge.view.simpleView
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-30 上午10:30:35
	 */
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class EnhenceStoneRender extends ListRenderBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		/** 装备、道具名称 */		
		private var _nameTxt:TextField;
		/** 显示，如强化石数量、宝石数量 */		
		private var _numTxt:TextField;
		/** 装备、道具图标 */		
		private var _iconImage:IconImage;
		/** 装备强化的强化等级'+12' */		
//		private var _levelTxt:TextField;
		/** 装备强化快速购买 */		
		private var _buyTxt:TextField;
		
		private var _propsBsVo:PropsBasicVo;
		private var _item:Object;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EnhenceStoneRender()
		{
			super();
		}
		
		override protected function resetLinkage():void
		{
			_linkage = "ui.EquipEnhanceStone";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
			
			_nameTxt = Xdis.getChild(_ui,"name_txt");
			_numTxt = Xdis.getChild(_ui,"num_txt");
			_iconImage = Xdis.getChild(_ui,"equip_iconImage");
			_buyTxt = Xdis.getChild(_ui,'buy_txt');
			
		}
		
		override protected function updateView(item:Object):void
		{
			var equipDyVo:EquipDyVo;
			var equipBsVo:EquipBasicVo;
			_item=item;			
			_nameTxt.text='';
			_numTxt.text='';
			_buyTxt.text='';
		
			_propsBsVo = item.vo;
			var count:int = item.count;
			
			_iconImage.url = PropsBasicManager.Instance.getURL(_propsBsVo.template_id);				
			_nameTxt.htmlText = HTMLUtil.createHtmlText(_propsBsVo.name,12,TypeProps.getQualityColor(_propsBsVo.quality));
			if(count <= 999 && count>0)
				_numTxt.htmlText = HTMLUtil.createHtmlText(count.toString(),12,TypeProps.getQualityColor(_propsBsVo.quality));
			else if(count == 0)
			{
				_numTxt.htmlText = HTMLUtil.createHtmlText(count.toString(),12,'ff0000');
				_iconImage.filters=FilterConfig.dead_filter;
			}
			else
				_numTxt.htmlText = HTMLUtil.createHtmlText('+999',12,TypeProps.getQualityColor(_propsBsVo.quality));
			
			_buyTxt.selectable=false;
			_buyTxt.htmlText=HTMLUtil.addLink(NoticeUtils.getStr(NoticeType.Notice_id_100039),NoticeUtils.getStr(NoticeType.Notice_id_100039));
			_buyTxt.addEventListener(MouseEvent.CLICK,onBuyClick);
			
//			bg.visible=false;
		}
		
		private function onBuyClick(e:MouseEvent):void
		{
			_item.isBuyClick=true;
			ModuleManager.moduleShop.openBuySmallWindowDirect(TypeProps.ITEM_TYPE_PROPS,_propsBsVo.template_id);
		}
		
	}
} 