package
{
	/**@author yefeng
	 * 2013 2013-7-3 下午4:36:00 
	 */ 
	       
	import app.MainAppLoader;
	
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.core.module.loginNew.view.RegisterView;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.net.NetManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	
	[SWF(width="1000",height="600",frameRate="60",backgroundColor="#000000")]
	public class PreLoading4 extends Sprite
	{
		private var progressBar:LoadBar;
		private var loadContainer:AbsView;
		private var registerContainer:AbsView;
		private var loadingContainer:AbsView;
		private var _textFiled:TextField;
		
		
		
		/**外部加载图片logo大小
		 */
		private static const LoadingAssetWidth:int=1250;
		
		private static const LoadingAssetHeight:int=750;

		/** loading bar 的宽高
		 */		
		private static const LoadingBarWidth:int=855;

		/** socket文本
		 */
//		private var _socketCloseTF:TextField;
		
		/**登录完成
		 */
		private var _loginComplete:Boolean=false;
		/**swf加载完成
		 */
		private var _swfLoadingComplete:Boolean=false;
		private var _yf2dInit:Boolean=false;
		
		/**xx2d文件加载完成
		 */
		private var _xx2dFileComplete:Boolean=false;

		/**app根目录地址
		 */		
		private var appRoot:String;
		
		private var myGame:Object
		public function PreLoading4()
		{
			if(stage)
			{
				appRoot=loaderInfo.url;
				var index:int=appRoot.lastIndexOf("/");
				if(index!=-1)
				{
					appRoot=appRoot.substring(0,index);
				}
				else appRoot="";

				StageProxy.Instance.configure(stage);
				
				loadingContainer=new AbsView();
				stage.addChild(loadingContainer);
				loadContainer=new AbsView();
				loadingContainer.addChild(loadContainer);
				registerContainer=new AbsView();
				loadingContainer.addChild(registerContainer);
				progressBar=new LoadBar();
				loadContainer.addChild(progressBar);
				stage.addEventListener(Event.RESIZE,onResize);
				progressBar.x=(LoadingAssetWidth-LoadingBarWidth)*0.5///50;
				progressBar.y=530;
				_textFiled=new TextField();
				_textFiled.autoSize="left";
				_textFiled.width=300;
				_textFiled.textColor=0xFFFFFF;
				_textFiled.x=progressBar.x+50;
				_textFiled.y=progressBar.y+70;
				loadContainer.addChild(_textFiled);
				
				
//				_socketCloseTF=new TextField();
//				_socketCloseTF.autoSize="left";
//				_socketCloseTF.width=300;
//				_socketCloseTF.textColor=0xFF0000;
//				_socketCloseTF.textColor=0xFFFFFF;
//				_socketCloseTF.x=progressBar.x+progressBar.width-30;
//				_socketCloseTF.y=progressBar.y+40;
//				loadContainer.addChild(_socketCloseTF);
//				_socketCloseTF.visible=false;
//				_socketCloseTF.text="服务器断开连接"
					
				onResize();
				getHTMLConfig();
				loadConfig();
				RegisterView.Instance.completeUILoadComplete=uiCompleteFuncCall;
				RegisterView.Instance.loginCompleteCall=loginCompleteFunc;
//				RegisterView.Instance.socketCloseCall=socketClose;
				initMenu();
				//驱动 socket 队列
				addEventListener(Event.ENTER_FRAME,onReveSocket);

			}
		}
		/**驱动 socket 队列
		 */		
		private function onReveSocket(e:Event):void
		{
			NetManager.handleMessage();
		}

		private function initMenu():void
		{
			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("杭州多乐网络科技",true,false);
			menu.customItems.push(item);
			item = new ContextMenuItem("勇者之光",true,false);
			menu.customItems.push(item);
			menu.hideBuiltInItems();
			this.contextMenu=menu;
		}

		 
		private function initYf2d():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_First_CREATE,onContext3dCreate);
			YF2d.Instance.initData(StageProxy.Instance.stage,0x000000);
		}
		private function onContext3dCreate(e:YF2dEvent):void
		{
			_yf2dInit=true;
			doMain();
		}
		

		/**注册回调
		 */		
		private function uiCompleteFuncCall():void
		{
			registerContainer.addChild(RegisterView.Instance);
			RegisterView.Instance.resize();
			if(!loadingContainer.contains(registerContainer))	loadingContainer.addChild(registerContainer);
			if(loadingContainer.contains(loadContainer))	loadingContainer.removeChild(loadContainer);
		}
		
		/**主策完成后显示loading界面
		 */
		private function loginCompleteFunc():void
		{
			RegisterView.Instance.dispose();
			if(loadingContainer.contains(registerContainer))	loadingContainer.removeChild(registerContainer);
			loadingContainer.addChild(loadContainer);
			_loginComplete=true;
			initYf2d();
		}
		
		private function onResize(e:Event=null):void
		{
			loadContainer.x=(stage.stageWidth-LoadingAssetWidth)*0.5;  
			loadContainer.y=(stage.stageHeight-LoadingAssetHeight)*0.5;
		}
		private function getHTMLConfig():void
		{
			ConfigManager.Instance.webId=loaderInfo.parameters["webId"];
			ConfigManager.Instance.keyId=loaderInfo.parameters["keyId"];
			ConfigManager.Instance.appName=loaderInfo.parameters["appName"];
			ConfigManager.Instance.appUrl=loaderInfo.parameters["appUrl"];
			ConfigManager.Instance.selectIp=loaderInfo.parameters["ip"];
			ConfigManager.Instance.port=loaderInfo.parameters["port"];
			ConfigManager.Instance.checkport=loaderInfo.parameters["checkPort"];
			ConfigManager.Instance.chatPort=loaderInfo.parameters["chatPort"];
			
			//聊天端口 
			ConfigManager.Instance.chatIp=loaderInfo.parameters["chatIp"];
			//下面这些为腾讯朋友网需要的
			if(loaderInfo.parameters.hasOwnProperty("openid"))
			{
				YellowAPIManager.Instence.openid=loaderInfo.parameters["openid"];
				ConfigManager.Instance.webId=YellowAPIManager.Instence.openid;

			}
			if(loaderInfo.parameters.hasOwnProperty("openkey"))
			{
				YellowAPIManager.Instence.openkey=loaderInfo.parameters["openkey"];
				ConfigManager.Instance.keyId=YellowAPIManager.Instence.openkey;
			}
			if(loaderInfo.parameters.hasOwnProperty("pf"))
			{
				YellowAPIManager.Instence.pf=loaderInfo.parameters["pf"];
			}
			if(loaderInfo.parameters.hasOwnProperty("pfkey"))
			{
				YellowAPIManager.Instence.pfkey=loaderInfo.parameters["pfkey"];
			}
		}


		private function loadConfig():void
		{
			var configUrl:String=appRoot+"/Config.xml?"+getTimer()+""+Math.random();
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
			///初始化so 
			ShareObjectManager.Instance.init(ConfigManager.Instance.getRoot(),ConfigManager.Instance.getVersion());
			loadingAssets();
		}
		/** 加载资源  
		 */		
		private function loadingAssets():void
		{
			//同 目录下的执行文件
			//加载主程序
			var assetsUrl:String=appRoot+"/"+ConfigManager.Instance.appUrl+ConfigManager.Instance.getVersionStr();
			var loader:MainAppLoader=new MainAppLoader();
			loader.loadCompleteCallback=mainAppLoaded;
			loader.progressCallBack=mainAppProgress;
			loader.initData(assetsUrl,null,{tips:"主程序"});
			
			var picAssets:String=URLTool.getLoadingAssets("loadPic.swf");
			var picloader:UILoader=new UILoader();
			picloader.loadCompleteCallback=picLoaded;
			picloader.initData(picAssets);
		}
		private function picLoaded(content:DisplayObject,data:Object):void
		{
			loadContainer.addChildAt(content,0);
		} 
		private function mainAppLoaded(content:DisplayObject,data:Object):void
		{

			var mainGame:Class=ApplicationDomain.currentDomain.getDefinition(ConfigManager.Instance.appName) as Class;
			myGame=new mainGame();
			
//			var mainGame:GameGpu3=new GameGpu3();
			
			myGame.allResLodedCallback=allResLoded;
			myGame.init();
			myGame.loadUIRes(mainAppProgress);
			print(this,"initMainApp");
		}
		 
		/** 所有资源加载完成 
		 */		
		private function allResLoded():void
		{
			_swfLoadingComplete=true;
			doMain(); 
		}
		   
		private function doMain():void
		{
			_textFiled.text="连接服务器...";
			if(_swfLoadingComplete&&_loginComplete&&_yf2dInit)
			{
				progressBar.gotoAndStop(1);
				if(stage.contains(loadingContainer))	stage.removeChild(loadingContainer);
				while(loadingContainer.numChildren>0)loadingContainer.removeChildAt(0);
				myGame.yf2dInit();
				removeEventListener(Event.ENTER_FRAME,onReveSocket);
				stage.removeEventListener(Event.RESIZE,onResize);
			}
		}
		
		private function mainAppProgress(e:ProgressEvent,data:Object):void
		{
			var percent:int=int(e.bytesLoaded*100/e.bytesTotal); 
			progressBar.gotoAndStop(percent);
			//			print(this,percent,data.tips);
			_textFiled.text="正在加载"+data.tips+",进度为"+percent+"%";
		}
		
//		private function socketClose():void
//		{
//			_socketCloseTF.visible=true;
//		}
		
		
	}
}