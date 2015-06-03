package com.YFFramework.game.core.module.bag.backPack
{
	/**
	 * 穿上装备、打开宠物蛋
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-7-24 上午10:43:48
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
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
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.newGuide.events.NewGuideEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CUseItem;
	import com.msg.storage.CPutToBodyReq;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class NewGuideUseItemWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		/** 装备
		 */
		private const EQUIP:int=1;
		/**宠物
		 */
		private const PetEGG:int=2;
		
		/**坐骑蛋
		 */
		private const MountEGG:int=3;
		
		/**翅膀
		 */
		private const WingEquip:int=4;
		
		
		private var _ui:Sprite;
		
		private var _info:ItemDyVo;
		private var _desc:TextField;
		private var _itemName:TextField;
		private var _icon:IconImage;
		private var _useBtn:Button;
		
		private var _type:int;//这里用个变量可以少做一些重复的搜索
		
		private static var _dict:Dictionary=new Dictionary();
		//======================================================================
		//        constructor
		//======================================================================
		
		
		/** 强制引导的 mc 
		 */
		private var _newGuideMovieClip:NewGuideMovieClip;
		
		/**前一步引导的内容  值 在  NewGuideStep
		 */
		private var _preGuideFlag:int=-1;
		public function NewGuideUseItemWindow()
		{
			super(MinWindowBg);
			_ui = initByArgument(205,208,"bagUI_putOnEquip");
			setContentXY(15,15);
			closeButton.visible=false;//这个方法只是暂时写的，等新手引导所有ui出来后再考虑要不要删
			tittleBgUI.visible=false;//这个方法只是暂时写的，等新手引导所有ui出来后再考虑要不要删
			
			_desc=Xdis.getChild(_ui,"txt1");
			_desc.selectable=false;
			_itemName=Xdis.getChild(_ui,"txt2");
			_itemName.selectable=false;
			_icon=Xdis.getChild(_ui,"icon_iconImage");
			_useBtn=Xdis.getChild(_ui,"use_button");
			_useBtn.addEventListener(MouseEvent.CLICK,onUse);

		}
		
		public static  function  getMyInstance(type:int,id:int):Boolean
		{
			var tmpId:int=0;
			if(type == TypeProps.ITEM_TYPE_EQUIP)
				tmpId = EquipDyManager.instance.getEquipInfo(id).template_id;
			else if(type == TypeProps.ITEM_TYPE_PROPS)
				tmpId = PropsDyManager.instance.getPropsInfo(id).templateId;
			if(_dict[type.toString()+tmpId.toString()] == null)
				return false;
			return true;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 暂定两个类型：PROPS_TYPE_PET_EGG:int = 4；ITEM_TYPE_EQUIP:int = 1;
		 * @param type 
		 */		
		public function init(info:ItemDyVo):void
		{
			if(info.type == TypeProps.ITEM_TYPE_EMPTY) return;
			
			var tmpId:int=0;
			if(info.type == TypeProps.ITEM_TYPE_EQUIP)
				tmpId = EquipDyManager.instance.getEquipInfo(info.id).template_id;
			else if(info.type == TypeProps.ITEM_TYPE_PROPS)
				tmpId = PropsDyManager.instance.getPropsInfo(info.id).templateId;
			var str:String=info.type.toString()+tmpId.toString();
			_dict[str]=info;
			
			_info=info;
			if(info.type == TypeProps.ITEM_TYPE_EQUIP)
			{
				_desc.text=NoticeUtils.getStr(NoticeType.Notice_id_100017);
				var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(info.id);
				var equipBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
				
				_icon.url=EquipBasicManager.Instance.getURL(equipDyVo.template_id);
				_itemName.text=equipBsVo.name;
				_useBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100018);
				Xtip.registerLinkTip(_icon,EquipTip,TipUtil.equipTipInitFunc,equipDyVo.equip_id,equipBsVo.template_id);
				
				if(equipBsVo.type!=TypeProps.EQUIP_TYPE_WINGS)
				{
					_type=EQUIP;
				}
				else  //设置   翅膀
				{
					_type=WingEquip;
				}
			}
			else if(info.type == TypeProps.ITEM_TYPE_PROPS)
			{
				var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(info.id);
				var propsBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
				if(propsBsVo.type == TypeProps.PROPS_TYPE_PET_EGG)
				{
					_desc.text=NoticeUtils.getStr(NoticeType.Notice_id_100019);
					_icon.url=PropsBasicManager.Instance.getURL(propsDyVo.templateId);
					_itemName.text=propsBsVo.name;
					_useBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100020);
					_type = PetEGG;
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,info.id,propsBsVo.template_id);
				}
				else if(propsBsVo.type == TypeProps.PROPS_TYPE_MOUNT_EGG)   //坐骑蛋进行处理
				{
					_desc.text=NoticeUtils.getStr(NoticeType.Notice_id_100071);
					_icon.url=PropsBasicManager.Instance.getURL(propsDyVo.templateId);
					_itemName.text=propsBsVo.name;
					_useBtn.label=NoticeUtils.getStr(NoticeType.Notice_id_100020); //点击孵化
					_type = MountEGG;
					Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,info.id,propsBsVo.template_id);

				}
			}
			postionWindow();
			
			if(_type==PetEGG)  //   强制引导 模态打洞
			{
//				initPetCreateGuide(); //引导宠物孵化
				NewGuideStep.PetGuideStep=NewGuideStep.CreatePet;
			}  
			else if(_type==MountEGG)
			{
//				initMountCreateGuide();  //坐骑复活引导
				NewGuideStep.MountGuideStep=NewGuideStep.CreateMount;
			}
			else if(_type==WingEquip)
			{
				NewGuideStep.WingGuideStep=NewGuideStep.WingGuideCreateWing;
			}
		}
		
		/**定位窗口
		 */
		private function postionWindow():void
		{
			LayerManager.WindowLayer.addChild(this);
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,resizeIt);
			resizeIt();
		}
		private function resizeIt(e:Event=null):void
		{
			x=StageProxy.Instance.getWidth()-this.width;
			y=StageProxy.Instance.getHeight()-this.height-50; 
		}
		
		
		/** 处理新手引导
		 */		
		override public function getNewGuideVo():*
		{
			var canTrigger:Boolean=false;
			if(_type==PetEGG)  //   强制引导 模态打洞
			{
				canTrigger=initPetCreateGuide(); //引导宠物孵化
				
			}  
			else if(_type==MountEGG)
			{
				canTrigger=initMountCreateGuide();  //坐骑复活引导
			}
			else if(_type==WingEquip)
			{
				canTrigger=initWingCreateGuide();  //坐骑复活引导
			}
			return canTrigger;
		}

		
		/**引导宠物孵化
		 */
		private  function initPetCreateGuide():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level==8||DataCenter.Instance.roleSelfVo.roleDyVo.level==9) //人物在  8 级别 或者 9级时候  显示  强制引导
			{
				if(NewGuideStep.PetGuideStep==NewGuideStep.CreatePet)
				{
					if(!_newGuideMovieClip)
					{
						var rect:Rectangle=getBtnRect(); 
						_newGuideMovieClip=NewGuideDrawHoleUtil.drawHole(rect.x,rect.y,rect.width,rect.height,_useBtn);
						_preGuideFlag=NewGuideStep.CreatePet;//孵化宠物
					}
					return true;
				}
			}
			return false;
		}
		/**坐骑引导 
		 */		
		private  function initMountCreateGuide():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level==16||DataCenter.Instance.roleSelfVo.roleDyVo.level==17) //人物在  8 级别 或者 9级时候  显示  强制引导
			{
				if(NewGuideStep.MountGuideStep==NewGuideStep.CreateMount)
				{
					if(!_newGuideMovieClip)
					{
						var rect:Rectangle=getBtnRect(); 
						_newGuideMovieClip=NewGuideDrawHoleUtil.drawHole(rect.x,rect.y,rect.width,rect.height,_useBtn);
						_preGuideFlag=NewGuideStep.CreateMount;//孵化宠物
						NewGuideStep.MountGuideStep=NewGuideStep.CreateMount;
					}
					return true;
				}

			}
			return false;
		}
		
		
		/**坐骑引导 
		 */		
		private  function initWingCreateGuide():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level==15||DataCenter.Instance.roleSelfVo.roleDyVo.level==16) //人物在  8 级别 或者 9级时候  显示  强制引导
			{
				if(NewGuideStep.WingGuideStep==NewGuideStep.WingGuideCreateWing)
				{
					if(!_newGuideMovieClip)
					{
						var rect:Rectangle=getBtnRect(); 
						_newGuideMovieClip=NewGuideDrawHoleUtil.drawHole(rect.x,rect.y,rect.width,rect.height,_useBtn);
						_preGuideFlag=NewGuideStep.WingGuideCreateWing;//孵化宠物
					}
					return true;
				}
				
			}
			return false;
		}

		/**获取使用按钮在事件坐标点位置
		 */
		private function getBtnRect():Rectangle
		{
			var pt:Point=UIPositionUtil.getRootPosition(_useBtn);
			
			return new Rectangle(pt.x,pt.y,_useBtn.width,_useBtn.height);
		}
		
		/**移除引导
		 */
		private function removeNewGuideModal():void
		{
			if(_newGuideMovieClip)
			{
				PopUpManager.removePopUp(_newGuideMovieClip);
				_newGuideMovieClip.release();
				_newGuideMovieClip=null;
				
				switch(_preGuideFlag)
				{
					case NewGuideStep.CreatePet:  //孵化宠物成功   下面进行引导宠物出战   在  PetIconView  进行引导宠物出战
						//进行宠物 出战
						NewGuideStep.PetGuideStep=NewGuideStep.PetFuncOpen;
						NewGuideManager.DoGuide();
						break;
					case NewGuideStep.CreateMount:  //引导坐骑
//						NewGuideStep.MountGuideStep=NewGuideStep.MountMainUIMountBtn;
						NewGuideStep.MountGuideStep=NewGuideStep.MountGuideFuncOpen;  //功能开启 
						NewGuideManager.DoGuide();
						break;
					case NewGuideStep.WingGuideCreateWing:
						NewGuideStep.WingGuideStep=NewGuideStep.WingGuideFunOpen; 
						NewGuideManager.DoGuide();
						break;
				}
			}
		}
		
		
		//======================================================================
		//        private function
		//======================================================================
		override public function dispose():void
		{
			UIManager.removeWindow(this);
//			var tmpId:int=0;
//			if(_info.type == TypeProps.ITEM_TYPE_EQUIP)
//				tmpId = EquipDyManager.instance.getEquipInfo(_info.id).template_id;
//			else if(_info.type == TypeProps.ITEM_TYPE_PROPS)
//				tmpId = PropsDyManager.instance.getPropsInfo(_info.id).templateId;
//			_dict[tmpId]=null;
//			delete _dict[tmpId];
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,resizeIt);


			super.dispose();
			UI.removeAllChilds(this);
			removeNewGuideModal();
			_desc=null;
			_itemName=null;
			
			Xtip.clearLinkTip(_icon);
			_icon.clear();
			_icon=null;
			
			_useBtn.removeEventListener(MouseEvent.CLICK,onUse);
			_useBtn=null;
			
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onUse(e:MouseEvent):void
		{
			var pos:int=0;
			if(_type == EQUIP||_type==WingEquip)
			{
				pos=EquipDyManager.instance.getEquipPosFromBag(_info.id);
				if(pos == 0) {
					dispose();
					return;
				}
				var equipDyVo:EquipDyVo=EquipDyManager.instance.getEquipInfo(_info.id);
				var equipBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id);
				
				var bodyMsg:CPutToBodyReq=new CPutToBodyReq();
				bodyMsg.sourcePos=pos;
				bodyMsg.targetPos=equipBsVo.type;
				YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CPutToBodyReq,bodyMsg);
			}
			else if(_type == PetEGG||_type==MountEGG)
			{
				pos=PropsDyManager.instance.getPropsPosFromBag(_info.id);
				if(pos == 0) {
					dispose();
					return;
				}
				var msg:CUseItem=new CUseItem();
				msg.itemPos=pos;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
			}
			
			dispose();
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 