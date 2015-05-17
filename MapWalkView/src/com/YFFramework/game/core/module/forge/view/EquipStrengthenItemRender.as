package com.YFFramework.game.core.module.forge.view
{
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.text.TextField;

	/**
	 * 身上背包装备过滤渲染器 
	 * @author flashk
	 * 
	 */
	public class EquipStrengthenItemRender extends ListRenderBase
	{
		private var _nameTxt:TextField;
		private var _moneyTxt:TextField;
		private var _addTxt:TextField;
		private var _iconImage:IconImage;
		
		public function EquipStrengthenItemRender()
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
			_addTxt = Xdis.getChild(_ui,"add_txt");
			_iconImage = Xdis.getChild(_ui,"equip_iconImage");
		}
		
		override protected function updateView(item:Object):void
		{
			var vo:EquipDyVo = item.vo;
			var basicVO:EquipBasicVo = item.basicVO;
			_nameTxt.htmlText = basicVO.name;
			_addTxt.text = "+"+vo.enhance_level;
			_iconImage.url = EquipBasicManager.Instance.getURL(basicVO.template_id);
			_moneyTxt.text = String(basicVO.sell_price);
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