package com.dolo.ui.tools
{
    import com.YFFramework.core.center.manager.update.UpdateManager;
    import com.dolo.ui.managers.UI;
    
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.clearTimeout;
    import flash.utils.getQualifiedClassName;
    import flash.utils.setTimeout;
	
	/**
	 * Tooltip提示 
	 * @author flashk
	 * 
	 */
    public class Xtip extends Sprite 
	{
		public static var isMouseDownHideTip:Boolean = false;
		public static var isMouseDownHideLinkTip:Boolean = true;
		//与鼠标的间隙
		public static var spaceFollowX:int = 14;
		public static var spaceFollowY:int = 17;
		public static var spaceLeft:int = 3;
		public static var spaceTop:int = 5;
		public static var tipBackgroundLinkName:String = "skin_minWindow";
        //新 ToolTip 控件的最大宽度（以像素为单位）。大于此宽度文本将自动换行。
        public static var maxWidth:Number = 500;
        //是否让提示实时跟随鼠标移动
        public static var isFollowMouse:Boolean = true;
		public static var isMouseMoveUpdateAfterEvent:Boolean = true;
        //提示文本的全局样式（影响所有ToolTip实例）
        public static var textFormat:TextFormat;
        //提示文本的顶部边距（全局设置，影响所有ToolTip实例）
        public static var paddingTop:Number = 3;
        //提示文本的左边距（全局样设置，影响所有ToolTip实例）
        public static var paddingLeft:Number = 6;
        //提示文本的淡入的速度，如果需要关闭淡入，将此值设置为1，请勿使用0或者负数（全局设置，影响所有ToolTip实例）
        public static var alphaIn:Number = 1.0;
        //提示文本的淡出的速度，如果需要关闭淡出，将此值设置为1，请勿使用0或者负数（全局设置，影响所有ToolTip实例）
        public static var alphaOut:Number = 1.0;
        //提示文本背景的滤镜，默认是一个阴影滤镜（全局设置，影响所有ToolTip实例）
        public static var backgroundFilter:Array = [new DropShadowFilter (4 , 45 , 0 , 1 , 4 , 4 , 0.3 , 1)];
        public static var txtFilter:Array = null;
		public static var stage:Stage;
		public static var textWidhtAdd:int = 3;
		public static var textHeightAdd:int = 1;
		public static var mouseLeftLess:int = 15;
		public static var removeLinkTipTimeOut:int = 55;
		
		private static var removeTarget:Sprite;
        private static var tips:Array = new Array ();
        private static var timer:Timer = new Timer (1);
        private static var isOn:Boolean = false;
        private static var target:InteractiveObject;
        private static var tip:Object;
        private static var ins:Xtip;
        private static var timeOutID:uint;
        private static var linkTips:Array = [];
        private static var nowLinkTip:Sprite;
        private static var nowDis:DisplayObject;
        private static var defaultToolTipStyle:Object;
		private static var nowMouseOnDis:Object;
		private static var backGround:DisplayObject;

		protected var _txt:TextField;
		protected var _tipValue:Object;
        protected var _compoWidth:Number = 10;
        protected var _compoHeight:Number = 10;
		private static  var _bg:Sprite;
		
        /**
         * 创建一个新的 ToolTip 组件实例
         */
        public function Xtip()
		{
            super ();
            if (textFormat == null){
                textFormat = new TextFormat();
                textFormat.font = "_sans";
                textFormat.size = 12;
            }
        }
		
		/**
		 * 获取当前鼠标位于的Tip按钮 
		 * @return 
		 * 
		 */
		public static function get nowMouseOn():DisplayObject{
			return nowDis;
		}
		
		/**
		 * 对一个可交互的显示对象注册简单提示
		 * @param display 可交互的显示对象
		 * @param tip 提示文本
		 * 
		 */
		public static function registerTip(display:DisplayObject , tip:Object):void
		{
			if(tip == null) return;
			if(tip is String){
				if((tip as String)=="" ) return;
			}
			var interDisplay:InteractiveObject = display as InteractiveObject;
			clearTip (interDisplay);
			tips.push ([interDisplay , tip]);
			if (interDisplay == null) return;
			if (target == interDisplay){
				if (ins != null){
					ins.tip = tip;
				}
			}else{
				timer.addEventListener (TimerEvent.TIMER , showTip);
			}
			interDisplay.addEventListener (MouseEvent.ROLL_OVER , interOver);
			interDisplay.addEventListener (MouseEvent.ROLL_OUT , interOut);
			interDisplay.addEventListener (MouseEvent.MOUSE_DOWN , interOutDown);
			interDisplay.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDis);
		}
		
		protected static function interOutDown(event:MouseEvent):void
		{
			if(isMouseDownHideTip == true){
				interOut(event);
			}
		}
		
		private static function onRemoveFromStageDis(event:Event):void
		{
			if(nowMouseOnDis == event.currentTarget){
				interOut();
			}
		}
		
		/**
		 * 对一个可交互的显示对象注册复杂提示
		 * @param display 可交互的显示对象
		 * @param linkName 提示要使用的类名，库链接名，当需要显示Tip时，会new一个这样的实例
		 * @param initDataFunction 当Tip即将显示时，将调用此函数初始化复杂tip的显示，此函数接收第一个参数为new linkName()的实例，后面参数为args的参数顺序（可选）
		 * @param args 需要传递给initDataFunction的多个可选参数
		 * 
		 *  Xtip.registerLinkTip(this,"com.dolo.ui.controls.Label",Xtip.InitFunction);
		 * 
		 */
		public static function registerLinkTip(display:DisplayObject , linkNameOrClass:* , initDataFunction:Function , ... args):void
		{
			try{
				clearLinkTip(display as InteractiveObject,initDataFunction);
			} 
			catch(error:Error) {
				
			}
			var linkName:String;
			if(linkNameOrClass is Class){
				linkName = getQualifiedClassName(linkNameOrClass);
			}else{
				linkName = String(linkNameOrClass);
			}
			var interDisplay:InteractiveObject = display as InteractiveObject;
			if (interDisplay == null) return;
			var arr:Array = [];
			arr[0] = display;
			arr[1] = linkName;
			arr[2] = initDataFunction;
			arr[3] = args;
			linkTips.push (arr);
			interDisplay.addEventListener (MouseEvent.ROLL_OVER , showLinkTip);
			interDisplay.addEventListener (MouseEvent.ROLL_OUT , hideLinkTip);
			interDisplay.addEventListener(MouseEvent.MOUSE_DOWN,hideLinkTipDown);
			interDisplay.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDis);
		}
		
		protected static function hideLinkTipDown(event:MouseEvent):void
		{
			if(isMouseDownHideLinkTip == true){
				hideLinkTip(event);
			}
		}
		
		/**
		 * 对一个可交互的显示对象的提示删除，并清除EventListener和引用，需要完全释放某个曾经添加过tip的按钮（或Sprite）时调用此方法
		 */
		public static function clearTip(interDisplay:InteractiveObject):void
		{
			interDisplay.removeEventListener (MouseEvent.ROLL_OVER , interOver);
			interDisplay.removeEventListener (MouseEvent.ROLL_OUT , interOut);
			interDisplay.removeEventListener (MouseEvent.MOUSE_DOWN , interOutDown);
			interDisplay.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDis);
			for (var i:Object in tips){
				if (tips[i][0] == interDisplay){
					tips.splice (uint (i) , 1);
					break;
				}
			}
		}
		
		/**
		 * 对一个可交互的显示对象的提示删除，并清除EventListener和引用，需要完全释放某个曾经添加过tip的按钮（或Sprite）时调用此方法
		 */
		public static function clearLinkTip(interDisplay:InteractiveObject , initDataFunction:Function = null):void
		{
			interDisplay.removeEventListener (MouseEvent.ROLL_OVER , showLinkTip);
			interDisplay.removeEventListener (MouseEvent.ROLL_OUT , hideLinkTip);
			interDisplay.removeEventListener(MouseEvent.MOUSE_DOWN,hideLinkTipDown);
			interDisplay.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageDis);
			for (var i:Object in linkTips){
				if (linkTips[i][0] == interDisplay){
					linkTips.splice (uint (i) , 1);
					break;
				}
			}
			if(nowDis == interDisplay){
				hideAllNowTip();
			}
		}
		
		/**
		 * 使用默认的回调函数， linkName类必须实现一个init(targetButton:display)方法初始化显示，targetButton为registerLinkTip(display)参数
		 * @param dis
		 * @param targetDis
		 * 
		 */
		public static function initFunction(dis:DisplayObject,targetDis:DisplayObject):void
		{
			Object(dis).init(targetDis);
		}
		
		/**
		 * 如果用户触发显示了tip，返回当前正在显示的tip显示对象，否则返回null 
		 * @param display
		 * @return 
		 * 
		 */
		public static function getNowShowTip(display:DisplayObject):Sprite
		{
			if (nowDis == display)  {
				return nowLinkTip;
			}
			return null;
		}
		
		private static function hideAllNowTip():void
		{
			hideLinkTip();
			interOut();
		}
		
		public static function hideNowTip(isHide:Boolean = false):void
		{
			if(isHide){
				hideLinkTip();
				interOut();
			}
		}
		
        /**
         * 获得组件的宽度，此宽度并不一定等同于DisplayObject的width。是setSize的宽度
         *
         * @see #setSize()
         * @see flash.display.DisplayObject
         */
        public function get compoWidth():Number
		{
            return _compoWidth;
        }

        public static function get nowTooltipView():Xtip 
		{
            return ins;
        }
		
        /**
         * 获得组件的高度，此宽度并不一定等同于DisplayObject的height。是setSize的高度度
         *
         * @see #setSize()
         * @see flash.display.DisplayObject
         */
        public function get compoHeight():Number 
		{
            return _compoHeight;
        }

        public function alphaInInit():void
		{
            this.alpha = 0;
//            this.removeEventListener (Event.ENTER_FRAME , alphaOutFrame);
			UpdateManager.Instance.framePer.delFunc(alphaOutFrame);
//            this.addEventListener (Event.ENTER_FRAME , alphaInFrame);
			UpdateManager.Instance.framePer.regFunc(alphaInFrame);
            alphaInFrame ();
        }

        public function alphaOutInit():void
		{
//            this.removeEventListener (Event.ENTER_FRAME , alphaInFrame);
			UpdateManager.Instance.framePer.delFunc(alphaInFrame);
//            this.addEventListener (Event.ENTER_FRAME , alphaOutFrame);
			UpdateManager.Instance.framePer.regFunc(alphaOutFrame);
            alphaOutFrame ();
        }
		
        /**
         * 设置提示，接受简单String，HTML String，图像URL Request，BitmapData,库链接，DisplayObject
         */
        public function set tip(value:Object):void
		{
            _tipValue = value;
            if (_txt == null){
                _txt = new TextField ();
                _txt.multiline = true;
                _txt.wordWrap = true;
				_txt.textColor = 0xFFFFFF;
				_txt.x = paddingLeft;
				_txt.y = paddingTop;
				_txt.filters = txtFilter;
            }
			if(_txt.parent == null){
				this.addChild (_txt);
			}
            _txt.htmlText = String (value);
            _txt.setTextFormat (textFormat);
            _txt.width = maxWidth;
            _txt.width = _txt.textWidth + 5;
            _txt.height = _txt.textHeight + 5;
            _compoWidth = _txt.width + paddingLeft * 2 - 3;
            _compoHeight = _txt.height + paddingTop * 2 - 1;
			if(backgroundFilter != null){
            	skinDisplayObject.filters = backgroundFilter;
			}
            if (this.stage == null) return;
            if (this.x + _compoWidth + 3 > this.stage.stageWidth){
                this.x = this.stage.stageWidth - _compoWidth - 3;
            }
            if (this.y + _compoHeight + 3 > this.stage.stageHeight){
                this.y = this.stage.mouseY - _compoHeight - 5;
            }
            if (_bg == null) {
                _bg = ObjectFactory.getNewSprite (tipBackgroundLinkName);
				_bg.cacheAsBitmap = true;
                this.mouseChildren = false;
                this.mouseEnabled = false;
            }
			if(_bg.parent == null){
				this.addChildAt (_bg , 0);
			}
			var bgW:int = int(_compoWidth+textWidhtAdd);
			var bgH:int =  int(_compoHeight + textHeightAdd);
			if(_bg.width != bgW){
            	_bg.width = bgW;
			}
			if(_bg.height != bgH){
            	_bg.height =bgH;
			}
        }

        public function get tip():Object
		{
            return _tipValue;
        }
		
        /**
         * 获得文本框实例的引用
         */
        public function get textField():TextField
		{
            return _txt;
        }
		
        /**
         * 获得背景实例的引用
         */
        public function get skinDisplayObject():DisplayObject
		{
            return new Shape ();
        }

        private function alphaInFrame(event:Event = null):void
		{
            this.alpha += alphaIn;
            if (this.alpha >= 1){
                this.alpha = 1;
//                this.removeEventListener (Event.ENTER_FRAME , alphaInFrame);
				UpdateManager.Instance.framePer.delFunc(alphaInFrame);
            }
        }
		
		public function dispose():void
		{
			if(_bg){
				_bg.cacheAsBitmap = false;
			}
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
		}

        private function alphaOutFrame(event:Event = null):void
		{
            this.alpha -= alphaOut;
            if (this.alpha <= 0){
                this.alpha = 0;
//                this.removeEventListener (Event.ENTER_FRAME , alphaOutFrame);
				UpdateManager.Instance.framePer.delFunc(alphaOutFrame);
                if (this.parent != null){
                    this.parent.removeChild (this);
                }
				this.dispose();
            }
        }
		
		public static function showTipNow(disObj:DisplayObject):void{
			removeLinkTip(removeTarget);
			var arr:Array = getDataFromLinkTip (disObj);
			if (arr == null) return;
			nowMouseOnDis = disObj;
			var sp:Sprite = ObjectFactory.getNewSprite (String (arr[1]));
			nowLinkTip = sp;
			nowDis = disObj;
			var fun:Function = arr[2] as Function;
			var oldArgs:Array = arr[3] as Array;
			var callArgs:Array = oldArgs.slice (0);
			if (fun != null){
				callArgs.unshift (arr[0]);
				callArgs.unshift (sp);
				fun.apply (null , callArgs);
			}
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			UI.topSprite.addChild (sp);
			UI.stage.addEventListener (MouseEvent.MOUSE_MOVE , followLinkTip);
			followLinkTip ();
		}

        public static function showLinkTip(event:MouseEvent):void 
		{
			removeLinkTip(removeTarget);
            var arr:Array = getDataFromLinkTip (event.currentTarget as DisplayObject);
            if (arr == null) return;
			nowMouseOnDis = event.currentTarget;
            var sp:Sprite = ObjectFactory.getNewSprite (String (arr[1]));
            nowLinkTip = sp;
            nowDis = event.currentTarget as DisplayObject;
            var fun:Function = arr[2] as Function;
            var oldArgs:Array = arr[3] as Array;
            var callArgs:Array = oldArgs.slice (0);
            if (fun != null){
                callArgs.unshift (arr[0]);
                callArgs.unshift (sp);
                fun.apply (null , callArgs);
            }
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
            UI.topSprite.addChild (sp);
			UI.stage.addEventListener (MouseEvent.MOUSE_MOVE , followLinkTip);
            followLinkTip ();
        }

        private static function hideLinkTip(event:MouseEvent=null):void
		{
			nowMouseOnDis = null;
//			if(event != null){
//			trace("hideLinkTip",event.relatedObject);
//			}
            if (nowLinkTip != null && nowLinkTip.parent != null) {
				removeTarget = nowLinkTip;
				if(removeLinkTipTimeOut>0){
               		 setTimeout(removeLinkTip,removeLinkTipTimeOut,nowLinkTip);
				}else{
					removeLinkTip(nowLinkTip);
				}
                nowLinkTip = null;
            }
            nowDis = null;
			UI.stage.removeEventListener (MouseEvent.MOUSE_MOVE , followLinkTip);
        }
		
		private static function removeLinkTip(targetSP:Sprite):void
		{
			if(targetSP && targetSP.parent){
				targetSP.parent.removeChild (targetSP);
			}else{
				return;
			}
			if(targetSP.hasOwnProperty("dispose")){
				Object(targetSP).dispose();
			}
			while(targetSP.numChildren>0){
				targetSP.removeChildAt(0);
			}
		}

        private static function followLinkTip(event:MouseEvent = null):void
		{
			if(nowLinkTip==null)	return;
			nowLinkTip.x = stage.mouseX + spaceFollowX;
			nowLinkTip.y = stage.mouseY + spaceFollowY;
			if (nowLinkTip.x + nowLinkTip.width + spaceLeft > stage.stageWidth){
				nowLinkTip.x = stage.mouseX - nowLinkTip.width - mouseLeftLess;
			}
			if (nowLinkTip.y + nowLinkTip.height + spaceTop > stage.stageHeight){
				nowLinkTip.y = stage.stageHeight - nowLinkTip.height - spaceTop;
			}
			if(nowLinkTip.x< 0) {
				nowLinkTip.x = 0;
			}
			if(nowLinkTip.y<0) {
				nowLinkTip.y = 0;
			}
			if (isMouseMoveUpdateAfterEvent == true && event != null){
				event.updateAfterEvent ();
			}
        }
		
		private static function updateXtipY(event:MouseEvent=null):void
		{
			ins.x = int(stage.mouseX+spaceFollowX);
			ins.y = int(stage.mouseY + spaceFollowY);
			if (ins.x + ins.compoWidth + spaceLeft > stage.stageWidth){
				ins.x = stage.stageWidth - ins.compoWidth - spaceLeft;
			}
			if (ins.y + ins.compoHeight + spaceTop > stage.stageHeight){
				ins.y = stage.mouseY - ins.compoHeight - spaceTop;
			}
			if(isMouseMoveUpdateAfterEvent == true && event != null){
				event.updateAfterEvent();
			}
		}

        private static function getDataFromLinkTip(display:DisplayObject):Array
		{
            for (var i:int = 0 ; i < linkTips.length ; i++){
                if (linkTips[i][0] == display){
                    return linkTips[i];
                }
            }
            return null;
        }
		
        /**
         * 设置提示的延迟，单位：毫秒（提示将在此时间后才开始显示，如果在此时间内移开，则不显示提示，对于一组附近的按钮，如果第一个提示已经显示，则后面的提示直接显示，移开这组按钮将重新计时）
         */
        public static function set showDelay(value:uint):void
		{
            timer.delay = value;
        }

        public static function get showDelay():uint
		{
            return uint (timer.delay);
        }
		
        /**
         * 设置ToolTip的全局样式，影响所有ToolTip实例，样式说明参见Styles
         */
        public static function setDefaultToolTipStyle(ellipse:Number , backgroundTopColor:uint , backgroundBottomColor:uint , backgroundTopAlpha:Number , 
													  					backgroundBottomAlpha:Number , borderColor:uint , borderAlpha:Number):void
		{
            defaultToolTipStyle = new Object ();
            defaultToolTipStyle.ellipse = ellipse;
            defaultToolTipStyle.backgroundTopColor = backgroundTopColor;
            defaultToolTipStyle.backgroundBottomColor = backgroundBottomColor;
            defaultToolTipStyle.backgroundTopAlpha = backgroundTopAlpha;
            defaultToolTipStyle.backgroundBottomAlpha = backgroundBottomAlpha;
            defaultToolTipStyle.borderColor = borderColor;
            defaultToolTipStyle.borderAlpha = borderAlpha;
        }

        public static function get toolTipInstance():Xtip
		{
            return ins;
        }
		
        /**
         * 立即在舞台上显示一个ToolTip实例
         */
        public static function showAToolTipOnStage(stage:Stage , tip:Object):Xtip
		{
            Xtip.stage = stage;
            Xtip.tip = tip;
            showTip ();
            return ins;
        }

        private static function showTip(event:TimerEvent = null):void
		{
            timer.stop ();
            if (ins != null){
                interOut ();
            }
			if(ins == null){
          	  ins = new Xtip ();
			}
            stage.addChild (ins);
            ins.x = stage.mouseX;
            ins.y = stage.mouseY + 20;
            ins.tip = tip;
            isOn = true;
            if (isFollowMouse == true){
                stage.addEventListener (MouseEvent.MOUSE_MOVE , updateXtipY);
            }
            ins.alphaInInit ();
			updateXtipY();
        }

        private static function interOver(event:MouseEvent):void
		{
            var tar:InteractiveObject = event.currentTarget as InteractiveObject;
            var index:uint = 0;
			nowMouseOnDis = event.currentTarget;
            for (var i:Object in tips){
                if (tips[i][0] == tar){
                    index = uint (i);
                    break;
                }
            }
            target = tips[index][0] as InteractiveObject;
            tip = tips[index][1];
            if (isOn == true){
                showTip ();
                if (timer.delay > 30){
                    ins.visible = false;
                    setTimeout (updateXtipY , 300 , ins);
                }else{
					updateXtipY ();
                }
            } else{
                if (timer.delay > 30){
                    timer.start ();
                }else{
                    isOn = true;
                    showTip ();
                }
            }
            clearTimeout (timeOutID);
        }

        public static function interOut(event:Event = null):void
		{
            timer.reset ();
            if (ins != null){
                ins.alphaOutInit ();
                stage.removeEventListener (MouseEvent.MOUSE_MOVE , updateXtipY);
            }
            if (timer.delay > 30){
                timeOutID = setTimeout (offIsOnLater , 500);
            }
			if(ins == null) return;
			if (ins.parent != null){
				ins.parent.removeChild (ins);
			}
			ins.dispose();
        }

        private static function offIsOnLater():void
		{
            isOn = false;
        }
		
    }
}
