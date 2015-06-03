package com.YFFramework.game.core.module.forge.view.simpleView
{
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-21 上午10:12:46
	 */
	public class WingItemRender extends ListRenderBase{
		private var _nameTxt:TextField;
		private var _statusTxt:TextField;
		private var _iconImage:IconImage;
		private var _color:uint=TypeProps.COLOR_WHITE;
		/** 装备强化的强化等级'+12' */		
		private var _levelTxt:TextField;
		/** 装备强化快速购买 */		
//		private var _buyTxt:TextField;
		
		public function WingItemRender(){
			_renderHeight = 53;
		}
		
		override protected function resetLinkage():void{
			_linkage = "ui.EquipStrengthenItemRenderItem";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_nameTxt = Xdis.getChild(_ui,"name_txt");
			_statusTxt = Xdis.getChild(_ui,"num_txt");
			_iconImage = Xdis.getChild(_ui,"equip_iconImage");
			_levelTxt = Xdis.getChild(_ui,'level_txt');
//			_buyTxt = Xdis.getChild(_ui,'buy_txt');
			
			_nameTxt.mouseEnabled=false;
			_statusTxt.mouseEnabled=false;
		}
		
		override protected function updateView(item:Object):void{
			var vo:* = item.dyVo;
			if(item.lv)	setColor(item.lv);
			_nameTxt.text = item.name;
			_nameTxt.textColor=_color;
			_statusTxt.text = item.holes;
			_statusTxt.textColor=_color;
			_iconImage.url = item.url;
			_levelTxt.text="";
//			_buyTxt.text="";
			
			if(item.type == ForgeSource.CHARACTER){
				Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,vo.equip_id,vo.template_id,true);
			}else if(item.type==ForgeSource.BAG){
				Xtip.registerLinkTip(_iconImage,EquipTipMix,TipUtil.equipTipInitFunc,vo.equip_id,vo.template_id,false);
			}else{
				Xtip.registerLinkTip(_iconImage,PropsTip,TipUtil.propsTipInitFunc,0,vo.templateId);
			}
		}
		
		override public function dispose():void{
			_nameTxt = null;
			_statusTxt = null;
			Xtip.clearLinkTip(_iconImage);
			_iconImage.clear();
			_iconImage=null;
			super.dispose();
		}
		
		private function setColor(quality:int):void{
			switch(quality){
				case 1:
					_color = TypeProps.COLOR_WHITE;
					break;
				case 2:
					_color = TypeProps.COLOR_GREEN;
					break;
				case 3:
					_color = TypeProps.COLOR_BLUE;
					break;
				case 4:
					_color = TypeProps.COLOR_PURPLE;
					break;
				case 5:
					_color = TypeProps.COLOR_ORANGE;
					break;
			}
		}
		
	}
} 