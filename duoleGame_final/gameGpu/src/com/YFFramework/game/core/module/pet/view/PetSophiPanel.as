package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.pets.CPetSophi;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**宠物洗练面板
	 * @version 1.0.0
	 * creation time：2013-11-20 上午10:54:33
	 */
	public class PetSophiPanel extends Window{
		
		private static var _ins:PetSophiPanel;
		private var _mc:MovieClip;
		private var succ_button:Button;
		private var _propsImg:IconImage;
		private var _itemPos:int;
		private var _propsArr:Array;
		
		public function PetSophiPanel(){
			super(MinWindowBg);
			_mc = initByArgument(200,330,"PetSophi") as MovieClip;
			
			AutoBuild.replaceAll(_mc);
			succ_button = Xdis.getChild(_mc,"succ_button");
			succ_button.addEventListener(MouseEvent.CLICK,onSucc);
			
			_propsImg = Xdis.getChild(_mc,"props_iconImage");
			updateContent();
		}
		
		/**更新内容
		 */		
		public function updateContent():void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			if(pet){
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(pet.basicId);
				_mc.t1.text = pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]+"/"+pet.fightAttrs[TypeProps.BA_PHY_QLT_LIM];
				_mc.t2.text = pet.fightAttrs[TypeProps.BA_STRENGTH_APT]+"/"+pet.fightAttrs[TypeProps.BA_STR_QLT_LIM];
				_mc.t3.text = pet.fightAttrs[TypeProps.BA_AGILE_APT]+"/"+pet.fightAttrs[TypeProps.BA_AGI_QLT_LIM];
				_mc.t4.text = pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]+"/"+pet.fightAttrs[TypeProps.BA_INT_QLT_LIM];
				_mc.t5.text = pet.fightAttrs[TypeProps.BA_SPIRIT_APT]+"/"+pet.fightAttrs[TypeProps.BA_SPI_QLT_LIM];
				
				var props:PropsBasicVo = getAppProps(pet);
				if(props){
					_propsImg.url = PropsBasicManager.Instance.getURL(props.template_id);
					Xtip.registerLinkTip(_propsImg,PropsTip,TipUtil.propsTipInitFunc,0,props.template_id);
					_itemPos=PropsDyManager.instance.getFirstPropsPos(props.template_id);
					if(_itemPos!=0){
						_propsImg.filters=null;
					}else{
						_propsImg.filters=FilterConfig.dead_filter;
					}
				}else{
					_propsImg.clear();
					_itemPos=0;
				}
				updateMoneyTxt();
			}
		}
		
		/**获得对应的物品
		 * @param pet
		 * @return 
		 */		
		private function getAppProps(pet:PetDyVo):PropsBasicVo{
			if(_propsArr==null){
				_propsArr = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_SOPHI);
				_propsArr.sortOn("quality");
			}
			
			if(pet.quality>=TypeProps.QUALITY_WHITE && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<100 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<100 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<100 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<100 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<100)){
				return _propsArr[0];
			}else if(pet.quality>=TypeProps.QUALITY_GREEN && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<200 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<200 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<200 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<200 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<200)){
				return _propsArr[1];
			}else if(pet.quality>=TypeProps.QUALITY_BLUE && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<400 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<400 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<400 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<400 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<400)){
				return _propsArr[2];
			}else if(pet.quality>=TypeProps.QUALITY_BLUE && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<700 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<700 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<700 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<700 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<700)){
				return _propsArr[3];
			}else if(pet.quality>=TypeProps.QUALITY_ORANGE && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<1000 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<1000 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<1000 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<1000 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<1000)){
				return _propsArr[4];
			}else if(pet.quality>=TypeProps.QUALITY_RED && (pet.fightAttrs[TypeProps.BA_PHYSIQUE_APT]<1500 || pet.fightAttrs[TypeProps.BA_STRENGTH_APT]<1500 ||
				pet.fightAttrs[TypeProps.BA_AGILE_APT]<1500 ||pet.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]<1500 ||pet.fightAttrs[TypeProps.BA_SPIRIT_APT]<1500)){
				return _propsArr[5];
			}
			return null;
		}
		
		/**更新金钱状态
		 */		
		public function updateMoneyTxt():void{
			if(PetDyManager.crtPetId!=-1)	_mc.moneyTxt.text = "消耗银锭：1000";
			else	_mc.moneyTxt.text="";
			if(DataCenter.Instance.roleSelfVo.note<1000)	_mc.moneyTxt.textColor = TypeProps.COLOR_RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateSophiBtn();
		}
		
		/**更新按钮状态
		 */		
		public function updateSophiBtn():void{
			if(_itemPos!=0 && _mc.moneyTxt.textColor != TypeProps.COLOR_RED){
				succ_button.enabled=true;
			}else{
				succ_button.enabled=false;
			}
		}
		
		/**洗练按钮点击
		 * @param e
		 */		
		private function onSucc(e:MouseEvent):void{
			var msg:CPetSophi = new CPetSophi();
			msg.petId = PetDyManager.crtPetId;
			msg.itemPos = _itemPos;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.SuccReq,msg);
		}
		
		/**打开
		 */		
		override public function open():void{
			super.open();
			this.updateContent();
		}
		
		/**关闭
		 */		
		override public function close(event:Event=null):void{
			super.close();
		}
		
		/**设置tittle
		 */		
		override protected  function resetTitleBgLinkage():void{
			_titleBgLink=null;
		}
		/**设置关闭按钮
		 */		
		override protected function resetCloseLinkage():void{
			_closeButtonLinkage = null;
		}
		
		public static function get Instance():PetSophiPanel{
			return _ins ||= new PetSophiPanel();
		}
	}
} 