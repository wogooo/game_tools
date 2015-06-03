package com.YFFramework.game.core.module.bag
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午4:08:23
	 * 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
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
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.bag.backPack.NewGuideUseItemWindow;
	import com.YFFramework.game.core.module.bag.backPack.OpenBagGridManager;
	import com.YFFramework.game.core.module.bag.baseClass.MoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideTaskManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.wing.event.WingEvent;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.hero.CUseItem;
	import com.msg.hero.CUseMultiItems;
	import com.msg.hero.SUseItem;
	import com.msg.hero.SUseMultiItems;
	import com.msg.item.CDelPropsReq;
	import com.msg.item.CGetCharEquipListReq;
	import com.msg.item.CGetCharPropsListReq;
	import com.msg.item.SCharacterEquipList;
	import com.msg.item.SCharacterPropsList;
	import com.msg.item.SDelEquip;
	import com.msg.item.SDelProps;
	import com.msg.item.SModifyEquipBinding;
	import com.msg.item.SModifyPropsBinding;
	import com.msg.item.SModifyPropsQuantity;
	import com.msg.open_cell.CGetOLOpenCellReq;
	import com.msg.open_cell.CGetOpenCellInfoReq;
	import com.msg.open_cell.CRefreshTimeReq;
	import com.msg.open_cell.SGetOLOpenCellRsp;
	import com.msg.open_cell.SGetOpenCellInfoRsp;
	import com.msg.open_cell.SRefreshTimeRsp;
	import com.msg.storage.CExpandStorageReq;
	import com.msg.storage.CGetBodyInfReq;
	import com.msg.storage.CGetDepotInfReq;
	import com.msg.storage.CGetPackInfReq;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromDepotReq;
	import com.msg.storage.CRemoveFromPackReq;
	import com.msg.storage.CRepairEquipReq;
	import com.msg.storage.CSellItemReq;
	import com.msg.storage.CSortDepotReq;
	import com.msg.storage.CSortPackReq;
	import com.msg.storage.CSplitItemReq;
	import com.msg.storage.SDepot;
	import com.msg.storage.SExpandStorageRsp;
	import com.msg.storage.SMoveItemRsp;
	import com.msg.storage.SPack;
	import com.msg.storage.SPutToBodyRsp;
	import com.msg.storage.SRemoveFromDepotRsp;
	import com.msg.storage.SRemoveFromPackRsp;
	import com.msg.storage.SSetDepotGridNum;
	import com.msg.storage.SSetPackGridNum;
	import com.msg.storage.SSortDepotRsp;
	import com.msg.storage.SSortPackRsp;
	import com.msg.storage.SSplitItemRsp;
	import com.net.MsgPool;
	import com.net.NetManager;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	public class BagModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _bagWindow:BagWindow;
		
		private var _isSort:Boolean=false;
		private var _isFirst:Boolean=true;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_bagWindow=new BagWindow();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			addEvents();
			addSocketCallback();
		}
		
		public function getBagWin():BagWindow
		{
			return _bagWindow;
		}
		
		//======================================================================
		//        private function
		//======================================================================
		/***************客户端处理消息***************/
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);// 请求背包,仓库,道具列表，装备列表，时间开启背包
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagUIClick,onBagUIClick);//打开界面
//			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CExpandStorageReq,onSendSocket);//扩展包裹：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CPutToBodyReq,onSendSocket);//给角色身上装备物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRemoveFromPackReq,onSendSocket);//从背包指定位置移除一个物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRemoveFromDepotReq,onSendSocket);//从仓库指定位置移除一个物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CMoveItemReq,onSendSocket);//移动物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSellItemReq,onSendSocket);//出售物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRepairEquipReq,onSendSocket);//装备修理
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSplitItemReq,onSendSocket);//拆分物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSortPackReq,onSendSocket);//背包整理：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSortDepotReq,onSendSocket);//仓库整理：请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.USE_ITEM,onSendSocket);//使用道具、装备
			
			//商店事件
			YFEventCenter.Instance.addEventListener(GlobalEvent.USER_SHOP_MODE,userSell);//监听从商店发出时的出售
