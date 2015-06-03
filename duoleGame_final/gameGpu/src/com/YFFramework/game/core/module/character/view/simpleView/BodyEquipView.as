package com.YFFramework.game.core.module.character.view.simpleView
{
	/**@author yefeng
	 * 2013 2013-3-20 下午3:23:37 
	 */
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BodyEquipView extends AbsView implements IMoveGrid
	{
		public var _equipDyVo:EquipDyVo;
		
		private var _bg:Shape;
		private var _pos:int;
		
		private var _iconImage:IconImage;
		private var _equipName:TextField;//装备的名字，当穿上这个装备后，名字要隐藏，脱掉显示名字
		private var _otherHero:Boolean;
		
		/**
		 * 如果这个装备双击了，就不能响应在CharacterWindow里的 onMouseUp里的穿上消息。已经脱掉了为true。
		 */		
		public var hasDoubleClick:Boolean=true;
		
		public function BodyEquipView(pos:int,txt:TextField)
		{
			super(false);
			
			_pos=pos;
			
			_bg=new Shape();
			_bg.graphics.beginFill(0xff0000,0);
			_bg.graphics.drawRect(0,0,42,42);
			_bg.graphics.endFill();
			addChild(_bg);
			
			_iconImage= new IconImage();
			_iconImage.x=2;
			_iconImage.y=2;
			addChild(_iconImage);
			
			_equipName=txt;
			
			mouseChildren=false;
			
		}
		
		/** 
		 * @param equipDyVo
		 * @param otherHero true->自己；false->他人   这个字段用于区别是角色面板（自己），还是排行榜里的面板
		 */		
		public function setContent(equipDyVo:EquipDyVo,otherHero:Boolean=false):void
		{
			_equipDyVo=equipDyVo;
			_equipDyVo.position=_pos;
			_iconImage.url = EquipBasicManager.Instance.getURL(_equipDyVo.template_id);
			_equipName.visible=false;
			if(otherHero == false)//自己，角色面板
			{
				Xtip.registerLinkTip(this,EquipTip,TipUtil.equipTipInitFunc,_equipDyVo.equip_id,_equipDyVo.template_id,true);
			}
			else
			{
				Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,0,_equipDyVo.template_id,true,_equipDyVo);
				removeEvents();
			}
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
		/**
		 * 装备的位置（或类型） 
		 * @return 
		 * 
		 */		
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
			
			Xtip.clearLinkTip(_iconImage);
			
			hasDoubleClick=false;//已经脱掉
			_equipName.visible=true;
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
			if(BagStoreManager.instantce.remainBagNum() > 0)
			{
//				var msg:CRemoveFromBodyReq=new CRemoveFromBodyReq();
//				msg.item=new Unit();
//				msg.pos=_pos;
//				var item:Unit=new Unit();
//				item.id=_equipDyVo.equip_id;
//				item.type=TypeProps.STORAGE_TYPE_BODY;
//				msg.item=item;
				ModuleManager.moduleCharacter.removeEquipReq(_pos,_equipDyVo.equip_id);
//				YFEventCenter.Instance.dispatchEventWith(CharacterEvent.C_PutOffEquip,msg);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);
			}
		}
	}
}