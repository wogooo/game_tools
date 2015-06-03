package com.YFFramework.game.core.module.character
{
	/**人物模块
	 * @author yefeng
	 *2012-8-21下午9:53:06
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharLevelExperienceBasicManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.character.manage.PowerNumManager;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.character.model.TitleDyManager;
	import com.YFFramework.game.core.module.character.view.CharacterWindow;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideAddPoint;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.wing.model.WingEnhanceManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.managers.UIManager;
	import com.msg.common.AttrInfo;
	import com.msg.enumdef.MoneyType;
	import com.msg.hero.CAddHeroPoint;
	import com.msg.hero.CHeroInfo;
	import com.msg.hero.SAddExperience;
	import com.msg.hero.SAddHeroPoint;
	import com.msg.hero.SChangeMoney;
	import com.msg.hero.SChangePKValue;
	import com.msg.hero.SEnergyChange;
	import com.msg.hero.SHeroAttrChange;
	import com.msg.hero.SHeroInfo;
	import com.msg.hero.SSeeChange;
	import com.msg.item.SModifyEquipCurDurab;
	import com.msg.item.Unit;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromBodyReq;
	import com.msg.storage.CRepairEquipReq;
	import com.msg.storage.SBody;
	import com.msg.storage.SPutToBodyRsp;
	import com.msg.storage.SRemoveFromBodyRsp;
	import com.msg.title_pro.CTitleList;
	import com.msg.title_pro.CUseTitle;
	import com.msg.title_pro.SGetNewTitle;
	import com.msg.title_pro.STitleList;
	import com.msg.title_pro.SUseTitle;
	import com.net.MsgPool;
	
	public class ModuleCharacter extends AbsModule{	
	
		private var powerOffset:int;
		private var _characterWindow:CharacterWindow;
		private var _isFirst:Boolean=true;
		private var _reqeust:Boolean;
		public function ModuleCharacter()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_characterWindow=new CharacterWindow();
		}
		
		public function getCharacterWindow():CharacterWindow
		{
			return _characterWindow;
		}
		
		override public function init():void
		{
			_reqeust=false;
			addEvents();
		}
		
		private function addEvents():void
		{
			/************************************客户端事件**************************************/
			//进入游戏请求玩家已有称号
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,initCharacter);
			///打开人物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.CharacterUIClick,onCharacterClick);
			//主角转职成功
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,onHeroChangeCareerSuccess);
			/** 主角血量魔法改变 */ 
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,heroInfoChange);
			///背包发来删除指定格子
			YFEventCenter.Instance.addEventListener(GlobalEvent.DelBodyGrid,delBodyGrid);
			//修理装备
			YFEventCenter.Instance.addEventListener(CharacterEvent.C_CRepairEquipReq,repairEquipReq);
			//公会名称改变(加入公会和退出公会)
			YFEventCenter.Instance.addEventListener(GlobalEvent.GuildEnter,updateGuild);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GuildExit,updateGuild);			
			//套装强化属性改变
			YFEventCenter.Instance.addEventListener(CharacterEvent.EquipStrengthLevelChange,suitStrengthChange);
			//装备进阶
			YFEventCenter.Instance.addEventListener(GlobalEvent.EQUIP_LEVEL_UP,equipLevelUp);
			//人物升级
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLvUp);
			
			/*********************************服务器发来*************************************/
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
			///修改装备：当前耐久度
			MsgPool.addCallBack(GameCmd.SModifyEquipCurDurab,SModifyEquipCurDurab,onModifyEquipCurDurab);
			///更新罪恶值
			MsgPool.addCallBack(GameCmd.SChangePKValue,SChangePKValue,onModifyPKValue);
			//活力改变
			MsgPool.addCallBack(GameCmd.SEnergyChange,SEnergyChange,onEnergyChange);
			/*****************称号**************/
			//返回已获得称号
			MsgPool.addCallBack(GameCmd.STitleList,STitleList,getTitleList);
			//发来新的称号
			MsgPool.addCallBack(GameCmd.SGetNewTitle,SGetNewTitle,getNewTitle);
			//使用称号回复
			MsgPool.addCallBack(GameCmd.SUseTitle,SUseTitle,useTitleResp);
		}
		
		/**玩家升级，提示玩家加点*/
		private function onHeroLvUp(e:YFEvent=null):void
		{
			if(CharacterDyManager.Instance.potential>0)
			{
				var addWindow:NewGuideAddPoint=NewGuideAddPoint.getInstence(NewGuideAddPoint.AddPoint);
				addWindow.show(LangBasic.Help_Add_Point,LangBasic.Help_Go_Now,GlobalEvent.CharacterUIClick);
			}
		}
		
		/** 场景初始化完成，请求人物全部属性 */		
		public function heroInfoReq():void
		{
			var cHeroInfo:CHeroInfo=new CHeroInfo();
			MsgPool.sendGameMsg(GameCmd.CHeroInfo,cHeroInfo);
		}
		
		/** 删除某个装备 */	
		public function removeEquipReq(pos:int,equipId:int):void
		{
			var msg:CRemoveFromBodyReq=new CRemoveFromBodyReq();
			msg.item=new Unit();
			msg.pos=pos;
			var item:Unit=new Unit();
			item.id=equipId;
			item.type=TypeProps.STORAGE_TYPE_BODY;
			msg.item=item;
			MsgPool.sendGameMsg(GameCmd.CRemoveFromBodyReq,msg);
		}
		
		/** 删除某个装备 */
		public function putOnEquipReq(fromPos:int,toPos:int):void
		{
			var bodyMsg:CPutToBodyReq=new CPutToBodyReq();
			bodyMsg.sourcePos=fromPos;
			bodyMsg.targetPos=toPos;
			MsgPool.sendGameMsg(GameCmd.CPutToBodyReq,bodyMsg);
		}
		
		/** 人物属性加点(体质，力量，敏捷，智力，精神) */
		public function addPoint(phy:int,str:int,agi:int,inte:int,spi:int):void
		{
			var msg:CAddHeroPoint = new CAddHeroPoint();
			msg.addAttrArr=[];
			if(phy > 0)//体质
			{
				var attr:AttrInfo = new AttrInfo();
				attr.attrId = TypeProps.BA_PHYSIQUE;
				attr.attrValue = phy;
				msg.addAttrArr.push(attr);
			}
			if(str > 0)//力量
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BA_STRENGTH;
				attr.attrValue = str;
				msg.addAttrArr.push(attr);
			}
			if(agi > 0)//敏捷
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BA_AGILE;
				attr.attrValue = agi;
				msg.addAttrArr.push(attr);
			}
			if(inte > 0)//智力
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BA_INTELLIGENCE;
				attr.attrValue = inte;
				msg.addAttrArr.push(attr);
			}
			if(spi > 0)//精神
			{
				attr = new AttrInfo();
				attr.attrId = TypeProps.BA_SPIRIT;
				attr.attrValue = spi;
				msg.addAttrArr.push(attr);
			}
			MsgPool.sendGameMsg(GameCmd.CAddHeroPoint,msg);
		}
		
		/** 1.请求自己已获得的称号 */
		private function initCharacter(e:YFEvent):void
		{
			var msg:CTitleList=new CTitleList();
			MsgPool.sendGameMsg(GameCmd.CTitleList,msg);//请求已获得称号
//			trace("真是:",DataCenter.Instance.roleSelfVo.roleDyVo.roleName);
			
			//vip信息
			_characterWindow.updateVip();
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,initCharacter);
			
			onHeroLvUp();
		}		
		
		/** 请求使用某个称号 */
		public function useTitleReq(titleId:int):void
		{
			var msg:CUseTitle=new CUseTitle();
			msg.titleId=titleId;
			MsgPool.sendGameMsg(GameCmd.CUseTitle,msg);
		}
		
		/** 请求已获得称号列表  */		
		private function getTitleList(msg:STitleList):void
		{
			TitleDyManager.instance.addTitleList(msg.titleList);
			TitleDyManager.instance.curTitleId=msg.currentTitle;
			_characterWindow.updateTitle();
		}
		
		/** 获得新的称号  */	
		private function getNewTitle(msg:SGetNewTitle):void
		{
			TitleDyManager.instance.setNewTitleId(msg.newTitleId);
			if(_characterWindow.isOpen && _characterWindow.getTabIndex() == _characterWindow.TITLE)//面板打开且在称号那一页才刷新
			{
				var type:int=TitleBasicManager.Instance.getTitleBasicVo(msg.newTitleId).title_type;
				_characterWindow.updateTitleType(type);
			}
		}
		
		private function useTitleResp(msg:SUseTitle):void
		{
			TitleDyManager.instance.curTitleId=msg.titleId;
			_characterWindow.updateTitle();//改变称号时，面板肯定是打开的
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TITLE_UPDATE);
		}
		
		private function heroInfoChange(e:YFEvent):void
		{
			var roleDyVo:RoleDyVo=e.param as RoleDyVo;
			if(roleDyVo.dyId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{///更新玩家血量
				_characterWindow.updateTextInfo();
			}
		}
		
		private function onEnergyChange(msg:SEnergyChange):void{
			CharacterDyManager.Instance.energy=msg.energy;
			_characterWindow.updateTextInfo();
		}
		
		/**人物阅历改变
		 */		
		private function onSSeeChange(sSeeChange:SSeeChange):void
		{
			CharacterDyManager.Instance.yueli=sSeeChange.seeValue;
			_characterWindow.updateTextInfo();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SeeChange);
		}
		
		private function onHeroChangeCareerSuccess(e:YFEvent):void
		{
			_characterWindow.onRoleChangeCareer();
		}
		
		/** 金币发生改变 */		
		private function onMoneyChange(sChangeMoney:SChangeMoney):void
		{
			var money:int=0;
			switch(sChangeMoney.moneyType)
			{
				//魔钻
				case TypeProps.MONEY_DIAMOND: 
					if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.diamond > 0)
					{
						money=sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.diamond;
						NoticeManager.setNotice(NoticeType.Notice_id_401,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_DIAMOND));
					}
					else if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.diamond < 0)
					{
						money=DataCenter.Instance.roleSelfVo.diamond - sChangeMoney.moneyValue;
						NoticeManager.setNotice(NoticeType.Notice_id_402,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_DIAMOND));
					}
					DataCenter.Instance.roleSelfVo.diamond=sChangeMoney.moneyValue;
					break
				//礼卷
				case TypeProps.MONEY_COUPON:
					if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.coupon > 0)
					{
						money=sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.coupon;
						NoticeManager.setNotice(NoticeType.Notice_id_401,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_COUPON));
					}
					else if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.coupon < 0)
					{
						money=DataCenter.Instance.roleSelfVo.coupon - sChangeMoney.moneyValue;
						NoticeManager.setNotice(NoticeType.Notice_id_402,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_COUPON));
					}
					DataCenter.Instance.roleSelfVo.coupon=sChangeMoney.moneyValue;
					break;
				//银币
				case TypeProps.MONEY_SILVER:
					trace("ModuleCharacter322行,没有银币这个货币!")
