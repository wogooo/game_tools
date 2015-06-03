package com.YFFramework.game.ui.yf2d.view.avatar
{
	/**@author yefeng
	 * 2013 2013-3-29 下午3:59:16 
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.PlayerView;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;
	
	import flash.utils.Dictionary;
	
	public class BuffEffect2DView extends Abs2dView
	{
		
		private static var _pool:Vector.<BuffEffect2DView>=new Vector.<BuffEffect2DView>();
		private static const MaxLen:int=50;// 5120*5120大小
		private static var _len:int=0;//当前池里的个数
		
		
		protected var _dict:Dictionary;
		private var player:PlayerView;

		public function BuffEffect2DView(player:PlayerView)
		{
			this.player=player;
			super();
			mouseChildren=mouseEnabled=false;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_dict=new Dictionary();
		}
		/**添加buff特效
		 */		
		public function addEffect(url:String):void
		{
			var clip:SkillEffect2DView=_dict[url];
			if(clip==null)
			{
				clip=YF2dMovieClipPool.getSkillEffect2DView();
				clip.start();
				addChild(clip);
				_dict[url]=clip;
				var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
				if(actionData)
				{
					clip.initData(actionData);
					clip.playDefault();
				}
				else 
				{
					SourceCache.Instance.addEventListener(url,onBuffEffectComplete);	
					SourceCache.Instance.loadRes(url,{player:player,buff2dView:this});
				}
			}
		}
		private function onBuffEffectComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onBuffEffectComplete);	
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			var objVect:Vector.<Object>=e.param as Vector.<Object>;
			var clip:SkillEffect2DView;
			var player:PlayerView ;
			var buff2dView:BuffEffect2DView;
			for each(var obj:Object in objVect)
			{
				player=obj.player as PlayerView;
				buff2dView=obj.buff2dView as BuffEffect2DView
				if(player)
				{
					if(!player.isDispose)  
					{
						clip=buff2dView._dict[url];
						if(clip)
						{
							clip.initData(actionData);
							clip.playDefault();
						}
					}
				}
			}
		}
		
		public function deleteEffect(url:String):void
		{
			var clip:SkillEffect2DView=_dict[url] as SkillEffect2DView;
			if(clip)
			{
				if(contains(clip)) removeChild(clip);
//				clip.stop();
//				clip.dispose();
				YF2dMovieClipPool.toSkillEffect2DViewPool(clip);
			}
			_dict[url]=null;
			delete _dict[url];
			
			if(numChildren==0)
			{
				if(parent)parent.removeChild(this);
			}
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			_isDispose=true;
			removeAllContent();
			_dict=null;
			player=null;
		}
		
		private function removeAllContent():void
		{
			var clip:SkillEffect2DView;
			while (numChildren)
			{
				clip=removeChildAt(0) as SkillEffect2DView;
				YF2dMovieClipPool.toSkillEffect2DViewPool(clip);
			}
		}
		
		//////对象池处理
		
		
		public function initFromPool(player:PlayerView):void
		{
			this.player=player;
		}
		
		
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			removeAllContent();
			_dict=new Dictionary();
			player=null;
		}
		/**获取tileView
		 */		
		public static function getBuffEffect2DViewPool(player:PlayerView):BuffEffect2DView
		{
			var absView:BuffEffect2DView;
			if(_len>0)
			{
				absView=_pool.pop();
				absView.initFromPool(player);
				_len--;
			}
			else absView=new BuffEffect2DView(player);
			return absView;
		}
		
		/**回收tileView
		 */		
		public static function toBuffEffect2DViewPool(absView:BuffEffect2DView):void
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
				else 
				{
					absView.disposeToPool();
				}
			}
			else absView.dispose();
		}
		/**填满对象池
		 */		
		public static function FillPool():void
		{
			var absView:BuffEffect2DView;
			for(var i:int=0;i!=MaxLen;++i)
			{
				absView=new BuffEffect2DView(null);
				_pool.push(absView);
			}
			_len=MaxLen;
		}
		
		
		
	}
}