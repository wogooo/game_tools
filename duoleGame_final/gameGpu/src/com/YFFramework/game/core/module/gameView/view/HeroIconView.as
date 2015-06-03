package com.YFFramework.game.core.module.gameView.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 下午1:57:44
	 * 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.AutoHealTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.autoSetting.source.AutoSource;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.Slider;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CAddHPByPool;
	import com.msg.hero.CAddMPByPool;
	import com.msg.hero.CSetHeroFightMode;
	import com.msg.hero.CUseItem;
	import com.msg.hero.SAddHPByPool;
	import com.msg.hero.SAddMPByPool;
	import com.msg.hero.SHpPoolChange;
	import com.msg.hero.SMpPoolChange;
	import com.msg.sys.CAutoConfigSave;
	import com.msg.sys.ConfigInt;
	import com.net.MsgPool;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class HeroIconView extends AbsView{
		
		private const WIDTH:int=174;//进度条的长度
		
		private var _mc:MovieClip;
		
		private var hp_progressBar:ProgressBar;
		private var mp_progressBar:ProgressBar;
		
		private var hp_slider:Slider;
		private var mp_slider:Slider;
		
		private var mode_button:Button;
		private var _menu:Menu;
		
		private var hp_button:Button;
		private var mp_button:Button;

		private var _hasHpPoolCD:Boolean=false;
		private var _hasHpDrugCD:Boolean=false;
		private var _hasMpPoolCD:Boolean=false;
		private var _hasMpDrugCD:Boolean=false;
		
		/** 只要是vip就显示的大图标 */
		private var _vipper:SimpleButton;
		/** 区分vip等级年费否的名字旁的小图标 */
		private var _vipIcon:MovieClip;
		
		private const Hp_Pool_Type:int=17;
		private const Mp_Pool_Type:int=18;
		
		public function HeroIconView(mc:MovieClip){
			
			super(false);
			_mc=mc;
			
			AutoBuild.replaceAll(_mc);
			
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			mp_progressBar = Xdis.getChild(_mc,"mp_progressBar");
			
			hp_slider = Xdis.getChild(_mc,"hp_slider");
			hp_slider.liveDragging=false;
			hp_slider.addEventListener(Event.CHANGE,onHPSlide);
			mp_slider = Xdis.getChild(_mc,"mp_slider");
			mp_slider.liveDragging=false;
			mp_slider.addEventListener(Event.CHANGE,onMPSlide);
			
			_mc.hp_tf.mouseEnabled =false;
			_mc.mp_tf.mouseEnabled =false;
			mode_button = Xdis.getChildAndAddClickEvent(onModeChange,_mc,"mode_button");
		
			hp_button = Xdis.getChildAndAddClickEvent(onHpClick,_mc,"hp_button");
			hp_button.label="血";
			hp_button.disableText();
			hp_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			mp_button = Xdis.getChildAndAddClickEvent(onMpClick,_mc,"mp_button");
			mp_button.label="魔";
			mp_button.disableText();
			mp_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			Xtip.registerLinkTip(hp_button,AutoHealTip,TipUtil.autoPoolInitFunc,AutoHealTip.TypeHP);
			Xtip.registerLinkTip(mp_button,AutoHealTip,TipUtil.autoPoolInitFunc,AutoHealTip.TypeMP);
			
			_vipper=Xdis.getChild(_mc,"vipper");
			_vipper.addEventListener(MouseEvent.CLICK,onVipClick);
			_vipper.visible=false;
			print(this,"此处vip图标显示隐藏掉");
			
			YFEventCenter.Instance.addEventListener(AutoEvent.LOAD_COMPLETE,onLoadComplete);
			MsgPool.addCallBack(GameCmd.SAddHPByPool,SAddHPByPool,onAddHpByPool);
			MsgPool.addCallBack(GameCmd.SAddMPByPool,SAddMPByPool,onAddMpByPool);
			MsgPool.addCallBack(GameCmd.SHpPoolChange,SHpPoolChange,onHpPoolChg);
			MsgPool.addCallBack(GameCmd.SMpPoolChange,SMpPoolChange,onMpPoolChg);
		}
		
		private function onVipInit():void
		{	
			var vipRes:String=TypeRole.getVipResName(DataCenter.Instance.roleSelfVo.roleDyVo.vipType,DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel);
			if(vipRes != '')
			{
				_vipIcon=ClassInstance.getInstance(vipRes);
				_vipIcon.buttonMode=true;
				_vipIcon.addEventListener(MouseEvent.CLICK,onVipClick);
				_mc.addChild(_vipIcon);
				_vipIcon.x=_mc.player_name.x+_mc.player_name.textWidth+5;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.vipType == TypeRole.VIP_TYPE_YEAR && DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel == 8)
					_vipIcon.y=_mc.player_name.y-4;
				else
					_vipIcon.y=_mc.player_name.y;
//				YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onVipInit);
			}
			
			var html:String="1.杀怪增加20%经验<br>2.小飞鞋免费使用<br>3.坐骑进阶成功率增加30%<br>4.翅膀进阶成功率增加30%<br>";
			if(DataCenter.Instance.roleSelfVo.roleDyVo.vipType == TypeRole.VIP_TYPE_NONE)
			{
				_vipper.filters=FilterConfig.dead_filter;
				html += HTMLUtil.createHtmlText("以上特权您开通黄钻即可激活",12,"ff0000");
			}
			else
			{
				_vipper.filters=[];
				html += HTMLUtil.createHtmlText("以上特权您已激活成功",12,'ffff00');
			}
			Xtip.registerTip(_vipper,html);			
			_vipper.addEventListener(MouseEvent.CLICK,onVipClick);
		}
		
		private function onVipClick(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);
		}
		
		/**血池改变
		 * @param msg
		 */		
		private function onHpPoolChg(msg:SHpPoolChange):void{
			DataCenter.Instance.roleSelfVo.hpPool = msg.hpPool;
			updatePool();
		}
		
		/**魔池改变
		 * @param msg
		 */	
		private function onMpPoolChg(msg:SMpPoolChange):void{
			DataCenter.Instance.roleSelfVo.mpPool = msg.mpPool;
			updatePool();
		}
		
		/**魔池加魔
		 * @param msg
		 */		
		private function onAddMpByPool(msg:SAddMPByPool):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				DataCenter.Instance.roleSelfVo.roleDyVo.mp = msg.mp;
				_hasMpPoolCD=true;
				setTimeout(onMpPoolCDComplete,15000);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,DataCenter.Instance.roleSelfVo.roleDyVo);
			}else{
				_hasMpPoolCD=false;
			}
		}
		
		/**魔池加魔cd完成
		 * @param o
		 */		
		private function onMpPoolCDComplete():void{
			_hasMpPoolCD = false;
			onRoleInfoChange();
		}
		
		/**血池加血
		 * @param msg
		 */
		private function onAddHpByPool(msg:SAddHPByPool):void{
			if(msg.errorInfo==TypeProps.RSPMSG_SUCCESS){
				DataCenter.Instance.roleSelfVo.roleDyVo.hp = msg.hp;
				_hasHpPoolCD=true;
				setTimeout(onHpCDComplete,15000);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RoleInfoChange,DataCenter.Instance.roleSelfVo.roleDyVo);
			}else{
				_hasHpPoolCD=false;
			}
		}
		
		/**血池加血cd完成*/
		private function onHpCDComplete():void{
			_hasHpPoolCD = false;
			onRoleInfoChange();
		}
		/**血瓶cd完成*/		
		private function onHpDrugCDComplete():void{
			_hasHpDrugCD=false;
			onRoleInfoChange();
		}
		/**魔瓶cd完成*/	
		private function onMpDrugCDComplete():void{
			_hasMpDrugCD=false;
			onRoleInfoChange();
		}

		/**人物属性改变
		 */		
		private function onRoleInfoChange():void{
			var hpPercent:Number = DataCenter.Instance.roleSelfVo.roleDyVo.hp/DataCenter.Instance.roleSelfVo.roleDyVo.maxHp * 100;
			var sendByPool:Boolean=false;
			if(hpPercent<=70 && DataCenter.Instance.roleSelfVo.roleDyVo.hp>0 && DataCenter.Instance.roleSelfVo.hpPool>=DataCenter.Instance.roleSelfVo.roleDyVo.maxHp*0.2 && _hasHpPoolCD==false){//使用血池
				MsgPool.sendGameMsg(GameCmd.CAddHPByPool,new CAddHPByPool());
				sendByPool = true;
				_hasHpPoolCD = true;
			}
			if(sendByPool==false && hpPercent<hp_slider.value && hpPercent<100 && _hasHpDrugCD==false && DataCenter.Instance.roleSelfVo.roleDyVo.hp>0){//使用血瓶
				var pos:int = PropsDyManager.instance.getFirstDrugPos();
				if(pos>0){
					var bvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(PropsDyManager.instance.getPropsInfo(BagStoreManager.instantce.getPackInfoByPos(pos).id).templateId);
					var cd:YFCD = BagStoreManager.instantce.getCd(bvo.cd_type);
					if(cd==null){
						var msg:CUseItem = new CUseItem();
						msg.itemPos = pos;
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
						setTimeout(onHpDrugCDComplete,bvo.cd_time+500);
						_hasHpDrugCD=true;
					}else{
						setTimeout(onHpDrugCDComplete,cd.getRemainTime()+500);
						_hasHpDrugCD=true;
					}
				}
			}
			
			var mpPercent:Number = DataCenter.Instance.roleSelfVo.roleDyVo.mp/DataCenter.Instance.roleSelfVo.roleDyVo.maxMp *100;
			sendByPool=false;
			if(mpPercent<=70 && DataCenter.Instance.roleSelfVo.roleDyVo.hp>0 && DataCenter.Instance.roleSelfVo.mpPool>=DataCenter.Instance.roleSelfVo.roleDyVo.maxMp*0.2 && _hasMpPoolCD==false){//使用魔池
				MsgPool.sendGameMsg(GameCmd.CAddMPByPool,new CAddMPByPool());
				sendByPool = true;
				_hasMpPoolCD=true;
			}
			if(sendByPool==false && DataCenter.Instance.roleSelfVo.roleDyVo.hp>0 && mpPercent<mp_slider.value && mpPercent<100 && _hasMpDrugCD==false){//使用魔瓶
				pos = PropsDyManager.instance.getFirstMPDrugPos();
				if(pos>0){
					bvo = PropsBasicManager.Instance.getPropsBasicVo(PropsDyManager.instance.getPropsInfo(BagStoreManager.instantce.getPackInfoByPos(pos).id).templateId);
					cd = BagStoreManager.instantce.getCd(bvo.cd_type);
					if(cd==null){
						msg = new CUseItem();
						msg.itemPos = pos;
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
						setTimeout(onMpDrugCDComplete,bvo.cd_time+500);
						_hasMpDrugCD=true;
					}else{
						setTimeout(onMpDrugCDComplete,cd.getRemainTime()+500);
						_hasMpDrugCD=true;
					}
				}
			}
		}
		/**初始化只调用一次
		 */
		public function initView():void
		{
			_mc.player_name.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			onVipInit();
			updateHp();
			updateMp();
			updateLevel();
			updatePKMode();
			onRoleInfoChange();
		}
		/**不断调用 这个方法 
		 */
		public function updateInfo():void{		
			updateHp();
			updateMp();
//			updateLevel();
//			updatePKMode();
//			updatePool();
			onRoleInfoChange();
//			trace("handleIt");
		}
		
		/**更新血池魔池
		 */		
		public function updatePool():void{
			onRoleInfoChange();
		}
		
		public function updateHp():void{
			_mc.hp_tf.text=DataCenter.Instance.roleSelfVo.roleDyVo.hp+"/"+DataCenter.Instance.roleSelfVo.roleDyVo.maxHp;
			hp_progressBar.percent=DataCenter.Instance.roleSelfVo.roleDyVo.hp/DataCenter.Instance.roleSelfVo.roleDyVo.maxHp;
		}
		
		public function updateMp():void{
			_mc.mp_tf.text=DataCenter.Instance.roleSelfVo.roleDyVo.mp+"/"+DataCenter.Instance.roleSelfVo.roleDyVo.maxMp;
			mp_progressBar.percent=DataCenter.Instance.roleSelfVo.roleDyVo.mp/DataCenter.Instance.roleSelfVo.roleDyVo.maxMp;
		}
		
		public function updateLevel():void{
			_mc.level.text=DataCenter.Instance.roleSelfVo.roleDyVo.level+"";
		}
		
		public function updatePKMode():void{
			mode_button.label=TypeRole.getPKModeName(DataCenter.Instance.roleSelfVo.pkMode);
		}
		
		/**魔按钮点击
		 * @param e 
		 */
		private function onMpClick(e:MouseEvent):void{
			var bvo:PropsBasicVo = PropsBasicManager.Instance.getAllBasicVoByType(Mp_Pool_Type)[0];
			if((AutoSource.MP_POOL_MAX-DataCenter.Instance.roleSelfVo.mpPool)<bvo.attr_value){
				NoticeUtil.setOperatorNotice("魔法源泉还很充足，不需要补充！");
			}else{
				AutoManager.autoUseTempId= bvo.template_id;
				ModuleShop.instance.buyItemDirect(TypeProps.ITEM_TYPE_PROPS,AutoManager.autoUseTempId,1);
			}
		}
		
		/**血按钮点击
		 * @param e
		 */		
		private function onHpClick(e:MouseEvent):void{
			var bvo:PropsBasicVo = PropsBasicManager.Instance.getAllBasicVoByType(Hp_Pool_Type)[0];
			if((AutoSource.HP_POOL_MAX-DataCenter.Instance.roleSelfVo.hpPool)<bvo.attr_value){
				NoticeUtil.setOperatorNotice("生命源泉还很充足，不需要补充！");
			}else{
				AutoManager.autoUseTempId=bvo.template_id;
				ModuleShop.instance.buyItemDirect(TypeProps.ITEM_TYPE_PROPS,AutoManager.autoUseTempId,1);
			}
		}
		
		/**加载挂机设置完成
		 * @param e
		 */
		private function onLoadComplete(e:YFEvent):void{
			hp_slider.value = AutoManager.Instance.hpPercent;
			Xtip.registerLinkTip(hp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,hp_slider.value,"人物生命值","血瓶");
			mp_slider.value = AutoManager.Instance.mpPercent;
			Xtip.registerLinkTip(mp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,mp_slider.value,"人物魔法值","魔瓶");
			onRoleInfoChange();
		}
		
		/**HP划动
		 * @param e
		 */
		private function onHPSlide(e:Event):void{
			AutoManager.Instance.hpPercent = hp_slider.value;
			Xtip.registerLinkTip(hp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,hp_slider.value,"人物生命值","血瓶");
			var msg:CAutoConfigSave = new CAutoConfigSave();
			msg.configIntArr = new Array();
			var config:ConfigInt = new ConfigInt();
			config.configType = AutoSource.CT_HP_PERCENT;
			config.configValue = hp_slider.value;
			msg.configIntArr.push(config);
			YFEventCenter.Instance.dispatchEventWith(AutoEvent.SAVE,msg);
			onRoleInfoChange();
			//Xtip.showTipNow(hp_slider.drag);
		}
		
		/**MP划动
		 * @param e
		 */
		private function onMPSlide(e:Event):void{
			AutoManager.Instance.hpPercent = mp_slider.value;
			Xtip.registerLinkTip(mp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,mp_slider.value,"人物魔法值","魔瓶");
			var msg:CAutoConfigSave = new CAutoConfigSave();
			msg.configIntArr = new Array();
			var config:ConfigInt = new ConfigInt();
			config.configType = AutoSource.CT_MP_PERCENT;
			config.configValue = mp_slider.value;
			msg.configIntArr.push(config);
			YFEventCenter.Instance.dispatchEventWith(AutoEvent.SAVE,msg);
			onRoleInfoChange();
			//Xtip.showTipNow(mp_slider.drag);
		}
		
		/**更新队长图标 
		 */
		public function updateLeaderFlag():void{
			if(_mc.leaderImg.numChildren>0)	_mc.leaderImg.removeChildAt(0);
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==TeamDyManager.LeaderId)	_mc.leaderImg.addChild(ClassInstance.getInstance("leaderFlag") as MovieClip);
		}
		
		/**更新自己图标 
		 */
		public function updateIconImg():void{
			if(_mc.iconImg.numChildren>0)	_mc.iconImg.removeChildAt(0);
			IconLoader.initLoader(CharacterPointBasicManager.Instance.getShowURL(DataCenter.Instance.roleSelfVo.roleDyVo.career,DataCenter.Instance.roleSelfVo.roleDyVo.sex),_mc.iconImg,null,{x:8,y:8});
		}
		
		/**人物战斗模式按钮点击 
		 * @param e
		 */
		private function onModeChange(e:MouseEvent):void{
			if(!_menu){
				_menu = new Menu();
				_menu.withoutMouseDownClose.push(mode_button);
				_menu.txtX=5;
				_menu.setSize(60,0);
				_menu.addItem("和平模式",onMenuItemClick);
				//_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("工会模式",onMenuItemClick);
				//_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("善恶模式",onMenuItemClick);
				//_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("杀戮模式",onMenuItemClick);
			}
			if(_menu.isOpen)	_menu.hide();
			else	_menu.show(mode_button,10,20);
		}
		
		/**人物战斗模式按钮下拉选项 点击
		 * @param index		下拉框的位置，从0开始
		 * @param label		下拉框的文字label
		 */
		private function onMenuItemClick(index:uint,label:String):void{
			var msg:CSetHeroFightMode = new CSetHeroFightMode();
			switch(index){
				case 0:
					msg.fightMode = TypeRole.PKMode_Peace;
					break;
				case 1:
					msg.fightMode = TypeRole.PKMode_Sociaty;
					break;
				case 2:
					msg.fightMode = TypeRole.PKMode_JusticeEvil;
					break;
				case 3:
					msg.fightMode = TypeRole.PKMode_All;
					break;
			}
			YFEventCenter.Instance.dispatchEventWith(PKEvent.CFightModeChange,msg);
		}
	}
} 