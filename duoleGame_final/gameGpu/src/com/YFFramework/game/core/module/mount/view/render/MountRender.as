package com.YFFramework.game.core.module.mount.view.render
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 下午3:00:56
	 * 坐骑渲染器
	 */
	public class MountRender extends ListRenderBase{
		
		private var _lvTxt:TextField;
		private var _nameTxt:TextField;
		//private var _statusTxt:TextField;
		private var _iconImage:IconImage;
		private var _statusImg:Sprite;
		private var _color:uint=TypeProps.COLOR_WHITE;
		
		public function MountRender(){
			_renderHeight = 52;
		}
		
		override protected function resetLinkage():void{
			_linkage = "uiSkin.MountItem";
		}
		
		override protected function onLinkageComplete():void{
			AutoBuild.replaceAll(_ui);
			_lvTxt = Xdis.getChild(_ui,"level");
			_nameTxt = Xdis.getChild(_ui,"pname");
			//_statusTxt = Xdis.getChild(_ui,"petStatus");
			_statusImg = Xdis.getChild(_ui,"statusImg");
			_iconImage = Xdis.getChild(_ui,"img_iconImage");
		}
		
		override protected function updateView(item:Object):void{
			//setColor(item.quality);
			_lvTxt.text = "";
			//_lvTxt.textColor = _color;
			//_statusTxt.text = item.status;
			while(_statusImg.numChildren>0){
				_statusImg.removeChildAt(0);
			}
			if(item.status=="出战"){
				_statusImg.addChild(new Bitmap(ClassInstance.getInstance("fightImg")));
			}else{
				_statusImg.addChild(new Bitmap(ClassInstance.getInstance("restImg")));
			}
			//_statusTxt.textColor = _color;
			_nameTxt.text = item.name;
			//_nameTxt.textColor = _color;
			_iconImage.url = item.url;
		}
		
		private function setColor(quality:int):void{
			switch(quality){
				case TypeProps.QUALITY_WHITE:
					_color = TypeProps.COLOR_WHITE;
					break;
				case TypeProps.QUALITY_GREEN:
					_color = TypeProps.COLOR_GREEN;
					break;
				case TypeProps.QUALITY_BLUE:
					_color = TypeProps.COLOR_BLUE;
					break;
				case TypeProps.QUALITY_PURPLE:
					_color = TypeProps.COLOR_PURPLE;
					break;
				case TypeProps.QUALITY_ORANGE:
					_color = TypeProps.COLOR_ORANGE;
					break;
				case TypeProps.QUALITY_RED:
					_color = TypeProps.COLOR_RED;
					break;
			}
		}
		
		/**清除对象 
		 */		
		override public function dispose():void{
			_lvTxt=null;
			_nameTxt=null;
			//_statusTxt=null;
			_iconImage.clear();
			_iconImage=null;
			while(_statusImg.numChildren>0){
				_statusImg.removeChildAt(0);
			}
			super.dispose();
		}
		
		/**空方法，不需要重置宽高 
		 * @param newWidth
		 * @param newHeight
		 */		
		override public function setSize(newWidth:Number, newHeight:Number):void{
		}
	}
} 