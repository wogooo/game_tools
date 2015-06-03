package com.YFFramework.game.core.module.mount.view.render
{
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.text.TextField;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-4-25 下午5:57:41
	 * 坐骑道具渲染器
	 */
	public class ItemRender extends ListRenderBase{
		
		private var _amountTxt:TextField;
		private var _nameTxt:TextField;
		private var _iconImage:IconImage;
		
		public function ItemRender(){
			_renderHeight = 48;
			_bg.visible=false;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.MountItem";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_amountTxt = Xdis.getChild(_ui,"level");
			_nameTxt = Xdis.getChild(_ui,"pname");
			_iconImage = Xdis.getChild(_ui,"img_iconImage");
		}
		
		override protected function updateView(item:Object):void{
			_amountTxt.text = "数量："+item.amount;
			_nameTxt.text = item.name;
			_iconImage.url = item.url;
			if(item.amount==0)	_ui.filters=FilterConfig.dead_filter;
			Xtip.registerLinkTip(_iconImage,PropsTip,TipUtil.propsTipInitFunc,0,item.template_id);
		}
		
		/**清除数据
		 */		
		override public function dispose():void{
			super.dispose();
			Xtip.clearLinkTip(_iconImage,TipUtil.propsTipInitFunc);
			_amountTxt = null;
			_nameTxt = null;
			_iconImage.clear();
			_iconImage = null;
		}
		
		/**空方法，不需要重置宽高 
		 * @param newWidth
		 * @param newHeight
		 */		
		override public function setSize(newWidth:Number, newHeight:Number):void{
		}
	}
} 