package com.YFFramework.game.core.module.gameView.view
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-29 下午1:57:44
	 * 
	 */
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	
	public class HeroIconView extends AbsView
	{
		private const WIDTH:int=174;//进度条的长度
		
		private var _mc:MovieClip;
		
		private var hp_progressBar:ProgressBar;
		private var mp_progressBar:ProgressBar;
		
		public function HeroIconView(mc:MovieClip)
		{
			super(false);
			_mc=mc;
			
			AutoBuild.replaceAll(_mc);
			
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			mp_progressBar = Xdis.getChild(_mc,"mp_progressBar");
		}
		
		public function updateInfo():void
		{		
			_mc.player_name.text=DataCenter.Instance.roleSelfVo.roleDyVo.roleName;	
			updateHp();
			updateMp();
			updateLevel();
//			updateIconImg();
//			updatePKMode();
		}
		
		public function updateHp():void
		{
			_mc.hp_tf.text=DataCenter.Instance.roleSelfVo.roleDyVo.hp+"/"+DataCenter.Instance.roleSelfVo.roleDyVo.maxHp;
			hp_progressBar.percent=DataCenter.Instance.roleSelfVo.roleDyVo.hp/DataCenter.Instance.roleSelfVo.roleDyVo.maxHp;
		}
		
		public function updateMp():void
		{
			_mc.mp_tf.text=DataCenter.Instance.roleSelfVo.roleDyVo.mp+"/"+DataCenter.Instance.roleSelfVo.roleDyVo.maxMp;
			mp_progressBar.percent=DataCenter.Instance.roleSelfVo.roleDyVo.mp/DataCenter.Instance.roleSelfVo.roleDyVo.maxMp;
		}
		
		public function updateLevel():void
		{
			_mc.level.text=DataCenter.Instance.roleSelfVo.roleDyVo.level+"";
		}
		
		public function updatePKMode():void
		{
			_mc.fightStatus.text=TypeRole.getPKModeName(DataCenter.Instance.roleSelfVo.pkMode);
		}
		
		/**更新队长图标 
		 */		
		public function updateLeaderFlag():void{
			if(_mc.leaderImg.numChildren>0)	_mc.leaderImg.removeChildAt(0);
			if(DataCenter.Instance.roleSelfVo.roleDyVo.dyId==TeamDyManager.LeaderId)	_mc.leaderImg.addChild(ClassInstance.getInstance("leaderFlag") as MovieClip);
		}
		
		/**更新自己图标 
		 */
		public function updateIconImg():void{
			if(_mc.iconImg.numChildren>0)	_mc.iconImg.removeChildAt(0);
			IconLoader.initLoader(CharacterPointBasicManager.Instance.getShowURL(DataCenter.Instance.roleSelfVo.roleDyVo.career,DataCenter.Instance.roleSelfVo.roleDyVo.sex),_mc.iconImg,null,{x:8,y:8});
		}
	}
} 