//			YFEventCenter.Instance.addEventListener(GlobalEvent.USER_FIX_CLICK,userMend);//部分修理
			//钱的刷新
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,moneyChange);
			//交易事件
			YFEventCenter.Instance.addEventListener(GlobalEvent.LockItem,lockItem);//上锁
			YFEventCenter.Instance.addEventListener(GlobalEvent.UnlockItem,unLockItem);//交易、寄售解锁
			YFEventCenter.Instance.addEventListener(BagEvent.MOVE_TO_TRADE,moveToTrade);//移动到交易
			YFEventCenter.Instance.addEventListener(BagEvent.MOVE_TO_BAG_SUCC,moveToBagSucc);//从交易成功移动到背包解锁
			//人物转职成功（要再刷新下背包，使得一些装备可不可用的状态改变\以及时间开启背包格子）
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,heroCareerChange);
			//删除过期道具、装备
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_CDelItemReq,delAgedItem);
			//装备进阶成功后刷新背包
			YFEventCenter.Instance.addEventListener(GlobalEvent.EQUIP_LEVEL_UP,updateOneGrid);
			//翅膀进化成功后刷新对应的格子
			YFEventCenter.Instance.addEventListener(WingEvent.WingLvUpBagUpdate,updateOneGrid);
			
			//新手引导
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagPackOpenForOpenNewPack,onGuideOpenBag);
			
			//人物升级
