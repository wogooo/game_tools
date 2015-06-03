package com.YFFramework.game.ui.yf2d.view.avatar.pool
{
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.game.ui.yf2d.view.avatar.BuildingEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingRotateEffect2DView;

	/** 技能动画对象池
	 * @author yefeng
	 * 2013 2013-7-6 下午5:37:05 
	 */
	public class YF2dMovieClipPool
	{
		/** 用于 人物tittle 
		 * 
		 */		
		private static var yf2dMovieClipArr:YF2dMovieClipArray=new YF2dMovieClipArray(40);//20
		
		/**特效
		 */
		public static var skillEffect2DViewArr:SkillEffect2DViewArray=new SkillEffect2DViewArray(100);//20
		/** 特效类 用于 特效和粒子 
		 */		
		private static var thingEffect2DViewArr:SkillEffect2DViewArray=new SkillEffect2DViewArray(250);//20
		/**旋转特效类
		 */		
		private static var thingRotateEffect2DViewArr:SkillEffect2DViewArray=new SkillEffect2DViewArray(60);//15
		/**建筑特效类
		 */		
		private static var buildingEffect2DViewArr:SkillEffect2DViewArray=new SkillEffect2DViewArray(20);//30


		public function YF2dMovieClipPool()
		{
		}
		
		public static function getYF2dMovieClip():ATFMovieClip
		{
			var movie:ATFMovieClip;
			if(yf2dMovieClipArr.length>0)
			{
				movie=yf2dMovieClipArr.pop();
				movie.initFromPool();
			}
			else movie=new ATFMovieClip();
			return movie;
		}
		public static function getSkillEffect2DView():SkillEffect2DView
		{
			var movie:SkillEffect2DView;
			if(skillEffect2DViewArr.length>0)
			{
				movie=skillEffect2DViewArr.pop() as SkillEffect2DView;
				movie.initFromPool();
			}
			else movie=new SkillEffect2DView();
			return movie;
		}

		public static function getThingEffect2DView():ThingEffect2DView
		{
			var movie:ThingEffect2DView;
			if(thingEffect2DViewArr.length>0)
			{
				movie=thingEffect2DViewArr.pop() as ThingEffect2DView;
				movie.initFromPool();
			}
			else movie=new ThingEffect2DView();
			return movie;
		}
		public static function getThingRotateEffect2DView():ThingRotateEffect2DView
		{
			var movie:ThingRotateEffect2DView;
			if(thingRotateEffect2DViewArr.length>0)
			{
				movie=thingRotateEffect2DViewArr.pop() as ThingRotateEffect2DView;
				movie.initFromPool();
			}
			else movie=new ThingRotateEffect2DView();
			return movie;
		}

		public static function getBuildingEffect2DView():BuildingEffect2DView
		{
			var movie:BuildingEffect2DView;
			if(buildingEffect2DViewArr.length>0)
			{
				movie=buildingEffect2DViewArr.pop() as BuildingEffect2DView;
				movie.initFromPool();
			}
			else movie=new BuildingEffect2DView();
			return movie;
		}
		/**将yf2dMovieClip    添加到对象池
		 */		
		public static function toYF2dMovieClipPool(yf2dMovieClip:ATFMovieClip):void
		{
			if(yf2dMovieClipArr.canPush())
			{
				yf2dMovieClip.disposeToPool();
				yf2dMovieClipArr.push(yf2dMovieClip);
			}
			else yf2dMovieClip.dispose();
		}
		
		/**将yf2dMovieClip    添加到对象池
		 */		
		public static function toSkillEffect2DViewPool(skillEffect2DView:SkillEffect2DView):void
		{
			if(skillEffect2DViewArr.canPush())
			{
				skillEffect2DView.disposeToPool();
				skillEffect2DViewArr.push(skillEffect2DView);
			}
			else skillEffect2DView.dispose();
		}
		public static function toThingEffect2DViewPool(thingEffect2DView:ThingEffect2DView):void
		{
			if(thingEffect2DViewArr.canPush())
			{
				thingEffect2DView.disposeToPool();
				thingEffect2DViewArr.push(thingEffect2DView);
			}
			else thingEffect2DView.dispose();
		}
		public static function toThingRotateEffect2DViewPool(thingRotateEffect2DView:ThingEffect2DView):void
		{
			if(thingRotateEffect2DViewArr.canPush())
			{
				thingRotateEffect2DView.disposeToPool();
				thingRotateEffect2DViewArr.push(thingRotateEffect2DView);
			}
			else thingRotateEffect2DView.dispose();
		}
		
		public static function toBuildingEffect2DViewPool(buildingEffect2DView:BuildingEffect2DView):void
		{
			if(buildingEffect2DViewArr.canPush())
			{
				buildingEffect2DView.disposeToPool();
				buildingEffect2DViewArr.push(buildingEffect2DView);
			}
			else buildingEffect2DView.dispose();
		}
		
		
		
	///填满对象池
		private static function fillYF2dMovieClipPool():void
		{
			var movie:ATFMovieClip;
			for(var i:int=0;i!=yf2dMovieClipArr.length;++i)
			{
				movie=new ATFMovieClip();
				movie.disposeToPool();
				yf2dMovieClipArr.push(movie);
			}
		}
		
		private static function fillSkillEffect2DViewPool():void
		{
			var movie:SkillEffect2DView;
			for(var i:int=0;i!=skillEffect2DViewArr.length;++i)
			{
				movie=new SkillEffect2DView();
				movie.disposeToPool();
				skillEffect2DViewArr.push(movie);
			}
		}
		
		private static function fillThingEffect2DViewPool():void
		{
			var movie:ThingEffect2DView;
			for(var i:int=0;i!=thingEffect2DViewArr.length;++i)
			{
				movie=new ThingEffect2DView();
				movie.disposeToPool();
				thingEffect2DViewArr.push(movie);
			}

		}

		private static function fillThingRotateEffect2DViewPool():void
		{
			var movie:ThingRotateEffect2DView;
			for(var i:int=0;i!=thingRotateEffect2DViewArr.length;++i)
			{
				movie=new ThingRotateEffect2DView();		
				movie.disposeToPool();
				thingRotateEffect2DViewArr.push(movie);
			}
		}
		/**填满对象池
		 */		
		public static function FillMoviePool():void
		{
			fillYF2dMovieClipPool();
			fillSkillEffect2DViewPool();
			fillThingEffect2DViewPool();
			fillThingRotateEffect2DViewPool();
		}
		
		
	}
}