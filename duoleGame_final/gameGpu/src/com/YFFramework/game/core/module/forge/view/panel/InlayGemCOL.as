package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.ForgeSource;
	import com.YFFramework.game.core.module.forge.view.simpleView.EquipItemRender;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.common.XFind;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 宝石镶嵌 
	 * @author flashk
	 * 
	 */
	public class InlayGemCOL
	{
		public static var maxStrengthenLevel:int = 12;
		
		private var _ui:Sprite;
		private var _tabs:TabsManager;
//		private var _materialTabs:TabsManager;
		private var _bagEquipList:TileList;
		private var _characterEquipList:TileList;
		private var _gemsList:TileList;
		/** 当前选中的装备dyVo */		
		private var _curEquipDyVo:EquipDyVo;
		private var _curEquipBsVo:EquipBasicVo;
		private var _curEquipIcon:IconImage;
		/**
		 * 为了可扩展最大镶嵌个数 
		 */		
		private var MAX_HOLES:int = 8;
		/**
		 * 所有格子iconImage（例如：现在是8个）
		 */		
		private var _holes:Array = [];
		/** 八个iconImage */		
		private var _holeIcons:Array = [];
		/** 光记录准备镶嵌的宝石 */
		private var _curGemsAry:Array;
		
		private var _inlayButton:Button;
		/** 控制只有现实当前页面才更新三个list */		
		private var _update:Boolean;
		
		public function InlayGemCOL(targetUI:Sprite)
		{
			_ui = targetUI;
			
			_bagEquipList = Xdis.getChild(_ui,"equipView2","equipsBox_tileList");
			_bagEquipList.itemRender = EquipItemRender;
			_bagEquipList.setSelfDeselect(true);
			_bagEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_characterEquipList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_characterEquipList.itemRender = EquipItemRender;
			_characterEquipList.setSelfDeselect(true);
			_characterEquipList.addEventListener(Event.CHANGE,onEquipListChange);
			
			_gemsList = Xdis.getChild(_ui,"equipsBox_tileList");
			_gemsList.itemRender = EquipItemRender;
			_gemsList.addEventListener(Event.CHANGE,onGemsChange);
			
			_curEquipIcon = Xdis.getChild(_ui,"equip_iconImage");
			_curEquipIcon.addEventListener(MouseEvent.CLICK,onEquipClick);
			
			_inlayButton = Xdis.getChild(_ui,"inlay_button");
			_inlayButton.addEventListener(MouseEvent.CLICK,onInlayBtnClick);
			_inlayButton.enabled=false;
			
			for(var i:int=0;i<MAX_HOLES;i++)
			{
				_holes.push(Xdis.getChild(_ui,"gem"+(i+1)));
				Sprite(_holes[i]).addEventListener(MouseEvent.CLICK,onHoleClick);
				_holeIcons.push(Xdis.getChild(_ui,"gem"+(i+1),"icon_iconImage"));
			}
			
			_tabs=new TabsManager();
			_tabs.initTabs(_ui,"tabsEquip_sp",2,"equipView");
			
			_curGemsAry=[];
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateAllList);
			
			resetPanel();
			
		}
		
		public function initPanel(update:Boolean):void
		{
			_update=update;
			if(_update)
			{
				updateBagList();
				updateCharacterList();
				updateGemsList();
				putCurEquipGemsOn();
			}		
		}
		
		public function resetPanel():void
		{
			clearLeftPanel();
			
			_tabs.switchToTab(1);
				
			_gemsList.clearSelection();
			_characterEquipList.clearSelection();
			_bagEquipList.clearSelection();
			
			checkInlayBtn();
			
			_update=false;
		}
		
		/** 
		 * 清除面板左侧：1.当前装备缓存置空；2.左侧面板的装备图标清除；3.当前装备已镶嵌宝石数置空；
		 * 4.用户已选择宝石数组置空；5.八个宝石图标不可用；6.清除八个宝石图标；7.镶嵌按钮不可用
		 * 8.宝石、装备、背包列表取消选择
		 */		
		private function clearLeftPanel():void
		{
			_curEquipDyVo=null;
			_curEquipBsVo=null;
			_curEquipIcon.clear();
			Xtip.clearLinkTip(_curEquipIcon);
			
			showOneEquipCanInlaidHoles(MAX_HOLES);
			clearAllIcons();
			checkInlayBtn();
		}
		
		/**
		 * （背包或身上）装备选择后切换 
		 * @param event
		 * 
		 */
		protected function onEquipListChange(event:Event):void
		{
			clearLeftPanel();
					
			var list:TileList = event.currentTarget as TileList;
			
			if(list.selectedSp.select == false) 
			{
				updateGemsList();
				return;
			}
			
			_curEquipDyVo = list.selectedItem.vo;
			_curEquipBsVo = EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			putCurEquipGemsOn();//放上装备 并显示已镶嵌的宝石
			
			if(list == _bagEquipList)
			{
				_characterEquipList.clearSelection();
			}
			else
			{
				_bagEquipList.clearSelection();
			}
		}
		
		/**
		 * 放上装备 并显示已镶嵌的宝石
		 * @param vo
		 * @param basicVO
		 * 
		 */
		public function putCurEquipGemsOn():void
		{
			if(_curEquipDyVo == null) return;
//			var basicVO:EquipBasicVo= EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			
			_curEquipIcon.url = EquipBasicManager.Instance.getURL(_curEquipBsVo.template_id);
			
			if(EquipDyManager.instance.getEquipPosFromRole(_curEquipDyVo.equip_id) > 0)
				Xtip.registerLinkTip(_curEquipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id,true);
			else
				Xtip.registerLinkTip(_curEquipIcon,EquipTipMix,TipUtil.equipTipInitFunc,_curEquipDyVo.equip_id,_curEquipDyVo.template_id);
			
			showOneEquipCanInlaidHoles(_curEquipBsVo.hole_number);//不可见某些孔什么的已经在clearLeftPanel设置好了
			
			_curGemsAry=new Array(_curEquipBsVo.hole_number);
			showOneEquipInlaidGems();
			
			var gemType:int=getGemType(_curEquipDyVo);
			updateGemsList(false,gemType);
		}
		
		/**
		 * 选择宝石 
		 * @param event
		 * 
		 */
		protected function onGemsChange(event:Event):void
		{
			if(_curEquipDyVo == null)//是否放上装备
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1209);
				return;
			}
			
