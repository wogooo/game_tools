package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.lang.Lang;
	
	/** 人物 角色主面板
	 * 2012-8-22 上午9:54:25
	 *@author yefeng
	 */
	public class CharacterBodyView extends AbsUIView
	{
		protected var _gridsView:BodyGridsView;
		
		/**职业 
		 */		
		protected var _carrerLabel:YFLabel;
		protected var _carrerText:YFLabel;
		/**等级
		 */		
		protected var _levelLabel:YFLabel;
		protected var _levelText:YFLabel;
		/**性别
		 */		
		protected var _sexLabel:YFLabel;
		protected var _sexText:YFLabel;

		/**所属阵营
		 */		
		protected var _groupLabel:YFLabel;
		protected var _groupText:YFLabel;

		/**称号
		 */		
		protected var _chenghaoLabel:YFLabel;
		protected var _chenghaoText:YFLabel;

		/**伴侣
		 */
		protected var _banlvLabel:YFLabel;
		protected var _banlvText:YFLabel;
		
		/**爵位
		 */		
		protected var _jueWeiLabel:YFLabel;
		protected var _jueWeiText:YFLabel;
		/**物攻
		 */
		protected var _wuGongLabel:YFLabel;
		protected var _wuGongText:YFLabel;
		/**物防
		 */
		protected var _wuFangLabel:YFLabel;
		protected var _wuFangText:YFLabel;
		/**法攻
		 */		
		protected var _faGongLabel:YFLabel;
		protected var _faGongText:YFLabel;
		/**法防
		 */		
		protected var _faFangLabel:YFLabel;
		protected var _faFangText:YFLabel;
		/**pk值
		 */		
		protected var _pkLabel:YFLabel;
		protected var _pkText:YFLabel;
		
		public function CharacterBodyView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_gridsView=new BodyGridsView();
			addChild(_gridsView);
			_gridsView.y=80;
			initLabel();
			
		}
		override protected function addEvents():void
		{
			super.addEvents();
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
		}
		
		protected function initLabel():void
		{
			///职业
			_carrerLabel=new YFLabel(Lang.ZhiYe+":",1,12,0xDDDDDD);
			_carrerText=new YFLabel(Lang.XinShou,1,12,0xFFCC99);
			addChild(_carrerLabel);
			addChild(_carrerText);
			///等级
			_levelLabel=new YFLabel(Lang.DengJi+":",1,12,0xDDDDDD);
			_levelText=new YFLabel("5",1,12,0xFFCC99);
			addChild(_levelLabel);
			addChild(_levelText);
			///性别 
			_sexLabel=new YFLabel(Lang.XingBie+":",1,12,0xDDDDDD);
			_sexText=new YFLabel(Lang.Nan,1,12,0xFFCC99);
			addChild(_sexLabel);
			addChild(_sexText);
			///帮派
			_groupLabel=new YFLabel(Lang.BangPai+":",1,12,0xDDDDDD);
			_groupText=new YFLabel(Lang.ZhanWeiJiaRu,1,12,0xFFCC99);
			addChild(_groupLabel);
			addChild(_groupText);
			_chenghaoLabel=new YFLabel(Lang.ChengHao+":",1,12,0xDDDDDD);
			_chenghaoText=new YFLabel(Lang.ZhanWeiHuoDe,1,12,0xFFCC99);
			addChild(_chenghaoLabel);
			addChild(_chenghaoText);
			_banlvLabel=new YFLabel(Lang.BanLv+":",1,12,0xDDDDDD);
			_banlvText=new YFLabel(Lang.Wu,1,12,0xFFCC99); 
			addChild(_banlvLabel);
			addChild(_banlvText);
			///爵位
			_jueWeiLabel=new YFLabel(Lang.JueWei+":",1,12,0xDDDDDD);
			_jueWeiText=new YFLabel(Lang.PingMin,1,12,0xFFCC99);
			addChild(_jueWeiLabel);
			addChild(_jueWeiText);
			//物攻
			_wuGongLabel=new YFLabel(Lang.WuGong+":",1,12,0xDDDDDD);
			_wuGongText=new YFLabel("333",1,12,0xFFCC99);
			addChild(_wuGongLabel);
			addChild(_wuGongText);
			//物防
			_wuFangLabel=new YFLabel(Lang.WuFang+":",1,12,0xDDDDDD);
			_wuFangText=new YFLabel("222",1,12,0xFFCC99);
			addChild(_wuFangLabel);
			addChild(_wuFangText);
			//法攻	
			_faGongLabel=new YFLabel(Lang.FaGong+":",1,12,0xDDDDDD);
			_faGongText=new YFLabel("333",1,12,0xFFCC99);
			addChild(_faGongLabel);
			addChild(_faGongText);
			//法防	
			_faFangLabel=new YFLabel(Lang.FaFang+":",1,12,0xDDDDDD);
			_faFangText=new YFLabel("333",1,12,0xFFCC99);
			addChild(_faFangLabel);
			addChild(_faFangText);
			//pk值
			 _pkLabel=new YFLabel(Lang.PKZhi+":",1,12,0xDDDDDD);
			_pkText=new YFLabel("333",1,12,0xFFCC99);
			addChild(_pkLabel);
			addChild(_pkText);
			///进行定位
			////职业
			_carrerLabel.x=0;
			_carrerText.x=_carrerLabel.x+_carrerLabel.textWidth+10;
			_carrerText.y=_carrerLabel.y=7;
			///等级
			_levelLabel.x=_carrerLabel.x;
			_levelText.x=_carrerText.x;	
			_levelText.y=_levelLabel.y=_carrerLabel.y+_carrerLabel.textHeight+5;
			
			//性别
			_sexLabel.x=_carrerLabel.x+80;
			_sexText.x=_sexLabel.x+_sexLabel.textWidth+10;
			_sexText.y=_sexLabel.y=_carrerLabel.y;
			/// 阵营
			_groupLabel.x=_sexLabel.x;
			_groupText.x=_groupLabel.x+_groupLabel.textWidth+10;
			_groupText.y=_groupLabel.y=_levelText.y;
			
			///称号
			_chenghaoLabel.x=_sexLabel.x+100
			_chenghaoText.x=_chenghaoLabel.x+_chenghaoLabel.textWidth+10;
			_chenghaoText.y=_chenghaoLabel.y=_carrerLabel.y;
			/// 伴侣
			_banlvLabel.x=_chenghaoLabel.x;
			_banlvText.x=_chenghaoText.x;
			_banlvText.y=_banlvLabel.y=_groupLabel.y;
			
			////爵位 
			var hSpace:int=10;
			var vSpace:int=10;
			_jueWeiLabel.x=265;
			_jueWeiText.x=_jueWeiLabel.x+_jueWeiLabel.textWidth+hSpace;
			_jueWeiText.y=_jueWeiLabel.y=80;
			
			_wuGongLabel.x=_jueWeiLabel.x;
			_wuGongText.x=_jueWeiText.x;
			_wuGongLabel.y=_wuGongText.y=_jueWeiLabel.y+_jueWeiLabel.textHeight+vSpace;
			//物防
			_wuFangLabel.x=_jueWeiLabel.x;
			_wuFangText.x=_jueWeiText.x;
			_wuFangLabel.y=_wuFangText.y=_wuGongLabel.y+_wuGongLabel.textHeight+vSpace;
			///法攻
			_faGongLabel.x=_jueWeiLabel.x;
			_faGongText.x=_jueWeiText.x;
			_faGongLabel.y=_faGongText.y=_wuFangLabel.y+_wuFangLabel.textHeight+vSpace;
			//法防
			 _faFangLabel.x=_jueWeiLabel.x;
			_faFangText.x=_jueWeiText.x;
			_faFangLabel.y=_faFangText.y=_faGongLabel.y+_faGongLabel.textHeight+vSpace;
			/**pk值
			 */		
			_pkLabel.x=_jueWeiLabel.x;
			_pkText.x=_jueWeiText.x;
			_pkLabel.y=_pkText.y=_faFangLabel.y+_faFangLabel.textHeight+vSpace;
			
			
		}
		
		/**更新View 
		 */		
		public function updateView():void
		{
			
		}
			
		/**
		 *脱下装备     将装备脱下至 背包中
		 */
		public function putOffEquip(dyId:String):void
		{
	//		DataCenter.Instance.goodsDyManager.moveGoodsVo(
		}
		/**穿上装备   将装备 中背包移动到 人物身上
		 */		
		public function putOnEquip(dyId:String):void
		{
			
		}
				
				
		
		
		
		
	}
}