//					if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.silver > 0)
//					{
//						money=sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.silver;
//						NoticeManager.setNotice(NoticeType.Notice_id_401,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_SILVER));
//					}
//					else if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.silver < 0)
//					{
//						money=DataCenter.Instance.roleSelfVo.silver - sChangeMoney.moneyValue;
//						NoticeManager.setNotice(NoticeType.Notice_id_402,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_SILVER));
//					}
//					DataCenter.Instance.roleSelfVo.silver=sChangeMoney.moneyValue;
					break;
				//银锭（绑定）  
				case TypeProps.MONEY_NOTE:
					if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.note > 0)
					{
						money=sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.note;
						NoticeManager.setNotice(NoticeType.Notice_id_401,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_NOTE));
					}
					else if(sChangeMoney.moneyValue - DataCenter.Instance.roleSelfVo.note < 0)
					{
						money=DataCenter.Instance.roleSelfVo.note - sChangeMoney.moneyValue;
						NoticeManager.setNotice(NoticeType.Notice_id_402,-1,money,NoticeUtils.getMoneyTypeStr(MoneyType.MONEY_NOTE));
					}
					DataCenter.Instance.roleSelfVo.note=sChangeMoney.moneyValue;
					break;
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoneyChange);
		}
		
		
		/**人物经验改变
		 */		
		private function onExpChange(sAddExperience:SAddExperience):void
		{
			var curLevel:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			var lastLevel:int=DataCenter.Instance.roleSelfVo.preLevel;
			var lastExp:int=DataCenter.Instance.roleSelfVo.exp;
			var changeExp:int=0;
			if(lastLevel == 0)
				lastLevel=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			if(curLevel != lastLevel)
			{	
				var startLevel:int;
				if(lastExp > 0)
				{
					changeExp=CharLevelExperienceBasicManager.Instance.getExp(lastLevel)-lastExp;
					startLevel=lastLevel+1;
				}
				else
					startLevel=lastLevel;
				for(var i:int=startLevel;i < curLevel;i++)
				{
					changeExp += CharLevelExperienceBasicManager.Instance.getExp(i);
				}
				changeExp += sAddExperience.exp;
			}
			else
			{
				changeExp=sAddExperience.exp - lastExp;
			}
			if(changeExp>0)
				NoticeManager.setNotice(NoticeType.Notice_id_801,-1,changeExp);
			
			DataCenter.Instance.roleSelfVo.exp=sAddExperience.exp;
			heroExpChange();
			DataCenter.Instance.roleSelfVo.preLevel=DataCenter.Instance.roleSelfVo.roleDyVo.level;
		}
		
		/**  角色身上
		 */		
		private function bodyInfoCallBack(sBody:SBody):void
		{
			CharacterDyManager.Instance.addEquip(sBody.cell);
			CharacterDyManager.Instance.setNewEquips(sBody.cell);
			_characterWindow.updateAllEquips();
			//原来发的都是CharacterEquipChange，现在只要发BagChange就行了，因为人物身上的穿脱装备一定是要经过背包的
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.HasHeroEquip);
			
			if(_characterWindow.isOpen)
				_characterWindow.equipStrengthChange();
		}
		
		private function heroInfoCallBack(sHeroInfo:SHeroInfo):void
		{		
			//获取坐骑星数和翅膀星数
			if(sHeroInfo.hasMountLucky){
				CharacterDyManager.Instance.mountStarNum = Math.floor(sHeroInfo.mountLucky/100);
				CharacterDyManager.Instance.mountLuckNum = sHeroInfo.mountLucky%100;
			}
			if(sHeroInfo.hasWingLucky){
				CharacterDyManager.Instance.wingStarNum = Math.floor(sHeroInfo.wingLucky/100);
				CharacterDyManager.Instance.wingLuckNum = sHeroInfo.wingLucky%100;
			}
			if(sHeroInfo.hasWingEnhanceTimes)
			{
				WingEnhanceManager.Instance.enhanced_count=sHeroInfo.wingEnhanceTimes;
				trace("今日已经强化的次数："+sHeroInfo.wingEnhanceTimes);
			}
			if(sHeroInfo.hasWingMoneyTimes)
			{
				trace("今日用钱强化的次数："+sHeroInfo.wingMoneyTimes);
				WingEnhanceManager.Instance.money_use_count=sHeroInfo.wingMoneyTimes;
			}
			if(_isFirst== false)
			{
				if(sHeroInfo.power != CharacterDyManager.Instance.power)
				{
					powerOffset=sHeroInfo.power-CharacterDyManager.Instance.power;
					PowerNumManager.instance.addPowerNum(sHeroInfo.power,powerOffset);						
				}		
			}
//			trace('战斗力改变前：',CharacterDyManager.Instance.power,'改变后：',sHeroInfo.power)
			CharacterDyManager.Instance.power=sHeroInfo.power;			
			_isFirst=false;
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
			//成长任务称号角色属性改变
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.hero_attr);
		}
		
		private function onPutToBodyRsp(msg:SPutToBodyRsp):void
		{
			equipResp(msg.rsp);
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS && _characterWindow.isOpen)
				_characterWindow.equipStrengthChange();
		}
		
		private function onRemoveFromBodyRsp(msg:SRemoveFromBodyRsp):void
		{
			equipResp(msg.rsp);
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS && _characterWindow.isOpen)
				_characterWindow.equipStrengthChange();
		}
		
		/** 人物属性大部分改变 一般在穿脱装备 以及升级的时候发生改变
		 */		
		private function onHeroAttrChange(sHeroAttrChange:SHeroAttrChange):void
		{
			if(sHeroAttrChange.power != CharacterDyManager.Instance.power)
			{
				powerOffset=sHeroAttrChange.power-CharacterDyManager.Instance.power;
				CharacterDyManager.Instance.power=sHeroAttrChange.power;
				PowerNumManager.instance.addPowerNum(CharacterDyManager.Instance.power,powerOffset);
			}
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
				_characterWindow.updatePoint();
			}
			_characterWindow.updateTextInfo();
			if(isDispatch) 	noticeHeroInfoChange();
			//成长任务称号角色属性改变
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.hero_attr);
		}
		
		private function onAddPointResp(msg:SAddHeroPoint):void
		{
			if(msg.code != 0)
				_characterWindow.updatePoint();
		}
		
		private function onModifyEquipCurDurab(msg:SModifyEquipCurDurab):void
		{
			var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(msg.equipId);
			equipDyVo.cur_durability=msg.curDurability;
		}
		
		private function onModifyPKValue(msg:SChangePKValue):void
		{
			CharacterDyManager.Instance.pkValue=msg.pkValue;
			_characterWindow.updatePKValue();
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
			
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
			{
				if(_characterWindow.isOpen&&_characterWindow.isCloseing==false) //窗口打开
				{
					if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorGuideTuiJian)
					{
						NewGuideManager.DoGuide();
					}
				}
			}

		}
		
		private function delBodyGrid(e:YFEvent):void
		{
			_characterWindow.delGrid(e.param as int);
		}
		
		private function repairEquipReq(e:YFEvent):void
		{
			var msg:CRepairEquipReq=new CRepairEquipReq();
			msg.pos=[e.param as int];
			MsgPool.sendGameMsg(GameCmd.CRepairEquipReq,msg);
		}
		
		private function updateGuild(e:YFEvent):void
		{
			_characterWindow.updateGuildName();
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.attend_guild);
		}
			
		private function suitStrengthChange(e:YFEvent):void
		{
			if(_characterWindow.isOpen)
				_characterWindow.equipStrengthChange();
		}
		
		private function equipResp(rsp:int):void
		{
			switch(rsp)
			{
				case TypeProps.RSPMSG_UN_EQUIP:
					NoticeManager.setNotice(NoticeType.Notice_id_1702);
					break;
				case TypeProps.RSPMSG_EQUIP_POS_UNFIT:
					NoticeManager.setNotice(NoticeType.Notice_id_1701);
					break;
				case TypeProps.RSPMSG_EQUIP_RANK_UNFIT:
					NoticeManager.setNotice(NoticeType.Notice_id_307);
					break;
				case TypeProps.RSPMSG_EQUIP_GENDER_UNFIT:
					NoticeManager.setNotice(NoticeType.Notice_id_308);
					break;
				case TypeProps.RSPMSG_EQUIP_CAREER_UNFIT:
					NoticeManager.setNotice(NoticeType.Notice_id_1700);
					break;
			}
		}
		
		private function equipLevelUp(e:YFEvent):void
		{
			var pos:int=e.param as int;
			if(pos < BagSource.BAG_OFFSET)
			{
				var equip:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(pos);
				CharacterDyManager.Instance.newEquips=[equip];
				_characterWindow.updateAllEquips();
			}
		}
	}
}