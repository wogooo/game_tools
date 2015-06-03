package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.module.mapScence.view.RoleSelectView;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;
	
	import flash.utils.Dictionary;
	
	/**2012-11-22 上午11:30:14
	 *@author yefeng
	 */
	public class EffectPart2DView extends Abs2dView
	{
		
		private static var _pool:Vector.<EffectPart2DView>=new Vector.<EffectPart2DView>();
		private static const MaxLen:int=50;// 5120*5120大小
		private static var _len:int=0;//当前池里的个数
		
		
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
		public function playEffect(actionData:ATFActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=1,complete:Function=null,completeParam:Object=null):void
		{
			var data:Object={actionData:actionData,loop:loop,skinType:skinType,direction:direction,complete:complete,completeparam:completeParam}
			TweenSuperSkill.excute(timesArr,playMovie,data);
		}
		/**
		 *  @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */		
		private function playMovie(data:Object):void
		{
			var actionData:ATFActionData=data.actionData;
			var loop:Boolean=data.loop;
			var skinType:int=data.skinType;
			var direction:int=int(data.direction);
			var movieCompleteFunc:Function=data.complete;
			var completeParam:Function=data.completeparam;
			var movie:SkillEffect2DView=YF2dMovieClipPool.getSkillEffect2DView();//new YF2dMovieClip();
			addChild(movie);
			movie.initData(actionData);
			movie.start();
			if(skinType==TypeSkill.Skin_HasDirection)	
			{
				movie.playDefaultAction(direction,loop,playComplete,{movie:movie,complete:movieCompleteFunc,completeParam:completeParam},true);
			}
			else if(skinType==TypeSkill.Skin_RotateDirection)
			{
				movie.playDefault(loop,playComplete,{movie:movie,complete:movieCompleteFunc,completeParam:completeParam},true);
				movie.rotationZ=DirectionUtil.getDirectionDegree(direction);
			}
			else  movie.playDefault(loop,playComplete,{movie:movie,complete:movieCompleteFunc,completeParam:completeParam},true);
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:SkillEffect2DView=data.movie as SkillEffect2DView;
			var completeFunc:Function=data.complete;
			var completeParam:Function=data.completeParam;
			if(contains(movie))	removeChild(movie);
			YF2dMovieClipPool.toSkillEffect2DViewPool(movie);
			if(numChildren==0) 
			{
				if(parent) parent.removeChild(this);
			}
			if(completeFunc!=null)completeFunc(completeParam);
		}
		/**释放内存
		 */		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			removeAllContent();
			_isDispose=true;
		}
		
		private function removeAllContent():void
		{
			var movie:DisplayObject2D;
			while(numChildren)
			{
				movie=removeChildAt(0);
				if(movie is RoleSelectView)  //为选中 的光标
				{
					continue;
				}
				else if(movie is SkillEffect2DView)
				{
					YF2dMovieClipPool.toSkillEffect2DViewPool(SkillEffect2DView(movie));
				}
				else movie.dispose();
			}
//			if(parent)parent.removeChild(this);
		}
		
		/**释放内存
		 */	
//		public function removeAllMovie():void
//		{
//			removeEvents();
//			var movie:SkillEffect2DView;
//			while(numChildren)
//			{
//				movie=getChildAt(0) as SkillEffect2DView;
//				removeChild(movie);
//				YF2dMovieClipPool.toSkillEffect2DViewPool(movie);
//			}
//			if(parent)parent.removeChild(this);
//		}

		/**删除选中光标 SelectRoleiew
		 *  display 是选中角色 角色身上闪动的选中光标圈圈
		 */		
		public function removeSelectRoleiew(display:DisplayObject2D):void
		{
			if(contains(display))	removeChild(display);
			if(numChildren==0) 
			{
				if(parent) parent.removeChild(this);
			}
		}
		/**添加选中光标
		 */ 
		public function addSelectRoleiew(display:DisplayObject2D):void
		{
			addChildAt(display,0);
		}
		
		
		///对象池处理
		
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			removeAllContent();
		}
		/**获取tileView
		 */		
		public static function getEffectPart2DViewPool():EffectPart2DView
		{
			var absView:EffectPart2DView;
			if(_len>0)
			{
				absView=_pool.pop();
				_len--;
			}
			else absView=new EffectPart2DView();
			return absView;
		}
		
		/**回收tileView
		 */		
		public static function toEffectPart2DViewPool(absView:EffectPart2DView):void
		{
			if(_len<MaxLen)
			{
				var index:int=_pool.indexOf(absView);
				if(index==-1)
				{
					absView.disposeToPool();
					_pool.push(absView);
					_len++;
				}
			}
			else absView.dispose();
		}
		/**填满对象池
		 */		
		public static function FillPool():void
		{
			var absView:EffectPart2DView;
			for(var i:int=0;i!=MaxLen;++i)
			{
				absView=new EffectPart2DView();
				_pool.push(absView);
			}
			_len=MaxLen;
		}
		
		
	}
}