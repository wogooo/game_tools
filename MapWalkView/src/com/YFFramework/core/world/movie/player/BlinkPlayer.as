package com.YFFramework.core.world.movie.player
{
	/** 场景 移形换影的显示类  用来显示重影
	 * @author yefeng
	 * 2013 2013-4-7 下午3:44:44 
	 */
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dMovieClip;
	
	/**只用来处理移形换影
	 */ 
	public class BlinkPlayer extends Abs2dView
	{
		private var _cloth:YF2dMovieClip;
		private var _weapon:YF2dMovieClip;
		private var _wing:YF2dMovieClip;
		public function BlinkPlayer()
		{
			super();
		}
		
		
		public function initData(clothData:YF2dActionData,weaponData:YF2dActionData=null,wingData:YF2dActionData=null):void
		{
			_cloth=new YF2dMovieClip();
			addChild(_cloth);
			_cloth.start();
			if(clothData)_cloth.actionData=clothData;
			else _cloth.setBitmapFrame(CommonFla.RoleFakeSkin,CommonFla.RoleFakeSkin.flashTexture,CommonFla.RoleFakeSkin.atlasData);////设置  默认皮肤
			if(weaponData)
			{
				_weapon=new YF2dMovieClip();
				_weapon.initData(weaponData);
				_weapon.start();
				addChild(_weapon);
			}
			if(wingData)
			{
				_wing=new YF2dMovieClip();
				_wing.initData(wingData);
				_wing.start();
				addChildAt(_wing,0);
			}
		}
//		
//		public function play(action:int,direction:int):void
//		{
//			
//		}
		
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			if(_cloth.actionData)_cloth.gotoAndStop(index,action,direction);
			if(_weapon.actionData)_weapon.gotoAndStop(index,action,direction);
			if(_wing.actionData)_wing.gotoAndStop(index,action,direction);
		}
		
//		public function gotoAndStopDefault():void
//		{
//			
//		}

			
		
		/**默认鸡蛋 皮肤
		 */		
		private function initDefault():void
		{
			_cloth=new YF2dMovieClip();
			addChild(_cloth);
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_cloth=null;
			_weapon=null;
			_wing=null;
		}
		
		
	}
}