package com.YFFramework.game.core.module.story.manager
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.module.story.model.StoryBasicVo;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.view.CloudStory;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/***
	 *筋斗云剧情管理类
	 *@author ludingchang 时间：2014-1-15 下午3:12:03
	 */
	public class CloudStoryManager
	{
		/**移动过程的时间*/
		private static const Move_Time:Number=1;//秒
		/**移动的距离*/
		private static const Move_Distence:int=300;
		/**在中间停留的时间*/
		private static const Stay_Time:Number=5000;//毫秒
		
		
		private static var _inst:CloudStoryManager;
		private var _hasInit:Boolean;
		private var _loading:Boolean;
		private var _dataToShow:Vector.<StoryBasicVo>;
		private var _Clouds:Array;//CloudStory
		public static function get Instence():CloudStoryManager
		{
			return _inst||=new CloudStoryManager;
		}
		public function CloudStoryManager()
		{
			_dataToShow=new Vector.<StoryBasicVo>;
			_Clouds=new Array;
		}
		public function show(vo:StoryShowVo):void
		{
			var data:Vector.<StoryBasicVo>=StoryBasicManager.Instance.getStoryBasicVo(vo.id);
			_dataToShow=_dataToShow.concat(data);
			if(_hasInit)//资源是否已经准备好，（载入完毕）
			{
				doShow();
			}
			else
			{
				if(!_loading)//不处于载入中（不在加载）
				{
					var loader:UILoader=new UILoader;
					loader.loadCompleteCallback=callback;
					loader.initData(URLTool.getCommonAssets("CloudStory.swf"));
					_loading=true;
				}//已经在加载就不需要再加载了
			}
		}
		
		private function doShow():void
		{//从左边缓动到中间
			var data:StoryBasicVo=_dataToShow.shift();
			if(data)
			{
				var cs:CloudStory=getOneCloud();
				cs.show(data);
				cs.alpha=1;
				LayerManager.StoryLayer.addChild(cs);
				cs.x=StageProxy.Instance.getWidth()/2-cs.width/2-Move_Distence;
				cs.alpha=.5;
				var xx1:Number=cs.x+Move_Distence;
				TweenLite.to(cs,Move_Time,{x:xx1,alpha:1,onComplete:onShow,onCompleteParams:[cs]});
			}
			if(_dataToShow.length>0)
				setTimeout(doShow,5000);
		}
		
		private function onShow(cloud:CloudStory):void
		{//停留
			setTimeout(dispear,Stay_Time,cloud);
		}
		
		private function dispear(cloud:CloudStory):void
		{//缓动到右边
			var xx1:Number=StageProxy.Instance.getWidth()/2-cloud.width/2+Move_Distence;
			TweenLite.to(cloud,Move_Time,{x:xx1,alpha:0.5,onComplete:removeCloud,onCompleteParams:[cloud]});
		}
		
		private function removeCloud(cloud:CloudStory):void
		{//从父容器移除
			cloud.parent.removeChild(cloud);
		}
		
		
		private function getOneCloud():CloudStory
		{
			//先从已经有的中去找出父容器为空的，如果数组中的所有都在显示，则new一个新的
			var i:int,len:int=_Clouds.length;
			for(i=0;i<len;i++)
			{
				if((_Clouds[i] as CloudStory).parent==null)
					return _Clouds[i];
			}
			var c:CloudStory=new CloudStory;
			c.x= StageProxy.Instance.getWidth()/2-c.width/2;
			c.y= StageProxy.Instance.getHeight()-300-len*c.height;
			_Clouds.push(c);
			return c;
		}
		
		private function callback(content:*,data:*):void
		{
			_hasInit=true;
			ResizeManager.Instance.regFunc(onReseize);
			doShow();
		}
		
		private function onReseize():void
		{
			var i:int,len:int=_Clouds.length;
			for(i=0;i<len;i++)
			{
				var cc:CloudStory=_Clouds[i];
				if(cc)
				{
					cc.y=StageProxy.Instance.getHeight()-300-i*cc.height;
				}
			}
		}
	}
}