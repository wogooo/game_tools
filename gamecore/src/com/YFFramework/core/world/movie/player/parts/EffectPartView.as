package com.YFFramework.core.world.movie.player.parts
{
	/** 人物特效容器 
	 * 
	 *   2012-7-4
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	
	import flash.utils.Dictionary;
	
	public class EffectPartView extends AbsView
	{
		
		
		/**  常驻的动画播放器    当大于两个时 则需要创临时的播放器
		 */
		private var _movie:BitmapMovieClip;
		
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
		 */
		public function playEffect(actionData:ActionData,timesArr:Vector.<Number>,loop:Boolean=false,totalTimes:int=-1):void
		{
			
			var movie:BitmapMovieClip=new BitmapMovieClip();
			movie.start();
			movie.initData(actionData);
			//var data:Object={movie:movie,complete:complete,loop:false}
			var data:Object={movie:movie,loop:loop}
	//		TweenSkill.WaitToExcute(waitTime,playMovie,data,totalTimes,complete,movie);
			TweenSuperSkill.excute(timesArr,playMovie,data,totalTimes,complete,movie);
		}
		/**
		 * @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */
		private function playMovie(data:Object):void
		{
			var  movie:BitmapMovieClip=data.movie as BitmapMovieClip;
			addChild(movie);
		//	var complete:Function=data.complete;
			var loop:Boolean=data.loop;
			movie.playDefault(loop,playComplete,movie,true);
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:BitmapMovieClip=data as BitmapMovieClip;
			if(contains(movie))	removeChild(movie);
		}
		
		
		private function complete(movie:BitmapMovieClip):void
		{
			if(contains(movie))removeChild(movie);
			movie.dispose();
			if(numChildren==0) 
			{
				if(parent) parent.removeChild(this);

			}
		}
		
	}
}