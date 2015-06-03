package com.YFFramework.game.core.module.story.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.story.event.StoryEvent;
	import com.YFFramework.game.core.module.story.manager.StoryBasicManager;
	import com.YFFramework.game.core.module.story.model.StoryBasicVo;
	import com.YFFramework.game.core.module.story.model.StoryShowVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/***
	 *动画剧情
	 *@author ludingchang 时间：2013-8-1 下午4:56:33
	 */
	public class MovieStory extends AbsView
	{
		private static const uiName:String="story.swf";
		/**黑边移动总用时，单位秒**/
		private static const coverMoveTime:Number=.5;
		/**最小宽*/
		private static const coverMinWidth:int=1024;
		/**最小高*/
		private static const coverMinHeight:int=600;
		
		private var _maskUp:Sprite;
		private var _maskDown:Sprite;
		private var _txt:TextPlayer;
		private var _sp:Sprite;
		private var _nextStoryId:int;
		private var _dataToShow:Vector.<StoryBasicVo>;
		private var _skip:TextField;
		private var _goOn:TextField;
		/**名字*/
		private var _nameTxt:TextField;
		private var _downContainer:DownTextContainer;
		private static var _hasInit:Boolean=false;
		
		
		/**完成后的回掉
		 */
//		public var completeCall:Function;
		
		/**显示的数据
		 */
		private var _storyShowVo:StoryShowVo;
		
		/**
		 * @param taskNPCHandleVo  作为对话条件 
		 */
		public function MovieStory()
		{
		}
		private function init(content:DisplayObject,data:*):void
		{
			_sp=content as Sprite
			_maskUp=_sp.getChildByName("maskUp") as Sprite;
			_maskDown=_sp.getChildByName("maskDown") as Sprite;
			_txt=new TextPlayer;
			_maskUp.x=_maskDown.x=0;
			_skip=new TextField;
			_skip.autoSize=TextFieldAutoSize.LEFT;
			_skip.selectable=false;
			var tf:TextFormat=new TextFormat;
			tf.underline=true;
			tf.color=0xccffff;
			_skip.defaultTextFormat=tf;
			_skip.text="跳过剧情";
			
			_goOn=new TextField;
			_goOn.autoSize=TextFieldAutoSize.LEFT;
			_goOn.selectable=false;
			_goOn.defaultTextFormat=tf;
			_goOn.text="点击继续";
			
			_nameTxt=new TextField;
			_nameTxt.autoSize=TextFieldAutoSize.LEFT;
			_nameTxt.selectable=false;
			tf.underline=false;
			tf.size=20;
			tf.color=0xccbb00;
			_nameTxt.defaultTextFormat=tf;
			
			addChild(_maskUp);
			_downContainer=new DownTextContainer(_maskDown,_skip,_goOn,_txt,_nameTxt);
			addChild(_downContainer);
			
			_hasInit=true;
			//剧情引导
			NewGuideManager.movieStoryGuideFunc=handleGuide;
			
			showCover();
		}
		/**
		 * 显示动画剧情
		 */		
		public function show(storyShowVo:StoryShowVo):void
		{
			_storyShowVo=storyShowVo;
			var story:Vector.<StoryBasicVo>=StoryBasicManager.Instance.getStoryBasicVo(_storyShowVo.id);
			_dataToShow=story.concat();	
			if(!_hasInit)
			{
				var url:String=URLTool.getCommonAssets(uiName);
				var _loader:UILoader=new UILoader;
				_loader.initData(url);
				_loader.loadCompleteCallback=init;
			}
			else
			{
				showCover();
			}
		}
		
		private function showCover():void
		{
			_txt.clear();
			PopUpManager.addPopUp(this,LayerManager.StoryLayer,0,0,0x010101,0.1,playNext,null,null,false);
			onResize(null);
			addEvent();
			_maskUp.y=-_maskUp.height;
			
			var stageH:int=getStageHeight();
			
			_downContainer.y=stageH;
			
			TweenLite.to(_maskUp,coverMoveTime,{y:0});
			TweenLite.to(_downContainer,coverMoveTime,{y:stageH-_downContainer.height,onComplete:showText});
		}
		
		private function addEvent():void
		{
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
			_goOn.addEventListener(MouseEvent.CLICK,playNext);
			_skip.addEventListener(MouseEvent.CLICK,close);
		}
		
		protected function showNextStory():void
		{
			if(_nextStoryId>0)
			{
				var nextVo:StoryShowVo=new StoryShowVo;
				nextVo.id=_nextStoryId;
				YFEventCenter.Instance.dispatchEventWith(StoryEvent.Show,nextVo);
			}
//			else 
//			{
//				if(completeCall!=null)completeCall();
//			}
		}
		
		protected function playNext(event:MouseEvent=null):void
		{
			showText();
		}
		
		private function getStageWidth():int
		{
			var stageW:int=StageProxy.Instance.getWidth();
			if(stageW<coverMinWidth)
				stageW=coverMinWidth;
			return stageW;
		}
		private function getStageHeight():int
		{ 
			var stageH:int=StageProxy.Instance.getHeight();
			if(stageH<coverMinHeight)
				stageH=coverMinHeight;
			return stageH;
		}
		protected function onResize(event:Event):void
		{
			var stageW:int=getStageWidth();
			var stageH:int=getStageHeight();
			_maskUp.width=stageW;
			_downContainer.width=stageW;
			_downContainer.y=stageH-_downContainer.height;
		}
		
		private function showText():void
		{
			if(_dataToShow.length>0)
			{
				var data:StoryBasicVo=_dataToShow.shift();
				_txt.play(data.text,data.movie_time);
				var url:String;
				if(data.player_type==TypeStory.PlayType_NPC)//为npc
				{
					url=Npc_ConfigBasicManager.Instance.getHalfIcon(data.NPC_id);
					_nameTxt.text=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(data.NPC_id).name+":";
				}
				else if(data.player_type==TypeStory.PlayType_Hero)
				{//自己
					url=CharacterPointBasicManager.Instance.getCharactorHalfIcon(DataCenter.Instance.roleSelfVo.roleDyVo.career,DataCenter.Instance.roleSelfVo.roleDyVo.sex);
					_nameTxt.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName+":";
				}
				else if(data.player_type==TypeStory.PlayType_Monster)
				{//怪物
					_nameTxt.text=MonsterBasicManager.Instance.getMonsterBasicVo(data.NPC_id).name+":";
					url=MonsterBasicManager.Instance.getShowURL(data.NPC_id);
				}
				_downContainer.setRoleIcon(data.player_type,url);
				onResize(null);
				_txt.start();
				_nextStoryId=data.next_id;
			}
			else 
				close();
		}
		
		private function close(e:MouseEvent=null):void
		{
			hanleDialogTask();
			showNextStory();
			PopUpManager.removePopUp(this);
			_txt.stop();
		}
		/**处理对话任务
		 */
		private function hanleDialogTask():void
		{
			if(_storyShowVo)//如果为对话任务的 剧情
			{
				switch(_storyShowVo.storyPositionType)  //剧情显示的地方
				{
					case TypeStory.StoryPositionType_TaskDialog: //以任务对话的形式显示
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_NpcDialogTask,_storyShowVo.npcHandleVo);
						break;
					case TypeStory.StoryPositionType_RaidStart: //副本开始时候显示
						YFEventCenter.Instance.dispatchEventWith(StoryEvent.RaidStoryStartComplete);
						break;
					case TypeStory.StoryPositionType_RaidEnd://副本结束的时候显示
						YFEventCenter.Instance.dispatchEventWith(StoryEvent.RaidStoryEndComplete);
						break;
					case TypeStory.StoryPositionType_AccecptTask: //接受任务
					case TypeStory.StoryPositionType_FinishTask: //完成任务
					case TypeStory.StoryPositionType_ReachTask: //完成任务
						NewGuideManager.DoGuide(); //剧情播后继续引导
						break;
				}
			}
		}
		
		private function removeEvent():void
		{
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,onResize);
			_goOn.removeEventListener(MouseEvent.CLICK,playNext);
			_skip.removeEventListener(MouseEvent.CLICK,showNextStory);
		}
		
		/**引导
		 */
		public function handleGuide():Boolean
		{
			if(stage)
			{
				return true;
			}
			return false;
		}
		
		
		
		
		override public function dispose(e:Event=null):void
		{
			removeEvent();
			_txt.stop();
			TweenLite.killTweensOf(_downContainer);
			TweenLite.killTweensOf(_maskUp);
			
			_maskUp=null;
			_maskDown=null;
			_txt=null;
			_sp=null;
			_dataToShow.length=0;
			_skip=null;
			_goOn=null;
			_downContainer.dispose();
			_downContainer=null;
			_storyShowVo=null;
			super.dispose();
		}
	}
}