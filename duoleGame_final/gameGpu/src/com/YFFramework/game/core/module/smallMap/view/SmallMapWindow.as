package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.map.rectMap.RectMapConfig;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.OneChildContainer;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapListItemVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	/**小窗口
	 * 2012-11-5 下午5:13:00
	 *@author yefeng
	 */
	public class SmallMapWindow extends Window
	{
		/**小地图背景
		 */		
		private static const SmallMapBgUrl:String=URLTool.getCommonAssets("smallMapBg.png");
		/** 背景地图宽
		 */
		private static const SmallMapBgWidth:int=631;
		/**背景地图高
		 */		
		private static const SmallMapBgHeight:int=406;
		/**当前地图的 视图
		 */		
		public var _currentSmallMapView:SmallMapView;
		/**世界地图点开后的小地图
		 */		
		private var _worldSmallMapView:SmallMapView;
		
		/**  flash 里面的  MC 元件
		 */		
		private var _mc:MovieClip;
		/**  怪物分布点
		 */		
		private var _monsterCheckBox:CheckBox;
		/**功能Npc
		 */		
		private var _funcNpcCheckBox:CheckBox;
		///其他npc
		private var _otherNPCFuncCheckBox:CheckBox
		/** x 输入框
		 */		
		private var _xInput:TextField;
		/** y 输入框
		 */		
		private var _yInput:TextField;
		/**背景图片
		 */		
		private var _bgMap:Sprite;
		private var _bgContainer:Sprite;
		/**  地图容器
		 */		
		private var _mapConatiner:OneChildContainer;
		/** 传送点 列表
		 */		
		private static const _exit_trunk_id:int=0;
		/** npc 列表 
		 */		
		private static const _npc_trunk_id:int=1;
		/**怪物 列表
		 */		
		private static const _monster_trunk_id:int=2;
		/**自动寻路  按钮
		 */		
		private var _autoSeachBtn:Button;
		/**当前地图 按钮
		 */		
		private var _currentMapButton:SimpleButton;
		/**世界地图button
		 */		
		private var _worldMapButton:SimpleButton;
		/**返回 按钮
		 */		
		private var _returnButton:Button;

		/** 场景信息描述
		 */		
		private var _mapDesTxt:TextField;
		
		
		/**世界地图  的整体架子
		 */		
		private var _worldMapView:WorldMapView;
		private var _tree:DoubleDeckTree;
		
		
		
		public function SmallMapWindow()
		{
			initUI();
			addEvents();
		}
		protected function initUI():void
		{
			_mc = initByArgument(930,580,"smallMapUI",WindowTittleName.mapTitle,true,DyModuleUIManager.petWinBg) as MovieClip;
			_bgContainer=Xdis.getChild(_mc,"bgContainer");
			_bgContainer.removeChildren();
			_bgMap=Xdis.getSpriteChild(_mc,"map_bg");
			loadBg();
			_mapConatiner=new OneChildContainer();
			_bgContainer.addChild(_mapConatiner);
			_currentSmallMapView=new SmallMapView();
			_mapConatiner.addChild(_currentSmallMapView);
			_currentSmallMapView.updatePop(true);
			
			_worldSmallMapView=new SmallMapView(false);
			///怪物分布点
			_monsterCheckBox=Xdis.getChild(_mc,"monsterZone_checkBox");
			//功能npc
			_funcNpcCheckBox=Xdis.getChild(_mc,"funcNPC_checkBox");
			//其他npc
			_otherNPCFuncCheckBox=Xdis.getChild(_mc,"otherNPC_checkBox");
			
			_tree=Xdis.getChild(_mc,"all_tree");
			_tree.trunkDefaultOpen=true;
			_tree.nodeRender=SmallMapListRender;
			var item:ListItem;
			item=new ListItem;
			item.label = LangBasic.SmallMap_Teleporter;
			_tree.addTrunk(item);
			item=new ListItem;
			item.label = LangBasic.SmallMap_NPC;
			_tree.addTrunk(item);
			item=new ListItem;
			item.label = LangBasic.SmallMap_Monster;
			_tree.addTrunk(item);
			
			_autoSeachBtn=Xdis.getChild(_mc,"autoSeach_button");
			
			_currentMapButton=Xdis.getChild(_mc,"currentMap_btn");
			_currentMapButton.visible=false;
//			_currentMapButton.label="当前地图";
			
			_worldMapButton=Xdis.getChild(_mc,"worldMap_btn");
			_worldMapButton.visible=false;
//			_worldMapButton.label="世界地图";
//			_worldMapButton.enabled=false;
			
			_returnButton=Xdis.getChild(_mc,"return_button");
			_returnButton.visible=false;
			
			_mapDesTxt=Xdis.getChild(_mc,"mapDesTxt");;
			_mapDesTxt.selectable=false;
			// x 输入文本
			_xInput=Xdis.getChild(_mc,"xTxt");
			//  y输入文本
			_yInput=Xdis.getChild(_mc,"yTxt");
			_xInput.restrict="0-9";
			_xInput.maxChars=4;
			_xInput.wordWrap=false;
			_xInput.multiline=false;
			_yInput.restrict="0-9";
			_yInput.maxChars=4;
			_yInput.multiline=false;
			_yInput.wordWrap=false;
			_monsterCheckBox.label="怪物分布";
			_funcNpcCheckBox.label="功能NPC";
			_otherNPCFuncCheckBox.label="其他NPC";
			_monsterCheckBox.selected=true;
			_funcNpcCheckBox.selected=true;
			_otherNPCFuncCheckBox.selected=true;
			_monsterCheckBox.textField.width=55;
			_funcNpcCheckBox.textField.width=55;
			_otherNPCFuncCheckBox.textField.width=55;
			
			//世界地图
			_worldMapView=new WorldMapView();
			_worldMapView.worldMapCallBack=worldMapCall;
			setContentXY(34,27);
		}
		/**加载背景图片 
		 */		
		private function loadBg():void
		{
			var loader:IconLoader=new IconLoader();
			loader.initData(SmallMapBgUrl,_bgMap);
		}
		/**世界地图回调
		 */		
		private function worldMapCall(mapId:int):void
		{
//			if(DataCenter.Instance.getMapId()!=mapId)
//			{
				_worldSmallMapView.updateMapChangeConfig(mapId);
				toggleView(_worldSmallMapView);
				_worldSmallMapView.x= -_worldSmallMapView.width*.5;
				_worldSmallMapView.y= -_worldSmallMapView.height*.5;
				_returnButton.visible=true;
//			}
//			else  //显示当前地图
//			{
//				toggleView(_currentSmallMapView);
//				_returnButton.visible=false;
//			}
		}
		

		/** 初始化传送点列表
		 */		
//		private function initExitList(xxObj:Object):void
//		{
//			_exit_list.removeAll();
//			var skipArr:Array=xxObj.skip;
//			var name:String;
//			var listItem:ListItem;
//			for each(var skipData:Object in skipArr)
//			{
//				listItem=new ListItem();
//				listItem.label=skipData.mapName;
//				listItem.data=new Point(skipData.selfX,skipData.selfY);
//				_exit_list.addItem(listItem);
//			}
//		}
		/**把树中所有节点的子节点移除*/
		private function clearTree():void
		{
			_tree.clearTrunkAllChilds(_exit_trunk_id);
			_tree.clearTrunkAllChilds(_npc_trunk_id);
			_tree.clearTrunkAllChilds(_monster_trunk_id);
		}
		/** 初始化npc列表 怪物列表  传送点列表
		 */		
		private function initmapConfigList():void
		{
			clearTree();
			var mapId:int=DataCenter.Instance.getMapId();
			///获取npc列表
			var arr:Array=Npc_PositionBasicManager.Instance.getMapMPCList(mapId);  ///该场景的  npc 列表
			var listItem:ListItem;
			var smallMapListItemVo:SmallMapListItemVo;
			for each(var npcPositonVo:Npc_PositionBasicVo in arr)
			{
				
				switch(npcPositonVo.type)
				{
					case TypeRole.SmallMapShowType_FuncNPC:  ///当为  npc时 
					case TypeRole.SmallMapShowType_OtherNPC:
						if(npcPositonVo.basic_id>0)
						{
							smallMapListItemVo=new SmallMapListItemVo();
							smallMapListItemVo.mapX=npcPositonVo.pos_x;
							smallMapListItemVo.mapY=npcPositonVo.pos_y;
							smallMapListItemVo.npcId=npcPositonVo.npc_id;
							smallMapListItemVo.type=SmallMapListItemVo.TypeNPC;
							listItem=new ListItem();
							listItem.label=npcPositonVo.small_map_des;
							listItem.vo=smallMapListItemVo;
							_tree.addNote(listItem,_npc_trunk_id);
						}
					break;
					case TypeRole.SmallMapShowType_MonsterZone: //怪物区域
						smallMapListItemVo=new SmallMapListItemVo();
						smallMapListItemVo.mapX=npcPositonVo.pos_x;
						smallMapListItemVo.mapY=npcPositonVo.pos_y;
						smallMapListItemVo.type=SmallMapListItemVo.TypePt;
						listItem=new ListItem();
						listItem.label=npcPositonVo.small_map_des;
						listItem.vo=smallMapListItemVo;
						_tree.addNote(listItem,_monster_trunk_id);
						break;
					case TypeRole.SmallMapShowType_TransferPt: //传送点
						smallMapListItemVo=new SmallMapListItemVo();
						smallMapListItemVo.mapX=npcPositonVo.pos_x;
						smallMapListItemVo.mapY=npcPositonVo.pos_y;
						smallMapListItemVo.type=SmallMapListItemVo.TypePt;
						listItem=new ListItem();
						listItem.label=npcPositonVo.small_map_des;
						listItem.vo=smallMapListItemVo;
						_tree.addNote(listItem,_exit_trunk_id);
						break;
				}
			}
		}
		/**初始化  怪物列表
		 */		
//		private function initMonsterList():void
//		{
//			_monster_list.removeAll();
//			var mapId:int=DataCenter.Instance.getMapId();
//			///获取npc列表
//			var arr:Array=Npc_PositionBasicManager.Instance.getMapMPCList(mapId);  ///该场景的  npc 列表
//			var listItem:ListItem;
//			for each(var npcPositonVo:Npc_PositionBasicVo in arr)
//			{
//				if(npcPositonVo.basic_id<=0)
//				{
//					if(npcPositonVo.type==TypeRole.SmallMapShowType_MonsterZone)
//					{
//						listItem=new ListItem();
//						listItem.label=npcPositonVo.small_map_des;
//						listItem.data=new Point(npcPositonVo.pos_x,npcPositonVo.pos_y);
//						_monster_list.addItem(listItem);
//					}
//				}
//			}
//		}
		
		protected function addEvents():void
		{
			_tree.addEventListener(Event.CHANGE,onListChange); 
			///   checkBox改变状态
			_monsterCheckBox.addEventListener(Event.CHANGE,onCheckBoxChange);
			// npc状态
			_funcNpcCheckBox.addEventListener(Event.CHANGE,onCheckBoxChange);
			//otherNPCFunc
			_otherNPCFuncCheckBox.addEventListener(Event.CHANGE,onCheckBoxChange);
			//自动寻路
			_autoSeachBtn.addEventListener(MouseEvent.CLICK,onClick);
			//当前地图
			_currentMapButton.addEventListener(MouseEvent.CLICK,onClick);
			// 世界地图
			_worldMapButton.addEventListener(MouseEvent.CLICK,onClick);
			//单击按钮返回
			_returnButton.addEventListener(MouseEvent.CLICK,onClick);
			//更新坐标 
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveForSmallMap,onHeroMove);
			
		}
		private  function onHeroMove(e:YFEvent):void
		{
			updateMapDescription();
		}
		/**单击按钮
		 */		
		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _autoSeachBtn:  ///自动寻路	  
					var xStr:String=StringUtil.trim(_xInput.text);
					var yStr:String=StringUtil.trim(_yInput.text);
					if(xStr!=""&&yStr!="")
					{
						var tileX:int=int(xStr);
						var tileY:int=int(yStr);
						if(tileX>=RectMapConfig.columns)
						{
							tileX=RectMapConfig.columns-1;
						}
						else if(tileX<0)
						{
							tileX=0;
						}
						if(tileY>=RectMapConfig.rows)
						{
							tileY=RectMapConfig.rows-1;
						}
						else if(tileY<0)
						{
							tileY=0;
						}
						_xInput.text=tileX+"";
						_yInput.text=tileY+"";
						var myPt:Point=RectMapUtil.getFlashCenterPosition(tileX,tileY);
						
						_currentSmallMapView.updateMoveToPt(myPt,DataCenter.Instance.getMapId());
					}
					break;
				case _currentMapButton:	//当前地图
					toggleView(_currentSmallMapView);
					_returnButton.visible=false;
					break;
				case _worldMapButton:	//世界地图
					_worldMapView.initLoad();
					toggleView(_worldMapView);
					_returnButton.visible=false;
					break;
				case _returnButton: ///返回到世界地图
					toggleView(_worldMapView); //显示世界地图
					_returnButton.visible=false;
					break;
			}
		}
		/**创建 ui 
		 */		
		private function toggleView(view:AbsView):void
		{
			_mapConatiner.addChild(view);
		}
		
		/**  改变checkBox状态
		 */		
		private function onCheckBoxChange(e:Event):void
		{
			switch(e.currentTarget)
			{
				case _monsterCheckBox:  // 怪物选中区域
					_currentSmallMapView.setMonsterZoneVisible(_monsterCheckBox.selected);
					break;
				case _funcNpcCheckBox: //  功能npc选中on区域
					_currentSmallMapView.setFuncNPCVisible(_funcNpcCheckBox.selected);
					break;
				case _otherNPCFuncCheckBox:  //其他 npc选中区域
					_currentSmallMapView.setOtherNPCVisible(_otherNPCFuncCheckBox.selected);
					break;
			}
		}

		private function onListChange(e:Event):void
		{
			var pt:Point;
			var smallMapListItemVo:SmallMapListItemVo;
			smallMapListItemVo=_tree.selectedItem.vo;
			if(smallMapListItemVo.type==SmallMapListItemVo.TypePt)
			{
				pt=new Point(smallMapListItemVo.mapX,smallMapListItemVo.mapY);
				_currentSmallMapView.updateMoveToPt(pt,DataCenter.Instance.getMapId());
			}
			else if(smallMapListItemVo.type==SmallMapListItemVo.TypeNPC)
			{
				var dyId:uint=smallMapListItemVo.npcId;
				_currentSmallMapView.closeToNPC(dyId); ///向npc
			}
		}
		
		
		/**初始化配置文件的 ui
		 * xxObj是地图文件数据对象
		 */		 
