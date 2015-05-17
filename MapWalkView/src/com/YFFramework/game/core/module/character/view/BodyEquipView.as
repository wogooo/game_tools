package com.YFFramework.game.core.module.character.view
{
	/**@author yefeng
	 * 2013 2013-3-20 下午3:23:37 
	 */
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.skill.window.DragData;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.Unit;
	import com.msg.storage.CRemoveFromBodyReq;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class BodyEquipView extends AbsView implements IMoveGrid
	{
		public var _equipDyVo:EquipDyVo;
		
		private var _bg:MovieClip;
		private var _pos:int;
		
		private var _iconImage:IconImage;
		
		/**
		 * 如果这个装备双击了，就不能响应在CharacterWindow里的 onMouseUp里的穿上消息。已经脱掉了为true。
		 */		
		public var hasDoubleClick:Boolean=true;
		
		public function BodyEquipView(pos:int)
		{
			super(false);
			
			_pos=pos;
			
			_bg=ClassInstance.getInstance("bagUI_bg2") as MovieClip;
			addChild(_bg);
			
			_iconImage= new IconImage();
			_iconImage.x=1;
			_iconImage.y=1;
			addChild(_iconImage);
			
			mouseChildren=false;
			
		}
		
		public function setContent(equipDyVo:EquipDyVo):void
		{
			_equipDyVo=equipDyVo;
			_equipDyVo.position=_pos;
			_iconImage.url = EquipBasicManager.Instance.getURL(_equipDyVo.template_id);
			if(_equipDyVo)
				Xtip.registerLinkTip(this,EquipTip,TipUtil.equipTipInitFunc,_equipDyVo.equip_id,_equipDyVo.template_id,true);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			DBClickManager.Instance.regDBClick(this,onMouseDoubleClick);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			DBClickManager.Instance.delDBClick(this);
		}
		
		//下面方法是从背包移动到人物属性面板需要实现的接口方法
		public function get boxKey():int
		{
			return _pos;
		}
		
		public function get boxType():int
		{
			return TypeProps.STORAGE_TYPE_BODY;
		}
		
		public function get info():EquipDyVo
		{
			return _equipDyVo;
		}
		
		/**
		 * 双击卸载身上的装备(卸载身上所有的装备时，可以调用这个方法)
		 * 
		 */		
		public function onMouseDoubleClick():void
		{			
			if(_equipDyVo)
			{
				hasDoubleClick=true;//双击脱掉了
				removeFromBody();
			}		
		}
		
		public function disposeContent():void
		{
			_iconImage.clear();
			_equipDyVo=null;
			
			Xtip.clearLinkTip(this);
			
			hasDoubleClick=false;//已经脱掉
		}
		
		//////////////////////**************事件函数****************////////////////////////////
		private function mouseDownHandler(e:MouseEvent):void
		{
			if(_equipDyVo != null )
			{
				var dragVO:DragData = new DragData();
				dragVO.data=new Object
				dragVO.fromID = _pos;//源位置
				dragVO.type = DragData.FROM_CHARACTER;
				dragVO.data.type = _equipDyVo.type;
				dragVO.data.id = _equipDyVo.equip_id;
				DragManager.Instance.startDrag(_iconImage,dragVO);
				Xtip.clearTip(this);
			}
		}
		
		private function removeFromBody():void
		{
			var msg:CRemoveFromBodyReq=new CRemoveFromBodyReq();
			msg.item=new Unit();
			msg.pos=_pos;
			var item:Unit=new Unit();
			item.id=_equipDyVo.equip_id;
			item.type=TypeProps.STORAGE_TYPE_BODY;
			msg.item=item;
			YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_PutOffEquip,msg);
		}
	}
}