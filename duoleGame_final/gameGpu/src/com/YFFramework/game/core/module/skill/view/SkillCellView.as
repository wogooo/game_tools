package com.YFFramework.game.core.module.skill.view
{
	/**@author yefeng
	 * 2013 2013-7-23 下午4:31:06 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.image.Cast;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SkillCellView extends AbsView
	{
		public static var _collection:Array=[];
		/**父容器
		 */		
//		public var container:Sprite;
		private var _iconImage:IconImage;
		private var _lv_txt:TextField;
		private var _up_icon:Sprite;
		
		/**技能 id
		 */		
		public var skillId:int=-1;
		
		private var _isReg:Boolean=false;
		
		private var _bg:BitmapControl;
		public function SkillCellView(canUpSp:Sprite)
		{
			_up_icon=canUpSp;
			super(false);
		}
		public function hideLvTxt():void
		{
			_lv_txt.visible=false;
			_up_icon.visible=false;
		}
		override protected function initUI():void
		{
			this.x=-3;
			this.y=-3;
			super.initUI();
			_bg = new BitmapControl(Skins.bagGridSkin);
			_bg.setXYOffset(-4,-4);
			addChildAt(_bg,0);
			_iconImage=new IconImage();
			addChild(_iconImage);
			_iconImage.mouseChildren=_iconImage.mouseEnabled=false;
			
			_collection.push(_bg);
			_bg.addEventListener(BagEvent.ITEM_SELECT,onSelect);
			
			_lv_txt=new TextField;
			addChild(_lv_txt);
			_lv_txt.textColor=0x8CF213;
			_lv_txt.selectable=false;
			_lv_txt.mouseEnabled=_lv_txt.mouseWheelEnabled=false;
			_lv_txt.x=25;
			_lv_txt.y=20;
			_lv_txt.filters=FilterConfig.text_filter;
			
			_up_icon.visible=false;
			_up_icon.mouseEnabled=false;
		}
		private function onSelect(e:BagEvent):void
		{
			setSelected();
		}
		
		/**设置本技能选中，同时设置其他不选中*/
		public function setSelected():void
		{
			_bg.select=true;
			for each(var control:BitmapControl in _collection)
			{
				if(control!=_bg)control.select=false;
			}
		}
		
		public function set url(vaule:String):void
		{
			_iconImage.url=vaule;
		}
		public function get url():String
		{
			return _iconImage.url;
		}
		/**  设置图片的颜色矩阵
		 */		
		public function updateView():void
		{
			if(skillId!=-1)
			{
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
				var skillBiscVo:SkillBasicVo;
				if(skillDyVo)
				{
					skillBiscVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel+1);
					
					_lv_txt.text=skillDyVo.skillLevel.toString();
					_lv_txt.visible=true;
					_iconImage.filters=[];
					Xtip.registerLinkTip(this,SkillTip,TipUtil.skillTipInitFunc,skillDyVo.skillId,skillDyVo.skillLevel,true);
				}
				else 
				{
					skillBiscVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,1);
					_lv_txt.text="0";
					_lv_txt.visible=false;
					_iconImage.filters=FilterConfig.dead_filter;
					Xtip.registerLinkTip(this,SkillTip,TipUtil.skillTipInitFunc,skillId,1,true);
				}
				_up_icon.visible=(skillBiscVo
					&& DataCenter.Instance.roleSelfVo.roleDyVo.level>=skillBiscVo.character_level);//是否显示“+”号，只需要等级满足就可以了
			}
		}
		/**获取高亮的图标
		 */		
		public function getLightBitmap():Bitmap
		{
			var mfilters:Array=_iconImage.filters.concat();
			_iconImage.filters=[];
			var bitmapData:BitmapData=Cast.Draw(_iconImage);
			_iconImage.filters=mfilters;
			return new Bitmap(bitmapData);
		}
	}
}