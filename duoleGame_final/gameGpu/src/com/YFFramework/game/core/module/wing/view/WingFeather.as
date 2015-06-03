package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.wing.event.WingEvent;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.CInlayGemReq;
	import com.msg.item.CRemoveGemReq;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-25 下午1:20:11
	 */
	public class WingFeather{
		
		private var _mc:MovieClip;
		private var _wingTabs:TabsManager;
		private var _mainWing:IconImage;
		private var _featherIcons:Vector.<IconImage>=new Vector.<IconImage>();
		
		private var _selfEquip:Boolean=false;
		private var _mainWingDyVo:EquipDyVo;
		private var _pageCtrl:WingFeatherPageCtrl;
		
		public function WingFeather(mc:MovieClip){
			_mc=mc;
			AutoBuild.replaceAll(_mc);
			
			_pageCtrl = new WingFeatherPageCtrl(_mc);
			
			_mainWing = Xdis.getChild(_mc,"wing_iconImage");
			
			for(var i:int=0;i<=5;i++){
				_featherIcons.push(Xdis.getChild(_mc,"f"+i+"_iconImage") as IconImage);
				var sp:Sprite = new Sprite();
				sp.graphics.beginFill(0,0);
				sp.graphics.drawRect(0,0,38,38);
				sp.graphics.endFill();
				_featherIcons[i].addChildAt(sp,0);
				_featherIcons[i].addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		/**鼠标弹起事件
		 * @param e
		 */		
		private function onMouseUp(e:MouseEvent):void{
			var icon:IconImage = e.currentTarget as IconImage;
			if(icon.url!="" && icon.url!=null){
				var cMsg:CRemoveGemReq = new CRemoveGemReq();
				if(_mainWingDyVo.gem_1_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=1;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
				if(_mainWingDyVo.gem_2_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=2;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
				if(_mainWingDyVo.gem_3_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=3;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
				if(_mainWingDyVo.gem_4_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=4;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
				if(_mainWingDyVo.gem_5_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=5;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
				if(_mainWingDyVo.gem_6_id>0){
					if(_selfEquip==true)	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
					else	cMsg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
					cMsg.inlayPos=6;
					YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherRemoveReq,cMsg);
				}
			}else{
				var fromData:DragData = DragManager.Instance.dragVo as DragData;
				if(fromData){
					if(fromData.type==DragData.FROM_WING){
						var vo:PropsDyVo = PropsDyManager.instance.getPropsInfo(fromData.data.id);
						if(!isFeatherAddable(vo.templateId)){
							NoticeUtil.setOperatorNotice("同类的羽毛只能镶嵌一颗！");
							return;
						}
						var msg:CInlayGemReq = new CInlayGemReq();
						
						if(_selfEquip==true)	msg.equipPos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
						else	msg.equipPos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
						msg.gemPos = PropsDyManager.instance.getFirstPropsPos(vo.templateId);
						msg.inlayPos = getFeatherPos(icon)+1;
						YFEventCenter.Instance.dispatchEventWith(WingEvent.FeatherReq,msg);
					}
				}
			}
		}
		/**获得羽毛位置
		 * @param icon
		 * @return 
		 */		
		private function getFeatherPos(icon:IconImage):int{
			for(var i:int=0;i<6;i++){
				if(_featherIcons[i]==icon){
					return i;
				}
			}
			return -1;
		}
		
		/**初始化窗口 
		 */		
		public function initPanel():void{
			for(var i:int=0;i<6;i++){
				_featherIcons[i].clear();
				if(_featherIcons[i].numChildren<2){
					var sp:Sprite = new Sprite();
					sp.graphics.beginFill(0,0);
					sp.graphics.drawRect(0,0,38,38);
					sp.graphics.endFill();
					_featherIcons[i].addChildAt(sp,0);
				}
			}
			
			var _das:Vector.<PropsDyVo>=new Vector.<PropsDyVo>();
			var arr:Array = PropsDyManager.instance.getPropsArray();
			var len:int = arr.length;
			for(i=0;i<len;i++){
				var bvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(arr[i].templateId);
				if(bvo.type == TypeProps.PROPS_TYPE_FEATHER){
					_das.push(arr[i]);
				}
			}
			_pageCtrl.updateList(_das);
			
			var vo:EquipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);
			if(vo==null){
				arr = BagStoreManager.instantce.getAllPackArray();
				len = arr.length;
				for(i=0;i<arr.length;i++){
					if(arr[i].type==TypeProps.ITEM_TYPE_EQUIP){
						vo = EquipDyManager.instance.getEquipInfo(arr[i].id);
						var ebvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
						if(ebvo.type==TypeProps.EQUIP_TYPE_WINGS){
							_mainWingDyVo = vo;
							_selfEquip = false;
						}
					}
				}
			}else{
				_mainWingDyVo = vo;
				_selfEquip = true;
			}
			
			if(_mainWingDyVo==null){
				_mainWing.clear();
				Xtip.clearLinkTip(_mainWing);
				_mc.wingTxt.text="";
				for(i=0;i<9;i++){
					_mc["t"+i].text="";
				}
			}else{
				_mainWing.url = EquipBasicManager.Instance.getURL(_mainWingDyVo.template_id);
				Xtip.registerLinkTip(_mainWing,EquipTip,TipUtil.equipTipInitFunc,_mainWingDyVo.equip_id,_mainWingDyVo.template_id,_selfEquip);
				_mc.wingTxt.text=EquipBasicManager.Instance.getEquipBasicVo(_mainWingDyVo.template_id).name;
				
				ebvo = EquipBasicManager.Instance.getEquipBasicVo(_mainWingDyVo.template_id);
				
				if(ebvo.base_attr_t1!=0){
					_mc.t0.text = TypeProps.getAttrName(ebvo.base_attr_t1)+":+"+ebvo.base_attr_v1+"%";//bvo.base_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					_mc.t5.text = "+"+getExtraAtt(ebvo.base_attr_t1)+"%";
				}
				else{
					_mc.t0.text="";
					_mc.t5.text="";
				}
				if(ebvo.base_attr_t2!=0){
					_mc.t1.text = TypeProps.getAttrName(ebvo.base_attr_t2)+":+"+ebvo.base_attr_v2+"%";//bvo.base_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					_mc.t6.text = "+"+getExtraAtt(ebvo.base_attr_t2)+"%";
				}
				else{
					_mc.t1.text="";
					_mc.t6.text="";
				}
				if(ebvo.base_attr_t3!=0){
					_mc.t2.text = TypeProps.getAttrName(ebvo.base_attr_t3)+":+"+ebvo.base_attr_v3+"%";//bvo.base_attr_v3*10000*_mainWingDyVo.enhance_level+"%";
					_mc.t7.text = "+"+getExtraAtt(ebvo.base_attr_t3)+"%";
				}
				else{
					_mc.t2.text="";
					_mc.t7.text="";
				}
				if(ebvo.app_attr_t1!=0){
					_mc.t3.text = TypeProps.getAttrName(ebvo.app_attr_t1)+":+"+ebvo.app_attr_v1+"%";//bvo.app_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					_mc.t8.text = "+"+getExtraAtt(ebvo.app_attr_t1)+"%";
				}
				else{
					_mc.t3.text="";
					_mc.t8.text="";
				}
				if(ebvo.app_attr_t2!=0){
					_mc.t4.text = TypeProps.getAttrName(ebvo.app_attr_t2)+":+"+ebvo.app_attr_v2+"%";//bvo.app_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					_mc.t9.text = "+"+getExtraAtt(ebvo.app_attr_t2)+"%";
				}
				else{
					_mc.t4.text="";
					_mc.t9.text="";
				}
				
				if(_mainWingDyVo.gem_1_id>0){
					_featherIcons[0].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_1_id);
					Xtip.registerLinkTip(_featherIcons[0],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_1_id);
				}
				if(_mainWingDyVo.gem_2_id>0){
					_featherIcons[1].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_2_id);
					Xtip.registerLinkTip(_featherIcons[1],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_2_id);
				}
				if(_mainWingDyVo.gem_3_id>0){
					_featherIcons[2].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_3_id);
					Xtip.registerLinkTip(_featherIcons[2],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_3_id);
				}
				if(_mainWingDyVo.gem_4_id>0){
					_featherIcons[3].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_4_id);
					Xtip.registerLinkTip(_featherIcons[3],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_4_id);
				}
				if(_mainWingDyVo.gem_5_id>0){
					_featherIcons[4].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_5_id);
					Xtip.registerLinkTip(_featherIcons[4],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_5_id);
				}
				if(_mainWingDyVo.gem_6_id>0){
					_featherIcons[5].url = PropsBasicManager.Instance.getURL(_mainWingDyVo.gem_6_id);
					Xtip.registerLinkTip(_featherIcons[5],PropsTip,TipUtil.propsTipInitFunc,0,_mainWingDyVo.gem_6_id);
				}
			}
		}
		/**获得额外属性
		 * @param attr_id
		 * @return 
		 */		
		private function getExtraAtt(attr_id:int):int{
			var extra:int=0;
			var bvo:PropsBasicVo;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_1_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_2_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_3_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_4_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_5_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			bvo=PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_6_id);
			if(bvo && bvo.attr_type==attr_id)	extra+=bvo.attr_value;
			return extra;
		}

		/**查看羽毛能否镶嵌；同一类型的羽毛不能再镶嵌
		 * @param templateId
		 * @return 
		 */		
		private function isFeatherAddable(templateId:int):Boolean{
			var bvo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(templateId);
			if(_mainWingDyVo.gem_1_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_1_id).attr_type==bvo.attr_type){
				return false;
			}
			if(_mainWingDyVo.gem_2_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_2_id).attr_type==bvo.attr_type){
				return false;
			}
			if(_mainWingDyVo.gem_3_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_3_id).attr_type==bvo.attr_type){
				return false;
			}
			if(_mainWingDyVo.gem_4_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_4_id).attr_type==bvo.attr_type){
				return false;
			}
			if(_mainWingDyVo.gem_5_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_5_id).attr_type==bvo.attr_type){
				return false;
			}
			if(_mainWingDyVo.gem_6_id>0 && PropsBasicManager.Instance.getPropsBasicVo(_mainWingDyVo.gem_6_id).attr_type==bvo.attr_type){
				return false;
			}
			return true;
		}
	}
} 