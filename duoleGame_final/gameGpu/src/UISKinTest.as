package
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.text.TextObject;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.ui.yfComponent.controls.YFCDData;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	import com.YFFramework.core.ui.yfComponent.controls.YFCheckBox;
	import com.YFFramework.core.ui.yfComponent.controls.YFComboBox;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridLock;
	import com.YFFramework.core.ui.yfComponent.controls.YFGridOpen;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFList;
	import com.YFFramework.core.ui.yfComponent.controls.YFNumericStepper;
	import com.YFFramework.core.ui.yfComponent.controls.YFPane;
	import com.YFFramework.core.ui.yfComponent.controls.YFProgressBar;
	import com.YFFramework.core.ui.yfComponent.controls.YFRadioButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFTabMenu;
	import com.YFFramework.core.ui.yfComponent.controls.YFTreeCell;
	import com.YFFramework.core.ui.yfComponent.controls.YFWindow;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.game.core.module.story.view.TextPlayer;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.scrollNum.NumTextFactory;
	import com.YFFramework.game.ui.imageText.scrollNum.NumTextPlayer;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	/**2012-8-9 上午9:23:48
	 *@author yefeng
	 */
	[SWF(width="800",height="600",backgroundColor="#225588")]
	public class UISKinTest extends Sprite
	{
		public function UISKinTest()
		{
			super();
			
			if(stage)
			{
//				StageProxy.Instance.configure(stage);
//				YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_CREATE,onContext3dCreate);
//				YF2d.Instance.initData(stage,0x000000,2);
				onContext3dCreate();
				
				var now:Date = new Date();
				trace(now.getTime()); 
				now.setTime(1376021189289);;//1376020633
				trace(now); // Tue Jan 15 00:00:00 GMT-0800 1929
				
				
//				var data:Date=new Date();
//				data.setTime(1376020633);
//				print(this,data.hours);
				
			}

		}
		private function onContext3dCreate(e:YF2dEvent=null):void
		{
			var loader:UISLoader=new UISLoader();
			var arr:Vector.<Object>=new Vector.<Object>();
			arr.push({url:"http://1.s.com/common/loading/不要的/uiSkin.swf"},{url:"http://1.s.com/common/loading/fightUI.swf"},{url:"http://1.s.com/common/loading/不要的/face.swf"},{url:"http://1.s.com/common/loading/cursorUI.swf?"+getTimer()+Math.random()});
			loader.load(arr)
			loader.loadCompleteCallBack=complete

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
			stage.addEventListener(Event.RESIZE,onResize);

		}
		private function onResize(e:Event):void
		{
			ResizeManager.Instance.resize();
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
		   
		   
		   var num:AbsView=ImageTextManager.Instance.createNum("123");
		   LayerManager.PopLayer.addChild(num);
		   num.x=num.y=300;
		   
		   
		   RichText.resLoadComplete=true;
		   var chatArowLeft:YFChatArrow=new YFChatArrow(2);
		   addChild(chatArowLeft);
		   chatArowLeft.x=600;
		   chatArowLeft.y=500;
		   chatArowLeft.width=500
		   chatArowLeft.text="很低很低动画iodhdih帝电话似乎【很多当皇帝是当往会我我&25皇帝电话当皇很低很低动画iodhdih帝电话似乎【很多当皇帝是当往会我我很低很低动画iodhdih帝电话似乎【很多当皇帝是当往会我我很低很低动画iodhdih帝电话似乎【很多当皇帝是当往会我我";
		 	
//&a931803632&a931803631
		   
		   YFCDData.iniCD();
		   _cd=new YFCD(40,40);
		   LayerManager.PopLayer.addChild(_cd);
		   _cd.start();
		   
		   _cd.x=400;
		   _cd.y=100;
		   var keyItem0:KeyBoardItem=new KeyBoardItem(Keyboard.A,onkeyDown);
		   
		   
		   var progress:YFProgressBar=new YFProgressBar();
		   addChild(progress);
		   progress.x=200;
		   progress.y=200;
		   progress.setPercent(0.5);
		   
		   
		   ////人物系统文本解析  到#0099ff地图名#000000找#ffff00【NPC名称】{唯一ID} 谈话
		   
		   
		   var myRichText:RichText=new RichText();
		   myRichText.width=500;
		   myRichText.setText("&931803632&931803631 到#32${#FF0000|林景湖|1|3}找{#00FFFF|狼熬|2|4}干嘛？&931803631&931803640&931803631&931803633&931803631&931803642&931803631哈哈啊阿娇的决定的决定加/45scrp大的决定加大的决定加大监督的决定加大就的决定加大监督的决定加大就ssssss飒飒飒飒飒飒飒飒撒谎说三四is是嘶嘶声嘶嘶声是嘶嘶声啊阿娇的决定的决定加大的决定加大的决定加大监督的决定加大就的决定加大监督的决定加大就ssssss飒飒飒飒飒飒飒飒撒谎说三四is是嘶嘶声嘶嘶声是嘶嘶声",exeFunc,flyExeFunc); //?3&

//		   myRichText.setText("环形任务1  -  难度比较大的",exeFunc,flyExeFunc); //?3&  
			addChild(	myRichText);
			myRichText.x=1000;
			myRichText.y=300;
//			var regExp:RegExp=/\#\d*\$/g;
//			var mmT:String="啊啊#35$测试啊#$#a$#92$";
//			var tttObj:Object=regExp.exe(mmT);
//			print(this,tttObj);
			
			
//			var yf2dLabel:YF2dGameNameLabel=new YF2dGameNameLabel();
//			yf2dLabel.setText("我是测试啊");
			
			
			playText=new TextPlayer();
			playText.play("大家都说我是坏人啊，你们相信吗,哇哈哈哈，哥哥我不是相信的。。。",5000,20);
			playText.start();
			LayerManager.PopLayer.addChild(playText);
			playText.x=200;
			playText.y=750;
			
			
			
//			numTextPlayer=new NumTextPlayer();
//			var arr:Vector.<BitmapData>=ImageTextManager.Instance.getNumArr(TypeImageText.Num_Yellow_3);
//			numTextPlayer.initData(arr,arr[0].width,arr[1].height,true);
//			numTextPlayer.x=600;
//			numTextPlayer.y=750;
//			numTextPlayer.completeCall=completeCall
//			numTextPlayer.completeParam=[numTextPlayer]
//			numTextPlayer.playTo(0,153,1);
			numTextPlayer=NumTextFactory.getNumTextPlayer();
			numTextPlayer.playNum(236,3,0xFFFF00,completeCall,[numTextPlayer]);
			LayerManager.PopLayer.addChild(numTextPlayer);
			numTextPlayer.x=600;
			numTextPlayer.y=750;

			
			var mc:MovieClip=ClassInstance.getInstance("a9");
			var player:MovieClipPlayer=new MovieClipPlayer(mc,30);
			player.start(); 
			
			LayerManager.PopLayer.addChild(player);
			player.x=800;
			player.y=750;

			textView=ImageTextManager.Instance.createMonsterBlood("367");
			LayerManager.PopLayer.addChild(textView);
			textView.x=600;
			textView.y=800;
			TweenLite.to(textView,1,{y:600,ease:Back.easeOut});
		}
		private var playText:TextPlayer;
		private var numTextPlayer:NumTextPlayer
		private var textView:AbsView;
		
		private function completeCall(numTextPlayer:NumTextPlayer):void
		{
//			numTextPlayer.filters=[new GlowFilter(0xFF0000,1,15,15)]
//				GlowFilterUtil.GlowDisplay(numTextPlayer,0xFFFF00);
			print(this,"complete OK",completeCall,[numTextPlayer]);
		}
		
		/** 鼠标单击
		 */ 
		private function stageClick(e:MouseEvent):void
		{
			//			showBloodText();
//			numTextPlayer.playTo(0,1260,1.5,0xFFFF00,completeCall,[numTextPlayer]);
			
		//	numTextPlayer.playNumToScaleDisappear(1260,1.5,0xFFFF00,completeCall,[numTextPlayer]);
			
			playText.play("大家都说我是坏人啊，你们相信吗,哇哈哈哈，哥哥我不是相信的。sassa....。。。",5000,20);
			playText.start();
			
			
			textView=ImageTextManager.Instance.createMonsterBlood("367");
			LayerManager.PopLayer.addChild(textView);

			textView.x=600;
			textView.y=800;
			TweenLite.to(textView,1,{y:550,ease:Back.easeOut});

//			ImageUtil.Instance.showBloodEx([0],100,300,300);
//			ImageUtil.Instance.showCrit(100,300,300);
			
//			ImageUtil.Instance.showBuffAdd(123,300,300);
			
			
			_cd.play(5000,0,false);
		}

		
		
		
		
		private function exeFunc(obj:Object):void
		{
			print(this,"文本单击:",	obj);
		}
		
		private function flyExeFunc(obj:Object):void
		{
			print(this,"小飞鞋单击:",	obj);
		}

		private function pipei():void
		{
			var str:String="人物系统文本解析到{#0099ff|地图名}找{#ffff00|aa0}"; //#0099ff地图名#000000找#ffff00【NPC名称】{唯一ID} 谈话
			var regExp:RegExp=/\{(?:[^\{]*?|.*?\{.*?\}[^{]*)\}/g;;///\{([^\{\}]*(\{[^\{\}]*\})?[^\{\}]*)*\}/g;//{*\s}/g;
			var arr:Array=[];
			var obj:Object=regExp.exec(str);
			var textArr:Array=[];
			
			var cellArr:Array=[];
			cellArr[0]=str.substring(0,obj.index);
			arr.push(cellArr);
			
			
			
			
			var realStr:String=obj[0];
			var myRealStr:String=realStr.substring(1,realStr.length-1);
			
			var cellArr2:Array=myRealStr.split("|");
			
			arr.push(cellArr2);
			
			
			str=str.substr(obj.index+realStr.length,str.length);
			
			print(this,"str::",str);
			
			regExp=/\{(?:[^\{]*?|.*?\{.*?\}[^{]*)\}/g;  ///需要重置 regExp 
			obj=regExp.exec(str);
			
//			while(result.length!=str.length){
//				result=str;
//				str=str.replace(regExp,"{}");
//				print(this,"result:",result,str)
//			}
//			print(this,"result==",result)
			
			var testTTT:String="人物系\946统文本解析到{#0099ff|地图名}找{#ffff00|aa0}啊阿娇的决定的决定加大的决定加大的决定加大监督的决定加大就的决定加大监督的决定加大就ssssss飒飒飒飒飒飒飒飒撒谎说三四is是嘶嘶声嘶嘶声是嘶嘶声"
			var  testResultArr:Array=analysisText(testTTT,null);
			print(this,"testResultArr"+testResultArr);
		}
		
		/**
		 * @param txt  人物系统文本解析  	人物系统文本解析到{#0099ff|地图名}找{#ffff00|aa0} 
		 * exeFunc  带有一个参数
		 */		
		private function  analysisText(txt:String,exeFunc:Function):Array
		{
			var str:String=txt;
			var resultArr:Array=[];
			while(str.length>0)
			{
				str=handleIt(str,resultArr,exeFunc);
			}
			return resultArr;
		}
		
		private function handleIt(str:String,resultArr:Array,exeFunc:Function):String
		{
			var regExp:RegExp=/\{(?:[^\{]*?|.*?\{.*?\}[^{]*)\}/g;
			var checkObj:Object=regExp.exec(str);
			var cellArr:Array;
			var tempStr:String;
			var realStr:String;
			var objLen:int;
			var cellArr2:Array;
			if(checkObj)
			{
				cellArr=[];
				cellArr[0]=str.substring(0,checkObj.index)  ///解析 {}前面的数据
				resultArr.push(cellArr);
				///
				objLen=checkObj.length;
				for(var i:int=0;i!=objLen;++i)  ///解析  {}
				{
					tempStr=checkObj[i];
					realStr=tempStr.substring(1,tempStr.length-1);
//					cellArr2=realStr.split("|");
					cellArr2=convertToRichArr(realStr,exeFunc);
					resultArr.push(cellArr2);
				}
				str=str.substr(checkObj.index+tempStr.length,str.length);
			}
			else   ///单纯的文本
			{
				cellArr=[];
				cellArr[0]=str;
				str="";
			}
			return str
		}
		/**
		 * #0099ff|地图名|type|onlyId    将这种类型的 字符串转化为  富文本支持的数组    [text,TextObject,eventFunc,eventParam]
		 */		
		private function convertToRichArr(str:String,exeFunc:Function):Array
		{
			var textObj:TextObject;
			var arr:Array=str.split("|");
			var len:int=arr.length;
			textObj=new TextObject(arr[0]);//new TextObject(arr[0],arr[0],arr[0]);
			var txt:String=arr[1];
			var eventparam:Object;
			if(len>=3)
			{
				eventparam={};
				eventparam.type=arr[2];
				if(len>=4)eventparam.id=arr[3]
			}
			var returnArr:Array=[txt,textObj];
			if(eventparam)returnArr.push(exeFunc,eventparam);
			return returnArr;
		}
		
		
		
		
		private var _cd:YFCD; 
		
		private var TTX:int=430;
		private function onkeyDown(e:KeyboardEvent):void
		{
			var code:int=e.keyCode;
			var cd:YFCD=_cd.clone();
			LayerManager.PopLayer.addChild(cd);
			cd.x=TTX;
			cd.y=100
			TTX +=40;
//			Draw.DrawRect(this.graphics,20,20,0xFF0000,1,cd.x,cd.y);
			print(this,"copy");
		}
		
		
			
		
		
		
//		private function showBloodText():void
//		{
//			var ui:AbsView=ImageTextManager.Instance.createNumWidthPre("123",1);
//			var ui2:AbsView=new AbsView(false);
//			ui2.addChild(ui);
//			ui.x=-ui.width*0.5;
//			ui.y=-ui.height*0.5;
//			LayerManager.PopLayer.addChild(ui2);
//			var ty:Number=ui2.x=ui2.y=300;
//			TweenLite.to(ui2,0.3,{y:ty-200,scaleX:4,ease:Linear.easeInOut,rotationX:50,onComplete:onComplete,onCompleteParams:[ui2,ty]});
//		}
		private function onComplete(ui2:AbsView, ty:Number):void  
		{
			TweenLite.to(ui2,0.2,{y:ty-150,scaleX:1,rotationX:0,ease:Linear.easeInOut,onComplete:completeIt,onCompleteParams:[ui2,ty]});
		}
		private function completeIt(param1:Object,ty:Number):void
		{
			var cc:AbsView=param1 as AbsView;
			
			TweenLite.to(cc,0.6,{alpha:0,y:ty-100*Math.random(),x:cc.x+Math.random()*400-200,ease:Linear.easeInOut,onComplete:completeIt2,onCompleteParams:[cc]});

		}
		private function completeIt2(param1:Object):void
		{
			var cc:AbsView=param1 as AbsView;
			LayerManager.PopLayer.removeChild(cc);
			var ui:AbsView=cc.getChildAt(0) as AbsView;
			cc.alpha=1;
			ui.dispose();
		}

		
		private function addObj(obj:DisplayObject):void
		{
			LayerManager.UILayer.addChild(obj);
		}
	}
}