//			var curEquipBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			var nextPos:int=getNextNeedShowPos();
			if(nextPos == _curEquipBsVo.hole_number)//没有可镶嵌的孔
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1210);
				return;
			}
			
			if(checkGemNone() == true)//检查宝石是否用完
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1221);
				return;
			}
			
			var vo:PropsBasicVo = _gemsList.selectedItem.vo;
			var icon:IconImage=_holeIcons[nextPos];
			icon.url = PropsBasicManager.Instance.getURL(vo.template_id);
			Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,vo.template_id);
			
			var gemInfo:Object={};
			gemInfo.gemPos=getNextNeedInlayPos();
			gemInfo.inlay=false;
			gemInfo.bsVo=vo;
			_curGemsAry[nextPos]=gemInfo;
			
			checkInlayBtn();
		}
		
		private function onEquipClick(e:MouseEvent):void
		{
			if(_curEquipDyVo != null)
			{
				clearLeftPanel();
				_bagEquipList.clearAllSelection();
				_characterEquipList.clearAllSelection();
				updateGemsList();
			}
		}
		
		/** 得到下一个未镶嵌宝石的位置
		 * @return 
		 */		
		private function getNextNeedShowPos():int
		{
			var pos:int=-1;
			var len:int=_curGemsAry.length;
			for(var i:int=0;i<len;i++)
			{
				if(_curGemsAry[i] == null)
				{
					pos=i;
					break;
				}
			}
			if(pos == -1)
				pos=_curGemsAry.length;
			return pos;
		}
		
		/** 找第一个未镶嵌宝石的实际位置（不是icon的显示位置）
		 * @return  
		 */		
		private function getNextNeedInlayPos():int
		{
			var posAry:Array=new Array(_curGemsAry.length);
			for each(var info:Object in _curGemsAry)//先把已镶嵌的，和准备镶嵌的位置标记出来
			{
				if(info)
				{	
					posAry[info.gemPos]=1;
				}	
			}
			
			var pos:int=0;
			var len:int=posAry.length;
			for(var i:int=0;i<len;i++)//找到第一个未镶嵌的位置就可以返回了
			{
				if(posAry[i] == null)
				{
					pos=i;
					break;
				}
			}
			return pos;
		}
		
		/**
		 * 检查list里点击的宝石是否全部放到左侧面板上
		 * @param vo
		 * @return true是用完了
		 * 
		 */		
		private function checkGemNone():Boolean
		{
			var onvo:PropsBasicVo = _gemsList.selectedItem.vo;
			var count:int=0;
			for each(var gemInfo:Object in _curGemsAry)
			{
				if(gemInfo && gemInfo.inlay == false)//在未镶嵌的里面找静态id相同的
				{
					if(PropsBasicVo(gemInfo.bsVo).template_id == onvo.template_id)
						count++;
				}
			}
			
			var max:int = PropsDyManager.instance.getPropsQuantity(onvo.template_id);
			if( (count+1) > max ) return true;
			return false;
		}
		
		protected function onHoleClick(e:MouseEvent):void
		{	
			if(_curEquipDyVo == null) return;
			
			var sp:Sprite = e.currentTarget as Sprite;
			var index:int = XFind.findIndexInArray(sp,_holes);
			if(index == -1) return;//没有这个东西，不操作
			if(_curGemsAry[index])
			{
				if(_curGemsAry[index] && _curGemsAry[index].inlay)
				{
					NoticeUtil.setOperatorNotice("这个宝石已经被镶嵌上了");
					return;//当前点击在已镶嵌的宝石，不往下操作
				}		
			}
			
			_curGemsAry[index]=null;//保持_curGemsAry的长度为当前装备的孔数
			sortGemAry();
			
			var vo:PropsBasicVo;
			var nowOnLen:int = _curGemsAry.length;
			for(var i:int=index;i<nowOnLen;i++)//从发生改变的部分开始循环至全部孔数
			{
				if(_curGemsAry[i])
				{
					vo = _curGemsAry[i].bsVo;
					IconImage(_holeIcons[i]).url = PropsBasicManager.Instance.getURL(vo.template_id);
					Xtip.registerLinkTip(IconImage(_holeIcons[i]),PropsTip,TipUtil.propsTipInitFunc,0,vo.template_id);
				}
				else
				{
					IconImage(_holeIcons[i]).clear();
					Xtip.clearLinkTip(IconImage(_holeIcons[i]));
				}
			}
			
			if(checkInlayBtn() == false)//如果一个宝石都不选就取消宝石列表里的选择
				_gemsList.clearSelection();
			
			checkInlayBtn();
		}
		
		/** 把_curGemsAry里的空位置前移
		 */		
		private function sortGemAry():void
		{
			var len:int=_curGemsAry.length;
			var ary:Array=new Array(len);
			for(var i:int=0;i<len;i++)
			{
				ary[i]=null;
			}
			
			var j:int=0;
			for(i=0;i<len;i++)
			{
				if(_curGemsAry[i])
				{
					ary[j]=_curGemsAry[i];
					j++;
				}
			}
			_curGemsAry=ary;
		}
		
		public function updateAllList(e:YFEvent=null):void
		{
			if(_update == false) return;
			
			updateCharacterList();
			updateBagList();
			
			_bagEquipList.updateNow();
			_characterEquipList.updateNow();
			
			if(_curEquipDyVo)//如果有之前的缓存数据，则在背包和身上找，找不到再删
			{
				var index1:int=_bagEquipList.findDataIndex(_curEquipDyVo,"vo");		
				if(index1 > -1)
				{
					_bagEquipList.isDispatchEvnet=false;
					_bagEquipList.selectedIndex=index1;
					_bagEquipList.scrollToIndex(index1);
				}
				else
				{
					var index2:int=_characterEquipList.findDataIndex(_curEquipDyVo,"vo");
					if(index2 > -1)
					{
						_characterEquipList.isDispatchEvnet=false;
						_characterEquipList.selectedIndex = index2;
						_characterEquipList.scrollToIndex(index2);
					}
					else
					{
						clearLeftPanel();
					}	
				}
			}
			if(_curEquipDyVo)//为什么这里还要判断，因为很可能这个装备只有一个孔，镶嵌后这个装备就不再装备栏显示了
			{
				//更新宝石图标
				clearAllIcons();
				
				var basicVO:EquipBasicVo= EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
				showOneEquipCanInlaidHoles(basicVO.hole_number);
				showOneEquipInlaidGems();
				
				var len:int=_curGemsAry.length;
				var index:int=0;
				var vo:PropsBasicVo;
				for(var i:int=0;i<len;i++)
				{
					if(_curGemsAry[i])
					{
						vo=_curGemsAry[i].bsVo;
						IconImage(_holeIcons[i]).url = PropsBasicManager.Instance.getURL(vo.template_id);
						Xtip.registerLinkTip(IconImage(_holeIcons[i]),PropsTip,TipUtil.propsTipInitFunc,0,vo.template_id);
						
					}
				}
				
				//选择某个装备后下面对应的宝石列表
				var gemType:int = getGemType(_curEquipDyVo);
				updateGemsList(false,gemType);
			}
			
			checkInlayBtn();			
		}
		
		private function getGemType(dyVo:EquipDyVo):int
		{
			var bsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
			var gemType:int;
			if(bsVo.type == TypeProps.EQUIP_TYPE_WEAPON || bsVo.type == TypeProps.EQUIP_TYPE_SHIELD)
				gemType = ForgeSource.GEM_TYPE_ATTACK;
			else if(bsVo.type == TypeProps.EQUIP_TYPE_HELMET || bsVo.type == TypeProps.EQUIP_TYPE_CLOTHES 
				|| bsVo.type == TypeProps.EQUIP_TYPE_WRIST || bsVo.type == TypeProps.EQUIP_TYPE_SHOES)
				gemType = ForgeSource.GEM_TYPE_DEFEND;
			else if(bsVo.type == TypeProps.EQUIP_TYPE_RING || bsVo.type == TypeProps.EQUIP_TYPE_NECKLACE)
				gemType = ForgeSource.GEM_TYPE_LIFE;
			return gemType;
		}
		
		/**
		 * 更新宝石列表
		 */
		private function updateGemsList(gemDefault:Boolean=true,gemType:int=0):void
		{	
			//首先在背包里挑出静态名称不同的宝石
			var gemsHashMap:HashMap=new HashMap();
			var bsVo:PropsBasicVo;
			var allProps:Array=BagStoreManager.instantce.getAllPropsFromBag();
			if(gemDefault)
			{
				allProps = BagStoreManager.instantce.getAllPropsFromBag();
				for each(var dyVo:PropsDyVo in allProps)
				{
					bsVo=PropsBasicManager.Instance.getPropsBasicVo(dyVo.templateId);
					if(bsVo.type == TypeProps.PROPS_TYPE_GEM)
						gemsHashMap.put(bsVo.name,bsVo);//这里不能用静态id做索引，因为同样一个道具绑定和不绑定的id不同
				}
			}
			else//不同宝石类型
			{
				allProps = BagStoreManager.instantce.getAllPropsFromBag();
				for each(dyVo in allProps)
				{
					bsVo=PropsBasicManager.Instance.getPropsBasicVo(dyVo.templateId);
					//补充：宝石使用等级要小于等于装备等级
					if(bsVo.type == TypeProps.PROPS_TYPE_GEM && bsVo.gem_type == gemType && bsVo.level <= _curEquipBsVo.level)
						gemsHashMap.put(bsVo.name,bsVo);//这里不能用静态id做索引，因为同样一个道具绑定和不绑定的id不同
				}
			}
			
			var arr:Array=gemsHashMap.values();
			arr.sortOn("template_id",Array.NUMERIC);
			
			_gemsList.removeAll();
			
			var item:Object;
			for each(var vo:PropsBasicVo in arr)
			{
				item = {};
				item.showType=ForgeSource.ITEM_NUM;
				item.vo = vo;
				item.type=ForgeSource.PROPS;
				_gemsList.addItem(item);
			}
			
		}
		
		/**
		 * 刷新身上装备列表
		 * @param event 
		 */		
		private function updateCharacterList(event:Object = null):void
		{
			if(_update == false) return;
			
			var arr:Array = CharacterDyManager.Instance.getAllEquips();
			updateTileList(_characterEquipList,arr,true);//记得回过滤掉穿戴后绑定的装备			
		}
		
		/**
		 * 刷新背包 已有装备列表
		 */
		private function updateBagList():void
		{
			var arr:Array = BagStoreManager.instantce.getAllEquipsFromBag();
			updateTileList(_bagEquipList,arr);//记得回过滤掉穿戴后绑定的装备
			
		}
		
		/**
		 * 更新列表（背包或身上）
		 * @param list
		 * @param arr 数据
		 * @param type 
		 * 
		 */		
		private function updateTileList(list:TileList,arr:Array,isSelf:Boolean=false):void
		{
			list.removeAll();
			
//			if(arr == null) return;

			var basicVO:EquipBasicVo;
			var item:Object;
			var equips:Array=[];
			for each(var vo:EquipDyVo in arr)
			{
				basicVO = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
				if(basicVO.type != TypeProps.EQUIP_TYPE_WINGS && basicVO.career != TypeRole.CAREER_NEWHAND && 
					basicVO.type != TypeProps.EQUIP_TYPE_FASHION_BODY)
				{
					var nowCount:int = countCurEquipGems(vo);
					if( nowCount < basicVO.hole_number)
					{
						equips.push(vo);				
					}
				}
			}
			
			equips=ForgeSource.orderContainEquips(equips);
			for each(vo in equips)
			{
				item = {};
				item.vo = vo;
				item.showType=ForgeSource.SHOW_GEMS;
				if(isSelf)
					item.type=ForgeSource.CHARACTER;
				else
					item.type=ForgeSource.BAG;
				list.addItem(item);
			}
		}
	
		
		
		
		
		/**
		 * 查询指定装备已经镶嵌宝石数量 
		 * @param vo
		 * @return 
		 * 
		 */		
		private function countCurEquipGems(vo:EquipDyVo):int
		{
			var count:int=0;
			if(vo.gem_1_id != 0){
				count++;
			}
			if(vo.gem_2_id != 0){
				count++;
			}
			if(vo.gem_3_id != 0){
				count++;
			}
			if(vo.gem_4_id != 0){
				count++;
			}
			if(vo.gem_5_id != 0){
				count++;
			}
			if(vo.gem_6_id != 0){
				count++;
			}
			if(vo.gem_7_id != 0){
				count++;
			}
			if(vo.gem_8_id != 0){
				count++;
			}
			return count;
		}
		
		
		/**
		 * 显示可用的镶嵌孔 
		 * @param num
		 * 
		 */		
		private function showOneEquipCanInlaidHoles(num:int):void
		{
			//先全部显示不可用一遍
			var len:int = _holes.length;
			for(var i:int=0;i<len;i++)
			{
				UI.setEnable(Sprite(_holes[i]),false);
				Sprite(_holes[i]).alpha = 0.5;
			}
			//再显示可以用的
			for(i=0;i<num;i++)
			{
				UI.setEnable(Sprite(_holes[i]),true);
				Sprite(_holes[i]).alpha = 1;
			}
		}
		
		/**
		 * 显示指定装备当前已镶嵌的所有宝石图标
		 * @param dyVo
		 * 
		 */		
		private function showOneEquipInlaidGems():void
		{	
			var i:int=0;
			if(_curEquipDyVo.gem_1_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_1_id,i,0);
				i++;
			}
			if(_curEquipDyVo.gem_2_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_2_id,i,1);
				i++;
			}
			if(_curEquipDyVo.gem_3_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_3_id,i,2);
				i++;
			}
			if(_curEquipDyVo.gem_4_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_4_id,i,3);
				i++;
			}
			if(_curEquipDyVo.gem_5_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_5_id,i,4);
				i++;
			}
			if(_curEquipDyVo.gem_6_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_6_id,i,5);
				i++;
			}
			if(_curEquipDyVo.gem_7_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_7_id,i,6);
				i++;
			}
			if(_curEquipDyVo.gem_8_id > 0)
			{
				showOneInlaidGem(_curEquipDyVo.gem_8_id,i,7);
				i++;
			}
			
		}
			
		/**
		 * 显示宝石图片，并生成宝石数据，和图片绑定
		 * @param gemId
		 * @param iconIndex
		 * @param gemPos
		 * 
		 */		
		private function showOneInlaidGem(gemId:int,iconIndex:int,gemPos:int):void
		{
			if(gemId > 0)
			{
				var icon:IconImage =_holeIcons[iconIndex];
				var bsVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(gemId);
				icon.url = PropsBasicManager.Instance.getURL(gemId);
				Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,gemId);
				
				var gemInfo:Object={};
				gemInfo.gemPos=gemPos;
				gemInfo.inlay=true;
				gemInfo.bsVo=bsVo;
				_curGemsAry[iconIndex]=gemInfo;
			}
			
		}
		
		private function clearAllIcons():void
		{
			for each(var icon:IconImage in _holeIcons)
			{
				icon.clear();
			}
		}
		
		private function checkInlayBtn():Boolean
		{
			if(_curEquipDyVo != null)
			{
				var inlay:Boolean=false;
				for each(var gemInfo:Object in _curGemsAry)
				{
					if(gemInfo && gemInfo.inlay == false)
					{
						inlay = true;
						break;
					}
				}
				if(inlay)
					_inlayButton.enabled=true;
				else
					_inlayButton.enabled=false;
			}
			else
				_inlayButton.enabled = false;
			
			return _inlayButton.enabled;
		}
		
		protected function onInlayBtnClick(event:MouseEvent):void
		{
			var equipPos:int;
			var curEquipBsVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(_curEquipDyVo.template_id);
			if(EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id) != 0)
			{
				equipPos = EquipDyManager.instance.getEquipPosFromBag(_curEquipDyVo.equip_id);
			}
			else
			{
				equipPos = curEquipBsVo.type;
			}
			
			var gemBsVo:PropsBasicVo;
			var gemInfo:Object;
			var len:int=_curGemsAry.length;
			for(var i:int=0;i<len;i++)
			{
				if(_curGemsAry[i] && _curGemsAry[i].inlay == false)
				{
					gemBsVo=_curGemsAry[i].bsVo;
					
					var gemPosAry:Array=PropsDyManager.instance.getPropsPosArray(gemBsVo.template_id,1);
					ModuleManager.forgetModule.inlayGem(equipPos,_curGemsAry[i].gemPos,gemPosAry[0].pos);
				}			
			}
		}
	}
}