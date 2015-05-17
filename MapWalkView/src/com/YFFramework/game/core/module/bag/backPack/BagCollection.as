package com.YFFramework.game.core.module.bag.backPack
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.baseClass.Collection;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.event.ZEvent;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.skill.window.DragData;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CUseItem;
	import com.msg.item.Unit;
	import com.msg.storage.CExpandStorageReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromPackReq;
	import com.msg.storage.CSellItemReq;
	import com.msg.storage.CSplitItemReq;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	


	/**
	 * @version 1.0.0
	 * creation time：2012-11-15 下午04:06:16
	 * 
	 */
	public class BagCollection extends Collection
	{
		//======================================================================
		//        const variable
		//======================================================================
		
		//======================================================================
		//        static variable
		//======================================================================
		/**
		 *主要作用是：背包grid的侦听时间，不负责初始化和更新数据 
		 */		
		//======================================================================
		//        variable
		//======================================================================			
		private var _money:int=0;
		
		private var _curInfo:ItemDyVo;//仅限二级菜单使用
		
		private var _fromDragVo:DragData;
		
		private var curPos:Point;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagCollection(boxType:int)
		{
			super(boxType);
			addEvents();
			curPos=new Point();

		}
		//======================================================================
		//        function
		//======================================================================
		public function dispose():void
		{
			removeEventListener(BagEvent.USE_ITEM,useItemDirect);
			removeEventListener(BagEvent.HIGH_LIGHT,bagHighLight);
			removeEventListener(BagEvent.OPEN_GRID,openGrid);
			removeEventListener(BagEvent.HIGH_LIGHT,bagHighLight);		
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{		
			addEventListener(BagEvent.USE_ITEM,useItemDirect);
			addEventListener(BagEvent.HIGH_LIGHT,bagHighLight);
			addEventListener(BagEvent.OPEN_GRID,openGrid);
			addEventListener(BagEvent.POP_UP_SECOND_MENU,popUpMenu);	
		}

		

		private function useItem(info:ItemDyVo):void
		{	
			if(info.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				var level:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
				var templateId:int=EquipDyManager.instance.getEquipInfo(info.id).template_id;
				var template:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(templateId);
				var sex:int=DataCenter.Instance.roleSelfVo.roleDyVo.sex;
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).level > level)
				{
					NoticeUtil.setOperatorNotice("人物等级不够，不能装备!");
					return;
				}
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != sex
				&& EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != TypeProps.GENDER_NONE)
				{
					NoticeUtil.setOperatorNotice("人物性别不对，不能装备！");
					return;
				}
				else
				{
					var bodyMsg:CPutToBodyReq=new CPutToBodyReq();
					bodyMsg.sourcePos=info.pos;
					bodyMsg.targetPos=template.type;
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CPutToBodyReq,bodyMsg);				
					Xtip.hideNowTip();
				}
			}			
			else if(info.type == TypeProps.ITEM_TYPE_PROPS)
			{
				if(PropsDyManager.instance.getPropsInfo(info.id))
				{
					var props:PropsDyVo=PropsDyManager.instance.getPropsInfo(info.id);
					var propsTemplate:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(props.templateId);
					if(propsTemplate.canFire() == false)//如果在冷却时间内无法使用
					{
						NoticeUtil.setOperatorNotice("冷却中无法使用！");
						return;
					}
					//如果是洗点、洗练、技能书、领悟、晶核，打开对应面板
					if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_ENHANCE || propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMPRE ||
						propsTemplate.type == TypeProps.PROPS_TYPE_PET_SKILLBOOK || propsTemplate.type == TypeProps.PROPS_TYPE_PET_SOPHI ||
						 props.templateId == ConstMapBasicManager.Instance.getConstMapBasicVo(TypeProps.CONST_ID_PET_RESET).tmpl_id)
					{
						YFEventCenter.Instance.dispatchEventWith(BagEvent.OPEN_PET_PANEL,propsTemplate.dialog_id);
						return;
					}	
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMFORT || propsTemplate.type == TypeProps.PROPS_TYPE_PET_FEED)//只能作用于出战宠物
					{
						var hasPet:Boolean=false;
						if(PetDyManager.Instance.getFightPetId() == 0)
						{
							NoticeUtil.setOperatorNotice("没有出战宠物,无法使用");
							return;
						}
						else
						{
							var hp:Number=PetDyManager.Instance.getPetDyVo(PetDyManager.Instance.getFightPetId()).fightAttrs[TypeProps.HP];
							var hpMax:Number=PetDyManager.Instance.getPetDyVo(PetDyManager.Instance.getFightPetId()).fightAttrs[TypeProps.HP_LIMIT];
							var happy:int=PetDyManager.Instance.getPetDyVo(PetDyManager.Instance.getFightPetId()).happy;
							if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_FEED && hp == hpMax)
							{
								NoticeUtil.setOperatorNotice("宠物生命值已满，无需喂养");
								return;
							}
							else if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMFORT && happy >= 100)
							{
								NoticeUtil.setOperatorNotice("宠物快乐度已满，无需驯养");
								return;
							}
							else
								hasPet=true;
						}
					}
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_EGG)
					{
						if(PetDyManager.Instance.getPetIdArray().length >= PetDyManager.Instance.getPetOpenSlots())
						{
							NoticeUtil.setOperatorNotice("宠物槽已满！");
							return;
						}
					}
					if(propsTemplate.level > DataCenter.Instance.roleSelfVo.roleDyVo.level)//使用物品等级不能超过人的等级
					{
						NoticeUtil.setOperatorNotice("你的等级不够，无法使用这个物品");
						return;
					}
					var msg:CUseItem=new CUseItem();
					msg.itemPos=info.pos;
					if(hasPet)
						msg.petId=PetDyManager.Instance.getFightPetId();
					YFEventCenter.Instance.dispatchEventWith(BagEvent.USE_ITEM,msg);
					Xtip.hideNowTip();
				}

			}		
			
		}

		private function splitProps():void
		{
			var txt:String="请输入要拆分的数量";
			JInputWindow.Instance().initPanel("道具拆分",txt,checkSplit);
			JInputWindow.Instance().setRestrict("1-9");
			JInputWindow.Instance().setMaxMin(PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity-1);
		}
		
		private function abandonItem():void
		{
			var alert:Alert=Alert.show("确认丢弃?","丢弃",onDelAlert,["确认","取消"]);
		}
		
		private function sellItem():void
		{
			var msg:CSellItemReq=new CSellItemReq();
			msg.sourcePos=_curInfo.pos;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSellItemReq,msg);
		}
		
		/**
		 * 仅无出售 ,有拆分
		 * 
		 */		
		private function menuNonSellMode(pos:Point):void
		{
			var menu:Menu=new Menu();
			menu.addItem("使用",onNonSellModeClick);
			menu.addItem("拆分",onNonSellModeClick);
			menu.addItem("展示",onNonSellModeClick);
			menu.addItem("丢弃",onNonSellModeClick);
			menu.show(null,pos.x,pos.y);
		}
		
		/**
		 * 有出售，有拆分 
		 * 
		 */		
		private function menuSellMode(pos:Point):void
		{
			var menu:Menu=new Menu();
			menu.addItem("使用",onSellModeClick);
			menu.addItem("拆分",onSellModeClick);
			menu.addItem("展示",onSellModeClick);
			menu.addItem("丢弃",onSellModeClick);
			menu.addItem("出售",onSellModeClick);
			menu.show(null,pos.x,pos.y);
		}
		
		/**
		 * 无拆分，无出售 
		 * 
		 */		
		private function menuNonSplitnSellMode(pos:Point):void
		{
			var menu:Menu=new Menu();
			menu.addItem("使用",onNonSplitnSellModeClick);
			menu.addItem("展示",onNonSplitnSellModeClick);
			menu.addItem("丢弃",onNonSplitnSellModeClick);
			menu.show(null,pos.x,pos.y);
		}
		
		/**
		 * 无拆分，有出售 
		 * 
		 */		
		private function menuNonSplitMode(pos:Point):void
		{
			var menu:Menu=new Menu();
			menu.addItem("使用",onNonSplitModeClick);
			menu.addItem("展示",onNonSplitModeClick);
			menu.addItem("丢弃",onNonSplitModeClick);
			menu.addItem("出售",onNonSplitModeClick);
			menu.show(null,pos.x,pos.y);
		}
		//======================================================================
		//        event handler
		//======================================================================	
		private function checkSplit():void
		{
			if(_curInfo)
			{
				var num:int=int(JInputWindow.Instance().getInputText());
				if(num > 0 && num< PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity)
				{
					var msg:CSplitItemReq=new CSplitItemReq();
					msg.sourcePos=_curInfo.pos;
					msg.splitNum=num;
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSplitItemReq,msg);
					JInputWindow.Instance().close();
					JInputWindow.Instance().dispose();
				}
			}
			
		}
		private function onConsumeMoney(e:AlertCloseEvent):void
		{	
			if(e.clickButtonIndex==1)
			{
				if(_money <= DataCenter.Instance.roleSelfVo.diamond)
				{
					var msg:CExpandStorageReq=new CExpandStorageReq();
					msg.stType=TypeProps.STORAGE_TYPE_PACK;
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CExpandStorageReq,msg);
				}
				else
				{
					NoticeUtil.setOperatorNotice("金钱不够不能开启!");
				}
			}
			
		}
		
		private function onDelAlert(e:AlertCloseEvent):void
		{
			var abandonMsg:CRemoveFromPackReq=new CRemoveFromPackReq();
			abandonMsg.item=new Unit();
			var item:Unit=new Unit();
			item.id=_curInfo.id;
			item.type=_curInfo.type;
			abandonMsg.item=item;
			abandonMsg.pos=_curInfo.pos;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromPackReq,abandonMsg);
			
		}
		
		private function bagHighLight(e:BagEvent):void
		{
			highLight(e.data as int);
		}
		
		private function useItemDirect(e:BagEvent):void
		{
			useItem(e.data as ItemDyVo);
			
		}
		private function openGrid(e:BagEvent):void
		{
			if(BagStoreManager.instantce.getPackNum() < PackSource.TOTAL_GRIDS)
			{
				_money=(int((BagStoreManager.instantce.getPackNum()-PackSource.PAGE_NUM)/PackSource.ROW_GRIDS)+1)*20;
				var str:String="扩展7格背包，需要花费*魔钻，是否继续？"
				str=str.replace("*",_money.toString());
				Alert.show(str,"扩展背包",onConsumeMoney,["确认","取消"]);
			}	
			
		}
		
		/**
		 * 弹出菜单 
		 * @param e
		 * 
		 */		
		protected function popUpMenu(e:BagEvent):void
		{	
			var pos:int=e.data as int;
			var grid:MoveGrid=moveGrids.get(pos);
			if(grid.parent)
				_curInfo = grid.info;
			else
				_curInfo = null;
			
			var stagePos:Point=new Point(StageProxy.Instance.stage.mouseX-3,StageProxy.Instance.stage.mouseY-3);
			
			var time:TimeOut=new TimeOut(250,onMouseClickLater,stagePos);
			time.start();
					
		}

		private function onMouseClickLater(obj:Object):void
		{
			if(PackSource.popUp && _curInfo && PackSource.shopSell == false && PackSource.shopMend == false)//已经在moveGrid里判断过了，有没有开仓库
			{
				if(_curInfo.type == TypeProps.ITEM_TYPE_PROPS)
				{
					var props:PropsDyVo=PropsDyManager.instance.getPropsInfo(_curInfo.id);
					var propsTemplate:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(props.templateId);
					if(propsTemplate.canFire() == false)//如果在冷却时间内无法使用
					{
						return;
					}
				}		
				
				Xtip.hideNowTip();
				
				if(ModuleManager.moduleShop.isNPCShopOpened == false)//未打开商店
				{
					if(_curInfo.type == TypeProps.ITEM_TYPE_PROPS)//只有道具可拆分
					{
						if(PropsDyManager.instance.getPropsInfo(_curInfo.id))
						{
							var templateId1:int=PropsDyManager.instance.getPropsInfo(_curInfo.id).templateId;
							if(PropsBasicManager.Instance.getPropsBasicVo(templateId1).type == TypeProps.PROPS_TYPE_TASK)//处理任务道具
								return;
							else if(PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity > 1)//道具要>1
								menuNonSellMode(obj as Point);//无出售有拆分
							else
								menuNonSplitnSellMode(obj as Point);//无出售无拆分
						}
						
					}
					else
						menuNonSplitnSellMode(obj as Point);//无出售无拆分
					
				}
				else//打开商店
				{
					if(PropsDyManager.instance.getPropsInfo(_curInfo.id))
					{
						var templateId2:int=PropsDyManager.instance.getPropsInfo(_curInfo.id).templateId;
						if(PropsBasicManager.Instance.getPropsBasicVo(templateId2).type == TypeProps.PROPS_TYPE_TASK)//处理任务道具
							return;
						else if(PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity > 1)//道具要>1
							menuSellMode(obj as Point);//有出售有拆分
						else
							menuNonSplitMode(obj as Point);//有出售无拆分
					}
					else
						menuNonSplitMode(obj as Point);//无出售无拆分
				}
				
			}		
		}
		
		private function onNonSellModeClick(index:uint,label:String):void
		{
			switch(index)
			{
				case 0:
					useItem(_curInfo);
					break;
				case 1:
					splitProps();
					break;
				case 2://展示
					break;
				case 3:
					abandonItem();
					break;
			}
		}
		
		private function onSellModeClick(index:uint,label:String):void
		{
			switch(index)
			{
				case 0:
					useItem(_curInfo);
					break;
				case 1:
					splitProps();
					break;
				case 2://展示
					break;
				case 3:
					abandonItem();
					break;
				case 4:
					sellItem();
					break;
			}
		}
		
		private function onNonSplitnSellModeClick(index:uint,label:String):void
		{
			switch(index)
			{
				case 0:
					useItem(_curInfo);
					break;
				case 1://展示
					break;
				case 2:
					abandonItem();
					break;
			}
		}
		
		private function onNonSplitModeClick(index:uint,label:String):void
		{
			switch(index)
			{
				case 0:
					useItem(_curInfo);
					break;
				case 1://展示
					break;
				case 2:
					abandonItem();
					break;
				case 3:
					sellItem();
					break;
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 