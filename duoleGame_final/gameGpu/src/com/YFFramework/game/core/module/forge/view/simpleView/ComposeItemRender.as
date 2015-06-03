package com.YFFramework.game.core.module.forge.view.simpleView
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-7-25 上午9:25:51
	 */
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ComposeItemRender extends ListRenderBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _iconImage:IconImage;
		private var _numTxt:TextField;
		private var _lock:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ComposeItemRender()
		{
			_renderHeight = 80;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override protected function resetLinkage():void
		{
			_linkage = "ui.composeRenderItem";
		}
		
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);

			_iconImage = Xdis.getChild(_ui,"icon_iconImage");
			_numTxt = Xdis.getChild(_ui,"num_txt");
			_numTxt.selectable=false;
			_numTxt.mouseEnabled=false;
			_lock = Xdis.getChild(_ui,"lockSp");
			_lock.mouseEnabled=false;
		}
		
		override protected function updateView(item:Object):void
		{
			var vo:PropsBasicVo=item.vo;
			
			_iconImage.url=PropsBasicManager.Instance.getURL(vo.template_id);
			Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,0,vo.template_id,null,false,item.bound);
			
			var num:int=item.num;
			if(num <= 999)
				_numTxt.text=num.toString();
			else
				_numTxt.text='999+';
			addChild(_numTxt);
			
			if(item.bound == TypeProps.BIND_TYPE_YES)
				_lock.visible=true;
			else
				_lock.visible=false;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 