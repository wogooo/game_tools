package com.YFFramework.game.core.module.forge.view.simpleView
{
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 装备强化和强化转移的装备渲染器
	 * @author flashk
	 * 
	 */
	public class EquipItemRender extends ListRenderBase
	{
		/** 装备、道具名称 */		
		private var _nameTxt:TextField;
		/** 显示，如强化石数量、宝石数量 */		
		private var _numTxt:TextField;
		/** 装备、道具图标 */		
		private var _iconImage:IconImage;
		/** 装备强化的强化等级'+12' */		
		private var _levelTxt:TextField;
		
		private var _propsBsVo:PropsBasicVo;
		private var _item:Object;
		
		public function EquipItemRender(){
			_renderHeight = 53;
		}
		
		override protected function resetLinkage():void
		{
			_linkage = "ui.EquipStrengthenItemRenderItem";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
			
			_nameTxt = Xdis.getChild(_ui,"name_txt");
			_numTxt = Xdis.getChild(_ui,"num_txt");
			_iconImage = Xdis.getChild(_ui,"equip_iconImage");
			_levelTxt = Xdis.getChild(_ui,'level_txt');
			
		}
		
		override protected function updateView(item:Object):void
		{
			var equipDyVo:EquipDyVo;
			var equipBsVo:EquipBasicVo;
			
			_item=item;			
			_nameTxt.text='';
			_levelTxt.text='';
			
			switch(item.showType)
			{
				case ForgeSource.SHOW_ENHANCE_LEVEL://装备强化，_levelTxt只在这里用到
					equipDyVo = item.vo;			
					equipBsVo = item.basicVO;
					
					_nameTxt.htmlText = HTMLUtil.createHtmlText(equipBsVo.name,12,TypeProps.getQualityColor(equipBsVo.quality));
					_levelTxt.htmlText = HTMLUtil.createHtmlText('+'+equipDyVo.enhance_level,12,TypeProps.getQualityColor(equipBsVo.quality));
					if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= equipBsVo.level)
						_numTxt.htmlText =  HTMLUtil.createHtmlText(NoticeUtils.getStr(NoticeType.Notice_id_100069)+equipBsVo.level.toString(),12,TypeProps.getQualityColor(equipBsVo.quality));
					else
						_numTxt.htmlText =  HTMLUtil.setFont(NoticeUtils.getStr(NoticeType.Notice_id_100069)+equipBsVo.level.toString());
					_iconImage.url = EquipBasicManager.Instance.getURL(equipBsVo.template_id);
					
					break;
				case ForgeSource.EQUIP_SHOW_LEVEL_UP://装备升级
					equipDyVo = item.vo;
					equipBsVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
					_nameTxt.htmlText =  HTMLUtil.createHtmlText(equipBsVo.name,12,TypeProps.getQualityColor(equipBsVo.quality));
					_numTxt.htmlText = HTMLUtil.createHtmlText("Lv："+equipBsVo.level,12,TypeProps.getQualityColor(equipBsVo.quality));
					_iconImage.url = EquipBasicManager.Instance.getURL(equipBsVo.template_id);
					break;
				case ForgeSource.ITEM_NUM://宝石镶嵌，宝石
					_propsBsVo =  item.vo;
					_nameTxt.htmlText = HTMLUtil.createHtmlText(_propsBsVo.name,12,TypeProps.getQualityColor(_propsBsVo.quality));
					_iconImage.url = PropsBasicManager.Instance.getURL(_propsBsVo.template_id);
					_numTxt.htmlText = HTMLUtil.createHtmlText(NoticeUtils.getStr(NoticeType.Notice_id_100035)+
						String(PropsDyManager.instance.getPropsQuantity(_propsBsVo.template_id)),12,
						TypeProps.getQualityColor(_propsBsVo.quality));
					
					break;
				case ForgeSource.SHOW_GEMS://宝石镶嵌，要镶嵌的装备
					equipDyVo = item.vo;
					equipBsVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
					
					_nameTxt.htmlText = HTMLUtil.createHtmlText(equipBsVo.name,12,TypeProps.getQualityColor(equipBsVo.quality));
					_iconImage.url = EquipBasicManager.Instance.getURL(equipBsVo.template_id);
//					_numTxt.htmlText = HTMLUtil.createHtmlText(item.now + "/"+equipBsVo.hole_number,12,TypeProps.getQualityColor(equipBsVo.quality));
					if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= equipBsVo.level)
						_numTxt.htmlText =  HTMLUtil.createHtmlText(NoticeUtils.getStr(NoticeType.Notice_id_100069)+equipBsVo.level.toString(),12,TypeProps.getQualityColor(equipBsVo.quality));
					else
						_numTxt.htmlText =  HTMLUtil.setFont(NoticeUtils.getStr(NoticeType.Notice_id_100069)+equipBsVo.level.toString());
					break;
			}
			
			if(item.type == ForgeSource.CHARACTER)
				Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,equipDyVo.equip_id,equipDyVo.template_id,true);
			else if(item.type == ForgeSource.BAG)
				Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,equipDyVo.equip_id,equipDyVo.template_id);
			else if(item.type == ForgeSource.PROPS)
				Xtip.registerLinkTip(_iconImage,PropsTip,TipUtil.propsTipInitFunc,0,_propsBsVo.template_id);
			else
			{
				if(EquipDyManager.instance.getEquipPosFromBag(equipDyVo.equip_id) > 0){
					Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,equipDyVo.equip_id,equipDyVo.template_id,false);
				}else{
					Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,equipDyVo.equip_id,equipDyVo.template_id,true);
				}
			}
			
		}
		
		
		
//		override public function get height():Number
//		{
//			return 53;
//		}
//		
//		override public function get width():Number
//		{
//			return 400;
//		}
		
		override public function dispose():void{
			_nameTxt = null;
			_numTxt = null;
			_levelTxt=null;
			_propsBsVo=null;
			Xtip.clearLinkTip(_iconImage);
			_iconImage.clear();
			_iconImage=null;
			super.dispose();
		}
		
	}
}