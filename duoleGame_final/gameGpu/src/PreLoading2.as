package 
{ 
	/**@author yefeng
	 */  
	import com.YFFramework.core.FlashConfig;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.proxy.StageProxy; 
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.StringUtil; 
	import com.YFFramework.game.gameConfig.ConfigManager;  
	import com.YFFramework.game.gameConfig.URLTool; 
	import flash.display.DisplayObject; 
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.ui.ContextMenu; 
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	 
	[SWF(width="1000",height="600",frameRate="60",backgroundColor="#000000")]
	public class PreLoading2 extends Sprite
	{
		private var menu:ContextMenu;  
 
		private var progressBar:LoadBar;
		private var loadContainer:AbsView; 
		private var _textFiled:TextField;
		public function PreLoading2()
		{ 
			if(stage) 
			{   
			  	print(this,FlashConfig.Instance.getFlashVersion());
				
				StageProxy.Instance.configure(stage);
				var menu:ContextMenu = new ContextMenu();
				var item:ContextMenuItem = new ContextMenuItem("杭州多乐网络科技",true,false);
				menu.customItems.push(item);
				item = new ContextMenuItem("勇者之光",true,false);
				menu.customItems.push(item);
				menu.hideBuiltInItems();
				this.contextMenu=menu;

				
				loadContainer=new AbsView();
				stage.addChild(loadContainer);
				progressBar=new LoadBar();
				loadContainer.addChild(progressBar);
				stage.addEventListener(Event.RESIZE,onResize);
				progressBar.x=50;
				progressBar.y=530;
				_textFiled=new TextField();
				_textFiled.autoSize="left";
				_textFiled.width=300;
				_textFiled.textColor=0xFFFFFF;
				_textFiled.x=progressBar.x+50;
				_textFiled.y=progressBar.y+40;
				loadContainer.addChild(_textFiled);
				onResize();
				initConfig();
			}
		}
		private var ipSelect:IPSelect
		private function initConfig():void
		{
//			ConfigManager.Instance.webId=loaderInfo.parameters["webId"];
//			ConfigManager.Instance.selectIp=loaderInfo.parameters["ip"];
//			ConfigManager.Instance.port=loaderInfo.parameters["port"];
//			ConfigManager.Instance.checkport=loaderInfo.parameters["checkPort"];
//			ConfigManager.Instance.chatPort=loaderInfo.parameters["chatPort"];
			
			ipSelect=new IPSelect();
			stage.addChild(ipSelect);
			ipSelect.x=(StageProxy.Instance.getWidth()-ipSelect.width)*0.5
			ipSelect.y=(StageProxy.Instance.getHeight()-ipSelect.height)*0.5
			ipSelect.ip6.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip48.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip60.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip70.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip84.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip69.addEventListener(MouseEvent.CLICK,onClick);
			ipSelect.ip96.addEventListener(MouseEvent.CLICK,onClick);
			
			if(ShareObjectManager.Instance.getString("ipSelect"))ipSelect.webIdTxt.text=ShareObjectManager.Instance.getString("ipSelect");
//			ConfigManager.Instance.selectIp=loaderInfo.parameters["ip"];
			ConfigManager.Instance.port=6961;
			ConfigManager.Instance.checkport=10906;
			ConfigManager.Instance.chatPort=7961;
		}
		private function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{ 
				case ipSelect.ip6:
					ConfigManager.Instance.selectIp="183.129.160.92"//"183.129.229.194";//"115.230.126.210"//"61.164.161.199"  //http://60.12.157.12
					break;
				case ipSelect.ip48:
					ConfigManager.Instance.selectIp="192.168.1.48"
					break;
				case ipSelect.ip60:
					ConfigManager.Instance.selectIp="192.168.1.60"
					break;
				case ipSelect.ip70:
					ConfigManager.Instance.selectIp="192.168.1.70"
					break;
				case ipSelect.ip84:
					ConfigManager.Instance.selectIp="192.168.1.84"
					break;
				case ipSelect.ip69:
					ConfigManager.Instance.selectIp="192.168.1.69"
					break;
				case ipSelect.ip96:
					ConfigManager.Instance.selectIp="192.168.1.96"
					break;
			}
 			ConfigManager.Instance.webId=StringUtil.trim(ipSelect.webIdTxt.text);
			
			ShareObjectManager.Instance.put("ipSelect",ConfigManager.Instance.webId);
			
			
			stage.removeChild(ipSelect);
			
			loadRootTxt();
		}
		
		private function onResize(e:Event=null):void
		{
			loadContainer.x=(stage.stageWidth-767)*0.5;  
			loadContainer.y=(stage.stageHeight-546)*0.5;
		}
//		protected function onUpdateMenuSelect2(event:ContextMenuEvent):void
//		{
//			Debug.showDebug();
//		}
//		
//		protected function onCleanMenuSelect(event:ContextMenuEvent):void
//		{
//			SystemTool.gc();
//		}

		private function loadRootTxt():void
		{
			var loader:FileLoader=new FileLoader();
			loader.loadCompleteCallBack=txtCall;
			loader.load("root.txt");
		}
		private function txtCall(loader:FileLoader):void
		{
			var data:String=String(loader.data);
			ConfigManager.Instance.setRoot(data);
			loadConfig();
		}
		private function loadConfig():void
		{
			var configUrl:String="Config.xml?"+getTimer()+""+Math.random();
			var fileLoader:FileLoader=new FileLoader();
			fileLoader.loadCompleteCallBack=configCompleteLoad;
			fileLoader.load(configUrl);
		} 
		private function configCompleteLoad(loader:FileLoader):void
		{
			var data:XML=new XML(loader.data);
			loader=null;
			ConfigManager.Instance.parseDataForDebug(data);
			URLTool.initRoot(ConfigManager.Instance.getRoot(),ConfigManager.Instance.getVersionStr());
			///初始化so 
//			ShareObjectManager.Instance.init(ConfigManager.Instance.getRoot(),ConfigManager.Instance.getVersion());
//			ShareObjectManager.Instance.flushSize();
			loadingAssets();
		} 
		/** 加载资源 o
		 */		
		private function loadingAssets():void
		{
			var loader:UILoader=new UILoader();
//			loader.loadCompleteCallback=mainAppLoaded;
//			loader.progressCallBack=mainAppProgress;
//			loader.initData("GameGpu.swf?"+ConfigManager.Instance.getVersion(),null,{tips:"主程序"});
				
			loader=new UILoader();
			loader.loadCompleteCallback=picLoaded;
			var url:String=URLTool.getLoadingAssets("loadPic.swf");
			loader.initData(url);
			
			var myGame:GameGpu=new GameGpu();
			myGame.allResLodedCallback=allResLoded
			myGame.loadUIRes(mainAppProgress);

		}
		private function picLoaded(content:DisplayObject,data:Object):void
		{
			loadContainer.addChildAt(content,0);
		}
		private function mainAppLoaded(content:DisplayObject,data:Object):void
		{
//			var mainGame:Class=ApplicationDomain.currentDomain.getDefinition("GameGpu") as Class;
//			var myGame:Object=new mainGame();
			var myGame:GameGpu=new GameGpu();
			myGame.allResLodedCallback=allResLoded
			myGame.loadUIRes(mainAppProgress);
		}
		/** 所有资源加载完成
		 */		
		private function allResLoded():void
		{
				progressBar.gotoAndStop(1);
				progressBar.stop();
				if(stage.contains(loadContainer))	stage.removeChild(loadContainer);
				while(loadContainer.numChildren>0)loadContainer.removeChildAt(0);
		}
		private function mainAppProgress(e:ProgressEvent,data:Object):void
		{
			var percent:int=int(e.bytesLoaded*100/e.bytesTotal);
			progressBar.gotoAndStop(percent);
//			print(this,percent,data.tips);
			_textFiled.text="正在加载"+data.tips+",进度为"+percent+"%";
		}

		
	}
}