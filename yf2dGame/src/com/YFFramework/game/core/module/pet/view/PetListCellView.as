package com.YFFramework.game.core.module.pet.view
{
	/**
	 * 宠物列表  每一个宠物的U基本信息 ui
	 * @author yefeng
	 *2012-9-22下午9:34:51
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFHolder;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.ResLoader;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.SkinManager;
	import com.YFFramework.game.core.global.model.SkinVo;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetBasicManager;
	import com.YFFramework.game.core.module.pet.model.PetBasicVo;
	import com.YFFramework.game.core.module.pet.model.PetCallBackVo;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.model.PetPlayVo;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PetListCellView extends YFHolder
	{
		/**宠物数据vo 
		 */ 
		public var petDyVo:PetDyVo;
		/**图标容器
		 */ 
		private var iconHolder:ResLoader;
		private var iconW:int=65; ///宠物图标大小
		private var iconH:int=60;
		
		/**出战召回按钮
		 */ 
		private var _callPetbtn:YFButton;
		/**宠物是否出战 默认为没有出战状态
		 */		
		private var _isPetPlay:Boolean;//宠物是否出战 默认为没有出战状态
		
		/**宠物名
		 */
		private var _nameLabel:YFLabel;
		/**等级
		 */		
		private var _levelLabel:YFLabel;
		/**等级值的标签
		 */		
		private var _levelValueLable:YFLabel;
		/**品质标签
		 */		
		private var _qualityLabel:YFLabel;
		/**品质值的标签
		 */		
		private var _qualityValueLabel:YFLabel;
		
		/**背景的名称
		 */ 
		private static const BgImageName:String="petCellListBg.png";
		
		private var _width:int;
		private var _height:int;
		/**背景图片
		 */ 
		private var _bgImage:Bitmap;
		
		/**是否被选中 当前对象是否被选中
		 */
		private var _select:Boolean;
		public function PetListCellView(peDyVo:PetDyVo)
		{
			this.petDyVo=peDyVo;
			_width=260;///宽度 为260 为滚动条预留的   背景实际上只有240
			_height=80;
			super(_width,_height);
		}
		override protected function initUI():void
		{
			super.initUI();
			initBg();////宠物窗口背景 
			var petBasicVo:PetBasicVo=PetBasicManager.Instance.getPetBasicVo(petDyVo.basicId);
			var skinVo:SkinVo=SkinManager.Instance.getSkinVo(petBasicVo.resId);
			var url:String=URLTool.getPetIcon(skinVo.iconId);  ////获取宠物图标
			///宠物图像
			iconHolder=new ResLoader(iconW,iconH);
			iconHolder.load(url);
			addChild(iconHolder);
			iconHolder.x=5;
			iconHolder.y=5;
			iconHolder.mouseChildren=iconHolder.mouseEnabled=false;
			///名称 
			_nameLabel=new YFLabel(petDyVo.roleName,3);
			_nameLabel.width=80;
			addChild(_nameLabel);
			_nameLabel.x=75;
			_nameLabel.y=10;
			_nameLabel.mouseChildren=_nameLabel.mouseEnabled=false;
			_callPetbtn=new YFButton();///出战   召回
			addChild(_callPetbtn);
			_callPetbtn.width=40;
			_callPetbtn.x=160;
			_callPetbtn.y=10;
			///等级
			_levelLabel=new YFLabel(Lang.DengJi);
			_levelValueLable=new YFLabel(petDyVo.level.toString());
			addChild(_levelLabel);
			addChild(_levelValueLable);
			_levelLabel.x=75;
			_levelLabel.y=35;
			_levelValueLable.x=135;
			_levelValueLable.y=35;
			_levelLabel.mouseEnabled=_levelLabel.mouseChildren=false;
			_levelValueLable.mouseEnabled=_levelValueLable.mouseChildren=false;
			_levelValueLable.mouseEnabled=_levelValueLable.mouseChildren=false;
			///品质
			_qualityLabel=new YFLabel(Lang.PingZhi);
			var qualityStr:String=getQualityName(petDyVo.quality);
			_qualityValueLabel=new YFLabel(qualityStr);
			addChild(_qualityLabel);
			addChild(_qualityValueLabel);
			_qualityLabel.x=75;
			_qualityLabel.y=55;
			_qualityValueLabel.x=135;
			_qualityValueLabel.y=55;
			_qualityLabel.mouseChildren=_qualityLabel.mouseEnabled=false;
			_qualityValueLabel.mouseChildren=_qualityValueLabel.mouseEnabled=false;
			///宠物默认为收回状态  
			isPetPlay=false;
			select=false;
		}
		/**加载背景图片
		 */		
		private function initBg():void
		{
			var loader:UILoader=new UILoader();
			var url:String=URLTool.getCommonAssets(BgImageName);
			loader.initData(url);
			loader.loadCompleteCallback=imageLoaded;
		}
		private function imageLoaded(content:DisplayObject,data:Object):void
		{
			_bgImage=content as Bitmap;
			///对加载进来的图片进行缩放
			_bgImage.width=(_width-20);
			_bgImage.height=_height;
			addChildAt(_bgImage,0);
			select=select;			
		}
		
		
		
		/**更新品质
		 */		
		public function updateQuality(quality:int):void
		{
			_qualityValueLabel.text=getQualityName(quality);
		}
		/**更新等级
		 */		
		public function updateLevel(level:int):void
		{
			_levelValueLable.text=level.toString();
		}
		/**更新宠物名称
		 */		
		public function updateName(name:String):void
		{
			_nameLabel.text=name;
		}
		
		/**宠物是否出战  
		 */		
		public function updatePetPlay(petPlay:Boolean):void
		{
			isPetPlay=petPlay;
		}
		
		/**宠物出战状态
		 */				
		private function set isPetPlay(value:Boolean):void
		{
			_isPetPlay=value;
			if(_isPetPlay==true)
			{
				//出战状态下 按钮显示召回
				_callPetbtn.text=Lang.ZhaoHui;
			}
			else 
			{
				//收回状态下 按钮显示出战
				_callPetbtn.text=Lang.ChuZhan;
			}
		}
		/**获取宠物出战状态 
		 */		
		private function get isPetPlay():Boolean
		{
			return _isPetPlay;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_callPetbtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_callPetbtn.removeEventListener(MouseEvent.CLICK,onClick);
		}
		/**单击按钮
		 */
		private function onClick(e:MouseEvent):void
		{
			if(_isPetPlay==false)
			{
				///请求出战宠物
				noticePetPlay();
			}
			else 
			{
				//请求收回宠物
				noticePetCallBask();
			}
		}
		
		/**宠物出战
		 */ 
		public function noticePetPlay():void
		{
			var petPlayerVo:PetPlayVo=new PetPlayVo();
			petPlayerVo.dyId=petDyVo.dyId;
			petPlayerVo.direction=HeroProxy.direction;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.C_PetPlay,petPlayerVo);
		}
		/**宠物收回
		 */		
		public function noticePetCallBask():void
		{
			var petCallBackVo:PetCallBackVo=new PetCallBackVo();
			petCallBackVo.dyId=petDyVo.dyId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.C_PetCallBack,petCallBackVo);
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
		
		
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			if(_bgImage)_bgImage.bitmapData.dispose();
			_bgImage=null;
			iconHolder=null;
			petDyVo=null;
			_callPetbtn=null;
			_nameLabel=null;
			_levelLabel=null;
			_levelValueLable=null;
			_qualityLabel=null;
			_qualityValueLabel=null;
		}
		
		/**是否被选中
		 */ 
		public function set select(value:Boolean):void
		{
			 _select=value;
			 if(_bgImage)
			 {
				 if(_select==true) _bgImage.alpha=0.8;
				 else _bgImage.alpha=0.5;
			 }
		}
		
		/**获取选中的对象
		 */		
		public function get select():Boolean
		{
			return _select;	
		}
		
		
	}
}