package com.YFFramework.core.ui.yf2d.view.avatar
{
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.game.core.global.model.TypeSkill;
	
	import flash.utils.Dictionary;
	
	/**2012-11-22 上午11:30:14
	 *@author yefeng
	 */
	public class EffectPart2DView extends Abs2dView
	{
		/**动画大于两个时创建临时的播放器  播放完之后立刻释放播放器内存
		 */
		private var _tempDict:Dictionary;
		public function EffectPart2DView()
		{
			super();
			mouseChildren=false;
			mouseEnabled=false;
		}
		
		/**
		 * @param loop  该特效是否 循环播放     一般人物待机 时需要
		 * @param timesArr   特效时间轴
		 * @param completeFunc 每次特效播放完之后调用
		 * @param completeParam	参数
		 * @param totalTimes   特效播放的时间   这个这间之后 将移除特效   不管是否处于循环播放状态 所以 当是循环播放时  需要将 值 设为很大   
		 * @param skinType是 皮肤类型    值在TypeSkin   1 表示有方向的皮肤   2 表示没有方向的皮肤 
		 */
		public function playEffect(actionData:YF2dActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=1):void
		{
			var data:Object={actionData:actionData,loop:loop,skinType:skinType,direction:direction}
			TweenSuperSkill.excute(timesArr,playMovie,data);
		}
		/**
		 *  @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */		
		private function playMovie(data:Object):void
		{
			var actionData:YF2dActionData=data.actionData;
			var loop:Boolean=data.loop;
			var skinType:int=data.skinType;
			var direction:int=int(data.direction);
			var movie:YF2dMovieClipPool=PoolCenter.Instance.getFromPool(YF2dMovieClipPool,null) as YF2dMovieClipPool;
			addChild(movie);
			movie.initData(actionData);
			movie.start();
			if(skinType==TypeSkill.Skin_HasDirection)	movie.playDefaultAction(direction,loop,playComplete,movie,true);
			else movie.playDefault(loop,playComplete,movie,true);
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:YF2dMovieClipPool=data as YF2dMovieClipPool;
			if(contains(movie))	removeChild(movie);
			movie.disposeToPool();
			if(numChildren==0) 
			{
				if(parent) parent.removeChild(this);
			}
		}
		/**释放内存
		 */		
//		override public function dispose(childrenDispose:Boolean=true):void
//		{
//			
//			_isDispose=true;
//		}
		/**释放内存
		 */	
		public function removeAllMovie():void
		{
			removeEvents();
			var movie:YF2dMovieClipPool;
			while(numChildren)
			{
				movie=getChildAt(0) as YF2dMovieClipPool;
				removeChild(movie);
				movie.disposeToPool();
			}
			if(parent)parent.removeChild(this);
		}
		
		
	}
}