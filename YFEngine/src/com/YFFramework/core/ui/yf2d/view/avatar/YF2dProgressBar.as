package com.YFFramework.core.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	
	import yf2d.display.sprite2D.Sprite2D;
	
	/**
	 *由 外部链接 .res资源创建    血条框名称是 bloodFrame  血条是 bloodProgress   
	 * bloodProgress在下层  bloodFrame在上层
	 * 2012-11-22 上午11:41:16
	 *@author yefeng
	 */
	public class YF2dProgressBar extends Abs2dView
	{
		private var bloodFrame:Sprite2D;
		private var bloodProgress:Sprite2D;
		public function YF2dProgressBar()
		{
			super();
		}
		
		override protected function initUI():void
		{
			bloodProgress=new Sprite2D();
			addChild(bloodProgress);
			bloodFrame=new Sprite2D();
			addChild(bloodFrame);
			bloodProgress.setTextureData(CommonFla.BloodProgressSKin);
			bloodProgress.setAtlas(CommonFla.BloodProgressSKin.atlasData);
			bloodProgress.setFlashTexture(CommonFla.BloodProgressSKin.flashTexture);
			bloodFrame.setTextureData(CommonFla.BloodFrameSkin);
			bloodFrame.setAtlas(CommonFla.BloodFrameSkin.atlasData);
			bloodFrame.setFlashTexture(CommonFla.BloodFrameSkin.flashTexture);
			
			//设置 血条的 注册点
			bloodProgress.pivotX=-bloodProgress.width*0.5;
			bloodProgress.pivotY=-bloodProgress.height*0.5;
			bloodFrame.pivotX=-bloodFrame.width*0.5;
			bloodFrame.pivotY=-bloodFrame.height*0.5;

		}
	
		
		/** 设置 进度条的百分比
		 */		
		public function setPercent(value:Number):void
		{
			if(value<0)value=0;
			if(value>1)value=1;
			bloodProgress.scaleX=value;			
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			bloodFrame=null;
			bloodProgress=null;
		}
	}
}