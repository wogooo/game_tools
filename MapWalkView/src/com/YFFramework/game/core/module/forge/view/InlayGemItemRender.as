package com.YFFramework.game.core.module.forge.view
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.text.TextField;
	
	/**
	 * 合成材料过滤渲染器 
	 * @author flashk
	 * 
	 */
	public class InlayGemItemRender extends ListRenderBase
	{
		private var _nameTxt:TextField;
		private var _moneyTxt:TextField;
		private var _iconImage:IconImage;
		
		public function InlayGemItemRender()
		{
			
		}
		
		override protected function resetLinkage():void
		{
			_linkage = "ui.EquipStrengthenItemRenderItem";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
			_nameTxt = Xdis.getChild(_ui,"name_txt");
			_moneyTxt = Xdis.getChild(_ui,"money_txt");
			_iconImage = Xdis.getChild(_ui,"equip_iconImage");
		}
		
		override protected function updateView(item:Object):void
		{
			var dyvo:PropsDyVo = item.vo;
			var vo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(dyvo.templateId);
			_nameTxt.htmlText = vo.name;
			_iconImage.url = PropsBasicManager.Instance.getURL(vo.template_id);
			_moneyTxt.text = String(PropsDyManager.instance.getPropsQuantity(dyvo.templateId));
		}
		
		override public function get height():Number
		{
			return 45;
		}
		
		override public function get width():Number
		{
			return 545;
		}
		
	}
}