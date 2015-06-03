package com.YFFramework.game.core.module.skill.view
{
	/**@author yefeng
	 * 2013 2013-7-24 下午4:12:27 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.skill.mamanger.SKillCDViewManager;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.QuickBoxDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	/**  快捷方式 单元UI
	 */	
	public class SkillQuickBoxView extends AbsView
	{
		
		//格子宽度
		public static const skillGridWidth:Number = 43;
		//格子高度
		public static const skillGridHeight:Number = 42;
		
		private static const skillBG:BitmapData=new BitmapData(skillGridWidth,skillGridHeight,true,0x00ffffff);
		
		public var quickBoxDyVo:QuickBoxDyVo;
		private var _cd:YFCD;
		private var _iconImage:IconImage;
		private var _textField:TextField;
		/** 是否处在CD中
		 */		
//		public var isInCD:Boolean;
		public function SkillQuickBoxView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			
			
			_iconImage=new IconImage();
			addChild(_iconImage);
			_iconImage.setSize(skillGridWidth,skillGridHeight);
			_iconImage.mouseChildren=_iconImage.mouseEnabled=false;
			_textField=new TextField();
			addChild(_textField);
			_textField.width=30;
			_textField.height=30
			_textField.textColor=0xF7F72B;
			_textField.filters=[new GlowFilter(0x000000,1,2,2,128)];
//			_textField.filters=FilterConfig.text_filter;
			_textField.mouseEnabled=false;
			var _bg:Bitmap=new Bitmap;
			_bg.bitmapData=skillBG;
			addChildAt(_bg,0);
//			_cd=new YFCD(skillGridWidth,skillGridHeight);
//			addChild(_cd);
//			_cd.mouseChildren=_cd.mouseEnabled=false;
		}
		
		private function setText(txt:int):void
		{
			_textField.text=txt.toString();
			_textField.width=_textField.textWidth+3;
			_textField.height=_textField.textHeight+3;
			_textField.x=skillGridWidth-_textField.width-8;
			_textField.y=skillGridHeight-_textField.height-3;
		}
		public function clearData():void
		{
//			isInCD=false;
			if(quickBoxDyVo)
			{
				switch(quickBoxDyVo.type)
				{
					case SkillModuleType.QuickType_BT_SKILL:
						Xtip.clearLinkTip(this,TipUtil.skillTipInitFunc);	
						break;
					case SkillModuleType.QuickType_BT_ITEM:
						Xtip.clearLinkTip(this,TipUtil.propsTipInitFunc);	
						break;
				}
			}
			quickBoxDyVo=null;
			_iconImage.clear();
			_textField.text="";
			if(_cd)
			{
				if(_cd.parent)_cd.parent.removeChild(_cd);
				_cd.dispose();
			}
			
		}
		public function playCD(cdTime:Number):void
		{
			if(!_cd)
			{
				_cd=new YFCD(skillGridWidth,skillGridHeight);
				addChild(_cd);
				_cd.mouseChildren=_cd.mouseEnabled=false;
			}
//			isInCD=true;
			_cd.play(cdTime,0,false,complete);
		}
		private function complete(obj:Object):void
		{
//			isInCD=false;
		}
		public function getCD():YFCD
		{
			return _cd;
		}
		
		public function updateView():void
		{
			switch(quickBoxDyVo.type)
			{
				case SkillModuleType.QuickType_BT_SKILL:
					var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(quickBoxDyVo.id);
					_iconImage.url=SkillBasicManager.Instance.getURL(skillDyVo.skillId,skillDyVo.skillLevel);
					setText(skillDyVo.skillLevel);
//					if(_cd)
//					{
//						if(_cd.parent)_cd.parent.removeChild(_cd);
//						_cd.dispose();
//					}
					_cd=SKillCDViewManager.Instance.getCd(skillDyVo.skillId);
					if(_cd)
					{
						addChild(_cd);
						_cd.mouseChildren=_cd.mouseEnabled=false;
					}
					Xtip.registerLinkTip(this,SkillTip,TipUtil.skillTipInitFunc,skillDyVo.skillId,skillDyVo.skillLevel,true);
					break;
				case SkillModuleType.QuickType_BT_ITEM:
//					var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(quickBoxDyVo.id);
					var num:int=PropsDyManager.instance.getPropsQuantity(quickBoxDyVo.id);  //获取道具总数量
					if(num)
					{
						var propBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(quickBoxDyVo.id);
						_iconImage.url=PropsBasicManager.Instance.getURL(quickBoxDyVo.id);
						setText(num);
//						if(_cd)
//						{
//							if(_cd.parent)_cd.parent.removeChild(_cd);
//							_cd.dispose();
//						}
						_cd=BagStoreManager.instantce.getCd(propBasicVo.cd_type);
						if(_cd)
						{
							addChild(_cd);
							_cd.mouseChildren=_cd.mouseEnabled=false;
						}
						Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,0,propBasicVo.template_id);
					}
					break;
			}
		}
	}
}