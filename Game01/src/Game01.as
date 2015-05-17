package
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.file.FilesLoader;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.core.net.socket.events.SocketEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.controls.YFAlert;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.FightEffectBasicManager;
	import com.YFFramework.game.core.global.manager.FightSkillBasicManager;
	import com.YFFramework.game.core.global.manager.GoodsBasicManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.manager.MountBasicManager;
	import com.YFFramework.game.core.global.manager.RoleBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.manager.SkinManager;
	import com.YFFramework.game.core.global.manager.SkipPointBasicManager;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.mapScence.manager.MapSceneBasicManager;
	import com.YFFramework.game.core.module.npc.manager.NPCBasicManager;
	import com.YFFramework.game.core.module.pet.manager.PetBasicManager;
	import com.YFFramework.game.core.scence.ScenceInitManager;
	import com.YFFramework.game.gameConfig.ConfigManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF(width="1000",height="600",frameRate="60",backgroundColor="#000000")]
	public class Game01 extends Sprite
	{
		private var _mainView:GameView;
		/**swf 资源列表
		 */
		private var _swfArr:Vector.<Object>;
		
		/** 策划数据表文件
		 */
		private var _fileArr:Vector.<Object>;
		public function Game01()
		{
			if(stage)
			{
				loadConfig();
			}
		}
		private function loadConfig():void
		{
			var configUrl:String="config.xml?"+getTimer();
			var fileLoader:FileLoader=new FileLoader();
			fileLoader.loadCompleteCallBack=configCompleteLoad;
			fileLoader.load(configUrl);
		}
		private function configCompleteLoad(loader:FileLoader):void
		{
			var data:XML=new XML(loader.data);
			loader=null;
			ConfigManager.Instance.parseData(data);
			URLTool.initRoot(ConfigManager.Instance.getRoot(),ConfigManager.Instance.getVersionStr());
			loadUIRes();
		}
		/** 加载游戏中常用的数值表
		 */		
		private function loadFileRes():void
		{			_fileArr=ConfigManager.Instance.getFileList();
			var filesLoader:FilesLoader=new FilesLoader();
			filesLoader.loadCompleteCallBack=completeFilesLoad;
			filesLoader.load(_fileArr);
		}
		/**配置文件加载完成
		 */		
		private function completeFilesLoad(loader:FilesLoader):void
		{
			var  dataArr:Array=loader.dataArr;  ///保存所有的表数据
			loader.dispose();
			var jsonObj:Object;
			for each (var obj:Object in dataArr) ///处理每一张表 
			{
				jsonObj=JSON.parse(obj.data);
				switch(obj.id)
				{
					case 1000:
						//角色基础属性表
						RoleBasicManager.Instance.cacheData(jsonObj);
						break;
					case 1001:
						//装备基础属性表
						GoodsBasicManager.Instance.cacheEquipData(jsonObj);
						break;
					case 1002:
						//装备皮肤图标id总表
						SkinManager.Instance.cacheData(jsonObj);
						break;
					case 1003:
						//药品表
						GoodsBasicManager.Instance.cacheMedicineData(jsonObj);
						break;
					case 2001:
						MonsterBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3001: ///技能特效播放数据表
						//
						FightEffectBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3002:  ///战斗技能表
						FightSkillBasicManager.Instance.cacheData(jsonObj);
						break;
					case 3003:  ///战斗技能表
						SkillBasicManager.Instance.cacheData(jsonObj);
						break;
					case 4000:  //宠物基本表
						PetBasicManager.Instance.cacheData(jsonObj);
						break;
					case 4010:
						MountBasicManager.Instance.cacheData(jsonObj);
						break;
					case 6000: ///场景配置表 mapScene.json
						MapSceneBasicManager.Instance.cacheData(jsonObj);
						break;
					case 6001: ///场景跳转配置表 skipPoint.json
						SkipPointBasicManager.Instance.cacheData(jsonObj);
						break;
					case 6100: ///npc配置表 npcProp.json
						NPCBasicManager.Instance.cacheData(jsonObj);
						break;

					
					
				}
			}
			///进入主程序
			gameMain();
		}
		/**  文本加载 
		 */		
		private function filesProgress(e:ProgressEvent,currentIndex:Number):void
		{
			var percent:Number=Number(e.bytesLoaded*100/e.bytesTotal);
			print(this,"正在加载"+_fileArr[currentIndex].tips,"百分比:"+percent+"%");
		}
		private function loadUIRes():void
		{
			_swfArr=ConfigManager.Instance.getUIList();
			var loader:UISLoader=new UISLoader();
			loader.loadCompleteCallBack=completeUILoad;
			loader.progressCallBack=uiProgress;
			loader.load(_swfArr);
		}
		
		private function uiProgress(e:ProgressEvent,currentIndex:Number):void
		{
			var percent:Number=Number(e.bytesLoaded*100/e.bytesTotal);
			print(this,"正在加载"+_swfArr[currentIndex].tips,"百分比:"+percent+"%");
		}
		private function completeUILoad(data:Vector.<Object>):void
		{
			loadFileRes();
		}
		private function gameMain():void
		{
			YFEventCenter.Instance.addEventListener(SocketEvent.Connnect,onSocketConenct);
			YFEventCenter.Instance.addEventListener(SocketEvent.Close,onSocketConenct);
			YFEventCenter.Instance.addEventListener(SocketEvent.IOError,onSocketConenct);
			YFEventCenter.Instance.addEventListener(SocketEvent.SecurityError,onSocketConenct);
			YFSocket.Instance.initData(ConfigManager.Instance.getIp().toString(),ConfigManager.Instance.getPort(),ConfigManager.Instance.getCheckPort());
			print(this,ConfigManager.Instance.getIp().toString(),ConfigManager.Instance.getPort(),ConfigManager.Instance.getCheckPort());
			StageProxy.Instance.configure(stage);
			_mainView=new GameView(this);
			var controller:ControlInit=new ControlInit();
			addEvents();
		}
		
		/** 服务器连接成功开始登陆
		 */
		private function initSocket():void
		{
  			ScenceManager.Instance.enterScence(ScenceInitManager.GameLogin);

		}
		private function onSocketConenct(e:YFEvent):void
		{
			switch(e.type)
			{
				case SocketEvent.Connnect:
					initSocket();
					break;
				case SocketEvent.Close:
					print(this,"服务器已经关闭");
					YFAlert.show("服务器已经关闭","提示:",0);
					break;
				case SocketEvent.IOError:
				case SocketEvent.SecurityError:
					YFAlert.show("服务器没有开启，或者未连接上！","提示:",0);
					
					break;
				
			}
		}
		
		private function addEvents():void
		{
		//	addEventListener(Event.ENTER_FRAME,onUpdate);
			var  timer:Timer=new Timer(33);
			timer.addEventListener(TimerEvent.TIMER,onUpdate);
			timer.start();
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,onResize);
			///登陆   成功 进入场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.Login,onEnterScence);
		}
		
		private function onEnterScence(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.Login,onEnterScence);
			//游戏成功登陆后启动游戏
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GameIn,e.param);
		}
		
		private function onUpdate(e:Event):void
		{
			UpdateManager.Instance.update();
		}
		
		private function onResize(e:Event):void
		{
			ResizeManager.Instance.resize();
		}
		
	}
}