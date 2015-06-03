package com.YFFramework.game.core.module.bag.backPack
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConfigDataManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.baseClass.Collection;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagPopUpMenu;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.notMetion.data.NotMetionDataManager;
	import com.YFFramework.game.core.module.notMetion.view.NotMetionWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xtip;
	import com.msg.common.ItemConsume;
	import com.msg.hero.CUseItem;
	import com.msg.item.Unit;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromPackReq;
	import com.msg.storage.CSellItemReq;
	import com.msg.storage.CSplitItemReq;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	


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
		private var _curInfo:ItemDyVo;//仅限二级菜单使用
		
		private var curPos:Point;		
		private var lastMenu:Menu;
		private var _money:int=0;
//		private var _isFirst:Boolean=true;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagCollection(boxType:int,mc:Sprite)
		{
			super(boxType,mc);
			addEvents();
			curPos=new Point();

		}
		//======================================================================
		//        function
		//======================================================================
		public function dispose():void
		{
			YFEventCenter.Instance.removeEventListener(BagEvent.USE_ITEM,useItemDirect);
			
			YFEventCenter.Instance.removeEventListener(BagEvent.OPEN_BAG_GRID,openGrid);
			YFEventCenter.Instance.removeEventListener(BagEvent.POP_UP_SECOND_MENU,popUpMenu);
			
			YFEventCenter.Instance.removeEventListener(BagEvent.POP_UP_INDEX,useMenu);
		}
		
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{		
			YFEventCenter.Instance.addEventListener(BagEvent.USE_ITEM,useItemDirect);
			
			YFEventCenter.Instance.addEventListener(BagEvent.OPEN_BAG_GRID,openGrid);
			YFEventCenter.Instance.addEventListener(BagEvent.POP_UP_SECOND_MENU,popUpMenu);
			
			YFEventCenter.Instance.addEventListener(BagEvent.POP_UP_INDEX,useMenu);
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
					NoticeManager.setNotice(NoticeType.Notice_id_307);
					return;
				}
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != sex
				&& EquipBasicManager.Instance.getEquipBasicVo(templateId).gender != TypeProps.GENDER_NONE)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_308);
					return;
				}
				if(EquipBasicManager.Instance.getEquipBasicVo(templateId).career != DataCenter.Instance.roleSelfVo.roleDyVo.career)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_1700);
					return;
				}
				else
				{
					//以后要注意时效性装备的问题
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
					
					if(propsTemplate.type == TypeProps.PROPS_TYPE_TASK)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_309);
						return;
					}
					
					if(BagStoreManager.instantce.getCd(propsTemplate.cd_type))
					{
						NoticeManager.setNotice(NoticeType.Notice_id_310);
						return;
					}
					//如果是宠物洗点、洗练、技能书、领悟、晶核打开对应面板
					if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_ENHANCE || propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMPRE ||
						propsTemplate.type == TypeProps.PROPS_TYPE_PET_SKILLBOOK || propsTemplate.type == TypeProps.PROPS_TYPE_PET_SOPHI)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_PET_PANEL,propsTemplate.dialog_id);
						return;
					}
					//如果是强化材料、装备洗练、宝石、羽毛打开对应面板
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_ENHANCE || propsTemplate.type == TypeProps.PROPS_TYPE_GEM || 
						propsTemplate.type == TypeProps.PROPS_TYPE_FEATHER  || propsTemplate.type == TypeProps.PROPS_TYPE_DEFT)
