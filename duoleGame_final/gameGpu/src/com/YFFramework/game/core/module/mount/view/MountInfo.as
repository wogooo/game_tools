package com.YFFramework.game.core.module.mount.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.module.mount.events.MountEvents;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.manager.MountLvBasicManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.YFFramework.game.core.module.mount.view.render.MountRender;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.MouseDownKeepCall;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.Quality;
	import com.msg.mount_pro.CDropMount;
	import com.msg.mount_pro.CMountFight;
	import com.msg.mount_pro.CTakebackMount;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flashx.textLayout.elements.BreakElement;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 下午2:25:07
	 * 坐骑信息面板
	 */
	public class MountInfo{
		
		private var _mc:MovieClip;
		private var _mountWindow:MountWindow;
		
		private var _mountList:List;

		//private var release_button:Button;
		private var fight_button:Button;
		private var left_button:SimpleButton;
		private var right_button:SimpleButton;
		private var _coverSp:Sprite;
		
		public function MountInfo(mc:MovieClip,mountWindow:MountWindow){
			_mc = mc;
			_mountWindow = mountWindow;
			AutoBuild.replaceAll(_mc);
			
			left_button = _mc.right;
			new MouseDownKeepCall(left_button,onLeft,8);

			right_button = _mc.left;
			new MouseDownKeepCall(right_button,onRight,8);
			
			_coverSp = Xdis.getChild(_mc,"cover");
		}
		
		/**初始化窗口
		 */		
		public function initWin():void{
			_mountList = Xdis.getChild(_mc,"mount_list");
			_mountList.itemRender = MountRender;
			_mountList.addEventListener(Event.CHANGE,updateCrtMount);
			//release_button = Xdis.getChildAndAddClickEvent(onRelease,_mc,"release_button");
			fight_button = Xdis.getChildAndAddClickEvent(onFight,_mc,"fight_button");
		}
		
		/**切换界面更新
		 */
		public function onTabUpdate():void{
			updateMountList();
			updateCrtMount();
		}
		
		/**更新坐骑列表
		 */	
		public function updateMountList():void{
			_mountList.removeAll();
			
			var item:ListItem;
			var arr:Array = MountDyManager.Instance.getMountsIdArr();
			var len:int=arr.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				var mount:MountDyVo = MountDyManager.Instance.getMount(arr[i]);
				item.name = MountBasicManager.Instance.getMountBasicVo(mount.basicId).mount_type;
//				item.lv = mount.level;
				item.dyId = mount.dyId;
				item.quality = MountBasicManager.Instance.getMountBasicVo(mount.basicId).quality;
				if(mount.dyId==MountDyManager.fightMountId)	item.status="出战";
				else	item.status="休息";
				item.url = MountBasicManager.Instance.getMountIconURL(mount.basicId);
				_mountList.addItem(item);
				if(mount.dyId==MountDyManager.crtMountId)	_mountList.selectedIndex=i;
			}
		}
		
		/**更新选中的坐骑信息 
		 * @param e
		 */	
		public function updateCrtMount(e:Event=null):void{
			if(e!=null)	MountDyManager.crtMountId = (e.currentTarget as List).selectedItem.dyId;
			while(_coverSp.numChildren>0){
				_coverSp.removeChildAt(0);
			}
			if(MountDyManager.crtMountId!=-1){
				var mount:MountDyVo = MountDyManager.Instance.getCrtMount();
				var mountBasic:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
//				var mul:Number = MountLvBasicManager.Instance.getMountLvBasic(mount.level).mul;
				_mc.mountTypeTxt.text = "坐骑类型："+MountBasicManager.Instance.getMountBasicVo(mount.basicId).mount_type;
//				_mc.mountLvTxt.text = "坐骑阶数："+mount.level;
				_mc.t0.text=mountBasic.displaySpeed;
//				_mc.t1.text="体质："+Math.round(mountBasic.physique*mul);
//				_mc.t2.text="力量："+Math.round(mountBasic.strength*mul);
//				_mc.t3.text="敏捷："+Math.round(mountBasic.agility*mul);
//				_mc.t4.text="智力："+Math.round(mountBasic.intell*mul);
//				_mc.t5.text="精神："+Math.round(mountBasic.spirit*mul);
				_mc.t1.text=Math.round(mountBasic.physique);
				_mc.t2.text=Math.round(mountBasic.strength);
				_mc.t3.text=Math.round(mountBasic.agility);
				_mc.t4.text=Math.round(mountBasic.intell);
				_mc.t5.text=Math.round(mountBasic.spirit);
//				_mc.t6.text="+"+mount.addPhy;
//				_mc.t7.text="+"+mount.addStr;
//				_mc.t8.text="+"+mount.addAgi;
//				_mc.t9.text="+"+mount.addInt;
//				_mc.t10.text="+"+mount.addSpi;
				if(mount.dyId==MountDyManager.fightMountId)	fight_button.textField.text = "休  息";
				else	fight_button.textField.text = "骑  乘";
				fight_button.enabled=true;
				//release_button.enabled=true;
				_mountWindow.updateMountPlayer();
				switch(mountBasic.quality){
					case TypeProps.QUALITY_WHITE:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityWhite")));
						break;
					case TypeProps.QUALITY_GREEN:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityGreen")));
						break;
					case TypeProps.QUALITY_BLUE:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityBlue")));
						break;
					case TypeProps.QUALITY_PURPLE:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityPurple")));
						break;
					case TypeProps.QUALITY_ORANGE:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityOrange")));
						break;
					case TypeProps.QUALITY_RED:
						_coverSp.addChild(new Bitmap(ClassInstance.getInstance("QualityRed")));
						break;
				}
			}else{
				_mc.mountTypeTxt.text = "";
				_mc.mountLvTxt.text = "";
				for(var i:int=0;i<11;i++){
					_mc["t"+i].text="";
				}
				fight_button.enabled=false;
				//release_button.enabled=false;
			}
		}
		
		/**清除对象
		 */		
		public function dispose():void{
			_mountList.removeAll();
			_mountList.removeEventListener(Event.CHANGE,updateCrtMount);
			_mountList=null;
//			release_button.removeEventListener(MouseEvent.CLICK,onRelease);
//			release_button=null;
			fight_button.removeEventListener(MouseEvent.CLICK,onFight);
			fight_button=null;
		}
		
