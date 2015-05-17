package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.center.pool.AbsUIPool;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	import com.YFFramework.core.ui.yfComponent.controls.YFCheckBox;
	import com.YFFramework.core.ui.yfComponent.controls.YFComboBox;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridLock;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridOpen;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFList;
	import com.YFFramework.core.ui.yfComponent.controls.YFNumericStepper;
	import com.YFFramework.core.ui.yfComponent.controls.YFPane;
	import com.YFFramework.core.ui.yfComponent.controls.YFRadioButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFTabMenu;
	import com.YFFramework.core.ui.yfComponent.controls.YFTreeCell;
	import com.YFFramework.core.ui.yfComponent.controls.YFWindow;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import yf2d.core.YF2d;
	
	/**2012-8-9 上午9:23:48
	 *@author yefeng
	 */
	[SWF(width="800",height="600")]
	public class UISKinTest extends Sprite
	{
		public function UISKinTest()
		{
			super();
			if(stage)
			{
				StageProxy.Instance.configure(stage);
				YF2d.Instance.initData(stage,stage.stage.stageWidth,stage.stageHeight);
				var loader:UISLoader=new UISLoader();
				var arr:Vector.<Object>=new Vector.<Object>();
				arr.push({url:"http://static.mygame.com/common/loading/uiSkin.swf"},{url:"http://static.mygame.com/common/loading/fightUI.swf"},{url:"http://static.mygame.com/common/loading/face.swf"});
				loader.load(arr)
				loader.loadCompleteCallBack=complete
			}
		}
		private function complete(data:Object):void
		{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			StageProxy.Instance.configure(stage);
			initUI();
			addEvents();
		}
		private function addEvents():void
		{
			stage.addEventListener(MouseEvent.CLICK,stageClick);
		}
		private function onEnterFrame(e:Event):void
		{
			UpdateManager.Instance.update();
		}
			
		
		
		/**初始化ui 
		 */		
		private function initUI():void
		{
			LayerManager.initLayer(this);
			
			var panel:YFPane=new YFPane(400,300);
			addObj(panel);
			
			var windown:YFWindow=new YFWindow();
			addObj(windown);
			windown.x=410;
			windown.width=400;
			windown.height=400
			var blueBtn:YFButton=new YFButton("中国人");
			addObj(blueBtn);
			blueBtn.x=windown.x+windown.width+10
			blueBtn.width=80
				
			var btn2:YFButton=new YFButton("中国人",2);
			addObj(btn2);
			btn2.x=blueBtn.x+blueBtn.width+10
			btn2.width=80
				
			var checkBox:YFCheckBox=new YFCheckBox();
			addObj(checkBox);
			checkBox.x=btn2.x+btn2.width+10;
			
			
			
			var list:YFList=new YFList(50,0,5);
			
			list.addItem({name:"中国"},'name');
			list.addItem({name:"香港"},'name');
			list.addItem({name:"澳门"},'name');
			list.addItem({name:"台湾"},'name');
			addObj(list);
			list.x=0;
			list.y=310
				
				
				
			 var comboBox:YFComboBox=new YFComboBox(100,100);
			 
			 comboBox.addItem({name:"中国"},'name');
			 comboBox.addItem({name:"香港"},'name');
			 comboBox.addItem({name:"澳门"},'name');
			 comboBox.addItem({name:"台湾"},'name');
			 comboBox.addItem({name:"美国"},'name');
			 comboBox.addItem({name:"英国"},'name');
	
			 addObj(comboBox);
			 comboBox.setSelectIndex(0);
			 comboBox.x=list.x+list.width+10;
			 comboBox.y=310
				 
			 comboBox.toolTip="我是下拉框"
			 
			 
			
	//		var scroller:YFScroller=new YFScroller(list,100)
	//		addObj(scroller);
	//		scroller.x=500
	//		scroller.y=310
	
			var stepper:YFNumericStepper=new YFNumericStepper();
			addObj(stepper);
			stepper.x=700;
			stepper.y=300
				
			var container:VContainer=new VContainer(); 
			container.x=500;
			container.y=400
			addObj(container);
			var radioButton:YFRadioButton=new YFRadioButton("语文");
			container.addChild(radioButton);
			radioButton=new YFRadioButton("数学");
			container.addChild(radioButton);
			
			radioButton=new YFRadioButton("外语");
			container.addChild(radioButton);
			
			container.updateView();
			
			
			var myMenu:YFTabMenu=new YFTabMenu(60,0,15);
			
			myMenu.addItem({name:"15"},'name');
			myMenu.addItem({name:"中国"},'name');
			myMenu.addItem({name:"香港"},'name');
			myMenu.addItem({name:"澳门"},'name');
			myMenu.addItem({name:"台湾"},'name');
			myMenu.addItem({name:"美国"},'name');
			myMenu.addItem({name:"英国"},'name');
			
			addObj(myMenu);
			myMenu.setSelectIndex(0);
			myMenu.x=20
			myMenu.y=400;
			
			myMenu=new YFTabMenu(60,0,13);
			myMenu.addItem({name:"13"},'name');
			myMenu.addItem({name:"中国"},'name');
			myMenu.addItem({name:"香港"},'name');
			myMenu.addItem({name:"澳门"},'name');
			myMenu.addItem({name:"台湾"},'name');
			myMenu.addItem({name:"美国"},'name');
			myMenu.addItem({name:"英国"},'name');
			addObj(myMenu);
			myMenu.setSelectIndex(0);
			myMenu.x=20
			myMenu.y=500;
			
			myMenu=new YFTabMenu(60,0,14);
			myMenu.addItem({name:"14"},'name');
			myMenu.addItem({name:"中国"},'name');
			myMenu.addItem({name:"香港"},'name');
			myMenu.addItem({name:"澳门"},'name');
			myMenu.addItem({name:"台湾"},'name');
			myMenu.addItem({name:"美国"},'name');
			myMenu.addItem({name:"英国"},'name');
			addObj(myMenu);
			myMenu.setSelectIndex(0);
			myMenu.x=20
			myMenu.y=600;

			
			
			
			
			
			
			var label:YFLabel=new YFLabel("天下第一");
			addObj(label);
			label.x=myMenu.x+myMenu.width;
			label.y=myMenu.y
				
			label=new YFLabel("天下第一",3);
			addObj(label);
			label.x=myMenu.x+myMenu.width+100;
			label.y=myMenu.y

				
			
			
//			LayerManager.initLayer(this);
//			PopUpManager.initPopUpManager();
//			YFAlert.show("帧的吗帧的吗帧的吗帧的吗帧的吗帧的吗帧的吗帧的吗帧的","22",1);

		   var bgicon1:YFGridOpen=new YFGridOpen();
		   addObj(bgicon1);
		   bgicon1.x=label.x+label.width;
		   bgicon1.y=label.y;
		   bgicon1.width=bgicon1.height=50;
		   
		   var bgIcon2:YFGridLock=new YFGridLock();
		   addObj(bgIcon2);
		   bgIcon2.x=bgicon1.x+bgicon1.width;
		   bgIcon2.y=bgicon1.y;
		   
		   var treeCell:YFTreeCell=new YFTreeCell("我的好友(3/16)",2);
		   addObj(treeCell);
		   treeCell.x=500;
		   treeCell.y=300;
			   
//		   var toggle5:YFTogleButton=new YFTogleButton(5);
//		   addObj(toggle5);
//		   toggle5.width=toggle5.height=200
//		   toggle5.x=600;
//		   toggle5.y=500;
		   
		   
		   var num:AbsUIPool=ImageTextManager.Instance.createNum("123");
		   LayerManager.FightTextLayer.addChild(num);
		   num.x=num.y=300;
		   
		   
		   RichText.resLoadComplete=true;
		   var chatArowLeft:YFChatArrow=new YFChatArrow(1);
		   addChild(chatArowLeft);
		   chatArowLeft.x=600;
		   chatArowLeft.y=500;
		   chatArowLeft.width=200
		   chatArowLeft.text="很低很低动画iodhdih帝电话似乎【很多当皇帝是当往会我我iw/45ggg皇帝电话当皇";
		  
		   var mat:Matrix=new Matrix();
		   mat.tx=chatArowLeft.width-30;
		   mat.ty=chatArowLeft.height+20;
		   var chatData:BitmapData=new BitmapData(chatArowLeft.width,chatArowLeft.height,false,0xFF0000);
		   chatData.draw(chatArowLeft,mat);
		   var bmp:Bitmap=new Bitmap(chatData);
		   addObj(bmp);
		   bmp.x=100
			bmp.y=400
				
				
		}
		
		
		/** 鼠标单击
		 */ 
		private function stageClick(e:MouseEvent):void
		{
			var ui:AbsUIPool=ImageTextManager.Instance.createNumWidthPre("123",2);
		//	var num:AbsUIPool=ImageTextManager.Instance.createTextNum(TypeImageText.Text_Hp_Mul,"123",TypeImageText.Num_Red);
			LayerManager.FightTextLayer.addChild(ui);
			ui.x=ui.y=300;
			var easeFunc:Function=Elastic.easeOut//Back.easeOut
			TweenLite.to(ui,1,{y:ui.y,x:ui.x-100,ease:easeFunc,onComplete:completeIt,onCompleteParams:[ui,"2"]});
			
		//	TweenMax.to(num, 1, {bezierThrough:[{y:num.y-150,x:num.x-50},{x:145, y:96}, {x:196, y:150}],onComplete:completeIt,onCompleteParams:[num]});
		}
		private function completeIt(param1:Object,param2:Object):void
		{
			var ui:AbsUIPool=param1 as AbsUIPool;
			ui.disposeToPool();
		}
		
		private function addObj(obj:DisplayObject):void
		{
			LayerManager.UILayer.addChild(obj);
		}
	}
}