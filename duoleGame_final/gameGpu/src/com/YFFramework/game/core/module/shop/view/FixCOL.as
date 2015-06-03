package com.YFFramework.game.core.module.shop.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.msg.enumdef.RspMsg;
	import com.msg.storage.CRepairEquipReq;
	import com.msg.storage.SRepairEquipRsp;
	import com.net.MsgPool;
	
	import flash.utils.getTimer;

	/**
	 * 修理 
	 * @author flashk
	 * 
	 */
	public class FixCOL
	{
		public static var mendFactor:Number = 1.0;
		
		private var _hashMap:HashMap;
		private var _lastFisMsgTime:int = -5000;
		
		public function FixCOL()
		{
		}
		
		private function onServerSRepairEquipRsp(data:SRepairEquipRsp):void
		{
//			MsgPool.k(GameCmd.SRepairEquipRsp,SRepairEquipRsp,onServerSRepairEquipRsp);
			if(getTimer()-_lastFisMsgTime < 3000) return;
			if(data.rsp == RspMsg.RSPMSG_SUCCESS){
				NoticeUtil.setOperatorNotice(LangBasic.itemRepairOK);
			}else{
				NoticeUtil.setOperatorNotice(LangBasic.itemRepairFaild);
			}
			_lastFisMsgTime = getTimer();
		}
		
		/**
		 * 全部修理 
		 * 
		 */
		public function fixAll():void
		{
			MsgPool.addCallBack(GameCmd.SRepairEquipRsp,SRepairEquipRsp,onServerSRepairEquipRsp);
			_hashMap = CharacterDyManager.Instance.getEquipDict();
			var arr:Array = _hashMap.values();
			var able:int = checkFixMoneyEnough(arr);
			if(able == 0){
				Alert.show(LangBasic.itemRepairMoneyNotEnough,LangBasic.fix);
				return;
			}else if( able == -1){
				Alert.show(LangBasic.itemNoNeedRepair,LangBasic.fix);
				return;
			}
			var msg:CRepairEquipReq = new CRepairEquipReq();
			for(var i:int=0;i<arr.length;i++){
				msg.pos.push(EquipDyVo(arr[i]).position);
			}
			MsgPool.sendGameMsg(GameCmd.CRepairEquipReq,msg);
		}
		
		/**
		 * 
		 * @param vos EquipDyVo数组
		 * 
		 */
		public static function checkFixMoneyEnough(vos:Array):int
		{
			var equipDyVo:EquipDyVo;
			var allDurability:int;
			var curDurability:int;
			var need:Number;
			var equip:EquipBasicVo;
			var needAll:Number = 0;
			var hasAll:Number = DataCenter.Instance.roleSelfVo.note;
			for(var i:int=0;i<vos.length;i++){
				equipDyVo = vos[i];
				equip = EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
				if(equip){
					allDurability = equip.durability;
					curDurability = equipDyVo.cur_durability;
					if(curDurability < allDurability){
						need = equip.level*(allDurability-curDurability)*mendFactor;
						needAll += need;
					}
				}
			}
			if(needAll == 0) return -1;
			if(hasAll < needAll ) return 0;
			return 1;
		}
		
	}
}