//		/**放生按钮点击 
//		 * @param e
//		 */		
//		private function onRelease(e:MouseEvent):void{
//			var txt:String = "确定要放生"+MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getCrtMount().basicId).mount_type+"吗？放生后，坐骑将永久消失";
//			Alert.show(txt,'放生宠物',onReleaseConfirm,["确认","取消"]);
//		}
//		
//		/**确认放生按钮点击 
//		 * @param e
//		 */		
//		private function onReleaseConfirm(e:AlertCloseEvent):void{
//			if(e.clickButtonIndex==1){
//				var msg:CDropMount = new CDropMount();
//				msg.mountId = MountDyManager.crtMountId;
//				YFEventCenter.Instance.dispatchEventWith(MountEvents.DropMountReq,msg);
//			}
//		}
		
		/**坐骑出战按钮点击 
		 * @param e
		 */		
		private function onFight(e:MouseEvent):void{
			if(MountDyManager.Instance.getCrtMount().dyId==MountDyManager.fightMountId){
				YFEventCenter.Instance.dispatchEventWith(MountEvents.TakebackMountReq);
			}else{
				var msg:CMountFight = new CMountFight();
				msg.mountId = MountDyManager.crtMountId;
				YFEventCenter.Instance.dispatchEventWith(MountEvents.FightMountReq,msg);
			}
		}
		
		/**坐骑左转 
		 * @param e
		 */		
		private function onLeft(e:MouseEvent=null):void{
			_mountWindow.turnLeft();
		}
		
		/**坐骑右转 
		 * @param e
		 */	
		private function onRight(e:MouseEvent=null):void{
			_mountWindow.turnRight();
		}
		
		
		
		
		///处理新手引导
		
		/**处理新手引导
		 */
		public function handleMountNewGuideFight():Boolean
		{
			if(NewGuideStep.MountGuideStep==NewGuideStep.MountWindowRectFightBtn)
			{
//				var pt:Point=UIPositionUtil.getPosition(fight_button,_mc);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,fight_button.width,fight_button.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(_mc);
				var pt:Point=UIPositionUtil.getUIRootPosition(fight_button);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,fight_button.width,fight_button.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,fight_button);
				return true;
			}
			return false;
		}
		
		

	}
} 