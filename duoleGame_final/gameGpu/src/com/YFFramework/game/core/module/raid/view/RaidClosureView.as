package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.core.module.raid.manager.RaidRewardManager;
	import com.YFFramework.game.core.module.raid.model.RaidGradeTypes;
	import com.YFFramework.game.core.module.raid.model.RaidRewardVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.MoneyType;
	import com.msg.raid_pro.CFetchRaidReward;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-11-6 下午4:26:33
	 */
	public class RaidClosureView extends Window{
		
		private var _mc:MovieClip;
		private var _cardMovieViewArray:Array;
		private var _cardIndex:int;
		private var _hasReward:Boolean;
		private var _basicRewardId:int;
		private var _rewardId:int;
		private var _iconsArr:Array;
		private var _grade:int;
		public var hasDisposed:Boolean;
		
		public function RaidClosureView(){
			_mc = initByArgument(700,400,"raidClosureView",WindowTittleName.titleRaidClosure) as MovieClip;
			AutoBuild.replaceAll(_mc);
			
			_cardMovieViewArray = new Array();
			_cardIndex=-1;
			_hasReward=false;
			hasDisposed = false;
			_iconsArr = new Array();
			for(var i:int=0;i<=4;i++){
				_iconsArr.push(Xdis.getChild(_mc,"item"+i+"_iconImage") as IconImage);
			}
		}
		
		/**更新并打开界面
		 * @param grade
		 */		
		public function updateGrade(grade:int):void{
			_grade = grade;
			switch(grade){
				case RaidGradeTypes.RAID_GRADE_A://A grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("aRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_B://B grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("bRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_C://C grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("cRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_D://D grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("dRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_E://E grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("eRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_S://S grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("sRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_SS://SS grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("ssRank")));
					break;
				case RaidGradeTypes.RAID_GRADE_SSS://SSS grade
					_mc.ranking.addChild(new Bitmap(ClassInstance.getInstance("sssRank")));
					break;
			}
			var cardMovieView:CardMovieView;
			for(var i:int=0;i<=4;i++){
				cardMovieView= new CardMovieView(i);
				cardMovieView.addEventListener(MouseEvent.CLICK,onClick);
				_cardMovieViewArray.push(cardMovieView);
				_mc["i"+i].addChild(cardMovieView);
			}
			this.open();
		}
		
		/**更新奖励
		 * @param basicId
		 */		
		public function updateReward(basicId:int):void{
			_basicRewardId = basicId;
			_hasReward=true;
			if(_cardIndex==-1)
			{
				var len:int=_cardMovieViewArray.length;
				_cardIndex=len*Math.random()
			}
			_cardMovieViewArray[_cardIndex].playToEnd(1,onComplete);
		}
		
		/**翻牌完成
		 * @param obj
		 */		
		private function onComplete(obj:Object=null):void{
			if(_mc){
				var vo:RaidRewardVo = RaidRewardManager.Instance.getRaidRewardVo(_basicRewardId);
				_rewardId = vo.rewardId;
				if(vo.itemType==RewardTypes.EQUIP){
					var equipVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.itemId);
					_iconsArr[_cardIndex].url = EquipBasicManager.Instance.getURL(vo.itemId);
					_mc["t"+_cardIndex].text = equipVo.name +"x" + vo.itemNumber;
				}else if(vo.itemType==RewardTypes.PROPS){
					var propsVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(vo.itemId);
					_iconsArr[_cardIndex].url = PropsBasicManager.Instance.getURL(vo.itemId);
					_mc["t"+_cardIndex].text = propsVo.name + "x"+vo.itemNumber;
				}
				else{
					_iconsArr[_cardIndex].url = URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(vo.itemType));
					_mc["t"+_cardIndex].text = RewardTypes.getTypeStr(vo.itemType)+"x"+vo.itemNumber;
				}
				var len:int = _cardMovieViewArray.length;
				var isFirst:Boolean=false;
				for(var i:int=0;i<len;i++){
					if(i!=_cardIndex){
						if(isFirst==false){
							_cardMovieViewArray[i].playToEnd(1,onOtherComplete);
							isFirst=true;
						}else{
							_cardMovieViewArray[i].playToEnd();
						}
					}
				}
			}
		}
		
		/**其他翻牌完成
		 * @param obj
		 */		
		private function onOtherComplete(obj:Object=null):void{
			if(_mc){
				var arr:Array = RaidRewardManager.Instance.getRaidRewardVoArray(_rewardId,_grade);
				var len:int=arr.length;
				for(var i:int=0;i<len;i++){
					if(arr[i].basicId==_basicRewardId){
						arr.splice(i,1);
						break;
					}
				}
				if(_cardMovieViewArray){
					len = _cardMovieViewArray.length;
					for(i=0;i<len;i++){
						if(i!=_cardIndex){
							var index:int = Math.round(Math.random()*(arr.length-1));
							
							var vo: RaidRewardVo = RaidRewardVo(arr[index]);
							if(vo.itemType==RewardTypes.EQUIP){
								var equipVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.itemId);
								_iconsArr[i].url = EquipBasicManager.Instance.getURL(vo.itemId);
								_mc["t"+i].text = equipVo.name +"x" + vo.itemNumber;
							}else if(vo.itemType==RewardTypes.PROPS){
								var propsVo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(vo.itemId);
								_iconsArr[i].url = PropsBasicManager.Instance.getURL(vo.itemId);
								_mc["t"+i].text = propsVo.name + "x"+vo.itemNumber;
							}
							else
							{
								_iconsArr[i].url = URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(vo.itemType));
								_mc["t"+i].text = RewardTypes.getTypeStr(vo.itemType)+"x"+vo.itemNumber;
							}
							arr.splice(index,1);
						}
					}
				}
			}
		}
		
		/**更新时间
		 * @param time
		 */		
		public function updateTime(time:int):void{
			if(_mc)
			{
				_mc.timeTxt.text=time;
			}
		}
		
		/**点击牌面
		 * @param e
		 */		
		private function onClick(e:MouseEvent):void{
			var len:int=_cardMovieViewArray.length;
			for(var i:int=0;i<len;i++){
				_cardMovieViewArray[i].removeEventListener(MouseEvent.CLICK,onClick);
			}
			_cardIndex = e.currentTarget.index;
			YFEventCenter.Instance.dispatchEventWith(RaidEvent.FetchRaidReward,new CFetchRaidReward());
		}
		
		/**关闭窗口
		 * @param event
		 */		
		override public function close(event:Event=null):void{
			if(_hasReward==false){
				YFEventCenter.Instance.dispatchEventWith(RaidEvent.FetchRaidReward,new CFetchRaidReward());
				hasDisposed = true;
			}
			super.close();
			this.dispose();
		}
		
		override public function dispose():void{
			super.dispose();  ///此处内部是一个递归 会调用各个UI的dipose方法 
			_mc = null;
			_cardMovieViewArray = null;
			_iconsArr = null;
		}
	}
} 