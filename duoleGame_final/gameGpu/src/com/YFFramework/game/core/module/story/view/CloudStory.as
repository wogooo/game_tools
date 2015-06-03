package com.YFFramework.game.core.module.story.view
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.story.manager.StoryResManager;
	import com.YFFramework.game.core.module.story.model.StoryBasicVo;
	import com.YFFramework.game.core.module.story.model.TypeStory;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/***
	 *在中间飘上来的文字剧情
	 *@author ludingchang 时间：2014-1-15 下午1:48:48
	 */
	public class CloudStory extends AbsView
	{

		private var _name_txt:TextField;

		private var _content_txt:TextField;

		private var _icon:Sprite;
		
		public function CloudStory()
		{
			super(false);
		}
		
		protected override function initUI():void
		{
			var view:MovieClip=ClassInstance.getInstance("CloudStoryMC") as MovieClip;
			_name_txt=view.name_txt;
			_content_txt=view.content_txt;
			_icon=Xdis.getChild(view,"icon_iconImage");
			addChild(view);
		}
		
		public function show(vo:StoryBasicVo):void
		{
			var data:StoryBasicVo=vo;
			var url:String="";
			if(data.player_type==TypeStory.PlayType_NPC)//为npc
			{
				url=Npc_ConfigBasicManager.Instance.getSmallIcon(data.NPC_id);
				_name_txt.text=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(data.NPC_id).name+":";
				_icon.x=575;
			}
			else if(data.player_type==TypeStory.PlayType_Hero)
			{//自己
				url=CharacterPointBasicManager.Instance.getShowURL(DataCenter.Instance.roleSelfVo.roleDyVo.career,DataCenter.Instance.roleSelfVo.roleDyVo.sex);
				_name_txt.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName+":";
				_icon.x=0;
			}
			else if(data.player_type==TypeStory.PlayType_Monster)
			{//怪物
				_name_txt.text=MonsterBasicManager.Instance.getMonsterBasicVo(data.NPC_id).name+":";
				url=MonsterBasicManager.Instance.getShowURL(data.NPC_id);
				_icon.x=575;
			}
			
			StoryResManager.Instence.getNPCicon(url,getNPCcallback);
			
			_content_txt.text=data.text;
		}
		
		private function getNPCcallback(dis:DisplayObject):void
		{
			_icon.removeChildren();
			_icon.addChild(dis);
		}
		
		public override function dispose(e:Event=null):void
		{
			super.dispose();
			_name_txt=null;
			 _content_txt=null;
			 _icon=null;
		}
		
	}
}