//						props.templateId == ConstMapBasicManager.Instance.getConstMapBasicVo(TypeProps.CONST_EQUIP_SOPHI).tmpl_id)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_FORGE_PANEL,propsTemplate.dialog_id);
						return;
					}
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_OPEN_PACK)
					{
						if(BagStoreManager.instantce.getPackNum() == BagSource.TOTAL_GRIDS)
						{
							NoticeUtil.setOperatorNotice("背包已全部开启，无法使用该道具");
							return;
						}
					}
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_OPEN_DEPOT)
					{
						if(BagStoreManager.instantce.getDepotNum() == BagSource.TOTAL_GRIDS)
						{
							NoticeUtil.setOperatorNotice("仓库已全部开启，无法使用该道具");
							return;
						}
					}
					//如果是坐骑喂养打开对应界面
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_MOUNT_FEED)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_MOUNT_PANEL,propsTemplate.dialog_id);
						return;
					}
					//打开大喇叭界面
					else if(props.templateId == ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_SPEAKER_ITEM))
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_SPEAKER_PANEL);
						return;
					}
					if(propsTemplate.level > DataCenter.Instance.roleSelfVo.roleDyVo.level)//使用物品等级不能超过人的等级
					{
						NoticeManager.setNotice(NoticeType.Notice_id_311);
						return;
					}
					//只能作用于出战宠物
					if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMFORT || propsTemplate.type == TypeProps.PROPS_TYPE_PET_FEED)
					{
						var hasPet:Boolean=false;
						if(PetDyManager.fightPetId == 0)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_312);
							return;
						}
						else
						{
							var hp:Number=PetDyManager.Instance.getFightPetDyVo().fightAttrs[TypeProps.EA_HEALTH];
							var hpMax:Number=PetDyManager.Instance.getFightPetDyVo().fightAttrs[TypeProps.EA_HEALTH_LIMIT];
							var happy:int=PetDyManager.Instance.getFightPetDyVo().happy;
							if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_FEED && hp == hpMax)
							{
								NoticeManager.setNotice(NoticeType.Notice_id_313);
								return;
							}
							else if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_COMFORT && happy >= 100)
							{
								NoticeManager.setNotice(NoticeType.Notice_id_314);
								return;
							}
							else
								hasPet=true;
						}
					}
					//开宠物蛋
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_PET_EGG)
					{
						if(PetDyManager.Instance.getPetIdArray().length >= PetDyManager.petOpenSlots)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_315);
							return;
						}
					}
					//开坐骑蛋
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_MOUNT_EGG)
					{
						if(MountDyManager.Instance.getMountsIdArr().length == TypeProps.MOUNT_MAX_NUM)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_316);
							return;
						}
					}
					//人物加血
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_HP_DRUG)
					{
						if(DataCenter.Instance.roleSelfVo.roleDyVo.hp == DataCenter.Instance.roleSelfVo.roleDyVo.maxHp)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_317);
							return;
						}
					}
					//人物加蓝
					else if(propsTemplate.type == TypeProps.PROPS_TYPE_MP_DRUG)
					{
						if(DataCenter.Instance.roleSelfVo.roleDyVo.mp == DataCenter.Instance.roleSelfVo.roleDyVo.maxMp)
						{
							NoticeManager.setNotice(NoticeType.Notice_id_318);
							return;
						}
					}
					//以后要注意时效性装备的问题
					var msg:CUseItem=new CUseItem();
					msg.itemPos=info.pos;
					if(hasPet)
						msg.petId=PetDyManager.fightPetId;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
					Xtip.hideNowTip();
				}

			}		
			
		}

		private function splitProps():void
		{
			if(BagStoreManager.instantce.remainBagNum() > 0)
			{
				var txt:String=NoticeUtils.getStr(NoticeType.Notice_id_100004);
				JInputWindow.Instance().initPanel("道具拆分",txt,checkSplit);//title没用
				JInputWindow.Instance().setRestrict("0-9");
				
				var inputTf:TextField=JInputWindow.Instance().getInputTextField();
				inputTf.addEventListener(FocusEvent.FOCUS_OUT,inputFocusOut);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);
			}
		}
		
		private function inputFocusOut(e:Event):void
		{
			var inputTf:TextField=JInputWindow.Instance().getInputTextField();
			var dyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(_curInfo.id);
			var max:int=dyVo.quantity-1;
			if(inputTf.text == "" || int(inputTf.text) < 1)
			{
				checkNumInRange(1);
			}
			else if(int(inputTf.text) > max)
			{			
				checkNumInRange(max);
			}
	
		}
		
		private function abandonItem():void
		{
			var alert:Alert;
			var str:String='';
			var templateId:int=0;
			
//			var confirmStr:String=NoticeUtils.getStr(NoticeType.Notice_id_100005);
//			var concelStr:String=NoticeUtils.getStr(NoticeType.Notice_id_100006);
			var buttonLabels:Array = [NoticeUtils.getStr(NoticeType.Notice_id_100005),NoticeUtils.getStr(NoticeType.Notice_id_100006)];
			var fromData:DragData=new DragData();
			fromData.fromID=_curInfo.pos;
			fromData.data=new Object();
			fromData.data.id=_curInfo.id;
			fromData.data.type=_curInfo.type;
				
			if(_curInfo.type == TypeProps.ITEM_TYPE_PROPS)
			{
				var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(_curInfo.id);
				if(propsDyVo)
				{
					templateId=PropsDyManager.instance.getPropsInfo(_curInfo.id).templateId;
					if(propsDyVo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100007);
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						alert=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100008),onDelAlter,buttonLabels,true,fromData);
					}
					else
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100009);
						str = str.replace("*",PropsBasicManager.Instance.getPropsBasicVo(templateId).name);
						alert=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100010),onDelAlter,buttonLabels,true,fromData);
					}
				}
			}
			else if(_curInfo.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(_curInfo.id);
				if(equipDyVo)
				{
					templateId=EquipDyManager.instance.getEquipInfo(_curInfo.id).template_id;
					if(equipDyVo.binding_type == TypeProps.BIND_TYPE_YES)
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100007);
						str = str.replace("*",EquipBasicManager.Instance.getEquipBasicVo(templateId).name);
						alert=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100008),onDelAlter,buttonLabels,true,fromData);
					}
					else
					{
						str=NoticeUtils.getStr(NoticeType.Notice_id_100009);
						str = str.replace("*",EquipBasicManager.Instance.getEquipBasicVo(templateId).name);
						alert=Alert.show(str,NoticeUtils.getStr(NoticeType.Notice_id_100010),onDelAlter,buttonLabels,true,fromData);
					}
				}	
			}
		}
		
		private function sellItem():void
		{
			var msg:CSellItemReq=new CSellItemReq();
			msg.sourcePos=_curInfo.pos;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSellItemReq,msg);
		}
		
		//======================================================================
		//        event handler
		//======================================================================	
		private function checkSplit():void
		{
			if(_curInfo)
			{
				var num:String=JInputWindow.Instance().getInputText();
				var max:int=PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity;//道具总数
				if(int(num) > 0 && int(num)< max)
				{
					var msg:CSplitItemReq=new CSplitItemReq();
					msg.sourcePos=_curInfo.pos;
					msg.splitNum=int(num);
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSplitItemReq,msg);
					JInputWindow.Instance().close();
				}
				else if(num == '' || int(num) <= 0)
				{
					checkNumInRange(1);
				}
				else if(int(num) >= max)
				{
					checkNumInRange(max-1);
				}
			}
			
		}
		
		/**
		 * 把焦点设置在输入框，并选中状态 
		 * @param num
		 * 
		 */		
		private function checkNumInRange(num:int):void
		{
			JInputWindow.Instance().getInputTextField().text=num.toString();
			UI.stage.focus = JInputWindow.Instance().getInputTextField();
			JInputWindow.Instance().getInputTextField().setSelection(0,num);
		}
		
		private function onConsumeMoney(data:Boolean):void
		{	
			NotMetionDataManager.bagOpenGrid=data;
			if(_money <= DataCenter.Instance.roleSelfVo.diamond)
			{
				ModuleManager.bagModule.expandSorageReq(TypeProps.STORAGE_TYPE_PACK);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_319);
			}
		}
		
		private function onDelAlert(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == BagSource.ALTER_COMFIRM)
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
		}
		
		private function useItemDirect(e:YFEvent):void
		{
			useItem(e.param as ItemDyVo);
		}
		
		private function openGrid(e:YFEvent):void
		{
			var mouseOverGridIndex:int=getMouseOverGridIndex();//此处mouseOverGridIndex是鼠标点击的位置，索引从 0开始  计算总量需要加上1  计算开启格子数是  left= mouseOverGridIndex+1  - 开启的数量
			var openGridNum:int=mouseOverGridIndex+1 -BagStoreManager.instantce.getPackNum();  //开启的格子数
//			print(this,"openGridNum 是 实际上要开启的格子数量,......");
			_money=ConfigDataManager.Instance.getConfigData("bag_one_grid_money").config_value;
			var propsNum:int=PropsDyManager.instance.getPropsQuantity(BagSource.OPEN_BAG_GRID_PROPS);//这个数字是我直接查表的，有可能会改变，到时候再改，与其写configMap里让策划不长脑子总不填，还不如直接写死呢				
			if(propsNum > 0)//背包里的道具数量够开格子的
			{
				var num:int=Math.min(openGridNum,propsNum);
				Alert.show("剩余"+num.toString()+"个背包扩充石可以使用，是否开启?",'提示',openGridsComfirm,['确认','取消'],true,num);							
			}
			else
			{
				if(NotMetionDataManager.bagOpenGrid == false)//面板不用打开
				{
					if(_money <= DataCenter.Instance.roleSelfVo.diamond)
					{
						ModuleManager.bagModule.expandSorageReq(TypeProps.STORAGE_TYPE_PACK);
					}
					else
						NoticeUtil.setOperatorNotice('魔钻不足！');
					return;
				}
				var str:String="开启一个背包格子需"+_money.toString()+"魔钻？";				
				NotMetionWindow.show(str,onConsumeMoney);			
			}	
		}
		
		private function openGridsComfirm(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == BagSource.ALTER_COMFIRM)
			{
				var propsNum:int=e.data as int;
				var bagRemainGrid:int=BagSource.TOTAL_GRIDS-BagStoreManager.instantce.getPackNum()-1;//计时的格子不算入内
				var num:int;
				if(bagRemainGrid >= propsNum)  num=propsNum;//格子数大于道具数，也就是道具可全部用完
				else  num = propsNum - bagRemainGrid;//道具用不完
				var posAry:Array=PropsDyManager.instance.getPropsPosArray(BagSource.OPEN_BAG_GRID_PROPS,Math.min(propsNum,num));
				for each(var itemPos:ItemConsume in posAry)
				{
					ModuleManager.bagModule.useItemMoreReq(itemPos.pos,itemPos.number);
				}			
			}
		}
		
		/**
		 * 弹出菜单 
		 * @param e
		 * 
		 */		
		protected function popUpMenu(e:YFEvent):void
		{	
			var pos:int=e.param as int;
			var grid:MoveGrid=moveGrids.get(pos);
			if(grid)
			{
				if(grid.parent)
				{
					_curInfo = grid.info;
//					grid.bgHighLight();
				}
				else
					_curInfo = null;
			}
			var stagePos:Point=new Point(StageProxy.Instance.stage.mouseX+3,StageProxy.Instance.stage.mouseY+3);
			
			var time:TimeOut=new TimeOut(250,onMouseClickLater,stagePos);
			time.start();
					
		}

		private function onMouseClickLater(obj:Object):void
		{
			if(BagSource.popUp && _curInfo && BagSource.shopSell == false && BagSource.shopMend == false)//已经在moveGrid里判断过了，有没有开仓库
			{	
				Xtip.hideNowTip();
				BagPopUpMenu.Instance().popUp(obj as Point,_curInfo);
				
			}		
		}
		
		private function useMenu(e:YFEvent):void
		{
			var index:int=e.param as int;
			switch(index)
			{
				case BagSource.MENU_USE:
					useItem(_curInfo);
					break;
				case BagSource.MENU_SPILT:
					splitProps();
					break;
				case BagSource.MENU_SHOW://展示
					var chatData:ChatData = new ChatData();
					if(_curInfo.type==TypeProps.ITEM_TYPE_EQUIP){
						var equipDyVo:EquipDyVo = EquipDyManager.instance.getEquipInfo(_curInfo.id);
						var equipBasicVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
						chatData.data = equipDyVo;
						chatData.myId = equipDyVo.equip_id;
						chatData.myType = ChatType.Chat_Type_Equip;
						chatData.myQuality = equipBasicVo.quality;
						chatData.displayName = equipBasicVo.name;
					}else{
						var propsDyVo:PropsDyVo = PropsDyManager.instance.getPropsInfo(_curInfo.id);
						var propsBasicVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
						chatData.data = propsDyVo;
						chatData.myId = propsDyVo.propsId;
						chatData.myType = ChatType.Chat_Type_Props;
						chatData.myQuality = propsBasicVo.quality;
						chatData.displayName = propsBasicVo.name;						
					}
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatDisplay,chatData);
					break;
				case BagSource.MENU_ABANDON:
					abandonItem();
					break;
				case BagSource.MENU_USE_MORE:
					var num:int=PropsDyManager.instance.getPropsInfo(_curInfo.id).quantity;
					ModuleManager.bagModule.useItemMoreReq(_curInfo.pos,num);
					break;
			}
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 