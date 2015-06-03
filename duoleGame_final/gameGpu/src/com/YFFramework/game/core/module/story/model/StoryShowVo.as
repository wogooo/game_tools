package com.YFFramework.game.core.module.story.model
{
	import com.YFFramework.game.core.global.model.TaskNPCHandleVo;

	/***
	 *
	 *@author ludingchang 时间：2013-8-1 下午4:02:31
	 */
	public class StoryShowVo
	{
		/**剧情唯一ID*/
		public var id:int;
		/**带上的数据
		 */
		public var npcHandleVo:TaskNPCHandleVo;
		
		/**值在TypeStory.StoryPositionType_
		 * 剧情显示的地方  
		 */
		public var storyPositionType:int;
		
		public function StoryShowVo()
		{
		}
	}
}