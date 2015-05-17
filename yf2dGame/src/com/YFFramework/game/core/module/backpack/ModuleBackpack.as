package com.YFFramework.game.core.module.backpack
{
	/** 
	 *  背包模块  2012-7-5
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.GoodsDyManager;
	import com.YFFramework.game.core.global.model.GoodsDyVo;
	import com.YFFramework.game.core.global.model.GoodsUtil;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.core.module.backpack.model.BackpackListVo;
	import com.YFFramework.game.core.module.backpack.model.CMDBackpack;
	import com.YFFramework.game.core.module.backpack.model.DeleteGoodsVo;
	import com.YFFramework.game.core.module.backpack.model.MoneyChangeResultVo;
	import com.YFFramework.game.core.module.backpack.model.SimpleMoveGoodsResultVo;
	import com.YFFramework.game.core.module.backpack.model.SimpleMoveGoodsVo;
	import com.YFFramework.game.core.module.backpack.model.UseGoodsResultVo;
	import com.YFFramework.game.core.module.backpack.model.UseGoodsVo;
	import com.YFFramework.game.core.module.backpack.view.BackPackWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModuleBackpack extends AbsModule
	{
		/**背包ui实例
		 */
		private var _backPackWindow:BackPackWindow;
		public function ModuleBackpack()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function show():void
		{
			_backPackWindow=new BackPackWindow();
			addEvents();
		}
		private function addEvents():void
		{
			////////////////////socket 发送
			///请求背包列表 
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSendSocket);// 背包按钮单击响应 

			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BackPackUIClick,onBackPackToggle);// 背包按钮单击响应 
			///  背包内 物品发生移动
			YFEventCenter.Instance.addEventListener(BackpackEvent.C_SimpleMoveGoods,onSendSocket);
			//删除背包物品
			YFEventCenter.Instance.addEventListener(BackpackEvent.C_DeleteGoods,onSendSocket);
			///背包使用物品
			YFEventCenter.Instance.addEventListener(BackpackEvent.C_UseGoods,onSendSocket);
			
			
			
			///////////////////sockeet  返回
			///服务端返回背包列表
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_RequestBackpackList,onSocketEvent);
			//// 服务端返回背包物品的拖动
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_SimpleMoveGoods,onSocketEvent);
			///服务端返回物品删除
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_DeleteGoods,onSocketEvent);
			///服务端返回 使用物品
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_UseGoods,onSocketEvent);
			///增加钱数
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_AddMoney,onSocketEvent);
			///删除钱数
			YFEventCenter.Instance.addEventListener(BackpackEvent.S_DelMoney,onSocketEvent);
		}
		
		
		/**
		 *单击背包按钮  响应  进行背包 弹出与关闭的切换  
		 */		
		private function onBackPackToggle(e:YFEvent):void
		{
			_backPackWindow.toggle();
		}

		/**发送消息给服务端
		 * 
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.GameIn:  ///请求背包列表
					YFSocket.Instance.sendMessage(CMDBackpack.C_RequestBackpackList);
					break;
				case BackpackEvent.C_SimpleMoveGoods:
					//背包内发生物品拖动
					var simpleMoveGoodsVo:SimpleMoveGoodsVo=e.param as SimpleMoveGoodsVo;
			//		msg.cmd=CMDBackpack.C_SimpleMoveGoods;
				//	msg.info=simpleMoveGoodsVo;
					YFSocket.Instance.sendMessage(CMDBackpack.C_SimpleMoveGoods,simpleMoveGoodsVo);
					break;
				case BackpackEvent.C_DeleteGoods:
					var deleteGoodsVo:DeleteGoodsVo=e.param as DeleteGoodsVo;
//					msg.cmd=CMDBackpack.C_DeleteGoods;
//					msg.info=deleteGoodsVo;
					YFSocket.Instance.sendMessage(CMDBackpack.C_DeleteGoods,deleteGoodsVo);
					break;
				case BackpackEvent.C_UseGoods:
					/// 客户端使用物品
					var useGoodsVo:UseGoodsVo=e.param as UseGoodsVo;
				//	msg.cmd=CMDBackpack.C_UseGoods;
				//	msg.info=useGoodsVo;
					YFSocket.Instance.sendMessage(CMDBackpack.C_UseGoods,useGoodsVo);
					break;
					
			}
		}

		
		
		/**接受服务端返回的信息
		 * 
		 */		
		private function onSocketEvent(e:YFEvent):void
		{
			var goodsDyVo:GoodsDyVo;
			switch(e.type)
			{
				///服务端返回背包列表
				case BackpackEvent.S_RequestBackpackList:
					///更新数据
					var backpackListVo:BackpackListVo=e.param as BackpackListVo;
					DataCenter.Instance.roleSelfVo.updateGold(backpackListVo.gold);  
					DataCenter.Instance.roleSelfVo.updateYuanBao(backpackListVo.yuanBao);
					///更新钱币
					_backPackWindow.updateGold();
					_backPackWindow.updateYuanBao();
					GoodsDyManager.Instance.updateBackpackList(backpackListVo.list);
					////更新背包容量 
					GoodsDyManager.Instance.backpackManager.size=backpackListVo.size;
					///更新物品图标视图
					_backPackWindow.updateGoodsList();
					///更新 格子视图
					_backPackWindow.updateGridsTotalNum();
					break;
				case BackpackEvent.S_SimpleMoveGoods:
					///服务端返回背包物品的拖动
					var simpleMoveGoodsResult:SimpleMoveGoodsResultVo=e.param as SimpleMoveGoodsResultVo;
					///更新数据 
					if(simpleMoveGoodsResult.toGridDyId)  ///如果该格子的物品存在   交换物品格子
					{  ///交换物品格子 
						GoodsDyManager.Instance.backpackManager.exchangeGridNum(simpleMoveGoodsResult.movingDyId,simpleMoveGoodsResult.movingGridNum,simpleMoveGoodsResult.toGridDyId,simpleMoveGoodsResult.toGridGridNum);
					}
					else  ///单纯更新拖动的物品格子
					{
						///更新新的格子位置
						GoodsDyManager.Instance.backpackManager.updateGridNum(simpleMoveGoodsResult.movingDyId,simpleMoveGoodsResult.movingGridNum);
					}
					_backPackWindow.updateSimpleGoodsMove(simpleMoveGoodsResult);
					break;
				case BackpackEvent.S_DeleteGoods: ///物品删除成功后返回  不成功 则服务端不必进行返回
					var deleteGoodsVo:DeleteGoodsVo=e.param as DeleteGoodsVo;
					///删除背包物品
					GoodsDyManager.Instance.delBackpack(deleteGoodsVo.dyId);
					///更新视图
					_backPackWindow.updateDeleteGoods(deleteGoodsVo.dyId);
					break;
				case BackpackEvent.S_UseGoods:///客户端返回使用物品
					var useGoodsResultVo:UseGoodsResultVo=e.param as UseGoodsResultVo;
					///物品使用    并且播放CD 
					_backPackWindow.updateUseGoodsView(useGoodsResultVo);
					break;
				case BackpackEvent.S_AddMoney:
					///添加钱数
					var addMoneyVo:MoneyChangeResultVo=e.param as MoneyChangeResultVo;
					if(addMoneyVo.type==GoodsUtil.Money_Gold)  //金币
					{
						DataCenter.Instance.roleSelfVo.updateGold(addMoneyVo.money);
						_backPackWindow.updateGold();
						print(this,"增加"+addMoneyVo.change+"金币");
					}
					else if(addMoneyVo.type==GoodsUtil.Money_YuanBao) //元宝
					{
						DataCenter.Instance.roleSelfVo.updateYuanBao(addMoneyVo.money);
						_backPackWindow.updateYuanBao();
						print(this,"增加"+addMoneyVo.change+"元宝");
					}
					break;
				case BackpackEvent.S_DelMoney:
					///删除钱数
					var delMoneyVo:MoneyChangeResultVo=e.param as MoneyChangeResultVo;
					if(delMoneyVo.type==GoodsUtil.Money_Gold)  //金币
					{
						DataCenter.Instance.roleSelfVo.updateGold(delMoneyVo.money);
						_backPackWindow.updateGold();
						print(this,"用掉"+delMoneyVo.change+"金币");
					}
					else if(delMoneyVo.type==GoodsUtil.Money_YuanBao) //元宝
					{
						DataCenter.Instance.roleSelfVo.updateYuanBao(delMoneyVo.money);
						_backPackWindow.updateYuanBao();
						print(this,"用掉"+delMoneyVo.change+"元宝");
					}
					break;
			}
		}
		
		
		
	}
}