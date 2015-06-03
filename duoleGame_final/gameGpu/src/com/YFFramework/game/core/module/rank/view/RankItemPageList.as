package com.YFFramework.game.core.module.rank.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-6-18 下午1:32:05
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.rank.data.RankDyVo;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.dolo.common.PageItemListBase;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RankItemPageList extends PageItemListBase
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _txt1:TextField;
		private var _txt2:TextField;
		private var _txt3:TextField;
		private var _txt4:TextField;
		private var _txt5:TextField;
		
		private var _medal:Sprite;
		private var _type:int;
		private var _vipper1:Sprite;
		private var _vipper2:Sprite;
		private var _vipBtn:MovieClip;
		private var _vipClick:Boolean;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankItemPageList()
		{
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 子类覆盖此方法，显示Item内容 
		 * @param data
		 * @param view
		 * 
		 */
		override protected function initItem(data:Object,view:Sprite,index:int):void
		{
			_txt1=Xdis.getChild(view,"t1");
			_txt2=Xdis.getChild(view,"t2");
			_txt3=Xdis.getChild(view,"t3");
			_txt4=Xdis.getChild(view,"t4");
			_txt5=Xdis.getChild(view,"t5");
			_medal=Xdis.getChild(view,"medal");
			_vipper1=Xdis.getChild(view,"vipper1");
			_vipper2=Xdis.getChild(view,"vipper2");
			UI.removeAllChilds(_vipper1);
			UI.removeAllChilds(_vipper2);
			_vipClick=false;
			
			UI.removeAllChilds(_medal);
			var vo:RankDyVo=data as RankDyVo;
			if(vo.rankOrder == 1)
				_medal.addChild(ClassInstance.getInstance("rankGolden"));
			else if(vo.rankOrder == 2)
				_medal.addChild(ClassInstance.getInstance("rankSilver"));
			else if(vo.rankOrder == 3)
				_medal.addChild(ClassInstance.getInstance("rankCopper"));		
			
			//开始显示内容
			_txt1.text=vo.rankOrder.toString();//排名
			if(vo.rankConfigType == RankSource.TITLE_POWER11 || vo.rankConfigType == RankSource.TITLE_LEVEL21 ||
				vo.rankConfigType == RankSource.TITLE_MONEY31 || vo.rankConfigType >= RankSource.TITLE_ACTIVITY41)//(排名、)角色、职业、帮会、战斗力
			{
				_txt2.text=vo.playerName;
				initRoleVip(view,vo,_txt2);
				_txt3.text=TypeRole.getCareerName(vo.playerCareer);
				_txt4.text=vo.guildName;
				_txt5.text=vo.rankValue.toString();
			}
			else if(vo.rankConfigType == RankSource.TITLE_POWER12)//(排名、)宠物名称、主人、宠物等级、战斗力
			{
				_txt2.text=PetBasicManager.Instance.getPetConfigVo(vo.petConfigId).pet_type_name;
				_txt3.text=vo.playerName;
				initRoleVip(view,vo,_txt3);
				_txt4.text=vo.petLevel.toString();
				_txt5.text=vo.rankValue.toString();
			}			
		}
		
		//======================================================================
		//        private function
		//======================================================================
		/** 只有宠物主人名字后才显示黄钻，所以只有宠物的黄钻和其他不一样 */
		private function initRoleVip(view:Sprite,vo:RankDyVo,txt:TextField):void
		{	
			var vipper:Sprite;
			if(vo.rankConfigType == RankSource.TITLE_POWER12)
				vipper=Xdis.getChild(view,"vipper2");
			else
				vipper=Xdis.getChild(view,"vipper1");
			
			if(_vipBtn)
				_vipBtn.removeEventListener(MouseEvent.CLICK,onVipClick);
			
			var vipRes:String=TypeRole.getVipResName(vo.vipType,vo.vipLevel);
			if(vipRes != '')
			{				
				_vipBtn=ClassInstance.getInstance(vipRes);
				_vipBtn.buttonMode=true;
				vipper.x=txt.x+(txt.width+txt.textWidth)/2;
				vipper.y=txt.y;
				vipper.addChild(_vipBtn);
				_vipBtn.addEventListener(MouseEvent.CLICK,onVipClick);
			}
		}
		
		override protected function onItemClick(view:Sprite,vo:Object,index:int):void
		{
			if(_vipClick){
				_vipClick=false;
				return;
			}
			var rankBsVo:RankDyVo=vo as RankDyVo;
			if(rankBsVo.rankConfigType == RankSource.TITLE_POWER11)
			{
				ModuleManager.rankModule.otherPlayerReq(rankBsVo.characterId,true);
			}
			else if(rankBsVo.rankConfigType == RankSource.TITLE_POWER12)
			{
				ModuleManager.rankModule.otherPetReq(rankBsVo.petId);
			}
		}

		private function onVipClick(e:MouseEvent):void
		{
			_vipClick=true;
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);		
		}
		//======================================================================
		//        event handler
		//======================================================================

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 