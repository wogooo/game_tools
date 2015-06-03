package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.MemberDyVo;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-9 上午10:57:09
	 * 队员场景组件
	 */
	public class TeamMemberView extends AbsView{
		
		public static var speed:Number = 4;
		private var _dyId:int;
		private var _mc:MovieClip;
		private var _index:int;
		private var _toY:int;
		
		private var hp_progressBar:ProgressBar;
		private var mp_progressBar:ProgressBar;
		
		public function TeamMemberView(dyId:int,index:int){
			_dyId = dyId;
			_index = index;
			_mc = ClassInstance.getInstance("teamIconView");
			AutoBuild.replaceAll(_mc);
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			mp_progressBar = Xdis.getChild(_mc,"mp_progressBar");	
			addChild(_mc);
			this.y = index * 75+125;
			super(false);
		}
		
		/**更新组件View 
		 */		
		public function updateMemberView():void{
			var memberDyVo:MemberDyVo = TeamDyManager.Instance.getMemberDyVo(_dyId);
			_mc.lvTxt.text = memberDyVo.lv;
			_mc.nameTxt.text = memberDyVo.name;
			
			hp_progressBar.percent=memberDyVo.hpPercent;
			mp_progressBar.percent=memberDyVo.mpPercent;
			
			if(_mc.leaderImg.numChildren>0)	_mc.leaderImg.removeChildAt(0);
			if(memberDyVo.dyId==TeamDyManager.LeaderId)	_mc.leaderImg.addChild(ClassInstance.getInstance("leaderFlag") as MovieClip);
		
			if(_mc.iconImg.numChildren>0)	_mc.iconImg.removeChildAt(0);
			IconLoader.initLoader(CharacterPointBasicManager.Instance.getTeamSceneIconURL(memberDyVo.profession,memberDyVo.sex),_mc.iconImg);
			if(memberDyVo.isOnline==false)	_mc.iconImg.filters=FilterConfig.dead_filter;
			else	_mc.iconImg.filters=null;
		}
		
		/**下线队员组件图标更变
		 */		
		public function offlineIconImg():void{
			_mc.iconImg.filters=FilterConfig.dead_filter;
		}
		
		/**上线队员组件图标更变
		 */		
		public function onlineIconImg():void{
			_mc.iconImg.filters=null;
		}
		
		/**更新组件Hp,Mp的View 
		 */	
		public function updateHpMp():void{
			hp_progressBar.percent=TeamDyManager.Instance.getMemberDyVo(_dyId).hpPercent;
			mp_progressBar.percent=TeamDyManager.Instance.getMemberDyVo(_dyId).mpPercent;
		}
		
		/**更新组件等级 
		 */		
		public function updateLv(lv:int):void{
			_mc.lvTxt.text = lv;
		}
		
		/**组件移动到index 
		 * @param index 终点位置
		 */		
		public function shiftTo(index:int):void{
			if(_index<index)	shiftDown(index);
			else if(_index>index)	shiftUpTo(index);
		}
		
		/**组件向下移动到终点
		 * @param destination 最终位置index
		 */
		public function shiftDown(destination:int):void{
			_toY = this.y + (destination-_index)*80;
			_index = destination;
			UpdateManager.Instance.framePer.regFunc(onDownFrame);
		}
		
		/**组件向上移动到终点
		 * @param destination 最终位置index
		 */		
		public function shiftUpTo(destination:int):void{
			_toY = this.y - (_index-destination)*80;
			_index = destination;
			UpdateManager.Instance.framePer.regFunc(onUpFrame);
		}
		
		/**组件向上移动 一个
		 */		
		public function shiftUp():void{
			_index--;
			_toY = this.y-80;
			UpdateManager.Instance.framePer.regFunc(onUpFrame);
		}
		
		/**清除对象
		 * @param e 
		 */		
		override public function dispose(e:Event=null):void{
			hp_progressBar=null;
			mp_progressBar=null;
			this.removeChild(_mc);
			if(_mc.iconImg.numChildren>0)	_mc.iconImg.removeChildAt(0);
			_mc=null;
			super.dispose();
		}
		
		/**向上移动更新
		 * @param e Event.EnterFrame
		 */		
		private function onUpFrame(e:Event=null):void{
			var less:Number = this.y-_toY;
			this.y -= less/speed;
			if(Math.abs(less)<1.1){
				this.y = _toY;
				UpdateManager.Instance.framePer.delFunc(onUpFrame);
			}
		}
		
		/**向下移动更新
		 * @param e Event.EnterFrame
		 */	
		private function onDownFrame(e:Event=null):void{
			var less:Number = _toY - this.y;
			this.y += less/speed;
			if(Math.abs(less)<1.1){
				this.y = _toY;
				UpdateManager.Instance.framePer.delFunc(onUpFrame);
			}
		}
		
		/**获取人物ID 
		 * @return 人物dyId
		 */		
		public function getDyId():int{
			return _dyId;
		}
		
		/**获取index
		 * @return int	index
		 */		
		public function getIndex():int{
			return _index;
		}
	}
} 