//			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLvUp);
		}
		/**引导打开背包面板
		 */		
		private function onGuideOpenBag(e:YFEvent):void
		{
			NewGuideStep.BagPackGuideStep=NewGuideStep.BagPackMainUIBtn;
			NewGuideManager.DoGuide();
		}
		
		/**新手引导 的 movie
		 */
		//处理背包打开的新手引导
		private function onNewGuideEvent(e:YFEvent=null):void
		{
			if(!_bagWindow.isOpen)
			{
				_bagWindow.open();
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
				{
					if(NewGuideStep.BagPackGuideStep==NewGuideStep.BagPackOpen)
					{
//						var starGrid:int=101;//背包格子从 101 开始
//						var itemDyVo:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(starGrid); //获取背包0 号位置的道具
						// 获取新手礼包在背包的位置
						var itemDyVo:ItemDyVo=BagStoreManager.instantce.findFirstLibaoItem(1);  //在背包中查找等级为1 的新手礼包
						var starGrid:int;
						if(itemDyVo)
						{
							starGrid=itemDyVo.pos;
							// 如果所接的任务为装备升级任务
							var taskTagetBasicVo:Task_targetBasicVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo();
							if(taskTagetBasicVo)
							{
								if(taskTagetBasicVo.seach_type==TypeProps.TaskTargetType_OpenNewPack)  //当前 主线任务为装备升级时 进行处理  
								{
									var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(itemDyVo.id);
									if(taskTagetBasicVo.seach_id==propsDyVo.templateId) //如果 为 该物品 进行显示
									{
										var moveGrid:MoveGrid=_bagWindow.getBagMoveGrid(starGrid);
										if(moveGrid)
										{
											//											NewGuideMovieClipWidthArrow.Instance.addToContainer(moveGrid);
											//											NewGuideMovieClipWidthArrow.Instance.initRect(-1,-1,46,46,NewGuideMovieClipWidthArrow.ArrowDirection_Right);
											var gridGlobalePt:Point=UIPositionUtil.getUIRootPosition(moveGrid);
											NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(gridGlobalePt.x,gridGlobalePt.y,45,45,NewGuideMovieClipWidthArrow.ArrowDirection_Right,moveGrid);
											return ;
										}
									}
								}
							}
						}
						//如果 不满足条件  则 取消引导 重置引导步骤
						NewGuideMovieClipWidthArrow.Instance.hide();
						NewGuideStep.BagPackGuideStep=-1;
						
						////发送完成任务事件
						var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskVo();
						//模拟对话任务进行完成
						NewGuideTaskManager.Instance.sendEvent(taskDyVo.taskID);
					}
				}
			}
		}
		
		
		private function onBagUIClick(e:YFEvent):void
		{
			if(!_bagWindow.isOpen)
			{
				onNewGuideEvent(); //打开i啊背包
			}
			else  //关闭背包
			{
				_bagWindow.switchOpenClose();
				
			}
		}

		
		/***************服务器发送的消息***************/
		private function addSocketCallback():void
		{
			///背包信息
			NetManager.gameSocket.addCallback(GameCmd.SPack,SPack,onStoragePack);
			///仓库信息
			NetManager.gameSocket.addCallback(GameCmd.SDepot,SDepot,onStorageDepot);
			///背包格子数
			NetManager.gameSocket.addCallback(GameCmd.SSetPackGridNum,SSetPackGridNum,onSetPackGridNum);
			///仓库格子数
			NetManager.gameSocket.addCallback(GameCmd.SSetDepotGridNum,SSetDepotGridNum,onSetDepotGridNum);
			///道具列表
			NetManager.gameSocket.addCallback(GameCmd.SCharacterPropsList,SCharacterPropsList,onCharacterPropsList);
			///装备列表
			NetManager.gameSocket.addCallback(GameCmd.SCharacterEquipList,SCharacterEquipList,onCharacterEquipList);
			///给角色身上装备物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SPutToBodyRsp,SPutToBodyRsp,onPutToBodyRsp);
			///在背包指定位置移除一个物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SRemoveFromPackRsp,SRemoveFromPackRsp,onRemoveFromPackRsp);
			///在仓库指定位置移除一个物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SRemoveFromDepotRsp,SRemoveFromDepotRsp,onRemoveFromDepotRsp);
			///移动物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SMoveItemRsp,SMoveItemRsp,onMoveItemRsp);
			///拆分物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SSplitItemRsp,SSplitItemRsp,onSplitItemRsp);
			///背包整理：响应
			NetManager.gameSocket.addCallback(GameCmd.SSortPackRsp,SSortPackRsp,onSortPackRsp);
			///仓库整理：响应
			NetManager.gameSocket.addCallback(GameCmd.SSortDepotRsp,SSortDepotRsp,onSortDepotRsp);
			///扩展包裹：响应
			NetManager.gameSocket.addCallback(GameCmd.SExpandStorageRsp,SExpandStorageRsp,onExpandStorageRsp);
			///改变道具数量
			NetManager.gameSocket.addCallback(GameCmd.SModifyPropsQuantity,SModifyPropsQuantity,onModifyPropsQuantity);
			
			///使用道具回复
			NetManager.gameSocket.addCallback(GameCmd.SUseItem,SUseItem,onUseItem);
			///批量使用道具回复
			MsgPool.addCallBack(GameCmd.SUseMultiItems,SUseMultiItems,useItemMoreResp);
			
			///删除道具
			MsgPool.addCallBack(GameCmd.SDelProps,SDelProps,delProps);
			///删除装备
			MsgPool.addCallBack(GameCmd.SDelEquip,SDelEquip,delEquip);
			
			///改变装备绑定性
			MsgPool.addCallBack(GameCmd.SModifyEquipBinding,SModifyEquipBinding,onModifyEquipBinding);
			///改变道具绑定性
			MsgPool.addCallBack(GameCmd.SModifyPropsBinding,SModifyPropsBinding,onModifyPropsBinding);
						
			/****************************背包时间开启事件************************/
			//返回开启格子信息
			MsgPool.addCallBack(GameCmd.SGetOpenCellInfoRsp,SGetOpenCellInfoRsp,getOpenCellInfoRsp);
			//刷新用户的在线时间响应
			MsgPool.addCallBack(GameCmd.SRefreshTimeRsp,SRefreshTimeRsp,refreshTimeRsp);
			//返回开启格子
			MsgPool.addCallBack(GameCmd.SGetOLOpenCellRsp,SGetOLOpenCellRsp,getOnlineCellRep);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onGameIn(e:YFEvent):void
		{
			onlineOpenBagGridReq();
			
			var propsMsg:CGetCharPropsListReq=new CGetCharPropsListReq();
			propsMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetCharPropsListReq,propsMsg);
			
			var equipMsg:CGetCharEquipListReq=new CGetCharEquipListReq();
			equipMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetCharEquipListReq,equipMsg);
			
			// 请求人物身上的 装备信息
			var cGetBodyInfReq:CGetBodyInfReq=new CGetBodyInfReq();
			MsgPool.sendGameMsg(GameCmd.CGetBodyInfReq,cGetBodyInfReq);
			
			var bagMsg:CGetPackInfReq=new CGetPackInfReq();
			bagMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetPackInfReq,bagMsg);
			
			var storeMsg:CGetDepotInfReq=new CGetDepotInfReq();
			storeMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetDepotInfReq,storeMsg);
							
		}
		
		/** 扩展仓库背包格子数 */		
		public function expandSorageReq(type:int):void
		{
			var msg:CExpandStorageReq=new CExpandStorageReq();
			msg.stType=type;
			MsgPool.sendGameMsg(GameCmd.CExpandStorageReq,msg);
		}
		
		
		/**发送消息给服务端
		 * 
		 */		
		private function onSendSocket(e:YFEvent):void
		{		
			//print(this,"进入游戏。。。");
			switch(e.type)
			{
//				case BagEvent.BAG_UI_CExpandStorageReq:
//					MsgPool.sendGameMsg(GameCmd.CExpandStorageReq,e.param as CExpandStorageReq);
//					break;
				case BagEvent.BAG_UI_CPutToBodyReq:
					MsgPool.sendGameMsg(GameCmd.CPutToBodyReq,e.param as CPutToBodyReq);
					break;
				case BagEvent.BAG_UI_CRemoveFromPackReq:
					MsgPool.sendGameMsg(GameCmd.CRemoveFromPackReq,e.param as CRemoveFromPackReq);
					break;
				case BagEvent.BAG_UI_CRemoveFromDepotReq:
					MsgPool.sendGameMsg(GameCmd.CRemoveFromDepotReq,e.param as CRemoveFromDepotReq);
					break;
				case BagEvent.BAG_UI_CMoveItemReq:
					var type:int=(e.param as CMoveItemReq).movDirect;
					switch(type)
					{
						case TypeProps.MOV_DIRECT_PACK_TO_PACK:
							if(_bagWindow.getPackTabIndex() == BagSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_PACK_TO_DEPOT:
							if(BagSource.openStore && _bagWindow.getPackTabIndex() != BagSource.TAB_MISSION 
								&& _bagWindow.getDepotTabIndex() == BagSource.TAB_ALL )
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_PACK_TO_BODY:
							MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							break;
						case TypeProps.MOV_DIRECT_DEPOT_TO_DEPOT:
							if(_bagWindow.getDepotTabIndex() == BagSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_DEPOT_TO_PACK:
							if(_bagWindow.isOpen && _bagWindow.getPackTabIndex() == BagSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_BODY_TO_PACK:
							if(_bagWindow.getPackTabIndex() == BagSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
					}
					
					break;
				case BagEvent.BAG_UI_CSellItemReq:
					MsgPool.sendGameMsg(GameCmd.CSellItemReq,e.param as CSellItemReq);
					break;
				case BagEvent.BAG_UI_CSplitItemReq:
					MsgPool.sendGameMsg(GameCmd.CSplitItemReq,e.param as CSplitItemReq);
					break;
				case BagEvent.BAG_UI_CSortPackReq:
					MsgPool.sendGameMsg(GameCmd.CSortPackReq,e.param as CSortPackReq);
					_isSort=true;
					break;
				case BagEvent.BAG_UI_CSortDepotReq:
					MsgPool.sendGameMsg(GameCmd.CSortDepotReq,e.param as CSortDepotReq);
					break;
				case GlobalEvent.USE_ITEM:
					MsgPool.sendGameMsg(GameCmd.CUseItem,e.param as CUseItem);
					break;
				case BagEvent.BAG_UI_CRepairEquipReq:
					var msg:CRepairEquipReq=new CRepairEquipReq();
					msg.pos=[e.param as int];
					MsgPool.sendGameMsg(GameCmd.CRepairEquipReq,msg);
					break;
			}
		}
		
		private function onStoragePack(msg:SPack):void
		{
			if(msg)
			{
				if(msg.hasClearAll)
				{
					_bagWindow.clearAll=true;
				}
				else
				{
					_bagWindow.clearAll=false;
				}	
				BagStoreManager.instantce.setPackList(msg.cell,_bagWindow.clearAll);
				BagStoreManager.instantce.setNewPackCells(msg.cell);
				if(_bagWindow.isOpen)
					_bagWindow.onPackTabChange();
				
				//检查背包是否已满
				if(BagStoreManager.instantce.getAllPackArray().length == BagStoreManager.instantce.getPackNum())
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagFull,true);
				
				
				if(_isSort == false)
				{
					var newItems:Array=BagStoreManager.instantce.newPackCells;
					if(newItems.length != 2)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
						if(_isFirst == false)
						{
							var bsId:int;
							var name:String;
							var quality:int;
							for each(var item:ItemDyVo in newItems)
							{
								if(item.type == TypeProps.ITEM_TYPE_EQUIP)
								{
									bsId=EquipDyManager.instance.getEquipInfo(item.id).template_id;
									var pos:int=EquipDyManager.instance.getEquipPosFromRole(item.id);
									if(EquipDyManager.instance.getEquipPosFromRole(item.id) == 0)
									{
										name=EquipBasicManager.Instance.getEquipBasicVo(bsId).name;
										quality = EquipBasicManager.Instance.getEquipBasicVo(bsId).quality;
										NoticeManager.setNotice(NoticeType.Notice_id_301,-1,NoticeUtils.setColorText(name,quality));
									}
								}
								else if(item.type == TypeProps.ITEM_TYPE_PROPS)
								{
									bsId=PropsDyManager.instance.getPropsInfo(item.id).templateId;
									name=PropsBasicManager.Instance.getPropsBasicVo(bsId).name;
									quality = PropsBasicManager.Instance.getPropsBasicVo(bsId).quality;
									NoticeManager.setNotice(NoticeType.Notice_id_300,-1,NoticeUtils.setColorText(name,quality),
										PropsDyManager.instance.getPropsInfo(item.id).quantity);
								}
							}
						}
					}					
				}
				
				//新手引导
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level < NewGuideManager.MaxGuideLevel)
				{
					var newGuideUseItemWin:NewGuideUseItemWindow//注意这里直接向服务器发送事件了
					var items:Array=BagStoreManager.instantce.newPackCells;
					for each(item in items)
					{
						if(NewGuideUseItemWindow.getMyInstance(item.type,item.id) == false && 
							BagStoreManager.instantce.checkCanShowNewGuide(item))
						{
							newGuideUseItemWin=new NewGuideUseItemWindow();
							newGuideUseItemWin.init(item);
						}
					}
				}
				
				_isFirst=false;//希望第一次初始化时不要提示用户一些信息
			}
		}
		
		private function onStorageDepot(msg:SDepot):void
		{
			if(msg)
			{
				if(msg.hasClearAll)
				{
					_bagWindow.setDepotClearAll(true);
				}
				else
				{
					_bagWindow.setDepotClearAll(false);
				}
				BagStoreManager.instantce.setDepotList(msg.cell,_bagWindow.getDepotClearAll());
				BagStoreManager.instantce.setNewDepotCells(msg.cell);
				_bagWindow.setDepotContent();
			}
		}
		private function onSetPackGridNum(msg:SSetPackGridNum):void
		{
			BagStoreManager.instantce.setPackNum(msg.packNum);
			_bagWindow.setPackGridNum();
		}
		
		private function onSetDepotGridNum(msg:SSetDepotGridNum):void
		{
			BagStoreManager.instantce.setDepotNum(msg.depotNum);
			_bagWindow.setDepotGridNum();
		}
		
		private function onCharacterPropsList(msg:SCharacterPropsList):void
		{
			if(msg)
				PropsDyManager.instance.setPropsList(msg.props);
		}
		
		private function onCharacterEquipList(msg:SCharacterEquipList):void
		{
			if(msg)
				EquipDyManager.instance.setEquipInfo(msg.equip);
		}
		
		private function onModifyPropsQuantity(msg:SModifyPropsQuantity):void
		{
			if(msg)
			{
				var dyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(msg.propsId);
				var vo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(dyVo.templateId);
				var num:int=dyVo.quantity-msg.quantity;//已有数量-改变后的数量=改变了几个数量；
				if(num < 0)//得到
					NoticeManager.setNotice(NoticeType.Notice_id_300,-1,NoticeUtils.setColorText(vo.name,vo.quality),-num);
				else if(num >0)//失去
					NoticeManager.setNotice(NoticeType.Notice_id_303,-1,NoticeUtils.setColorText(vo.name,vo.quality),num);
				
				PropsDyManager.instance.motifyPropsNum(msg.propsId,msg.quantity);
				if(MarketSource.ConsignmentStatus || TradeDyManager.isTrading)
				{
					_bagWindow.lockMode();
				}
				_bagWindow.changePropsNum(msg.propsId);
				
				if(_isSort == false)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
							
			}
		}
		
		private function onUseItem(msg:SUseItem):void
		{
			if(msg.code == TypeProps.RSPMSG_SUCCESS)
			{
				_bagWindow.useItemResp(msg);
				
				var type:int=PropsBasicManager.Instance.getPropsBasicVo(msg.itemTemplateId).type;
				if(type == TypeProps.PROPS_TYPE_HP_DRUG || type == TypeProps.PROPS_TYPE_MP_DRUG)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagDrugUseItemResp,msg.itemTemplateId);
				else if(type == TypeProps.PROPS_TYPE_PET_FEED)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUseItemResp,msg.itemTemplateId);
				
				if(type==TypeProps.PROPS_TYPE_GIFTPACKS)  //为礼包 
				{
					// 如果所接的任务为装备升级任务
					var taskTagetBasicVo:Task_targetBasicVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo();
					if(taskTagetBasicVo)
					{
						if(taskTagetBasicVo.seach_id==msg.itemTemplateId)  //目标为使用目标  客户端模拟  使用礼包任务 通过对话任务完成
						{
							//引导关闭  窗口
							NewGuideStep.BagPackGuideStep=NewGuideStep.BagPackCloseBagWindow;
							//						bagWindow.handleGuideCloseBag();  //内部处理引导  getNewGuideVo方法
							
							var taskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskVo();
							//模拟对话任务进行完成
							NewGuideTaskManager.Instance.sendEvent(taskDyVo.taskID);
						}
					}
				}
			}
			else if (msg.code == TypeProps.RSPMSG_PACK_FULL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_320);
		}
		
		private function delProps(msg:SDelProps):void
		{
			var dyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(msg.propsId);
			var vo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(dyVo.templateId);
			
			NoticeManager.setNotice(NoticeType.Notice_id_303,-1,NoticeUtils.setColorText(vo.name,vo.quality),dyVo.quantity);

			_bagWindow.delGrid(TypeProps.ITEM_TYPE_PROPS,msg.propsId);
			PropsDyManager.instance.delProps(msg.propsId);
			BagTimerManager.instance.deleteTimer(TypeProps.ITEM_TYPE_PROPS,msg.propsId);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			
			//取消背包已满的提示
			if(BagStoreManager.instantce.getAllPackArray().length <= BagStoreManager.instantce.getPackNum())
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagFull,false);
			
		}
		
		private function delEquip(msg:SDelEquip):void
		{
			var dyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(msg.equipId);
			var vo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
			NoticeManager.setNotice(NoticeType.Notice_id_304,-1,NoticeUtils.setColorText(vo.name,vo.quality));
			
			var pos:int=EquipDyManager.instance.getEquipPosFromBag(msg.equipId);
			if(pos == 0)
			{
				pos=EquipDyManager.instance.getEquipPosFromDepot(msg.equipId);
				if(pos == 0)
					pos = EquipDyManager.instance.getEquipPosFromRole(msg.equipId);
			}
			if(pos > 0)
			{
				if(pos < 101)
				{
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DelBodyGrid,pos);
				}
				else
				{
					_bagWindow.delGrid(TypeProps.ITEM_TYPE_EQUIP,msg.equipId);//背包和仓库中的删除
				}
				EquipDyManager.instance.delEquip(msg.equipId);
			}		
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			BagTimerManager.instance.deleteTimer(TypeProps.ITEM_TYPE_EQUIP,msg.equipId);
			
			//取消背包已满的提示
			if(BagStoreManager.instantce.getAllPackArray().length <= BagStoreManager.instantce.getPackNum())
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagFull,false);
		}
		
		private function onPutToBodyRsp(msg:SPutToBodyRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_321);
		}
		
		private function onRemoveFromPackRsp(msg:SRemoveFromPackRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_322);
		}
		
		private function onRemoveFromDepotRsp(msg:SRemoveFromDepotRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_333);
		}
		
		private function onMoveItemRsp(msg:SMoveItemRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_323);
		}
		
		private function onSplitItemRsp(msg:SSplitItemRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_324);
		}
		
		private function onSortPackRsp(msg:SSortPackRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_325);
			_isSort=false;
		}
		
		private function onSortDepotRsp(msg:SSortDepotRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_326);
		}
		
		private function onExpandStorageRsp(msg:SExpandStorageRsp):void
		{
			if(msg.rsp == TypeProps.RSPMSG_USEITEM_FAILED)
				NoticeManager.setNotice(NoticeType.Notice_id_327);
		}	
		
		/**
		 * 商店出售模式 
		 */		
		private function userSell(e:YFEvent):void
		{
			_bagWindow.shopModeChange(e.param as int);
		}
		
