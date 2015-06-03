package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-30 上午10:37:46
	 */
	public class FeatherItemList extends PageItemListBase{
		
		private var _iconImg:IconImage;
		private var _numTextField:TextField;
		
		public function FeatherItemList(){
		}
		/**初始化道具
		 * @param data
		 * @param view
		 * @param index
		 */		
		override protected function initItem(data:Object,view:Sprite,index:int):void{
			
			var vo:PropsDyVo = data as PropsDyVo;
			
			_iconImg=Xdis.getChild(view,"icon_iconImage");
			_iconImg.url = PropsBasicManager.Instance.getURL(vo.templateId);
			Xtip.registerLinkTip(_iconImg,PropsTip,TipUtil.propsTipInitFunc,0,vo.templateId);
			view.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			_numTextField=Xdis.getChild(view,"numTxt");
			_numTextField.text = "x"+PropsDyManager.instance.getPropsQuantity(vo.templateId);
		}
		
		override protected function disposeItem(view:Sprite):void
		{
			_iconImg=Xdis.getChild(view,"icon_iconImage");
			Xtip.clearLinkTip(_iconImg);
			_iconImg.clear();
			
			view.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		/**鼠标按下事件
		 * @param e
		 */		
		private function onMouseDown(e:MouseEvent):void{
			var sp:Sprite = e.currentTarget as Sprite;
			var vo:PropsDyVo = _datas[getViewIndex(sp)];
			if(vo){
				var dragData:DragData = new DragData();
				dragData.type = DragData.FROM_WING;
				dragData.data = new Object();
				dragData.data.id = vo.propsId;
				DragManager.Instance.startDrag(sp,dragData);
			}
		}
	}
} 