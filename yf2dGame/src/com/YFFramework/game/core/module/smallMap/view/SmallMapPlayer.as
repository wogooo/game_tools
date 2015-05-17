package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.ui.yfComponent.YFSmallMapIcon;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.core.world.movie.player.AbsAnimatorView;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**2012-11-6 下午3:09:51
	 *@author yefeng
	 */
	public class SmallMapPlayer extends YFSmallMapIcon
	{
		private var _nameLabel:YFLabel;
		private var _roleDyVo:MonsterDyVo;
		public function SmallMapPlayer(roleDyVo:MonsterDyVo)
		{
			_roleDyVo=roleDyVo;
			var skinId:int=0;
			switch(roleDyVo.bigCatergory)
			{
				case TypeRole.BigCategory_NPC:  // npc 
					skinId=1;
					buttonMode=true;
					break;
				case TypeRole.BigCategory_Monster:  // 怪物
					skinId=2;
					break;
				case TypeRole.BigCategory_SkipWay: ///传送点
					skinId=3;
					break;
				case TypeRole.BigCategory_Player:  //如果为队友 则显示队友的图标
					skinId=4;
					break;
				case TypeRole.BigCategory_MonsterZone: ///怪物区域 图标
					skinId=5;
					break;
			}
			super(skinId);
			mouseChildren=false;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			toolTip=_roleDyVo.roleName;
			if(_roleDyVo.bigCatergory==TypeRole.BigCategory_NPC||_roleDyVo.bigCatergory==TypeRole.BigCategory_SkipWay)
			{
				_nameLabel=new YFLabel();
				addChild(_nameLabel);
				text=_roleDyVo.roleName;
				_nameLabel.setColor(0xFFFF99);
			}
		}
		/**更新世界坐标
		 * @param ratio 缩放因子
		 */		
		public function updateMapPosition(ratio:Number):void
		{
			x=_roleDyVo.mapX*ratio;
			y=_roleDyVo.mapY*ratio;
		}
		
		/** 更新flash窗口坐标
		 * @param ratio
		 */		
//		public function updateViewPortPosition(ratio:Number):void
//		{
//			var myPt:Point=AbsAnimatorView.getFlashPt(_roleDyVo.mapX,_roleDyVo.mapY);
//			x=myPt.x*ratio;
//			y=myPt.y*ratio;
//		}
		private function set text(value:String):void
		{
			_nameLabel.text=value;
			_nameLabel.exactWidth();
			_nameLabel.y=_bitmap.y-_nameLabel.textHeight;
			_nameLabel.x=-_nameLabel.textWidth*0.5
		}
		
		public function get roleDyVo():MonsterDyVo
		{
			return _roleDyVo;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_nameLabel=null;
			_roleDyVo=null;
		}
	}
}