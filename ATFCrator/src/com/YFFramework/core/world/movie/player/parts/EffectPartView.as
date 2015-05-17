package com.YFFramework.core.world.movie.player.parts
{
	/** 人物特效容器 
	 * 
	 *   2012-7-4
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClipPool;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.game.core.global.model.TypeSkill;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class EffectPartView extends AbsView
	{
		
		
		/**  常驻的动画播放器    当大于两个时 则需要创临时的播放器
		 */
	//	private var _movie:BitmapMovieClip;
		
		/**动画大于两个时创建临时的播放器  播放完之后立刻释放播放器内存
		 */
		private var _tempDict:Dictionary;
		
		public function EffectPartView(autoRemove:Boolean=false)
		{
			super(autoRemove);
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
		public function playEffect(actionData:ActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=1):void
		{
			var data:Object={actionData:actionData,loop:loop,skinType:skinType,direction:direction}
			TweenSuperSkill.excute(timesArr,playMovie,data);
		}
		/**
		 *  @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */		
		private function playMovie(data:Object):void
		{
			var actionData:ActionData=data.actionData;
			var loop:Boolean=data.loop;
			var skinType:int=data.skinType;
			var direction:int=int(data.direction);
			var movie:BitmapMovieClipPool=PoolCenter.Instance.getFromPool(BitmapMovieClipPool,null) as BitmapMovieClipPool;
			addChild(movie);
			movie.initData(actionData);
			movie.start();
			if(skinType==TypeSkill.Skin_HasDirection)	movie.playDefaultAction(direction,loop,playComplete,movie,true);
			else movie.playDefault(loop,playComplete,movie,true);
		}
		/**
		 * @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */
//		private function playMovie(data:Object):void
//		{
//			var  movie:BitmapMovieClipPool=data.movie as BitmapMovieClipPool;
//			var loop:Boolean=data.loop;
//			var skinType:int=data.skinType;
//			var direction:int=int(data.direction);
//			if(skinType==TypeSkin.NoDirection)	movie.playDefault(loop,playComplete,movie,true);
//			else movie.playDefaultAction(direction,loop,playComplete,movie,true);
//		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:BitmapMovieClipPool=data as BitmapMovieClipPool;
			if(contains(movie))	removeChild(movie);
			movie.disposeToPool();
			if(numChildren==0) 
			{
				if(parent) parent.removeChild(this);
			}
		}
		/**释放内存
		 */		
		override public function dispose(e:Event=null):void
		{
			removeEvents();
			var movie:BitmapMovieClipPool;
			while(numChildren)
			{
				movie=getChildAt(0) as BitmapMovieClipPool;
				removeChild(movie);
				movie.disposeToPool();
			}
			if(parent)parent.removeChild(this);
			_isDispose=true;
		}
		
		
//		protected function complete(obj:BitmapMovieClipPool):void
//		{
//			var child:BitmapMovieClipPool;
//			while(numChildren>0)
//			{
//				child=getChildAt(0) as BitmapMovieClipPool;
//				removeChild(child);
//				child.disposeToPool();
//			}
//			if(parent) parent.removeChild(this);	
//		}

		
//		protected function complete(movie:BitmapMovieClipPool):void
//		{
//			if(contains(movie))removeChild(movie);
//			movie.disposeToPool();
//			if(numChildren==0) 
//			{
//				if(parent) parent.removeChild(this);
//			}
//		}
		
	}
}