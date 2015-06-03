package com.YFFramework.game.core.module.story.controller
{
	/**@author yefeng
	 * 2013 2013-5-3 下午1:55:37 
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.module.pet.view.grid.Item;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.story.manager.CloudStoryManager;
	import com.YFFramework.game.core.module.story.manager.StoryBasicManager;
	import com.YFFramework.game.core.module.story.model.StoryBasicVo;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.YFFramework.game.core.module.story.view.ColorText;
	import com.YFFramework.game.core.module.story.view.MovieStory;
	import com.YFFramework.game.core.scence.TypeScence;
	
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**   游戏剧情模块
	 */	
	public class ModuleStory extends AbsModule
	{
		private var _colorText:ColorText;
		private var _movieStory:MovieStory;
		public function ModuleStory()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_colorText=new ColorText;
			_movieStory=new MovieStory;

		}
		
		override public function init():void
		{
			addEvents();
			addSocketEvent();
		}
		
		private function addSocketEvent():void
		{
		}
		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(StoryEvent.Show,showStory);
			
			//接受任务后触发的剧情
			YFEventCenter.Instance.addEventListener(StoryEvent.AcceptTaskStory,onStoryEvent);
			//完成任务后触发的剧情
			YFEventCenter.Instance.addEventListener(StoryEvent.FinishTaskStory,onStoryEvent);
			//达到目标触发的剧情
			YFEventCenter.Instance.addEventListener(StoryEvent.ReachTaskStory,onStoryEvent);

			
		}
		
		private function onStoryEvent(e:YFEvent):void
		{
			var storyShowVo:StoryShowVo;
			var story_id:int=int(e.param);
			storyShowVo=new StoryShowVo();
			storyShowVo.id=story_id;
			switch(e.type)
			{
				case StoryEvent.AcceptTaskStory: //接受任务   触发的剧情
					storyShowVo.storyPositionType=TypeStory.StoryPositionType_AccecptTask;
					break;
				case StoryEvent.FinishTaskStory: //完成任务 触发的剧情
					storyShowVo.storyPositionType=TypeStory.StoryPositionType_FinishTask;
					break;
				case StoryEvent.ReachTaskStory:
					storyShowVo.storyPositionType=TypeStory.StoryPositionType_ReachTask;
					break;
			}
			YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,storyShowVo);
		}
		
		private function showStory(e:YFEvent):void
		{
			var vo:StoryShowVo=e.param as StoryShowVo;
			var story:Vector.<StoryBasicVo>=StoryBasicManager.Instance.getStoryBasicVo(vo.id);
			switch(story[0].type)
			{
				case TypeStory.StoryTypeText:
					_colorText.show(story[0].text);
					break;
				case TypeStory.StoryTypeMovie:
					_movieStory.show(vo);
					break;
				case TypeStory.StoryTypeCloud:
					CloudStoryManager.Instence.show(vo);
					break;
			}
		}
	}
}