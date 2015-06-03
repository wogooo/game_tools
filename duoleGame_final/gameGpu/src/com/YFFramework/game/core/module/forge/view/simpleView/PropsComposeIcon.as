package com.YFFramework.game.core.module.forge.view.simpleView
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.forge.events.ForgeEvents;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-18 上午9:37:22
	 */
	public class PropsComposeIcon
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _icon:IconImage;
		private var _index:int;
		private var _lock:Sprite;
		
		private var _bsVo:PropsBasicVo;
//		private var _dyVo:PropsDyVo;
		private var _bound:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PropsComposeIcon(index:int,icon:IconImage,lock:Sprite)
		{
			_index=index;
			_icon=icon;
			_lock=lock;
			_lock.mouseChildren=false;
			_lock.mouseEnabled=false;
			_icon.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(_bsVo)
			{
				clear();
				YFEventCenter.Instance.dispatchEventWith(ForgeEvents.ClearPropsIcon,_index);
			}		
		}

		public function get bsVo():PropsBasicVo
		{
			return _bsVo;
		}

		public function set bsVo(value:PropsBasicVo):void
		{
			_bsVo = value;
			_icon.url=PropsBasicManager.Instance.getURL(_bsVo.template_id);
			Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_bsVo.template_id);
		}

		public function clear():void
		{
			_icon.clear();
			_bsVo=null;
//			_dyVo=null;
			_lock.visible=false;
			_bound=0;
			Xtip.clearLinkTip(_icon);
		}

		public function get bound():int
		{
			return _bound;
		}

		public function set bound(value:int):void
		{
			_bound = value;
			if(_bound == TypeProps.BIND_TYPE_YES)
				_lock.visible=true;
			else
				_lock.visible=false;
		}

		public function get index():int
		{
			return _index;
		}


	}
} 