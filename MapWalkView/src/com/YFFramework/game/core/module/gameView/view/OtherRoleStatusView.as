package com.YFFramework.game.core.module.gameView.view
{
	/**@author yefeng
	 * 2013 2013-3-28 上午11:26:39 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.CharacterPointBasicVo;
	import com.YFFramework.game.core.global.model.MonsterBasicVo;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	
	import yf2d.display.Image;
	
	/**角色信息
	 */	
	public class OtherRoleStatusView extends AbsView
	{
		/**角色信息
		 */		
		public var roleDyVo:RoleDyVo;
		private var _mc:MovieClip;
		
		private var hp_progressBar:ProgressBar;
		private var mp_progressBar:ProgressBar;
		/** 图像
		 */		
		private var _imageIcon:IconImage;
		
		public function OtherRoleStatusView(mc:MovieClip)
		{
			_mc=mc;
			super(false);
		}
		
		
		override protected function initUI():void
		{
			super.initUI();
			addChild(_mc);
			AutoBuild.replaceAll(_mc);
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			mp_progressBar = Xdis.getChild(_mc,"mp_progressBar");
			_imageIcon=new IconImage();
			addChild(_imageIcon);
			_imageIcon.x=30;
			_imageIcon.y=30;
		}

		public function updateInfo():void
		{
			if(roleDyVo)
			{
				var url:String;
				switch(roleDyVo.bigCatergory)
				{
					case TypeRole.BigCategory_Player:
					case TypeRole.BigCategory_Pet:
						
						_mc.level.text=roleDyVo.level+"";
						_mc.player_name.text=roleDyVo.roleName;
						_mc.hp_tf.text=roleDyVo.hp+"/"+roleDyVo.maxHp;
						_mc.mp_tf.text=roleDyVo.mp+"/"+roleDyVo.maxMp;
						mp_progressBar.percent=roleDyVo.mp/roleDyVo.maxMp;
						if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)  ///人物  
							url=CharacterPointBasicManager.Instance.getShowURL(roleDyVo.career,roleDyVo.sex);
						else ///宠物
							url=PetBasicManager.Instance.getShowURL(roleDyVo.basicId);
						break;
					case TypeRole.BigCategory_Monster:
						_mc.level.text=roleDyVo.level+"";
						_mc.player_name.text=roleDyVo.roleName;
						_mc.hp_tf.text=int(100*roleDyVo.hp/roleDyVo.maxHp)+"%";
						_mc.mp_tf.text="100%100";
						url=MonsterBasicManager.Instance.getShowURL(roleDyVo.basicId);
						break;
					
				}
				hp_progressBar.percent=roleDyVo.hp/roleDyVo.maxHp;
				_imageIcon.url=url;				
				if(roleDyVo.bigCatergory==TypeRole.BigCategory_Player)
				{
					_imageIcon.x=8;
					_imageIcon.y=8;
				}
				else 
				{
					_imageIcon.x=20;
					_imageIcon.y=20;
				}
			}
		}
		
	}
}