//		public function updateConfigUI(xxObj:Object):void
//		{
			//小地图更新配置
//			_smallMapView.updateMapConfig(xxObj);
//			centerSmallMap(DataCenter.Instance.getMapId());
			
//			initExitList(xxObj);
//		}
		
		public function updateMapChange():void
		{
			_currentSmallMapView.updateMapChangeConfig(DataCenter.Instance.getMapId());
			initmapConfigList();
//			initMonsterList();
			updateMapDescription();
			_currentSmallMapView.x=getCenterSmallMapX(DataCenter.Instance.getMapId());
			_currentSmallMapView.y=getCenterSmallMapY(DataCenter.Instance.getMapId());
		}
		/**更新地图描述
		 */		
		private function  updateMapDescription():void
		{
			var tilePt:Point=HeroPositionProxy.getTilePositon();
			_mapDesTxt.text=DataCenter.Instance.mapSceneBasicVo.mapDes+"("+tilePt.x+","+tilePt.y+")";
		}
		/**居中地图 获取x 值
		 */		
		private function getCenterSmallMapX(mapId:int):Number
		{
			return -DataCenter.Instance.getSmallMapWidth(mapId)*0.5;
		}
		private function getCenterSmallMapY(mapId:int):Number
		{
			return -DataCenter.getSmallMapMinHeight(mapId)*0.5;
		}
		
	}
}