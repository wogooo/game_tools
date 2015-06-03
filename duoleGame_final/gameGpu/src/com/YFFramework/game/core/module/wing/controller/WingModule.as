package com.YFFramework.game.core.module.wing.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.preview.event.PreviewEvent;
	import com.YFFramework.game.core.module.wing.event.WingEvent;
	import com.YFFramework.game.core.module.wing.view.WingWindow;
	import com.msg.hero.SUpdateWingLucky;
	import com.msg.item.CEnhanceEquipReq;
	import com.msg.item.CInlayGemReq;
	import com.msg.item.CRemoveGemReq;
	import com.msg.item.SEnhanceEquipRsp;
	import com.msg.item.SInlayGemRsp;
	import com.msg.item.SModifyWingEnhLevel;
	import com.msg.item.SRemoveGemRsp;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-9-27 上午10:20:16
	 */
	public class WingModule extends AbsModule{
		
		private var _window:WingWindow;
		
		public function WingModule(){
			_window = new WingWindow();
		}
		
		override public function init():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.WingUIClick,onWingClick);
			
			//翅膀进化请求
			YFEventCenter.Instance.addEventListener(WingEvent.LvUpWingReq,sendLvUpWing);	
			//翅膀羽毛请求
			YFEventCenter.Instance.addEventListener(WingEvent.FeatherReq,sendFeatherWing);
			//翅膀羽毛回复
			YFEventCenter.Instance.addEventListener(WingEvent.FeatherResp,onFeatherWingRsp);
			//翅膀进化回复
			YFEventCenter.Instance.addEventListener(WingEvent.LvUpWingResp,onSEnhanceEquipRsp);
			//翅膀移除羽毛请求
			YFEventCenter.Instance.addEventListener(WingEvent.FeatherRemoveReq,sendFeatherRemove);
			//翅膀移除羽毛回复
			YFEventCenter.Instance.addEventListener(WingEvent.FeatherRemoveResp,onSFeatherRemoveRsp);
			//背包改变回复
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);		
			//打开对应界面
			YFEventCenter.Instance.addEventListener(GlobalEvent.OPEN_FORGE_PANEL,openWingPanel);
			//翅膀预览关闭
			YFEventCenter.Instance.addEventListener(PreviewEvent.CloseRole,onPreviewClose);
			
			MsgPool.addCallBack(GameCmd.SModifyWingEnhLevel,SModifyWingEnhLevel,wingEnhLv);
			MsgPool.addCallBack(GameCmd.SUpdateWingLucky,SUpdateWingLucky,onUpdateWingLucky);	//坐骑星运改变
		}
		
		private function onPreviewClose(e:YFEvent):void
		{
			_window._wingLvUp.onClosePreview();
		}
		
		private function openWingPanel(e:YFEvent):void
		{
			var panelId:int=e.param as int;
			if(_window.isOpen == false)
			{
				_window.open();
				_window.openTab(panelId);
			}
			
		}
		
		/** 背包改变回复
		 * @param e
		 */		
		private function onBagChange(e:YFEvent):void{
			if(_window.isOpen && _window._tabs.nowIndex==1){
				_window._wingLvUp.initPanel();
			}else if(_window.isOpen && _window._tabs.nowIndex==2){
				_window._wingFeather.initPanel();
			}
		}
		
		/**翅膀星运改变回复
		 * @param msg
		 */		
		private function onUpdateWingLucky(msg:SUpdateWingLucky):void{
			CharacterDyManager.Instance.wingStarNum = Math.floor(msg.lucky/100);
			CharacterDyManager.Instance.wingLuckNum = msg.lucky%100;
			if(_window.isOpen && _window._tabs.nowIndex==1){
				_window._wingLvUp.initPanel();
			}
			if(msg.isLucky)
				_window._wingLvUp.showLuckEff();
		}
		
		/**羽毛移除请求
		 * @param e
		 */		
		private function sendFeatherRemove(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CRemoveGemReq,e.param as CRemoveGemReq);
		}
		
		/**羽毛移除回复
		 * @param e
		 */		
		private function onSFeatherRemoveRsp(e:YFEvent):void{
			var data:SRemoveGemRsp = SRemoveGemRsp(e.param);
			if(data.rsp == TypeProps.RSPMSG_SUCCESS){
				//NoticeManager.setNotice(NoticeType.Notice_id_1215);
				
			}else{
				NoticeUtil.setOperatorNotice("失败");
			}
			_window._wingFeather.initPanel();
		}
		
		/**羽毛镶嵌回复
		 * @param e
		 */		
		private function onFeatherWingRsp(e:YFEvent):void{
			var data:SInlayGemRsp = SInlayGemRsp(e.param);
			if(data.rsp == TypeProps.RSPMSG_SUCCESS){
				NoticeManager.setNotice(NoticeType.Notice_id_1215);
			}else{
				NoticeManager.setNotice(NoticeType.Notice_id_1216);
			}
			_window._wingFeather.initPanel();
		}
		
		/**装备强化回复
		 * @param e
		 */		
		private function onSEnhanceEquipRsp(e:YFEvent):void{
			var data:SEnhanceEquipRsp = SEnhanceEquipRsp(e.param);
			var equipDyVo:EquipDyVo;
			if(CharacterDyManager.Instance.getEquipInfoByPos(data.pos)){
				equipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(data.pos);
			}else{
				equipDyVo = EquipDyManager.instance.getEquipInfo(BagStoreManager.instantce.getPackInfoByPos(data.pos).id);	
			}
			equipDyVo.position = data.pos;
			_window._wingLvUp.onLvUpUpdate(equipDyVo);
			YFEventCenter.Instance.dispatchEventWith(WingEvent.WingLvUpBagUpdate,data.pos);
			
			if(data.rsp == TypeProps.RSPMSG_SUCCESS)	
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1217);
				_window._wingLvUp.showLvEff();
			}
			else	
				NoticeManager.setNotice(NoticeType.Notice_id_1218);
			_window._wingLvUp.checkAuto();
		}
		
		/**翅膀进化请求
		 * @param msg
		 */		
		private function wingEnhLv(msg:SModifyWingEnhLevel):void{
			EquipDyManager.instance.getEquipInfo(msg.equipId).template_id=msg.enhanceTmpid;
		}
		
		/**打开翅膀界面
		 * @param e
		 */		
		private function onWingClick(e:YFEvent):void{
			_window.switchOpenClose();
			if(_window.isOpen){
				_window.openTab(1);
			}
		}
		
		/**翅膀进化请求
		 * @param e
		 */		
		private function sendLvUpWing(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CEnhanceEquipReq,e.param as CEnhanceEquipReq);
		}
		
		/**羽毛镶嵌请求
		 * @param e
		 */		
		private function sendFeatherWing(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CInlayGemReq,e.param as CInlayGemReq);
		}
	}
} 