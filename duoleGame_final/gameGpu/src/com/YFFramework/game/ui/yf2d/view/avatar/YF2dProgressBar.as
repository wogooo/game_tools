package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.display.sprite2D.Sprite2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.game.ui.res.CommonFla;
	import com.greensock.TweenLite;
	
	/**
	 *由 外部链接 .res资源创建    血条框名称是 bloodFrame  血条是 bloodProgress   
	 * bloodProgress在下层  bloodFrame在上层
	 * 2012-11-22 上午11:41:16
	 *@author yefeng
	 */
	public class YF2dProgressBar extends Abs2dView
	{
		public static const Width:int=50;
		public static const Height:int=6;
		
		private static var _pool:Vector.<YF2dProgressBar>=new Vector.<YF2dProgressBar>();
		private static const MaxLen:int=30;// 5120*5120大小
		private static var _len:int=0;//当前池里的个数
		
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
		override protected function addEvents():void
		{
			super.addEvents();
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onResetContext);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onResetContext);
		}
		private function onResetContext(e:YF2dEvent=null):void
		{
			bloodProgress.setFlashTexture(CommonFla.BloodProgressSKin.flashTexture);
			bloodFrame.setFlashTexture(CommonFla.BloodFrameSkin.flashTexture);
		}
	
		
		/** 设置 进度条的百分比
		 */		
		public function setPercent(value:Number):void
		{
			if(value<0)value=0;
			if(value>1)value=1;
//			bloodProgress.scaleX=value;			
			TweenLite.to(bloodProgress,0.3,{scaleX:value});
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			bloodFrame=null;
			bloodProgress=null;
		}
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			visible=true;
			removeEvents();
			
		}
		/**对象池中获取数据重新初始化
		 */		
		public function initFromPool():void
		{
			onResetContext();
			addEvents();
		}
		
		public static function getYF2dProgressBar():YF2dProgressBar
		{
			var progrssBar:YF2dProgressBar;
			if(_len>0)
			{
				progrssBar=_pool.pop();
				progrssBar.initFromPool();
				_len--;
			}
			else progrssBar=new YF2dProgressBar();
			return progrssBar;

		}
		public static function toYF2dProgressBarPool(progrssBar:YF2dProgressBar):void
		{
			if(_len<MaxLen)
			{
				var index:int=_pool.indexOf(progrssBar);
				if(index==-1)
				{
					progrssBar.disposeToPool();
					_pool.push(progrssBar);
					_len++;
				}
			}
			else progrssBar.dispose();
		}
		
		
		/**填满对象池
		 */		
		public static function FillPool():void
		{
			var progrssBar:YF2dProgressBar;
			for(var i:int=0;i!=MaxLen;++i)
			{
				progrssBar=new YF2dProgressBar();
				progrssBar.disposeToPool();
				_pool.push(progrssBar);
			}
			_len=MaxLen;
		}
	}
}