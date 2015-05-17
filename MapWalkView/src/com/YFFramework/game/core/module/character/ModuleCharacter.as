package com.YFFramework.game.core.module.character
{
	/**人物模块
	 * @author yefeng
	 *2012-8-21下午9:53:06
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.character.view.CharacterWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.managers.UIManager;
	import com.msg.common.AttrInfo;
	import com.msg.enumdef.MoneyType;
	import com.msg.hero.CAddHeroPoint;
	import com.msg.hero.CHeroInfo;
	import com.msg.hero.SAddExperience;
	import com.msg.hero.SAddHeroPoint;
	import com.msg.hero.SChangeMoney;
	import com.msg.hero.SHeroAttrChange;
	import com.msg.hero.SHeroInfo;
	import com.msg.hero.SSeeChange;
	import com.msg.item.SModifyEquipBinding;
	import com.msg.item.SModifyEquipCurDurab;
	import com.msg.storage.CGetBodyInfReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromBodyReq;
	import com.msg.storage.SBody;
	import com.msg.storage.SPutToBodyRsp;
	import com.msg.storage.SRemoveFromBodyRsp;
	import com.net.MsgPool;
	
	public class ModuleCharacter extends AbsModule
	{	
	
		private var _characterWindow:CharacterWindow;
//		private var _reqeust:Boolean;
		public function ModuleCharacter()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function init():void
		{
			_characterWindow=new CharacterWindow();
//			_reqeust=false;
			addEvents();
			addSocketEvents();
		}
		private function addEvents():void
		{
			///打开人物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.CharacterUIClick,onCharacterClick);
			///快捷键
			YFEventCenter.Instance.addEventListener(GlobalEvent.C,onCharacterClick);
			////socket 发送
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSendSocket);
			///穿装备
			YFEventCenter.Instance.addEventListener(CharacterEvent.C_PutOnEquip,onSendSocket);
			///脱装备
			YFEventCenter.Instance.addEventListener(CharacterEvent.C_PutOffEquip,onSendSocket);
			///加点
			YFEventCenter.Instance.addEventListener(CharacterEvent.C_AddPointReq,onSendSocket);
			//主角转职成功
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onHeroChangeCareerSuccess);
			
		}
		/**处理socket事件
		 */		
		private function addSocketEvents():void
		{
			///人物金币 改变  
			MsgPool.addCallBack(GameCmd.SChangeMoney,SChangeMoney,onMoneyChange);
			///人物经验改变
			MsgPool.addCallBack(GameCmd.SAddExperience,SAddExperience,onExpChange);
			///请求人物身上的装备信息
			MsgPool.addCallBack(GameCmd.SBody,SBody,bodyInfoCallBack);
			///角色信息返回
			MsgPool.addCallBack(GameCmd.SHeroInfo,SHeroInfo,heroInfoCallBack);
			///穿装备回复
			MsgPool.addCallBack(GameCmd.SPutToBodyRsp,SPutToBodyRsp,onPutToBodyRsp);
			///脱装备回复
			MsgPool.addCallBack(GameCmd.SRemoveFromBodyRsp,SRemoveFromBodyRsp,onRemoveFromBodyRsp);
			///主角属性改变 包括 血量 魔法 经验  等等 主角相关的信息
			MsgPool.addCallBack(GameCmd.SHeroAttrChange,SHeroAttrChange,onHeroAttrChange);
			///加点回复
			MsgPool.addCallBack(GameCmd.SAddHeroPoint,SAddHeroPoint,onAddPointResp);
			///人物阅历主动改变
			MsgPool.addCallBack(GameCmd.SSeeChange,SSeeChange,onSSeeChange);
			///改变装备绑定性：只有穿戴后绑定需要这条消息
			MsgPool.addCallBack(GameCmd.SModifyEquipBinding,SModifyEquipBinding,onModifyEquipBinding);
			///修改装备：当前耐久度
			MsgPool.addCallBack(GameCmd.SModifyEquipCurDurab,SModifyEquipCurDurab,onModifyEquipCurDurab);
		}
		/**人物阅历改变
		 */		
		private function onSSeeChange(sSeeChange:SSeeChange):void
		{
			CharacterDyManager.Instance.yueli=sSeeChange.seeValue;
			_characterWindow.updateTextInfo();
		}
		private function onHeroChangeCareerSuccess(e:YFEvent):void
		{
			_characterWindow.removeAllEquip();
		}
			
			
		
		/** 金币发生改变
		 */		
		private function onMoneyChange(sChangeMoney:SChangeMoney):void
		{
			switch(sChangeMoney.moneyType)
			{
				//魔钻
				case MoneyType.MONEY_DIAMOND: 
					DataCenter.Instance.roleSelfVo.diamond=sChangeMoney.moneyValue;
					break
				//礼卷
				case MoneyType.MONEY_COUPON: 
					DataCenter.Instance.roleSelfVo.coupon=sChangeMoney.moneyValue;
					break
				//银币
				case MoneyType.MONEY_SILVER: 
					DataCenter.Instance.roleSelfVo.silver=sChangeMoney.moneyValue;
					break
				//银锭（绑定）  
				case MoneyType.MONEY_NOTE: 
					DataCenter.Instance.roleSelfVo.note=sChangeMoney.moneyValue;
					break
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoneyChange);
			///主角
			heroExpChange();
		}
		
		
		/**人物经验改变
		 */		
		private function onExpChange(sAddExperience:SAddExperience):void
		{
			DataCenter.Instance.roleSelfVo.exp=sAddExperience.exp;
			heroExpChange();
		}
		
		/**  角色身上
		 */		
		private function bodyInfoCallBack(sBody:SBody):void
		{
			CharacterDyManager.Instance.addEquip(sBody.cell);
			CharacterDyManager.Instance.setNewEquips(sBody.cell);
			_characterWindow.updateAllEquips();
		}
		
		private function heroInfoCallBack(sHeroInfo:SHeroInfo):void
		{
			CharacterDyManager.Instance.power=sHeroInfo.power;
			for each (var attrInfo:AttrInfo in sHeroInfo.attrArr)
			{
				CharacterDyManager.Instance.propArr[attrInfo.attrId]=attrInfo.attrValue;
//				print(this,"attrInfo.attrValue:",attrInfo.attrId,"value:",attrInfo.attrValue);
				switch(attrInfo.attrId)
				{
					case TypeProps.EA_HEALTH:  ///生命 
						DataCenter.Instance.roleSelfVo.roleDyVo.hp=attrInfo.attrValue;
						break;
					case TypeProps.EA_HEALTH_LIMIT:  ///最大生命 
						DataCenter.Instance.roleSelfVo.roleDyVo.maxHp=attrInfo.attrValue;
						break;
					case TypeProps.EA_MANA:  ///魔法
						DataCenter.Instance.roleSelfVo.roleDyVo.mp=attrInfo.attrValue;
						break;
					case TypeProps.EA_MANA_LIMIT:  ///魔法上线
						DataCenter.Instance.roleSelfVo.roleDyVo.maxMp=attrInfo.attrValue;
						break;
				}
			}
			_characterWindow.updateTextInfo();
			noticeHeroInfoChange();
		}
		
		private function onPutToBodyRsp(msg:SPutToBodyRsp):void
		{
			_characterWindow.equipResp(msg.rsp);
		}
		
		private function onRemoveFromBodyRsp(msg:SRemoveFromBodyRsp):void
		{
			_characterWindow.equipResp(msg.rsp);
		}
		
		/** 人物属性大部分改变 一般在穿脱装备 以及升级的时候发生改变
		 */		
		private function onHeroAttrChange(sHeroAttrChange:SHeroAttrChange):void
		{
			CharacterDyManager.Instance.power=sHeroAttrChange.power;
			var isDispatch:Boolean=false;///是否进行广播   如果属性里面 含有 血量 或者  魔法值的话则进行广播
			for each (var attrInfo:AttrInfo in sHeroAttrChange.changeAttrArr)
			{
				CharacterDyManager.Instance.propArr[attrInfo.attrId]=attrInfo.attrValue;
				switch(attrInfo.attrId)
				{
					case TypeProps.EA_HEALTH:  ///生命 
						DataCenter.Instance.roleSelfVo.roleDyVo.hp=attrInfo.attrValue;
						isDispatch=true
						break;
					case TypeProps.EA_HEALTH_LIMIT:  ///最大生命 
						DataCenter.Instance.roleSelfVo.roleDyVo.maxHp=attrInfo.attrValue;
						isDispatch=true
						break;
					case TypeProps.EA_MANA:  ///魔法
						DataCenter.Instance.roleSelfVo.roleDyVo.mp=attrInfo.attrValue;
						isDispatch=true
						break;
					case TypeProps.EA_MANA_LIMIT:  ///魔法上线
						DataCenter.Instance.roleSelfVo.roleDyVo.maxMp=attrInfo.attrValue;
						isDispatch=true
						break;
				}
			}
			if(sHeroAttrChange.hasPotential)
			{
				CharacterDyManager.Instance.potential=sHeroAttrChange.potential;
			}
			_characterWindow.updateTextInfo();
			if(isDispatch) 	noticeHeroInfoChange();
		}
		
		private function onAddPointResp(msg:SAddHeroPoint):void
		{
			if(msg.code != 0)
				_characterWindow.updatePoint();
		}
		
		private function onModifyEquipBinding(msg:SModifyEquipBinding):void
		{
			var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(msg.equipId);
			equipDyVo.binding_attr=msg.bindingAttr;
		}
		
		private function onModifyEquipCurDurab(msg:SModifyEquipCurDurab):void
		{
			var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(msg.equipId);
			equipDyVo.cur_durability=msg.curDurability;
		}
		
		/**  主角信息改变 主界面UI更新
		 */		
		private function noticeHeroInfoChange():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,DataCenter.Instance.roleSelfVo.roleDyVo);
		}
		
		/**经验发生改变  在主界面修改经验条UI
		 */		
		private function heroExpChange():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.HeroExpChange);
		}
		
		protected function onCharacterClick(e:YFEvent):void
		{
			UIManager.switchOpenClose(_characterWindow);
			if(_characterWindow.isOpen)
			{
				_characterWindow.playRoleAction();
				_characterWindow.clearPoint();
			}
			else
			{
				_characterWindow.stopRoleAction();
			}
		}
		private function requestCharactorData():void
		{
			/// 请求人物身上的 装备列表
			var cGetBodyInfReq:CGetBodyInfReq=new CGetBodyInfReq();
			MsgPool.sendGameMsg(GameCmd.CGetBodyInfReq,cGetBodyInfReq);
		}
		/**客户端发送socket给服务端
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					var cHeroInfo:CHeroInfo=new CHeroInfo();
					MsgPool.sendGameMsg(GameCmd.CHeroInfo,cHeroInfo);
					requestCharactorData();
					break;
				case CharacterEvent.C_PutOffEquip:
					MsgPool.sendGameMsg(GameCmd.CRemoveFromBodyReq,e.param as CRemoveFromBodyReq);
					break;
				case CharacterEvent.C_PutOnEquip:
					MsgPool.sendGameMsg(GameCmd.CPutToBodyReq,e.param as CPutToBodyReq);
					break;
				case CharacterEvent.C_AddPointReq:
					MsgPool.sendGameMsg(GameCmd.CAddHeroPoint,e.param as CAddHeroPoint);
					break;
			}
		}
	}
}