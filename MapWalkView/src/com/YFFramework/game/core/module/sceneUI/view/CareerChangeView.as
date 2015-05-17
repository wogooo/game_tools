package com.YFFramework.game.core.module.sceneUI.view
{
	/**@author yefeng
	 * 2013 2013-4-9 上午11:30:31 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.sceneUI.model.SceneUIEvent;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Window;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/**   角色转职 UI
	 */	
	public class CareerChangeView extends  Window
	{
		/**转职 图像
		 */		
		private static const 	Career_ZhanShiImage:String=URLTool.getCommonAssets("career_1.png");
		/**法师图像
		 */		
		private static const 	Career_FaShiImage:String=URLTool.getCommonAssets("career_2.png");
		/**牧师图像
		 */		
		private static const 	Career_MuShiImage:String=URLTool.getCommonAssets("career_3.png");
		/**猎人图像
		 */		
		private static const 	Career_LieRenImage:String=URLTool.getCommonAssets("career_4.png");
		/**刺客图像
		 */		
		private static const 	Career_CiKeImage:String=URLTool.getCommonAssets("career_5.png");
		
		private var _mc:MovieClip;
		/** 职业
		 */		
		private var _career:int;
		
		private var _selectView:Shape;
		private static const Glow:GlowFilter=new GlowFilter(0xFF0000,1,10,10,3);
		public function CareerChangeView()
		{
			super();
			initUI();
			addEvents();
			randomSelect();
		}
		
		protected function initUI():void
		{
			_mc=ClassInstance.getInstance("loginUI_changeCareer");
			content=_mc;
			title="转职";
			setSize(828,380);
			initImage();
			_selectView=new Shape();
			_selectView.alpha=0.3;
			Draw.DrawRect(_selectView.graphics,162,285,0xFF0000);
		}
		/**初始化 图像
		 */		
		private function initImage():void
		{
			loadImage(Career_ZhanShiImage,_mc.zhanshi);
			loadImage(Career_FaShiImage,_mc.fashi);
			loadImage(Career_MuShiImage,_mc.mushi);
			loadImage(Career_LieRenImage,_mc.daozhei);
			loadImage(Career_CiKeImage,_mc.cike);
		}
		private function loadImage(url:String,container:Sprite):void
		{
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=completeLoaded;
			loader.initData(url,null,container);
		}
		/**
		 */		
		private function completeLoaded(bitmap:Bitmap,container:Sprite=null):void
		{
			container.addChildAt(bitmap,1);
			bitmap.y=40;
		}
		protected function addEvents():void
		{
			_mc.zhanshi.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.fashi.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.mushi.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.daozhei.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.cike.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.confirm_button.addEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.randomCareer.addEventListener(MouseEvent.CLICK,onCareerClick);
		}
		protected function removeEvents():void
		{
			_mc.zhanshi.removeEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.fashi.removeEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.mushi.removeEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.daozhei.removeEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.cike.removeEventListener(MouseEvent.CLICK,onCareerClick);
			_mc.confirm_button.removeEventListener(MouseEvent.CLICK,onCareerClick);	
			_mc.randomCareer.removeEventListener(MouseEvent.CLICK,onCareerClick);	
		}
		protected function onCareerClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				///战士
				case _mc.zhanshi:
					_career=TypeRole.CAREER_WARRIOR;
					setSelect(_mc.zhanshi);
					break;
				//法师
				case _mc.fashi:
					_career=TypeRole.CAREER_MASTER;
					setSelect(_mc.fashi);
					break;
				case _mc.mushi:
					_career=TypeRole.CAREER_PRIEST;
					setSelect(_mc.mushi);
					break;
				case _mc.daozhei:
					_career=TypeRole.CAREER_HUNTER;
					setSelect(_mc.daozhei);
					break;
				case _mc.cike:
					_career=TypeRole.CAREER_BRAVO;
					setSelect(_mc.cike);
					break;
				case _mc.confirm_button:
					if(_career==TypeRole.CAREER_WARRIOR||_career==TypeRole.CAREER_MASTER)
					{
						///确定
						YFEventCenter.Instance.dispatchEventWith(SceneUIEvent.SelectCareer,_career);
						dispose();
					}
					else 
					{
						Alert.show("该职业尚未有开发!");
					}
					break;
				case _mc.randomCareer: ///随机
					randomSelect(_career);
					break;
			}
		}
		/**随机选择
		 */		
		private function randomSelect(currentIndex:int=-1):void
		{
			//转职   默认是从头1 开始
			var career:int=	Math.round(Math.random()*(5-1)) +1;
			while(career==currentIndex)
			{
				career=	Math.round(Math.random()*(5-1)) +1;
			}
			switch(career )
			{
				case TypeRole.CAREER_WARRIOR:
					_mc.zhanshi.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case TypeRole.CAREER_MASTER:
					_mc.fashi.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case TypeRole.CAREER_PRIEST:
					_mc.mushi.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case TypeRole.CAREER_HUNTER:
					_mc.daozhei.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case TypeRole.CAREER_BRAVO:
					_mc.cike.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
			}
		}
		
		private function setSelect(display:Sprite):void
		{
//			_mc.zhanshi.filters=[];
//			_mc.fashi.filters=[];
//			_mc.mushi.filters=[];
//			_mc.daozhei.filters=[];
//			_mc.cike.filters=[];
//			display.filters=[Glow];
			display.addChild(_selectView);
		}
			
		
		override public function dispose():void
		{
			super.dispose();
			close();
			if(parent) parent.removeChild(this);
			removeEvents();
			_mc=null;
		}
	}
}