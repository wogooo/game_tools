package com.YFFramework.game.core.module.forge
{
	/**@author flashk
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.module.forge.view.ForgeWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Window;
	import com.msg.enumdef.RspMsg;
	import com.msg.item.CEnhanceEquipReq;
	import com.msg.item.CEquipEnhanceTransReq;
	import com.msg.item.CInlayGemReq;
	import com.msg.item.SEnhanceEquipRsp;
	import com.msg.item.SEquipEnhanceTransRsp;
	import com.msg.item.SInlayGemRsp;
	import com.msg.item.SModifyEquipEnhLevel;
	import com.msg.item.SModifyEquipGem;
	import com.net.MsgPool;
	
	import flash.utils.getTimer;
	
	public class ForgeModule extends AbsModule
	{
		private var _window:ForgeWindow;
		private var _lastTime:int;
		
		public function ForgeModule()
		{
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		private function onSInlayGemRsp(data:SInlayGemRsp):void
		{
			var t:int = getTimer();
			if(t-_lastTime < 3000) return;
			_lastTime = getTimer();
			if(data.rsp == RspMsg.RSPMSG_SUCCESS){
				Alert.show(LangBasic.inlayGemOK,LangBasic.equipUpdate);
				_window.updateInlayGemBag();
			}else{
				Alert.show(LangBasic.inlayGemFaild,LangBasic.equipUpdate);
			}
		}
		
		private function onSEnhanceEquipRsp(data:SEnhanceEquipRsp):void
		{
			if(data.rsp == RspMsg.RSPMSG_SUCCESS){
				Alert.show(LangBasic.equipStrengthenOK,LangBasic.equipUpdate);
			}else{
				Alert.show(LangBasic.equipStrengthenFaild,LangBasic.equipUpdate);
			}
		}
		
		override public function init():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.ForgeUIClick,onForgeClick);
			MsgPool.addCallBack(GameCmd.SEnhanceEquipRsp,SEnhanceEquipRsp,onSEnhanceEquipRsp);
			MsgPool.addCallBack(GameCmd.SInlayGemRsp,SInlayGemRsp,onSInlayGemRsp);
			MsgPool.addCallBack(GameCmd.SEquipEnhanceTransRsp,SEquipEnhanceTransRsp,onSEquipEnhanceTransRsp);
			MsgPool.addCallBack(GameCmd.SModifyEquipEnhLevel,SModifyEquipEnhLevel,onSModifyEquipEnhLevel);
			MsgPool.addCallBack(GameCmd.SModifyEquipGem,SModifyEquipGem,onSModifyEquipGem);
		}
		
		private function onSModifyEquipGem(data:SModifyEquipGem):void
		{
			var vo:EquipDyVo = EquipDyManager.instance.getEquipInfo(data.equipId);
			vo.gem_1_id = data.gem_1Id;
			vo.gem_2_id = data.gem_2Id;
			vo.gem_3_id = data.gem_3Id;
			vo.gem_4_id = data.gem_4Id;
			vo.gem_5_id = data.gem_5Id;
			vo.gem_6_id = data.gem_6Id;
			vo.gem_7_id = data.gem_7Id;
			vo.gem_8_id = data.gem_8Id;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EquipGemChange,data.equipId);
		}
		
		private function onSModifyEquipEnhLevel(data:SModifyEquipEnhLevel):void
		{
			var vo:EquipDyVo = EquipDyManager.instance.getEquipInfo(data.equipId);
			vo.enhance_level = data.enhanceLevel;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EquipEnhanceLevelChange,data.equipId);
		}
		
		private function onSEquipEnhanceTransRsp(data:SEquipEnhanceTransRsp):void
		{
			if(data.rsp == RspMsg.RSPMSG_SUCCESS){
				Alert.show(LangBasic.shiftOK,LangBasic.equipUpdate);
				_window.shiftCOL.reset();
			}else{
				Alert.show(LangBasic.shiftFaild,LangBasic.equipUpdate);
			}
		}
		
		/**
		 * 强化装备 
		 * @param pos 装备所在位置
		 * @param stoneNum 使用强化石数量
		 * 
		 */
		public function strengthenEquip(pos:int,stoneNum:int):void
		{
			var msg:CEnhanceEquipReq = new CEnhanceEquipReq();
			msg.pos = pos;
			msg.stoneNum = stoneNum;
			MsgPool.sendGameMsg(GameCmd.CEnhanceEquipReq,msg);
		}
		
		/**
		 * 镶嵌宝石 
		 * @param equipPos
		 * @param inlayPos
		 * @param gemPos
		 * 
		 */
		public function inlayGem(equipPos:int,inlayPos:int,gemPos:int):void
		{
			var msg:CInlayGemReq = new CInlayGemReq();
			msg.equipPos = equipPos;
			msg.inlayPos = inlayPos+1;
			msg.gemPos = gemPos;
			MsgPool.sendGameMsg(GameCmd.CInlayGemReq,msg);
		}
		
		/**
		 * 强化转移 
		 * @param fromPos
		 * @param toPos
		 * 
		 */
		public function shiftEquipStrengthen(fromPos:int,toPos:int):void
		{
			var msg:CEquipEnhanceTransReq = new CEquipEnhanceTransReq();
			msg.sourcePos = fromPos;
			msg.targetPos = toPos;
			MsgPool.sendGameMsg(GameCmd.CEquipEnhanceTransReq,msg);
		}
		
		private function onForgeClick(e:YFEvent):void
		{
			if(_window == null){
				_window = new ForgeWindow();
			}
			_window.switchOpenClose();
		}
		
	}
}