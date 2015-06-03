package com.YFFramework.game.core.module.story.view
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.module.story.manager.StoryResManager;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/***
	 *下方剧情文本及遮罩容器
	 *@author ludingchang 时间：2013-8-2 下午2:49:03
	 */
	public class DownTextContainer extends AbsView
	{
		private var _mask:Sprite;
		private var _skip:TextField;
		private var _goOn:TextField;
		private var _story:TextPlayer;
		private var _nameTxt:TextField;
		private var _roleIcon:DisplayObject;
		private var _type:int;
		public function DownTextContainer($mask:Sprite,$skip:TextField,$goon:TextField,$story:TextPlayer,$name:TextField)
		{
			_mask=$mask;
			_skip=$skip;
			_goOn=$goon;
			_story=$story;
			_nameTxt=$name;
			super();
		}
		override protected function initUI():void
		{
			addChildAt(_mask,0);
			addChild(_story);
			addChild(_goOn);
			addChild(_skip);
			addChild(_nameTxt);
			_mask.x=0;
			_mask.y=0;
			_story.x=300;
			_story.y=40;
			_skip.y=10;
			_goOn.y=120;
			_nameTxt.x=300;
			_nameTxt.y=15;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_mask=null;
			_skip=null;
			_goOn=null;
			_story=null;
			_nameTxt=null;
			clearRoleIcon();
		}
		override public function set width(value:Number):void
		{
			if(_type==TypeStory.PlayType_Hero)
			{
				if(_roleIcon)
				{
					_roleIcon.x=50;
				}
			}
			else
			{
				if(_roleIcon)
				{
					_roleIcon.x=value-200;
				}
			}
			_story.width=value-700;
			_mask.width=value;
			_skip.x=value-_skip.width-300;
			_goOn.x=value-_goOn.width-400;
		}
		override public function get width():Number
		{
			return _mask.width;
		}
		override public function get height():Number
		{
			return _mask.height;
		}
		override public function set height(value:Number):void
		{
			_mask.height=value;
		}
		
		public function setRoleIcon(type:int,url:String):void
		{
			clearRoleIcon();
			_type=type;
			StoryResManager.Instence.getNPCicon(url,getNPCcallback);
		}
		private function clearRoleIcon():void
		{
			if(_roleIcon)
			{
				if(_roleIcon.parent)
				{
					_roleIcon.parent.removeChild(_roleIcon);
				}
				if(_roleIcon is MovieClip)
					(_roleIcon as MovieClip).stop();
			}
			_roleIcon=null;
		}
		/**刷新NPC图标*/
		private function getNPCcallback(dis:DisplayObject):void
		{
			_roleIcon=dis;
			if(_roleIcon is MovieClip)
				(_roleIcon as MovieClip).play();
			addChild(_roleIcon);
			_roleIcon.y=-50;
			width=width;//刷新位置
		}
	}
}