//		private function userMend(e:YFEvent):void
//		{
//			bagWindow.mendMode(e.param as Boolean);
//		}
		
		/**
		 * 刷新钱 
		 */		
		private function moneyChange(e:YFEvent):void
		{
			_bagWindow.updateMoney();
		}
		
		//交易
		private function lockItem(e:YFEvent):void
		{
			if(_bagWindow.isOpen)
				_bagWindow.lockMode();
			_bagWindow.setGridLockStatus(e.param as int,true);
		}
		
		private function unLockItem(e:YFEvent):void
		{
			if(_bagWindow.isOpen)
				_bagWindow.lockMode();
			_bagWindow.setGridLockStatus(e.param as int,false);
		}
		
		private function moveToTrade(e:YFEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoveToTrade,e.param);
		}
		
		private function moveToBagSucc(e:YFEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoveToBagSuccess,e.param);
		}
		
		//人物转职成功
		private function heroCareerChange(e:YFEvent):void
		{
			_bagWindow.updatePackEquips(true);
			onlineOpenBagGridReq();
		}
		
		private function delAgedItem(e:YFEvent):void
		{
			var msg:CDelPropsReq=new CDelPropsReq();
			msg.pos=e.param as int;
			MsgPool.sendGameMsg(GameCmd.CDelPropsReq,msg);
		}
		
		private function onModifyEquipBinding(msg:SModifyEquipBinding):void
		{
			var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(msg.equipId);
			equipDyVo.binding_type=msg.bindingAttr;
			_bagWindow.changePropsEquipBound(TypeProps.ITEM_TYPE_EQUIP,msg.equipId);
		}
		
		private function onModifyPropsBinding(msg:SModifyPropsBinding):void
		{
			var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(msg.propsId);
			propsDyVo.binding_type=msg.bindingAttr;
			_bagWindow.changePropsEquipBound(TypeProps.ITEM_TYPE_PROPS,msg.propsId);
		}
		
		private function updateOneGrid(e:YFEvent):void
		{
			var pos:int=e.param as int;
			if(pos >= BagSource.BAG_OFFSET && _bagWindow.isOpen)
			{
				var item:ItemDyVo=BagStoreManager.instantce.getPackInfoByPos(pos);
				BagStoreManager.instantce.newPackCells=[item];
				_bagWindow.clearAll=false;
				_bagWindow.onPackTabChange();
			}			
		}
		
		/** 批量使用 */
		public function useItemMoreReq(pos:int,number:int):void
		{
			var msg:CUseMultiItems=new CUseMultiItems();
			msg.itemPos=pos;
			msg.itemNumber=number;
			MsgPool.sendGameMsg(GameCmd.CUseMultiItems,msg);
		}
		
		private function useItemMoreResp(msg:SUseMultiItems):void
		{
			if(msg.successNumber == 0)
				NoticeUtil.setOperatorNotice('无法批量使用');
		}
		
		/*********************************时间开启格子**********************************/
		/** 超过30级才请求时间开启 */
		private function onlineOpenBagGridReq():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= 30)
			{
				var timeMsg:CGetOpenCellInfoReq=new CGetOpenCellInfoReq();//上线请求开启格子信息
				MsgPool.sendGameMsg(GameCmd.CGetOpenCellInfoReq,timeMsg);
			}
		}
		
		/** 返回开启格子信息 */
		private function getOpenCellInfoRsp(msg:SGetOpenCellInfoRsp):void
		{
			OpenBagGridManager.openGridId=msg.id;
			OpenBagGridManager.serverTime=msg.oltime;
//			trace("第一步，即将初始化cd")
			OpenBagGridManager.instance.initCd();
			OpenBagGridManager.instance.updateTime(updateTimeReq);
			
		}
		
		/** 服务器第一次返回时间后，每隔五分钟向服务器请求校准时间 */
		private function updateTimeReq(e:TimerEvent):void
		{
			var msg:CRefreshTimeReq=new CRefreshTimeReq();
			MsgPool.sendGameMsg(GameCmd.CRefreshTimeReq,msg);
		}
		
		/** 刷新用户的在线时间响应 */
		private function refreshTimeRsp(msg:SRefreshTimeRsp):void
		{
			OpenBagGridManager.serverTotalTime = msg.oltime;
		}
		
		/** 请求开启格子 */
		public function openOnlineGridReq(id:int):void
		{
			var msg:CGetOLOpenCellReq=new CGetOLOpenCellReq();
			msg.id=id;
			MsgPool.sendGameMsg(GameCmd.CGetOLOpenCellReq,msg);
//			trace("第四步，请求开格子")
		}
		
		/** 返回开启格子 */
		private function getOnlineCellRep(msg:SGetOLOpenCellRsp):void
		{
			OpenBagGridManager.openGridId=msg.id;
			OpenBagGridManager.serverTime=msg.oltime;//每次开启后，时间重新计算
//			trace("第五步：即将初始化cd")
			OpenBagGridManager.instance.initCd();
			if(msg.rsp == TypeProps.RSPMSG_FAIL)
			{
//				trace(msg.id,"开格子失败！")
				_bagWindow.playCloseGridCd();
			}
//			else
				trace(msg.id,"开格子成功！")
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 