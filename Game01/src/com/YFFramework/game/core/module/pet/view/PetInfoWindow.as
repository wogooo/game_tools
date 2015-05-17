package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFHolder;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFTextInput;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.SkinManager;
	import com.YFFramework.game.core.global.model.SkinVo;
	import com.YFFramework.game.core.module.pet.manager.PetBasicManager;
	import com.YFFramework.game.core.module.pet.model.PetBasicVo;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	
	/** 宠物的详细信息面板
	 * 2012-9-27 下午1:24:43
	 *@author yefeng
	 */
	public class PetInfoWindow extends GameWindow
	{
		/**宠物面板
		 */		
		private var _petDyVo:PetDyVo;
		/**宠物显示观看对象
		 */ 
		private var _avatar:BitmapMovieClip;
		/**姓名 标签
		 */		
		private var _nameLabel:YFTextInput;
		/** 改 标签  用于改名称
		 */		
		private var _gaiBtn:YFButton;
		/**等级
		 */
		private var _levelLabel:YFLabel;
		/**等级值的标签
		 */		
		private var _levelValueLabel:YFLabel;
		/**品质标签
		 */		
		private var _qualityLabel:YFLabel;
		/**  品质值标签
		 */		
		private var _qualityValueLabel:YFLabel;
		/**经验
		 */		
		private var _expLabel:YFLabel;
		/**经验 值标签
		 */		
		private var _expValueLabel:YFLabel;
		/**默认技能标签 
		 */
		private var _defaultSkillLabel:YFLabel;
		/**默认技能的那个框
		 */		
		private var _defaultSkillFrame:YFHolder;
		/** 生命
		 */		
		private var _hpLabel:YFLabel;
		/**生命值
		 */		
		private var _hpValueLabel:YFLabel;
		/**物攻
		 */		
		private var _pAtkLabel:YFLabel;
		/**物攻值
		 */		
		private var _pAtkValueLabel:YFLabel;
		/**物防
		 */		
		private var _pDefenseLabel:YFLabel;
		/** 物理防御值
		 */		
		private var _pDefenseValueLabel:YFLabel;
		/**法攻
		 */		
		private var _mAtkLabel:YFLabel;
		/**法攻值
		 */		
		private var _mAtkValue:YFLabel; 
		/**法防
		 */		
		private var _mDefenseLabel:YFLabel;
		/**法防值
		 */		
		private var _mDefenseValueLabel:YFLabel;
		
		
		public function PetInfoWindow()
		{
			super(270, 380);
		}
		
		/**重新赋值
		 */ 
		public function initData(petDyVo:PetDyVo):void
		{
			_avatar.bitmapData=null;
			_petDyVo=petDyVo;
			
			////初始化图象
			var basicVo:PetBasicVo=PetBasicManager.Instance.getPetBasicVo(_petDyVo.basicId);
			var skinVo:SkinVo=SkinManager.Instance.getSkinVo(basicVo.resId);
			var url:String=URLTool.getMonster(skinVo.normalSkinId);///获取宠物的皮肤
			SourceCache.Instance.addEventListener(url,loadComplete);
			SourceCache.Instance.loadRes(url);
			////
			
			
		}
		/**加载完成
		 */
		private function loadComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			var actionData:ActionData=SourceCache.Instance.getRes(url) as ActionData;
			_avatar.initData(actionData);
			_avatar.play(TypeAction.Stand,TypeDirection.Down,true);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			///avatar
			_avatar=new BitmapMovieClip();
			_avatar.start();
			addChild(_avatar);
			_avatar.setPivotXY(70,_bgBody.y+150);
			//名称
			_nameLabel=new YFTextInput("姓名",3);///该姓名 二字  会在 该类初始化 传入数据时 被覆盖掉
			_nameLabel.width=55;
			addContent(_nameLabel,170,35);
			_gaiBtn=new YFButton(Lang.Gai);
			addContent(_gaiBtn,233,34);
			_gaiBtn.width=30;
			_levelLabel=new YFLabel(Lang.DengJi);
			addContent(_levelLabel,170,60);
			_levelValueLabel=new YFLabel("1");
			addContent(_levelValueLabel,210,60);
			_qualityLabel=new YFLabel(Lang.PingZhi);
			addContent(_qualityLabel,170,80);
			_qualityValueLabel=new YFLabel(getQualityName(0),1,12,0xFF00FF);///将要被覆盖的值
			addContent(_qualityValueLabel,210,80);
			_expLabel=new YFLabel(Lang.JingYan);
			addContent(_expLabel,170,100);
			_expValueLabel=new YFLabel("1%");
			addContent(_expValueLabel,210,100);
			_defaultSkillLabel=new YFLabel(Lang.MoRenJiNeng);///默认技能
			addContent(_defaultSkillLabel,170,120);
			_defaultSkillFrame=new YFHolder(41,42,2)
			addContent(_defaultSkillFrame,170,140);
			_hpLabel=new YFLabel(Lang.ShengMing);
			addContent(_hpLabel,20,230);
			_hpValueLabel=new YFLabel("33");
			addContent(_hpValueLabel,60,230);
			_pAtkLabel=new YFLabel(Lang.WuGong);
			addContent(_pAtkLabel,20,260);
			_pAtkValueLabel=new YFLabel("222");
			addContent(_pAtkValueLabel,60,260);
			_pDefenseLabel=new YFLabel(Lang.WuFang); ///物防 
			addContent(_pDefenseLabel,120,260);
			_pDefenseValueLabel=new YFLabel("222");
			addContent(_pDefenseValueLabel,170,260);
			_mAtkLabel=new YFLabel(Lang.FaGong);//法攻
			addContent(_mAtkLabel,20,290);
			_mAtkValue=new YFLabel("222"); ///法攻值 
			addContent(_mAtkValue,60,290);
			_mDefenseLabel=new YFLabel(Lang.FaFang); ///法防标签
			addContent(_mDefenseLabel,120,290);
			_mDefenseValueLabel=new YFLabel("222");
			addContent(_mDefenseValueLabel,170,290);
			
		}
		override protected function addEvents():void
		{
			super.addEvents();
		}
		/** 得到品质信息  ： 多少星级  还是优秀
		 * @return
		 */		
		private function getQualityName(quality:int):String
		{
			if(quality==0) return Lang.YouXiu;////优秀
			else if(quality>0) ///品质大于0
			{
				return Lang.JiPin+quality+Lang.xing;
			}
			return null;
		}
		/**
		 */		
		public function update():void
		{
			
		}
		
	}
}