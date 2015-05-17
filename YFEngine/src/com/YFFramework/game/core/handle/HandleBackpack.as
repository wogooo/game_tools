package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.core.module.backpack.model.BackpackListVo;
	import com.YFFramework.game.core.module.backpack.model.CMDBackpack;
	import com.YFFramework.game.core.module.backpack.model.DeleteGoodsVo;
	import com.YFFramework.game.core.module.backpack.model.MoneyChangeResultVo;
	import com.YFFramework.game.core.module.backpack.model.SimpleMoveGoodsResultVo;
	import com.YFFramework.game.core.module.backpack.model.UseGoodsResultVo;
	
	/**背包通讯200-299
	 * 2012-8-17 上午10:56:27
	 *@author yefeng
	 */
	public class HandleBackpack extends AbsHandle
	{
		public function HandleBackpack()
		{
			super();
			_minCMD=200;
			_maxCMD=299;
		}
		/** 处理背包通讯
		 * @param msg    message类  的oBject 
		 * @return   
		 */		
		override public function socketHandle(msg:Object):Boolean
		{
			var info:Object=msg.info;
			var obj:Object;
			switch(msg.cmd)
			{
				case CMDBackpack.S_RequestBackpackList:
						///服务端返回背包列表
					var  backpackListVo:BackpackListVo=new BackpackListVo();
					backpackListVo.size=info.size;
					backpackListVo.list=info.list;
					backpackListVo.gold=info.gold;
					backpackListVo.yuanBao=info.yuanBao;
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_RequestBackpackList,backpackListVo);
					return true;
					break;
				case CMDBackpack.S_SimpleMoveGoods:
					//服务端返回背包内物品的移动
					var simpleMoveGoodsResultVo:SimpleMoveGoodsResultVo=new SimpleMoveGoodsResultVo();
					simpleMoveGoodsResultVo.movingDyId=info.movingDyId;
					simpleMoveGoodsResultVo.movingGridNum=info.movingGridNum;
					simpleMoveGoodsResultVo.toGridDyId=info.toGridDyId;
					simpleMoveGoodsResultVo.toGridGridNum=info.toGridGridNum;
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_SimpleMoveGoods,simpleMoveGoodsResultVo);
					return true;
					break;
				case CMDBackpack.S_DeleteGoods:
					///删除物品成功后返回
					var deleteGoodsVo:DeleteGoodsVo=new DeleteGoodsVo();
					deleteGoodsVo.dyId=String(info);
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_DeleteGoods,deleteGoodsVo);
					return true;
					break
				case CMDBackpack.S_UseGoods:
					///服务端返回使用物品   注意 服务端 还有一条协议是返回给  场景模块 用来产生效果
					///使用物品
					var useGoodsVo:UseGoodsResultVo=new UseGoodsResultVo();
					useGoodsVo.dyId=info.dyId;
					useGoodsVo.num=info.num;
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_UseGoods,useGoodsVo);
					return true;
					break;
				case CMDBackpack.S_AddMoney:
					///增加钱数
					var addMoneyVo:MoneyChangeResultVo=new MoneyChangeResultVo();
					addMoneyVo.change=info.change;
					addMoneyVo.money=info.money;
					addMoneyVo.type=info.type;
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_AddMoney,addMoneyVo);
					return true;
					break;
				case CMDBackpack.S_DelMoney:
					///删除钱数
					var delMoneyVo:MoneyChangeResultVo=new MoneyChangeResultVo();
					delMoneyVo.change=info.change;
					delMoneyVo.money=info.money;
					delMoneyVo.type=info.type;
					YFEventCenter.Instance.dispatchEventWith(BackpackEvent.S_DelMoney,delMoneyVo);
					return true;
					break;
				
				
			}
			return false;
		}
		
		
	}
}