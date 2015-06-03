package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.ForgeModule;
	import com.YFFramework.game.core.module.forge.data.EquipDecompBasicManager;
	import com.YFFramework.game.core.module.forge.data.EquipDecompBasicVo;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.common.XFind;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.CEquipDecompReq;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-8 上午10:10:03
	 * 
	 */
	public class EquipDisolveCOL
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const EQUIP_MAX:int = 8;
		private const ITEM_MAX:int=4;
		
		private var _ui:Sprite;
		
		private var _bagEquipList:TileList;
		
		private var _equipHole:Array = [];
		private var _equipsIcons:Array = [];
		
		private var _itemsIcons:Array = [];
		/** 可得到材料的数量数组
		 */
		private var _itemsNumAry:Array = [];
		
		private var _disolveBtn:Button;
		
		private var _curEquipsAry:Array;
		
		private var _update:Boolean=false;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EquipDisolveCOL(mc:Sprite)
		{
			_ui = mc;
			
			_bagEquipList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_bagEquipList.itemRender = EquipItemRender;
			_bagEquipList.setMulSelectable(true);
			_bagEquipList.setSelfDeselect(true);
			_bagEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			for(var i:int=0;i<EQUIP_MAX;i++)
			{
				_equipHole.push(Xdis.getChild(_ui,"equip"+(i+1)));
				_equipsIcons.push(Xdis.getChild(_ui,"equip"+(i+1),"icon_iconImage"));
				Sprite(_equipHole[i]).addEventListener(MouseEvent.CLICK,onHoleClick);
			}
			
			for(i=0;i<ITEM_MAX;i++)
			{
				_itemsIcons.push(Xdis.getChild(_ui,"item"+(i+1),"icon_iconImage"));
				_itemsNumAry.push(Xdis.getChild(_ui,"txt"+(i+1)));
			}
			
			_disolveBtn=Xdis.getChild(_ui,"disolve_button");
			_disolveBtn.addEventListener(MouseEvent.CLICK,onDisolveClick);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateBagList);
			
			resetPanel();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				updateBagList();
			}
		}
		
		/** 
		 * 使用这个方法，不仅整个panel清空，并且背包list就不实时更新了
		 */		
		public function resetPanel():void
		{
			clearLeftPanel();
			_update=false;
		}
		
		/** 
		 * 清空當前的所有數據
		 */		
		public function clearLeftPanel():void
		{
			_curEquipsAry=[];
			
			clearIcons();
			
			_bagEquipList.clearSelection();
			
			checkDisolveBtn();
		}
		//======================================================================
		//        private function
		//======================================================================
		
		private function clearIcons():void
		{
			for each(var icon:IconImage in _equipsIcons)
			{
				icon.clear();
				Xtip.clearLinkTip(icon);
			}
			
			for each(var itemIcon:IconImage in _itemsIcons)
			{
				itemIcon.clear();
				Xtip.clearLinkTip(itemIcon);
			}
			
			for each(var tf:TextField in _itemsNumAry)
			{
				tf.text='';
				tf.selectable=false;
			}
		}
		
		private function updateBagList(e:YFEvent=null):void
		{
			if(_update == false) return;
			
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			
			if(arr.length == 0) return;
			
			_bagEquipList.removeAll();
			
			var len:int = arr.length;
			var basicVO:EquipBasicVo;
			var item:Object;
			for each(var vo:EquipDyVo in arr)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS &&
					EquipDecompBasicManager.Instance.getEquipDecompBasicVo(basicVO.template_id) && basicVO.career != TypeRole.CAREER_NEWHAND
					&& basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY)
				{
					item = {};
					item.vo = vo;
					item.showType=ForgeSource.SHOW_ENHANCE_LEVEL;
					item.type=ForgeSource.BAG;
					_bagEquipList.addItem(item);
				}
			}
			
		}
		
		private function checkDisolveBtn():void
		{
			if(_curEquipsAry.length == 0)
				_disolveBtn.enabled=false;
			else
				_disolveBtn.enabled=true;
		}
		
		private function putEquipOn():void
		{	
			clearIcons();
			
			var i:int=0;
			var len:int=_curEquipsAry.length;
			var dyVo:EquipDyVo;
			for(i=0;i<len;i++)
			{
				dyVo=_curEquipsAry[i];
				_equipsIcons[i].url=EquipBasicManager.Instance.getURL(dyVo.template_id);
				
				if(EquipDyManager.instance.getEquipPosFromRole(dyVo.equip_id) > 0)
					Xtip.registerLinkTip(IconImage(_equipsIcons[i]),EquipTipMix,TipUtil.equipTipInitFunc,dyVo.equip_id,dyVo.template_id,true);
				else
					Xtip.registerLinkTip(IconImage(_equipsIcons[i]),EquipTipMix,TipUtil.equipTipInitFunc,dyVo.equip_id,dyVo.template_id);
			}
			
			var materials:EquipDecompBasicVo;
			var num:int=0;
			var itemsDict:Dictionary=new Dictionary();
			for each(dyVo in _curEquipsAry)
			{
				materials=EquipDecompBasicManager.Instance.getEquipDecompBasicVo(dyVo.template_id);
				if(materials.mater_1_id > 0)
				{
					if(itemsDict[materials.mater_1_id])
					{
						num=itemsDict[materials.mater_1_id] as int;
						num += 1;
					}
					else
					{
						num=1;			
					}
					itemsDict[materials.mater_1_id]=num;
				}
				if(materials.mater_2_id > 0)
				{
					if(itemsDict[materials.mater_2_id])
					{
						num=itemsDict[materials.mater_2_id] as int;
						num += 1;
					}
					else
					{
						num=1;
					}
					itemsDict[materials.mater_2_id]=num;
				}
				if(materials.mater_3_id > 0)
				{
					if(itemsDict[materials.mater_3_id])
					{
						num=itemsDict[materials.mater_3_id] as int;
						num += 1;
					}
					else
					{
						num=1;
					}
					itemsDict[materials.mater_3_id]=num;
				}
				if(materials.mater_4_id > 0)
				{
					if(itemsDict[materials.mater_4_id])
					{
						num=itemsDict[materials.mater_4_id] as int;
						num += 1;
					}
					else
					{
						num=1;
					}
					itemsDict[materials.mater_4_id]=num;
				}
			}
			
			i=0;//重新把上面的循环因子设置为0
			for(var id:String in itemsDict)
			{
				IconImage(_itemsIcons[i]).url=PropsBasicManager.Instance.getURL(int(id));
				Xtip.registerLinkTip(IconImage(_itemsIcons[i]),PropsTip,TipUtil.propsTipInitFunc,0,int(id));
				TextField(_itemsNumAry[i]).text=String(itemsDict[int(id)]);
				i++;
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 装备选择后切换 
		 * @param event
		 * 
		 */
		protected function onEquipListChange(event:Event):void
		{	
			var list:TileList = event.currentTarget as TileList;
			var dyVo:EquipDyVo = list.selectedItem.vo;
			
			if(list.selectedSp.select==true)
			{
				_curEquipsAry.push(dyVo);
			}
			else
			{
				var len:int=_curEquipsAry.length;
				for(var i:int=0;i<len;i++)
				{
					if(_curEquipsAry[i].equip_id == dyVo.equip_id)
					{
						_curEquipsAry.splice(i,1);
						break;
					}
				}
			}
			
			if(_curEquipsAry.length == EQUIP_MAX)//如果已经选择了八个，就不能继续选择了
				_bagEquipList.selectEnable=false;
			else
				_bagEquipList.selectEnable=true;
			
			if(_curEquipsAry.length == 0)//如果删除至0个，则重置
			{
				clearLeftPanel();
				return;
			}
			
			putEquipOn();
			
			checkDisolveBtn();
		}
		
		private function onHoleClick(e:MouseEvent):void
		{
			var sp:Sprite = e.currentTarget as Sprite;
			var index:int = XFind.findIndexInArray(sp,_equipHole);
			if(index == -1) return;//没有这个东西，不操作
			
			var vo:EquipDyVo=_curEquipsAry[index];
			_curEquipsAry.splice(index,1);

			var listIndex:int=_bagEquipList.findDataIndex(vo,"vo");
			if(listIndex > -1)
				_bagEquipList.setItemSelectAt(listIndex,false)
			
			putEquipOn();
			checkDisolveBtn();
		}
		
		private function onDisolveClick(e:MouseEvent):void
		{
			var materialsNum:int=0;
			for each(var tf:TextField in _itemsNumAry)//这里用了点奇淫巧计，看显示数量的tf是不是有数字的来判断有几种道具
			{
				if(tf.text != '')
					materialsNum++;
			}
			
			if(BagStoreManager.instantce.remainBagNum() >= materialsNum)
			{
				var posAry:Array=[];
				var pos:int=0;
				for each(var dyVo:EquipDyVo in _curEquipsAry)
				{
					pos=EquipDyManager.instance.getEquipPosFromBag(dyVo.equip_id);
					posAry.push(pos);
				}
				ModuleManager.forgetModule.equipDecompReq(posAry);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_302);
			
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 