package com.YFFramework.game.core.module.trade.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.model.LockItemDyVo;
	import com.dolo.ui.controls.BitmapButton;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 下午3:15:32
	 * 交易面板格子
	 */
	public class TradeGrid extends Sprite{
		
		private var _bg:BitmapControl;
		private var _text:TextField;
		private var _iconSp:Sprite;
		private var _item:LockItemDyVo;
		private var _actionable:Boolean;
		
		public function TradeGrid(x:int,y:int,actionable:Boolean){
			this.x = x*44;
			this.y = y*43;
			_actionable = actionable;
			_bg = new BitmapControl(Skins.bagGridSkin,0,false);
			_bg.setXYOffset(-4,-4);
			addChild(_bg);
			
			_iconSp = new Sprite;
			_iconSp.x=2;
			_iconSp.y=2;
			addChild(_iconSp);
			
			_text = new TextField;
			_text.x = 25;
			_text.y = 25;
			_text.textColor = TypeProps.Cfff3a5;
			_text.mouseEnabled = false;
			_text.height=16;
			_text.width=16;
			addChild(_text);
			
			_item=null;
			addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		/**加载格子内容
		 * @param templateId	道具的id
		 * @param quantity		道具的数量
		 */		
		public function loadContent(itemDyVo:LockItemDyVo):void{
			if(_iconSp.numChildren>0)	_iconSp.removeChildAt(0);
			IconLoader.initLoader(itemDyVo.url,_iconSp);
			_bg.followTargetMouse(_iconSp);
			_text.text = itemDyVo.quantity.toString();
			_item = itemDyVo;
			if(_item.type==TypeProps.ITEM_TYPE_EQUIP)	Xtip.registerLinkTip(_iconSp,EquipTip,TipUtil.equipTipInitFunc,_item.dyId,_item.templateId);
			else if(_item.type==TypeProps.ITEM_TYPE_PROPS)	Xtip.registerLinkTip(_iconSp,PropsTip,TipUtil.propsTipInitFunc,0,_item.templateId);	
		}
		
		/**清除格子内容 
		 */		
		public function clearContent():void{
			if(_iconSp.numChildren>0)	_iconSp.removeChildAt(0);
			_text.text="";
			_bg.clearFollowTargetMouse(_iconSp);
			if(_item.type==TypeProps.ITEM_TYPE_EQUIP)	Xtip.clearLinkTip(_iconSp,TipUtil.equipTipInitFunc);
			else if(_item.type==TypeProps.ITEM_TYPE_PROPS) Xtip.clearLinkTip(_iconSp,TipUtil.propsTipInitFunc);
			_item=null;
		}
		
		/**移除对象
		 */		
		public function dispose():void{
			removeEventListener(MouseEvent.CLICK,onClick);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			while(this.numChildren>0)	this.removeChildAt(0);
			_text=null;
			_iconSp=null;
			_bg=null;
			_item=null;
		}
		
		/**单击格子
		 * @param e	单击事件
		 */		
		public function onClick(e:MouseEvent):void{
			if(_item && TradeDyManager.isLock==false && _actionable){
				TradeDyManager.Instance.removeFromMyLockItem(_item.pos);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,_item.pos);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			}
		} 
		
		/**拖动事件监听
		 * @param e
		 */		
		public function onMouseDown(e:MouseEvent):void{
			if(_item && TradeDyManager.isLock==false && _actionable){
				var dragData:DragData = new DragData();
				dragData.type = DragData.FROM_TRADE;
				dragData.fromID = _item.pos;
				DragManager.Instance.startDrag(_iconSp,dragData);
			}
		}
	}
} 